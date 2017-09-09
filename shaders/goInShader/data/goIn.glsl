#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform float shrinkFactor;

void main(void) {
  vec2 center = vec2(0.5, 0.5);
  vec2 offset = vertTexCoord.st - center;
  // the pixel that was originally this much farther away will now be put here
  // > 1 means that the picture shrinks in
  // [0..1] means that the picture expands outwards

  vec2 samplePosition = center + normalize(offset) * length(offset) * shrinkFactor;
  vec4 col = vec4(0.0);
  vec4 textureCol = texture2D(texture, samplePosition);

  if (samplePosition.x < 0 || samplePosition.x >= 1 ||
      samplePosition.y < 0 || samplePosition.y >= 1) {
    col = vec4(vec3(0.0), 1.0);
  } else {
    col += textureCol;
  }

  gl_FragColor = col;
}

