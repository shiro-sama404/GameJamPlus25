event_inherited();
randomise();

my_x = x;
my_y = y;
alcance_x = 30;
alcance_y = 10;

//debug
ponto_x = 0;
ponto_y = 0;
tamanho = 10;
//debug

espera_estado = game_get_speed(gamespeed_fps)*2;
timer_estado = espera_estado;

area_ranged = 100;

alvo = noone;

timer_ataque = espera_estado;

checa_area = function(_tamanho_area = 0, _alvo = noone){
	
	if (_alvo == noone) return false
	
	return collision_circle(x,y, _tamanho_area, _alvo, 0,1);
	
}

estado_parado = function(){
	sprite_index = spr_enemy_idle;
	
	if timer_ataque > 0 {
		timer_ataque--;
	}
	
	velh = 0;
	velv = 0;
	
	timer_estado--;
	
	if (timer_estado <= 0){
		var _chance = random(1);
		if (_chance > .5){
			estado = estado_andando;
		}
		timer_estado = espera_estado;
	}
	
	alvo = checa_area(area_ranged, obj_player);
	if (alvo && timer_ataque <= 0)
	{
		estado = estado_persegue;
	}
}
estado_andando = function(){
	if timer_ataque > 0 {
		timer_ataque--;
	}
	
	if (sprite_index != spr_enemy_walk){
		sprite_index = spr_enemy_walk;
		image_index =0;
		
		velh = random_range(-1,1);
		velv = random_range(-1,1);
	}
	
	timer_estado--;
	if (timer_estado <= 0){
		estado = choose(estado_parado, estado_andando);
		timer_estado = espera_estado;
	}
	
	alvo = checa_area(area_ranged, obj_player);
	if (alvo && timer_ataque == 0)
	{
		estado = estado_persegue;
	}
}

estado_persegue = function(){
	
	my_y = y - sprite_height / 2;
	my_x = x;
	
	ponto_x = alvo.x;
	ponto_y = alvo.y - alvo.sprite_height /2 ;
	
	var _dist = point_distance(my_x,my_y, ponto_x, ponto_y);
	var _dir = point_direction(my_x,my_y, ponto_x, ponto_y);
	
	var _dist_x = abs(ponto_x - my_x);
	var _dist_y = abs(ponto_y - my_y);
		
	velh = lengthdir_x(_dist_x < 35 ? 0: .5, _dir);
	velv= lengthdir_y(_dist_y < 5 ? 0: .5, _dir); 

	if (sprite_index != spr_enemy_walk){
		sprite_index = spr_enemy_walk;
		image_index = 0;
	}
	
	var _atacar = rectangle_in_rectangle(my_x, my_y + 10, my_x + alcance_x * face,my_y - alcance_y,  ponto_x, ponto_y, ponto_x + tamanho * -face, ponto_y + tamanho)
	if (_atacar){
		estado = estado_ataque;
	}
	
}

estado_ataque = function(){
	velh = 0;
	velv = 0;

	if sprite_index != spr_enemy_attack1{
		sprite_index = spr_enemy_attack1
		image_index = 0;
	}
	if image_index > image_number -1 {
		estado = estado_parado;
		timer_ataque = espera_estado;
		delete my_damage;
	}
	
}
estado = estado_andando;