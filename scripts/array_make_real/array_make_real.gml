function array_make_real(_array){
var length = array_length(_array);

var new_array = array_map(_array,function(_element,_index){
	return real(_element);	
})
return new_array;
}