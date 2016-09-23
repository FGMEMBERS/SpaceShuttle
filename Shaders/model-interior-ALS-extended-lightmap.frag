// -*-C++-*-
#version 120

// written by Thorsten Renk, Oct 2015

varying vec4 diffuse_term;
varying vec3 normal;
varying vec3 relPos;


uniform sampler2D texture;
uniform sampler2D lightmap_texture;
uniform sampler2D lightmap2_texture;
uniform sampler2D lightmap3_texture;
uniform sampler2D grain_texture;
uniform samplerCube cube_texture;


varying float yprime_alt;
varying float mie_angle;


uniform float visibility;
uniform float avisibility;
uniform float scattering;
uniform float terminator;
uniform float terrain_alt; 
uniform float hazeLayerAltitude;
uniform float overcast;
uniform float eye_alt;
uniform float cloud_self_shading;
uniform float angle;
uniform float threshold_low;
uniform float threshold_high;
uniform float emit_intensity;
uniform float light_radius;
uniform float lightmap_r_factor;
uniform float lightmap_g_factor;
uniform float lightmap_b_factor;
uniform float lightmap_a_factor;
uniform float lightmap2_r_factor;
uniform float lightmap2_g_factor;
uniform float lightmap2_b_factor;
uniform float lightmap2_a_factor;
uniform float lightmap3_r_factor;
uniform float lightmap3_g_factor;
uniform float lightmap3_b_factor;
uniform float lightmap3_a_factor;
uniform float grain_magnification;

uniform vec3 offset_vec;
uniform vec3 scale_vec;
uniform vec3 tag_color;
uniform vec3 emit_color;
uniform vec3 light_filter_one;
uniform vec3 light_filter_two;
uniform vec3 lightmap_r_color;
uniform vec3 lightmap_g_color;
uniform vec3 lightmap_b_color;
uniform vec3 lightmap_a_color;
uniform vec3 lightmap2_r_color;
uniform vec3 lightmap2_g_color;
uniform vec3 lightmap2_b_color;
uniform vec3 lightmap2_a_color;
uniform vec3 lightmap3_r_color;
uniform vec3 lightmap3_g_color;
uniform vec3 lightmap3_b_color;
uniform vec3 lightmap3_a_color;

uniform int quality_level;
uniform int tquality_level;
uniform int use_searchlight;
uniform int implicit_lightmap_enabled;
uniform int use_flashlight;
uniform int lightmap_enabled;
uniform int lightmap_multi;
uniform int grain_texture_enabled;


const float EarthRadius = 5800000.0;
const float terminator_width = 200000.0;

float alt;
float eShade;


float fog_func (in float targ, in float alt);
float alt_factor(in float eye_alt, in float vertex_alt);
float light_distance_fading(in float dist);
float fog_backscatter(in float avisibility);

vec3 addLights(in vec3 color1, in vec3 color2);
vec3 flashlight(in vec3 color, in float radius);
vec3 filter_combined (in vec3 color) ;

float luminance(vec3 color)
{
    return dot(vec3(0.212671, 0.715160, 0.072169), color);
}


float light_func (in float x, in float a, in float b, in float c, in float d, in float e)
{
x = x - 0.5;

// use the asymptotics to shorten computations
if (x > 30.0) {return e;}
if (x < -15.0) {return 0.0;}

return e / pow((1.0 + a * exp(-b * (x-c)) ),(1.0/d));
}

// this determines how light is attenuated in the distance
// physically this should be exp(-arg) but for technical reasons we use a sharper cutoff
// for distance > visibility




