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



section "V-Blank interrupt vector", rom0[$40]
                reti



section "Main", rom0[$0150]
Main:           call Setup
.update:        halt
                nop
                jr    .update



section "Setup", rom0
Setup:;                    ┌──┬LY register
.disableLCD:    ld    hl, $ff44;┌┬Line 144, V-Blank starts
                ld    a,       $90
.ltLY144:       cp    [hl]
                jr    C, @+2
                jr    NZ, .ltLY144
;                          ┌──┬Prepare Speed Switch, CGB Mode Only
.switchSpeed:   ld    hl, $ff4d;┌Prepare Speed Switch?
                set             0, [hl]
                stop;      ┌──┬LCD Control
.enableLCD:     ld    hl, $ff40;┌LCD Display enabled?
                set             7, [hl]
.enableInterrupts:;        ┌──┬Interrupt Enable register
                ld    hl, $ffff;┌V-Blank interrupt enabled?
                set             0, [hl]
                reti

; vim:filetype=rgbasm expandtab softtabstop=2
