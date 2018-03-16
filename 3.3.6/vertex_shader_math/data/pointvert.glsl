uniform mat4 projection;
uniform mat4 modelview;

attribute vec4 position;
attribute vec4 color;
// special Processing value. Processing draws thick points
// as a polygon (using many triangles); so we're actually
// in the middle of a triangle fan context. offset is the
// specific offset of this vertex from the actual position.
attribute vec2 offset;

varying vec4 vertColor;

float rand(vec2 xy) {
    return fract(sin(dot(xy, vec2(23.95314, 593.3134)) * 9504.2321 + 544.321));
}

void main() {
  vec4 pos = modelview * position;
  // clip goes from like -.85 to .85, this is almost but not quite normalized coordinates
  vec4 clip = projection * pos;

  // goes from like -1 to 0.85
  /* gl_Position = clip + projection * vec4(offset, 0, 0); */

  // this won't work because we're not in -1 -> 1 space
  /* gl_Position = vec4(128., 128., 181., 217.); */

  // this won't work because we can't put the position on the same place for every vertex since that means the polygon area is 0 and no points get rasterized (also the w is wrong)
  /* gl_Position = vec4(0., 0., 0.5, 0.7); */

  // this will cover the entire screen, unless the strokeWeight is 1 in which case it'll be about the screen size
  /* gl_Position = vec4(0., 0., 0., 1.) + projection * vec4(offset, 0, 0); */

  // this works about correctly, because the offset is specified in pixel coordinates, and Processing uses the .w as a big divider, something like 235
  /* gl_Position = vec4(0., 0., 0., 235.) + projection * vec4(offset, 0, 0); */

  // this will also kind of work - the x/y is now expressed in pixel coordinates
  gl_Position = clip + projection * vec4(offset * (1. + sin(offset / 10. + clip.xy))/2., 0, 0);

  vertColor = color;
  /* vertColor = clip / 255.; */
  /* vertColor = clip / 255.; */
  /* vertColor = vec4(offset / 100., 0., 1.); */
  /* vertColor = vec4(clip.www / 1000., 1.); */
}
