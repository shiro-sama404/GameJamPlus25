with(obj_entidade)
{
	var _escala = z * .002;
	
	//Desenha sombra para os personagens
	draw_sprite_ext(spr_sombra, 0, x, y, 1 + _escala, 1 + _escala, 0, c_black, .5);
}