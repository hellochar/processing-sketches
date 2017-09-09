#define PROCESSING_LIGHT_SHADER

varying vec4 vertColor;
varying vec4 vertPos;

void main() {
    /*gl_FragColor = vertColor;*/
    gl_FragColor.xyz = vertPos.xyz / 100;
    gl_FragColor.a = 1;
}
