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
- L: Dash
- Shift: Defesa (segure para defender)

GAMEPAD XBOX/XINPUT:
- Analógico Esquerdo / D-Pad: Movimento
- A (gp_face1): Pular
- B (gp_face2): Atacar  
- X (gp_face3): Ataque especial (mesmo que B por enquanto)
- Y (gp_face4): Reservado para futuras funcionalidades
- LB: Dash
- RB: Defesa (segure para defender)
*/

function player_controla(){
	// Input de teclado
	var _kb_up = keyboard_check(ord("W"));
	var _kb_down = keyboard_check(ord("S"));
	var _kb_left = keyboard_check(ord("A"));
	var _kb_right = keyboard_check(ord("D"));
	var _kb_jump = keyboard_check_pressed(ord("K"));
	var _kb_attack = keyboard_check_pressed(ord("J"));
	var _kb_dash = keyboard_check_pressed(ord("L")); // L para dash
	var _kb_defense = keyboard_check(vk_shift); // Shift para defesa
	
	// Input de gamepad (Player 1 - Gamepad 0)
	var _gp_up = gamepad_button_check(0, gp_padu) || gamepad_axis_value(0, gp_axislv) < -0.5;
	var _gp_down = gamepad_button_check(0, gp_padd) || gamepad_axis_value(0, gp_axislv) > 0.5;
	var _gp_left = gamepad_button_check(0, gp_padl) || gamepad_axis_value(0, gp_axislh) < -0.5;
	var _gp_right = gamepad_button_check(0, gp_padr) || gamepad_axis_value(0, gp_axislh) > 0.5;
	var _gp_jump = gamepad_button_check_pressed(0, gp_face1); // A/Cross - Pular
	var _gp_attack = gamepad_button_check_pressed(0, gp_face2) || gamepad_button_check_pressed(0, gp_face3); // B/Circle ou X/Square - Atacar
	var _gp_dash = gamepad_button_check_pressed(0, gp_shoulderlb); // LB - Dash
	var _gp_defense = gamepad_button_check(0, gp_shoulderrb); // RB - Defesa (segure)
	
	// Combinar inputs (teclado OU gamepad)
	up = _kb_up || _gp_up;
	down = _kb_down || _gp_down;
	left = _kb_left || _gp_left;
	right = _kb_right || _gp_right;
	jump = _kb_jump || _gp_jump;
	attack = _kb_attack || _gp_attack;
	dash = _kb_dash || _gp_dash;
	defense = _kb_defense || _gp_defense;

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
	// Só mudar sprite se não estiver em animação de dano
	if (!dano_animacao_ativa) {
		sprite_index = spr_player_idle;
	}
	player_controla();
	
	// Verificar defesa primeiro
	if (defense) {
		estado = player_estado_defense;
		return;
	}
	
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
	
	// Verificar dash
	if (dash && dash_disponivel) {
		// Determinar direção do dash baseado na face atual ou input
		dash_direcao = face; // Usar direção atual
		if (left) dash_direcao = -1;
		if (right) dash_direcao = 1;
		
		iniciar_dash();
	}
}

function player_estado_walk(){
	// Só mudar sprite se não estiver em animação de dano
	if (!dano_animacao_ativa) {
		sprite_index = spr_player_walk;
	}
	player_controla();
	
	// Verificar defesa primeiro
	if (defense) {
		estado = player_estado_defense;
		return;
	}
	
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
	
	// Verificar dash
	if (dash && dash_disponivel) {
		// Determinar direção do dash baseado no movimento atual
		dash_direcao = face;
		if (left) dash_direcao = -1;
		if (right) dash_direcao = 1;
		
		iniciar_dash();
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
		// Registrar primeiro ataque do combo
		registrar_ataque_combo();
	}
	
	if _attack && image_index >= image_number -1 {
		if sprite_index == spr_player_kick{
			sprite_index = spr_player_punch1;
			image_index = 0;
			buffer_attack = false; 
			// Limpar lista de atacantes para permitir novo dano
			limpar_atacantes_de_entidades();
			// Registrar segundo ataque do combo
			registrar_ataque_combo();
		}
		if sprite_index == spr_player_punch1 && buffer_attack{
			sprite_index = spr_player_jump_attack;
			image_index = 0;
			buffer_attack = false; 
			// Limpar lista de atacantes para permitir novo dano
			limpar_atacantes_de_entidades();
			// Registrar terceiro ataque do combo (finalizador)
			registrar_ataque_combo();
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
			// Só mudar sprite se não estiver em animação de dano
			if (!dano_animacao_ativa) {
				sprite_index = spr_player_jump;
				image_index = 0;
			}
		}
	}
	player_controla();
	velv = 0;
	
	if (image_index >= image_number-1){
		image_index = image_number -1;
	}
	
	if (velz > 0){
		// Só mudar sprite se não estiver em animação de dano
		if (!dano_animacao_ativa) {
			sprite_index = spr_player_caindo;
		}
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
		velh = face * 3; // Movimento horizontal inicial
		jump_kick2_impulso = false; // Resetar impulso
	}
	
	// Manter movimento horizontal durante o ataque
	if (image_index < image_number - 1) {
		velh = face * 2; // Movimento constante durante a animação
		jump_kick2_impulso = false;
	}
	
	if (image_index >= image_number -1){
		image_index = image_number -1;
		gravidade(grav*10);
		velh = face * 15; // Impulso final maior
		jump_kick2_impulso = true; // Ativar velocidade alta
		
		// Limpar hitbox de dano quando a animação termina
		if (is_struct(my_damage)) {
			delete my_damage;
			my_damage = noone;
		}
	}
}

