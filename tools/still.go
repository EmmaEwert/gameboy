package main

import (
	"fmt"
	"image"
	"image/color"
	"image/png"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: still filename")
		return
	}
	file, _ := os.Open(os.Args[1])
	image, _ := png.Decode(file)

	tilemap := load(image)
	// optimized := tilemap.optimize()
	tilemap.print()
}

func load(image image.Image) *Map {
	tilemap := new(Map)
	tileID := 0
	for tileID < len(tilemap.tiles) {
		tile := new(Tile)
		pixelID := 0
		var colors [64]color.Color
		for pixelID < len(tile.colorIDs) {
			x := pixelID%8 + (tileID%20)*8
			y := pixelID/8 + (tileID/20)*8
			color := image.At(x, y)
			colorID := 0
			for colors[colorID] != nil && colors[colorID] != color {
				colorID++
			}
			if colors[colorID] == nil {
				tile.colors[colorID] = color
				colors[colorID] = color
			}
			tile.colorIDs[pixelID] = uint8(colorID)
			pixelID++
		}
		tilemap.tiles[tileID] = tile
		tileID++
	}
	return tilemap
}

func (in *Map) optimize() *Map {
	out := *in
	tileID := 0
	for tileID < len(in.tiles) {
		src := in.tiles[tileID]
		y := 0
		for y < 8 {
			x := 0
			var colors [8]color.Color
			for x < 8 {
				id := x + y*8
				colorID := uint8(0)
				for colorID < 8 {
					if colors[colorID] == nil {
						colors[colorID] = src.colors[src.colorIDs[id]]
						out.tiles[tileID].colorIDs[id] = colorID
						break
					} else if colors[colorID] == src.colors[src.colorIDs[id]] {
						out.tiles[tileID].colorIDs[id] = 9
						break
						//}
					}
					colorID++
				}
				x++
			}
			y++
		}
		tileID++
	}
	return &out
}

func (m *Map) print() {
	pixelID := 0
	tw, _ := 20, 18
	w, h := 96, 48
	pixels := w * h // pixel count
	for pixelID < pixels {
		x := pixelID % w
		y := pixelID / w
		tx := x / 8
		ty := y / 8
		tileID := tx + ty*tw
		tile := m.tiles[tileID]
		colorID := tile.colorIDs[x%8+y%8*8]
		if tile.colors[colorID] == nil {
			bg(255, 0, 0)
			fmt.Print(" ?[0m")
		} else {
			r, g, b, _ := tile.colors[colorID].RGBA()
			bg(r, g, b)
			if colorID > 3 {
				fmt.Print("[38;2;255;255;255m")
			}
			fmt.Printf("%2d[0m", colorID)
		}
		pixelID++
		if pixelID%(w*8) == 0 {
			fmt.Println()
		}
		if pixelID%w == 0 {
			fmt.Println()
		} else if pixelID%8 == 0 {
			fmt.Print(" ")
		}
	}
}

func bg(r, g, b uint32) {
	r, g, b = r&0xff, g&0xff, b&0xff
	fmt.Printf("[48;2;%d;%d;%dm", r, g, b)
	if r+g+b < 256 {
		fmt.Print("[38;2;128;128;128m")
	} else {
		fmt.Print("[38;2;64;64;64m")
	}
}

type Tile struct {
	colors   [64]color.Color
	colorIDs [64]uint8 // palette index, 0-3 + palette * 4 (ideally)
}

type Scanline struct {
	changes []Change
	swaps   []Swap
	scroll  image.Point
}

type Change struct {
	colorID int
	color   color.Color
}

type Swap struct {
	tileID    int
	paletteID int
}

type Palette struct {
	colors [4]color.Color
}

type Map struct {
	palettes [8]Palette
	tiles    [20 * 18]*Tile
	lines    [144 * 8]Scanline
}

/*
order of optimizations:

* identify 4+ colors in single tile lines
	* solve by messing with scroll.x and scroll.y for entire line
	* failing that, solve with local sprite overlays

theoretically correct 2bpp image output from here

* reoptimise per scanline analysis
	* restructure initial palettes to fit tile line palette swaps
	* reorder palette color changes to increase consecutivity
* swap tile line palette to one with colors closest to required
* reuse as many colors as possible from tile line just above
* change final palettes' colors as required for scanline

practically correct 2bpp image output from here

result structure:
	[Palette][Palette]..8..[Palette]
	[Tile][Tile]..20..[Tile] [Scanline][Scanline]..8..[Scanline]
	[Tile][Tile]..20..[Tile] [Scanline][Scanline]..8..[Scanline]
	..18..
	[Tile][Tile]..20..[Tile] [Scanline][Scanline]..8..[Scanline]

notes:

* Map can just be [20*18*8*8]Color, read line-sequentially
	* `position(pixelindex uint16) x, y uint8`
	* `tile(x, y uint8) tileindex uint16`
*/

// vim:nolist tabstop=2
