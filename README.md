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

The Gameboy Color supports 384 tiles, enough to cover 81.25 % of the
32×32 background map. The remaining 18.75 % (192 tiles) means the map
can be completely covered when each row reuses 6 tiles on average.

The display can mostly be covered in unique tiles, as it shows 360-398
tiles, depending on whether the scroll values are tile-aligned.

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

A single-color palette write time of 40 cycles, this allows 7 palette
color changes per scanline (280 cycles), with 1-7 cycles to spare
before VRAM becomes inaccessible.

```asm
; c = $68, hl = $ff69
ld a,index      ; 8 cycles, hardcoded index
ld [c],a        ; 8 cycles
ld [hl],colorLO ; 12 cycles, hardcoded colorLO
ld [hl],colorHI ; 12 cycles, hardcoded colorHI
                ;=40 cycles
```

VRAM access doesn't need to be available for `ld a,index` of the first
color.

Additionally, the first two instructions can be skipped for consecutive
colors. As well, if registers `b`, `d`, `e`, and `f` contain indices set
before VRAM access, the 4 cycle `ld a,r` instructions can be used
instead of the 8 cycle `ld a,index` for the second through fifth index.

During VRAM read, the next LYC can be set from hardcoded RAM with
`ld [bc],lyc`, assuming `bc = $ff45`.

### Palette swap data (tentative)

Assuming every scanline applies the maximum number of palette swaps, the
data does not need to include swap count or line number.

Of course, the redundant data need not exist in ROM. Alternatively, a
single byte per useful scanline in ROM might suffice for determining how
many redundant swap operations should be appended when the data is copied
to RAM.

| Data    | Bits | Description                      |
|---------|------|----------------------------------|
| swaps   | 0-2  | 0-7 color changes                |
| next    | 3-7  | (0-31)+1 lines until next swap   |
| index0  | 0-5  | palette 0-7, color 0-3, byte 0-1 |
|         | 7    | always 1 (write two color bytes) |
| color0  | 0-14 | 14 BBBBBGGGGGRRRRR 0             |
| ‥       |      |                                  |
| index6  | 0-5  | palette 0-7, color 0-3, byte 0-1 |
|         | 7    | always 1 (write two color bytes) |
| color6  | 0-14 | 14 BBBBBGGGGGRRRRR 0             |

If this ends up taking too much ROM space, the data can potentially be
run length encoded.

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
