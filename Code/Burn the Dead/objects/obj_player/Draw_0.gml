// Efeito visual de invencibilidade (piscando)
if (invencibilidade_ativa) {
    // Piscar a cada 4 frames
    if ((invencibilidade_timer div 4) mod 2 == 0) {
        // Desenhar com transparência reduzida
        draw_set_alpha(0.5);
        event_inherited();
        draw_set_alpha(1.0);
    } else {
        // Não desenhar (criar efeito de piscar)
        // Sprite fica invisível neste frame
    }
} else {
    // Desenho normal quando não está em invencibilidade
    event_inherited();
}
//draw_self();

// Desenhar rastro do dash
desenhar_rastro_dash();

//draw_sprite_ext(sprite_index,image_index,x,y + z,face,image_yscale,image_angle,image_blend,image_alpha); 

//draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom,true);


if (is_struct(my_damage)) {
	//desenhar_area_struct(my_damage, "damage");
}

//desenhar_area_struct(my_hurtbox, "hurtbox");