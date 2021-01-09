int faces[] = {
  2, 1, 0,
  3, 2, 0,
  4, 3, 0,
  5, 4, 0,
  1, 5, 0,

  11, 6,  7,
  11, 7,  8,
  11, 8,  9,
  11, 9,  10,
  11, 10, 6,

  1, 2, 6,
  2, 3, 7,
  3, 4, 8,
  4, 5, 9,
  5, 1, 10,

  2,  7, 6,
  3,  8, 7,
  4,  9, 8,
  5, 10, 9,
  1, 6, 10 
};

float verts[] = {
   0.000f,  0.000f,  1.000f,
   0.894f,  0.000f,  0.447f,
   0.276f,  0.851f,  0.447f,
  -0.724f,  0.526f,  0.447f,
  -0.724f, -0.526f,  0.447f,
   0.276f, -0.851f,  0.447f,
   0.724f,  0.526f, -0.447f,
  -0.276f,  0.851f, -0.447f,
  -0.894f,  0.000f, -0.447f,
  -0.276f, -0.851f, -0.447f,
   0.724f, -0.526f, -0.447f,
   0.000f,  0.000f, -1.000f 
};   

PShape createIcosahedron() {
  PShape sh = createShape();
  sh.beginShape(TRIANGLES);
  sh.noStroke();
  sh.fill(200);
  for (int i = 0; i < faces.length/3; i++) {
    int i0 = faces[3 * i + 0];
    int i1 = faces[3 * i + 1];
    int i2 = faces[3 * i + 2];      
    sh.vertex(verts[3 * i0 + 0], verts[3 * i0 + 1], verts[3 * i0 + 2]);
    sh.vertex(verts[3 * i1 + 0], verts[3 * i1 + 1], verts[3 * i1 + 2]);
    sh.vertex(verts[3 * i2 + 0], verts[3 * i2 + 1], verts[3 * i2 + 2]);
  }
  sh.endShape();
  return sh;
}  
  
