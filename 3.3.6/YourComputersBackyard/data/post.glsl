#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform float time;
uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

// https://github.com/armory3d/armory/blob/master/Shaders/std/tonemap.glsl

// Based on Filmic Tonemapping Operators http://filmicgames.com/archives/75
vec3 tonemapFilmic(const vec3 color) {
    vec3 x = max(vec3(0.0), color - 0.004);
    return (x * (6.2 * x + 0.5)) / (x * (6.2 * x + 1.7) + 0.06);
}

// https://knarkowicz.wordpress.com/2016/01/06/aces-filmic-tone-mapping-curve/
vec3 acesFilm(const vec3 x) {
    const float a = 2.51;
    const float b = 0.03;
    const float c = 2.43;
    const float d = 0.59;
    const float e = 0.14;
    return clamp((x * (a * x + b)) / (x * (c * x + d ) + e), 0.0, 1.0);
}

float vignette() {
    // https://github.com/mattdesl/lwjgl-basics/wiki/ShaderLesson3
    vec2 position = vertTexCoord.xy - vec2(0.5);

    //determine the vector length of the center position
    float len = length(position);

    //use smoothstep to create a smooth vignette
    float RADIUS = 0.75;
    float SOFTNESS = 0.45;
    float vignette = smoothstep(RADIUS, RADIUS-SOFTNESS, len);

    return vignette;
}

vec2 barrelDistortion(vec2 coord, float amt) {
    vec2 cc = coord - 0.5;
    float dist = dot(cc, cc);
    return coord + cc * dist * amt;
}

float sat( float t )
{
    return clamp( t, 0.0, 1.0 );
}

float linterp( float t ) {
    return sat( 1.0 - abs( 2.0*t - 1.0 ) );
}

float remap( float t, float a, float b ) {
    return sat( (t - a) / (b - a) );
}

vec4 spectrum_offset( float t ) {
    vec4 ret;
    float lo = step(t,0.5);
    float hi = 1.0-lo;
    float w = linterp( remap( t, 1.0/6.0, 5.0/6.0 ) );
    ret = vec4(lo,1.0,hi, 1.) * vec4(1.0-w, w, 1.0-w, 1.);

    return pow( ret, vec4(1.0/2.2) );
}

vec3 chromaticAbberation() {
    const float max_distort = 0.2;
    const int num_iter = 12;
    const float reci_num_iter_f = 1.0 / float(num_iter);

    vec2 uv=(vertTexCoord.xy*.9)+.05;
    // vec2 uv = vertTexCoord.xy;

    vec4 sumcol = vec4(0.0);
    vec4 sumw = vec4(0.0);
    for ( int i=0; i<num_iter;++i )
    {
        float t = float(i) * reci_num_iter_f;
        vec4 w = spectrum_offset( t );
        sumw += w;
        sumcol += w * texture2D( texture, barrelDistortion(uv, .6 * max_distort*t ) );
    }

    return (sumcol / sumw).rgb;
}

float random(vec2 n, float offset ){
    return .5 - fract(sin(dot(n.xy + vec2(offset, 0.), vec2(12.9898, 78.233)))* 43758.5453);
}



void main(void) {
    // chromatic abberation
    vec3 totalColor = chromaticAbberation();

    // bit of vignetting
    float vignetteAmount = vignette();
    totalColor = mix(totalColor, totalColor * vignetteAmount, 0.5);

    // noise
    totalColor += 0.02 * random(vertTexCoord.xy, 1 + time * 0.001);

    // tonemapping
    totalColor = tonemapFilmic(totalColor);

    gl_FragColor = vec4(totalColor, 1.0);
}
