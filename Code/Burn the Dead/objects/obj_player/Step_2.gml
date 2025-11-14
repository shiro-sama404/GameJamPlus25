event_inherited();

// Durante o dash ou jump kick 2 impulso, usar velocidade máxima especial
if (dash_ativo || jump_kick2_impulso) {
    // Dash ou Jump Kick 2: usa vel_max_dash para permitir velocidade alta
    move_and_collide(velh, velv, obj_chao, 12, 0, 0, vel_max_dash, vel_max);
} else {
    // Movimento normal: usa vel_max normal (2) para controle
    move_and_collide(velh, velv, obj_chao, 12, 0, 0, vel_max, vel_max);
}
