#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void) {
  // Grouping texcoord variables in order to make it work in the GMA 950. See post #13
  // in this thread:
  // http://www.idevgames.com/forums/thread-3467.html
  vec2 coord = vertTexCoord.st;

  vec4 color = texture2D(texture, coord);

  vec3 colorCorrected = pow(color.rgb, vec3(1.0 / 1.2));
  gl_FragColor = vec4(colorCorrected, color.a);
}
