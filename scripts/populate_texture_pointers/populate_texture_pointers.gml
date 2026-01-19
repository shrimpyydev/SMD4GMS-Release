function populate_texture_pointers(_intermediate_struct){
var length = array_length(_intermediate_struct.materials);
if(length!=0)
	{
	for(var i=0; i<length; i++)
		{
		var current_material = _intermediate_struct.materials[i];//get the material name from a parsed .smd
		var material_info = string_split(current_material,"."); //seperate file name from file extension.
		show_debug_message(string(material_info));
		var preimported = asset_get_index(material_info[0]); //check to see if the texture has already been added to the project, returns -1 if not.
		if(preimported!=-1)
			{
			show_debug_message("We found the material");
			array_push(_intermediate_struct.texture_pointers,sprite_get_texture(preimported,0));
			}
			else
			{
				//current_material=string_replace(current_material,".bmp",".png");
				show_debug_message("Material not found, loading extern: "+current_material);
				show_debug_message("Checking for: "+current_material+" success: "+string(file_exists(current_material))+" attempting to append .png extension");
				if(!file_exists(current_material))
				{
				current_material+=".png";	
				show_debug_message("Material not found, loading extern: "+current_material);
				show_debug_message("Checking for: "+current_material+" success: "+string(file_exists(current_material))+" attempting to append .png extension");
				
				}
				
				
				if(!variable_global_exists("material_handler"))
				{
				global.material_handler	= {};
				}
			struct_set(global.material_handler,material_info[0],sprite_add(current_material,0,0,0,0,0));	
			array_push(_intermediate_struct.texture_pointers,sprite_get_texture(struct_get(global.material_handler,material_info[0]),0));	
			}
			
		}
	
	
	
	}
}