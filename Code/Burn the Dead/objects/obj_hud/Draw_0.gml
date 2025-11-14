// Teste simples do HUD
draw_set_color(c_white);
draw_text(20, 20, "HUD FUNCIONANDO!");

// Procurar o player na room
var _player = instance_find(obj_player, 0);
if (_player != noone) {
    draw_text(20, 40, "Player vida: " + string(_player.vida_atual) + "/" + string(_player.vida_maxima));
    
    // Desenhar barra de vida simples
    var _barra_x = 20;
    var _barra_y = 60;
    var _barra_largura = 200;
    var _barra_altura = 20;
    
    // Fundo da barra
    draw_set_color(c_black);
    draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_largura, _barra_y + _barra_altura, false);
    
    // Barra de vida
    var _vida_percent = _player.vida_atual / _player.vida_maxima;
    var _vida_largura = _barra_largura * _vida_percent;
    draw_set_color(c_red);
    draw_rectangle(_barra_x, _barra_y, _barra_x + _vida_largura, _barra_y + _barra_altura, false);
    
    // Borda
    draw_set_color(c_white);
    draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_largura, _barra_y + _barra_altura, true);
}

draw_set_color(c_white);