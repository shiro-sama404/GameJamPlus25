if (cutscene_finished) exit;

// === ENTRADA DO USUÁRIO ===
var input_pressed = false;

// Verificar teclado e gamepad
if (accept_input) {
    var kb_input = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter);
    var gp_input = gamepad_button_check_pressed(0, gp_face1) || gamepad_button_check_pressed(0, gp_start);
    
    input_pressed = kb_input || gp_input;
    
    // Input para pular digitação
    skip_typing_input = keyboard_check_pressed(ord("X")) || gamepad_button_check_pressed(0, gp_face2);
}

// === EFEITO DE DIGITAÇÃO ===
var current_text = cutscene_data[current_step].text;
var text_total_length = string_length(current_text);
var text_is_complete = (text_visible_length >= text_total_length);

if (!text_is_complete) {
    // Pular digitação se pressionou X ou B
    if (skip_typing_input) {
        text_visible_length = text_total_length;
    } else {
        // Digitação normal
        text_visible_length += text_speed;
        text_visible_length = min(text_visible_length, text_total_length);
        
        // Som de digitação (opcional)
        text_typing_sound_timer--;
        if (text_typing_sound_timer <= 0 && text_visible_length < text_total_length) {
            // audio_play_sound(snd_typing, 1, false); // Descomente se tiver som de digitação
            text_typing_sound_timer = 3; // Tocar som a cada 3 frames
        }
    }
}

// === AVANÇO DE PASSO ===
if (input_pressed) {
    if (text_is_complete || text_visible_length >= text_total_length) {
        // Texto completo - avançar para próximo passo
        avancar_passo();
    } else {
        // Texto incompleto - completar instantaneamente
        text_visible_length = text_total_length;
        accept_input = false; // Pequeno delay para evitar duplo input
        alarm[0] = 10; // Reativar input em 10 frames
    }
}