all: den.gb palette

palette:
	go build tools/palette.go

den.gb: dragons-den/main.obj
	rgblink -oden.gb dragons-den/main.obj
	rgbfix -v den.gb

dragons-den/main.obj: dragons-den/main.asm
	rgbasm -odragons-den/main.obj -h dragons-den/main.asm

clean:
	rm dragons-den/main.obj den.gb palette
