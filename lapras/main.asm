include "header.inc"

section "Program", rom0[$150]
Main
  call  DisableLCD
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
  ld    a,$3f       ; ($3f + 1) * $10 = $400 bytes = $40 tiles
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
  ld    a,$f        ; $20 * 8 attributes, ceil($100,$10) = $100, $100 / $10 - 1 = $f
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
  ld    a,$f
  ld    [hl],a      ; start DMA transfer
  ret

LoadPalettes
  ld    c,$68
  ld    a,%10000000
  ld    [c],a
  inc   c

  ld    a,%11111111;#ffffff
  ld    [c],a
  ld    a,%01111111
  ld    [c],a

  ld    a,%00101110;#70c8f8
  ld    [c],a
  ld    a,%01111111
  ld    [c],a

  ld    a,%11100111;#3878a0
  ld    [c],a
  ld    a,%01010001
  ld    [c],a

  ld    a,%10000010;#102028
  ld    [c],a
  ld    a,%00010100
  ld    [c],a
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

section "Tile data", romx,bank[1]
TileData
incbin "lapras.2bpp"

section "Map tile indices", romx,bank[1]
MapIndices
        ;0   1   2   3   4   5   6   7
  db    $00,$01,$02,$03,$04,$05,$06,$07
  dw    0,0,0,0,0,0,0,0,0,0,0,0;31
  db    $08,$09,$0a,$0b,$0c,$0d,$0e,$0f
  dw    0,0,0,0,0,0,0,0,0,0,0,0;31
  db    $10,$11,$12,$13,$14,$15,$16,$17
  dw    0,0,0,0,0,0,0,0,0,0,0,0;31
  db    $18,$19,$1a,$1b,$1c,$1d,$1e,$1f
  dw    0,0,0,0,0,0,0,0,0,0,0,0;31
  db    $20,$21,$22,$23,$24,$25,$26,$27
  dw    0,0,0,0,0,0,0,0,0,0,0,0;31
  db    $28,$29,$2a,$2b,$2c,$2d,$2e,$2f
  dw    0,0,0,0,0,0,0,0,0,0,0,0;31
  db    $30,$31,$32,$33,$34,$35,$36,$37
  dw    0,0,0,0,0,0,0,0,0,0,0,0;31
  db    $38,$39,$3a,$3b,$3c,$3d,$3e,$3f
  dw    0,0,0,0,0,0,0,0,0,0,0,0;31

section "Map tile attributes", romx,bank[1]
MapAttributes;bits: 7 BG-to-OAM, 6 v-flip, 5 h-flip, 3 VRAM bank number, 2-0 palette
  dw    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;row 0
  dw    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;row 1
  dw    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;row 2
  dw    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;row 3
  dw    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;row 4
  dw    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;row 5
  dw    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;row 6
  dw    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;row 7

; vim:syn=rgbasm
