//===== supplied by Processing
uniform mat4 projection;
uniform mat4 transform;
attribute vec4 position;
attribute vec4 color;
attribute vec2 offset;
//==================

void main() {
    // I just need to fill gl_Position; I can choose to fill any varyings here too
    gl_Position = vec4(0.25, 0.25, 0., 1.);
    /* gl_PointSize = 10.; */
}