// Função para iniciar o dash
function iniciar_dash() {
	dash_ativo = true;
	dash_disponivel = false;
	dash_timer = dash_cooldown;
	dash_timer_ativo = dash_duracao;
	
	// Limpar rastro anterior
	dash_trail = [];
	
	// Mudar para estado de dash
	estado = player_estado_dash;
	
	// Vibração leve no dash
	gamepad_vibrate_dash();
}

// Estado do dash
function player_estado_dash() {
	// Movimento rápido na direção do dash
	velh = dash_direcao * dash_velocidade;
	velv = 0; // Dash é só horizontal
	
	// Atualizar face
	face = dash_direcao;
	
	// Sprite de movimento rápido (usar sprite de walk por enquanto)
	// Só mudar sprite se não estiver em animação de dano
	if (!dano_animacao_ativa) {
		sprite_index = spr_player_walk;
	}
	
	// Adicionar posição atual ao rastro
	adicionar_rastro_dash();
	
	// Reduzir timer do dash
	dash_timer_ativo--;
	
	// Verificar se o dash terminou
	if (dash_timer_ativo <= 0) {
		dash_ativo = false;
		// Voltar ao movimento normal
		if (velh != 0) {
			estado = player_estado_walk;
		} else {
			estado = player_estado_idle;
		}
	}
}

// Estado de defesa
function player_estado_defense() {
	// Parar todo movimento e impedir novos inputs de movimento
	velh = 0;
	velv = 0;
	
	// Desativar qualquer animação de dano se estiver ativa
	if (dano_animacao_ativa) {
		dano_animacao_ativa = false;
		dano_animacao_timer = 0;
	}
	
	// Usar sprite de defesa
	sprite_index = spr_player_defense;
	
	// Se chegou no último frame, parar a animação
	if (image_index >= image_number - 1) {
		image_index = image_number - 1;
		image_speed = 0; // Parar animação no último frame
	}
	
	// Verificar inputs para sair da defesa (SEM chamar player_controla)
	// Input de teclado
	var _kb_defense = keyboard_check(vk_shift); // Shift para defesa
	
	// Input de gamepad (Player 1 - Gamepad 0)
	var _gp_defense = gamepad_button_check(0, gp_shoulderrb); // RB - Defesa (segure)
	
	// Combinar inputs (teclado OU gamepad)
	defense = _kb_defense || _gp_defense;
	
	// Sair da defesa quando soltar o botão
	if (!defense) {
		// Restaurar velocidade normal da animação
		image_speed = 1;
		estado = player_estado_idle;
	}
}

// Função para adicionar posição ao rastro
function adicionar_rastro_dash() {
	// Adicionar posição atual ao início da array
	array_insert(dash_trail, 0, {
		pos_x: x,
		pos_y: y,
		alpha: 1.0,
		sprite: sprite_index,
		image: image_index,
		face_dir: face
	});
	
	// Limitar número de rastros
	while (array_length(dash_trail) > dash_trail_max) {
		array_pop(dash_trail);
	}
}

// Função para atualizar o rastro do dash
function atualizar_rastro_dash() {
	// Reduzir alpha de todos os rastros
	for (var i = 0; i < array_length(dash_trail); i++) {
		dash_trail[i].alpha -= 0.15; // Desaparece rapidamente
		
		// Remover rastros invisíveis
		if (dash_trail[i].alpha <= 0) {
			array_delete(dash_trail, i, 1);
			i--; // Ajustar índice após remoção
		}
	}
}

// Função para desenhar o rastro do dash
function desenhar_rastro_dash() {
	// Desenhar todos os rastros com transparência decrescente
	for (var i = array_length(dash_trail) - 1; i >= 0; i--) {
		var _trail = dash_trail[i];
		
		// Calcular alpha e cor
		var _alpha = _trail.alpha;
		var _color = c_white; // Cor branca para ghosting
		
		// Desenhar sprite do rastro
		draw_sprite_ext(
			_trail.sprite,
			_trail.image,
			_trail.pos_x,
			_trail.pos_y,
			_trail.face_dir,  // scale X baseado na direção
			1,               // scale Y
			0,               // rotation
			_color,          // color
			_alpha * 0.6     // transparência com multiplicador para efeito mais sutil
		);
	}
}

// Função para registrar ataque e controlar combo
function registrar_ataque_combo() {
	// Incrementar contador de combo
	combo_count++;
	
	// Resetar timer de combo
	combo_timer = combo_timeout;
	
	// Aplicar vibração baseada no nível do combo
	gamepad_vibrate_attack(combo_count);
	
	// Limitar combo máximo
	if (combo_count > 3) {
		combo_count = 3;
	}
}