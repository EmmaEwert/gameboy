all: scanlines.gb den.gb lapras.gb palette still

den.gb: dragons-den/main.obj
	rgblink -oden.gb dragons-den/main.obj
	rgbfix -v den.gb

dragons-den/main.obj: dragons-den/main.asm
	rgbasm -odragons-den/main.obj -h dragons-den/main.asm

lapras.gb: lapras/main.obj
	rgblink -olapras.gb lapras/main.obj
	rgbfix -v lapras.gb

lapras/main.obj: lapras/main.asm lapras/map.asm lapras/palette.asm lapras/header.inc lapras/lapras.2bpp
	rgbasm -ilapras/ -olapras/main.obj -h lapras/main.asm

lapras/lapras.2bpp: lapras/lapras.png
	rgbgfx -o lapras/lapras.2bpp lapras/lapras.png

palette: tools/palette.go
	go build tools/palette.go

still: tools/still.go
	go build tools/still.go

clean:
	rm dragons-den/main.obj den.gb lapras/main.obj lapras.gb palette still
