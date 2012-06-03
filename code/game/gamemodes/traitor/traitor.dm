/datum/game_mode
	// this includes admin-appointed traitors and multitraitors. Easy!
	var/list/datum/mind/traitors = list()

/datum/game_mode/traitor
	name = "traitor"
	config_tag = "traitor"
	restricted_jobs = list("Cyborg", "AI")//Approved by headmins for a week test, if you see this it would be nice if you didn't spread it everywhere
	protected_jobs = list("Security Officer", "Warden", "Head of Security", "Captain")
	required_enemies = 1
	recommended_enemies = 4


	uplink_welcome = "Syndicate Uplink Console:"
	uplink_uses = 10

	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800 //upper bound on time before intercept arrives (in tenths of seconds)

	var/traitors_possible = 5 //hard limit on traitors if scaling is turned off
	var/const/traitor_scaling_coeff = 8.0 //how much does the amount of players get divided by to determine traitors

	var/num_players = 0


/datum/game_mode/traitor/announce()
	world << "<B>Текущий режим - предатели!</B>"
	world << "<B>На станции есть предатели, которые продались синдикату. НЕ ДАЙТЕ ИМ ВЫПОЛНИТЬ ИХ ЦЕЛИ!</B>"


/datum/game_mode/traitor/pre_setup()

	if(config.protect_roles_from_antagonist)
		restricted_jobs += protected_jobs

	var/list/possible_traitors = get_players_for_role(BE_TRAITOR)

	// stop setup if no possible traitors
	if(!possible_traitors.len)
		return 0

	var/num_traitors = 1

	if(config.traitor_scaling)
		num_traitors = max(1, round((num_players())/(traitor_scaling_coeff)) + 1)
	else
		num_traitors = max(1, min(num_players(), traitors_possible))

	for(var/datum/mind/player in possible_traitors)
		for(var/job in restricted_jobs)
			if(player.assigned_role == job)
				possible_traitors -= player

	for(var/j = 0, j < num_traitors, j++)
		if (!possible_traitors.len)
			break
		var/datum/mind/traitor = pick(possible_traitors)
		traitors += traitor
		traitor.special_role = "traitor"
		possible_traitors.Remove(traitor)

	if(!traitors.len)
		return 0
	return 1


/datum/game_mode/traitor/post_setup()
	for(var/datum/mind/traitor in traitors)
		forge_traitor_objectives(traitor)
		spawn(rand(10,100))
			finalize_traitor(traitor)
			greet_traitor(traitor)
	modePlayer += traitors
	spawn (rand(waittime_l, waittime_h))
		send_intercept()
	..()
	return 1


/datum/game_mode/proc/forge_traitor_objectives(var/datum/mind/traitor)
	var/datum/traitorinfo/info = new
	info.ckey = traitor.key
	info.starting_player_count = num_players()
	info.starting_name = traitor.current.name
	if(istype(traitor.current, /mob/living/silicon))
		var/datum/objective/assassinate/kill_objective = new
		kill_objective.owner = traitor
		kill_objective.find_target()
		traitor.objectives += kill_objective

		var/datum/objective/survive/survive_objective = new
		survive_objective.owner = traitor
		traitor.objectives += survive_objective

		if(prob(10))
			var/datum/objective/block/block_objective = new
			block_objective.owner = traitor
			traitor.objectives += block_objective
		info.starting_occupation = "AI"

	else
		info.starting_occupation = (traitor.current:wear_id && traitor.current:wear_id:assignment ? traitor.current:wear_id:assignment : traitor.assigned_role)
		for(var/datum/objective/o in SelectObjectives((istype(traitor.current:wear_id, /obj/item/weapon/card/id) ? traitor.current:wear_id:assignment : traitor.assigned_role), traitor))
			o.owner = traitor
			traitor.objectives += o
	for(var/datum/objective/objective in traitor.objectives)
		info.starting_objective += "[objective.explanation_text]            "
	logtraitors[traitor] = info
	return


/datum/game_mode/proc/greet_traitor(var/datum/mind/traitor)
	traitor.current << "<B><font size=3 color=red>ВЫ ПРЕДАТЕЛЬ.</font></B>"
	traitor.current << "\red <B>ПОВТОРЯЕМ</B>"
	traitor.current << "\red <B>Вы ПРЕДАТЕЛЬ.</B>"
	var/obj_count = 1
	for(var/datum/objective/objective in traitor.objectives)
		traitor.current << "<B>Цель #[obj_count]</B>: [objective.explanation_text]"
		obj_count++
	return


