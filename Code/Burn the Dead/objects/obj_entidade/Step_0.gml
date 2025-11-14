if (velh != 0){
	face = sign(velh);
}

// Aplicar knockback
if (knockback_velh != 0 || knockback_velv != 0) {
    // Verificar colisão horizontal
    if (!place_meeting(x + knockback_velh, y, obj_chao)) {
        x += knockback_velh;
    } else {
        knockback_velh = 0; // Parar knockback se colidir
    }
    
    // Verificar colisão vertical
    if (!place_meeting(x, y + knockback_velv, obj_chao)) {
        y += knockback_velv;
    } else {
        knockback_velv = 0; // Parar knockback se colidir
    }
    
    // Reduzir knockback gradualmente
    knockback_velh *= knockback_deceleracao;
    knockback_velv *= knockback_deceleracao;
    
    // Parar knockback quando for muito pequeno
    if (abs(knockback_velh) < 0.1) knockback_velh = 0;
    if (abs(knockback_velv) < 0.1) knockback_velv = 0;
}

// Gerenciar cooldown de dano
if (dano_cooldown_atual > 0) {
    dano_cooldown_atual--;
    if (dano_cooldown_atual <= 0) {
        // Limpar lista de atacantes quando o cooldown acabar
        lista_atacantes_recentes = [];
    }
}

// Gerenciar flash de dano
if (flash_dano > 0) {
    flash_dano--;
}

atualizar_posicao_struct(my_hurtbox, x, y, z);