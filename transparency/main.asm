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



section "Data", romx,bank[1]
WINDOW_ATTRIBUTES set 0
WindowAttributes:
                rept  $400
                db    %10001001
WINDOW_ATTRIBUTES set WINDOW_ATTRIBUTES+1
                endr
WINDOW_MAP      set   0
WindowMap:      db    $40, $40, $40, $40, $00, $01, $02, $03
                db    $40, $40, $40, $40, $40, $40, $40, $40
                db    $40, $40, $40, $40, $40, $40, $40, $40
                db    $40, $40, $40, $40, $40, $40, $40, $40
WINDOW_MAP      set   WINDOW_MAP+$20
                db    $40, $40, $40, $40, $10, $11, $12, $13
                db    $40, $40, $40, $40, $40, $40, $40, $40
                db    $40, $40, $40, $40, $40, $40, $40, $40
                db    $40, $40, $40, $40, $40, $40, $40, $40
WINDOW_MAP      set   WINDOW_MAP+$20
                rept  $20-(WINDOW_MAP/$20)
                db    $40, $40, $40, $40, $40, $40, $40, $40
                db    $40, $40, $40, $40, $40, $40, $40, $40
                db    $40, $40, $40, $40, $40, $40, $40, $40
                db    $40, $40, $40, $40, $40, $40, $40, $40
WINDOW_MAP      set   WINDOW_MAP+$20
                endr

TILES           set   0
TEXT_TILES      set   0
TextTiles:      dw    `00000000
                dw    `00000000
                dw    `00000000
                dw    `00000000
                dw    `33100000
                dw    `30301320
                dw    `33103030
                dw    `30003030
TEXT_TILES      set   TEXT_TILES+1
                dw    `00000000
                dw    `00000000
                dw    `00000020
                dw    `00000300
                dw    `30000000
                dw    `30001310
                dw    `30303030
                dw    `33003330
TEXT_TILES      set   TEXT_TILES+1
                dw    `00000000
                dw    `00000000
                dw    `00000000
                dw    `00000000
                dw    `00000000
                dw    `33131013
                dw    `31313030
                dw    `30303030
TEXT_TILES      set   TEXT_TILES+1
                dw    `00000000
                dw    `00000000
                dw    `00000000
                dw    `00000000
                dw    `00000000
                dw    `20332000
                dw    `30303000
                dw    `30303000
