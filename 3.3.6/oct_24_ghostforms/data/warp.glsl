#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform vec2 u_mouse;
uniform float u_time;

float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))
                 * 43758.5453123);
}

vec2 random2(in vec2 st) {
    return normalize(vec2(
        random(st * vec2(42.9401, 941.2301) + vec2(-9534.1, 41.4394)) * 2. - 1.,
    	random(st * vec2(-456.321, 14.6943) + vec2(-585.456, 14.658)) * 2. - 1.
    ));
}

float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = smoothstep(0., 1., f);

    return mix(
        	mix(a, b, u.x),
        	mix(c, d, u.x),
        	u.y
    );
}

vec2 noise2 (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    vec2 a = random2(i);
    vec2 b = random2(i + vec2(1.0, 0.0));
    vec2 c = random2(i + vec2(0.0, 1.0));
    vec2 d = random2(i + vec2(1.0, 1.0));

    vec2 u = smoothstep(0., 1., f);

    return mix(
        	mix(a, b, u.x),
        	mix(c, d, u.x),
        	u.y
    );
}

vec2 octaveNoise2(in vec2 st) {
    const int octaves = 6;
    vec2 samplePoint = st;
    float falloff = 0.5;
    float amplitude = 1.;
    vec2 sum = vec2(0.);
    for (int i = 0; i < octaves; i++) {
        sum += noise2(samplePoint) * amplitude;
        amplitude *= falloff;
        samplePoint = vec2(23.592, 504.2491) + samplePoint / falloff;
    }
    // totalAmplitude*scalar = 1; totalAmplitude = 1 / (1 - r), where r = falloff
    // scalar / (1 - r) = 1 -> scalar = (1 - r)
    float amplitudeScalar = 1. - falloff;
    return sum * amplitudeScalar;
}

float octaveNoise(in vec2 st) {
    const int octaves = 6;
    vec2 samplePoint = st;
    float falloff = 0.5;
    float amplitude = 1.;
    float sum = 0.;
    for (int i = 0; i < octaves; i++) {
        sum += noise(samplePoint) * amplitude;
        amplitude *= falloff;
        samplePoint = vec2(23.592, 504.2491) + samplePoint / falloff;
    }
    // totalAmplitude*scalar = 1; totalAmplitude = 1 / (1 - r), where r = falloff
    // scalar / (1 - r) = 1 -> scalar = (1 - r)
    float amplitudeScalar = 1. - falloff;
    return sum * amplitudeScalar;
}

// the idea is to use the output of the noise function to modify the input to a noise function
float noiseWarpingNoise(in vec2 st) {
    float noisyValue = octaveNoise(st * u_mouse.x * 10.) * u_mouse.y * 10.;
    return octaveNoise(vec2(noisyValue) + st);
}

float noiseWarpingNoise2(in vec2 st) {
    float noisyValue = octaveNoise(st * u_mouse.x * 10.) * u_mouse.y * 10.;
    float noisyValue2 = octaveNoise((vec2(noisyValue) + st) * u_mouse.x * 10.) * u_mouse.y * 10.;
    float noisyValue3 = octaveNoise(vec2(noisyValue2) + st);
    return noisyValue3;
}

float noise2WarpingNoise(in vec2 st) {
    vec2 noisy2Value = octaveNoise2(st * u_mouse.x * 10.) * u_mouse.y * 10.;
    float noisyValue2 = octaveNoise(noisy2Value + st);
    return noisyValue2;
}

vec2 iterativeNoise2WarpingNoise(in vec2 st, in vec2 offset) {
    const int iterations = 3;
    vec2 noisy2Value = vec2(u_time / 100.0);
    float scalarInput = u_mouse.x * 0.1;
    float scalarValue = u_mouse.y * 2.;
    for (int i = 0; i < iterations; i++) {
        vec2 v = (st + noisy2Value) * (1. + scalarInput);
        noisy2Value = octaveNoise2(v) * scalarValue + offset;
    }
    return noisy2Value;
}

vec2 warp(in vec2 uv) {
    /* vec2 duv = sin(uv + u_time / 100.0) * 0.25; */
    vec2 duv = vec2(0.);
    return uv + duv;
}

void main() {
  vec2 uv = warp(vertTexCoord.st);
  /* uv -= vec2(0.5, 0.5); */
  vec2 warpedUv1 = iterativeNoise2WarpingNoise(uv, vec2(0.));
  vec2 warpedUv2 = iterativeNoise2WarpingNoise(uv, vec2(0.004));
  vec2 warpedUv3 = iterativeNoise2WarpingNoise(uv, vec2(0.008));

  vec4 col1 = texture2D(texture, uv + warpedUv1 * 0.5);
  vec4 col2 = texture2D(texture, uv + warpedUv2 * 0.5);
  vec4 col3 = texture2D(texture, uv + warpedUv3 * 0.5);

  vec4 col = vec4(col1.r, col2.g, col3.b, 1.0);
  gl_FragColor = col;
}

/* void main() { */
/*     vec2 st = gl_FragCoord.xy/u_resolution.xy; */
/*     st.x *= u_resolution.x/u_resolution.y; */
/*     st -= vec2(0.5, 0.5); */
/*  */
/*     vec3 color = vec3(0.); */
/*     // color = vec3(noiseWarpingNoise(st * 10.)); */
/*     // color = vec3(noise2WarpingNoise(st * 10.)); */
/*     float r = length(iterativeNoise2WarpingNoise(st, vec2(0.))); */
/*     float g = length(iterativeNoise2WarpingNoise(st, vec2(0.005, 0.005))); */
/*     float b = length(iterativeNoise2WarpingNoise(st, vec2(0.01, 0.01))); */
/*     color = vec3(r, g, b); */
/*     color = pow(color, vec3(2.)); */
/*  */
/*     gl_FragColor = vec4(color,1.0); */
/* } */
/*  */
/* void main(void) { */
/*   vec2 uv = vertTexCoord.st; */
/*   vec2 warpedUv = warp(uv); */
/*  */
/*   vec4 col = texture2D(texture, warpedUv); */
/*  */
/*   gl_FragColor = col; */
/* } */
