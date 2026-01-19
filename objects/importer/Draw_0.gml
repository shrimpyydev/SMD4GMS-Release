
gpu_set_ztestenable(1);
gpu_set_zwriteenable(1);
gpu_set_alphatestenable(1);
var reorient_mat = matrix_multiply(matrix_build(0,0,0,0,0,-direction,1,1,1),matrix_multiply(matrix_build(0,0,0,-90,0,0,4,4,4),matrix_build(room_width/2,room_height/2,0,0,0,0,scale,scale,scale)));

matrix_set(matrix_world,reorient_mat);

shader_set(my_model.shader);
var animation_frame = shader_get_uniform(shader_current(),"bone_matricies");
var next_animation_frame = shader_get_uniform(shader_current(),"next_bone_matricies");
var rest_pos = shader_get_uniform(shader_current(),"bone_restpos_matricies");
shader_set_uniform_matrix_array(rest_pos,matrix_desegregate(my_model.inverse_bind));
if(current_animation!=-1)
{
shader_set_uniform_matrix_array(next_animation_frame,matrix_desegregate(current_animation[floor(current_frame + 1) mod array_length(current_animation)]));
shader_set_uniform_f(shader_get_uniform(shader_current(),"blend"),frac(current_frame));
shader_set_uniform_matrix_array(animation_frame,matrix_desegregate(current_animation[floor(current_frame)],my_model.nodes));
}
else
{
shader_set_uniform_matrix_array(next_animation_frame,matrix_desegregate(my_model.bind_pose_bonetoworld));
shader_set_uniform_f(shader_get_uniform(shader_current(),"blend"),0);
shader_set_uniform_matrix_array(animation_frame,matrix_desegregate(my_model.bind_pose_bonetoworld));
	
	
}
var length = array_length(my_model.texture_pointers);

	for(var i=0; i<length; i++)
	{
	var samp = shader_get_sampler_index(shd_render_smd, "mate"+string(i+1));
	texture_set_stage(samp,my_model.texture_pointers[i]);
	}


vertex_submit(my_model.model,pr_trianglelist,-1);
matrix_set(matrix_world,matrix_build_identity());
shader_reset();
