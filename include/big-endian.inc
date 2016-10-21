ldbe:           macro
                ld    \1, (\2>>8)+(\2<<8)%$10000
                endm
; vim:filetype=rgbasm expandtab softtabstop=2
