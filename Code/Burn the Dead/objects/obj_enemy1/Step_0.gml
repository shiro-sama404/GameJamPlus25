// Inherit the parent event
event_inherited();

// Só executar lógica se não estiver morto
if (!morreu) {
    estado();

    if (is_struct(my_damage)){
        atualizar_posicao_struct(my_damage, x, y, z);
    }
} else {
    // Se estiver morto, executar estado de morte
    estado();
}