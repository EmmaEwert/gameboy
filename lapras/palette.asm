section "Palette code", rom0
LoadPalettes
  ld    c,$68
  ld    a,%10000000
  ld    [c],a
  inc   c
  ld    hl,PaletteData  ; ROM
  ld    b,$40;bytes, 2 per color = $20 colors = 8 palettes
.while;b --> 0
  ld    a,[hl+]
  ld    [c],a
  dec   b
  jr    nz,.while
  ret

ScanlineLookup;needs to be tight to save cycles for palette changes
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

ScanlineTable;executes eg. Scanline2 at post-LY=2 H-Blank
  rept 5; tile rows to skip
  rept 8; pixel rows per tile
  jp    Scanline
  endr
  endr
  ; row 0, 0-7
  jp    Scanline
  jp    Scanline
  jp    Scanline2
  jp    Scanline
  jp    Scanline
  jp    Scanline
  jp    Scanline6
  jp    Scanline7
  ; row 1, 8-15
  jp    Scanline8
  jp    Scanline9
  jp    Scanline
  jp    Scanline11
  jp    Scanline
  jp    Scanline
  jp    Scanline14
  jp    Scanline15
  ; row 2, 16-23
  jp    Scanline16
  jp    Scanline17
  jp    Scanline
  jp    Scanline19
  jp    Scanline20
  jp    Scanline21
  jp    Scanline
  jp    Scanline23
  ; row 3, 24-31
  jp    Scanline
  jp    Scanline25
  jp    Scanline
  jp    Scanline
  jp    Scanline28
  jp    Scanline29
  jp    Scanline30
  jp    Scanline
  rept 160-(5*8)-32      ; fill out remaining entries with returns
  jp    Scanline
  endr

Scanline
  reti

Scanline2
  ld    hl,$ff69        ; palette register
  ld    a,%10000110     ; palette %000, color %11, byte %0
  ld    [de],a
  ld    [hl],%00000011 ; #184050
  ld    [hl],%00101001
  ; repeat 4 above per color (or 2 above if directly next color)
  reti

Scanline6
  ld    hl,$ff69
  ld    a,%10000110
  ld    [de],a
  ld    [hl],%10000010 ; #102028
  ld    [hl],%00010100
  ld    [hl],%00101110 ; #70c8f8
  ld    [hl],%01111111
  reti

Scanline7
  ld    hl,$ff69
  ld    a,%10001110
  ld    [de],a
  ld    [hl],%00000011 ; #184050
  ld    [hl],%00101001
  reti

Scanline8
  ld    hl,$ff69
  ld    a,%10001110
  ld    [de],a
  ld    [hl],%10000010 ; #102028
  ld    [hl],%00010100
  ld    [hl],%00101110 ; #70c8f8
  ld    [hl],%01111111
  ld    [hl],%10001000 ; #40a0e8
  ld    [hl],%01110110
  reti

Scanline9
  ld    hl,$ff69
  ld    a,%10001000
  ld    [de],a
  ld    [hl],%11111111 ; #ffffff
  ld    [hl],%01111111
  ld    a,%10010000
  ld    [de],a
  ld    [hl],%11111111 ; #ffffff
  ld    [hl],%01111111
  reti

Scanline11
  ld    hl,$ff69
  ld    a,%10010110
  ld    [de],a
  ld    [hl],%00000011 ; #184050
  ld    [hl],%00101001
  reti

Scanline14
  ld    hl,$ff69
  ld    a,%10001000
  ld    [de],a
  ld    [hl],%01010100 ; #a09090
  ld    [hl],%01001010
  reti

Scanline15
  ld    hl,$ff69
  ld    a,%10000110
  ld    [de],a
  ld    [hl],%00000011 ; #184050
  ld    [hl],%00101001
  ld    [hl],%10010001 ; #88a090
  ld    [hl],%01001010
  ld    [hl],%00111100 ; #e0c880
  ld    [hl],%01000011
  reti

Scanline16
  ld    hl,$ff69
  ld    a,%10010010
  ld    [de],a
  ld    [hl],%11100111 ; #3878a0
  ld    [hl],%01010001
  ld    [hl],%01001010 ; #505068
  ld    [hl],%00110101
  reti

