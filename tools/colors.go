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
    fmt.Println("Usage: colors filename")
    return
  }
  file, _ := os.Open(os.Args[1])
  image, _ := png.Decode(file)
  count := countColors(image)
  fmt.Printf("%d unique colors\n", count)
}

func countColors(image image.Image) int {
  max := image.Bounds().Max
  count := 0
  var colors = make([]color.Color, max.X * max.Y)
  for i, _ := range colors {
    x := i % max.X
    y := i / max.Y
    color := image.At(x, y)
    c := count+1
    for c >= 0 {
      if colors[c] == color {
        break
      }
      c--
    }
    if (c < 0) { // color didn't exist
      colors[count] = color
      count++
    }
  }
  return count
}
