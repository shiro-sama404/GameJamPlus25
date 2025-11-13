// Inherit the parent event
event_inherited();

//Definição dos estados do inimigo
estado_parado = function()
{
	sprite_index = spr_inimigo_idle;
	
	velh = 0;
	
	var _chance = random(1);
	
	if (_chance > .5)
	{
		estado = estado_move;
	}
	
}

estado_move = function()
{
	if (sprite_index != spr_inimigo_move)
	{
		sprite_index = spr_inimigo_move;
		image_index = 0;
		
		velh = random_range(-1, 1);
		velv = random_range(-1, 1);
	}
}

estado = estado_parado;