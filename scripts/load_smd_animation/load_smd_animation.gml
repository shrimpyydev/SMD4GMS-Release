function load_smd_animation(_smdfile,_name,_nodes){
var _smd = buffer_load(_smdfile);
var buff_text = buffer_read(_smd,buffer_string);
buff_text = string_split(buff_text,"\n");




var state = SMD_STATE.NONE;
var final_array=[];//this is the array we will send to our intermediate model, it will be an "array of arrays" where each subarray contains frame specific matricies
var cache_array=[];//this is where we'll store the matricies for the frame we are actively parsing
var node_list={};
var array_lookup=array_map(_nodes,function(_element,_index){
return _element[0];
});

var length = array_length(buff_text);

for(var i=0; i<length; i++)
	{
		
	var line = string_trim(buff_text[i]);
    if (line == "" || line == "version 1") continue;

    switch (string_lower(line))
    {
        case "nodes":     state = SMD_STATE.NODES;     continue;
        case "skeleton":  state = SMD_STATE.SKELETON;  continue;
        case "end":       state = SMD_STATE.NONE;      continue;
    }
if(state == SMD_STATE.NODES){
var substring=string_split(line," ",1);
struct_set(node_list,substring[0],string_replace_all(substring[1],chr(34),""));

}
if(state == SMD_STATE.SKELETON)
	{
	if(string_pos("time",line)!=0)
		{
			//this checks if we are starting a new frame, if the cache array isn't empty, we push it into final array and clear it.
			if(array_length(cache_array)>0)
			{
			array_push(final_array,cache_array);
			cache_array=[];
			}
			continue;
		}
		else
		{
		//converts the contents of the current line into real numbers, builds a matrix out of it and puts it in the cache
		line=array_make_real(string_split(line," ",1));
		
		var bone_lookup = struct_get(node_list,string(line[0]));
		var map_index = array_get_index(array_lookup,bone_lookup);
		if(map_index==-1)//sometimes, animation files can have more nodes than the root model, used in editors for things like IK, this filters them out
		{
		continue;	
		}
		
		array_push(cache_array,smd_local_matrix(line[1],line[2],line[3],line[4],line[5],line[6]));
		
	
		}
	}

}

if(array_length(cache_array)>0)
			{
			array_push(final_array,cache_array);
			cache_array=[];
			}
if(!variable_global_exists("animation_handler"))
{
global.animation_handler={
animations : {},
baked_animations : {},
};	
}
struct_set(global.animation_handler.animations,_name,final_array);//put the animation we caclulated into the data 
struct_set(global.animation_handler.baked_animations,_name,bake_world_space(_nodes,final_array));//walk the animation heriarcy and prep it for GPU submission

}