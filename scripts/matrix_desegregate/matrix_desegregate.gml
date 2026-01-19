// turns an array containing multiple matricies into one BIG continuous array
function matrix_desegregate(_array_of_matricies){
var length = array_length(_array_of_matricies);
var final_array=array_create(16*length);

for(var i=0; i<length; i++)
{
array_copy(final_array,16*i,_array_of_matricies[i],0,16);	
	
	
}

return final_array;
}