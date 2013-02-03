varying vec4	Color;

uniform float Green;

void
main( void )
{
	gl_FragColor = Color;
	gl_FragColor.g = Green;
}
