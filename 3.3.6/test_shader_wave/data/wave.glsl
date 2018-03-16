uniform sampler2D u_tex;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform vec2 lowerLeft;
uniform vec2 upperRight;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(1222.9898,978.233))) * 403758.5453);
}

const mat3 gaussian3x3 = mat3(
    1./16., 1./8., 1./16.,
    1./8.,  1./4., 1./8.,
    1./16., 1./8., 1./16.
);

const mat3 uniform3x3 = mat3(vec3(1./9.), vec3(1./9.), vec3(1./9.));

const mat3 lowDissipation3x3 = mat3(
    0.,    1/16.,     0.,
    1/16., 12./16.,   1./16.,
    0.,    1/16.,     0.
);

const mat3 verySlow3x3 = mat3(
    1./64., 1/32.,   1./64.,
    1./32., 13./16., 1./32.,
    1./64., 1/32.,   1./64.
);

vec4 blur(vec2 st, mat3 kernel) {
    vec4 sum = vec4(0.);
    for (int x = 0; x < 3; x++) {
        for (int y = 0; y < 3; y++) {
            vec2 offset = vec2(x - 1., y - 1.);
            sum += texture2D(u_tex, st + offset / u_resolution) * kernel[x][y];
        }
    }
    return sum;
}

vec2 changePop1(vec2 st, float oldR, float oldG) {
    // ok, lets make some formulas happen:
    // r holds "resources" from 0 to 1
    // g holds "grass" from 0 to 1
    // b holds "bison" from 0 to 1

    // here's how they interact:
    // r diffuses from nearby sources with a simple 3x3 gaussian blur
    // g eats r in its cell and spreads slowly to nearby cells
    // b eats g in its cell and nearby cells and spreads quickly
    // when g and b die, they contribute back to r

    // energy conservation would be ideal
    // ok well lets just try r and g for now

    // here's one formula set:
    // newR = oldR * rDiffusionFactor + nearbyDiffusionR - eatenR + gReturnedToR
    // newG = oldG * gDiffusionFactor + birthedG - deathedG + nearbyDiffusionG
    // eatenR = oldG * eatFactor
    // eatFactor = 0.5;
    // birthedG = eatenR * birthFactor
    // birthFactor = 1 - oldG
    // deathedG = oldG * deathFactor
    // deathFactor = oldG
    // gReturnedToR = deathedG

    vec2 eatDeath = mix(lowerLeft, upperRight, st);

    // what percentage of the population dies this frame
    float deathFactor = eatDeath.y * oldG;

    // the number of g that dies this frame
    float deathedG = oldG * deathFactor;

    // what percentage of G eats this frame
    float eatFactor = eatDeath.x;
    // how much r has been eaten by g
    // this should scale with G, and also with R
    float eatenR = oldR * oldG * eatFactor;

    // what percentage of eaten food turns into new G's?
    // when there's no g, 100% of it turns into
    float birthFactor = 1. - oldG;

    // the number of g's born this frame
    float birthedG = eatenR * birthFactor;

    float gReturnedToR = deathedG;
    float newR = blur(st, gaussian3x3).r - eatenR + gReturnedToR;
    /* float newR = blur(st, verySlow3x3).r - eatenR + gReturnedToR; */
    /* float newG = blur(st, verySlow3x3).g + birthedG - deathedG; */
    float newG = blur(st, uniform3x3).g + birthedG - deathedG;
    /* float modG = newG - oldG; */
    /* float newR = blur(st, gaussian3x3).r - modG; */

    return vec2(newR, newG);
}

const float F = 0.8;
vec2 changePop2(vec2 st, float r, float g, float E, float D) {
    float dr = r*F - g*g*D;
    float dg = r - g*E;
    float newR = blur(st, gaussian3x3).r + dr;
    float newG = blur(st, gaussian3x3).g + dg;
    return vec2(newR, newG);
}

void main() {
    vec2 st = gl_FragCoord.xy / u_resolution;
    if (u_mouse.x < 10) {
        gl_FragColor = vec4(
                rand(st),
                rand(st * 340.39201),
                0,
                1.);
        return;
    }
    vec4 v = texture2D(u_tex, st);
    float oldR = v.r;
    float oldG = v.g;

    vec2 ed = mix(lowerLeft, upperRight, st);
    vec2 new = changePop2(st, oldR, oldG, ed.x, ed.y);

    float t = 1;
    gl_FragColor = vec4(mix(oldR, new.r, t), mix(oldG, new.g, t), 0, 1.);
}
