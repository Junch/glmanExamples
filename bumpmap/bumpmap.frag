uniform float Ambient;
uniform float BumpDensity;
uniform float BumpSize;
uniform vec4  SurfaceColor;
uniform float Height;

varying vec3  LightDir;
varying vec3  Normal;

void main()
{
	vec3 normal;

	vec2 st = gl_TexCoord[0].st;		// locate the bumps based on (s,t)
	st.s *= 2.;				// makes the bumps round on the equator of the sphere

	vec2 c = BumpDensity * st;		// make lots more bumps
	vec2 uv = fract(c) - vec2(.5,.5);	// (u,v,w) are local coordinates for the bump normal
	uv *= 2.;				// change [-.5,-.5] to [-1.,1.]

	// in surface coords, the normal starts out to be (0,0,1) -- change it from there:

	float u = 0. + uv.s;	// normal perturbation in s
	float v = 0. + uv.t;	// normal perturbation in t
	float w = 1.;		// don't perturb in w


	// see if we are actually in a bump -- BumpSize is the radius:

	float dist2d = u*u + v*v;
	if( dist2d < BumpSize*BumpSize )
	{
		normal = normalize( vec3( Height*u, Height*v, w ) );
	}
	else
	{
		normal = vec3( 0., 0., 1. );
	}

	float intensity = Ambient + (1.-Ambient)*abs( dot(normal, LightDir) );
	vec3 litColor = SurfaceColor.rgb * intensity;
	
	gl_FragColor = vec4( litColor, SurfaceColor.a );
}
