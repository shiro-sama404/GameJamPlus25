// Herdar propriedades da entidade
event_inherited();

// Configurações específicas do inimigo
vida_maxima = 100;
vida_atual = vida_maxima;
dano = 10;

// Configurar hurtbox do inimigo
hurtbox_x1 = -12;
hurtbox_y1 = -28;
hurtbox_x2 = 12;
hurtbox_y2 = 0;
my_hurtbox = new scr_hurtbox(hurtbox_x1, hurtbox_y1, hurtbox_x2, hurtbox_y2);

randomise();

my_x = x;
my_y = y;

// Configurações de alcance melhoradas
alcance_deteccao = 100;  // Distância para detectar o player
alcance_ataque = 35;     // Distância para atacar
velocidade_perseguicao = 1.0;

//debug
ponto_x = 0;
ponto_y = 0;
//debug

espera_estado = game_get_speed(gamespeed_fps)*2;
timer_estado = espera_estado;

area_ranged = alcance_deteccao;

alvo = noone;

timer_ataque = espera_estado;

// Sobrescrever função de morte
morrer = function() {
    // Destruir o inimigo quando morre
    instance_destroy();
}

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
	
	// Sempre verificar se há player próximo
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
		image_index = 0;
		
		// Movimento aleatório mais suave
		var _dir = random(360);
		var _speed = 0.5;
		velh = lengthdir_x(_speed, _dir);
		velv = lengthdir_y(_speed, _dir);
	}
	
	timer_estado--;
	if (timer_estado <= 0){
		estado = choose(estado_parado, estado_andando);
		timer_estado = espera_estado;
	}
	
	// Sempre verificar se há player próximo
	alvo = checa_area(area_ranged, obj_player);
	if (alvo && timer_ataque <= 0)
	{
		estado = estado_persegue;
	}
}

estado_persegue = function(){
	
	if (!instance_exists(alvo)) {
		estado = estado_parado;
		return;
	}
	
	// Posições centralizadas para cálculo mais preciso
	my_x = x;
	my_y = y - sprite_height / 2;
	
	ponto_x = alvo.x;
	ponto_y = alvo.y - alvo.sprite_height / 2;
	
	// Calcular distância real entre os centros
	var _distancia_total = point_distance(my_x, my_y, ponto_x, ponto_y);
	
	// Verificar se está na distância de ataque
	if (_distancia_total <= alcance_ataque) {
		// Parar movimento e atacar
		velh = 0;
		velv = 0;
		estado = estado_ataque;
		return;
	}
	
	// Movimento suave em direção ao player
	var _distancia_x = ponto_x - my_x;
	var _distancia_y = ponto_y - my_y;
	
	// Normalizar movimento para velocidade consistente
	var _magnitude = sqrt(_distancia_x * _distancia_x + _distancia_y * _distancia_y);
	
	if (_magnitude > 0) {
		velh = (_distancia_x / _magnitude) * velocidade_perseguicao;
		velv = (_distancia_y / _magnitude) * velocidade_perseguicao;
		
		// Ajustar face baseado na direção
		if (_distancia_x > 0) {
			face = 1;
		} else if (_distancia_x < 0) {
			face = -1;
		}
		
		// ACELERAR quando próximo para ajuste rápido de posição
		if (_distancia_total < alcance_ataque + 15) {
			velh *= 1.5;  // Aumentar velocidade para ajuste rápido
			velv *= 1.5;
		}
	}
	
	// Verificar se perdeu o player (muito longe)
	if (_distancia_total > alcance_deteccao + 20) {
		estado = estado_parado;
		alvo = noone;
	}
	
	// Sprite de caminhada
	if (sprite_index != spr_enemy_walk){
		sprite_index = spr_enemy_walk;
		image_index = 0;
	}
}

estado_ataque = function(){
	velh = 0;
	velv = 0;

	// Verificar se o player ainda está no alcance
	if (instance_exists(alvo)) {
		var _dist_player = point_distance(x, y, alvo.x, alvo.y);
		if (_dist_player > alcance_ataque + 15) {
			// Player saiu do alcance, voltar a perseguir
			estado = estado_persegue;
			return;
		}
	}

	if sprite_index != spr_enemy_attack1{
		sprite_index = spr_enemy_attack1
		image_index = 0;
		// Limpar lista de atacantes para permitir novo dano
		limpar_atacantes_de_entidades();
	}
	if image_index > image_number -1 {
		estado = estado_parado;
		timer_ataque = espera_estado;
		// Limpar hitbox de dano quando a animação termina
		if (is_struct(my_damage)) {
			delete my_damage;
			my_damage = noone;
		}
	}
}
estado = estado_andando;