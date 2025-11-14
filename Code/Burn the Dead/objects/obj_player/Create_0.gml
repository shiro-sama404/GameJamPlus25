// Herdar propriedades da entidade
event_inherited();

// Configurações específicas do player
vida_maxima = 100;
vida_atual = vida_maxima;
dano = 25;

velh = 0;
velv = 0;
velz = 0;

z = 0;

vel_max = 2;
vel_pulo = 4;
grav = .15;
face = 1;
buffer_attack = false;
my_damage = noone;

// Configurar hurtbox do player
hurtbox_x1 = -8;
hurtbox_y1 = -40;
hurtbox_x2 = 8;
hurtbox_y2 = 0;
my_hurtbox = new scr_hurtbox(hurtbox_x1, hurtbox_y1, hurtbox_x2, hurtbox_y2);

up		= noone;
down	= noone;
left	= noone;
right	= noone;
jump	= noone;
attack	= noone;
dash	= noone;

// Timer para controlar vibração
vibration_timer = 0;

// Sistema de combo para vibração
combo_count = 0;
combo_timer = 0;
combo_timeout = 90; // 1.5 segundos para resetar combo (60fps * 1.5)
ultimo_ataque_frame = 0;

// Variáveis para animação de dano
dano_animacao_ativa = false;
dano_animacao_timer = 0;
dano_animacao_duracao = 20; // Duração em frames da animação de dano
sprite_antes_dano = noone; // Para salvar sprite anterior

// Variáveis do dash
dash_disponivel = true;
dash_cooldown = 60; // 1 segundo a 60fps
dash_timer = 0;
dash_ativo = false;
dash_duracao = 12; // Duração do dash em frames
dash_timer_ativo = 0;
dash_velocidade = 8; // Velocidade do dash
dash_direcao = 0; // Direção do dash (-1 esquerda, 1 direita)

// Lista para armazenar posições do rastro
dash_trail = [];
dash_trail_max = 8; // Máximo de rastros

// Sobrescrever função de morte
morrer = function() {
    // Reiniciar o jogo quando o player morre
    game_restart();
}

// Sobrescrever funções de dano para adicionar animação
receber_dano = function(_quantidade_dano, _atacante = noone) {
    // Verificar se pode receber dano deste atacante
    if (dano_cooldown_atual > 0) return false;
    
    // Verificar se este atacante já causou dano recentemente
    if (_atacante != noone) {
        for (var i = 0; i < array_length(lista_atacantes_recentes); i++) {
            if (lista_atacantes_recentes[i] == _atacante) {
                return false; // Já recebeu dano deste atacante
            }
        }
        // Adicionar atacante à lista
        array_push(lista_atacantes_recentes, _atacante);
    }
    
    vida_atual -= _quantidade_dano;
    dano_cooldown_atual = dano_cooldown_tempo;
    flash_dano = 10; // Flash visual por 10 frames
    
    // Ativar animação de dano
    iniciar_animacao_dano();
    
    // Vibração quando o player toma dano (apenas se ainda estiver vivo)
    if (vida_atual > 0) {
        gamepad_vibrate_damage_quick(); // Vibração rápida quando toma dano
    }
    
    // Aplicar knockback se necessário
    if (_atacante != noone) {
        aplicar_knockback_por_ataque(_atacante, self);
    }
    
    if (vida_atual <= 0) {
        vida_atual = 0;
        morreu = true;
        morrer();
    }
    
    return true;
}

receber_dano_sem_cooldown = function(_quantidade_dano, _atacante = noone) {
    vida_atual -= _quantidade_dano;
    flash_dano = 10; // Flash visual por 10 frames
    
    // Ativar animação de dano
    iniciar_animacao_dano();
    
    // Vibração quando o player toma dano (apenas se ainda estiver vivo)
    if (vida_atual > 0) {
        gamepad_vibrate_damage_quick(); // Vibração rápida quando toma dano
    }
    
    // Aplicar knockback se necessário
    if (_atacante != noone) {
        aplicar_knockback_por_ataque(_atacante, self);
    }
    
    if (vida_atual <= 0) {
        vida_atual = 0;
        morreu = true;
        morrer();
    }
    
    return true;
}

// Função para iniciar animação de dano
iniciar_animacao_dano = function() {
    // Só iniciar se não estiver morto
    if (vida_atual > 0) {
        // Salvar sprite atual se não estiver já em animação de dano
        if (!dano_animacao_ativa) {
            sprite_antes_dano = sprite_index;
        }
        
        dano_animacao_ativa = true;
        dano_animacao_timer = dano_animacao_duracao;
        sprite_index = spr_player_hurt;
        image_index = 0;
    }
}

// Importar funções específicas do player
controla_player = method(self, player_controla);
estado_idle = method(self, player_estado_idle);
estado_walk = method(self, player_estado_walk);
estado_ataque = method(self, player_estado_ataque);
estado_pulo = method(self, player_estado_pulo);
estado_jump_kick = method(self, player_estado_jump_kick);
estado_jump_kick2 = method(self, player_estado_jump_kick2);
estado_dash = method(self, player_estado_dash);

estado = estado_walk;