TEXT_TILES      set   TEXT_TILES+1
                rept  $10-$04
                rept  $08
                dw    `00000000
                endr
TEXT_TILES      set   TEXT_TILES+1
                endr
                dw    `30003030
                dw    `30002310
                dw    `00000000
                dw    `00000000
                dw    `00000000
                dw    `00000000
                dw    `00000000
                dw    `00000000
TEXT_TILES      set   TEXT_TILES+1
                dw    `30203000
                dw    `30301330
                dw    `00000000
                dw    `00000000
                dw    `00000000
                dw    `00000000
                dw    `00000000
                dw    `00000000
TEXT_TILES      set   TEXT_TILES+1
                dw    `30303030
                dw    `30303023
                dw    `00000000
                dw    `00000000
                dw    `00000000
                dw    `00000000
                dw    `00000000
                dw    `00000000
TEXT_TILES      set   TEXT_TILES+1
                dw    `30303000
                dw    `10303000
                dw    `00000000
                dw    `00000000
                dw    `00000000
                dw    `00000000
                dw    `00000000
                dw    `00000000
TEXT_TILES      set   TEXT_TILES+1
TILES           set   TILES+TEXT_TILES
Sprites:
incbin          "transparency/lyra.2bpp"
SPRITES         set   $10





section "V-Blank interrupt vector", rom0[$40]
                call  SwapBuffer
                reti



section "Main", rom0[$0150]
Main:           call Setup
.update:        halt
                nop
                jr    .update



section "Code", rom0;      ┌──┬LCD Control
SwapBuffer:     ld    hl, $ff40;┌Window Display enabled?
                ld    a,     %00100000
                xor   [hl]
                ld    [hl], a
;                          ┌──┬Window Y Position
                ld    hl, $ff4a
                ld    [hl], $90-$20
;                          ┌──┬Window X Position minus 7
                ld    hl, $ff4b
                ld    [hl], $07
                ret



section "Setup", rom0
Setup:;                    ┌──┬LY
.disableLCD:    ld    hl, $ff44;┌┬Line 144, V-Blank starts
                ld    a,       $90
.ltLY144:       cp    [hl]
                jr    C, @+2
                jr    NZ, .ltLY144
;                          ┌──┬LCD Control
                ld    hl, $ff40;┌LCD Display enabled?
                res             7, [hl]
;                          ┌──┬Prepare Speed Switch, CGB Mode Only
.switchSpeed:   ld    hl, $ff4d;┌Prepare Speed Switch?
                set             0, [hl]
                stop
;                          ┌──┬Background Palette Index
.setPalettes:   ld    hl, $ff68;┌Auto Increment?
                ld    [hl],    %10000000
;                          ┌──┬Background Palette Data
                inc   l;  $ff69
                ld    [hl], %10001000;Palette 0
                ld    [hl], %01000000
                ld    [hl], %00000000
                ld    [hl], %00000000
                ld    [hl], %00000000
                ld    [hl], %00000000
                ld    [hl], %00000000
                ld    [hl], %00000000
                ld    [hl], %00000000;Palette 1
                ld    [hl], %00000000
                ld    [hl], %00001000
                ld    [hl], %00100001
                ld    [hl], %00010000
                ld    [hl], %01000010
                ld    [hl], %11111111
                ld    [hl], %01111111
.writeSprites:  ld    hl, $ff51
                ld    [hl], (Sprites+$00)/$100
                inc   l
                ld    [hl], (Sprites+$00)%$100
                inc   l
                ld    [hl], $88
                inc   l
                ld    [hl], $00
                inc   l
                ld    [hl], SPRITES/4-1
                ld    hl, $ff51
                ld    [hl], (Sprites+$40)/$100
                inc   l
                ld    [hl], (Sprites+$40)%$100
                inc   l
                ld    [hl], $89
                inc   l
                ld    [hl], $00
                inc   l
                ld    [hl], SPRITES/4-1
                ld    hl, $ff51
                ld    [hl], (Sprites+$80)/$100
                inc   l
                ld    [hl], (Sprites+$80)%$100
                inc   l
                ld    [hl], $8a
                inc   l
                ld    [hl], $00
                inc   l
                ld    [hl], SPRITES/4-1
                ld    hl, $ff51
                ld    [hl], (Sprites+$c0)/$100
                inc   l
                ld    [hl], (Sprites+$c0)%$100
                inc   l
                ld    [hl], $8b
                inc   l
                ld    [hl], $00
                inc   l
                ld    [hl], SPRITES/4-1
;                          ┌──┬LCD VRAM Bank
.writeTextTiles:ld    hl, $ff4f;┌VRAM Bank = 1
                set             0, [hl]
                ld    hl, $ff51
                ld    [hl], TextTiles/$100
                inc   l
                ld    [hl], TextTiles%$100
                inc   l
                ld    [hl], $80
                inc   l
                ld    [hl], $00
                inc   l
                ld    [hl], (TEXT_TILES-1)
.writeWindowAttributes:
                ld    hl, $ff51
                ld    [hl], WindowAttributes/$100
                inc   l
                ld    [hl], WindowAttributes%$100
                inc   l
                ld    [hl], $9c
                inc   l
                ld    [hl], $00
                inc   l
                ld    [hl], (WINDOW_ATTRIBUTES/$10-1)
;                          ┌──┬LCD VRAM Bank
                ld    hl, $ff4f;┌VRAM Bank = 0
                res             0, [hl]
.writeWindowMap:ld    hl, $ff51
                ld    [hl], WindowMap/$100
                inc   l
                ld    [hl], WindowMap%$100
                inc   l
                ld    [hl], $9c
                inc   l
                ld    [hl], $00
                inc   l
                ld    [hl], (WINDOW_MAP/$10-1)
;                          ┌──┬LCD Control
.selectWindow:  ld    hl, $ff40;┌Window Tile Map Display Select = $9c00-$9fff
                set             6, [hl]
;                     ┌LCD Display enabled?
.enableLCD:     set   7, [hl]
.enableInterrupts:;        ┌──┬Interrupt Enable
                ld    hl, $ffff;┌V-Blank interrupt enabled?
                set             0, [hl]
                reti




; vim:filetype=rgbasm expandtab softtabstop=2
