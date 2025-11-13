function gravidade (_grav = .2){
	z += velz;
	
	if (z < 0){
		velz += _grav;
	}
	else {
		velz = 0;
		z = 0;
		estado = estado_idle;
		delete my_damage;
	}
	
	
}

//sistema de dano

function scr_dano(_x1, _y1, _x2, _y2) constructor
{
	my_x = other.x;
	my_y = other.y;
	my_z = other.z;
	
	x1 = _x1;
	x2 = _x2;
	y1 = _y1;
	y2 = _y2;
	
	static desenha_area = function(){
		draw_rectangle(x1 + my_x,y1 + my_y + my_z,x2 + my_x ,y2 + my_y + my_z,true);
	}
	static atualiza_posicao = function()
	{
	    my_x = other.x;
	    my_y = other.y;
	    my_z = other.z;
	}
}