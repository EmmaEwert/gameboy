# Dragon's Den

Gameboy high color example.

## Register usage

| Register  | Usage                    |
|-----------|--------------------------|
| a         | accumulator              |
| b         | counter                  |
| c,d,e,h,l | auxiliary                |
| bc        | counter                  |
| de        | dst address              |
| hl        | src address, accumulator |
| sp        | desperate times          |

## Palette

Given a 24 bit color `RGB`, a 15 bit color `rgb` can be derived:

`rgb = R / 8 + (G / 8 + B / 8 * $20) * $20`

## Topics to look into

Currently, nothing is transferred through DMA.

Time-critical code that relies on dynamic data might be copied to RAM
with the dynamic parts hardcoded into the instructions. The code can
then be executed directly from RAM. For example, palette changes during
H-Blank.

Palettes can apparently be written to in all video modes except mode 3.

[Circular map cutoff](http://www.coranac.com/tonc/text/dma.htm#sec-demo)
might be possible by rendering map into a window, and resizing this
window during each H-Blank.

If there is leftover tile space, cycles, and palettes, the static image
might be panned, allowing 256×144 pixels of the original 256×160 to be
displayed.

The fact that the screen is somewhat interlaced (last and current frame
are mixed) might be taken advantage of.

## Mid-frame palette swap

Palettes can be written to in modes 0, 1, and 2 (H-Blank, V-Blank and
OAM read, respectively). H-Blank and OAM read happen after each
scanline, and last for 201-207 cycles and 77-83 cycles, respectively.

VRAM read (mode 3) lasts for 169-175 cycles, and can be used to prepare
for the palette swap code to be executed during mode 0 and 2.

V-Blank can be used to prepare the initial and per-frame states for
rendering.

A complete scanline cycle takes 456 cycles, so H-Blank + OAM read (where
palettes can be written to) continuously last **281-287 cycles**.

## Gotchas

The `halt` instruction repeats the next byte twice. Avoid by using `nop`
or an instruction that is non-destructive if its first byte is repeated.

Setting tile attributes directly after setting map tiles can lead to
errors, mostly in double speed mode. Avoid this by having a `nop`
instruction between them, or by setting tile attributes before map
tiles.

Turning off LCD outside V-Blank is rumoured to potentially cause
physical damage to the GBC screen circuitry over time. It won't always
work on the Super Gameboy, either.
