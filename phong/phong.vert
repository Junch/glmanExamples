#version 330 compatibility

out vec3 Position;
out vec3 Normal;

void main()
{
    Normal = normalize( uNormalMatrix * aNormal);
    Position = vec3( uModelViewMatrix * aVertex );

    gl_Position = uModelViewProjectionMatrix * aVertex;
}
