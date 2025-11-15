ajusta_fundo = function(){
	// Pegar posição da câmera
	var _camera_x = camera_get_view_x(view_camera[0]);
	
	// Layer de fundo distante (mais lento = mais longe)
	var _layer_background = layer_get_id("Background");
	if (_layer_background != -1) {
		layer_x(_layer_background, _camera_x * 0.15); // 15% da velocidade - mais lento e suave
	}
	
	// Layer intermediária (se existir)
	var _layer_mid = layer_get_id("Backgrounds_2");
	if (_layer_mid != -1) {
		layer_x(_layer_mid, _camera_x * 0.10); // 35% da velocidade - movimento médio
	}
	
	// Layer de primeiro plano (se existir) - move mais rápido que a câmera
	var _layer_fore = layer_get_id("Foreground");
	if (_layer_fore != -1) {
		layer_x(_layer_fore, _camera_x * 1.05); // Apenas 5% mais rápido - muito mais suave
	}
}