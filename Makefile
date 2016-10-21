roms=weather.gb transparency.gb scanlines.gb den.gb lapras.gb
tools=colors palette still
asmflags=-h -iinclude/
fixflags=-c -i emma -j -k PD -l 0x33 -m 0x1b -p 0x40 -r 0x04 -t $(*F) -v

all: $(roms) $(tools)


# Static rules
$(roms): %.gb: %/main.obj
	rgblink -o$@ $?
	rgbfix $(fixflags) $@

%.obj: %.asm
	rgbasm $(asmflags) -o$@ $<


# Weather
weather/main.asm: $(addprefix include/pallet-town,.2bpp .pal .tilemap)

$(addprefix include/pallet-town,.2bpp .pal .tilemap): include/pallet-town.png
	rgbgfx -P -T -u -o $@ $<


# Transparency
transparency/main.asm: $(addprefix transparency/,lyra.2bpp pallet.2bpp text.2bpp)

transparency/lyra.2bpp: transparency/lyra.png
	rgbgfx -o $@ $<

transparency/pallet.2bpp: transparency/pallet.png
	rgbgfx -T -u -o $@ $<

transparency/text.2bpp: transparency/text.png
	rgbgfx -T -u -o $@ $<


# Lapras
lapras/main.asm: $(addprefix lapras/,map.asm palette.asm header.inc lapras.2bpp)

lapras/lapras.2bpp: lapras/lapras.png
	rgbgfx -o $@ $?


# Tools
$(tools): %: tools/%.go
	go build $<

clean:
	rm -f $(roms)
	rm -f $(tools)
	rm -f */**.obj */**.2bpp */**.pal */**.tilemap
	rm -f *.sav
