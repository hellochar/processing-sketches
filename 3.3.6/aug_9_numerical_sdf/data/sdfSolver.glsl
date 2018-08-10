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
uniform bool diags;

void main( void ) {
    vec2 uv = vertTexCoord.st;
    vec4 sourcePixel = texture2D(source, uv);
    if (length(sourcePixel.rgb) > 0.) {
        gl_FragColor = sourcePixel;
    } else {
        // so, we want to compute the new sdf value. We have:
        // texture, the previous values
        // we're just max of me and (my neighbors - 1)
        vec3 s = vec3(1. / 255.);
        vec3 s2 = s * sqrt(2.);

        vec4 me = texture2D(texture, uv);
        vec3 newValue = me.rgb;

        if (diags) {
            vec4 ld = texture2D(texture, uv + texOffset * vec2(-1., -1.));
            vec4 lu = texture2D(texture, uv + texOffset * vec2(-1., 1.));
            vec4 rd = texture2D(texture, uv + texOffset * vec2(1., -1.));
            vec4 ru = texture2D(texture, uv + texOffset * vec2(1., 1.));
            newValue = max(newValue, ld.rgb - s2);
            newValue = max(newValue, lu.rgb - s2);
            newValue = max(newValue, rd.rgb - s2);
            newValue = max(newValue, ru.rgb - s2);
        } else {
            vec4 l = texture2D(texture, uv + texOffset * vec2(-1., 0.));
            vec4 r = texture2D(texture, uv + texOffset * vec2(1., 0.));
            vec4 d = texture2D(texture, uv + texOffset * vec2(0., -1.));
            vec4 u = texture2D(texture, uv + texOffset * vec2(0., 1.));
            newValue = max(newValue, l.rgb - s);
            newValue = max(newValue, r.rgb - s);
            newValue = max(newValue, d.rgb - s);
            newValue = max(newValue, u.rgb - s);
        }

        gl_FragColor = vec4(vec3(newValue), 1.);
    }
}
