// Conway's game of life

#ifdef GL_ES
precision highp float;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform float time;
uniform vec2 mouse;
uniform sampler2D texture; // previous pixels
uniform sampler2D source;
uniform vec2 texOffset;
varying vec4 vertTexCoord;

void main( void ) {
    vec2 uv = vertTexCoord.st;
    vec4 sourcePixel = texture2D(source, uv);
    if (length(sourcePixel.rgb) > 0.) {
        gl_FragColor = sourcePixel;
    } else {
        // so, we want to compute the new sdf value. We have:
        // texture, the previous values
        // we're just max of me and (my neighbors - 1)
        vec4 left = texture2D(texture, uv + texOffset * vec2(-1., 0.));
        vec4 right = texture2D(texture, uv + texOffset * vec2(1., 0.));
        vec4 down = texture2D(texture, uv + texOffset * vec2(0., -1.));
        vec4 up = texture2D(texture, uv + texOffset * vec2(0., 1.));
        // max = max(max, texture2D(texture, uv + texOffset * vec2(-1., -1.)).g);
        // max = max(max, texture2D(texture, uv + texOffset * vec2(-1., 1.)).g);
        // max = max(max, texture2D(texture, uv + texOffset * vec2(1., -1.)).g);
        // max = max(max, texture2D(texture, uv + texOffset * vec2(1., 1.)).g);
        vec4 me = texture2D(texture, uv);

        float s = 1. / 255.;
        float newValue = me.r - s;
        newValue = max(newValue, left.r - s);
        newValue = max(newValue, right.r - s);
        newValue = max(newValue, down.r - s);
        newValue = max(newValue, up.r - s);

        gl_FragColor = vec4(vec3(newValue), 1.);
    }
}
