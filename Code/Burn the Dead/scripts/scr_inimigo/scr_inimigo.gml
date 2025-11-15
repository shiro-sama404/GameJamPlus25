// ========================================
// FUNÇÕES ESPECÍFICAS DOS INIMIGOS
// ========================================

function enemy_checa_area(_tamanho_area = 0, _alvo = noone){
	if (_alvo == noone) return false
	return collision_circle(x,y, _tamanho_area, _alvo, 0,1);
}

function enemy_estado_parado(){
	sprite_index = spr_zombie_idle;
	
	// Não fazer nada se estiver em recuperação
	if (recuperacao_ativa) {
		velh = 0;
		velv = 0;
		return;
	}
	
	if timer_ataque > 0 {
		timer_ataque--;
	}
	
	velh = 0;
	velv = 0;
	
	timer_estado--;
	
	if (timer_estado <= 0){
		var _chance = random(1);
		if (_chance > .5){
			estado = enemy_estado_andando;
		}
		timer_estado = espera_estado;
	}
	
	// Sempre verificar se há player próximo
	alvo = enemy_checa_area(area_ranged, obj_player);
	if (alvo && timer_ataque <= 0)
	{
		estado = enemy_estado_persegue;
	}
}

function enemy_estado_andando(){
	// Não fazer nada se estiver em recuperação
	if (recuperacao_ativa) {
		sprite_index = spr_zombie_idle;
		velh = 0;
		velv = 0;
		return;
	}
	
	if timer_ataque > 0 {
		timer_ataque--;
	}
	
	if (sprite_index != spr_zombie_walk){
		sprite_index = spr_zombie_walk;
		image_index = 0;
		
		// Movimento aleatório mais suave
		var _dir = random(360);
		var _speed = 0.5;
		velh = lengthdir_x(_speed, _dir);
		velv = lengthdir_y(_speed, _dir);
	}
	
	timer_estado--;
	if (timer_estado <= 0){
		estado = choose(enemy_estado_parado, enemy_estado_andando);
		timer_estado = espera_estado;
	}
	
	// Sempre verificar se há player próximo
	alvo = enemy_checa_area(area_ranged, obj_player);
	if (alvo && timer_ataque <= 0)
	{
		estado = enemy_estado_persegue;
	}
}

function enemy_estado_persegue(){
	if (!instance_exists(alvo)) {
		estado = enemy_estado_parado;
		return;
	}
	
	// Não fazer nada se estiver em recuperação
	if (recuperacao_ativa) {
		sprite_index = spr_zombie_idle;
		velh = 0;
		velv = 0;
		return;
	}
	
	// Posições centralizadas para cálculo mais preciso
	my_x = x;
	my_y = y - sprite_height / 2;
	
	ponto_x = alvo.x;
	ponto_y = alvo.y - alvo.sprite_height / 2;
	
	// Calcular distâncias separadamente para melhor controle
	var _distancia_x = ponto_x - my_x;
	var _distancia_y = ponto_y - my_y;
	var _distancia_x_abs = abs(_distancia_x);
	var _distancia_y_abs = abs(_distancia_y);
	var _distancia_total = point_distance(my_x, my_y, ponto_x, ponto_y);
	
    // Verificar se está na distância de ataque E bem alinhado no eixo Y
    var _tolerancia_y = 25; // Tolerância maior para alinhamento vertical (sprite maior)
    var _distancia_ideal = 45; // Distância ajustada para sprite maior do player
    var _alcance_x_maximo = 50; // Aumentado para alcançar o sprite maior	// Condições mais precisas para atacar baseadas na hitbox real: 
	// 1. Estar dentro do alcance real da hitbox (25 pixels)
	// 2. Estar bem alinhado verticalmente (15 pixels)
	// 3. Estar na distância X correta para a hitbox acertar
	// 4. Não estar em cooldown de knockback
	if (_distancia_total <= _distancia_ideal && _distancia_y_abs <= _tolerancia_y && _distancia_x_abs <= _alcance_x_maximo && knocback_cooldown <= 0) {
		// Parar movimento e atacar
		velh = 0;
		velv = 0;
		estado = enemy_estado_ataque;
		return;
	}
	
	// Movimento suave em direção ao player
	// Usar as distâncias já calculadas com direção
	
	// Normalizar movimento para velocidade consistente
	var _magnitude = sqrt(_distancia_x * _distancia_x + _distancia_y * _distancia_y);
	
	if (_magnitude > 0) {
		velh = (_distancia_x / _magnitude) * velocidade_perseguicao;
		velv = (_distancia_y / _magnitude) * velocidade_perseguicao;
		
        // Zona morta para movimento horizontal quando muito próximo e bem alinhado
        if (_distancia_total < alcance_ataque + 20 && _distancia_y_abs <= _tolerancia_y && _distancia_x_abs < 15) {
            velh = 0; // Parar movimento horizontal se estiver muito próximo e bem posicionado
        }		// Ajustar face baseado na direção (só se movimento horizontal for significativo)
		if (abs(_distancia_x) > 5) { // Só muda direção se diferença for maior que 5 pixels
			if (_distancia_x > 0) {
				face = 1;
			} else if (_distancia_x < 0) {
				face = -1;
			}
		}
		
		// ACELERAR quando próximo para ajuste rápido de posição Y
		// Priorizar movimento vertical quando próximo e mal alinhado
		if (_distancia_total < alcance_ataque + 35) {
			if (_distancia_y_abs > _tolerancia_y) {
				// Se está mal alinhado verticalmente, priorizar movimento Y
				velv *= 2.5;  // Acelerar muito a correção vertical
				velh *= 0.3;  // Reduzir drasticamente movimento horizontal
			} else if (_distancia_x_abs > alcance_ataque - 15) {
				// Se está bem alinhado Y mas longe em X, acelerar X
				velh *= 1.8;
				velv *= 0.8;
			} else {
				// Se está próximo mas não na posição ideal, movimento controlado
				velh *= 1.2;
				velv *= 1.2;
			}
		}
	}
	
	// Verificar se perdeu o player (muito longe)
	if (_distancia_total > alcance_deteccao + 30) {
		estado = enemy_estado_parado;
		alvo = noone;
	}
	
	// Sprite de caminhada
	if (sprite_index != spr_zombie_walk){
		sprite_index = spr_zombie_walk;
		image_index = 0;
	}
}

