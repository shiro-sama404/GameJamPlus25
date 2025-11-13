function scr_funcoes(){

}

function gravidade (_grav = .2){
	z += velz;
	
	if (z < 0){
		velz += _grav;
	}
	else {
		velz = 0;
		z = 0;
		estado = estado_idle;
	}
	
	
}