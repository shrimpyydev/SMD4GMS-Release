//direction+=0.5;
if(current_animation!=-1)
{
current_frame = (current_frame+0.25) mod array_length(current_animation);
}
else
{
current_frame = 0;	
}
//show_debug_message("Current frame is: "+string(current_frame));