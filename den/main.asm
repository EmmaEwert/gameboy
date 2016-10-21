section "Header", rom0[$0100]
                di
                jp    Main
                ds    75

section "V-Blank", rom0[$40]
  call LoadPalettes
  reti

section "LCD Status", rom0[$48] ; LYC=LY ($ff45=$ff44) interrupt, for now
  jp    ScanlineLookup

section "Program", rom0[$150]
Main
  call  DisableLCD
  ld    a,%00000011
  ldh   [$ff],a     ; enable V-Blank and LCD STAT interrupt
  ld    a,%00001000
  ldh   [$41],a     ; enable H-Blank interrupt
  ;ld    a,%01000000
  ;ldh   [$41],a     ; enable LYC=LY interrupt
  ;ld    a,$03       ; interrupt at line $03
  ;ldh   [$45],a
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
  ld    a,$1a       ; ($1a + 1) * $10 = $1b0 bytes = $1b tiles
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
  ld    a,5         ; $20 + $20 + $14 attributes, ceil($54,$10) = $60, $60 / $10 - 1 = 5
  ld    [hl],a      ; $ff55.0-6 = bytes / $10 - 1, write = start DMA transfer
  ld    bc,MapIndices
  xor   a
  ld    [$ff4f],a   ; VRAM Bank 0
  ld    l,$51
  ld    [hl],b
  inc   l;$52
  ld    [hl],c
  inc   l;$53
  ld    [hl],d
  inc   l;$54
  ld    [hl],e
  inc   l;$55
  ld    a,5
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

ScanlineLookup
  ld    b,3;= sizeof(jp a16)
  ldh   a,[$44]     ; LY
  ld    d,0
  ld    e,a
  ld    hl,ScanlineTable
.while;b > 0
  add   de          ; hl += LY
  dec   b
  jr    nz,.while   ; hl = 3 × LY
  ld    de,$ff68    ; palette index register
  jp    hl

ScanlineTable
  ; row 0, 0-7
  jp    Scanline
  jp    Scanline
  jp    Scanline
  jp    Scanline3
  jp    Scanline
  jp    Scanline
  jp    Scanline
  jp    Scanline7
  ; row 1, 8-15
  jp    Scanline8
  jp    Scanline
  jp    Scanline
  jp    Scanline11
  jp    Scanline12
  jp    Scanline13
  jp    Scanline14
  jp    Scanline15
  ; row 2, 16-23
  jp    Scanline16
  jp    Scanline
  jp    Scanline18
  jp    Scanline19
  jp    Scanline
  jp    Scanline21
  jp    Scanline
  jp    Scanline
  rept 160-24      ; fill out remaining entries with returns
  jp    Scanline
  endr

Scanline
  reti

Scanline3
  ld    hl,$ff69        ; palette register
  ld    a,%10001100     ; palette 1, color 2, byte 0
  ld    [de],a
  ld    [hl],%10100110  ; #302830
  ld    [hl],%00011000
  ; repeat 4 above per color (or 2 above if directly next color)
  reti

Scanline7
  ld    hl,$ff69
  ld    a,%10001100     ; 1:2:0
  ld    [de],a
  ld    [hl],%10001101  ; #686078
  ld    [hl],%00111101

  ;ld    a,%10010100     ; 2:2:0
  ;ld    [de],a
  ;ld    [hl],%00101010  ; #504858
  ;ld    [hl],%00101101
  ; can't actually make it here quick enough, it seems?
  ;ld    [hl],%10100110  ; #302830
  ;ld    [hl],%00011000
  reti

Scanline8
  ld    hl,$ff69
  ld    a,%10001100     ; 1:2:0
  ld    [de],a
  ld    [hl],%01101010  ; #505868
  ld    [hl],%00110101
  reti

Scanline11
  ld    hl,$ff69
  ld    a,%10011110     ; 3:3:0
  ld    [de],a
  ld    [hl],%00101010  ; #504858
  ld    [hl],%00101101
  reti

Scanline12
  ld    hl,$ff69
  ld    a,%10011110     ; 3:3:0
  ld    [de],a
  ld    [hl],%01101010  ; #505868
  ld    [hl],%00110101
  reti

Scanline13
  ld    hl,$ff69
  ld    a,%10011110     ; 3:3:0
  ld    [de],a
  ld    [hl],%00101010  ; #504858
  ld    [hl],%00101101
  reti

Scanline14
  ld    hl,$ff69
  ld    a,%10000110     ; 0:3:0
  ld    [de],a
  ld    [hl],%01101010  ; #505868
  ld    [hl],%00110101
  reti

Scanline15
  ld    hl,$ff69
  ld    a,%10010110     ; 2:3:0
  ld    [de],a
  ld    [hl],%00001000  ; #404050
  ld    [hl],%00101001

Scanline16
  ld    hl,$ff69
  ld    a,%10000010     ; 0:1:0
  ld    [de],a
  ld    [hl],%00001000  ; #404050
  ld    [hl],%00101001

  ld    hl,$ff69
  ld    a,%10011010     ; 3:1:0
  ld    [de],a
  ld    [hl],%01101010  ; #505868
  ld    [hl],%00110101
  reti

Scanline18
  ld    hl,$ff69
  ld    a,%10000100     ; 0:2:0
  ld    [de],a
  ld    [hl],%11101110  ; #707878
  ld    [hl],%00111101

  ld    a,%10011010     ; 3:1:0
  ld    [de],a
  ld    [hl],%11101110  ; #707878
  ld    [hl],%00111101
  reti

Scanline19
  ld    hl,$ff69
  ld    a,%10000000     ; 0:0:0
  ld    [de],a
  ld    [hl],%11100111  ; #383840
  ld    [hl],%00100000

  ld    a,%10011000     ; 3:0:0
  ld    [de],a
  ld    [hl],%00001000  ; #404050
  ld    [hl],%00101001
  reti

