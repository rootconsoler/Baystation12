#define NODERANGE 3

/obj/effect/alien/weeds/New()
	..()
	if(istype(loc, /turf/space))
		del(src)
		return
	if(icon_state == "weeds")icon_state = pick("weeds", "weeds1", "weeds2")
	spawn(rand(300,450)) //2x time.
		if(src)
			extend()
	return

/obj/effect/alien/weeds/node/New()
	..()
	sd_SetLuminosity(NODERANGE)
	return

/obj/effect/alien/weeds/proc/extend()
	for(var/dirn in cardinal)
		var/turf/T = get_step(src, dirn)
		var/extendeble = 1
		if(!T || T.density || locate(/obj/effect/alien/weeds) in T || istype(T.loc, /area/arrival) || istype(T, /turf/space))
			continue
		if(!(locate(/obj/effect/alien/weeds/node) in view(NODERANGE, T)))
			continue
		for(var/obj/A in T)
			if(A.density)
				extendeble = 0
				break
		if(extendeble)
			new /obj/effect/alien/weeds(T)

/obj/effect/alien/weeds/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
		if(2.0)
			if (prob(50))
				del(src)
		if(3.0)
			if (prob(5))
				del(src)
	return

/obj/effect/alien/weeds/attackby(var/obj/item/weapon/W, var/mob/user)
	visible_message("\red <B>\The [src] have been attacked with \the [W][(user ? " by [user]." : ".")]")

	var/damage = W.force / 4.0

	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W

		if(WT.welding)
			damage = 15
			playsound(loc, 'Welder.ogg', 100, 1)

	health -= damage
	healthcheck()

/obj/effect/alien/weeds/proc/healthcheck()
	if(health <= 0)
		del(src)


/obj/effect/alien/weeds/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		health -= 5
		healthcheck()

/*/obj/effect/alien/weeds/burn(fi_amount)
	if (fi_amount > 18000)
		spawn( 0 )
			del(src)
			return
		return 0
	return 1
*/

#undef NODERANGE //NODRANGE ?