// ========================================
// SISTEMA DE GAME OVER COM FADE
// ========================================

// Estados do Game Over
enum GAMEOVER_STATE {
    FADE_IN,    // Escurecendo a tela
    SHOWING,    // Mostrando Game Over
    WAITING     // Aguardando input do player
}

// Função para inicializar Game Over
function gameover_inicializar() {
    // Controle do sistema
    gameover_estado = GAMEOVER_STATE.FADE_IN;
    
    // Controle de alpha e fade
    alpha_fundo = 0;        // Alpha do fundo preto
    alpha_texto = 0;        // Alpha do texto
    fade_speed = 0.03;      // Velocidade do fade
    
    // Textos
    texto_gameover = "GAME OVER";
    texto_instrucao = "Pressione qualquer tecla para voltar ao menu";
    
    // Interface
    gui_width = display_get_gui_width();
    gui_height = display_get_gui_height();
}

// Função para atualizar lógica do Game Over
function gameover_step() {
    switch(gameover_estado) {
        case GAMEOVER_STATE.FADE_IN:
            // Escurecer fundo primeiro
            alpha_fundo += fade_speed;
            if (alpha_fundo >= 0.8) {
                alpha_fundo = 0.8;
                
                // Depois fazer texto aparecer
                alpha_texto += fade_speed * 2;
                if (alpha_texto >= 1) {
                    alpha_texto = 1;
                    gameover_estado = GAMEOVER_STATE.SHOWING;
                }
            }
            break;
            
        case GAMEOVER_STATE.SHOWING:
            // Aguardar um pouco antes de permitir input
            gameover_estado = GAMEOVER_STATE.WAITING;
            break;
            
        case GAMEOVER_STATE.WAITING:
            // Verificar input para voltar ao menu
            var _input_menu = keyboard_check_pressed(vk_anykey) || 
                              gamepad_button_check_pressed(0, gp_face1) ||
                              gamepad_button_check_pressed(0, gp_start) ||
                              mouse_check_button_pressed(mb_left);
                              
            if (_input_menu) {
                // Tocar som de click se disponível
                if (audio_exists(snd_click)) {
                    audio_play_sound(snd_click, 1, false);
                }
                
                // Voltar ao menu
				audio_stop_sound(snd_ruido_fundo);
				audio_stop_sound(snd_combat_music);
                room_goto(rm_menu);
            }
            break;
    }
}

// Função para desenhar o Game Over
function gameover_draw() {
    // Fundo escuro
    draw_set_color(c_black);
    draw_set_alpha(alpha_fundo);
    draw_rectangle(0, 0, gui_width, gui_height, false);
    
    // Texto GAME OVER
    if (alpha_texto > 0) {
        draw_set_alpha(alpha_texto);
        draw_set_color(c_red);
        draw_set_font(fnt_menu);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        // Game Over principal
        var _game_over_y = gui_height * 0.4;
        draw_text_transformed(gui_width / 2, _game_over_y, texto_gameover, 2, 2, 0);
        
        // Instrução para continuar
        draw_set_color(c_white);
        draw_set_alpha(alpha_texto * 0.7);
        var _instrucao_y = gui_height * 0.6;
        draw_text(gui_width / 2, _instrucao_y, texto_instrucao);
    }
    
    // Reset configurações
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}