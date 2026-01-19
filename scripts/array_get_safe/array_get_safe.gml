function array_get_safe(_array, _index, _fallback_value=0){
var length=array_length(_array);
if(_index+1 > length)
{

return 0;	
}
else
{
return array_get(_array,_index);	
}


}