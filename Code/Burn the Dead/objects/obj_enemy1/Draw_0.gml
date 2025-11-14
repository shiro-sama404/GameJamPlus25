// Aplicar alpha da morte se estiver morrendo
if (morreu && variable_instance_exists(id, "morte_alpha")) {
    image_alpha = morte_alpha;
}

// Inherit the parent event
event_inherited();

// Desenhar barra de vida acima da cabeça
if (!morreu && vida_atual < vida_maxima) {
    var _barra_largura = 40;
    var _barra_altura = 6;
    var _offset_y = -45; // Acima da cabeça
    
    var _barra_x = x - _barra_largura / 2;
    var _barra_y = y + z + _offset_y;
    
    // Calcular porcentagem de vida
    var _vida_percent = vida_atual / vida_maxima;
    var _vida_largura = _barra_largura * _vida_percent;
    
    // Desenhar fundo da barra
    draw_set_color(c_black);
    draw_rectangle(_barra_x - 1, _barra_y - 1, _barra_x + _barra_largura + 1, _barra_y + _barra_altura + 1, false);
    
    // Desenhar barra de vida
    var _cor_vida = _vida_percent > 0.6 ? c_green : (_vida_percent > 0.3 ? c_yellow : c_red);
    draw_set_color(_cor_vida);
    draw_rectangle(_barra_x, _barra_y, _barra_x + _vida_largura, _barra_y + _barra_altura, false);
    
    // Desenhar borda
    draw_set_color(c_white);
    draw_rectangle(_barra_x - 1, _barra_y - 1, _barra_x + _barra_largura + 1, _barra_y + _barra_altura + 1, true);
}

// Resetar cor
draw_set_color(c_white);

//draw_text(x,y - 30, timer_estado);

//draw_circle(x,y,area_ranged,true);

//draw_rectangle(my_x, my_y + 10, my_x + alcance_x * face,my_y - alcance_y,true);

//draw_rectangle(ponto_x, ponto_y, ponto_x + tamanho * -face, ponto_y + tamanho, true);

