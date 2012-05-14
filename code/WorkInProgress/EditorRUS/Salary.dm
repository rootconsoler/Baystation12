/obj/machinery/salary
	name = "Salary computer"
	icon = 'terminals.dmi'
	icon_state = "OLDatm_off"
	density = 0
	anchored = 1
	var
		obj/item/weapon/card/id/blacklist = list()
		obj/item/weapon/card/id/insID
		credits = 0
		salary = 0
	proc
		SetSalary(var/amount)
			if(amount >= 0)
				salary = amount
		GetCredits(var/amount)
			if(amount <= 0)
				return 0
			credits += amount
			return 1
		Salary(var/mob/user)
			if(insID in blacklist)
				user << "\red You already get your salary"
				return
			if(!insID)
				user << "\blue Insert your ID, please"
				return
			if(credits < salary)
				user << "\red Enough credits"
				insID.money += credits
				credits = 0
			insID.money += salary
			credits -= salary
			blacklist += insID
		ResetBlack()
			blacklist = null
	attack_hand(var/mob/user)
		if(stat && NOPOWER)
			return
		if(user)
			user.machine = src
			var/dat
			dat += "<h2>Welcome to [src.name]. Current salary - [salary] credits.</h2><br>"
			if(insID)
				dat += "Welcome to system, [insID.registered_name]!<br>"
				dat += "Select action:<br>"
				dat += "<a href='?src=\ref[src];action=sal'>Get salary</a><br>"
				dat += "<a href='?src=\ref[src];action=eid'>Eject ID</a><br>"
			else
				dat += "Please, insert ID to authorize<br>"
				dat += "<a href='?src=\ref[src];action=id'>Insert</a><br>"
			user << browse(dat,"window=salary")
	Topic(href, href_list)
		if(get_dist(usr,src) <= 1 && usr)
			switch(href_list["action"])
				if("sal")
					Salary(usr)
				if("eid")
					insID.loc = loc
					insID = null
				if("id")
					var/obj/item/weapon/card/id/C = usr.equipped()
					if(istype(C, /obj/item/weapon/card/id))
						usr.drop_item()
						C.loc = src
						insID = C
						usr << "You insert your ID in [src.name]"
			src.updateUsrDialog()
			return
		usr << browse(null)
	attackby(var/obj/I,var/mob/user)
		if(I)
			if(istype(I,/obj/item/weapon/card/id) && !insID)
				usr.drop_item()
				I.loc = src
				insID = I
				usr << "You insert your ID in [src.name]"
				return
			usr << "Computer already have an ID"
			return
		..()
/obj/machinery/salarcomp
	name = "Salary control computer"
	icon = 'computer.dmi'
	icon_state = "old_security"
	density = 1
	anchored = 1
	var
		obj/machinery/salary/rcomps = list()
		credits = 0
	attackby(var/obj/M, var/mob/user)
		if(M)
			if(istype(M,/obj/item/weapon/spacecash))
				credits += M:worth * M:amount
				user << "\blue You insert [M:worth * M:amount] credits"
				del(M)
				return
			..()
	proc
		GetSalaryes()
			for(var/obj/machinery/salary/M in world)
				if(istype(M,/obj/machinery/salary))
					rcomps += M
	attack_hand(var/mob/user)
		user.machine = src
		if(!rcomps)
			GetSalaryes()
		else
			rcomps = null
			GetSalaryes()
		var/dat = "<h1>Welcome to salary system control</h1><br>"
		for(var/obj/machinery/salary/M in rcomps)
			dat += "<a href='?src=\ref[src]&csal=1&computer=\ref[M]'>[M.name] - set salary</a><br>"
			dat += "<a href='?src=\ref[src]&cc=1&computer=\ref[M]'>[M.name] - send credits</a><br>"
		user << browse(dat,"window=csalary")

	Topic(href, href_list)
		if(get_dist(usr,src) <= 1)
			if(href_list["csal"])
				var/obj/machinery/salary/S = href_list["computer"]
				var/newsal = input(usr,"Set salary for that division") as num
				if(newsal < 0)
					usr << "Salary must be positive!"
					return
				S.SetSalary(newsal)
			if(href_list["cc"])
				var/obj/machinery/salary/S = href_list["computer"]
				var/cr = input(usr,"Set how much credits will send to that computer",0) as num
				if(cr < 0)
					usr << "Credits must be positive!"
					return
				if(cr > credits)
					usr << "Enough credits"
					return
				S.GetCredits(cr)
				usr << "\blue SUCCESS!"
				credits -= cr
				S.ResetBlack()
			src.updateUsrDialog()
		else
			usr.machine = null
			usr << browse("window=csalary")