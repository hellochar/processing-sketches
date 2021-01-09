#version 410

layout (triangles) in;
layout (line_strip, max_vertices = 2) out;
 
uniform mat4 projectionMatrix;
 
in TessEvalData {
  vec4 color;
  vec4 texCoord;
  vec3 position;
  vec3 normal;
  vec3 lightDir;
} teData[3];

out vec4 gColor;
 
void ProduceEdge(vec3 v1, vec3 v2) {
  gl_Position = projectionMatrix * vec4(v1, 1);
  gColor = vec4(0, 1, 0, 1);
  EmitVertex();
  
  gl_Position = projectionMatrix * vec4(v2, 1);
  gColor = vec4(0, 1, 0, 1);
  EmitVertex();
} 
 
void main() {
  ProduceEdge(teData[0].position, teData[1].position);
  EndPrimitive();

  ProduceEdge(teData[0].position, teData[2].position);
  EndPrimitive();
  
  ProduceEdge(teData[1].position, teData[2].position);
  EndPrimitive();
}