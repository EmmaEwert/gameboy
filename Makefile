roms=voltorbflip.gb squish.gb daycycle.gb weather.gb transparency.gb scanlines.gb den.gb lapras.gb
tools=colors palette still
asmflags=-h -iinclude/
fixflags=-c -i emma -j -k PD -l 0x33 -m 0x1b -p 0x40 -r 0x04 -t $(*F) -v

all: $(roms) $(tools)


# Static rules
$(roms): %.gb: %/main.obj
	rgblink -n $(basename $@).sym -o$@ $?
	rgbfix $(fixflags) $@

%.obj: %.rgbasm
	rgbasm $(asmflags) -o$@ $<



# Squish
squish/main.rgbasm: $(addprefix include/pallet-town,.2bpp .pal .tilemap)



# Daycycle
daycycle/main.rgbasm: $(addprefix include/pallet-town,.2bpp .pal .tilemap)



# Weather
weather/main.rgbasm: $(addprefix include/pallet-town,.2bpp .pal .tilemap) $(addprefix include/weather,.2bpp .pal)

$(addprefix include/pallet-town,.2bpp .pal .tilemap): include/pallet-town.png
	rgbgfx -P -T -u -o $@ $<

$(addprefix include/weather,.2bpp .pal): include/weather.png
	rgbgfx -P -o $@ $<


# Transparency
transparency/main.rgbasm: $(addprefix transparency/,lyra.2bpp pallet.2bpp text.2bpp)

transparency/lyra.2bpp: transparency/lyra.png
	rgbgfx -o $@ $<

transparency/pallet.2bpp: transparency/pallet.png
	rgbgfx -T -u -o $@ $<

transparency/text.2bpp: transparency/text.png
	rgbgfx -T -u -o $@ $<


# Lapras
lapras/main.rgbasm: $(addprefix lapras/,map.rgbasm palette.rgbasm header.inc lapras.2bpp)

lapras/lapras.2bpp: lapras/lapras.png
	rgbgfx -o $@ $?


# Tools
$(tools): %: tools/%.go
	go build $<

clean:
	rm -f $(roms)
	rm -f $(tools)
	rm -f */**.obj */**.2bpp */**.pal */**.tilemap
	rm -f *.sav *.sym
