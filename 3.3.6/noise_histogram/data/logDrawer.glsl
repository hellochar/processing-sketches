
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define COUNTS_MAX_WIDTH 1920
#define COUNTS_MAX_HEIGHT 1080

uniform float countsMax;
uniform vec2 resolution; // resolution of the screen in pixel space

void main() {
    float logScalar = 255 / log(countsMax);
    float width = resolution.y;
    float x = gl_FragCoord.x;
    float y = gl_FragCoord.y;
    int i = int(floor(y*width+x));
    gl_FragColor = vec4(logScalar * log(vec3(countR[i], countG[i], countB[i])), 1.0);
}

