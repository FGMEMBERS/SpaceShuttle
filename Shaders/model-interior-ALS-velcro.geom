// -*-C++-*-
#version 120
#extension GL_EXT_geometry_shader4 : enable

#define MAX_LAYERS 15



varying in vec3 v_normal[3];

varying out vec3 g_rawpos;
varying out float g_layer;
varying out float g_NdotL;

uniform float max_height;


float min3(in float a, in float b, in float c)
{
    float m = a;
    if (m > b) m = b;
    if (m > c) m = c;
    return m;
}

void main()
{
    float distances[3];
    distances[0] = -(gl_ModelViewMatrix * gl_PositionIn[0]).z;
    distances[1] = -(gl_ModelViewMatrix * gl_PositionIn[1]).z;
    distances[2] = -(gl_ModelViewMatrix * gl_PositionIn[2]).z;
    float minDistance = min3(distances[0], distances[1], distances[2]);
    //float avgDistance = (distances[0]+distances[1]+distances[2])*0.33;

    int numLayers = MAX_LAYERS;

    float deltaLayer = 1.0 / float(numLayers);
    float currDeltaLayer = deltaLayer * 0.5;

    for (int layer = 0; layer < numLayers; ++layer) {
        for (int i = 0; i < 3; ++i) {
            vec4 pos = gl_PositionIn[i] + vec4(v_normal[i] * currDeltaLayer * max_height, 0.0);
            g_rawpos = gl_PositionIn[i].xyz;
            g_layer = currDeltaLayer;
			g_NdotL = dot (normalize(v_normal[i]), normalize(gl_LightSource[0].position.xyz));
            gl_Position = gl_ModelViewProjectionMatrix * pos;
            gl_TexCoord[0] = gl_TexCoordIn[i][0];
            EmitVertex();
        }
        EndPrimitive();

        currDeltaLayer += deltaLayer;
    }
}
