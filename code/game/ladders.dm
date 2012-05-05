/obj/ladder_down
	name = "Ladder down"
	icon = 'mining.dmi' //Type other icon
	icon_state = "chute"
	density = 0
	opacity = 0
	var
		tx //Target X
		ty //Target Y
	Entered(var/atom/victim as mob|obj)
		if(victim && tx && ty && victim:z > 0)
			victim.x = tx
			victim.y = ty
			victim.z -= 1