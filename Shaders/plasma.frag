// -*-C++-*-
#version 120

uniform float temperature;
uniform float osg_SimulationTime;

varying vec3 rawPos;

float Noise3D(in vec3 coord, in float wavelength);

void main()
{
 
    if (temperature < 2000.0) {discard;}
 
    float noise_01m = Noise3D(vec3(rawPos.x + 10.0* osg_SimulationTime, rawPos.y, rawPos.z) , 0.1);
    float noise_05m = Noise3D(vec3(rawPos.x + 10.0* osg_SimulationTime, rawPos.y, rawPos.z) , 0.5);  

    vec3 plasma_color_low = vec3 (0.8, 0.4, 0.4);
    vec3 plasma_color_high = vec3 (1.0, 0.5, 0.0);
    vec3 white = vec3 (1.0, 1.0, 1.0);

    float mix_factor = clamp((temperature - 2000.0)/1000.0, 0.0, 1.0);

    vec3 plasma_color = mix(plasma_color_low, plasma_color_high, mix_factor);
    plasma_color = mix (plasma_color, white, 0.3 * noise_05m + 0.1 * noise_01m);

    gl_FragColor = vec4 (plasma_color, 0.75 * mix_factor);
    

}
