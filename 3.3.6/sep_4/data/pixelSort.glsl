#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform sampler2D sdf;

float luma(vec4 color) {
  return dot(color.rgb, vec3(0.299, 0.587, 0.114));
}

// horizontally sort each row of an image from left (min brightness) to right (max brightness)
void main(void) {
  // Grouping texcoord variables in order to make it work in the GMA 950. See post #13
  // in this thread:
  // http://www.idevgames.com/forums/thread-3467.html
  vec2 uvLeft = vertTexCoord.st + vec2(-texOffset.s,          0.0);
  vec2 uv = vertTexCoord.st + vec2(         0.0,          0.0);
  vec2 uvRight = vertTexCoord.st + vec2(+texOffset.s,          0.0);

  vec4 left = texture2D(texture, uvLeft);
  vec4 me = texture2D(texture, uv);
  vec4 right = texture2D(texture, uvRight);

  vec4 sdfValue = texture2D(sdf, uv);
  me += sdfValue;

  // how do we build a sort?
  // lets just compare this pixel vs the left px
  // left < me
  //    we don't need to do anything
  // left == me
  //    we don't need to do anything
  // left > me
  //    we want to swap: we want me to be left, and left to be me
  //    we can't express "left to be me". So we instead need to
  //    modify me algorithm to also look at the right
  //
  // if right < me, we become right

  gl_FragColor = me;

  if (luma(left) > luma(me)) {
      gl_FragColor = left;
  } else if (luma(right) < luma(me)) {
      gl_FragColor = right;
  }

  gl_FragColor.rgb -= sdfValue.rgb / 10.;
}
