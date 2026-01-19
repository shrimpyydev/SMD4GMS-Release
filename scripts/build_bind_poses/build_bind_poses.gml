// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function build_bind_poses(_intermediate_struct){
var bind_pose=_intermediate_struct.bind_pose;
var bind_pose_world=_intermediate_struct.bind_pose_bonetoworld;
var bind_inverse_pose=_intermediate_struct.inverse_bind
var nodes=_intermediate_struct.nodes;
var number_of_bones=array_length(nodes);

for(var i=0; i<number_of_bones; i++)
	{
	var current_node=nodes[i];	
	if(current_node[1]==-1)
		{
		matrix_inverse(bind_inverse_pose[i],bind_inverse_pose[i]);
		}
		else
		{
		matrix_multiply(bind_pose[i],bind_pose_world[current_node[1]],bind_pose_world[i]);
		
		}
	
	}


for(var i=0; i<number_of_bones; i++)
	{
	matrix_inverse(bind_pose_world[i],bind_inverse_pose[i]);
	
	}


}