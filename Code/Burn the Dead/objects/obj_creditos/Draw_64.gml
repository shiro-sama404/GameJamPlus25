// === DESENHAR CRÉDITOS DIRETAMENTE ===

// Fundo preto
draw_set_color(c_black);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

// Se ainda há mensagens para mostrar
if (creditos_atual < array_length(creditos_mensagens)) {
    // Configurar texto
    draw_set_font(fnt_menu);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_set_alpha(alpha_atual);
    
    // Desenhar texto atual centralizado
    var texto_atual = creditos_mensagens[creditos_atual];
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();
    
    draw_text_ext(gui_w / 2, gui_h / 2, texto_atual, -1, gui_w * 0.8);
    
    // Resetar alpha
    draw_set_alpha(1);
}

// Instruções de pular (sempre visíveis com baixa opacidade)
draw_set_alpha(0.5);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_color(c_gray);
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();
draw_text(gui_w / 2, gui_h - 30, "Pressione qualquer tecla para pular");

// Reset configurações completo
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);