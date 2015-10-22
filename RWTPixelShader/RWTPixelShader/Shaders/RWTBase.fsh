//
//  RWTBase.fsh
//  RWTPixelShader
//
//  Created by Ricardo on 3/23/14.
//  Copyright (c) 2014 RayWenderlich. All rights reserved.
//

//void main(void) {
//  gl_FragColor = vec4(0., 1., 0.5, 1.);
//}

#ifdef GL_ES
precision mediump float;
#endif

uniform float uTime;
//uniform vec2 mouse;
//uniform vec2 resolution;

float lengthsq(vec2 p) { return dot(p, p); }

float noise(vec2 p){
    return fract(sin(fract(sin(p.x) * (43.13311)) + p.y) * 31.001);
}


float worley(vec2 p) {
    // Initialise distance to a large value
    float d = 20.0;
    for (int xo = -2; xo <= 2; xo++) {
        for (int yo = -2; yo <= 2; yo++) {
            // Test all surrounding cells to see if distance is smaller.
            vec2 test_cell = floor(p) + vec2(xo, yo);
            // Update distance if smaller.
            float n0 = noise(test_cell);
            float n1 = noise(test_cell + vec2(134.0,8413.0));
            
            float ox = mix( n0, n1, sin(uTime) );
            float oy = mix( n0, n1, cos(uTime) );
            
            vec2 c = test_cell + vec2(ox,oy);
            d = min(d,
                    lengthsq(p - c)
                    );
        }
    }
    return d;
}

void main() {
    vec2 uv = gl_FragCoord.xy;
    float t = 0.9 * worley(gl_FragCoord.xy / 20.0);
    gl_FragColor = vec4(vec3(t,sqrt(t),t), 1.0);
}
