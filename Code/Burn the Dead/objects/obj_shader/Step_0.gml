if (instance_exists(player) && shaders)
{
	var _life_ratio = player.vida_atual / player.vida_maxima;
	
	var _low_hp_layer = layer_exists("LowHPShader");
	var _damage_shake_layer = layer_exists("DamageShake");
	var _damage_noise_layer = layer_exists("DamageNoise");
	
	var _hurt_state = player.hurt && !_damage_shake_layer && !_damage_noise_layer;
	var _left_hurt_state = !player.hurt && _damage_shake_layer && _damage_noise_layer;
	
	_state = _life_ratio <= .3 ? "lowhp" : "normal";
	
	switch(_state)
	{
		case "lowhp":
			
			if (!layer_exists("LowHPShader"))
			{
				create_shader("LowHPShader", "_filter_lowhp", "g_VignetteEdges", [.5, 1.2]);
			}
			
			break;
		
		default:
			
			if(_last_state == "lowhp" && _state == "normal")
			{
				destroy_shader_layer("LowHPShader");
			}
			
			
			break;
	}
	
	if (_hurt_state)
	{
		create_shader("DamageShake", "_filter_screenshake", "g_Magnitude", 6);
		create_shader("DamageNoise", "_filter_whitenoise", "g_WhiteNoiseAnimation", .5);
	}
	
	if (_left_hurt_state)
	{
		destroy_shader_layer("DamageShake");
		destroy_shader_layer("DamageNoise");
	}
			
	
	
	_last_state = _state;
	
}