// === DEBUG VISUAL DA CÂMERA ===
// Só desenha se estiver no modo debug

if (keyboard_check(vk_f1)) {
    draw_set_color(c_yellow);
    draw_set_alpha(0.3);
    
    // Desenhar zona morta
    var cam_center_x = camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]) / 2;
    var cam_center_y = camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]) / 2;
    
    var deadzone_left = cam_center_x - deadzone_width / 2;
    var deadzone_top = cam_center_y - deadzone_height / 2;
    
    draw_rectangle(deadzone_left, deadzone_top, 
                   deadzone_left + deadzone_width, 
                   deadzone_top + deadzone_height, false);
    
    // Desenhar centro da câmera
    draw_set_color(c_red);
    draw_set_alpha(1);
    draw_circle(cam_center_x, cam_center_y, 3, false);
    
    // Reset
    draw_set_color(c_white);
    draw_set_alpha(1);
}