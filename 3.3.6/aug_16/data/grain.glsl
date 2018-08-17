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

float random(vec2 n, float offset ){
    return .5 - fract(sin(dot(n.xy + vec2(offset, 0.), vec2(12.9898, 78.233)))* 43758.5453);
}

void main(void) {
    vec2 uv = vertTexCoord.xy;
    vec3 totalColor = texture2D(texture, uv).rgb;

    float freq = 200;
    float ratio = texOffset.y / texOffset.x;
    vec2 fuv = floor(uv * vec2(ratio, 1.) * freq) / freq;

    // noise
    totalColor -= 0.05 * random(fuv, 0.001);

    // checkering
    // totalColor += 1.25 * pow(sin(dot(fuv, vec2(1.)) * freq * 3.14), 2.);

    gl_FragColor = vec4(totalColor, 1.0);
}
