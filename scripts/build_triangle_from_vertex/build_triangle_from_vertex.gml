function build_triangle_from_vertex(_array,_material,_intermediate_struct)
{
//show_debug_message("data in triangle equals: "+string(_array));
var buff=_intermediate_struct.model;	
vertex_position_3d(buff,_array[1],_array[2],_array[3]);
vertex_normal(buff,_array[4],_array[5],_array[6]);
vertex_texcoord(buff,_array[7],_array[8]);
vertex_color(buff,c_white,1);	
vertex_float1(buff,_material+1);//material reference	
vertex_float1(buff,_array[0]);//legacy bone indicies
vertex_float4(buff,array_get_safe(_array,9),array_get_safe(_array,11),array_get_safe(_array,13),array_get_safe(_array,15));//weighted bone indicies
vertex_float4(buff,array_get_safe(_array,10),array_get_safe(_array,12),array_get_safe(_array,14),array_get_safe(_array,16));//bone weights


};
