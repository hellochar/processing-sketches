#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

// convert: 
// KinectPV2 mask img (white = no person, black 0-5 = person id)
// into source (black = no person, white = person)
void main(void) {
  vec2 uv = vertTexCoord.st;
  vec4 col = texture2D(texture, uv);

  if (col.r < 1.) {
      // there is a person here
      gl_FragColor = vec4(vec3(1.), 1.);
  } else {
      // there is no person here
      gl_FragColor = vec4(vec3(0.), 1.);
  }
}
