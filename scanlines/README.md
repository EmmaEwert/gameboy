# Scanlines

Gameboy max colour depth example.

## Goals

Render the maximum number of colours on screen.

## Official

The maximum colour count is based on 8 background palettes of 4 colours each,
plus 8 sprite palettes of 3 colours each. The 4th colour in each sprite palette
is fully transparent.

* 8 background palettes × 4 colours = 32 colours
* 8 sprite palettes × 4 colours = 24 colours
* 32 background colours + 24 sprite colours = 56 colours

The colour components are 5 bits each for red, green, and blue, making the
possible colour count 2⁵ = 32'768.

## Determining max colour count

Each scanline rendering except `$00` takes 456 cycles, or 228 cycles at CGB
double speed.

The LCD modes and interrupts for each scanline are distributed on these 456
cycles as shown in this table:

|Mode      |Mode 2  |Mode 3|Mode 0 |
|----------|--------|------|-------|
|Cycles    |   80   |  176 |  200  |
|Interrupts|OAM, LYC|      |H-Blank|

During *Mode 2*, OAM RAM is inaccessible. During *Mode 3*, OAM RAM, VRAM, and
palettes are inaccessible.

If we start accessing the LCD exactly when Mode 0 starts, we have 200 cycles of
OAM+VRAM+palette access, followed by 80 cycles of VRAM+palette access.

A single palette colour, assigned with immediate load instructions, takes 12
cycles at CGB double speed, assuming *[$ff68] BG palette index* has already been
set up:

```asm
ld    [hl], %gggrrrrr ;6 cycles
ld    [hl], %-bbbbbgg ;6 cycles
```

280 cycles ÷ 12 = 23 colour assignments, with 4 cycles remaining.

The remaining 9 background colours and 24 sprite colours can still be used, but
they can't be changed while rendering.

With 144 scanlines, this gives a naive max colour count of:

23 × 144 + 9 + 24 = 3'345 colours on screen.

The *[$ff68] BG palette index* register must be set up before assigning colours,
as well. This can be done without VRAM access.

Because the cycles available during each mode vary slightly over time, it only
seems effectively possible to change 22 palette entries per scanline.

A few colour assignments can use pre-initialised registers a, b, c, d and e, as
well. The `ld [hl], r` instruction takes 4 cycles instead of 6, so this might
free up enough cycles for an additional colour assignment, especially if the
colours stored in registers are used more than once.

For example, if all colour changes used preset registers, it would be possible
to change 33 colours per scanline.

Considering the Game Boy Color has a 15 bit colour palette, and assuming we can
use registers a, b, c, d and e for both the high byte and the low byte of the
colour, this gives us 2 colour bytes, using any of 5 distinct register bytes:

25 few-cycles colour combinations that we have moderate control over, with
enough free cycles left for another 5 colours that are a combination of any
immediate byte and a register value, as well as one extra pure immediate colour,
and an immediate `gggrrrrr` part of one more colour.

Furthermore, registers h and l implicitly contain the values `%11111111` and
`%01101001`, respectively, from the *[$ff69] BG palette data* reigster address.

Not using h or l, this gives us 31½ new, somewhat controllable colours per
scanline: 4'536 colours on screen.

The Game Boy Color mixes the current and last frame, though. By changing the
colours displayed each frame, this can drastically increase the number of
colours on screen.

The current code displays 18'986 colours on screen. Properly used frame mixing
should make it possible to increase this colour count even further.
