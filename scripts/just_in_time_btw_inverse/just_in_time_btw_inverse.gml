// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function just_in_time_btw_inverse(_animation,_nodes){
//var scratch_array = variable_clone(_animation);
var solved_array = variable_clone(_animation);
var num_of_nodes=array_length(_nodes);

for(var i=0; i<num_of_nodes; i++)
{
	var current_node=_nodes[i];
	if(current_node[1]!=-1)
	{
	var heritage_array=[i,current_node[1]];
		while(current_node[1]!=-1)
		{
		current_node=_nodes[current_node[1]];	
		if(current_node[1]!=-1)
		{
		array_push(heritage_array,current_node[1]);	
		}
		}
		var current_matrix = matrix_build_identity();
		while(array_length(heritage_array)>0)
		{
		matrix_multiply(_animation[array_pop(heritage_array)],current_matrix,current_matrix);	
			
			
		}
		solved_array[i]=current_matrix;
		
	}
	
}
return solved_array;



}