// ========================================
// FUNÇÕES UTILITÁRIAS GERAIS
// ========================================

// Função para verificar se há gamepad conectado
function gamepad_connected(){
    return gamepad_is_connected(0);
}

// Função para aplicar vibração no gamepad (para feedback tátil)
function apply_gamepad_vibration(_left_motor = 0.3, _right_motor = 0.3){
    if (gamepad_connected()) {
        gamepad_set_vibration(0, _left_motor, _right_motor);
    }
}

// Função para vibração suave quando acerta golpe
function gamepad_vibrate_hit(){
    gamepad_set_vibration(0, 0.15, 0.2); // Vibração suave para acerto
}

// Função para vibração quando toma dano (para ser usada pelo player)
function gamepad_vibrate_damage_quick(){
    gamepad_set_vibration(0, 0.6, 0.3); // Vibração mais intensa para dano
    // Definir timer no player para parar a vibração
    if (instance_exists(obj_player)) {
        with(obj_player) {
            vibration_timer = 12; // 12 frames para duração adequada
        }
    }
}

// Função para parar vibração do gamepad
function stop_gamepad_vibration(){
    gamepad_set_vibration(0, 0, 0);
}

function gravidade (_grav = .2){
	z += velz;
	
	if (z < 0){
		velz += _grav;
	}
	else {
		velz = 0;
		z = 0;
		estado = estado_idle;
	}
}

//sistema de dano

function scr_dano(_x1, _y1, _x2, _y2) constructor
{
	my_x = 0;
	my_y = 0;
	my_z = 0;
	
	x1 = _x1;
	x2 = _x2;
	y1 = _y1;
	y2 = _y2;
	
	// Lista para rastrear quem já foi atingido por este ataque específico
	inimigos_atingidos = [];
}

function scr_hurtbox(_x1,_y1,_x2,_y2) : scr_dano(_x1,_y1,_x2,_y2) constructor{

}

// Funções auxiliares para structs de dano
function atualizar_posicao_struct(struct, _x, _y, _z) {
	if (is_struct(struct)) {
		struct.my_x = _x;
		struct.my_y = _y;
		struct.my_z = _z;
	}
}

function desenhar_area_struct(struct, _tipo = "hurtbox") {
	if (is_struct(struct)) {
		// Desenhar com cores diferentes para identificar tipo
		draw_set_alpha(0.3);
		if (_tipo == "damage") {
			draw_set_color(c_red); // Hitboxes de dano em vermelho
		} else {
			draw_set_color(c_blue); // Hurtboxes em azul
		}
		draw_rectangle(struct.x1 + struct.my_x, struct.y1 + struct.my_y + struct.my_z, 
		              struct.x2 + struct.my_x, struct.y2 + struct.my_y + struct.my_z, false);
		
		// Borda mais visível
		draw_set_alpha(1.0);
		draw_rectangle(struct.x1 + struct.my_x, struct.y1 + struct.my_y + struct.my_z, 
		              struct.x2 + struct.my_x, struct.y2 + struct.my_y + struct.my_z, true);
		
		draw_set_color(c_white);
		draw_set_alpha(1.0);
	}
}

// Função para checar colisão entre duas hitboxes
function checar_colisao_hitbox(hitbox1, hitbox2) {
    var x1_min = hitbox1.x1 + hitbox1.my_x;
    var y1_min = hitbox1.y1 + hitbox1.my_y + hitbox1.my_z;
    var x1_max = hitbox1.x2 + hitbox1.my_x;
    var y1_max = hitbox1.y2 + hitbox1.my_y + hitbox1.my_z;
    
    var x2_min = hitbox2.x1 + hitbox2.my_x;
    var y2_min = hitbox2.y1 + hitbox2.my_y + hitbox2.my_z;
    var x2_max = hitbox2.x2 + hitbox2.my_x;
    var y2_max = hitbox2.y2 + hitbox2.my_y + hitbox2.my_z;
    
    return rectangle_in_rectangle(x1_min, y1_min, x1_max, y1_max, x2_min, y2_min, x2_max, y2_max);
}

// Função para aplicar dano entre entidades
function aplicar_dano_entre_entidades(atacante, alvo) {
    if (!is_struct(atacante.my_damage) || alvo.morreu) return false;
    
    if (checar_colisao_hitbox(atacante.my_damage, alvo.my_hurtbox)) {
        // Verificar se este alvo já foi atingido por este ataque específico
        for (var i = 0; i < array_length(atacante.my_damage.inimigos_atingidos); i++) {
            if (atacante.my_damage.inimigos_atingidos[i] == alvo) {
                return false; // Já foi atingido por este ataque
            }
        }
        
        // Adicionar à lista de atingidos deste ataque
        array_push(atacante.my_damage.inimigos_atingidos, alvo);
        
        // Feedback tátil para o player quando acertar um golpe
        if (atacante.object_index == obj_player && gamepad_connected()) {
            gamepad_vibrate_hit(); // Vibração suave quando acerta golpe
        }
        
        // Se o atacante for o player, usar função sem cooldown
        if (atacante.object_index == obj_player) {
            return alvo.receber_dano_sem_cooldown(atacante.dano, atacante);
        } else {
            return alvo.receber_dano(atacante.dano, atacante);
        }
    }
    
    return false;
}

// Função para aplicar knockback baseado no tipo de ataque
function aplicar_knockback_por_ataque(atacante, alvo) {
    if (atacante.object_index == obj_player && alvo.object_index == obj_enemy1) {
        var _knockback_force = 2; // Força base
        
        // Ajustar força baseada no sprite/ataque
        switch(atacante.sprite_index) {
            case spr_player_kick:
                _knockback_force = 3; // Chute empurra mais
                break;
            case spr_player_punch1:
                _knockback_force = 2; // Soco normal
                break;
            case spr_player_jump_attack:
                _knockback_force = 4; // Ataque aéreo empurra muito
                break;
        }
        
        var _direction = point_direction(atacante.x, atacante.y, alvo.x, alvo.y);
        alvo.knockback_velh = lengthdir_x(_knockback_force, _direction);
        alvo.knockback_velv = lengthdir_y(_knockback_force, _direction);
    }
}

// Função para limpar lista de atacantes (usada quando começar novo ataque)
function limpar_atacantes_de_entidades() {
    with (obj_entidade) {
        lista_atacantes_recentes = [];
    }
}