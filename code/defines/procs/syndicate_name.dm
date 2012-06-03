var/syndicate_name = null
/proc/syndicate_name()
	if (syndicate_name)
		return syndicate_name

	var/name = ""

	// Prefix
	name += pick("Clandestine", "Prima", "Blue", "Zero-G", "Max", "Blasto", "Waffle", "North", "Omni", "Newton", "Cyber", "Bonk", "Gene", "Gib")

	// Suffix
	if (prob(80))
		name += " "

		// Full
		if (prob(60))
			name += pick("Syndicate", "Consortium", "Collective", "Corporation", "Group", "Holdings", "Biotech", "Industries", "Systems", "Products", "Chemicals", "Enterprises", "Family", "Creations", "International", "Intergalactic", "Interplanetary", "Foundation", "Positronics", "Hive")
		// Broken
		else
			name += pick("Syndi", "Corp", "Bio", "System", "Prod", "Chem", "Inter", "Hive")
			name += pick("", "-")
			name += pick("Tech", "Sun", "Co", "Tek", "X", "Inc", "Code")
	// Small
	else
		name += pick("-", "*", "")
		name += pick("Tech", "Sun", "Co", "Tek", "X", "Inc", "Gen", "Star", "Dyne", "Code", "Hive")

	syndicate_name = name
	return name


//Traitors and traitor silicons will get these. Revs will not.
var/syndicate_code_phrase//Code phrase for traitors.
var/syndicate_code_response//Code response for traitors.

	/*
	Should be expanded.
	How this works:
	Instead of "I'm looking for James Smith," the traitor would say "James Smith" as part of a conversation.
	Another traitor may then respond with: "They enjoy running through the void-filled vacuum of the derelict."
	The phrase should then have the words: James Smith.
	The response should then have the words: run, void, and derelict.
	This way assures that the code is suited to the conversation and is unpredicatable.
	Obviously, some people will be better at this than others but in theory, everyone should be able to do it and it only enhances roleplay.
	Can probably be done through "{ }" but I don't really see the practical benefit.
	One example of an earlier system is commented below.
	/N
	*/
/*
/proc/generate_code_phrase()//Proc is used for phrase and response in master_controller.dm

	var/code_phrase = ""//What is returned when the proc finishes.
	var/words = pick(//How many words there will be. Minimum of two. 2, 4 and 5 have a lesser chance of being selected. 3 is the most likely.
		50; 2,
		200; 3,
		50; 4,
		25; 5
	)

	var/safety[] = list(1,2,3)//Tells the proc which options to remove later on.
	var/nouns[] = list("love","hate","anger","peace","pride","sympathy","bravery","loyalty","honesty","integrity","compassion","charity","success","courage","deceit","skill","beauty","brilliance","pain","misery","beliefs","dreams","justice","truth","faith","liberty","knowledge","thought","information","culture","trust","dedication","progress","education","hospitality","leisure","trouble","friendships", "relaxation")
	var/drinks[] = list("vodka and tonic","gin fizz","bahama mama","manhattan","black Russian","whiskey soda","long island tea","margarita","Irish coffee"," manly dwarf","Irish cream","doctor's delight","Beepksy Smash","tequilla sunrise","brave bull","gargle blaster","bloody mary","whiskey cola","white Russian","vodka martini","martini","Cuba libre","kahlua","vodka","wine","moonshine")
	var/locations[] = teleportlocs.len ? teleportlocs : drinks//if null, defaults to drinks instead.

	var/names[] = list()
	for(var/datum/data/record/t in data_core.general)//Picks from crew manifest.
		names += t.fields["name"]

	var/maxwords = words//Extra var to check for duplicates.

	for(words,words>0,words--)//Randomly picks from one of the choices below.

		if(words==1&&(1 in safety)&&(2 in safety))//If there is only one word remaining and choice 1 or 2 have not been selected.
			safety = list(pick(1,2))//Select choice 1 or 2.
		else if(words==1&&maxwords==2)//Else if there is only one word remaining (and there were two originally), and 1 or 2 were chosen,
			safety = list(3)//Default to list 3

		switch(pick(safety))//Chance based on the safety list.
			if(1)//1 and 2 can only be selected once each to prevent more than two specific names/places/etc.
				switch(rand(1,2))//Mainly to add more options later.
					if(1)
						if(names.len&&prob(70))
							code_phrase += pick(names)
						else
							code_phrase += pick(pick(first_names_male,first_names_female))
							code_phrase += " "
							code_phrase += pick(last_names)
					if(2)
						code_phrase += pick(get_all_jobs())//Returns a job.
				safety -= 1
			if(2)
				switch(rand(1,2))//Places or things.
					if(1)
						code_phrase += pick(drinks)
					if(2)
						code_phrase += pick(locations)
				safety -= 2
			if(3)
				switch(rand(1,3))//Nouns, adjectives, verbs. Can be selected more than once.
					if(1)
						code_phrase += pick(nouns)
					if(2)
						code_phrase += pick(adjectives)
					if(3)
						code_phrase += pick(verbs)
		if(words==1)
			code_phrase += "."
		else
			code_phrase += ", "

	return code_phrase
*/

