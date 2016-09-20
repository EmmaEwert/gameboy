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

```
rgb = R × $100
    + G % 8 × $2000
    + G / 8
    + B × 4
```

Note: The green component is split between bits `14-12` and `1-0`,
hence the convoluted expression.
