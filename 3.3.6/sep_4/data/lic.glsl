// line integral convolution

#ifdef GL_ES
precision highp float;
#endif

#define PROCESSING_TEXTURE_SHADER

#define PI (3.14159265)

uniform float time;
uniform vec2 mouse;
uniform sampler2D texture;
uniform sampler2D source;
uniform vec2 texOffset;
varying vec4 vertTexCoord;

//	Simplex 3D Noise 
//	by Ian McEwan, Ashima Arts
//
vec4 permute(vec4 x){return mod(((x*34.0)+1.0)*x, 289.0);}
vec4 taylorInvSqrt(vec4 r){return 1.79284291400159 - 0.85373472095314 * r;}

float snoise(vec3 v){ 
  const vec2  C = vec2(1.0/6.0, 1.0/3.0) ;
  const vec4  D = vec4(0.0, 0.5, 1.0, 2.0);

// First corner
  vec3 i  = floor(v + dot(v, C.yyy) );
  vec3 x0 =   v - i + dot(i, C.xxx) ;

// Other corners
  vec3 g = step(x0.yzx, x0.xyz);
  vec3 l = 1.0 - g;
  vec3 i1 = min( g.xyz, l.zxy );
  vec3 i2 = max( g.xyz, l.zxy );

  //  x0 = x0 - 0. + 0.0 * C 
  vec3 x1 = x0 - i1 + 1.0 * C.xxx;
  vec3 x2 = x0 - i2 + 2.0 * C.xxx;
  vec3 x3 = x0 - 1. + 3.0 * C.xxx;

// Permutations
  i = mod(i, 289.0 ); 
  vec4 p = permute( permute( permute( 
             i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
           + i.y + vec4(0.0, i1.y, i2.y, 1.0 )) 
           + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));

// Gradients
// ( N*N points uniformly over a square, mapped onto an octahedron.)
  float n_ = 1.0/7.0; // N=7
  vec3  ns = n_ * D.wyz - D.xzx;

  vec4 j = p - 49.0 * floor(p * ns.z *ns.z);  //  mod(p,N*N)

  vec4 x_ = floor(j * ns.z);
  vec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)

  vec4 x = x_ *ns.x + ns.yyyy;
  vec4 y = y_ *ns.x + ns.yyyy;
  vec4 h = 1.0 - abs(x) - abs(y);

  vec4 b0 = vec4( x.xy, y.xy );
  vec4 b1 = vec4( x.zw, y.zw );

  vec4 s0 = floor(b0)*2.0 + 1.0;
  vec4 s1 = floor(b1)*2.0 + 1.0;
  vec4 sh = -step(h, vec4(0.0));

  vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;
  vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;

  vec3 p0 = vec3(a0.xy,h.x);
  vec3 p1 = vec3(a0.zw,h.y);
  vec3 p2 = vec3(a1.xy,h.z);
  vec3 p3 = vec3(a1.zw,h.w);

//Normalise gradients
  vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
  p0 *= norm.x;
  p1 *= norm.y;
  p2 *= norm.z;
  p3 *= norm.w;

// Mix final noise value
  vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
  m = m * m;
  return 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1), 
                                dot(p2,x2), dot(p3,x3) ) );
}

highp float random(vec2 co)
{
    highp float a = 12.9898;
    highp float b = 78.233;
    highp float c = 43758.5453;
    highp float dt= dot(co.xy ,vec2(a,b));
    highp float sn= mod(dt,3.14);
    return fract(sin(sn) * c);
}

float sigmoid(float x) {
    return 1. / (1. + exp(-x * 6.));
}

mat2 rot(float a) {
    return mat2(cos(a), -sin(a), sin(a), cos(a));
}

vec2 fieldSin(vec2 xy, vec2 c, float hz) {
    vec2 o = xy - c;
    float d = length(o);
    vec2 dir = normalize(o);
    float mag = sin(d * hz + time);
    return dir * mag;
}

vec2 fieldTan(vec2 xy, vec2 c) {
    vec2 o = xy - c;
    float off = 0.1;
    float ang = atan(o.x, o.y) + off;
    return vec2(cos(ang), sin(ang));
}

vec2 fieldTwist(vec2 xy, vec2 c, float scale) {
    vec2 o = xy - c;
    float ang = atan(o.y, o.x) + time;
    return vec2(cos(ang*scale), sin(ang*scale));
}

vec2 fieldNoise(vec2 xy, float s) {
    return vec2(
            snoise(vec3(xy * s, time)) - 0.5,
            snoise(vec3(xy * s, time + 5.)) - 0.5
            );
}

vec2 fieldRot(vec2 xy, vec2 c) {
    return (xy - c) * rot(PI / 2);
}

vec2 vectorField(vec2 xy) {
    return
        vec2(0.)
        + fieldSin(xy, vec2(0.25, 0.25), 1.) * 2.
        + fieldRot(xy, vec2(-0.25, 0.)) * 0.1
        + fieldTwist(xy, vec2(0.0, 0.), 4.) * 2.
        /* + fieldTwist(xy, vec2(0.25, 0.5), 3.) */
        /* + fieldNoise(xy, 0.2) */
        ;
}

const float UVMULT = 10.;

// xy = (uv - 0.5) * 2 / 10.
// uv = (xy * 10.) / 2 + 0.5
vec2 uv2xy(vec2 uv) {
    return ((uv - 0.5) * 2.) * UVMULT;
}

vec2 xy2uv(vec2 xy) {
    return (xy / UVMULT) / 2. + 0.5;
}

vec3 color(vec2 uv) {
    return vec3(random(uv));
}

void main( void ) {
    vec2 uv = vertTexCoord.st;
    vec2 xy = uv2xy(uv);
    vec3 col = vec3(0.);
    int NUM_SAMPLES = 50;
    for (int i = 0; i < NUM_SAMPLES; i++) {
        /* col += color(tuv); // texture2D(source, tuv).rgb; */
        vec2 dxy = vectorField(xy) * 0.01;
        xy += dxy;
        vec2 tuv = xy2uv(xy);
        col += texture2D(source, tuv).rgb;
    }
    col /= float(NUM_SAMPLES);

    /* col += texture2D(texture, uv).rgb * 0.9; */

    // col = color(uv);
    gl_FragColor = vec4(col, 1.);
}
