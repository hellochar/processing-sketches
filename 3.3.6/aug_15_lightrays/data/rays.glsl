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

void main(void) {
    vec2 uv = vertTexCoord.st;
    vec4 t0 = texture2D(texture, uv);

    vec3 lightrayColor;
    for (float i = 0.0; i < 1.0; i += 0.1) {
        vec2 uv2 = mix(uv, vec2(0.5), i);
        vec4 tex = texture2D(texture, uv2);
        lightrayColor += tex.rgb;
    }
    lightrayColor /= 10.;
    vec3 totalColor = t0.rgb + lightrayColor;
    gl_FragColor = vec4(totalColor, 1.0);
}

