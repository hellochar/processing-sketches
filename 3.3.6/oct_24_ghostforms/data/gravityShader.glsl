#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;

uniform vec2 iMouse;
uniform float iMouseFactor;
uniform vec2 iResolution;
uniform float G;
uniform float gamma;

varying vec4 vertTexCoord;

vec2 gravity(vec2 p, vec2 attractionCenter, float g) {
    float mass1 = 1.0;
    float mass2 = 1.0;
    
    return (attractionCenter - p) * g * mass1 * mass2 / pow(length(p - attractionCenter), 2.0);
}

vec4 equality(vec2 p, vec2 attractionCenter) {
    float total = 0.0;
    vec2 incomingP = p;
    vec2 outgoingP = p;
    vec4 c = vec4(0.0);
    vec4 outgoingColorFactor = vec4(1.0);
    vec4 incomingColorFactor = vec4(1.0);
    for( float i = 1.0; i < 12.0; i += 1.0) {
       incomingP = incomingP - gravity(incomingP, attractionCenter, G);
       outgoingP = outgoingP + gravity(outgoingP, attractionCenter, G);

       /* incomingP -= (iMouse - p) * iMouseFactor; */
       /* outgoingP += (iMouse - p) * iMouseFactor; */
       float intensityScalar = 0.8 / (i + 2.);
       c += texture2D(texture, incomingP / iResolution) * intensityScalar * pow(incomingColorFactor, vec4(i));
       /* c += texture2D(texture, outgoingP / iResolution) * intensityScalar * pow(outgoingColorFactor, vec4(i)); */
    }
    return c;
}

void main(void)
{
    vec2 uv = gl_FragCoord.xy;
    vec4 c = texture2D(texture, vertTexCoord.st);
    vec4 c2 = equality(uv, iResolution/2.0);
    gl_FragColor = pow(c + c2, vec4(gamma));
}
