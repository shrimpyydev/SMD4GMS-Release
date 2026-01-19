function build_smd_buffer(_model_struct,_format){

var length=array_length(_model_struct.triangles);
vertex_begin(_model_struct.model,_format);
for(var i=0; i<length; i++)
	{
	var current_tri=_model_struct.triangles[i];
	var current_vertex=current_tri[1];
	build_triangle_from_vertex(current_vertex,current_tri[0],_model_struct);
	var current_vertex=current_tri[2];
	build_triangle_from_vertex(current_vertex,current_tri[0],_model_struct);
	var current_vertex=current_tri[3];
	build_triangle_from_vertex(current_vertex,current_tri[0],_model_struct);



	}
vertex_end(_model_struct.model);
}