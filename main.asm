section "Header", rom0[$100]
  di
  jp    Main
  dw    $ceed,$6666,$cc0d,$000b,$0373,$0083,$000c,$000d ; Nintendo
  dw    $0008,$111f,$8889,$000e,$dccc,$6ee6,$dddd,$d999 ; logo, exact
  dw    $bbbb,$6763,$6e0e,$eccc,$dddc,$999f,$bbb9,$333e ; (required)
  db    "TITLE      CODE",$80,0,0,0 ; Title&ID, GBC?, 2 license, SGB?
  db    0,0,0,0,$33 ; cart, rom, ram, region, old license

section "V-Blank", rom0[$40]
  call LoadPalettes
  reti

section "LCD Status", rom0[$48] ; LYC=LY ($ff45=$ff44) interrupt, for now
  jp    RefreshPalette

section "Program", rom0[$150]
Main
  call  DisableLCD
  ld    a,%00000011
  ldh   [$ff],a     ; enable V-Blank and LCD STAT interrupt
  ld    a,%01000000
  ldh   [$41],a     ; enable LYC=LY interrupt
  ld    a,$03       ; interrupt at line $03
  ldh   [$45],a
  call  LoadTiles
  call  LoadMap
  call  LoadPalettes
  call  EnableLCD
  ei
.Update
  halt
  nop
  jr    .Update

LoadTiles
  ld    hl,$0800    ; TileData ROM, swap(h) = RAM up to $80ff
  ld    b,$b0       ; $n0 = n tiles
.while;b --> 0
  ld    a,[hl]
  swap  h
  ld    [hl+],a
  swap  h
  dec   b
  jr    nz,.while
  ret

LoadMap;Data
  ld    b,$14       ; $14 tiles
  ld    de,$9800    ; VRAM background map
  ld    hl,MapData
.while;b --> 0
  ld    e,l
  ld    a,[hl+]
  ld    [de],a
  dec   b
  jr    nz,.while
;LoadMapAttributes
  ld    bc,$144f    ; $14 tiles, $ff4f=VRAM Bank
  ld    de,$9800
  ld    hl,MapAttributes
  ld    a,1
  ld    [c],a       ; VRAM Bank 1
.while2;b --> 0
  ld    e,l         ; de = $98xx, hl = 07xx (256 bytes at most)
  ld    a,[hl+]
  ld    [de],a
  dec   b
  jr    nz,.while2
;Finish
  ld    a,0
  ld    [c],a       ; VRAM Bank 0
  ret

LoadPalettes
  ld    c,$68
  ld    a,%10000000
  ld    [c],a
  inc   c
  ld    hl,PaletteData    ; ROM
  ld    b,$18;bytes, 2 per color = 12 colors = 3 palettes
.while;b --> 0
  ld    a,[hl+]
  ld    [c],a
  dec   b
  jr    nz,.while
  ret

RefreshPalette
  ld    c,$68
  ld    a,%10001100
  ld    [c],a
  inc   c
  ld    hl,$ff41
  xor   a
  ld    de,%0001100010100110
.wait
  bit   1,[hl]
  jr    nz,.wait
  ld    a,e
  ld    [c],a
  ld    a,d
  ld    [c],a
  reti

DisableLCD
  ld    bc,$9044
  ld    hl,$ff40    ; LCD control
.wait;while LY < 144 (not in vblank)
  ld    a,[c]       ; a = LY
  cp    b           ; LY < 144?
  jr    c,.wait
  res   7,[hl]
  ret

EnableLCD
  ld    hl,$ff40
  set   7,[hl]
  ret

section "Palette data", rom0[$500]
PaletteData
        ; BBBBBGGGGGRRRRR
  dw    %0100101001010000 ; #809090
  dw    %0011110111101110 ; #707878
  dw    %0011110110001101 ; #686078
  dw    %0010110100101010 ; #504858

  dw    %0010000011100111 ; #383840
  dw    %0010100100001000 ; #404050
  dw    %0011110110001101 ; #686078
  dw    %0010110100101010 ; #504858

  dw    %0010000011100111 ; #383840
  dw    %0001010010000101 ; #282028
  dw    %0001100010100110 ; #302830
  dw    %0010110101100111 ; #385858

section "Map data", rom0[$600]
MapData
        ;0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19
  db    $00,$01,$02,$03,$04,$05,$06,$07,$07,$07,$07,$08,$08,$07,$07,$07,$07,$07,$09,$0a

section "Map attributes", rom0[$700]
MapAttributes
  db    %00000000,%00000000,%00000000,%00000001; 0- 3
  db    %00000001,%00000010,%00000010,%00000010; 4- 7
  db    %00000010,%00000010,%00000010,%00000010; 8-11
  db    %00100010,%00000010,%00000010,%00000010;12-15
  db    %00000010,%00000010,%00000010,%00000010;16-19

section "Tile data", rom0[$800]
TileData
  dw    `00000000   ; 0
  dw    `00000000
  dw    `00000000
  dw    `00000000
  dw    `00000000
  dw    `10000000
  dw    `11000001
  dw    `00011001

  dw    `00011111   ; 1
  dw    `00011111
  dw    `00111111
  dw    `00111111
  dw    `11111111
  dw    `11111112
  dw    `11111112
  dw    `11111112

  dw    `12222222   ; 2
  dw    `12222222
  dw    `22222222
  dw    `22222222
  dw    `22222223
  dw    `22222223
  dw    `22332233
  dw    `23333333

  dw    `23311111   ; 3
  dw    `23311133
  dw    `33311133
  dw    `33111333
  dw    `33111333
  dw    `31113333
  dw    `30013333
  dw    `00013333

  dw    `11100000   ; 4
  dw    `11100000
  dw    `11000000
  dw    `11000000
  dw    `33002000
  dw    `33002200
  dw    `33002200
  dw    `30002200

  dw    `00000222   ; 5
  dw    `00000222
  dw    `00002222
  dw    `00002221
  dw    `00022211
  dw    `00022211
  dw    `00022111
  dw    `00221111

  dw    `22111111   ; 6
  dw    `11111111
  dw    `11111111
  dw    `11222111
  dw    `11222111
  dw    `12221111
  dw    `12221111
  dw    `22221111

  dw    `11111111   ; 7
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111

  dw    `11111111   ; 8, 8h
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111133

  dw    `11111112   ; 9
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111

  dw    `22222222   ; a
  dw    `22222222
  dw    `12222222
  dw    `11122222
  dw    `12122222
  dw    `12222221
  dw    `12222211
  dw    `11222111

; vim:syn=rgbasm
