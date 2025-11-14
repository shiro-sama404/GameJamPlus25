// === SISTEMA DE CUTSCENE AVANÇADO ===
// Similar ao Graveyard Keeper / Papers Please

// Configurações da tela
gui_width = display_get_gui_width();
gui_height = display_get_gui_height();

// === ESTRUTURA DE DADOS DA CUTSCENE ===
// Usando cutscene de exemplo para demonstração
cutscene_data = [
    {
        text: "Era uma vez, em uma cidade sombria...",
        sprite: spr_teste,
        sound: noone,
        callback: function() {
            // Exemplo: parar música de fundo
            audio_stop_all();
        }
    },
    {
        text: "Nosso herói caminhava pelas ruas desertas, sem saber o que o esperava.",
        sprite: spr_teste,
        sound: noone,
        callback: noone
    },
    {
        text: "Agora é hora de lutar! O jogo vai começar.",
        sprite: spr_teste,
        sound: noone,
        callback: function() {
            // Este callback só será executado quando o usuário avançar este passo
            //show_debug_message("Callback executado! Indo para Room1...");
            room_goto_next(); // Descomente para usar
        }
    }
];

// === VARIÁVEIS DE CONTROLE ===
current_step = 0;
cutscene_finished = false;

// === EFEITO DE DIGITAÇÃO ===
text_visible_length = 0;
text_speed = 2; // Caracteres por frame
text_typing_sound_timer = 0;

// === LAYOUT E POSICIONAMENTO ===
// Área da imagem (metade superior da tela)
image_area_y = 0;
image_area_height = gui_height * 0.6;
image_x = gui_width / 2;
image_y = image_area_height / 2;

// Área do texto (parte inferior) - centralizado verticalmente
text_area_y = image_area_height;
text_area_height = gui_height - image_area_height;
text_margin = 60;

// Posição do texto centralizada
text_x = gui_width / 2;
text_y = text_area_y + (text_area_height / 2);
text_width = gui_width - (text_margin * 2);

// === CONTROLES ===
accept_input = true;
skip_typing_input = false;

// === FUNÇÕES AUXILIARES ===

// Função para inicializar um passo da cutscene
inicializar_passo = function() {
    if (current_step >= array_length(cutscene_data)) {
        finalizar_cutscene();
        return;
    }
    
    text_visible_length = 0;
    text_typing_sound_timer = 0;
    
    var step_data = cutscene_data[current_step];
    
    // Tocar som se especificado
    if (step_data.sound != noone && audio_exists(step_data.sound)) {
        audio_play_sound(step_data.sound, 1, false);
    }
    
    // NÃO executar callback aqui - apenas quando avançar o passo
}

// Função para executar callback do passo atual
executar_callback_atual = function() {
    if (current_step < array_length(cutscene_data)) {
        var step_data = cutscene_data[current_step];
        if (step_data.callback != noone && is_method(step_data.callback)) {
            step_data.callback();
        }
    }
}

// Função para avançar para o próximo passo
avancar_passo = function() {
    // Executar callback do passo atual ANTES de avançar
    executar_callback_atual();
    
    current_step++;
    
    if (current_step < array_length(cutscene_data)) {
        inicializar_passo();
    } else {
        finalizar_cutscene();
    }
}

// Função para finalizar a cutscene
finalizar_cutscene = function() {
    cutscene_finished = true;
    instance_destroy();
}

// === INICIALIZAÇÃO ===
inicializar_passo();