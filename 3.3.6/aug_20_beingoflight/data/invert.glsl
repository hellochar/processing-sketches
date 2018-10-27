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

void main(void) {
    vec4 color = texture2D(texture, vertTexCoord.st);
    gl_FragColor = vec4(1.0 - color.rgb, 1.0);
}

