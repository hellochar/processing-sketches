#version 410

uniform mat4 transformMatrix;
uniform sampler2D heightMap;
uniform mat4 texMatrix;

in vec4 position;
in vec4 color;
in vec3 normal;
in vec2 texCoord;

out VertexData {
  vec4 position;
  vec4 color;
  vec3 normal;
  vec2 texCoord;
} vData;

void main() {
  vec2 st = (texMatrix * vec4(texCoord, 1.0, 1.0)).st;
  float h = 5 * texture(heightMap, st).r;
  vData.position = vec4(position.xy, h, 1);
  vData.color = color;
  vData.normal = normal;  
  vData.texCoord = texCoord;
}