// === SISTEMA DE CÂMERA AVANÇADO ===

// Configurações da câmera
cam = view_camera[0];
follow = obj_player; // Objeto a seguir

// Posição atual da câmera
cam_x = x;
cam_y = y;

// Configurações de suavização
follow_speed = 0.08;        // Velocidade de seguimento mais suave (0.05 = muito lento, 0.15 = rápido)
look_ahead_distance = 40;   // Distância de antecipação reduzida
look_ahead_speed = 0.05;    // Velocidade da antecipação

// Limites da câmera (definir conforme o tamanho da room)
cam_left_limit = 0;
cam_right_limit = room_width - camera_get_view_width(cam);
cam_top_limit = 0;
cam_bottom_limit = room_height - camera_get_view_height(cam);

// Configurações de zona morta (deadzone) - agora mais suave
deadzone_width = 60;   // Largura da zona morta reduzida
deadzone_height = 30;  // Altura da zona morta reduzida

// Posição alvo da câmera
target_x = x;
target_y = y;

// Configurações de shake da câmera
shake_magnitude = 0;
shake_duration = 0;
shake_timer = 0;

// Funções de controle da câmera
aplicar_camera_shake = function(_magnitude, _duration) {
    shake_magnitude = _magnitude;
    shake_duration = _duration;
    shake_timer = _duration;
}

// Função para definir limites da câmera
definir_limites_camera = function(_left, _top, _right, _bottom) {
    cam_left_limit = _left;
    cam_top_limit = _top;
    cam_right_limit = _right - camera_get_view_width(cam);
    cam_bottom_limit = _bottom - camera_get_view_height(cam);
}