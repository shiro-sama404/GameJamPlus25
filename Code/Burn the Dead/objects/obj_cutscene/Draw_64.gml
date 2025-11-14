if (cutscene_finished) exit;

// === FUNDO ===
draw_set_color(c_black);
draw_rectangle(0, 0, gui_width, gui_height, false);

// === ÁREA DA IMAGEM ===
var current_sprite = cutscene_data[current_step].sprite;
if (current_sprite != noone && sprite_exists(current_sprite)) {
    // Calcular escala para ajustar imagem na área disponível
    var sprite_w = sprite_get_width(current_sprite);
    var sprite_h = sprite_get_height(current_sprite);
    var max_w = gui_width * 0.8;
    var max_h = image_area_height * 0.8;
    
    var scale_x = max_w / sprite_w;
    var scale_y = max_h / sprite_h;
    var final_scale = min(scale_x, scale_y);
    
    draw_sprite_ext(current_sprite, 0, image_x, image_y, final_scale, final_scale, 0, c_white, 1);
}

// === TEXTO ===
if (font_exists(fnt_cutscene_text)) {
    draw_set_font(fnt_cutscene_text);
} else {
    draw_set_font(-1); // Fonte padrão se a fonte customizada não existir
}

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);

// Texto com efeito de digitação
var full_text = cutscene_data[current_step].text;
var visible_text = string_copy(full_text, 1, text_visible_length);

draw_text_ext(text_x, text_y, visible_text, -1, text_width);

// === INDICADORES ===
var text_total_length = string_length(full_text);
var text_is_complete = (text_visible_length >= text_total_length);

if (text_is_complete) {
    // Seta piscando para indicar que pode avançar
    var blink = (current_time / 500) % 2 < 1;
    if (blink) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);
        draw_text(gui_width / 2, gui_height - 60, "▶");
    }
    
    // Instruções no canto
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_ltgray);
    var instructions = "SPACE/ENTER - Continue    X/B - Skip Text";
    draw_text(gui_width / 2, gui_height - 30, instructions);
} else {
    // Mostra que está digitando
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_yellow);
    draw_text(gui_width / 2, gui_height - 30, "X/B - Skip Typing");
}

// === CONTADOR DE PROGRESSO ===
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_color(c_gray);
var progress_text = string(current_step + 1) + " / " + string(array_length(cutscene_data));
draw_text(gui_width - 20, 20, progress_text);

// Reset das configurações de draw
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);