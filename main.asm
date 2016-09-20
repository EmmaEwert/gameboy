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
  call  LoadPalettes
  ei
.Update
  halt
  jp    .Update

LoadTiles
  ld    hl,$0800    ; ROM, swap(h) = RAM up to $80ff
  ld    b,$20       ; $n0 = n tiles
.while;b --> 0
  ld    a,[hl]
  swap  h
  ld    [hl+],a
  swap  h
  dec   b
  jp    nz,.while
  ret

LoadPalettes
  ld    c,$68
  ld    a,%10000000
  ld    [c],a
  inc   c
  ld    hl,$0700    ; ROM
  ld    b,$08;bytes, 2 per color = 4 colors
.while;b --> 0
  ld    a,[hl+]
  ld    [c],a
  dec   b
  jp    nz,.while
  ret

section "Palette data", rom0[$700]
        ; BBBBBGGGGGRRRRR
  dw    %0010000011100111 ; #383840
  dw    %0010100100001000 ; #404050
  dw    %0011110110001101 ; #686078
  dw    %0010110100101010 ; #504858

  dw    %0100101001010000 ; #809090
  dw    %0011110111101110 ; #707878
  dw    %0011110110001101 ; #686078
  dw    %0010110100101010 ; #504858

section "Tile data", rom0[$800]
  dw    `23311111
  dw    `23311133
  dw    `33311133
  dw    `33111333
  dw    `33111333
  dw    `31113333
  dw    `30013333
  dw    `00013333

  dw    `11100000
  dw    `11100000
  dw    `11000000
  dw    `11000000
  dw    `33002000
  dw    `33002200
  dw    `33002200
  dw    `30002200

; vim:syn=rgbasm
