velh = 0;
velv = 0;
velz = 0;

z = 0;

vel_max = 2;
vel_pulo = 4;
grav = .15;
face = 1;
buffer_attack = false;

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
		velz = -vel_pulo;
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
		velz = -vel_pulo;
	}
	if (attack){
		estado = estado_ataque;
	}
}

estado_ataque = function(){
	
	velh = 0;
	
	var _attack = false;
	
	if (buffer_attack == true){
		_attack = true;
	}
	else{
		buffer_attack = keyboard_check_pressed(ord("J"));
	}
	
	if sprite_index != spr_player_punch1 && sprite_index != spr_player_kick && sprite_index != spr_player_jump_attack{
		image_index = 0;
		sprite_index = spr_player_kick;
	}
	
	if _attack && image_index >= image_number -1 {
		if sprite_index == spr_player_kick{
			sprite_index = spr_player_punch1;
			image_index = 0;
			buffer_attack = false; 
		}
		if sprite_index == spr_player_punch1 && buffer_attack{
			sprite_index = spr_player_jump_attack;
			image_index = 0;
			buffer_attack = false; 
		}
	}
	
	
	if (image_index >= image_number-1){
		estado = estado_idle;
		buffer_attack = false;
	}
}

estado_pulo = function(){
	
	if (sprite_index != spr_player_jump && velz <=0){
				
		if (sprite_index != spr_player_jump_attack){

			sprite_index = spr_player_jump;
			image_index = 0;
		}

	}
	controla_player();
	velv = 0;
	
	if (image_index >= image_number-1){
		image_index = image_number -1;
	}
	
	if (velz > 0){
		sprite_index = spr_player_caindo;
	}
	if (attack){
		estado = estado_jump_kick;
	}
	if (attack && down){
		estado = estado_jump_kick2;
	}

	gravidade(grav);
	
}

estado_jump_kick = function(){
	
	velz =.1;

	if(sprite_index != spr_player_jump_attack){

		
		sprite_index = spr_player_jump_attack
		image_index = 0;
	}
	
	if (image_index >= image_number - 1){
		estado = estado_pulo;
	}
	gravidade(); 
}
estado_jump_kick2 = function(){

	velv = 0;
	

	if sprite_index != spr_player_jump_attack2{
		sprite_index = spr_player_jump_attack2;
		image_index = 0;
		velh = 0;
	}
	
	if (image_index >= image_number -1){
		image_index = image_number -1;
		gravidade(grav*10);
		velh = face * 12;
	}
	
}

estado = estado_walk;

