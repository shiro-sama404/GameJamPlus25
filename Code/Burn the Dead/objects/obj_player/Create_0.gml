velh = 0;
velv = 0;
velz = 0;

z = 0;

vel_max = 2;
vel_pulo = 4;
grav = .15;

up		= noone;
down	= noone;
left	= noone;
right	= noone;
jump	= noone;
attack	= noone;


controla_player = function(){
	

up		= keyboard_check(ord("W"));
down	= keyboard_check(ord("S"));
left	= keyboard_check(ord("A"));
right	= keyboard_check(ord("D"));
jump	= keyboard_check_pressed(ord("K"));

attack	= keyboard_check_pressed(ord("J"));

velh = (right - left) * vel_max;
velv = (down - up) * vel_max;

}


estado = noone;

estado_idle = function(){
	sprite_index = spr_player_idle;
	controla_player();
	
	//saindo do estado
	if velh != 0 or velv != 0{
		estado = estado_walk; 
	}
	if (jump){
		estado = estado_pulo;
	}
	
	if (attack){
		estado = estado_ataque;
	}
}

estado_walk = function(){
	sprite_index = spr_player_walk;
	controla_player();
	
		if velh == 0 && velv == 0{
		estado = estado_idle; 
	}
	if (jump){
		estado = estado_pulo;
	}
	if (attack){
		estado = estado_ataque;
	}
}

estado_ataque = function(){
	
	velh = 0;
	
	var _attack = keyboard_check_pressed(ord("J"))
	
	if sprite_index != spr_player_punch1 && sprite_index != spr_player_kick{
		image_index = 0;
		sprite_index = spr_player_kick;
	}
	
	if _attack {
		if sprite_index == spr_player_kick{
			image_index = 0;
			sprite_index = spr_player_punch1;
		}
	}
	
	
	if (image_index >= image_number-1){
		estado = estado_idle;
	}
}

estado_pulo = function(){
	
	if (sprite_index != spr_player_jump && velz <=0){
		sprite_index = spr_player_jump;
		image_index = 0;
		
		velz = -vel_pulo;
	}
	controla_player();
	
	if (image_index >= image_number-1){
		image_index = image_number -1;
	}
	
	if (velz > 0){
		sprite_index = spr_player_caindo;
	}
	z += velz;
	
	if (z < 0){
		velz += grav;
	}
	else {
		velz = 0;
		z = 0;
		estado = estado_idle;
	}
	
	
}

estado_jump_kick = function(){

	if(sprite_index != spr_player_jump_attack){
		sprite_index = spr_player_jump_attack
		image_index = 0;
	}
}
estado = estado_walk;

