if (!shaders_are_supported())
{
	return;
}

// Attributes

// shader
shaders = true;
shader_layers = [];

// instances
player = obj_player;

// estados 
_state = "normal";
_last_state = noone;



// Methods

create_shader = function(_layer_name, _filter_name, _filter_parameter = pointer_null, _value = noone)
{
	var lay = layer_create(-10000, _layer_name);
	var _fx;
	
	switch (_filter_name)
	{
		case "_filter_screenshake":
			_fx = fx_create("_filter_screenshake");
			break;
		case "_filter_lowhp":
			_fx = fx_create("_filter_vignette");
			break;
		case "_filter_whitenoise":
			_fx = fx_create("_filter_whitenoise");
			break;
			
	}
	
	if (_fx != -1 && _filter_parameter != pointer_null && _value != noone)
	{
		fx_set_parameter(_fx, _filter_parameter, _value);	
	}
	
	layer_set_fx(lay, _fx);	
	
	var layer_name = layer_get_name(lay);
	
	array_push(shader_layers, layer_name);
	
	return;
}


destroy_shader_layer = function(_layer_name)
{
	var i = array_get_index(shader_layers, _layer_name);
	var ind = layer_get_id(_layer_name);
	layer_destroy(ind);
	array_delete(shader_layers, i, 1);
	
}