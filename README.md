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
