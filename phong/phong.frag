#version 330 compatibility

in vec3 Position;
in vec3 Normal;

uniform vec4 Kdv4;
uniform float uLightX, uLightY, uLightZ;
uniform float uShiness;

struct LightInfo {
  vec4 Position; // Light position in eye coords.
  vec3 La;       // Ambient light intensity
  vec3 Ld;       // Diffuse light intensity
  vec3 Ls;       // Specular light intensity
};
LightInfo Light;

struct MaterialInfo {
  vec3 Ka;            // Ambient reflectivity
  vec3 Kd;            // Diffuse reflectivity
  vec3 Ks;            // Specular reflectivity
  float Shininess;    // Specular shininess factor
};
MaterialInfo Material;

layout( location = 0 ) out vec4 FragColor;

void init()
{
    Light.Position = vec4( uLightX, uLightY, uLightZ, 1.0);
    Light.La = vec3(0.4, 0.4, 0.4);
    Light.Ld = vec3(1.0, 1.0, 1.0);
    Light.Ls = vec3(1.0, 1.0, 1.0);
    Material.Ka = Kdv4.xyz;
    Material.Kd = Kdv4.xyz;
    Material.Ks = Kdv4.xyz;
    Material.Shininess = uShiness;
}

vec3 ads( )
{
    vec3 s = normalize( vec3(Light.Position) - Position );
    vec3 v = normalize(vec3(-Position));
    vec3 r = reflect( -s, Normal );
	float sDotN = max( dot(s,Normal), 0.0 );
	  
	vec3 ambient = Light.La * Material.Ka;
    vec3 diffuse = Light.Ld * Material.Kd * sDotN;
    vec3 spec = vec3(0.0);
    if( sDotN > 0.0 )
       spec = Light.Ls * Material.Ks *
              pow( max( dot(r,v), 0.0 ), Material.Shininess );

    vec3 LightIntensity = ambient + diffuse + spec;
	return LightIntensity;
}

void main() {
    init();
    FragColor = vec4(ads(), 1.0);
}