void main()
{

  vec3 shadedFogColor = vec3(0.55, 0.67, 0.88);
// this is taken from default.frag
    vec3 n;
    float NdotL, NdotHV, fogFactor;
    vec4 color = gl_Color;
    vec3 lightDir = gl_LightSource[0].position.xyz;
    vec3 halfVector = gl_LightSource[0].halfVector.xyz;
    vec4 texel;
    vec4 fragColor;
    vec4 specular = vec4(0.0);
    float intensity;

    float effective_scattering = min(scattering, cloud_self_shading);

    eShade = 1.0 - 0.9 * smoothstep(-terminator_width+ terminator, terminator_width + terminator, yprime_alt);
    vec4 light_specular = gl_LightSource[0].specular * (eShade - 0.1);

    // If gl_Color.a == 0, this is a back-facing polygon and the
    // normal should be reversed.
    n = (2.0 * gl_Color.a - 1.0) * normal;
    n = normalize(n);

    // lookup on the opacity map
    vec3 light_vec = normalize((gl_ModelViewMatrixInverse * gl_LightSource[0].position).xyz);
    //vec3 light_vec = vec3 (-1.0,0.0,0.0);

    vec4 ep = gl_ModelViewMatrixInverse * vec4(0.0,0.0,0.0,1.0);
    vec3 scaled_pos = relPos + ep.xyz;

    //vec3 lookup_vec = normalize(- normalize(light_vec) + relPos);
    scaled_pos -= offset_vec; 
    float rangle = radians(angle);
    mat2 rotMat = mat2 (cos(rangle), -sin(rangle), sin(rangle), cos(rangle));   
    scaled_pos.xy *=rotMat;

    scaled_pos /= scale_vec;
    
    //vec3 lookup_pos = dot(base1,scaled_pos) * base1 + dot(base2,scaled_pos) * base2;
    vec3 lookup_pos = scaled_pos - light_vec * dot(light_vec, scaled_pos);

    vec3 lookup_vec = normalize(normalize(light_vec) + lookup_pos);
    vec4 opacity = textureCube(cube_texture, lookup_vec);
   

    vec4 diffuse = diffuse_term;
    NdotL = dot(n, lightDir);
    //NdotL = dot(n, (gl_ModelViewMatrix * vec4 (light_vec,0.0)).xyz);
    if (NdotL > 0.0) {

	diffuse.rgb += 2.0 * diffuse.rgb * (1.0 - opacity.a);
        color += diffuse * NdotL * opacity;
        NdotHV = max(dot(n, halfVector), 0.0);
        if (gl_FrontMaterial.shininess > 0.0)
            specular.rgb = (gl_FrontMaterial.specular.rgb
                            * light_specular.rgb
                            * pow(NdotHV, gl_FrontMaterial.shininess));
    }
    color.a = diffuse.a;
    // This shouldn't be necessary, but our lighting becomes very
    // saturated. Clamping the color before modulating by the texture
    // is closer to what the OpenGL fixed function pipeline does.
    //color = clamp(color, 0.0, 1.0);

    vec3 secondary_light = vec3 (0.0,0.0,0.0);

    if (use_flashlight == 1)
 	{
 	secondary_light.rgb += flashlight(light_filter_one, light_radius);
 	}
    if (use_flashlight == 2)
 	{
 	secondary_light.rgb += flashlight(light_filter_two, light_radius);
 	}
 	float dist = length(relPos);
 	color.rgb += secondary_light * light_distance_fading(dist);

    texel = texture2D(texture, gl_TexCoord[0].st);

    if (grain_texture_enabled ==1)
        {
        vec4 grainTexel = texture2D(grain_texture, gl_TexCoord[0].st * grain_magnification);
        texel.rgb = mix(texel.rgb, grainTexel.rgb,  grainTexel.a );
        }


    fragColor = color * texel + specular;

   // implicit lightmap - the user gets to select a color which is then made emissive

   if (implicit_lightmap_enabled == 1)
	{
	float cdiff = (length(texel.rgb - tag_color));
	float enhance = 1.0 - smoothstep(threshold_low, threshold_high, cdiff); 
	fragColor.rgb = fragColor.rgb + enhance * emit_color * emit_intensity;
	}

   // explicit lightmap

    vec3 lightmapcolor = vec3(0.0, 0.0, 0.0);


    if (lightmap_enabled == 1)
	{
        vec4 lightmapTexel = texture2D(lightmap_texture, gl_TexCoord[0].st);
        vec4 lightmapFactor = vec4(lightmap_r_factor, lightmap_g_factor, lightmap_b_factor, lightmap_a_factor);
        lightmapFactor = lightmapFactor * lightmapTexel;

        vec4 lightmap2Texel = texture2D(lightmap2_texture, gl_TexCoord[0].st);
        vec4 lightmap2Factor = vec4(lightmap2_r_factor, lightmap2_g_factor, lightmap2_b_factor, lightmap2_a_factor);
        lightmap2Factor = lightmap2Factor * lightmap2Texel;

        vec4 lightmap3Texel = texture2D(lightmap3_texture, gl_TexCoord[0].st);
        vec4 lightmap3Factor = vec4(lightmap3_r_factor, lightmap3_g_factor, lightmap3_b_factor, lightmap3_a_factor);
        lightmap3Factor = lightmap3Factor * lightmap3Texel;

        if (lightmap_multi > 0 )
		{


		lightmapcolor = lightmap_r_color * lightmapFactor.r;
		lightmapcolor = addLights(lightmapcolor, lightmap_g_color * lightmapFactor.g);
		lightmapcolor = addLights(lightmapcolor, lightmap_b_color * lightmapFactor.b);
		lightmapcolor = addLights(lightmapcolor, lightmap_a_color * lightmapFactor.a);

		lightmapcolor = addLights(lightmapcolor, lightmap2_r_color * lightmap2Factor.r);
		lightmapcolor = addLights(lightmapcolor, lightmap2_g_color * lightmap2Factor.g);
		lightmapcolor = addLights(lightmapcolor, lightmap2_b_color * lightmap2Factor.b);
		lightmapcolor = addLights(lightmapcolor, lightmap2_a_color * lightmap2Factor.a);

        lightmapcolor = addLights(lightmapcolor, lightmap3_r_color * lightmap3Factor.r);
		lightmapcolor = addLights(lightmapcolor, lightmap3_g_color * lightmap3Factor.g);
		lightmapcolor = addLights(lightmapcolor, lightmap3_b_color * lightmap3Factor.b);
		lightmapcolor = addLights(lightmapcolor, lightmap3_a_color * lightmap3Factor.a);
            	}
	 else 
		{
                lightmapcolor = lightmapTexel.rgb * lightmap_r_color * lightmapFactor.r;
            	}
       fragColor.rgb = max(fragColor.rgb, lightmapcolor.rgb * gl_FrontMaterial.diffuse.rgb * smoothstep(0.0, 1.0, texel.rgb*.5 + lightmapcolor.rgb*.5));
	}

fragColor.rgb = filter_combined(fragColor.rgb);

gl_FragColor = fragColor;


}

