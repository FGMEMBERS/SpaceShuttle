// -*-C++-*-
#version 120

#define BLADE_FRACTION 0.1
#define MAX_LAYERS 30
#define MAX_DISTANCE 1000.0

uniform float scattering;
uniform float max_height;
uniform float velcro_density;
uniform float velcro_scale;
uniform float velcro_modulate_height_min;
uniform float angle;
uniform float interior_ambience_r;
uniform float interior_ambience_g;
uniform float interior_ambience_b;



uniform int velcro_modulate_by_overlay;
uniform int velcro_groups;

uniform vec3 offset_vec;
uniform vec3 scale_vec;



uniform sampler2D colorTex;
uniform samplerCube cube_texture;


uniform float osg_SimulationTime;

varying vec3 g_rawpos;                  // Horizontal position in model space
varying float g_layer;				       // The layer where the fragment lives (0-1 range)
varying float g_NdotL;

float rand2D(in vec2 co);
float Noise2D(in vec2 co, in float wavelength);
vec3 filter_combined (in vec3 color) ;



float map(float s, float a1, float a2, float b1, float b2)
{
    return b1+(s-a1)*(b2-b1)/(a2-a1);
}

float decodeBinary(float n, float layer)
{
	return float(mod(floor(n*pow(0.5, layer)), 2.0));
}


float bladeNoise2D(in float x, in float y, in float dDensity, in float layer, in float d_factor, in float h_factor)
{
	float integer_x    = x - fract(x);
    float fractional_x = x - integer_x;

    float integer_y    = y - fract(y);
    float fractional_y = y - integer_y;

	if (rand2D(vec2(integer_x+1.0, integer_y +1.0)) > dDensity)
		{return 0.0;}

	float hfact =  0.7 + 0.3 * (rand2D(vec2(integer_x, integer_y + 2.0)));
	hfact *= h_factor;
	
	if (layer > hfact) {return 0.0;}	
		
    float xoffset = (rand2D(vec2(integer_x, integer_y)) -0.5);
    float yoffset = (rand2D(vec2(integer_x+1.0, integer_y)) - 0.5);
	
	float xbend =  (rand2D(vec2(integer_x+1.0, integer_y + 1.0)) - 0.5);
	float ybend =  (rand2D(vec2(integer_x, integer_y + 1.0)) - 0.5);
	float fraction = BLADE_FRACTION * (0.5 + 0.5 * (1.0 - smoothstep(0.5, 1.0, layer)));

	float bend = 0.5 * layer * layer;
	
	vec2 truePos = vec2 (0.5 + xoffset * (1.0 - 2.0 * BLADE_FRACTION) + xbend * bend, 0.5 + yoffset * (1.0 -2.0 * BLADE_FRACTION) +  ybend * bend);

	float distance = length(truePos - vec2(fractional_x, fractional_y));
	return 1.0 - step (fraction * d_factor, distance);
}

float BladeNoise2D(in vec2 coord, in float wavelength, in float dDensity, in float layer, in float d_factor, in float h_factor)
{
return bladeNoise2D(coord.x/wavelength, coord.y/wavelength, dDensity, layer, d_factor, h_factor);
}

void main()
{
	vec2 texCoord = gl_TexCoord[0].st;
		
	
	float h_factor = 1.0;
	
	float value = 0.0;
	
	float d_factor = 1.0 ;
	d_factor *= clamp(max_height/0.3,0.5, 1.0);
	
	float bladeFlag = BladeNoise2D(texCoord, velcro_scale, velcro_density, g_layer, d_factor, h_factor);
	if (velcro_groups >1) {bladeFlag += BladeNoise2D(texCoord, 0.9 * velcro_scale, velcro_density, g_layer, d_factor, h_factor);}
	if (velcro_groups >2) {bladeFlag += BladeNoise2D(texCoord, 0.8 * velcro_scale, velcro_density, g_layer, d_factor, h_factor);}
	if (velcro_groups >3) {bladeFlag += BladeNoise2D(texCoord, 0.7 * velcro_scale, velcro_density, g_layer, d_factor, h_factor);}
	if (velcro_groups >4) {bladeFlag += BladeNoise2D(texCoord, 0.6 * velcro_scale, velcro_density, g_layer, d_factor, h_factor);}

		
	if (bladeFlag > 0.0) {value = 1.0;}
	else {discard;}
	
	
	
	vec3 texel = texture2D(colorTex, texCoord).rgb;

	// lookup on the opacity map
    vec3 light_vec = normalize((gl_ModelViewMatrixInverse * gl_LightSource[0].position).xyz);

    vec4 ep = gl_ModelViewMatrixInverse * vec4(0.0,0.0,0.0,1.0);
    vec3 scaled_pos = g_rawpos;

    scaled_pos -= offset_vec; 
    float rangle = radians(angle);
    mat2 rotMat = mat2 (cos(rangle), -sin(rangle), sin(rangle), cos(rangle));   
    scaled_pos.xy *=rotMat;

    scaled_pos /= scale_vec;
    vec3 lookup_pos = scaled_pos - light_vec * dot(light_vec, scaled_pos);

    vec3 lookup_vec = normalize(normalize(light_vec) + lookup_pos);
    vec4 opacity = textureCube(cube_texture, lookup_vec);
	
	vec3 ambient_light = vec3 (interior_ambience_r, interior_ambience_g, interior_ambience_b);
	float ambient_intensity = length(ambient_light)/1.73;
	ambient_intensity = sqrt(ambient_intensity);
	vec3 light;
	if (ambient_intensity == 0.0) {light = vec3 (0.0, 0.0, 0.0);}
	else  {light =  normalize(ambient_light) * ambient_intensity * (0.9 + 0.5 * g_layer);}
	
	light +=vec3 (1.0, 1.0, 1.0) * length(gl_LightSource[0].diffuse.rgb)/1.73 * opacity.rgb * max(0.0,g_NdotL);
	light = clamp(light, 0.0, 1.4);
	
	texel.rgb *= light;
	texel = clamp(texel, 0.0, 1.0);
	
	
	vec4 fragColor = vec4 (texel, value);
	fragColor.rgb = filter_combined(fragColor.rgb);

    gl_FragColor = fragColor;
}
