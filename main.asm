section "V-Blank", rom0[$40]
  ld    c,$68
  ld    a,%10000000 ; auto increment from palette 0 color 0
  ld    [c],a
  inc   c
  ld    a,e
  ld    [c],a
  ld    a,d
  ld    [c],a
  inc   de
  reti
  ;fixme: overflows well into next interrupt section

section "Start", rom0[$101]
  jp    Main
  dw    $ceed,$6666,$cc0d,$000b,$0373,$0083,$000c,$000d ; Nintendo
  dw    $0008,$111f,$8889,$000e,$dccc,$6ee6,$dddd,$d999 ; logo, exact
  dw    $bbbb,$6763,$6e0e,$eccc,$dddc,$999f,$bbb9,$333e ; (required)
  db    "TITLE      CODE",$80,0,0,0 ; Title&ID, GBC?, 2 license, SGB?
  db    0,0,0,0,$33 ; cart, rom, ram, region, old license

section "Program", rom0[$150]
Main
  ld    a,%00000001
  ldh   [$ff],a     ; enable V-Blank interrupt
  ei
.Update
  halt
  jp    .Update

; vim:syn=rgbasm
