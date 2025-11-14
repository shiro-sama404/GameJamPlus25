// === EXEMPLO DE USO DO SISTEMA DE CUTSCENE ===
// Coloque este código em qualquer lugar onde quiser iniciar uma cutscene

// EXEMPLO 1: Cutscene simples de introdução
function criar_cutscene_intro() {
    var cutscene = instance_create_layer(0, 0, "Instances", obj_cutscene);
    
    cutscene.cutscene_data = [
        {
            text: "Era uma vez, em uma cidade sombria...",
            sprite: noone,
            sound: noone,
            callback: function() {
                // Mudar música de fundo
                audio_stop_all();
                // audio_play_sound(mus_intro, 1, true);
            }
        },
        {
            text: "Nosso herói caminhava pelas ruas desertas, sem saber o que o esperava.",
            sprite: noone, // Substitua por seu sprite
            sound: noone,
            callback: noone
        },
        {
            text: "Agora é hora de lutar!",
            sprite: noone,
            sound: noone,
            callback: function() {
                // Ir para a fase de jogo
                room_goto(Room1);
            }
        }
    ];
}

// EXEMPLO 2: Cutscene de Game Over
function criar_cutscene_game_over() {
    var cutscene = instance_create_layer(0, 0, "Instances", obj_cutscene);
    
    cutscene.cutscene_data = [
        {
            text: "Você foi derrotado...",
            sprite: noone,
            sound: noone, // snd_death
            callback: function() {
                audio_stop_all();
                // audio_play_sound(mus_sad, 1, true);
            }
        },
        {
            text: "Mas toda derrota é uma oportunidade de aprender.",
            sprite: noone,
            sound: noone,
            callback: noone
        },
        {
            text: "Tentar novamente?",
            sprite: noone,
            sound: noone,
            callback: function() {
                // Resetar o jogo
                game_restart();
            }
        }
    ];
}

// EXEMPLO 3: Cutscene entre fases
function criar_cutscene_transicao(proxima_room) {
    var cutscene = instance_create_layer(0, 0, "Instances", obj_cutscene);
    
    cutscene.cutscene_data = [
        {
            text: "Fase completada! Preparando-se para o próximo desafio...",
            sprite: noone,
            sound: noone, // snd_victory
            callback: function() {
                // Salvar progresso
                // save_game_progress();
            }
        },
        {
            text: "Continuando a jornada...",
            sprite: noone,
            sound: noone,
            callback: function() {
                // Ir para próxima room (passada como parâmetro)
                room_goto(proxima_room);
            }
        }
    ];
}

// EXEMPLO 4: Cutscene com imagem e som
function criar_cutscene_com_midia() {
    var cutscene = instance_create_layer(0, 0, "Instances", obj_cutscene);
    
    cutscene.cutscene_data = [
        {
            text: "O herói olha para o horizonte...",
            sprite: spr_player_idle, // Use seus sprites
            sound: snd_player_attack, // Use seus sons
            callback: function() {
                // Parar música de fundo para dar destaque ao diálogo
                audio_stop_all();
            }
        },
        {
            text: "Uma jornada épica está começando!",
            sprite: spr_player_walk,
            sound: noone,
            callback: function() {
                // Iniciar música épica
                // audio_play_sound(mus_epic, 1, true);
            }
        }
    ];
}

// EXEMPLO 5: Cutscene de tutorial
function criar_cutscene_tutorial() {
    var cutscene = instance_create_layer(0, 0, "Instances", obj_cutscene);
    
    cutscene.cutscene_data = [
        {
            text: "Use WASD ou as setas para se mover.",
            sprite: noone,
            sound: noone,
            callback: function() {
                // Criar variável global para controle do tutorial
                global.tutorial_step = 1;
            }
        },
        {
            text: "Pressione J para atacar os inimigos.",
            sprite: noone,
            sound: noone,
            callback: function() {
                global.tutorial_step = 2;
            }
        },
        {
            text: "Use K para pular. Agora vamos praticar!",
            sprite: noone,
            sound: noone,
            callback: function() {
                global.tutorial_step = 3;
                // Voltar ao jogo com tutorial ativo
                room_goto(Room1);
            }
        }
    ];
}

// === COMO CHAMAR ===
// Simplesmente chame uma dessas funções de qualquer lugar:
// criar_cutscene_intro();
// criar_cutscene_game_over();
// criar_cutscene_transicao(Room2);
// criar_cutscene_com_midia();
// criar_cutscene_tutorial();

// === EXEMPLOS DE CHAMADAS EM DIFERENTES SITUAÇÕES ===

// No início do jogo (Room Creation Code):
// criar_cutscene_intro();

// Quando o player morre (obj_player):
// if (vida_atual <= 0) {
//     criar_cutscene_game_over();
// }

// Ao completar uma fase (obj_level_controller):
// if (fase_completa) {
//     criar_cutscene_transicao(proxima_room);
// }

// No início de um tutorial (obj_tutorial_trigger):
// if (place_meeting(x, y, obj_player)) {
//     criar_cutscene_tutorial();
//     instance_destroy(); // Destruir trigger após uso
// }