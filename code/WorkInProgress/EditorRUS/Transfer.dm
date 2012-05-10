/obj/im
/obj/om
/obj/machinery/transfer
	name = "Money transformer"
	icon = 'stationobjs.dmi'
	icon_state = "injector"
	anchored = 1
	density = 1
	var/s = 0 //amount of silver
	var/g = 0   //amount of gold
	var/d= 0
	var/i = 0
	var/p = 0
	var/u = 0
	var/c = 0
	var/credits = 0
	var/obj/im/input
	var/obj/om/output
	proc
		calculate()
			credits += s * 10 + g * 50 + d * 300 + i + p * 2 + c * 50 //HELL YEAH!
			s = 0
			g = 0
			d = 0
			i = 0
			p = 0
			u = 0
			c = 0
	attackby(var/obj/A, var/mob/user)
		if(istype(A,/obj/item/weapon/coin/gold))
			g += 1
			user.drop_item()
			A.loc = src
			return
		if(istype(A,/obj/item/weapon/coin/silver))
			s += 1
			user.drop_item()
			A.loc = src
			return
		if(istype(A,/obj/item/weapon/coin/diamond))
			d += 1
			user.drop_item()
			A.loc = src
			return
		if(istype(A,/obj/item/weapon/coin/iron))
			i += 1
			user.drop_item()
			A.loc = src
			return
		if(istype(A,/obj/item/weapon/coin/plasma))
			p += 1
			user.drop_item()
			A.loc = src
			return
		if(istype(A,/obj/item/weapon/coin/uranium))
			u += 1
			user.drop_item()
			A.loc = src
			return
		if(istype(A,/obj/item/weapon/coin/clown))
			c += 1
			user.drop_item()
			A.loc = src
			return
		..()
	New()
		for (var/dir in cardinal)
			src.input = locate(/obj/im, get_step(src, dir))
			if(src.input) break
		for (var/dir in cardinal)
			src.output = locate(/obj/om, get_step(src, dir))
			if(src.output) break
	process()
		var/obj/item/weapon/moneybag/MB
		for(MB in input.loc)
			if(istype(MB,/obj/item/weapon/moneybag))
				break
		for(var/obj/item/weapon/coin/C in MB.contents)
			if(istype(C,/obj/item/weapon/coin/gold))
				g += 1
			if(istype(C,/obj/item/weapon/coin/silver))
				s += 1
			if(istype(C,/obj/item/weapon/coin/diamond))
				d += 1
			if(istype(C,/obj/item/weapon/coin/iron))
				i += 1
			if(istype(C,/obj/item/weapon/coin/plasma))
				p += 1
			if(istype(C,/obj/item/weapon/coin/uranium))
				u += 1
			if(istype(C,/obj/item/weapon/coin/clown))
				c += 1
			MB.contents -= C
	attack_hand(var/mob/user)
		user.machine = src
		var/dat
		dat += "<h1>Welcome to money-to-cash system!</h1><br>"
		dat += "In-system credits - [credits]<br>"
		dat += "<a href=\"?src=\ref[src]&calc=1\">Transform moneys</a><br>"
		dat += "<a href=\"?src=\ref[src]&with=1&us=\ref[user]\">Take cashes</a><br>"
		user << browse(dat,"window=RS")
		onclose(user,"close")
	Topic(href,href_list)
		if ((usr.machine==src && get_dist(src, usr) <= 1 || istype(usr, /mob/living/silicon/ai)))
			if(href_list["calc"])
				calculate()
				src.updateUsrDialog()
			if(href_list["with"] && href_list["us"] && output)
				var/amount = input(href_list["us"],"Select a cash",0) in list(1,10,20,50,100,200,500,1000, 0) as num
				switch(amount)
					if(1)
						new /obj/item/weapon/spacecash(output.loc)
						credits -= 1
					if(10)
						new /obj/item/weapon/spacecash/c10(output.loc)
						credits -= 10
					if(20)
						new /obj/item/weapon/spacecash/c20(output.loc)
						credits -= 20
					if(50)
						new /obj/item/weapon/spacecash/c50(output.loc)
						credits -= 50
					if(100)
						new /obj/item/weapon/spacecash/c100(output.loc)
						credits -= 100
					if(200)
						new /obj/item/weapon/spacecash/c200(output.loc)
						credits -= 200
					if(500)
						new /obj/item/weapon/spacecash/c500(output.loc)
						credits -= 500
					if(1000)
						new /obj/item/weapon/spacecash/c1000(output.loc)
						credits -= 1000
				src.updateUsrDialog()
		else
			usr.machine = null
			usr << browse(null,"window=RS")