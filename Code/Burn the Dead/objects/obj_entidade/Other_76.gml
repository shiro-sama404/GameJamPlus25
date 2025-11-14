var _data = event_data[? "event_type"]; 
var _msg = event_data[? "message"];  

var _elemento =	event_data[? "element_id"];

if (layer_instance_get_instance(_elemento) == id){

	if (_data == "sprite event")
	{

	    if (_msg == "atacar")
	    {
			// Criar hitbox baseada na bounding box do sprite atual
			var _x1, _y1, _x2, _y2;
			
			// Obter a bounding box do sprite do ataque
			_x1 = (-sprite_xoffset + sprite_get_bbox_left(sprite_index)) * face;
			_y1 = -sprite_yoffset + sprite_get_bbox_top(sprite_index);
			_x2 = (-sprite_xoffset + sprite_get_bbox_right(sprite_index)) * face;
			_y2 = -sprite_yoffset + sprite_get_bbox_bottom(sprite_index);
			
			// Ajustar para a direção que a entidade está olhando
			if (face == -1) {
				var _temp = _x1;
				_x1 = _x2;
				_x2 = _temp;
			}
			
			// Criar hitbox com as dimensões do sprite
			my_damage = new scr_dano(_x1, _y1, _x2, _y2);
	    }
	}
}