package main

import (
  . "fmt"
  . "math"
  . "strconv"
  . "os"
)

func main() {
  if len(Args) != 4 {
    Println("Usage: palette RR GG BB")
    return
  }
  r, err := ParseUint(Args[1], 16, 8)
  g, err := ParseUint(Args[2], 16, 8)
  b, err := ParseUint(Args[3], 16, 8)
  if err != nil {
    Println(err)
    return
  }
  R := uint64(Floor(float64(r) / 8 + 0.5))
  G := uint64(Floor(float64(g) / 8 + 0.5))
  B := uint64(Floor(float64(b) / 8 + 0.5))
  rgb := R + (G + B * 0x20) * 0x20
  if R * 8 != r || G * 8 != g || B * 8 != b {
    Printf("  dw    %%%016b ; #%x%x%x (from #%02x%02x%02x)\n",
      rgb, R * 8, G * 8, B * 8, r, g, b)
    Printf("  db    %%%08b, %%%08b ; #%x%x%x (from #%02x%02x%02x)\n",
      rgb >> 8, rgb & 0xff, R * 8, G * 8, B * 8, r, g, b)
    Printf("  ld    [hl],%%%08b ; #%x%x%x (from #%02x%02%02x)\n",
      rgb & 0xff, R * 8, G * 8, B * 8, r, g, b)
    Printf("  ld    [hl],%%%08b\n", rgb >> 8)
    return
  }
  Printf("  dw    %%%016b ; #%x%x%x\n", rgb, r, g, b)
  Printf("  db    %%%08b, %%%08b ; #%x%x%x\n", rgb & 0xff, rgb >> 8, r, g, b)
  Printf("  ld    [hl],%%%08b ; #%x%x%x\n", rgb & 0xff, R * 8, G * 8, B * 8)
  Printf("  ld    [hl],%%%08b\n", rgb >> 8)
}