function enemy_estado_ataque(){
	velh = 0;
	velv = 0;

	// Verificar se o player ainda está no alcance E alinhado verticalmente
	if (instance_exists(alvo)) {
		var _dist_player = point_distance(x, y, alvo.x, alvo.y);
		var _dist_y = abs((alvo.y - alvo.sprite_height / 2) - (y - sprite_height / 2));
		var _dist_x = abs(alvo.x - x);
		var _tolerancia_y = 25; // Tolerância maior para sprite maior
		var _alcance_x_maximo = 50; // Ajustado para sprite maior do player
		
		if (_dist_player > 55 || _dist_y > _tolerancia_y + 10 || _dist_x > _alcance_x_maximo + 10) {
			// Player saiu do alcance efetivo, voltar a perseguir
			estado = enemy_estado_persegue;
			return;
		}
	}

	if sprite_index != spr_zombie_attack1{
		sprite_index = spr_zombie_attack1
		image_index = 0;
		// Limpar lista de atacantes para permitir novo dano
		limpar_atacantes_de_entidades();
	}
	if image_index > image_number -1 {
		// Ativar estado de recuperação
		recuperacao_ativa = true;
		recuperacao_timer = recuperacao_duracao;
		
		estado = enemy_estado_parado;
		timer_ataque = espera_estado;
		// Limpar hitbox de dano quando a animação termina
		if (is_struct(my_damage)) {
			delete my_damage;
			my_damage = noone;
		}
	}
}

// Estado de morte - reproduz animação de morte e controla fade out
function enemy_estado_morte(){
	// Parar qualquer movimento
	velh = 0;
	velv = 0;
	velz = 0;
	
	// Limpar hitbox de dano se existir
	if (is_struct(my_damage)) {
		delete my_damage;
		my_damage = noone;
	}
	
	// Controlar animação de morte
	if (!morte_animacao_completa) {
		// Verificar se animação terminou
		if (image_index >= image_number - 1) {
			// Travar no último frame
			image_index = image_number - 1;
			image_speed = 0; // Parar a animação
			morte_animacao_completa = true;
			morte_timer_fade = morte_fade_duracao; // Iniciar timer de 3 segundos
		}
	} else {
		// Garantir que permanece no último frame
		image_index = image_number - 1;
		image_speed = 0;
		
		// Animação completa, iniciar fade out
		if (morte_timer_fade > 0) {
			morte_timer_fade--;
			// Calcular alpha para fade out suave
			morte_alpha = morte_timer_fade / morte_fade_duracao;
		} else {
			// Fade completo, destruir instância
			instance_destroy();
		}
	}
}