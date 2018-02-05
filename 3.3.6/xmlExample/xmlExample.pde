XML result = loadXML("http://www.colourlovers.com/api/palettes/top");
//result.print();
XML firstPalette = result.getChild("palette");
XML firstPaletteColors = firstPalette.getChild("colors");
XML[] colorHexes = firstPaletteColors.getChildren("hex");
for (XML c : colorHexes) {
  c.print();
  String hex = c.getContent().trim();
  color paletteColor = unhex(hex);
  println(hex, red(paletteColor), green(paletteColor), blue(paletteColor));
}