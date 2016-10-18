WaitForHBlank:  macro;     ┌──┬Interrupt Flag
                ld    hl, $ff0f;┌LCD Status
.notHBlank\@    bit             1, [hl]
                jr    Z, .notHBlank\@
                res             1, [hl]
                endm

WaitForVBlank:  macro;     ┌──┬Interrupt Flag
                ld    hl, $ff0f;┌V-Blank
.notVBlank\@    bit             0, [hl]
                jr    Z, .notVBlank\@
                res             0, [hl]
                endm

WaitForLY144:   macro;     ┌──┬LY register
                ld    hl, $ff44;┌┬Line 144, V-Blank starts
                ld    a,       $90
.ltLY144\@:     cp    [hl]
                jr    C, @+2
                jr    NZ, .ltLY144\@
                endm



section "Header", rom0[$0100]
                di
                jp    Main
                db    $ce, $ed, $66, $66, $cc, $0d, $00, $0b, $03, $73, $00, $83
                db    $00, $0c, $00, $0d, $00, $08, $11, $1f, $88, $89, $00, $0e
                db    $dc, $cc, $6e, $e6, $dd, $dd, $d9, $99, $bb, $bb, $67, $63
                db    $6e, $0e, $ec, $cc, $dd, $dc, $99, $9f, $bb, $b9, $33, $3e
                db    "SCANLINES  EMMA"
                db    $80       ;GBC+DMG
                db    "PD"
                db    $00       ;No SGB
                db    $1b       ;MBC5+RAM+Battery
                db    $08       ;  8 MiB ROM
                db    $04       ;128 KiB RAM
                db    $01       ;International
                db    $33
                db    %10       ;0.1.0
                db    $00, $00, $00



section "Main", rom0[$0150]
Main:           call  Setup
                ld    hl, $0000
                push  hl
                jp    Scanline
.update:        halt
                nop
                jr    .update



Setup:
DisableLCD:     WaitForLY144;┌──┬LCD Control register
                ld    hl,   $ff40;┌LCD Display Enabled?
                res               7, [hl]
;                          ┌Prepare Speed Switch, CGB Mode Only
;                          ├──┐ ┌Current Speed (Read)
SwitchSpeed:    ld    hl, $ff4d;│      ┌Prepare Speed Switch?
                ld    [hl],    %00000001
                stop
TILES set 1
WriteTiles:     ld    hl,$ff51
                ld    [hl],Tiles/$100
                inc   l   ;$52
                ld    [hl],Tiles%$100
                inc   l   ;$53
                ld    [hl],$80
                inc   l   ;$54
                ld    [hl],$00
                inc   l   ;$55
                ld    [hl],(TILES-1)
WriteMap:       ld    hl, $ff4f
                ld    [hl], 1
                ld    hl, $ff51
                ld    [hl],Map/$100
                inc   l   ;$52
                ld    [hl],Map%$100
                inc   l   ;$53
                ld    [hl],$98
                inc   l   ;$54
                ld    [hl],$00
                inc   l   ;$55
                ld    [hl],($400/$10-1)
                ld    hl, $ff4f
                ld    [hl], 0
;                          ┌──┬LCD Control
EnableLCD:      ld    hl, $ff40;┌LCD Display Enable
                set             7, [hl]
EnableInterrupts:;         ┌──┬LCDC Status
                ld    hl, $ff41; ┌Mode 0 H-Blank Interrupt Enabled
                ld    [hl], %00001000
                reti






section "New Scanline", rom0
Scanline:       WaitForLY144
                ld    hl, $ff68
                ld    [hl], %10100000
                inc   l
                rept  $10
                ld    [hl], %00000000
                ld    [hl], %00000000
                endr
                ld    a, %10000000
                ld    c, $68
green           set   $00
blue            set   $00
                rept $8f
                WaitForHBlank
                ld    l,c
                ld    [hl+],a
red             set   $00
                rept  $10
color           set   red
                ld    [hl], red & %00011111 + (green & %00000111) << 5
                ld    [hl], (blue/4) << 2 + (green >> 3)
red             set   red + 1
                endr
green           set   (green + 1) % $20
blue            set   (blue + 1)
                endr

                WaitForLY144
                ld    l,c
                ld    [hl], %10100000
                inc   l
                rept  $10
                ld    [hl], %00000000
                ld    [hl], %10000000
                endr
                ld    a,%10000000
                WaitForHBlank
                ld    l,c
                ld    [hl+],a
                rept  $10
                ld    [hl], e
                ld    [hl], d
                endr
                jp    Scanline



section "Data", romx,bank[1]
Tiles:          dw `00112233
                dw `00112233
                dw `00112233
                dw `00112233
                dw `00112233
                dw `00112233
                dw `00112233
                dw `00112233

Map:            rept  $20
                db    $00,$01,$02,$03,$04,$05,$06,$07
                db    $07,$07,$07,$07,$07,$07,$07,$07
                db    $07,$07,$07,$07,$07,$07,$07,$07
                db    $07,$07,$07,$07,$07,$07,$07,$07
                endr

; vim:filetype=rgbasm expandtab softtabstop=2
