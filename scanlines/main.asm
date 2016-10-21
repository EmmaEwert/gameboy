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
                ds    75



section "V-Blank interrupt vector", rom0[$40]
                call  SwapBuffer
                reti



section "LCD Status interrupt vector", rom0[$48]
                call  Scanline
                reti


section "Main", rom0[$0150]
Main:           call  Setup
.update:        halt
                nop
                jr    .update



section "Code", rom0
color:          macro
                if \1 == 0
                ld    [hl], a
                else if \1 == 1
                ld    [hl], b
                else if \1 == 2
                ld    [hl], c
                else if \1 == 3
                ld    [hl], d
                else if \1 == 4
                ld    [hl], e
                else if \1 == 5
                ld    [hl], l
                else if \1 == 6
                ld    [hl], h
                else if \1 == 7
                ld    [hl], %101010101
                else
                ld    [hl], \2
                endc
                endc
                endc
                endc
                endc
                endc
                endc
                endc
                endm



Scanline:
aRegister       set   %00000000
bRegister       set   %01010101
cRegister       set   %00011111
dRegister       set   %11100000
eRegister       set   %01111100
                rept  144
                ld    hl, $ff68       ;6 cycles
                ld    [hl], %10000000 ;6 cycles
                ld    a, aRegister % $100          ;4 cycles
                ld    bc, ((bRegister << 8) + cRegister) % $10000       ;6 cycles
                ld    de, ((dRegister << 8) + eRegister) % $10000       ;6 cycles
                ;VRAM accessible after roughly 224 cycles

;                          ┌──┬LCD Status
                ld    hl, $ff41; ┌Mode 0 H-Blank interrupt enabled?
                ld    [hl], %00001000

;                          ┌──┬Interrupt Flag
                ld    hl, $ff0f;┌LCD Status
.notHBlank\@    bit             1, [hl]
                jr    Z, .notHBlank\@
                ld    l, $69


                ;VRAM accessible for roughly 280 cycles
count           set   0
hi              set   0
                rept  7
lo              set   0
                rept  5
                if    count < (7 * 5 - 3)
                color lo
                color hi
                endc
count           set   count+1
lo              set   lo+1
                endr
hi              set   hi+1
                endr
                ;ld    [hl], %11111111 ;6 cycles
                ;ld    [hl], %00000000 ;6 cycles
                ;ld    [hl], %01100110 ;6 cycles

;                          ┌──┬LCD Status
                ld    hl, $ff41;┌LYC=LY Coincidence interrupt enabled?
;                               │  ┌Mode 0 H-Blank interrupt enabled?
                ld    [hl],   %01000000

;                          ┌──┬Interrupt Flag
                ld    hl, $ff0f;┌LCD Status
                res             1, [hl]
aRegister       set   aRegister + 3
bRegister       set   bRegister + 5
cRegister       set   cRegister + 7
dRegister       set   dRegister + 11
eRegister       set   eRegister + 13
                endr
                ret



;                          ┌──┬Scroll X
SwapBuffer:     ld    hl, $ff43;
                ld    a, %00000001
                xor   [hl]
                ld    [hl], a
;                          ┌──┬LCD Control
                ld    hl, $ff40;┌BG Tile Map Display Select
                ld    a,   %00001000
                xor   [hl]
                ld    [hl], a
                ret



section "Setup", rom0
Setup:
.disableLCD:    WaitForLY144;┌──┬LCD Control register
                ld    hl,   $ff40;┌LCD Display enabled?
                res               7, [hl]
;                          ┌Prepare Speed Switch, CGB Mode Only
;                          ├──┐ ┌Current Speed (Read)
.switchSpeed:   ld    hl, $ff4d;│      ┌Prepare Speed Switch?
                ld    [hl],    %00000001
                stop
TILES set 1
.writeTiles:    ld    hl,$ff51
                ld    [hl],Tiles/$100
                inc   l   ;$52
                ld    [hl],Tiles%$100
                inc   l   ;$53
                ld    [hl],$80
                inc   l   ;$54
                ld    [hl],$00
                inc   l   ;$55
                ld    [hl],(TILES-1)
.writeMap:      ld    hl, $ff4f
                ld    [hl], 1; bank 1
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
                ld    l, $53
                ld    [hl], $9c
                ld    l, $55
                ld    [hl],($400/$10-1)
                ld    hl, $ff4f
                ld    [hl], 0; bank 0
;                          ┌──┬LCD Control
.enableLCD:     ld    hl, $ff40;┌LCD Display enabled?
                set             7, [hl]
.enableInterrupts:;        ┌──┬LCD Status
                ld    hl, $ff41;┌LYC=LY Coincidence interrupt enabled?
                ld    [hl],   %01000000
;                          ┌──┬LYC
                ld    hl, $ff45;┌┬Set LCD Status LYC=LY Coincidence flag here
                ld    [hl],    $00
;                          ┌Interrupt Enable register
;                          ├──┐;   ┌LCD Status interrupt enabled?
                ld    hl, $ffff;   │┌V-Blank interrupt enabled?
                ld    [hl], %00000011
                reti



section "Data", romx,bank[1]
Tiles:          rept $08
                dw `00112233
                endr

Map:            rept  $80
                db    $00,$01,$02,$03,$04,$05,$06,$07
                endr

MixMap:         rept  $20
                db    $00,$00,$00,$00,$00,$02,$02,$02
                db    $02,$02,$04,$04,$04,$04,$04,$06
                db    $06,$06,$06,$06,$00,$00,$00,$00
                db    $00,$00,$00,$00,$00,$00,$00,$00
                endr

; vim:filetype=rgbasm expandtab softtabstop=2
