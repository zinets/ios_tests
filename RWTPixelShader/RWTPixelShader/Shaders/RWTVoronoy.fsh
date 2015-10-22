//
//  RWTBase.fsh
//  RWTPixelShader
//
//  Created by Ricardo on 3/23/14.
//  Copyright (c) 2014 RayWenderlich. All rights reserved.
//

//void main() {
//    vec2 uv = gl_FragCoord.xy;
//    float t = 0.9 * worley(gl_FragCoord.xy / 20.0);
//    gl_FragColor = vec4(vec3(t,sqrt(t),t), 1.0);
//}

precision mediump float;

varying vec2 aPosition;
uniform vec2 uResolution;
uniform float uTime;

vec2 hash2( vec2 p )
{
    // texture based white noise
//    return texture2D( iChannel0, (p+0.5)/256.0, -100.0 ).xy;
    
    // procedural white noise
    return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}

vec3 voronoi( in vec2 x )
{
    vec2 n = floor(x);
    vec2 f = fract(x);
    
    //----------------------------------
    // first pass: regular voronoi
    //----------------------------------
    vec2 mg, mr;
    
    float md = 8.0;
    for( int j=-1; j<=1; j++ )
        for( int i=-1; i<=1; i++ )
        {
            vec2 g = vec2(float(i),float(j));
            vec2 o = hash2( n + g );
#ifdef ANIMATE
            o = 0.5 + 0.5*sin( iGlobalTime + 6.2831*o );
#endif
            vec2 r = g + o - f;
            float d = dot(r,r);
            
            if( d<md )
            {
                md = d;
                mr = r;
                mg = g;
            }
        }
    
    //----------------------------------
    // second pass: distance to borders
    //----------------------------------
    md = 8.0;
    for( int j=-2; j<=2; j++ )
        for( int i=-2; i<=2; i++ )
        {
            vec2 g = mg + vec2(float(i),float(j));
            vec2 o = hash2( n + g );
#ifdef ANIMATE
            o = 0.5 + 0.5*sin( iGlobalTime + 6.2831*o );
#endif
            vec2 r = g + o - f;
            
            if( dot(mr-r,mr-r)>0.00001 )
                md = min( md, dot( 0.5*(mr+r), normalize(r-mr) ) );
        }
    
    return vec3( md, mr );
}



//const float waves = 19.;
//
//// triangle wave from 0 to 1
//float wrap(float n) {
//    return abs(mod(n, 2.)-1.)*-1. + 1.;
//}
//
//// creates a cosine wave in the plane at a given angle
//float wave(float angle, vec2 point) {
//    float cth = cos(angle);
//    float sth = sin(angle);
//    return (cos (cth*point.x + sth*point.y) + 1.) / 2.;
//}
//
//// sum cosine waves at various interfering angles
//// wrap values when they exceed 1
//float quasi(float interferenceAngle, vec2 point) {
//    float sum = 0.;
//    for (float i = 0.; i < waves; i++) {
//        sum += wave(3.1416*i*interferenceAngle, point);
//    }
//    return wrap(sum);
//}
//
//void main() {
//    vec2 position = gl_FragCoord.xy - 0.5;
//    float b = quasi(uTime*0.002, (position-0.5)*200.);
//    vec4 c1 = vec4(0.0,0.,0.2,1.);
//    vec4 c2 = vec4(1.5,0.7,0.,1.);
//    
//    gl_FragColor = mix(c1,c2,b);
//}

void main() {
    vec2 p = gl_FragCoord.xy/uResolution;
    
    vec3 c = voronoi( 8.0*p );
    
    // isolines
    vec3 col;// = c.x*(0.5 + 0.5*sin(64.0*c.x))*vec3(1.0);
    // borders
    col = mix( vec3(1.0,0.6,0.0), col, smoothstep( 0.04, 0.07, c.x ) );
    // feature points
    float dd = length( c.yz );
    col = mix( vec3(1.0,0.6,0.1), col, smoothstep( 0.0, 0.12, dd) );
    col += vec3(1.0,0.6,0.1)*(1.0-smoothstep( 0.0, 0.04, dd));
    
    gl_FragColor = vec4(col,1.0);
}
