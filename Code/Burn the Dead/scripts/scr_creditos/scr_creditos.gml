// ========================================
// SISTEMA DE CRÉDITOS COM FADE
// ========================================

// Estados dos créditos
enum CREDITOS_STATE {
    FADE_IN,    // Aparecendo o texto
    SHOWING,    // Mostrando o texto
    FADE_OUT,   // Sumindo o texto
    FINISHED    // Todos os créditos terminaram
}

// Função para inicializar créditos
function creditos_inicializar() {
    // Mensagens dos créditos
    creditos_mensagens = [
        "Esse jogo é apenas uma prova de conceito,\nisso não representa a qualidade do produto final",
        "Todos os sprites, códigos e sons foram produzidos do zero por:\nLara, Miguel, Riva, Gilvas, Nathan e Arthur",
		"Todos os direitos reservados para Quick Yellow Guitars",
        "Jogue com Gamepad para ter uma melhor experiencia. Tenha um bom jogo"
    ];
    
    // Controle do sistema
    creditos_atual = 0;
    creditos_estado = CREDITOS_STATE.FADE_IN;
    
    // Controle de tempo e alpha
    alpha_atual = 0;
    fade_speed = 0.02; // Velocidade do fade (ajuste conforme necessário)
    tempo_mostrando = 0;
    tempo_para_mostrar = 180; // 3 segundos a 60fps
    
    // Interface
    gui_width = display_get_gui_width();
    gui_height = display_get_gui_height();
}

// Função para atualizar lógica dos créditos
function creditos_step() {
    switch(creditos_estado) {
        case CREDITOS_STATE.FADE_IN:
            alpha_atual += fade_speed;
            if (alpha_atual >= 1) {
                alpha_atual = 1;
                creditos_estado = CREDITOS_STATE.SHOWING;
                tempo_mostrando = tempo_para_mostrar;
            }
            break;
            
        case CREDITOS_STATE.SHOWING:
            tempo_mostrando--;
            if (tempo_mostrando <= 0) {
                creditos_estado = CREDITOS_STATE.FADE_OUT;
            }
            break;
            
        case CREDITOS_STATE.FADE_OUT:
            alpha_atual -= fade_speed;
            if (alpha_atual <= 0) {
                alpha_atual = 0;
                creditos_atual++;
                
                if (creditos_atual >= array_length(creditos_mensagens)) {
                    creditos_estado = CREDITOS_STATE.FINISHED;
                } else {
                    creditos_estado = CREDITOS_STATE.FADE_IN;
                }
            }
            break;
            
        case CREDITOS_STATE.FINISHED:
            // Ir para o menu
            room_goto(rm_menu);
            break;
    }
    
    // Permitir pular créditos com qualquer tecla ou botão
    var _input_skip = keyboard_check_pressed(vk_anykey) || 
                      gamepad_button_check_pressed(0, gp_face1) ||
                      gamepad_button_check_pressed(0, gp_start) ||
                      mouse_check_button_pressed(mb_left);
                      
    if (_input_skip) {
        room_goto(rm_menu);
    }
}

// Função para desenhar os créditos
function creditos_draw() {
    // Fundo preto
    draw_set_color(c_black);
    draw_rectangle(0, 0, gui_width, gui_height, false);
    
    // Se ainda há mensagens para mostrar
    if (creditos_atual < array_length(creditos_mensagens)) {
        // Configurar texto (mesma lógica da cutscene)
        draw_set_font(fnt_menu);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_set_alpha(alpha_atual);
        
        // Desenhar texto atual centralizado (lógica da cutscene)
        var texto_atual = creditos_mensagens[creditos_atual];
        var text_x = gui_width / 2;
        var text_y = gui_height / 2;
        var text_width = gui_width * 0.8;
        
        draw_text_ext(text_x, text_y, texto_atual, -1, text_width);
        
        // Resetar alpha
        draw_set_alpha(1);
    }
    
    // Instruções de pular (sempre visíveis com baixa opacidade)
    draw_set_alpha(0.5);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_gray);
    draw_text(gui_width / 2, gui_height - 30, "Pressione qualquer tecla para pular");
    
    // Reset configurações completo
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}