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
MAP             set   0
Map:            rept  $0e
                rept  $20
                db    $00
MAP             set   MAP+1
                endr
                endr
                db    $80, $81, $82, $83
MAP             set   MAP+4
                rept  $20-$04
                db    $00
MAP             set   MAP+1
                endr
                db    $90, $91, $92, $93
MAP             set   MAP+4
                rept  $20-$04
                db    $00
MAP             set   MAP+1
                endr
                db    $a0, $a1, $a2, $a3
MAP             set   MAP+4
                rept  $20-$04
                db    $00
MAP             set   MAP+1
                endr
                db    $b0, $b1, $b2, $b3
MAP             set   MAP+4
                rept  $20-$04
                db    $00
MAP             set   MAP+1
                endr

MAP_ATTRIBUTES  set   0
MapAttributes:  rept  $0e
                rept  $20
                db    $00
MAP_ATTRIBUTES  set   MAP_ATTRIBUTES+1
                endr
                endr
                db    $02, $02, $02, $02
MAP_ATTRIBUTES  set   MAP_ATTRIBUTES+4
                rept  $20-$04
                db    $00
MAP_ATTRIBUTES  set   MAP_ATTRIBUTES+1
                endr
                db    $02, $02, $02, $02
MAP_ATTRIBUTES  set   MAP_ATTRIBUTES+4
                rept  $20-$04
                db    $00
MAP_ATTRIBUTES  set   MAP_ATTRIBUTES+1
                endr
                db    $02, $02, $02, $02
MAP_ATTRIBUTES  set   MAP_ATTRIBUTES+4
                rept  $20-$04
                db    $00
MAP_ATTRIBUTES  set   MAP_ATTRIBUTES+1
                endr
                db    $02, $02, $02, $02
MAP_ATTRIBUTES  set   MAP_ATTRIBUTES+4
                rept  $20-$04
                db    $00
MAP_ATTRIBUTES  set   MAP_ATTRIBUTES+1
                endr

WINDOW_ATTRIBUTES set 0
WindowAttributes:
                db    $02, $02, $02, $02, $89, $89, $89, $89
                db    $89, $89, $89, $89, $89, $89, $89, $89
                db    $89, $89, $89, $89, $89, $89, $89, $89
                db    $89, $89, $89, $89, $89, $89, $89, $89
WINDOW_ATTRIBUTES set WINDOW_ATTRIBUTES+$20
                db    $02, $02, $02, $02, $89, $89, $89, $89
                db    $89, $89, $89, $89, $89, $89, $89, $89
                db    $89, $89, $89, $89, $89, $89, $89, $89
                db    $89, $89, $89, $89, $89, $89, $89, $89
WINDOW_ATTRIBUTES set WINDOW_ATTRIBUTES+$20
                db    $02, $02, $02, $02, $89, $89, $89, $89
                db    $89, $89, $89, $89, $89, $89, $89, $89
                db    $89, $89, $89, $89, $89, $89, $89, $89
                db    $89, $89, $89, $89, $89, $89, $89, $89
WINDOW_ATTRIBUTES set WINDOW_ATTRIBUTES+$20
                db    $02, $02, $02, $02, $89, $89, $89, $89
                db    $89, $89, $89, $89, $89, $89, $89, $89
                db    $89, $89, $89, $89, $89, $89, $89, $89
                db    $89, $89, $89, $89, $89, $89, $89, $89
WINDOW_ATTRIBUTES set WINDOW_ATTRIBUTES+$20
                rept  $400-WINDOW_ATTRIBUTES
                db    %10001001;$89
WINDOW_ATTRIBUTES set WINDOW_ATTRIBUTES+1
                endr
WINDOW_MAP      set   0
WindowMap:      db    $80, $81, $82, $83, $00, $01, $02, $03
                db    $40, $40, $40, $40, $40, $40, $40, $40
                db    $40, $40, $40, $40, $40, $40, $40, $40
                db    $40, $40, $40, $40, $40, $40, $40, $40
WINDOW_MAP      set   WINDOW_MAP+$20
                db    $90, $91, $92, $93, $10, $11, $12, $13
                db    $40, $40, $40, $40, $40, $40, $40, $40
                db    $40, $40, $40, $40, $40, $40, $40, $40
                db    $40, $40, $40, $40, $40, $40, $40, $40
WINDOW_MAP      set   WINDOW_MAP+$20
                db    $a0, $a1, $a2, $a3, $40, $40, $40, $40
                db    $40, $40, $40, $40, $40, $40, $40, $40
                db    $40, $40, $40, $40, $40, $40, $40, $40
                db    $40, $40, $40, $40, $40, $40, $40, $40
WINDOW_MAP      set   WINDOW_MAP+$20
                db    $b0, $b1, $b2, $b3, $40, $40, $40, $40
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

section "Sprite Attributes", rom0[$0400]
SpriteMap:      db    $80, $08, $80, %00000000
                db    $80, $10, $81, %00000000
                db    $80, $18, $82, %00000000
                db    $80, $20, $83, %00000000
                db    $88, $08, $90, %00000000
                db    $88, $10, $91, %00000000
                db    $88, $18, $92, %00000000
                db    $88, $20, $93, %00000000
                db    $90, $08, $a0, %00000000
                db    $90, $10, $a1, %00000000
                db    $90, $18, $a2, %00000000
                db    $90, $20, $a3, %00000000
                db    $98, $08, $b0, %00000000
                db    $98, $10, $b1, %00000000
                db    $98, $18, $b2, %00000000
                db    $98, $20, $b3, %00000000



section "V-Blank interrupt vector", rom0[$0040]
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

                ;call  TransferOAM
                ret



section "OAM DMA Transfer", hram
TransferOAM:    ds $0b



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
.mapPalettes:   ld    hl, $ff68;┌Auto Increment?
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
                ;Palette 2
                ld    [hl], %01011111 ; #f8d0b8
                ld    [hl], %01011111
                ld    [hl], %10111111 ; #f86860
                ld    [hl], %00110001
                ld    [hl], %11010011 ; #987040
                ld    [hl], %00100001
                ld    [hl], %11111111 ; #f8f8f8
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
.writeMap:      ld    hl, $ff51
                ld    [hl], Map/$100
                inc   l
                ld    [hl], Map%$100
                inc   l
                ld    [hl], $98
                inc   l
                ld    [hl], $00
                inc   l
                ld    [hl], (MAP/$10-1)
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
.writeMapAttributes:
                ld    hl, $ff51
                ld    [hl], MapAttributes/$100
                inc   l
                ld    [hl], MapAttributes%$100
                inc   l
                ld    [hl], $98
                inc   l
                ld    [hl], $00
                inc   l
                ld    [hl], (MAP/$10-1)
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
.writeOAMTransfer:
                ld    hl, RAMTransferOAM
                ld    de, TransferOAM
                rept $0b
                ld    a, [hl+]
                ld    [de], a
                inc   de
                endr
;                          ┌──┬LCD Control
.selectWindow:  ld    hl, $ff40;┌Window Tile Map Display Select = $9c00-$9fff
                set             6, [hl]
.enableSprites:;                ┌BG and Window Master Priority
                set             1, [hl]
;                     ┌LCD Display enabled?
.enableLCD:     set   7, [hl]
.enableInterrupts:;        ┌──┬Interrupt Enable
                ld    hl, $ffff;┌V-Blank interrupt enabled?
                set             0, [hl]
                reti



RAMTransferOAM: ld    hl, $ff46
                ld    [hl], $04
                ld    a, $28
.wait:          dec   a
                jr    NZ, .wait
                ret



; vim:filetype=rgbasm expandtab softtabstop=2
