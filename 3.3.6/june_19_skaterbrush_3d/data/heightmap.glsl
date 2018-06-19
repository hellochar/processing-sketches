#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform vec2 resolution;
uniform vec2 mouse;

uniform vec2 texOffset;
varying vec4 vertColor;
varying vec4 vertTexCoord;

const vec4 lumcoeff = vec4(0.299, 0.587, 0.114, 0);

float height(vec2 uv) {
    // return dot(texture2D(texture, uv), lumcoeff);
    return 1. - texture2D(texture, uv).x;
}

vec3 norm(vec2 uv) {
    vec3 o = vec3(texOffset, 0.);
    return normalize(
            vec3(
        (height(uv + vec2(texOffset.x, 0.)) -
         height(uv - vec2(texOffset.x, 0.))) / (2. * texOffset.x),
        (height(uv + vec2(0., texOffset.y)) -
         height(uv - vec2(0., texOffset.y))) / (2. * texOffset.y),
        20.
    ));
}

void main() {
    float height = height(vertTexCoord.xy);
    vec3 norm = norm(vertTexCoord.xy);
    vec3 col = vec3(0.);
    // base black color; colors from http://colorpalettes.net/color-palette-3871/
    vec3 baseColor = vec3(23., 25., 27.) / 255.;
    col += baseColor;

    // diffuse
    float vignetteScalar = smoothstep(1. - length(vertTexCoord.xy - vec2(0.5)), 0., 0.25);
    float diffuseAmount = max(0., dot(norm, normalize(vec3(1., 1., 0.4))));
    vec3 diffuseColorBase = vec3(81., 159., 165.) / 255.;

    /* vec3 diffuseColor = vignetteScalar * diffuseAmount * diffuseColorBase; */
    /* col += diffuseColor; */
    col = mix(col, diffuseColorBase, vignetteScalar * diffuseAmount);

    // phong
    float phong2Amount = pow(
            max(0., dot(norm, normalize(vec3(1., 1., 0.04)))),
            2.
            );
    vec3 phong2ColorBase = sqrt(vec3(159., 33., 18.) / 255.) * 1.3;
    col = mix(col, phong2ColorBase, phong2Amount);

    vec3 materialColor = mix(vec3(55., 22., 8.) / 255., vec3(81., 159., 165.) / 255., pow(1. - height, 4.));
    col *= materialColor;
    col *= 1.4;


    float phong6Amount = pow(
            max(0., dot(norm, normalize(vec3(1., 1., 0.04)))),
            6.
            );
    vec3 phong6ColorBase = sqrt(vec3(242., 158., 146.) / 255.) * 2.3;
    vec3 phong6Color = phong6ColorBase * phong6Amount;
    col += phong6Color;

    col = sqrt(col);

    gl_FragColor = vec4(col, 1.);
}

