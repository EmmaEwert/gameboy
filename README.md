# Game Boy prototypes

A collection of prototype programs for the Game Boy, mostly just toying around.

## Daycycle

![Pallet Town, through day and night][daycycle]

Implementing a day/night cycle using a rather large palette table.

## Den

Initial work on per-scanline palette changes.

## Lapras

Initial work on high-colour Lapras tiles that degrade to monochrome gameboys
gracefully. Doesn't actually work on those yet.

## Scanlines

Testing throughput of distinct colours.

![18986 distinct but noisy colours][scanlines]

## Squish

Squishing the top lines, while trying to retain some recognisability by
frame mixing. *Kinda* 256 pixels in height.

## Transparency

Text box overlaying background.

![Chat bubble transparent on top of Pallet Town][transparency]

## Weather

Weather effect using semitransparent window.

![Circling over rainy Pallet Town][weather]

## Documentation (ref.rgbasm)

Developer's notes, describes register usage and various other information.



# Tools

## Colors

Count distinct colours in png image.

## Palette

Given three bytes (R, G and B) in hex, outputs various rgbasm instructions with
these colours, in the GBC 15-bit format.



[daycycle]: http://media.tumblr.com/4ed30c435b4146dc97c78fa826dc45b9/tumblr_inline_ofkjljbU4t1seqeh7_500.gif
[scanlines]: http://66.media.tumblr.com/e5d708f2f25f1b2972ad6b0361a7190f/tumblr_inline_ofa58tqSS01seqeh7_500.png
[transparency]: http://66.media.tumblr.com/068f7f6be91e869d83ad025c92c3cea2/tumblr_inline_ofbfyvdpZM1seqeh7_500.png
[weather]: http://media.tumblr.com/3d51daa4dd19effac46bc1958583039e/tumblr_inline_ofh89xDzIO1seqeh7_500.gif
