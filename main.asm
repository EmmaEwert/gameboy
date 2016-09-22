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
  ld    hl,$ff51    ; $ff51-$ff55: VRAM DMA transfer
  ld    bc,TileData ; Tiledata ROM
  ld    de,$8000    ; Tiledata RAM
  ld    [hl],b
  inc   l;$52
  ld    [hl],c
  inc   l;$53
  ld    [hl],d
  inc   l;$54
  ld    [hl],e
  inc   l;$55
  ld    a,$12       ; $130 bytes / $10 - 1 = $12
  ld    [hl],a      ; start DMA transfer
  ret

LoadMap;Attributes, then Indices
  ld    hl,$ff4f    ; $ff4f=VRAM Bank
  ld    bc,MapAttributes
  ld    de,$9800
  ld    a,1
  ld    [hl+],a     ; VRAM Bank 1
  inc   l           ; $ff51-$ff54: DMA srcHI, srcLO, dstHI, dstLO
  ld    [hl],b
  inc   l;$52
  ld    [hl],c
  inc   l;$53
  ld    [hl],d
  inc   l;$54
  ld    [hl],e
  inc   l;$55       ; $ff55.7 = mode (0: general purpose, 1: H-Blank)
  ld    a,3         ; $20 + $14 attributes, ceil($34,$10) = $40, $40 / $10 - 1 = 3
  ld    [hl],a      ; $ff55.0-6 = bytes / $10 - 1, write = start DMA transfer
  ld    bc,MapIndices
  xor   a
  ld    [$ff4f],a   ; VRAM Bank 0
  ld    l,$51
  ld    [hl],b
  inc   l;$51
  ld    [hl],c
  inc   l;$52
  ld    [hl],d
  inc   l;$53
  ld    [hl],e
  inc   l;$55
  ld    a,3
  ld    [hl],a      ; start DMA transfer
  ret

LoadPalettes
  ld    c,$68
  ld    a,%10000000
  ld    [c],a
  inc   c
  ld    hl,PaletteData    ; ROM
  ld    b,$28;bytes, 2 per color = 20 colors = 5 palettes
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

section "Palette data", romx,bank[1]
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

  dw    %0100101001010000 ; #809090
  dw    %0011110111101110 ; #707878
  dw    %0011110110001101 ; #686078
  dw    %0010110100101010 ; #504858

  dw    %0010110101100111 ; #385858
  dw    %0001010010000101 ; #282028
  dw    %0010010100100110 ; #304848
  dw    %0001100011000100 ; #203030

  dw    0,0,0,0 ; Align to $10 boundary for DMA transfer

section "Map tile indices", romx,bank[1]
MapIndices
        ;0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19
  db    $00,$01,$02,$03,$04,$05,$06,$07,$07,$07,$07,$08,$08,$07,$07,$07,$07,$07,$09,$0a;$0a>
  dw    0,0,0,0,0,0
  db    $0b,$0c,$0d,$0e,$0f,$10,$08,$07,$07,$07,$07,$11,$11,$07,$07,$07,$07,$07,$07,$12;$12>
  dw    0,0,0,0,0,0 ; Align to $10 boundary for DMA transfer

section "Map tile attributes", romx,bank[1]
MapAttributes
                    ; row 0
  db    %00000000,%00000000,%00000000,%00000001; 0- 3
  db    %00000001,%00000010,%00000010,%00000010; 4- 7
  db    %00000010,%00000010,%00000010,%00000010; 8-11
  db    %00100010,%00000010,%00000010,%00000010;12-15
  db    %00000010,%00000010,%00000010,%00000010;16-19
  dw    0,0,0,0,0,0 ; row 1
  db    %00000000,%00000011,%00000001,%00000001; 0- 3
  db    %00000010,%00000010,%01100010,%00000010; 4- 7
  db    %00000010,%00000010,%00000010,%00000100; 8-11
  db    %00100100,%00000010,%00000010,%00000010;12-15
  db    %00000010,%00000010,%00000010,%00000010;16-19
  dw    0,0,0,0,0,0 ; row 2, align to $10 boundary for DMA transfer

section "Tile data", romx,bank[1]
TileData
  dw    `00000000   ; 00
  dw    `00000000
  dw    `00000000
  dw    `00000000
  dw    `00000000
  dw    `10000000
  dw    `11000001
  dw    `00011001

  dw    `00011111   ; 01
  dw    `00011111
  dw    `00111111
  dw    `00111111
  dw    `11111111
  dw    `11111112
  dw    `11111112
  dw    `11111112

  dw    `12222222   ; 02
  dw    `12222222
  dw    `22222222
  dw    `22222222
  dw    `22222223
  dw    `22222223
  dw    `22332233
  dw    `23333333

  dw    `23311111   ; 03
  dw    `23311133
  dw    `33311133
  dw    `33111333
  dw    `33111333
  dw    `31113333
  dw    `30013333
  dw    `00013333

  dw    `11100000   ; 04
  dw    `11100000
  dw    `11000000
  dw    `11000000
  dw    `33002000
  dw    `33002200
  dw    `33002200
  dw    `30002200

  dw    `00000222   ; 05
  dw    `00000222
  dw    `00002222
  dw    `00002221
  dw    `00022211
  dw    `00022211
  dw    `00022111
  dw    `00221111

  dw    `22111111   ; 06
  dw    `11111111
  dw    `11111111
  dw    `11222111
  dw    `11222111
  dw    `12221111
  dw    `12221111
  dw    `22221111

  dw    `11111111   ; 07, 17
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111

  dw    `11111111   ; 08, 08h, 18hv
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111133

  dw    `11111112   ; 09
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111

  dw    `22222222   ; 0a
  dw    `22222222
  dw    `12222222
  dw    `11122222
  dw    `12122222
  dw    `12222221
  dw    `12222211
  dw    `11222111

  dw    `00001111   ; 10
  dw    `00001111
  dw    `00000111
  dw    `10000001
  dw    `10000001
  dw    `21100000
  dw    `22100000
  dw    `32100000

  dw    `11111122   ; 11
  dw    `11111222
  dw    `11111222
  dw    `11112223
  dw    `11122223
  dw    `00122233
  dw    `00022233
  dw    `00022333

  dw    `23313310   ; 12
  dw    `23111100
  dw    `33111100
  dw    `33111000
  dw    `11111000
  dw    `11111000
  dw    `11111111
  dw    `11111111

  dw    `00013333   ; 13
  dw    `00011133
  dw    `00011133
  dw    `00000111
  dw    `01000111
  dw    `11000111
  dw    `10000111
  dw    `00000011

  dw    `20003300   ; 14
  dw    `20003330
  dw    `00003330
  dw    `00033133
  dw    `00033113
  dw    `00033111
  dw    `00033111
  dw    `00033111

  dw    `03331111   ; 15
  dw    `03311111
  dw    `03311111
  dw    `33311111
  dw    `33311111
  dw    `33111111
  dw    `33111111
  dw    `11111111

  dw    `11111000   ; 16, 16h
  dw    `11111002
  dw    `11111022
  dw    `11110022
  dw    `11110222
  dw    `11100233
  dw    `11102233
  dw    `11002333

  dw    `11111111   ; 17
  dw    `11111111
  dw    `11111111
  dw    `11111131
  dw    `11111331
  dw    `11111333
  dw    `11111333
  dw    `11113333

; vim:syn=rgbasm
