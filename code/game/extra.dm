/proc/Mutate()
	set name = "Mutate"
	set category = "Bio"
	if(usr:super >= 100)
		usr:sight |= (SEE_MOBS|SEE_OBJS|SEE_TURFS)
		usr:see_in_dark = 15
		usr:see_invisible = 5
		usr:mutations |= XRAY
		usr << "\blue SUCCESS!!"
	else
		usr << "\red Enough bio-power"
/proc/Ms3()
	set name = "Compress item"
	set category = "Bio"
	if(usr:super >= 5)
		if(usr:equipped())
			var/obj/O = usr:equipped()
			if(O)
				usr:drop_item()
				O.loc = usr:contents
				usr:injected += O
				usr:super -= 5
	else
		usr << "\red Enough bio-power"
/proc/Ms4()
	set name = "Eject item"
	set category = "Bio"
	if(usr:injected)
		var/obj/O = input(usr,"Item?") in usr:injected
		if(O)
			O.loc = usr:loc
			usr:injected -= O
			usr:update_clothing()
/proc/StunEye()
	set name = "Stun vieweble"
	set category = "Bio"
	if(usr:super >= 10)
		var/mob/living/carbon/human/M = list()
		for(var/mob/living/carbon/human/H in viewers(8,usr))
			if(H != usr)
				M += H
		var/mob/living/carbon/human/Victim = input(usr,"Who?") in M
		if(Victim)
			Victim << "\red \bold Strange force stun you!"
			Victim << "[usr] look at you and blinks."
			Victim.stunned += 30
			Victim.weakened += 30
			playsound('empulse.ogg',usr.loc,50)
			Victim << sound('snap.ogg')
			usr << "\blue You use your stun eye onto [Victim]"
		usr:super -= 10
	else
		usr << "\red Enough bio-power"
/proc/GibEye()
	set name = "Damage eye"
	set category = "Bio"
	if(usr:super >= 70)
		var/mob/living/carbon/human/M = list()
		for(var/mob/living/carbon/human/H in viewers(8,usr))
			if(H != usr)
				M += H
		var/mob/living/carbon/human/Victim = input(usr,"Who?") in M
		if(Victim)
			Victim << "\red \bold You feel strange!"
			sleep(10)
			Victim << "[usr] look at you and close eyes."
			Victim << "\red \bold From [usr] eyes falls sparks!"
			Victim.radiation += 50
			usr << "\blue You use your damage eye onto [Victim]"
		usr:super -= 70
	else
		usr << "\red Enough bio-power"
/proc/SelfDest()
	set name = "Self-destruct"
	set category = "Bio"
	usr:say("Self-destruct activated, 13 second")
	for(var/mob/V in viewers(10,usr:loc))
		V << "\red [usr] change eye color!"
	playsound(usr:loc,'Alarm.ogg', 150)
	for(var/time=1,13, time++)
		for(var/mob/V in viewers(10,usr:loc))
			V << "\red \bold [usr] display in him eyes a [13 - time] seconds!!!"
		if(time <= 0)
			explosion(usr.loc,3,5,7)
			del(usr)
			return
		sleep(10)
	return
/proc/TransDress()
	set name = "Materialize trans-dress"
	set category = "Bio"
	var/turf/loca = get_turf(usr)
	new /obj/item/clothing/under/schoolgirl(loca)
	new /obj/item/clothing/head/kitty(loca)
	new /obj/item/clothing/under/blackskirt(loca)
/proc/Invisible()
	set name = "Invisible implant"
	set category = "Bio"
	usr.icon_state = "invisa"
	usr.icon = "invisa"
	usr:stand_icon = "invisa"
	usr:lying_icon = "invisa"
	usr:face_standing = "invisa"
	usr:face_lying = "invisa"
	usr << "You activate invisible implant"
/proc/Visible()
	set name = "Deactivate invisible implant"
	set category = "Bio"
	usr.icon_state = null
	usr.icon = null
	usr:stand_icon = null
	usr:lying_icon = null
	usr:face_standing = null
	usr:face_lying = null
	usr << "You deactivate invisible implant"
	usr:update_clothing()
	usr:update_body()
/proc/Mediate()
	set name = "Restract bio-power"
	set category = "Bio"
	sleep(300)
	usr << "\blue \bold Restracted!"
	usr:super += 150
	usr:bloodloss += 30
