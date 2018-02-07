#define PI 3.1415926535897932384626433832795

uniform sampler2D lastFrame;
uniform vec2 resolution;
uniform vec2 mouse;

// v's are corners, interp's components both are in [0, 1]
float interp2(float v00, float v10, float v01, float v11, vec2 interp) {
    float vAvg0 = mix(v00, v10, interp.x);
    float vAvg1 = mix(v01, v11, interp.x);
    float vAvgAvg = mix(vAvg0, vAvg1, interp.y);
    return vAvgAvg;
}

// uniform random in [0, 1] for every xy input
float random(vec2 xy) {
    /* return fract(sin(dot(xy, vec2(14.41921, 93.570249))) * 42159.59342); */
    return fract(sin(dot(xy, mouse / resolution)) * 2);
}

// a random number for every unit square (edges are at [0, 0] -> (1, 1))
float randomBlocks(vec2 xy) {
    return random(floor(xy));
}

// linearly interpolate between the 4 corner points
float linearRandomBlocks(vec2 xy) {
    // option 1: simply take the 4 corners
    float v = randomBlocks(xy);
    float vx = randomBlocks(xy + vec2(1, 0));
    float vy = randomBlocks(xy + vec2(0, 1));
    float vxy = randomBlocks(xy + vec2(1, 1));

    vec2 distances = fract(xy); // dist 0 = right on v, dist 1 = right on vxy
    return interp2(v, vx, vy, vxy, distances);
}

// interpolate using sine between the 4 corner points
float sinRandomBlocks(vec2 xy) {
    float v = randomBlocks(xy);
    float vx = randomBlocks(xy + vec2(1, 0));
    float vy = randomBlocks(xy + vec2(0, 1));
    float vxy = randomBlocks(xy + vec2(1, 1));

    vec2 distances = fract(xy); // dist 0 = right on v, dist 1 = right on vxy
    vec2 angles = vec2(-PI/2) + PI * distances;
    vec2 interpolatedFactor = (sin(angles) + 1) / 2;
    return interp2(v, vx, vy, vxy, interpolatedFactor);
}

float octaveSines(vec2 xy) {
    // compute 8 sines with falloff 0.5
    float sum = 0;
    float waveLength = 1;
    float falloff = 0.5;
    for (int i = 0; i < 8; i++) {
        sum += sinRandomBlocks(xy * waveLength) * falloff;
        waveLength *= 2;
        falloff /= 2;
    }
    return sum;
}

// uniform random unit vector
vec2 randomUnitVector(vec2 xy) {
    float angle = random(xy) * PI * 2;
    return vec2(cos(angle), sin(angle));
}

float linearRandomUnitVectorBlocks(vec2 xy) {
    vec2 grad00 = randomUnitVector(floor(xy));
    vec2 xyTo00 = xy - floor(xy);
    float d00 = dot(xyTo00, grad00);

    vec2 grad10 = randomUnitVector(floor(xy + vec2(1, 0)));
    vec2 xyTo10 = xy - floor(xy + vec2(1, 0));
    float d10 = dot(xyTo10, grad10);

    vec2 grad01 = randomUnitVector(floor(xy + vec2(0, 1)));
    vec2 xyTo01 = xy - floor(xy + vec2(0, 1));
    float d01 = dot(xyTo01, grad01);

    vec2 grad11 = randomUnitVector(floor(xy + vec2(1, 1)));
    vec2 xyTo11 = xy - floor(xy + vec2(1, 1));
    float d11 = dot(xyTo11, grad11);

    if (true) {
        return length(d01);
    }

    // now 2d interpolate
    vec2 distances = fract(xy);
    return interp2(d00, d10, d01, d11, distances);
}

void main() {
    vec2 normalizedCoordinates = gl_FragCoord.xy / resolution;
    vec4 lastColor = texture2D(lastFrame, normalizedCoordinates);
    gl_FragColor = vec4(vec3(linearRandomUnitVectorBlocks(normalizedCoordinates * 10)), 1);
    /* gl_FragColor = vec4( */
    /*         vec3(sinRandomBlocks(normalizedCoordinates * 10)), */
    /*         /* octaveSines(normalizedCoordinates * 10) * vec3(1, 1, 1), */
    /*         1 */
    /*         ); */
}
