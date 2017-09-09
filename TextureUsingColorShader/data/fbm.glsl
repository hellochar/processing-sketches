#define PROCESSING_COLOR_SHADER

uniform vec2 resolution;
uniform vec2 mousePositions[100];
uniform float count;

uniform vec2 mouse;

uniform sampler2D image;

void main() {
    /*gl_FragCoord is the vec4 holding the position (only xy are relevant)*/
    // complete program 1:
        /*gl_FragColor = vec4(vec3(0), 1);*/

    // complete program 2:
    float val = 0;
    for(int i = 0; i < count; i++) {
        float len = length(gl_FragCoord.xy - mousePositions[i]);
        val += sin(len / mix(1, 20, mouse.x / resolution.x));
    }
    /*val = clamp(val, 0, 1);*/

    //texture shader 1:
    gl_FragColor = vec4(
            val * vec3(texture2D(image, vec2(gl_FragCoord.x, resolution.y - gl_FragCoord.y) / resolution).rgb),
            1);

    //shader:
    /*gl_FragColor = step(.05, 1) * gl_FragColor;*/
}

