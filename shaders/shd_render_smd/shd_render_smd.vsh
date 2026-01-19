#define max_bones 128 //this can be changed to as high a number as glsl and your system can support, but must be set at compile time to size matricies uniforms.
//old .smd files, such as those in HL1, baked movement into the model data. This version of the shader takes the translation data from the root bone and applies an equal and opposite translation. Use the other shader if this is not desired.

attribute vec3 in_Position;                  // (x,y,z)
attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.
attribute vec4 in_Colour0;					// (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

attribute float in_Colour1;					//material index,
attribute float in_Colour2;					//legacy bone index,
attribute vec4 in_Colour3;					//weighted bone index, this is mutually exclusive with legacy
attribute vec4 in_Colour4;					//bone weights


varying vec3 v_vNormal;
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

varying float mat_index;

uniform mat4 bone_matricies[max_bones];
uniform mat4 next_bone_matricies[max_bones];
uniform mat4 bone_restpos_matricies[max_bones];
uniform float blend;


void main()
{
    vec4 final_pos = vec4(0.0, 0.0, 0.0, 1.0);
	
	
	if(max(max(in_Colour4.x,in_Colour4.y),max(in_Colour4.z,in_Colour4.w)) == 0.0 )//early versions of .smd did not support bone weighting, this detects if there are no bone weights and processes it accordingly
	{
	mat4 bone = bone_matricies[0];
	mat4 next_bone = next_bone_matricies[0];
	vec4 object_space_pos = bone_matricies[int(in_Colour2)] * bone_restpos_matricies[int(in_Colour2)] * vec4( in_Position.x, in_Position.y, in_Position.z, 1.0) - vec4(bone[3].x,bone[3].y,bone[3].z,0.0);
    vec4 object_space_pos_next;
	if(blend!=0.0)
	{
	 object_space_pos_next = next_bone_matricies[int(in_Colour2)] * bone_restpos_matricies[int(in_Colour2)] * vec4( in_Position.x, in_Position.y, in_Position.z, 1.0)  - vec4(next_bone[3].x,next_bone[3].y,next_bone[3].z,0.0);	
	}
	else
	{
	object_space_pos_next = object_space_pos;	
	}
	final_pos = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * mix(object_space_pos,object_space_pos_next,blend);
	
	}
	else//This animates using boneweights. The legacy version of the shader samples both the current frame and next frame and linearly blends them, this is not supported with bone weights YET.
	{
	float reweight = 1.0 - (in_Colour4.x + in_Colour4.y + in_Colour4.z + in_Colour4.w); //if bone weights don't add up to 1, this grabs the remainder and toses it into the first bone.
	vec4 object_space_weight_1 = (bone_matricies[int(in_Colour3.x)] * bone_restpos_matricies[int(in_Colour3.x)] * vec4( in_Position.x, in_Position.y, in_Position.z, 1.0)) * vec4(in_Colour4.x + reweight);
	vec4 object_space_weight_2 = (bone_matricies[int(in_Colour3.y)] * bone_restpos_matricies[int(in_Colour3.y)] * vec4( in_Position.x, in_Position.y, in_Position.z, 1.0)) * vec4(in_Colour4.y);	
	vec4 object_space_weight_3 = (bone_matricies[int(in_Colour3.z)] * bone_restpos_matricies[int(in_Colour3.z)] * vec4( in_Position.x, in_Position.y, in_Position.z, 1.0)) * vec4(in_Colour4.z);	
	vec4 object_space_weight_4 = (bone_matricies[int(in_Colour3.w)] * bone_restpos_matricies[int(in_Colour3.w)] * vec4( in_Position.x, in_Position.y, in_Position.z, 1.0)) * vec4(in_Colour4.w);	
	vec4 object_space_pos = object_space_weight_1 + object_space_weight_2 + object_space_weight_3 + object_space_weight_4;
	
	final_pos = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
	}
	
	gl_Position = final_pos;
	
	
    
    v_vColour = in_Colour0;
    v_vTexcoord = vec2(in_TextureCoord.x,floor(in_TextureCoord.y) + 1.0 - fract(in_TextureCoord.y));
	v_vNormal = in_Normal;
	mat_index = in_Colour1;
}
