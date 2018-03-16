uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;

uniform vec4 lightPosition;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;

varying vec4 worldPosition;
varying vec3 modelViewPosition;
varying vec3 ecNormal;
varying vec3 untransformedNormal;
varying vec4 vertColor;
varying vec3 lightDirection;
varying vec3 test;

/* void main() { */
/*   gl_Position = transform * position; */
/*   modelViewPosition = vec3(modelview * position); */
/*   ecNormal = normalize(normalMatrix * normal); */
/*   untransformedNormal = normal; // for some reason these two are the same?! */
/*  */
/*   vec3 direction = normalize(lightPosition.xyz - modelViewPosition); */
/*   float intensity = max(0.0, dot(direction, ecNormal)); */
/*   vertColor = vec4(intensity, intensity, intensity, 1) * color; */
/* } */
/*  */
/*  */

void main() {
  gl_Position = transform * position;
  vec3 ecPosition = vec3(modelview * position);
  vec3 ecNormal = normalize(normalMatrix * normal);

  vec3 direction = normalize(lightPosition.xyz - ecPosition);
  /* float intensity = max(0.0, dot(direction, ecNormal)); */
  /* vertColor = vec4(intensity, intensity, intensity, 1) * color; */
  modelViewPosition = ecPosition;
  lightDirection = direction;
  worldPosition = position;
  test = vec3(1, 0, 1);
}
