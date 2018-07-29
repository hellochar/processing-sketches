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
  vec2 tc0 = vertTexCoord.st + vec2(-texOffset.s, -texOffset.t);
  vec2 tc1 = vertTexCoord.st + vec2(         0.0, -texOffset.t);
  vec2 tc2 = vertTexCoord.st + vec2(+texOffset.s, -texOffset.t);
  vec2 tc3 = vertTexCoord.st + vec2(-texOffset.s,          0.0);
  vec2 tc4 = vertTexCoord.st + vec2(         0.0,          0.0);
  vec2 tc5 = vertTexCoord.st + vec2(+texOffset.s,          0.0);
  vec2 tc6 = vertTexCoord.st + vec2(-texOffset.s, +texOffset.t);
  vec2 tc7 = vertTexCoord.st + vec2(         0.0, +texOffset.t);
  vec2 tc8 = vertTexCoord.st + vec2(+texOffset.s, +texOffset.t);
  
  vec4 col0 = texture2D(texture, tc0);
  vec4 col1 = texture2D(texture, tc1);
  vec4 col2 = texture2D(texture, tc2);
  vec4 col3 = texture2D(texture, tc3);
  vec4 col4 = texture2D(texture, tc4);
  vec4 col5 = texture2D(texture, tc5);
  vec4 col6 = texture2D(texture, tc6);
  vec4 col7 = texture2D(texture, tc7);
  vec4 col8 = texture2D(texture, tc8);

  bool isInside = col4.r < 0.5;

  vec2 uv = vertTexCoord.st;
  float lerpAmount = length(uv - vec2(0.5)); // goes from 0 to 0.5 on the edge centers to sqrt(2) / 2 on the corners
  // vec3 colInner = vec3(92., 112., 128.) / 255.;
  vec3 colInner = vec3(24., 32., 38.) / 255.;
  vec3 colOuter = vec3(16., 22., 26.) / 255.;
  // vec3 colBg = mix(colInner, colOuter, lerpAmount * 2.);
  vec3 colBg = colOuter;

  vec3 colPerson = vec3(72., 175., 240.) / 255.;

  // vec3 col = isInside ? colPerson : colBg;
  vec3 col = colBg;

  vec4 sum = (8.0 * col4 - (col0 + col1 + col2 + col3 + col5 + col6 + col7 + col8)) * 1.;
  gl_FragColor = vec4(sum.rgb, 1.0) * vertColor + vec4(col, 1.0);
}
