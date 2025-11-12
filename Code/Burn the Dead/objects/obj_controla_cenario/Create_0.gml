ajusta_fundo = function(){
	var _layer = layer_get_id("Background");
	var _x = camera_get_view_x(view_camera[0]);
	layer_x(_layer, _x / 4);

}