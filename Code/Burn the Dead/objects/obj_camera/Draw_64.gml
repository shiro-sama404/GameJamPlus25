// === DEBUG DA CÂMERA ===
// Informações de debug no canto superior esquerdo

if (keyboard_check(vk_f1)) {
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    var debug_x = 10;
    var debug_y = 10;
    var line_height = 20;
    var current_line = 0;
    
    // Informações da câmera
    draw_text(debug_x, debug_y + (current_line++ * line_height), "=== CÂMERA DEBUG ===");
    draw_text(debug_x, debug_y + (current_line++ * line_height), "Posição: " + string(round(cam_x)) + ", " + string(round(cam_y)));
    draw_text(debug_x, debug_y + (current_line++ * line_height), "Alvo: " + string(round(target_x)) + ", " + string(round(target_y)));
    draw_text(debug_x, debug_y + (current_line++ * line_height), "Follow Speed: " + string(follow_speed));
    
    if (instance_exists(follow)) {
        current_line++;
        draw_text(debug_x, debug_y + (current_line++ * line_height), "=== PLAYER ===");
        draw_text(debug_x, debug_y + (current_line++ * line_height), "Pos Player: " + string(round(follow.x)) + ", " + string(round(follow.y)));
        draw_text(debug_x, debug_y + (current_line++ * line_height), "Vel Player: " + string(follow.velh) + ", " + string(follow.velv));
    }
    
    if (shake_timer > 0) {
        current_line++;
        draw_text(debug_x, debug_y + (current_line++ * line_height), "=== SHAKE ===");
        draw_text(debug_x, debug_y + (current_line++ * line_height), "Magnitude: " + string(shake_magnitude));
        draw_text(debug_x, debug_y + (current_line++ * line_height), "Timer: " + string(shake_timer));
    }
    
    current_line++;
    draw_text(debug_x, debug_y + (current_line++ * line_height), "F1 - Toggle Debug");
}