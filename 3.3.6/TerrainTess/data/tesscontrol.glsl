#version 410

layout(vertices = 3) out;

#define id gl_InvocationID

uniform mat4 transformMatrix;
uniform vec2 resolution;
uniform float lodFactor;
uniform bool cullGeometry;

in VertexData {
  vec4 position;
  vec4 color;
  vec3 normal;
  vec2 texCoord;
} vData[];

out VertexData {
  vec4 position;
  vec4 color;
  vec3 normal;
  vec2 texCoord;
} tcData[];

bool offscreen(vec4 vertex) {
  if (cullGeometry) {
    return any(lessThan(vertex.xy, vec2(-1.7))) ||
           any(greaterThan(vertex.xy, vec2(1.7)));
  } else {
    return false;
  }
}
    
vec4 project(vec4 vertex) {
  vec4 result = transformMatrix * vertex;
  result /= result.w;
  return result;
}

vec2 screenSpace(vec4 vertex) {
  return (clamp(vertex.xy, -1.3, 1.3) + 1) * (resolution * 0.5);
}

float level(vec2 v0, vec2 v1) {
  return clamp(distance(v0, v1) / lodFactor, 1, 64);
}

void main() {
  // IMPORTANT: even though the elements of tcData and vData are of the same 
  // type, VertexData in this case, they cannot be assigned directly one into
  // the other:
  // tcData[id] = vData[id] 
  // Each field has to be assigned individually:
  tcData[id].position = vData[id].position;
  tcData[id].color = vData[id].color;
  tcData[id].normal = vData[id].normal;
  tcData[id].texCoord = vData[id].texCoord;
    
  if (id == 0) {
    // Dynamic LOD calculation:
    vec4 v0 = project(vData[0].position);
    vec4 v1 = project(vData[1].position);
    vec4 v2 = project(vData[2].position);
 
    if(all(bvec3(offscreen(v0), offscreen(v1), offscreen(v2)))) {
      // All vertices defining this patch are outside the viewing volume,
	  // so setting the tessellation levels to zero effectively discards it.
	  gl_TessLevelInner[0] = 0;
      gl_TessLevelOuter[0] = 0;
      gl_TessLevelOuter[1] = 0;
      gl_TessLevelOuter[2] = 0;
    } else { 
	  vec2 ss0 = screenSpace(v0);
	  vec2 ss1 = screenSpace(v1);
	  vec2 ss2 = screenSpace(v2);

	  float e0 = level(ss1, ss2);
	  float e1 = level(ss0, ss1);
	  float e2 = level(ss0, ss2);

	  int lod = int(e0/3 + e1/3 + e2/3);
	  
      gl_TessLevelInner[0] = lod;
	  // Order here of e0, e1 and e2 is important!
	  gl_TessLevelOuter[0] = e0;
	  gl_TessLevelOuter[1] = e2;
	  gl_TessLevelOuter[2] = e1;
	} 
  }
}
