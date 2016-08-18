// -*-C++-*-


#version 120
#define MODE_OFF 0
#define MODE_DIFFUSE 1
#define MODE_AMBIENT_AND_DIFFUSE 2

varying vec3 rawPos;

void main()
{

    rawPos = gl_Vertex.xyz;
    gl_Position = ftransform();
    gl_FrontColor = vec4 (1.0, 0.5, 0.0, 0.5);
    gl_BackColor = vec4 (1.0, 0.5, 0.0, 0.5);
}
