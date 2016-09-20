section "Header", rom0[$100]
  nop
  jp    Main
  dw    $ceed,$6666,$cc0d,$000b,$0373,$0083,$000c,$000d ; Nintendo
  dw    $0008,$111f,$8889,$000e,$dccc,$6ee6,$dddd,$d999 ; logo, exact
  dw    $bbbb,$6763,$6e0e,$eccc,$dddc,$999f,$bbb9,$333e ; (required)
  db    "TITLE      CODE",$80,0,0,0 ; Title&ID, GBC?, 2 license, SGB?
  db    0,0,0,0,$33 ; cart, rom, ram, region, old license

section "LCD Status", rom0[$48]
  reti

section "Program", rom0[$150]
Main
  ld    a,%00000010
  ldh   [$ff],a     ; enable LCD STAT interrupt
  ld    a,%00001000
  ldh   [$41],a     ; enable H-Blank interrupt
  call  LoadTiles
  ei
.Update
  halt
  jp    .Update

LoadTiles
  ld    hl,$0800    ; ROM, swap(h) = RAM up to $80ff
  ld    b,$10       ; $n0 = n tiles
.while;b --> 0
  ld    a,[hl]
  swap  h
  ldi   [hl],a
  swap  h
  dec   b
  jp    nz,.while
  ret

section "Tile data", rom0[$800]
  dw    `23311111
  dw    `23311133
  dw    `33311133
  dw    `33111333
  dw    `33111333
  dw    `31113333
  dw    `30013333
  dw    `00013333

; vim:syn=rgbasm
