// Inherit the parent event
event_inherited();

// Atualizar cooldown de knockback
if (knocback_cooldown > 0) {
    knocback_cooldown--;
}

// Atualizar estado de recuperação
if (recuperacao_ativa) {
    recuperacao_timer--;
    if (recuperacao_timer <= 0) {
        recuperacao_ativa = false;
    }
}

// Só executar lógica se não estiver morto
if (!morreu) {
    estado();

    if (is_struct(my_damage)){
        atualizar_posicao_struct(my_damage, x, y, z);
    }
} else {
    // Se estiver morto, executar estado de morte
    estado();
}