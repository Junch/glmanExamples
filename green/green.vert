varying vec4	Color;

void
main( void )
{
	Color = gl_Color;
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}
