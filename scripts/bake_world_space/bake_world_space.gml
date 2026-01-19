// takes an animation and performs recursive matrix multiplication from root to child, this is what is passed to the shader
function bake_world_space(_nodes, _animation){
var num_of_nodes = array_length(_nodes);
var frame_count = array_length(_animation);
var solved_array = variable_clone(_animation);

for(var i=0; i<frame_count; i++)
	{
	var bone_array=_animation[i];
	solved_array[i] = just_in_time_btw(_animation[i],_nodes);
	
	}

return solved_array;
}