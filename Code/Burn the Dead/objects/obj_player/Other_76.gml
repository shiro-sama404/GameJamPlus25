var _data = event_data[? "event_type"]; 
var _msg = event_data[? "message"];  

var _elemento = event_data[? "element_id"];

if (layer_instance_get_instance(_elemento) == id){

	if (_data == "sprite event")
	{
	    if (_msg == "atacar")
	    {
			// Criar hitbox específica baseada no sprite atual
			switch(sprite_index) {
				case spr_player_kick:
					// Kick - ataque de perna, alcance médio
					my_damage = new scr_dano(face * 12, -16, face * 28, -4);
					break;
					
				case spr_player_punch1:
					// Punch - soco próximo, mais rápido
					my_damage = new scr_dano(face * 8, -20, face * 22, -8);
					break;
					
				case spr_player_jump_attack:
					// Combo final ou jump attack - área maior, mais poderoso
					my_damage = new scr_dano(face * 8, -28, face * 32, -8);
					break;
					
				default:
					// Hitbox padrão se não encontrar sprite específico
					var _x1, _y1, _x2, _y2;
					_x1 = (-sprite_xoffset + sprite_get_bbox_left(sprite_index)) * face;
					_y1 = -sprite_yoffset + sprite_get_bbox_top(sprite_index);
					_x2 = (-sprite_xoffset + sprite_get_bbox_right(sprite_index)) * face;
					_y2 = -sprite_yoffset + sprite_get_bbox_bottom(sprite_index);
					my_damage = new scr_dano(_x1, _y1, _x2, _y2);
					break;
			}
	    }
	}
}