Scanline21
  ld    hl,$ff69
  ld    a,%10000010     ; 0:1:0
  ld    [de],a
  ld    [hl],%01010000  ; #809090
  ld    [hl],%01001010

  ld    a,%10000110     ; 0:3:0
  ld    [de],a
  ld    [hl],%00101010  ; #504858
  ld    [hl],%00101101
  reti

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
  dw    %0010110100101010 ; #504858

  dw    %0100101001010000 ; #809090
  dw    %0011110111101110 ; #707878
  dw    %0011110110001101 ; #686078
  dw    %0011010101101010 ; #505868

  dw    %0010010100100110 ; #304848
  dw    %0001010010000101 ; #282028
  dw    %0010110101100111 ; #385858
  dw    %0001100011000100 ; #203030

  dw    0,0,0,0 ; Align to $10 boundary for DMA transfer

section "Map tile indices", romx,bank[1]
MapIndices
        ;0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19
  db    $00,$01,$02,$03,$04,$05,$06,$07,$07,$07,$07,$08,$08,$07,$07,$07,$07,$07,$09,$0a;$0a>
  dw    0,0,0,0,0,0
  db    $0b,$0c,$0d,$0e,$0f,$10,$08,$07,$07,$07,$07,$11,$11,$07,$07,$07,$07,$07,$07,$12;$12>
  dw    0,0,0,0,0,0
  db    $13,$14,$15,$16,$17,$10,$08,$07,$07,$07,$18,$19,$19,$18,$07,$07,$07,$07,$07,$1a;$1a>
  dw    0,0,0,0,0,0 ; Align to $10 boundary for DMA transfer

section "Map tile attributes", romx,bank[1]
MapAttributes;bits: 7 BG-to-OAM, 6 v-flip, 5 h-flip, 3 VRAM bank number, 2-0 palette
                    ; row 0
  db    %00000000,%00000000,%00000000,%00000001; 0- 3
  db    %00000001,%00000010,%00000010,%00000010; 4- 7
  db    %00000010,%00000010,%00000010,%00000100; 8-11
  db    %00100100,%00000010,%00000010,%00000010;12-15
  db    %00000010,%00000010,%00000010,%00000010;16-19
  dw    0,0,0,0,0,0 ; row 1
  db    %00000000,%00000011,%00000001,%00000001; 0- 3
  db    %00000010,%00000010,%01100010,%00000010; 4- 7
  db    %00000010,%00000010,%00000010,%00000100; 8-11
  db    %00100100,%00000010,%00000010,%00000010;12-15
  db    %00000010,%00000010,%00000010,%00000010;16-19
  dw    0,0,0,0,0,0 ; row 2
  db    %00000000,%00000011,%00000010,%00000010; 0- 3
  db    %00000010,%00000010,%01100010,%00000010; 4- 7
  db    %00000010,%00000010,%00000100,%00000100; 8-11
  db    %00100100,%00100100,%00000010,%00000010;12-15
  db    %00000010,%00000010,%00000010,%00000010;16-19
  dw    0,0,0,0,0,0 ; row 3, align to $10 boundary for DMA transfer

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

  dw    `11111111   ; 07, 17, 27
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
  dw    `11111122

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
  dw    `00122233   ; actually 00122234
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

  dw    `30002200   ; 14
  dw    `30002220
  dw    `00002220
  dw    `00022122
  dw    `00022112
  dw    `00022111
  dw    `00022111
  dw    `00022111

  dw    `02221111   ; 15
  dw    `02211111
  dw    `02211111
  dw    `22211111
  dw    `22211111
  dw    `22111111
  dw    `22111111
  dw    `11111111

  dw    `11111222   ; 16, 16h
  dw    `11111220
  dw    `11111200
  dw    `11112200
  dw    `11112000
  dw    `11122033
  dw    `11120033
  dw    `11220333

  dw    `11111111   ; 17
  dw    `11111111
  dw    `11111111
  dw    `11111121
  dw    `11111221
  dw    `11111222
  dw    `11111222
  dw    `11112222

  dw    `33200000   ; 20
  dw    `13220000
  dw    `13322000
  dw    `13332200
  dw    `10332222
  dw    `00032222
  dw    `00032211
  dw    `00032111

  dw    `00033333   ; 21
  dw    `00213333   ; actually 00213334
  dw    `00213333   ; actually 00213333
  dw    `01223333   ; actually 01223333
  dw    `11123330
  dw    `11123300
  dw    `11123000   ; actually 41123000
  dw    `11123000   ; actually 41123005

  dw    `33333333   ; 22
  dw    `33333333
  dw    `33333333
  dw    `33333330
  dw    `33333300
  dw    `33333300
  dw    `33333000
  dw    `33333000

  dw    `00020000   ; 23
  dw    `00022000
  dw    `00022000
  dw    `00222220
  dw    `00222220
  dw    `00222220
  dw    `00200222
  dw    `00000222

  dw    `00022111   ; 24
  dw    `00222111
  dw    `00221111
  dw    `02221111
  dw    `02221111
  dw    `02211111
  dw    `22211111
  dw    `22211111

  dw    `11111111   ; 25, 25h
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111111
  dw    `11111110
  dw    `11111100
  dw    `11111000

  dw    `11200333   ; 26, 26h
  dw    `12003333
  dw    `12003333
  dw    `20033333
  dw    `00033333
  dw    `00333333
  dw    `00333300
  dw    `03333022

  dw    `11122222   ; 27
  dw    `11122222
  dw    `11112222
  dw    `11112222
  dw    `11112222
  dw    `11112222
  dw    `11111222
  dw    `11111112

; vim:syn=rgbasm
