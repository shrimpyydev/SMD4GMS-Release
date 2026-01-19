
#region //vertex format
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_colour();
vertex_format_add_custom(vertex_type_float1, vertex_usage_colour);//material index, bound to in_Colour1
vertex_format_add_custom(vertex_type_float1, vertex_usage_colour);//bone index, bound to in_Colour2
vertex_format_add_custom(vertex_type_float4, vertex_usage_colour);//weighted bone indicies, bound to in_Colour3
vertex_format_add_custom(vertex_type_float4, vertex_usage_colour);//bone weights, bound to in_Colour4
standard_form = vertex_format_end();
#endregion


game_set_speed(display_get_frequency(),gamespeed_fps);

my_buff = vertex_create_buffer();
global.material_handler={}; //all materials are stored here, good practice to initialize but the scripts will create it if need be.
//the animation handler stores animations. 

global.animation_handler={
animations : {}, //these are animations stored with bones defined by a local matrix, they are not ready to be used as a uniform but you CAN use them in a pinch by calling just_in_time_btw() which immedietly processes and returns an animation.
baked_animations : {}, //baked_animations contain animations with fully computed matricies and are ready to be submitted as a shader uniform.
};
my_model=load_smd_model("Grappler.smd",my_buff); //loads the model, you just need a 


load_smd_animation("ggwalk.smd","Walk",my_model.nodes);


scale=20;
//scale=1;


build_smd_buffer(my_model,standard_form);

current_animation=global.animation_handler.baked_animations.Walk; //sets the current animation, must be previously imported via load_smd_animation 
//current_animation=-1; //uncomment to setto default pose

array_pop(global.animation_handler.baked_animations.Walk);//unique to the test model, just deleting a duplicate from frame.
current_frame=0;
direction=270;
model_struct_cleanup(my_model); //lots of data stored in the the struct is not needed after construction. This tidies things up.