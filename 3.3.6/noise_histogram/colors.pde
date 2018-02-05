//color[] colors = {#212922, #294936, #3D604B, #5B8266, #AEF6C7};
//color[] colors = {#ff0000, #00ff00, #0000ff};
//color[] colors = {#0C6AA7, #887002, #860209};//, #884D02};
//color[] colors = {#024218, #06203A, #3E5503};
color[] colors = {#39A9DB, #40BCD8, #F39237, #D63230};
String colorPaletteName;

void loadRandomColourLoversPalette() {
  XML response = loadXML("http://www.colourlovers.com/api/palettes/top");
  XML[] allPalettes = response.getChildren("palette");
  XML palette = allPalettes[(int)random(allPalettes.length)];
  colorPaletteName = palette.getChild("title").getContent(); 
  XML paletteColorsNode = palette.getChild("colors");
  XML[] hexColorNodes = paletteColorsNode.getChildren("hex");
  colors = new color[hexColorNodes.length];
  for (int i = 0 ; i < hexColorNodes.length; i++) {
    XML c = hexColorNodes[i];
    String hex = c.getContent().trim();
    color paletteColor = unhex(hex);
    colors[i] = paletteColor;
  }
}