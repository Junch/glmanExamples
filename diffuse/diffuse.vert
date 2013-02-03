#version 330 compatibility

out vec3 LightIntensity;

uniform vec4 Kd;            // Diffuse reflectivity
uniform float uLightX, uLightY, uLightZ;

void main()
{
    vec3 LightPosition = vec3( uLightX, uLightY, uLightZ );
	vec3 Ld = vec3(1.0, 1.0, 1.0);
	
    vec3 tnorm = normalize( uNormalMatrix * aNormal);
    vec4 eyeCoords = uModelViewMatrix * aVertex;
    vec3 s = normalize(LightPosition - eyeCoords.xyz);

    LightIntensity = Ld * Kd.xyz * max( dot( s, tnorm ), 0.0 );

    gl_Position = uModelViewProjectionMatrix * aVertex;
}
