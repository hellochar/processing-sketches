class TessellationShader extends PShader {
  int glTessControl, glTessEval, glGeometry;
  String tessControlSrc, tessEvalSrc, geometrySrc;

  TessellationShader(PApplet parent, String vertFilename, String tessControlFilename, 
                                     String tessEvalFilename, String geoFilename, 
                                     String fragFilename) {
    super(parent, vertFilename, fragFilename);
    tessControlSrc = PApplet.join(parent.loadStrings(tessControlFilename), "\n");
    tessEvalSrc = PApplet.join(parent.loadStrings(tessEvalFilename), "\n");
    geometrySrc = PApplet.join(parent.loadStrings(geoFilename), "\n");
  }

  void setup() {
    glTessControl = pgl.createShader(GL4.GL_TESS_CONTROL_SHADER);
    compile(glTessControl, tessControlSrc, "Cannot compile tessellation control shader:\n");
    glTessEval = pgl.createShader(GL4.GL_TESS_EVALUATION_SHADER);
    compile(glTessEval, tessEvalSrc, "Cannot compile tessellation evaluation shader:\n");
    glGeometry = pgl.createShader(GL3.GL_GEOMETRY_SHADER);
    compile(glGeometry, geometrySrc, "Cannot compile geometry shader:\n");
    pgl.attachShader(glProgram, glTessControl);
    pgl.attachShader(glProgram, glTessEval);
    pgl.attachShader(glProgram, glGeometry);
  }

  void compile(int id, String src, String msg) {
    pgl.shaderSource(id, src);
    pgl.compileShader(id);      
    pgl.getShaderiv(id, PGL.COMPILE_STATUS, intBuffer);
    boolean compiled = intBuffer.get(0) == 0 ? false : true;
    if (!compiled) {
      println(msg + pgl.getShaderInfoLog(id));
    }
  }

  void draw(int idxId, int count, int offset) {
    GL4 gl4 = ((PJOGL)pgl).gl.getGL4();
    gl4.glPatchParameteri(GL4.GL_PATCH_VERTICES, 3);      
    pgl.bindBuffer(PGL.ELEMENT_ARRAY_BUFFER, idxId);
    pgl.drawElements(GL4.GL_PATCHES, count, GL.GL_UNSIGNED_SHORT, offset * Short.SIZE / 8);
    pgl.bindBuffer(PGL.ELEMENT_ARRAY_BUFFER, 0);
  }
}