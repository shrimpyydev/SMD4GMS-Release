function load_smd_model(_modelfile, _vertex_buff){

var _smd = buffer_load(_modelfile);
var buff_text = buffer_read(_smd,buffer_string);
buff_text = string_split(buff_text,"\n");



var model_struct =
{
	nodes : [],
	bones : [],	
	triangles : [],
	materials : [],
	texture_pointers : [],
	model : _vertex_buff,
	animations : {},
	shader : shd_render_smd,
}

var state = SMD_STATE.NONE;



var length = array_length(buff_text);

for(var i=0; i<length; i++)
	{
		
	var line = string_trim(buff_text[i]);
    if (line == "" || line == "version 1") continue;

    switch (string_lower(line))
    {
        case "nodes":     state = SMD_STATE.NODES;     continue;
        case "skeleton":  state = SMD_STATE.SKELETON;  continue;
        case "triangles": state = SMD_STATE.TRIANGLES; continue;
        case "end":       state = SMD_STATE.NONE;      continue;
    }	
	if(state==SMD_STATE.NODES){
	var substring = parse_smd_node_line(buff_text[i]);
	
	array_push(model_struct.nodes,[substring[0],real(substring[1])]); //packing the string reference to a node and the index of it's parent, they are ordered sequentially so the first number would be redundant as it's just the array index
	}
	else if(state==SMD_STATE.SKELETON){	
	var substring = string_split(string_trim(buff_text[i])," ",1);	
	
	if(substring[0]=="time"){continue};//this essentially creates a reference bind pose, bind pose does not needed to be animated so we aren't using time in this case as it's only ever going to be one frame.
	
	substring = array_make_real(substring); //convert all values in the array to real numbers.
	array_push(model_struct.bones,smd_local_matrix(substring[1],substring[2],substring[3],substring[4],substring[5],substring[6]));//builds bone matricies, SMD uses zyx order as opposed to GM's xyz, custom function to compose correctly
	}	
	else if(state==SMD_STATE.TRIANGLES){
		var substring = string_split(string_trim(buff_text[i])," ");//grab the first line in the triangle block, first line is assumed to be material
	//find if this is the first time encountering a given material, if so store it. Either way, get an index for it so we can assign it to the verticies we're parsing
	var material_index = array_get_index(model_struct.materials, substring[0]);
	var vertex_info=[];
	if(material_index==-1)
		{
		material_index=array_length(model_struct.materials);
		array_push(model_struct.materials,substring[0]);
		}
	//we won't be parsing triangles line by line, instead by groups of 4 lines, manually advancing the loop
	substring = array_make_real(string_split(string_trim(buff_text[i+1])," ",1));//grab all the triangles values, store them into an array and convert them into real numbers
	//show_debug_message("triangle_data: "+string(substring));
	//we are building an array that defines the triangle, the array contains a material index and three sub-arrays, and each of those contains data in the following structure: bone_id, px, py, pz, nx, ny, nz, u, v
	array_push(vertex_info,material_index);
	array_push(vertex_info,[substring[0],substring[1],substring[2],substring[3],substring[4],substring[5],substring[6],substring[7],substring[8],array_get_safe(substring,10),array_get_safe(substring,11),array_get_safe(substring,12),array_get_safe(substring,13),array_get_safe(substring,14),array_get_safe(substring,15),array_get_safe(substring,16),array_get_safe(substring,17)]);
	
	substring = array_make_real(string_split(string_trim(buff_text[i+2])," ",1));
	
	array_push(vertex_info,[substring[0],substring[1],substring[2],substring[3],substring[4],substring[5],substring[6],substring[7],substring[8],array_get_safe(substring,10),array_get_safe(substring,11),array_get_safe(substring,12),array_get_safe(substring,13),array_get_safe(substring,14),array_get_safe(substring,15),array_get_safe(substring,16),array_get_safe(substring,17)]);
	substring = array_make_real(string_split(string_trim(buff_text[i+3])," ",1));
	
	array_push(vertex_info,[substring[0],substring[1],substring[2],substring[3],substring[4],substring[5],substring[6],substring[7],substring[8],array_get_safe(substring,10),array_get_safe(substring,11),array_get_safe(substring,12),array_get_safe(substring,13),array_get_safe(substring,14),array_get_safe(substring,15),array_get_safe(substring,16),array_get_safe(substring,17)]);
	
	while(array_last(vertex_info[1])==0)
	{
	array_pop(vertex_info[1]);	
	}
	
	while(array_last(vertex_info[2])==0)
	{
	array_pop(vertex_info[2]);	
	}
	
	while(array_last(vertex_info[3])==0)
	{
	array_pop(vertex_info[3]);	
	}
	
	
	
	array_push(model_struct.triangles,vertex_info); //shove the whole parsed and constructed triangle into the main struct
	i+=3; //since the for loop is constructed to go line by line, manually advance past the lines we read by "looking ahead"
	
	}
	
	
	}

variable_struct_set(model_struct,"bind_pose",variable_clone(model_struct.bones));
variable_struct_set(model_struct,"bind_pose_bonetoworld",variable_clone(model_struct.bones));
variable_struct_set(model_struct,"inverse_bind",variable_clone(model_struct.bones));
struct_remove(model_struct,"bones");




buffer_delete(_smd);
populate_texture_pointers(model_struct);//aquires materials and puts them in the pointer.
build_bind_poses(model_struct);

return model_struct;
}