/datum/game_mode/proc/finalize_traitor(var/datum/mind/traitor)
	if (istype(traitor.current, /mob/living/silicon))
		add_law_zero(traitor.current)
	else
		equip_traitor(traitor.current)
	return


/datum/game_mode/traitor/declare_completion()
	..()
	return//Traitors will be checked as part of check_extra_completion. Leaving this here as a reminder.


/datum/game_mode/proc/add_law_zero(mob/living/silicon/ai/killer)
	var/law = sanitize("\red Выполнить вашу цель любой ценой.")
	killer << sanitize("<b>Ваши законы были изменены!</b>")
	killer.set_zeroth_law(law)
	killer << sanitize("Новый закон: 0. [law]")

	//Begin code phrase.
	killer << sanitize("\red Синдикат предоставил следующую информацию, чтобы найти других")
	killer << sanitize("\red \bold Кодовая фраза: \black [syndicate_code_phrase]")
	killer.mind.store_memory(sanitize("<b>Кодовая фраза</b>: [syndicate_code_phrase]"))
	killer << sanitize("\red \bold Кодовый ответ: \black [syndicate_code_response]")
	killer.mind.store_memory(sanitize("<b>Кодовый ответ</b>: [syndicate_code_response]"))
	killer << sanitize("Используйте кодовые слова с осторожностью ведь каждый может оказаться врагом!")
//End code phrase.


