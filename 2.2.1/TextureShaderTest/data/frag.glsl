#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

void main() {

    gl_FragCoord is the vec4 holding the position (only xy are relevant)
    gl_FragColor = ...
}
