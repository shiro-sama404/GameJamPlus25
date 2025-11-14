event_inherited();

// Durante o dash, usar velocidade máxima especial
if (dash_ativo) {
    // Dash: usa vel_max_dash para permitir velocidade alta
    move_and_collide(velh, velv, obj_chao, 12, 0, 0, vel_max_dash, vel_max);
} else {
    // Movimento normal: usa vel_max normal (2) para controle
    move_and_collide(velh, velv, obj_chao, 12, 0, 0, vel_max, vel_max);
}
