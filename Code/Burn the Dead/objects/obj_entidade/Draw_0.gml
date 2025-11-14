// Flash de dano
var _cor = flash_dano > 0 ? c_red : image_blend;
draw_sprite_ext(sprite_index,image_index,x,y + z,image_xscale * face ,image_yscale,image_angle,_cor,image_alpha); 


if (is_struct(my_damage)) {
	//desenhar_area_struct(my_damage, "damage");
}

//desenhar_area_struct(my_hurtbox, "hurtbox");