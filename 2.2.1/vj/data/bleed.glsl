#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER


// Processing specific input
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;


mat3 m = mat3( 0.00,  0.80,  0.60,
              -0.80,  0.36, -0.48,
              -0.60, -0.48,  0.64 );

float hash( float n )
{
    return fract(sin(n)*43758.5453123);
}


float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);

    f = f*f*(3.0-2.0*f);

    float n = p.x + p.y*57.0 + 113.0*p.z;

    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                        mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),
                    mix(mix( hash(n+113.0), hash(n+114.0),f.x),
                        mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
    return res;
}




vec3 noised( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);

    vec2 u = f*f*(3.0-2.0*f);

    float n = p.x + p.y*57.0;

    float a = hash(n+  0.0);
    float b = hash(n+  1.0);
    float c = hash(n+ 57.0);
    float d = hash(n+ 58.0);
	return vec3(a+(b-a)*u.x+(c-a)*u.y+(a-b-c+d)*u.x*u.y,
				30.0*f*f*(f*(f-2.0)+1.0)*(vec2(b-a,c-a)+(a-b-c+d)*u.yx));

}

float noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);

    f = f*f*(3.0-2.0*f);

    float n = p.x + p.y*57.0;

    float res = mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                    mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);

    return res;
}

float fbm( vec3 p )
{
    float f = 0.0;

    f += 0.5000*noise( p ); p = m*p*2.02;
    f += 0.2500*noise( p ); p = m*p*2.03;
    f += 0.1250*noise( p ); p = m*p*2.01;
    f += 0.0625*noise( p );

    return f/0.9375;
}

mat2 m2 = mat2(1.6,-1.2,1.2,1.6);
	
float fbm( vec2 p )
{
    float f = 0.0;

    f += 0.5000*noise( p ); p = m2*p*2.02;
    f += 0.2500*noise( p ); p = m2*p*2.03;
    f += 0.1250*noise( p ); p = m2*p*2.01;
    f += 0.0625*noise( p );

    return f/0.9375;
}

float terrain( in vec2 x )
{
	vec2  p = x*0.003;
    float a = 0.0;
    float b = 1.0;
	vec2  d = vec2(0.0);
    for(int i=0;i<5; i++)
    {
        vec3 n = noised(p);
        d += n.yz;
        a += b*n.x/(1.0+dot(d,d));
		b *= 0.5;
        p=mat2(1.6,-1.2,1.2,1.6)*p;
    }

    return 140.0*a;
}

float terrain2( in vec2 x )
{
	vec2  p = x*0.003;
    float a = 0.0;
    float b = 1.0;
	vec2  d = vec2(0.0);
    for(int i=0;i<14; i++)
    {
        vec3 n = noised(p);
        d += n.yz;
        a += b*n.x/(1.0+dot(d,d));
		b *= 0.5;
        p=m2*p;
    }

    return 140.0*a;
}


float map( in vec3 p )
{
	float h = terrain(p.xz);
	
	float ss = 0.03;
	float hh = h*ss;
	float fh = fract(hh);
	float ih = floor(hh);
	fh = mix( sqrt(fh), fh, smoothstep(50.0,140.0,h) );
	h = (ih+fh)/ss;
	
    return p.y - h;
}

float map2( in vec3 p )
{
	float h = terrain2(p.xz);

	
	float ss = 0.03;
	float hh = h*ss;
	float fh = fract(hh);
	float ih = floor(hh);
	fh = mix( sqrt(fh), fh, smoothstep(50.0,140.0,h) );
	h = (ih+fh)/ss;
	
    return p.y - h;
}



void main(void) {
  // // Grouping texcoord variables in order to make it work in the GMA 950. See post #13
  // // in this thread:
  // // http://www.idevgames.com/forums/thread-3467.html
  // vec2 tc0 = vertTexCoord.st + vec2(-texOffset.s, -texOffset.t);
  // vec2 tc1 = vertTexCoord.st + vec2(         0.0, -texOffset.t);
  // vec2 tc2 = vertTexCoord.st + vec2(+texOffset.s, -texOffset.t);
  // vec2 tc3 = vertTexCoord.st + vec2(-texOffset.s,          0.0);
  // vec2 tc4 = vertTexCoord.st + vec2(         0.0,          0.0);
  // vec2 tc5 = vertTexCoord.st + vec2(+texOffset.s,          0.0);
  // vec2 tc6 = vertTexCoord.st + vec2(-texOffset.s, +texOffset.t);
  // vec2 tc7 = vertTexCoord.st + vec2(         0.0, +texOffset.t);
  // vec2 tc8 = vertTexCoord.st + vec2(+texOffset.s, +texOffset.t);

  // vec4 col0 = texture2D(texture, tc0);
  // vec4 col1 = texture2D(texture, tc1);
  // vec4 col2 = texture2D(texture, tc2);
  // vec4 col3 = texture2D(texture, tc3);
  // vec4 col4 = texture2D(texture, tc4);
  // vec4 col5 = texture2D(texture, tc5);
  // vec4 col6 = texture2D(texture, tc6);
  // vec4 col7 = texture2D(texture, tc7);
  // vec4 col8 = texture2D(texture, tc8);

  // vec4 sum = (1.0 * col0 + 2.0 * col1 + 1.0 * col2 +  
  //             2.0 * col3 + 4.0 * col4 + 2.0 * col5 +
  //             1.0 * col6 + 2.0 * col7 + 1.0 * col8) / 16.0;            
  // gl_FragColor = vec4(sum.rgb, 1.0) * vertColor;  

  vec4 originalColor = texture2D(texture, vertTexCoord.st);
  /* float bleedAmount = terrain( vertTexCoord.st * 4000 + vec2(time) ) / 180.0; */
  float z = time / 3 + sin(time * 5) / 3;
  float bleedAmount = clamp( 0.003 / abs(fbm( vec3( vertTexCoord.st * 20, z) ) - 0.5), 0, 1);
  if (bleedAmount < 0.9) {
      bleedAmount = 0;
  }
  vec4 bleedColor = vec4(1, 0, 0, 1);

  vec4 lerpedColor = originalColor + originalColor * bleedColor * bleedAmount;


  gl_FragColor = lerpedColor;
}
