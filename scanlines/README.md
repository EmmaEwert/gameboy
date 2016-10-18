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

A few colour assignments can use pre-initialised registers a, b, c, d and e, as
well. The `ld [hl], r` instruction takes 4 cycles instead of 6, so this might
free up enough cycles for an additional colour assignment.

However, the *[$ff68] BG palette index* register must be set up before assigning
colours, as well.

The fastest way to do this seems to be preloading the `a` register with the
first colour index, the `hl` register with the *BG palette index* register
address, and using the following instruction once VRAM is accessible:

```asm
ld    [hl+], a  ;4 cycles
```

This sets the first colour index, *and* loads the `hl` register with the
*[$ff69] BG palette data* register address.


The Game Boy Color mixes the current and last frame, though. By changing the
colours displayed each frame, this can drastically increase the number of
colours on screen.
