// fragment shader

// supplied by Processing
uniform sampler2D texture;
uniform vec2 texOffset;
varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform vec2 u_mouse;
uniform float amt;

const int radius = 10;

void main() {
    float lengthToMouse = length(u_mouse - vertTexCoord.st);
    vec4 bloomAmount = vec4(0.);
    for(int dx = -radius; dx <= radius; dx++) {
        for(int dy = -radius; dy <= radius; dy++) {
            vec4 c = texture2D(texture, vertTexCoord.st + texOffset * vec2(dx, dy));
            bloomAmount += pow(c, vec4(2.));
        }
    }
    // goes from 0 to 1
    bloomAmount /= radius * radius;
    bloomAmount *= amt;
    /* bloomAmount /= (.1 + lengthToMouse); */
    vec4 c = texture2D(texture, vertTexCoord.st);
    gl_FragColor = pow(c / (.5 + lengthToMouse) + log(vec4(1.) + bloomAmount) / log(vec4(3.)) + vec4(0.1), vec4(1.0));
}
