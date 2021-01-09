#version 410

layout(triangles, fractional_odd_spacing, ccw) in;

uniform sampler2D heightMap;
uniform mat4 modelviewMatrix;
uniform mat4 transformMatrix;
uniform mat3 normalMatrix;
uniform mat4 texMatrix;

uniform vec4 lightPosition;

in VertexData {
  vec4 position;
  vec4 color;
  vec3 normal;
  vec2 texCoord;
} tcData[];

out TessEvalData {
  vec4 color;
  vec4 texCoord;
  vec3 position;
  vec3 normal;
  vec3 lightDir;
} teData;

void main(){
  // In the case of a triangle patch, the values xyz of gl_TessCoord are the barycentric 
  // coordinates of the tessellated position.
  float f0 = gl_TessCoord.x;
  float f1 = gl_TessCoord.y;
  float f2 = gl_TessCoord.z;
  
  vec4 pos = f0 * tcData[0].position + f1 * tcData[1].position + f2 * tcData[2].position;
  vec4 color = f0 * tcData[0].color + f1 * tcData[1].color + f2 * tcData[2].color;
  vec3 normal = normalize(f0 * tcData[0].normal + f1 * tcData[1].normal + f2 * tcData[2].normal);
  vec2 tcoord2 = f0 * tcData[0].texCoord + f1 * tcData[1].texCoord + f2 * tcData[2].texCoord; 
  vec4 tcoord4 = texMatrix * vec4(tcoord2, 1.0, 1.0);
  float h = 5 * texture(heightMap, tcoord4.st).r;
  vec4 dispPos = vec4(pos.xy, h, 1);
   
  teData.color = color;
  teData.texCoord = tcoord4;
  teData.position = vec3(modelviewMatrix * dispPos);  
  teData.normal = normalize(normalMatrix * normal);
  teData.lightDir = normalize(lightPosition.xyz - teData.position);
  
  gl_Position = transformMatrix * dispPos; 
}
