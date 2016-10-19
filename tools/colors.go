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
  count, out := countColors(image)
  fmt.Printf("%d unique colors\n%d repeat colors, saved in %s\n", count, image.Bounds().Max.X * image.Bounds().Max.Y - count, out)
}

func countColors(in image.Image) (int, string) {
  var encoder png.Encoder
  encoder.CompressionLevel = png.BestCompression
  max := in.Bounds().Max
  out := image.NewRGBA(image.Rect(0, 0, max.X, max.Y))
  count := 0
  var colors = make([]color.Color, max.X * max.Y)
  for i, _ := range colors {
    x := i % max.X
    y := i / max.Y
    color := in.At(x, y)
    c := count+1
    for c >= 0 {
      if colors[c] == color {
        out.Set(x, y, color)
        break
      }
      c--
    }
    if (c < 0) { // color didn't exist
      colors[count] = color
      count++
    }
  }
  filename := "repeats.png"
  file, _ := os.Create(filename)
  defer file.Close()
  encoder.Encode(file, out)
  return count, filename
}
