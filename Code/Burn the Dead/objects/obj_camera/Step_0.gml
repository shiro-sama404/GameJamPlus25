// === LÓGICA DE SEGUIMENTO DA CÂMERA ===

if (instance_exists(follow)) {
    var follow_x = follow.x;
    var follow_y = follow.y;
    
    // === SISTEMA DE ANTECIPAÇÃO (LOOK AHEAD) ===
    var look_ahead_x = 0;
    var look_ahead_y = 0;
    
    // Antecipação horizontal suave baseada na direção do player
    if (follow.velh != 0) {
        look_ahead_x = follow.velh * look_ahead_distance * 0.5; // Usar velocidade real, não só direção
    }
    
    // Antecipação vertical suave
    if (follow.velv != 0) {
        look_ahead_y = follow.velv * look_ahead_distance * 0.3;
    }
    
    // === SISTEMA DE SEGUIMENTO SUAVE (SEM ZONA MORTA ABRUPTA) ===
    var cam_center_x = cam_x + camera_get_view_width(cam) / 2;
    var cam_center_y = cam_y + camera_get_view_height(cam) / 2;
    
    // Calcular posição alvo ideal
    var ideal_x = follow_x + look_ahead_x;
    var ideal_y = follow_y + look_ahead_y;
    
    // Calcular distância do centro da câmera até o player
    var dist_x = ideal_x - cam_center_x;
    var dist_y = ideal_y - cam_center_y;
    
    // Sistema de zona morta suave - quanto mais longe, mais rápido move
    var deadzone_factor_x = 1;
    var deadzone_factor_y = 1;
    
    // Se dentro da zona morta, reduzir velocidade
    if (abs(dist_x) < deadzone_width / 2) {
        deadzone_factor_x = abs(dist_x) / (deadzone_width / 2); // 0 a 1
    }
    
    if (abs(dist_y) < deadzone_height / 2) {
        deadzone_factor_y = abs(dist_y) / (deadzone_height / 2); // 0 a 1
    }
    
    // Aplicar movimento suave com aceleração baseada na distância
    var dynamic_speed_x = follow_speed * (0.3 + deadzone_factor_x * 0.7); // Velocidade mínima 30%
    var dynamic_speed_y = follow_speed * (0.3 + deadzone_factor_y * 0.7);
    
    // Posição alvo da câmera
    target_x = ideal_x - camera_get_view_width(cam) / 2;
    target_y = ideal_y - camera_get_view_height(cam) / 2;
    
    // === MOVIMENTO ULTRA SUAVE DA CÂMERA ===
    cam_x = lerp(cam_x, target_x, dynamic_speed_x);
    cam_y = lerp(cam_y, target_y, dynamic_speed_y);
    
    // === APLICAR LIMITES ===
    cam_x = clamp(cam_x, cam_left_limit, cam_right_limit);
    cam_y = clamp(cam_y, cam_top_limit, cam_bottom_limit);
}

// === SISTEMA DE SHAKE ===
var final_x = cam_x;
var final_y = cam_y;

if (shake_timer > 0) {
    shake_timer--;
    
    // Calcular intensidade do shake (diminui com o tempo)
    var shake_intensity = (shake_timer / shake_duration) * shake_magnitude;
    
    // Aplicar shake aleatório
    final_x += random_range(-shake_intensity, shake_intensity);
    final_y += random_range(-shake_intensity, shake_intensity);
}

// === ATUALIZAR POSIÇÃO DA CÂMERA ===
camera_set_view_pos(cam, final_x, final_y);

// Atualizar posição do objeto câmera para debug
x = final_x + camera_get_view_width(cam) / 2;
y = final_y + camera_get_view_height(cam) / 2;