// colors.glsl - an iterative shader that modifies the last color a little bit


//default Processing variables
uniform mat4 modelviewMatrix;
uniform mat4 transformMatrix;
uniform mat3 normalMatrix;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;

uniform sampler2D ppixels;


// my variables
uniform float millis;

float random() {
    return mod(fract(sin(dot(position + millis * 0.001, vec2(14.9898,78.233))) * 43758.5453), 1.0);
}

void main( void ) {
    vec4 color = vec4(random(), 0, 0, 1);

    gl_FragColor = color;
}
