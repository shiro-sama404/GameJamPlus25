event_inherited();
estado();

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

atualizar_posicao_struct(my_hurtbox, x, y, z);