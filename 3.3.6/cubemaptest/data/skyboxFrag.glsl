#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

varying vec4 worldPosition;
varying vec3 modelViewPosition;
varying vec3 ecNormal;
varying vec3 untransformedNormal;
varying vec4 vertColor;
varying vec3 lightDirection;
varying vec3 test;

void main() {
    /* gl_FragColor = vec4(normalize(worldPosition.xyz / worldPosition.w), 1); */
    /* gl_FragColor = vec4(normalize(worldPosition), 1); */
    /* gl_FragColor = vec4(normalize(untransformedNormal), 1); */
    /* gl_FragColor = vertColor; */
    /* gl_FragColor = vec4(modelViewPosition, 1); */
    /* gl_FragColor = vec4(lightDirection, 1); */
    /* gl_FragColor = vec4(vec3(worldPosition), 1); */
    gl_FragColor = vec4(test, 1);
}
