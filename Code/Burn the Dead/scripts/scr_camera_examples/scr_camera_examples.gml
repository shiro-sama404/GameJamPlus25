// === EXEMPLOS DE USO DA CÂMERA ===

// EXEMPLO 1: Câmera básica seguindo o player
function criar_camera_basica() {
    // Colocar no Room Creation Code ou em um objeto controller
    instance_create_layer(0, 0, "Instances", obj_camera);
}

// EXEMPLO 2: Configurar câmera com limites específicos
function configurar_camera_com_limites() {
    var camera = instance_find(obj_camera, 0);
    if (camera != noone) {
        // Definir limites para evitar que a câmera saia da room
        camera.definir_limites_camera(0, 0, room_width, room_height);
        
        // Ou limites customizados (exemplo: não mostrar certas áreas)
        // camera.definir_limites_camera(100, 50, room_width - 100, room_height - 50);
    }
}

// EXEMPLO 3: Aplicar shake da câmera quando o player toma dano
function camera_shake_dano() {
    var camera = instance_find(obj_camera, 0);
    if (camera != noone) {
        // Shake leve para dano
        camera.aplicar_camera_shake(3, 15); // magnitude 3, duração 15 frames
    }
}

// EXEMPLO 4: Shake forte para explosões ou ataques especiais
function camera_shake_explosao() {
    var camera = instance_find(obj_camera, 0);
    if (camera != noone) {
        // Shake forte para explosão
        camera.aplicar_camera_shake(8, 30); // magnitude 8, duração 30 frames
    }
}

// EXEMPLO 5: Ajustar configurações da câmera dinamicamente
function ajustar_configuracoes_camera(_follow_speed, _look_ahead) {
    var camera = instance_find(obj_camera, 0);
    if (camera != noone) {
        camera.follow_speed = _follow_speed;      // 0.05 = lento, 0.3 = rápido
        camera.look_ahead_distance = _look_ahead; // distância de antecipação
    }
}

// EXEMPLO 6: Câmera para cutscenes (seguir objeto específico)
function camera_seguir_objeto(_objeto) {
    var camera = instance_find(obj_camera, 0);
    if (camera != noone) {
        camera.follow = _objeto; // Pode ser qualquer objeto
        camera.follow_speed = 0.02; // Movimento mais lento para cutscenes
    }
}

// EXEMPLO 7: Voltar a seguir o player após cutscene
function camera_voltar_para_player() {
    var camera = instance_find(obj_camera, 0);
    if (camera != noone) {
        camera.follow = obj_player;
        camera.follow_speed = 0.1; // Velocidade normal
    }
}

// EXEMPLO 8: Configurações de zona morta
function configurar_zona_morta(_largura, _altura) {
    var camera = instance_find(obj_camera, 0);
    if (camera != noone) {
        camera.deadzone_width = _largura;
        camera.deadzone_height = _altura;
    }
}

// EXEMPLO 9: Shake personalizado para diferentes situações
function camera_shake_personalizado(_tipo) {
    var camera = instance_find(obj_camera, 0);
    if (camera != noone) {
        switch(_tipo) {
            case "dano_leve":
                camera.aplicar_camera_shake(2, 10);
                break;
            case "dano_medio":
                camera.aplicar_camera_shake(4, 20);
                break;
            case "dano_forte":
                camera.aplicar_camera_shake(6, 25);
                break;
            case "explosao":
                camera.aplicar_camera_shake(10, 40);
                break;
            case "terremoto":
                camera.aplicar_camera_shake(8, 120); // Shake longo
                break;
            case "impacto":
                camera.aplicar_camera_shake(12, 15); // Shake forte e curto
                break;
        }
    }
}

// EXEMPLO 10: Sistema de câmera cinematográfica
function camera_modo_cinematico(_ativar) {
    var camera = instance_find(obj_camera, 0);
    if (camera != noone) {
        if (_ativar) {
            // Configurações para cutscenes
            camera.follow_speed = 0.03;
            camera.look_ahead_distance = 30;
            camera.deadzone_width = 20;
            camera.deadzone_height = 20;
        } else {
            // Voltar às configurações normais
            camera.follow_speed = 0.1;
            camera.look_ahead_distance = 60;
            camera.deadzone_width = 80;
            camera.deadzone_height = 40;
        }
    }
}

// === COMO USAR NO SEU JOGO ===

// 1. No Room Creation Code:
// criar_camera_basica();
// configurar_camera_com_limites();

// 2. Quando o player toma dano (obj_player):
// camera_shake_dano();

// 3. Para ataques especiais (obj_player):
// if (sprite_index == spr_player_jump_attack2) {
//     camera_shake_explosao();
// }

// 4. Para ajustar sensibilidade:
// ajustar_configuracoes_camera(0.15, 80); // Câmera mais responsiva

// 5. Para cutscenes:
// camera_seguir_objeto(obj_npc);
// camera_modo_cinematico(true);
// // ... após cutscene ...
// camera_voltar_para_player();
// camera_modo_cinematico(false);

// 6. Para diferentes tipos de shake:
// camera_shake_personalizado("dano_medio");
// camera_shake_personalizado("explosao");
// camera_shake_personalizado("terremoto");

// 7. Para configurar zona morta específica:
// configurar_zona_morta(120, 60); // Zona morta maior
// configurar_zona_morta(40, 20);  // Zona morta menor (mais sensível)

// === DICAS DE USO ===

// - Use follow_speed baixo (0.05) para movimento suave e cinematográfico
// - Use follow_speed alto (0.2-0.3) para gameplay mais responsivo
// - Zona morta menor = câmera mais reativa
// - Zona morta maior = câmera mais estável
// - Look ahead maior = mais antecipação do movimento
// - Sempre teste as configurações para encontrar o equilíbrio ideal