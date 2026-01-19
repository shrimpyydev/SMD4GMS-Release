//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vNormal;
varying float mat_index;


uniform sampler2D mate1;
uniform sampler2D mate2;
uniform sampler2D mate3;
uniform sampler2D mate4;
uniform sampler2D mate5;
uniform sampler2D mate6;
uniform sampler2D mate7;
uniform sampler2D mate8;
void main()
{
    int samp_index = int(mat_index + 0.5);
	
	if(samp_index == 1)
	{
	gl_FragColor = v_vColour * texture2D( mate1, v_vTexcoord );	
	}
	else if(samp_index == 2)
	{
	gl_FragColor = v_vColour * texture2D( mate2, v_vTexcoord );	
	}
	else if(samp_index == 3)
	{
	gl_FragColor = v_vColour * texture2D( mate3, v_vTexcoord );	
	}
	else if(samp_index == 4)
	{
	gl_FragColor = v_vColour * texture2D( mate4, v_vTexcoord );	
	}
	else if(samp_index == 5)
	{
	gl_FragColor = v_vColour * texture2D( mate5, v_vTexcoord );	
	}
	else if(samp_index == 6)
	{
	gl_FragColor = v_vColour * texture2D( mate6, v_vTexcoord );	
	}
	else if(samp_index == 7)
	{
	gl_FragColor = v_vColour * texture2D( mate7, v_vTexcoord );	
	}
	else if(samp_index == 8)
	{
	gl_FragColor = v_vColour * texture2D( mate8, v_vTexcoord );	
	}
	else
	{
	gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	}
}
