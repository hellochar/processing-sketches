#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_COLOR_SHADER

void main() {
  gl_FragColor.r = floor(10 * gl_FragCoord.x / 500) / 10;
  gl_FragColor.gba = vec3(0, 0, 1);
}
