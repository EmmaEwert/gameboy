# Transparency

Game Boy transparency example.

## Goals

Render the Game Boy window, with transparency, supporting arbitrary scrolling.

Render any rectangular section, with transparency.

Render arbitrary sections, with transparency.

## VRAM Tile Data layout

|Use                        |Bank 0 |Bank 1 |
|---------------------------|-------|-------|
|Sprites, Background        |Map    |Sprites|
|Sprites, Background, Window|Map    |Text   |
|Background, Window         |Window |Misc.  |

## Window sections

It might be possible to properly display subsections of the Game Boy window by
disabling it for all scanlines that don't need it.

This would enable any window Y cross-section, but since the entire window is
rendered, such windows must be on the right side of the display.
