section "Map tile indices", romx,bank[1]
MapIndices
  rept 5
  dw    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;31
  endr
  db     0 , 0 , 0 , 0 , 0 , 0 , 0 ,$01,$02,$03, 0 , 0 , 0 , 0
  dw    0,0,0,0,0,0,0,0,0;31
  db     0 , 0 , 0 , 0 , 0 , 0 , 0 ,$09,$0a,$0b, 0 , 0 , 0 , 0
  dw    0,0,0,0,0,0,0,0,0;31
  db     0 , 0 , 0 , 0 , 0 , 0 ,$10,$11,$12,$13, 0 , 0 , 0 , 0
  dw    0,0,0,0,0,0,0,0,0;31
  db     0 , 0 , 0 , 0 , 0 , 0 , 0 ,$19,$1a,$1b,$1c,$1d, 0 , 0
  dw    0,0,0,0,0,0,0,0,0;31
  db     0 , 0 , 0 , 0 , 0 , 0 , 0 ,$21,$22,$23,$24,$25,$26, 0
  dw    0,0,0,0,0,0,0,0,0;31
  db     0 , 0 , 0 , 0 , 0 , 0 , 0 ,$29,$2a,$2b,$2c,$2d,$2e,$2f
  dw    0,0,0,0,0,0,0,0,0;31
  db     0 , 0 , 0 , 0 , 0 , 0 ,$30,$31,$32,$33,$34,$35,$36,$37
  dw    0,0,0,0,0,0,0,0,0;31
  db     0 , 0 , 0 , 0 , 0 , 0 ,$38,$39,$3a,$3b,$3c,$3d,$3e, 0
  dw    0,0,0,0,0,0,0,0,0;31

section "Map tile attributes", romx,bank[1]
MapAttributes;bits: 7 BG-to-OAM, 6 v-flip, 5 h-flip, 3 VRAM bank number, 2-0 palette
  rept 5
  dw    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;31
  endr
  db    0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  db    0,0,0,0,0,0,0,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  db    0,0,0,0,0,0,2,0,1,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  db    0,0,0,0,0,0,0,0,1,2,3,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  dw    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  dw    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  dw    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  dw    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; vim:syn=rgbasm