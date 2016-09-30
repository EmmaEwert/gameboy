all: den palette

palette:
	go build tools/palette.go

den: dragons-den/main.obj
	rgblink -oden.gb dragons-den/main.obj
	rgbfix -v den.gb

dragons-den/main.obj:
	rgbasm -odragons-den/main.obj -h dragons-den/main.asm

clean:
	rm dragons-den/main.obj den.gb palette