Scanline17
  ld    hl,$ff69
  ld    a,%10000010
  ld    [de],a
  ld    [hl],%00111100 ; #e0c880
  ld    [hl],%01000011
  reti

Scanline19
  ld    hl,$ff69
  ld    a,%10000110
  ld    [de],a
  ld    [hl],%10000010 ; #102028
  ld    [hl],%00010100
  ld    a,%10001100
  ld    [de],a
  ld    [hl],%00101011 ; #584840
  ld    [hl],%00100001
  reti

Scanline20
  ld    hl,$ff69
  ld    a,%10001100
  ld    [de],a
  ld    [hl],%11100111 ; #3878a0
  ld    [hl],%01010001
  ld    [hl],%00101011 ; #584840
  ld    [hl],%00100001
  reti

Scanline21
  ld    hl,$ff69
  ld    a,%10001000
  ld    [de],a
  ld    [hl],%11111111 ; #ffffff
  ld    [hl],%01111111
  ld    a,%10001110
  ld    [de],a
  ld    [hl],%10000010 ; #102028
  ld    [hl],%00010100
  reti

Scanline23
  ld    hl,$ff69
  ld    a,%10011100
  ld    [de],a
  ld    [hl],%01010100 ; #a09090
  ld    [hl],%01001010
  ld    [hl],%10100101 ; #282838
  ld    [hl],%00011100
  reti

Scanline25
  ld    hl,$ff69
  ld    a,%10001000
  ld    [de],a
  ld    [hl],%10010001 ; #88a090
  ld    [hl],%01001010
  ld    a,%10010010
  ld    [de],a
  ld    [hl],%01011011 ; #d8d0c8
  ld    [hl],%01100111
  ld    [hl],%01010100 ; #a09090
  ld    [hl],%01001010
  ld    [hl],%10100101 ; #282838
  ld    [hl],%00011100
  reti

Scanline28
  ld    hl,$ff69
  ld    a,%10011100
  ld    [de],a
  ld    [hl],%01001010 ; #505068
  ld    [hl],%00110101
  reti

Scanline29
  ld    hl,$ff69
  ld    a,%10011000
  ld    [de],a
  ld    [hl],%01011011 ; #d8d0c8
  ld    [hl],%01100111
  ld    a,%10100110
  ld    [de],a
  ld    [hl],%10100101 ; #282838
  ld    [hl],%00011100
  reti

Scanline30
  ld    hl,$ff69
  ld    a,%10010000
  ld    [de],a
  ld    [hl],%11100111 ; #3878a0
  ld    [hl],%01010001
  ld    a,%10011010
  ld    [de],a
  ld    [hl],%01011011 ; #d8d0c8
  ld    [hl],%01100111
  ld    [hl],%01010100 ; #a09090
  ld    [hl],%01001010
  ld    [hl],%01001010 ; #505068
  ld    [hl],%00110101
  reti

section "Palette data", romx,bank[1]
PaletteData
  dw    %0111111111111111;#ffffff
  dw    %0111011010001000;#40a0e8
  dw    %0101000111100111;#3878a0
  dw    %0001010010000010;#102028

  dw    %0111111111111111;#ffffff
  dw    %0111011010001000;#40a0e8
  dw    %0101000111100111;#3878a0
  dw    %0001010010000010;#102028

  dw    %0111111111111111;#ffffff
  dw    %0111111100101110;#70c8f8
  dw    %0101000111100111;#3878a0
  dw    %0001010010000010;#102028

  dw    %0111111111111111;#ffffff
  dw    %0100101001010100;#a09090
  dw    %0101000111100111;#3878a0
  dw    %0001010010000010;#102028

  dw    %0111111111111111;#ffffff
  dw    %0110011101011011;#d8d0c8
  dw    %0100101001010100;#a09090
  dw    %0011010101001010;#505068

  rept 3 ; Align to $10 boundary for DMA transfer below
  dw    %0111111111111111;#f8f8f8
  dw    %0100001000010000;#808080
  dw    %0010000100001000;#404040
  dw    %0000000000000000;#000000
  endr
; vim:syn=rgbasm
