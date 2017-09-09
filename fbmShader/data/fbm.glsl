#define PROCESSING_COLOR_SHADER
//
// GLSL textureless classic 2D noise "cnoise",
// with an RSL-style periodic variant "pnoise".
// Author:  Stefan Gustavson (stefan.gustavson@liu.se)
// Version: 2011-08-22
//
// Many thanks to Ian McEwan of Ashima Arts for the
// ideas for permutation and gradient selection.
//
// Copyright (c) 2011 Stefan Gustavson. All rights reserved.
// Distributed under the MIT license. See LICENSE file.
// https://github.com/ashima/webgl-noise
//

vec4 mod289(vec4 x)
{
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 permute(vec4 x)
{
  return mod289(((x*34.0)+1.0)*x);
}

vec4 taylorInvSqrt(vec4 r)
{
  return 1.79284291400159 - 0.85373472095314 * r;
}

vec2 fade(vec2 t) {
  return t*t*t*(t*(t*6.0-15.0)+10.0);
}

// Classic Perlin noise
float cnoise(vec2 P)
{
  vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
  vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
  Pi = mod289(Pi); // To avoid truncation effects in permutation
  vec4 ix = Pi.xzxz;
  vec4 iy = Pi.yyww;
  vec4 fx = Pf.xzxz;
  vec4 fy = Pf.yyww;

  vec4 i = permute(permute(ix) + iy);

  vec4 gx = fract(i * (1.0 / 41.0)) * 2.0 - 1.0 ;
  vec4 gy = abs(gx) - 0.5 ;
  vec4 tx = floor(gx + 0.5);
  gx = gx - tx;

  vec2 g00 = vec2(gx.x,gy.x);
  vec2 g10 = vec2(gx.y,gy.y);
  vec2 g01 = vec2(gx.z,gy.z);
  vec2 g11 = vec2(gx.w,gy.w);

  vec4 norm = taylorInvSqrt(vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
  g00 *= norm.x;  
  g01 *= norm.y;  
  g10 *= norm.z;  
  g11 *= norm.w;  

  float n00 = dot(g00, vec2(fx.x, fy.x));
  float n10 = dot(g10, vec2(fx.y, fy.y));
  float n01 = dot(g01, vec2(fx.z, fy.z));
  float n11 = dot(g11, vec2(fx.w, fy.w));

  vec2 fade_xy = fade(Pf.xy);
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
  float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}

// Classic Perlin noise, periodic variant
float pnoise(vec2 P, vec2 rep)
{
  vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
  vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
  Pi = mod(Pi, rep.xyxy); // To create noise with explicit period
  Pi = mod289(Pi);        // To avoid truncation effects in permutation
  vec4 ix = Pi.xzxz;
  vec4 iy = Pi.yyww;
  vec4 fx = Pf.xzxz;
  vec4 fy = Pf.yyww;

  vec4 i = permute(permute(ix) + iy);

  vec4 gx = fract(i * (1.0 / 41.0)) * 2.0 - 1.0 ;
  vec4 gy = abs(gx) - 0.5 ;
  vec4 tx = floor(gx + 0.5);
  gx = gx - tx;

  vec2 g00 = vec2(gx.x,gy.x);
  vec2 g10 = vec2(gx.y,gy.y);
  vec2 g01 = vec2(gx.z,gy.z);
  vec2 g11 = vec2(gx.w,gy.w);

  vec4 norm = taylorInvSqrt(vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
  g00 *= norm.x;  
  g01 *= norm.y;  
  g10 *= norm.z;  
  g11 *= norm.w;  

  float n00 = dot(g00, vec2(fx.x, fy.x));
  float n10 = dot(g10, vec2(fx.y, fy.y));
  float n01 = dot(g01, vec2(fx.z, fy.z));
  float n11 = dot(g11, vec2(fx.w, fy.w));

  vec2 fade_xy = fade(Pf.xy);
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
  float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}

float fbm(vec2 p) {
  int octaves = 4;
  float scalar = 0.5;
  float sum = 0;
  for(int i = 0; i < octaves; i++) {
    sum += scalar * cnoise(p*pow(2, i));
    scalar *= 0.5;
  }
  return sum;
}

uniform vec2 resolution;
uniform vec2 mouse;
uniform int millis;

uniform sampler2D image;

// p [0..3, 0..3]
float pattern(vec2 p, out vec2 lvl2, out vec2 lvl1) {
    vec2 lvl3 = p;
    float fbm3 = fbm(lvl3) / 5;
    lvl2 = p + fbm3 + vec2(millis / 4295., millis / 9591.);
    float fbm2 = fbm(lvl2);
    //lvl1 in [0..3, 0..3] + [-1..1, -1..1]
    lvl1 = p + fbm2 + mouse/resolution;
    float fbm1 = fbm(lvl1);
    return fbm1;
}

void main() {

    vec2 scalar = vec2(3);
    /*gl_FragCoord is the vec4 holding the position (only xy are relevant)*/
    // complete program 1:
        /*gl_FragColor = vec4(vec3(0), 1);*/

    // complete program 2:
    /*float val = 0;*/
    /*for(int i = 0; i < count; i++) {*/
    /*    float len = length(gl_FragCoord.xy - mousePositions[i]);*/
    /*    val += sin(len / mix(1, 20, mouse.x / resolution.x));*/
    /*}*/
    /*val = clamp(val, 0, 1);*/

    //texture shader 1:
    /*gl_FragColor = vec4(*/
    /*        val * vec3(texture2D(image, vec2(gl_FragCoord.x, resolution.y - gl_FragCoord.y) / resolution).rgb),*/
    /*        1);*/

    //shader:
    /*gl_FragColor = step(.05, 1) * gl_FragColor;*/

    vec2 lvl2, lvl1;

    float value = pattern(gl_FragCoord.xy / vec2(500, 500) * scalar, lvl2, lvl1);

    /*gl_FragColor = vec4((1+vec3(value))/2, 1);*/
    gl_FragColor = texture2D(image, lvl1 / 5.0);
    /*gl_FragColor = vec4(value, lvl2, 1);*/
    /*gl_FragColor = vec4(value, lvl2, 1);*/
    /*gl_FragColor = vec4(value, fbm3, fbm2, 1);*/
    /*gl_FragColor = vec4(.5 * vec3(1+value/2) + .5 * vec3(fbm3, fbm2, 0), 1);*/
    /*gl_FragColor*/
}

