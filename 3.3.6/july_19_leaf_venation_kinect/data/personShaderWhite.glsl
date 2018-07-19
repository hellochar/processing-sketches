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
  vec2 tc4 = vertTexCoord.st + vec2(         0.0,          0.0);
  vec4 col4 = texture2D(texture, tc4);

  if (col4.r > 0.1 && col4.w > 0.1) {
      gl_FragColor = vec4(1.0);
  } else {
      gl_FragColor = vec4(0.0);
  }

  // gl_FragColor = vec4(sum.rgb, 1.0) * vertColor;
}
