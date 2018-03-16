// this is provided by processing I think?
uniform sampler2D texture;
uniform vec2 texOffset;
varying vec4 vertTexCoord;

void main() {
    vec4 color = texture2D(texture, vertTexCoord.st);
    vec4 colorR = texture2D(texture, vertTexCoord.st + vec2(texOffset.s, 0.));
    vec4 colorL = texture2D(texture, vertTexCoord.st + vec2(-texOffset.s, 0.));
    vec4 colorU = texture2D(texture, vertTexCoord.st + vec2(0., texOffset.t));
    vec4 colorD = texture2D(texture, vertTexCoord.st + vec2(0., -texOffset.t));

    vec4 sum = colorR + colorL + colorU + colorD - color * 4.;
    gl_FragColor = vec4(sum.rgb * 128., 1.0);
}
