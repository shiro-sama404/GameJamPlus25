// HUD do Player - Draw GUI Event

// Contador de FPS para debug
draw_set_color(c_white);
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_text(display_get_gui_width() - 20, 20, "FPS: " + string(fps));

// HUD do Player - Draw GUI Event

// Contador de FPS para debug
draw_set_color(c_yellow);
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_text(display_get_gui_width() - 20, 20, "FPS: " + string(fps));

// Procurar o player na room
var _player = instance_find(obj_player, 0);

if (_player != noone && !_player.morreu) {
    
    // Configurações da barra de vida
    var _margin = 20;
    var _barra_largura = 200;
    var _barra_altura = 20;
    var _barra_x = _margin;
    var _barra_y = _margin;
    
    // Cores
    var _cor_fundo = c_black;
    var _cor_vida = c_red;
    var _cor_borda = c_white;
    
    // Calcular porcentagem de vida
    var _vida_percent = clamp(_player.vida_atual / _player.vida_maxima, 0, 1);
    var _vida_largura = _barra_largura * _vida_percent;
    
    // Desenhar fundo da barra
    draw_set_color(_cor_fundo);
    draw_rectangle(_barra_x - 2, _barra_y - 2, _barra_x + _barra_largura + 2, _barra_y + _barra_altura + 2, false);
    
    // Desenhar barra de vida
    draw_set_color(_cor_vida);
    draw_rectangle(_barra_x, _barra_y, _barra_x + _vida_largura, _barra_y + _barra_altura, false);
    
    // Desenhar borda
    draw_set_color(_cor_borda);
    draw_rectangle(_barra_x - 2, _barra_y - 2, _barra_x + _barra_largura + 2, _barra_y + _barra_altura + 2, true);
    
    // Texto da vida (opcional)
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(_barra_x, _barra_y + _barra_altura + 5, "HP: " + string(floor(_player.vida_atual)) + "/" + string(_player.vida_maxima));
}

// Resetar configurações de desenho
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);