#define M_2PI 6.28318530718
#define MAX_SIDES 999


vec4 RegularPoly( vec2 pos, float radius, int sides, vec4 color, float rot, vec2 frag )
{
	vec2 vi,vj;
	int j = sides - 1;
	bool c = false;

	float ir, jr;
	
	for( int i = 0; i < MAX_SIDES; i++ )
	{
		if( i >= sides )
			break;
		
		ir = float(i)/float(sides) * M_2PI + rot;
		jr = float(j)/float(sides) * M_2PI + rot;
		
		vi = vec2( sin( ir ) * radius, cos( ir ) * radius ) + pos;
		vj = vec2( sin( jr ) * radius, cos( jr ) * radius ) + pos;
		
		// From http://www.ecse.rpi.edu/~wrf/Research/Short_Notes/pnpoly.html
		if( ( ( vi.y > frag.y ) != ( vj.y > frag.y ) ) &&
			( frag.x < ( vj.x - vi.x ) * ( frag.y - vi.y ) / ( vj.y - vi.y ) + vi.x ) )
			c = !c;
		
		
		j = i;
	}
	
	if( c )	return color;
	else return vec4( 0,0,0,0 );
}


void main(void)
{
	vec2 uv = gl_FragCoord.xy;
	vec4 bg = vec4( 0,0,0,1 );
	vec4 p1 = RegularPoly( iMouse.xy, 50.0, 8, vec4( 1,1,0,1 ), -iGlobalTime, uv );
	vec4 p2 = RegularPoly( iMouse.xy, 20.0, 6, vec4( 1,0,0,1 ), iGlobalTime*2.0, uv );
	
	vec4 color = mix( p1, p2, p2.w );
	
	gl_FragColor = mix( bg, color, color.w );
}