//This proc tests the gen above.
/proc/generate_traitors()

	var/choice = rand(1,3)
	switch(choice)
		if(1)
			syndicate_code_phrase += sanitize(pick("Я видел","Может кто видел","Может быть вы видели","Я пытаюсь найти","Я слежу за"))
			syndicate_code_phrase += " "
			syndicate_code_phrase += pick(pick(first_names_male,first_names_female))
			syndicate_code_phrase += " "
			syndicate_code_phrase += pick(last_names)
			syndicate_code_phrase += "."
		if(2)
			syndicate_code_phrase += sanitize(pick("Как я могу попасть в","Как мне найти","Где","Где я могу найти"))
			syndicate_code_phrase += " "
			syndicate_code_phrase += sanitize(pick("Отбытие","инженерный отсек","атмос","мостик","бриг","планету клованов","ЦК","библиотеку","церковь","ванную","мед-бей","хранилище инструментов","шаттл отбытия","роботику","туалет","жилой отсек","гимнастерку","автолат","карго-бей","бар","театр","дереликт"))
			syndicate_code_phrase += "?"
		if(3)
			if(prob(70))
				syndicate_code_phrase += sanitize(pick("Дайте мне","Я хочу","Я люблю","Сделайте мне"))
			else
				syndicate_code_phrase += sanitize(pick("Дайте"))
				syndicate_code_phrase += " "
			syndicate_code_phrase += pick("водку с тоником","джин физз","багаму маму","манхеттен","черной России","виски с содой","чай далеких островов","маргариту","иранское кофе","аутистичного дварфа","иранский крем","докторского делайта","бибски-коктейл","восход текиллы","смелого быка","грызлодера","кровавой мери","виски-колу","белой России","водку с мартини","мартини","Куба либрэ","какхлуэ","водку","вино","лунного света")
			syndicate_code_phrase += "."

	switch(choice)
		if(1)
			if(prob(80))
				syndicate_code_response += sanitize(pick("Попробуйте посмотреть рядом с","Да, я видел этого человека рядом с","Нет, но возможно этот человек был в","Попробуйте поискать рядом с"))
				syndicate_code_response += " "
				syndicate_code_response += sanitize(pick("Отбытием","инженерный отсеком","атмосом","мостиком","бригом","библиотекой","церковью","ванной","мед-беем","хранилищем инструментов","роботикой","туалетом","дормиторием","гимнастеркой","автолатом","карго-беем","баром","театром"))
				syndicate_code_response += "."
			else if(prob(60))
				syndicate_code_response += sanitize(pick("Нет, я слишком занят","У меня нет на это времени.","Нет времени."))
			else
				syndicate_code_response += sanitize(pick("*shrug*","*smile*","*blink*","*sigh*","*laugh*","*nod*","*giggle*"))
		if(2)
			if(prob(80))
				syndicate_code_response += sanitize(pick("Идите в","Поищите","Попробуйте зайти в","Попробуйте найти"))
				syndicate_code_response += " "
				syndicate_code_response += sanitize(pick("[pick("южную","северную","восточную","западную")] техническую дверь","ближайший техтоннель","телепортер","морг","[pick("южный","северный","восточный","западный")] коридор "))
				syndicate_code_response += "."
			else if(prob(60))
				syndicate_code_response += sanitize(pick("Спросите у","Поговорите с","Найдите","Следуйте за"))
				syndicate_code_response += " "
				if(prob(50))
					syndicate_code_response += sanitize(pick(pick(first_names_male,first_names_female)))
					syndicate_code_response += " "
					syndicate_code_response += sanitize(pick(last_names))
				else
					syndicate_code_response += "[pick(get_all_jobs())]"
				syndicate_code_response += "."
			else
				syndicate_code_response += sanitize(pick("*shrug*","*smile*","*blink*","*sigh*","*laugh*","*nod*","*giggle*"))