event_inherited();
estado();

// Controlar vibração
if (vibration_timer > 0) {
    vibration_timer--;
    if (vibration_timer <= 0) {
        stop_gamepad_vibration(); // Para a vibração quando timer zera
    }
}

// Controlar cooldown do dash
if (dash_timer > 0) {
    dash_timer--;
    if (dash_timer <= 0) {
        dash_disponivel = true; // Dash disponível novamente
    }
}

// Controlar sistema de combo
if (combo_timer > 0) {
    combo_timer--;
    if (combo_timer <= 0) {
        combo_count = 0; // Resetar combo após timeout
    }
}

// Controlar sistema de invencibilidade
if (invencibilidade_ativa) {
    invencibilidade_timer--;
    if (invencibilidade_timer <= 0) {
        invencibilidade_ativa = false;
    }
}

// Atualizar efeito de rastro
if (dash_ativo || array_length(dash_trail) > 0) {
    atualizar_rastro_dash();
}

if (is_struct(my_damage)){
	atualizar_posicao_struct(my_damage, x, y, z);
	
	// Checar colisão com inimigos
	with (obj_enemy1) {
		if (aplicar_dano_entre_entidades(other, self)) {
			// Dano foi aplicado
		}
	}
}

// Checar se está recebendo dano de inimigos
with (obj_enemy1) {
	if (aplicar_dano_entre_entidades(self, other)) {
		// Player recebeu dano
	}
}

// Controlar animação de dano (só se não estiver defendendo)
if (dano_animacao_ativa && estado != estado_defense) {
    dano_animacao_timer--;
    
    if (dano_animacao_timer <= 0) {
        // Terminar animação de dano
        dano_animacao_ativa = false;
        sprite_index = sprite_antes_dano; // Voltar ao sprite anterior
        image_index = 0;
    }
} else if (estado == estado_defense && dano_animacao_ativa) {
    // Se entrou em defesa durante animação de dano, cancelar
    dano_animacao_ativa = false;
    dano_animacao_timer = 0;
}

atualizar_posicao_struct(my_hurtbox, x, y, z);