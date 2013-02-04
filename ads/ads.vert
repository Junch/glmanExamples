#version 330 compatibility

uniform vec4 Kdv4;       // Diffuse reflectivity
uniform float uLightX, uLightY, uLightZ;
uniform float uShiness;

vec3 VertexPosition;
vec3 VertexNormal;

out vec3 LightIntensity;

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

mat4 ModelViewMatrix;
mat3 NormalMatrix;
mat4 ProjectionMatrix;
mat4 MVP;

void convert()
{
    Light.Position = vec4( uLightX, uLightY, uLightZ, 1.0);
    Light.La = vec3(0.4, 0.4, 0.4);
    Light.Ld = vec3(1.0, 1.0, 1.0);
    Light.Ls = vec3(1.0, 1.0, 1.0);
    Material.Ka = Kdv4.xyz;
    Material.Kd = Kdv4.xyz;
    Material.Ks = Kdv4.xyz;
    Material.Shininess = uShiness;

    ModelViewMatrix = uModelViewMatrix;
    NormalMatrix = uNormalMatrix;
    MVP = uModelViewProjectionMatrix;
    VertexNormal = aNormal;
    VertexPosition = aVertex.xyz;
}

void main()
{
    convert();

    vec3 tnorm = normalize( NormalMatrix * VertexNormal);
    vec4 eyeCoords = ModelViewMatrix * vec4(VertexPosition,1.0);
    vec3 s = normalize(vec3(Light.Position - eyeCoords));
    vec3 v = normalize(-eyeCoords.xyz);
    vec3 r = reflect(-s, tnorm);
    float sDotN = max( dot( s, tnorm ), 0.0 );
    vec3 ambient = Light.La * Material.Ka;
    vec3 diffuse = Light.Ld * Material.Kd * sDotN;
    vec3 spec = vec3(0.0);
    if (sDotN > 0.0)
       spec = Light.Ls * Material.Ks *
              pow( max( dot(r,v), 0.0 ), Material.Shininess );
    
    LightIntensity = ambient + diffuse + spec;
    gl_Position = MVP * vec4(VertexPosition,1.0);
}