/datum/game_mode/proc/auto_declare_completion_traitor()
	for(var/datum/mind/traitor in traitors)
		var/traitor_name

		if(traitor.current)
			if(traitor.current == traitor.original)
				traitor_name = "[traitor.current.real_name] (played by [traitor.key])"
			else if (traitor.original)
				traitor_name = "[traitor.current.real_name] (originally [traitor.original.real_name]) (played by [traitor.key])"
			else
				traitor_name = "[traitor.current.real_name] (original character destroyed) (played by [traitor.key])"
		else
			traitor_name = "[traitor.key] (character destroyed)"
		var/special_role_text = traitor.special_role?(lowertext(traitor.special_role)):"antagonist"
		world << "<B>The [special_role_text] was [traitor_name]</B>"
		if(traitor.objectives.len)//If the traitor had no objectives, don't need to process this.
			var/traitorwin = 1
			var/count = 1
			for(var/datum/objective/objective in traitor.objectives)
				if(objective.check_completion())
					world << "<B>Objective #[count]</B>: [objective.explanation_text] \green <B>Success</B>"
					//feedback_add_details("traitor_objective","[objective.type]|SUCCESS")
				else
					world << "<B>Objective #[count]</B>: [objective.explanation_text] \red Failed"
					//feedback_add_details("traitor_objective","[objective.type]|FAIL")
					traitorwin = 0
				count++

			if(traitorwin)
				world << "<B>The [special_role_text] УСПЕШЕН!<B>"
				//feedback_add_details("traitor_success","SUCCESS")
			else
				world << "<B>The [special_role_text] ПРОВАЛИЛСЯ!<B>"
				//feedback_add_details("traitor_success","FAIL")

			var/datum/traitorinfo/info = logtraitors[traitor]
			if (info)
				var/DBConnection/dbcon = new()
				dbcon.Connect("dbi:mysql:[sqldb]:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
				if(dbcon.IsConnected())
					var/DBQuery/query = dbcon.NewQuery("INSERT INTO `bay12`.`traitorlogs` (`CKey`, `Objective`, `Succeeded`, `Spawned`, `Occupation`, `PlayerCount`) VALUES ('[info.ckey]', [dbcon.Quote(info.starting_objective)], '[traitorwin]', '[dd_list2text(info.spawnlist, ";")]', '[info.starting_occupation]', '[info.starting_player_count]')")
					query.Execute()

	return 1


/datum/game_mode/proc/equip_traitor(mob/living/carbon/human/traitor_mob, var/safety = 0)
	if (!istype(traitor_mob))
		return
	. = 1
	if (traitor_mob.mind)
		if (traitor_mob.mind.assigned_role == "Clown")
			traitor_mob << sanitize("Вы натренированы сдерживать свою клоунскую натуру, и пользоваться оружием без вреда себе.")
			traitor_mob.mutations &= ~CLUMSY

	// find a radio! toolbox(es), backpack, belt, headset, pockets
	var/loc = ""
	var/obj/item/device/R = null //Hide the uplink in a PDA if available, otherwise radio
	if (!R && istype(traitor_mob.belt, /obj/item/device/pda))
		R = traitor_mob.belt
		loc = "on your belt"
	if (!R && istype(traitor_mob.wear_id, /obj/item/device/pda))
		R = traitor_mob.wear_id
		loc = "on your jumpsuit"
	if (!R && istype(traitor_mob.wear_id, /obj/item/device/pda))
		R = traitor_mob.wear_id
		loc = "on your jumpsuit"
	if (!R && istype(traitor_mob.l_hand, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = traitor_mob.l_hand
		var/list/L = S.return_inv()
		for (var/obj/item/device/radio/foo in L)
			R = foo
			loc = "in the [S.name] in your left hand"
			break
	if (!R && istype(traitor_mob.r_hand, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = traitor_mob.r_hand
		var/list/L = S.return_inv()
		for (var/obj/item/device/radio/foo in L)
			R = foo
			loc = "in the [S.name] in your right hand"
			break
	if (!R && istype(traitor_mob.back, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = traitor_mob.back
		var/list/L = S.return_inv()
		for (var/obj/item/device/radio/foo in L)
			R = foo
			loc = "in the [S.name] on your back"
			break
	if (!R && istype(traitor_mob.l_store, /obj/item/device/pda))
		R = traitor_mob.l_store
		loc = "in your pocket"
	if (!R && istype(traitor_mob.r_store, /obj/item/device/pda))
		R = traitor_mob.r_store
		loc = "in your pocket"
	if (!R && traitor_mob.w_uniform && istype(traitor_mob.belt, /obj/item/device/radio))
		R = traitor_mob.belt
		loc = "on your belt"
	if (!R && istype(traitor_mob.l_ear, /obj/item/device/radio))
		R = traitor_mob.l_ear
		loc = "on your head"
	if (!R && istype(traitor_mob.r_ear, /obj/item/device/radio))
		R = traitor_mob.r_ear
		loc = "on your head"
	if (!R)
		traitor_mob << "Unfortunately, the Syndicate wasn't able to get you an uplink."
		traitor_mob << "\red <b>ADMINHELP THIS AT ONCE.</b>"
		. = 0
	else
		if (istype(R, /obj/item/device/radio))
			// generate list of radio freqs
			var/freq = 1441
			var/list/freqlist = list()
			while (freq <= 1489)
				if (freq < 1451 || freq > 1459)
					freqlist += freq
				freq += 2
				if ((freq % 2) == 0)
					freq += 1
			freq = freqlist[rand(1, freqlist.len)]

			var/obj/item/device/uplink/radio/T = new /obj/item/device/uplink/radio(R)
			R:traitorradio = T
			R:traitor_frequency = freq
			T.name = R.name
			T.icon = R.icon
			T.w_class = R.w_class
			T.icon_state = R.icon_state
			T.item_state = R.item_state
			T.origradio = R
			traitor_mob << sanitize("Синдикат вставил аплинк в ваш наушник. Просто настройтесь на частоту [format_frequency(freq)] чтобы разблокировать меню.")
			traitor_mob.mind.store_memory(sanitize("<B>Radio Freq:</B> [format_frequency(freq)] ([R.name] [loc])."))
		else if (istype(R, /obj/item/device/pda))
			// generate a passcode if the uplink is hidden in a PDA
			var/pda_pass = "[rand(1,999999)]"

			var/obj/item/device/uplink/pda/T = new /obj/item/device/uplink/pda(R)
			R:uplink = T
			T.lock_code = pda_pass
			T.hostpda = R
			traitor_mob << sanitize("Синдикат вставил аплинк в ваш КПК. Введите код \"[pda_pass]\" в поле для рингтона для разблокировки меню.")
			traitor_mob.mind.store_memory(sanitize("<B>Uplink Passcode:</B> [pda_pass] ([R.name] [loc])."))
	//Begin code phrase.
	if(!safety)//If they are not a rev. Can be added on to.
		traitor_mob << sanitize("Синдикат предоставил следующую информацию для поиска своих:")
		traitor_mob << sanitize("\red Кодовая фраза: \black [syndicate_code_phrase]")
		traitor_mob.mind.store_memory(sanitize("<b>Code Phrase</b>: [syndicate_code_phrase]"))
		traitor_mob << sanitize("\red Кодовый ответ: \black [syndicate_code_response]")
		traitor_mob.mind.store_memory(sanitize("<b>Кодовый ответ</b>: [syndicate_code_response]"))
		traitor_mob << sanitize("Используйте кодовые слова с осторожностью, ведь каждый может оказаться врагом!")
	//End code phrase.