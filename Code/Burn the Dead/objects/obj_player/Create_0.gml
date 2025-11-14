// Herdar propriedades da entidade
event_inherited();

// Configurações específicas do player
vida_maxima = 100;
vida_atual = vida_maxima;
dano = 25;

velh = 0;
velv = 0;
velz = 0;

z = 0;

vel_max = 2;
vel_pulo = 4;
grav = .15;
face = 1;
buffer_attack = false;
my_damage = noone;

// Configurar hurtbox do player
hurtbox_x1 = -8;
hurtbox_y1 = -40;
hurtbox_x2 = 8;
hurtbox_y2 = 0;
my_hurtbox = new scr_hurtbox(hurtbox_x1, hurtbox_y1, hurtbox_x2, hurtbox_y2);

up		= noone;
down	= noone;
left	= noone;
right	= noone;
jump	= noone;
attack	= noone;

// Sobrescrever função de morte
morrer = function() {
    // Reiniciar o jogo quando o player morre
    game_restart();
}


controla_player = function(){
	

up		= keyboard_check(ord("W"));
down	= keyboard_check(ord("S"));
left	= keyboard_check(ord("A"));
right	= keyboard_check(ord("D"));
jump	= keyboard_check_pressed(ord("K"));

attack	= keyboard_check_pressed(ord("J"));

// Calcular direção do movimento
var _input_h = right - left;
var _input_v = down - up;

// Normalizar movimento diagonal para manter velocidade constante
if (_input_h != 0 && _input_v != 0) {
    // Movimento diagonal - normalizar o vetor
    var _magnitude = sqrt(_input_h * _input_h + _input_v * _input_v);
    velh = (_input_h / _magnitude) * vel_max;
    velv = (_input_v / _magnitude) * vel_max;
} else {
    // Movimento em linha reta
    velh = _input_h * vel_max;
    velv = _input_v * vel_max;
}

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
	velv = 0;
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
		// Limpar lista de atacantes para permitir novo dano
		limpar_atacantes_de_entidades();
	}
	
	if _attack && image_index >= image_number -1 {
		if sprite_index == spr_player_kick{
			sprite_index = spr_player_punch1;
			image_index = 0;
			buffer_attack = false; 
			// Limpar lista de atacantes para permitir novo dano
			limpar_atacantes_de_entidades();
		}
		if sprite_index == spr_player_punch1 && buffer_attack{
			sprite_index = spr_player_jump_attack;
			image_index = 0;
			buffer_attack = false; 
			// Limpar lista de atacantes para permitir novo dano
			limpar_atacantes_de_entidades();
		}
	}
	
	if (image_index >= image_number-1){
		estado = estado_idle;
		buffer_attack = false;
		
		// Limpar hitbox de dano quando a animação termina
		if (is_struct(my_damage)) {
			delete my_damage;
			my_damage = noone;
		}
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
		// Limpar lista de atacantes para permitir novo dano
		limpar_atacantes_de_entidades();
	}
	
	if (image_index >= image_number - 1){
		estado = estado_pulo;
		// Limpar hitbox de dano quando a animação termina
		if (is_struct(my_damage)) {
			delete my_damage;
			my_damage = noone;
		}
	}
	gravidade(grav); 
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

