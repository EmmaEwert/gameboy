section "Start", rom0[$101]
  jp    Main
  dw    $ceed,$6666,$cc0d,$000b,$0373,$0083,$000c,$000d ; Nintendo
  dw    $0008,$111f,$8889,$000e,$dccc,$6ee6,$dddd,$d999 ; logo, exact
  dw    $bbbb,$6763,$6e0e,$eccc,$dddc,$999f,$bbb9,$333e ; (required)
  db    "TITLE      CODE",$80,0,0,0 ; Title&ID, GBC?, 2 license, SGB?
  db    0,0,0,0,$33 ; cart, rom, ram, region, old license

section "Program", rom0[$150]
Main
  ld    a,%10000000
  ld    hl,$ff69
.Update
  ld    [$ff68],a
  ld    [hl],c
  ld    [hl],b
  inc   bc
  jp    Main

; vim:syn=rgbasm
