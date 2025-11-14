// ========================================
// FUNÇÕES ESPECÍFICAS DO PLAYER
// ========================================

/*
MAPEAMENTO DE CONTROLES:
========================

TECLADO:
- WASD: Movimento (W=Cima, A=Esquerda, S=Baixo, D=Direita)
- J: Atacar
- K: Pular

GAMEPAD XBOX/XINPUT:
- Analógico Esquerdo / D-Pad: Movimento
- A (gp_face1): Pular
- B (gp_face2): Atacar  
- X (gp_face3): Ataque especial (mesmo que B por enquanto)
- Y (gp_face4): Reservado para futuras funcionalidades
- LB/RB: Reservados para dash/esquiva
- LT/RT: Reservados para ataques carregados
*/

function player_controla(){
	// Input de teclado
	var _kb_up = keyboard_check(ord("W"));
	var _kb_down = keyboard_check(ord("S"));
	var _kb_left = keyboard_check(ord("A"));
	var _kb_right = keyboard_check(ord("D"));
	var _kb_jump = keyboard_check_pressed(ord("K"));
	var _kb_attack = keyboard_check_pressed(ord("J"));
	
	// Input de gamepad (Player 1 - Gamepad 0)
	var _gp_up = gamepad_button_check(0, gp_padu) || gamepad_axis_value(0, gp_axislv) < -0.5;
	var _gp_down = gamepad_button_check(0, gp_padd) || gamepad_axis_value(0, gp_axislv) > 0.5;
	var _gp_left = gamepad_button_check(0, gp_padl) || gamepad_axis_value(0, gp_axislh) < -0.5;
	var _gp_right = gamepad_button_check(0, gp_padr) || gamepad_axis_value(0, gp_axislh) > 0.5;
	var _gp_jump = gamepad_button_check_pressed(0, gp_face1); // A/Cross - Pular
	var _gp_attack = gamepad_button_check_pressed(0, gp_face2) || gamepad_button_check_pressed(0, gp_face3); // B/Circle ou X/Square - Atacar
	
	// Combinar inputs (teclado OU gamepad)
	up = _kb_up || _gp_up;
	down = _kb_down || _gp_down;
	left = _kb_left || _gp_left;
	right = _kb_right || _gp_right;
	jump = _kb_jump || _gp_jump;
	attack = _kb_attack || _gp_attack;

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

function player_estado_idle(){
	sprite_index = spr_player_idle;
	player_controla();
	
	//saindo do estado
	if velh != 0 or velv != 0{
		estado = player_estado_walk; 
	}
	if (jump){
		estado = player_estado_pulo;
		velz = -vel_pulo;
	}
	
	if (attack){
		estado = player_estado_ataque;
	}
}

function player_estado_walk(){
	sprite_index = spr_player_walk;
	player_controla();
	
	if velh == 0 && velv == 0{
		estado = player_estado_idle; 
	}
	if (jump){
		estado = player_estado_pulo;
		velz = -vel_pulo;
	}
	if (attack){
		estado = player_estado_ataque;
	}
}

function player_estado_ataque(){
	velv = 0;
	velh = 0;
	
	var _attack = false;
	
	if (buffer_attack == true){
		_attack = true;
	}
	else{
		// Verificar input de teclado e gamepad para ataques
		var _kb_attack = keyboard_check_pressed(ord("J"));
		var _gp_attack = gamepad_button_check_pressed(0, gp_face2) || gamepad_button_check_pressed(0, gp_face3); // B/Circle ou X/Square
		buffer_attack = _kb_attack || _gp_attack;
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
		estado = player_estado_idle;
		buffer_attack = false;
		
		// Limpar hitbox de dano quando a animação termina
		if (is_struct(my_damage)) {
			delete my_damage;
			my_damage = noone;
		}
	}
}

function player_estado_pulo(){
	if (sprite_index != spr_player_jump && velz <=0){
		if (sprite_index != spr_player_jump_attack){
			sprite_index = spr_player_jump;
			image_index = 0;
		}
	}
	player_controla();
	velv = 0;
	
	if (image_index >= image_number-1){
		image_index = image_number -1;
	}
	
	if (velz > 0){
		sprite_index = spr_player_caindo;
	}
	if (attack){
		estado = player_estado_jump_kick;
	}
	if (attack && down){
		estado = player_estado_jump_kick2;
	}

	gravidade(grav);
}

function player_estado_jump_kick(){
	velz =.1;

	if(sprite_index != spr_player_jump_attack){
		sprite_index = spr_player_jump_attack
		image_index = 0;
		// Limpar lista de atacantes para permitir novo dano
		limpar_atacantes_de_entidades();
	}
	
	if (image_index >= image_number - 1){
		estado = player_estado_pulo;
		// Limpar hitbox de dano quando a animação termina
		if (is_struct(my_damage)) {
			delete my_damage;
			my_damage = noone;
		}
	}
	gravidade(grav); 
}

function player_estado_jump_kick2(){
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