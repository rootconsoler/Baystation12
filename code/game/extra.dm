/proc/StunEye()
	set name = "Stun vieweble"
	set category = "Bio"
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
		usr.adjustCloneLoss(2.5)
/proc/GibEye()
	set name = "Damage eye"
	set category = "Bio"
	var/mob/living/carbon/human/M = list()
	for(var/mob/living/carbon/human/H in viewers(8,usr))
		if(H != usr)
			M += H
	var/mob/living/carbon/human/Victim = input(usr,"Who?") in M
	if(Victim)
		Victim << "\red \bold You feel very strong pain!"
		sleep(10)
		Victim << "[usr] look at you and close eyes."
		Victim.adjustToxLoss(75)
		usr << "\blue You use your damage eye onto [Victim]"
		usr.adjustCloneLoss(5)
/proc/SelfDest()
	set name = "Self-destruct"
	set category = "Bio"
	explosion(usr.loc,2,1,1)
	del(usr)
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
	usr.icon_state = "none"
	usr.icon = "none"
	usr:stand_icon = "none"
	usr:lying_icon = "none"
	usr:face_standing = "none"
	usr:face_lying = "none"
	usr << "You activate visible implant"
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
/proc/Mediate()
	set name = "Heal"
	set category = "Bio"
	usr:adjustCloneLoss(usr:getCloneLoss())
	spawn(6000)
		if(usr:getCloneLoss() != 0)
			usr:adjustCloneLoss(25)
