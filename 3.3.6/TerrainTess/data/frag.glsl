#version 410

uniform sampler2D heightMap;
uniform float bumpScale;

in TessEvalData {
  vec4 color;
  vec4 texCoord;
  vec3 position;
  vec3 normal;
  vec3 lightDir;
} teData;

out vec4 fragColor;

vec2 dHdxy_fwd(vec2 vUv) {
  vec2 dSTdx = dFdx(vUv);
  vec2 dSTdy = dFdy(vUv);

  float Hll = bumpScale * texture(heightMap, vUv).x;
  float dBx = bumpScale * texture(heightMap, vUv + dSTdx).x - Hll;
  float dBy = bumpScale * texture(heightMap, vUv + dSTdy).x - Hll;

  return vec2(dBx, dBy);
}

vec3 perturbNormal(vec3 surf_pos, vec3 surf_norm, vec2 dHdxy) {
  vec3 vSigmaX = dFdx(surf_pos);
  vec3 vSigmaY = dFdy(surf_pos);
  vec3 vN = surf_norm;		// normalized
  
  vec3 R1 = cross(vSigmaY, vN);
  vec3 R2 = cross(vN, vSigmaX);

  float fDet = dot(vSigmaX, R1);

  vec3 vGrad = sign(fDet) * (dHdxy.x * R1 + dHdxy.y * R2);
  return normalize(abs(fDet) * surf_norm - vGrad);
}

void main() {
  vec2 tcoord = teData.texCoord.st;

  vec3 normal = perturbNormal(normalize(teData.position), teData.normal, dHdxy_fwd(tcoord));  
  vec3 direction = normalize(teData.lightDir);
  float intensity = max(0.0, dot(direction, normal));  
  vec4 diffuseColor = vec4(vec3(intensity), 1) * teData.color;  
  
  fragColor = diffuseColor;
  //gl_FragColor = vec4(1, 0, 0, 1); 
}