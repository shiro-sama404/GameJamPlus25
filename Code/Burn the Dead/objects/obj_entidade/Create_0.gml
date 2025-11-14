velh	= 0;
velv	= 0;
velz	= 0;

face	= 1;
z		=0;

// Sistema de vida e dano
vida_maxima = 100;
vida_atual = vida_maxima;
dano = 10;
morreu = false;

// Sistema de cooldown para evitar dano múltiplo
dano_cooldown_tempo = 30; // 30 frames = 0.5 segundos
dano_cooldown_atual = 0;
lista_atacantes_recentes = []; // Lista para rastrear quem já causou dano

// Sistema de knockback
knockback_velh = 0;
knockback_velv = 0;
knockback_deceleracao = 0.8;

// Indicador visual de dano
flash_dano = 0; // Para piscar quando receber dano

// Definir hurtbox padrão (será sobrescrita pelos filhos)
hurtbox_x1 = -16;
hurtbox_y1 = -32;
hurtbox_x2 = 16;
hurtbox_y2 = 0;

my_hurtbox = new scr_hurtbox(hurtbox_x1, hurtbox_y1, hurtbox_x2, hurtbox_y2);
my_damage = noone;
estado = noone;

// Função para receber dano
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
    
    // Sons de dano
    if (object_index == obj_player && vida_atual > 0) {
        // Vibração quando o player toma dano
        gamepad_vibrate_damage_quick();
    } else if (object_is_ancestor(object_index, obj_entidade) && object_index != obj_player) {
        // Som de dano para qualquer inimigo (herda de obj_entidade mas não é player)
        var _som_dano = choose(snd_enemy_hurt1, snd_enemy_hurt2);
        audio_play_sound(_som_dano, 1, false);
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

// Função para receber dano sem cooldown (usada pelos ataques do player)
receber_dano_sem_cooldown = function(_quantidade_dano, _atacante = noone) {
    vida_atual -= _quantidade_dano;
    flash_dano = 10; // Flash visual por 10 frames
    
    // Sons de dano
    if (object_index == obj_player && vida_atual > 0) {
        // Vibração quando o player toma dano
        gamepad_vibrate_damage_quick();
    } else if (object_is_ancestor(object_index, obj_entidade) && object_index != obj_player) {
        // Som de dano para qualquer inimigo (herda de obj_entidade mas não é player)
        var _som_dano = choose(snd_enemy_hurt1, snd_enemy_hurt2);
        audio_play_sound(_som_dano, 1, false);
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

// Função para curar
curar = function(_quantidade_cura) {
    vida_atual = min(vida_atual + _quantidade_cura, vida_maxima);
}

// Função virtual para quando morrer (sobrescrita pelos filhos)
morrer = function() {
    // Função vazia para ser sobrescrita
}