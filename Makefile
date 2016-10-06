all: den.gb palette still

den.gb: dragons-den/main.obj
	rgblink -oden.gb dragons-den/main.obj
	rgbfix -v den.gb

dragons-den/main.obj: dragons-den/main.asm
	rgbasm -odragons-den/main.obj -h dragons-den/main.asm

palette: tools/palette.go
	go build tools/palette.go

still: tools/still.go
	go build tools/still.go

clean:
	rm dragons-den/main.obj den.gb palette still
