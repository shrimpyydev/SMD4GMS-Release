function model_struct_cleanup(_model_struct){
struct_remove(_model_struct,"triangles");
struct_remove(_model_struct,"materials");
}