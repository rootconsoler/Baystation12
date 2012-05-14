/obj/machinery/EATM
	name = "ATM"
	desc = "ATM for credit card operations"
	icon = 'terminals.dmi'
	icon_state = "atm"
	anchored = 1
	use_power = 1
	idle_power_usage = 50
	var
		obj/item/weapon/card/id/Card
		obj/item/weapon/spacecash/Cashes = list()
		inserted = 0
		accepted = 0
		pincode = 0
	attackby(var/obj/A, var/mob/user)
		if(istype(A,/obj/item/weapon/spacecash))
			Cashes += A
			user.drop_item()
			A.loc = src
			inserted += A:worth
			return
		if(istype(A,/obj/item/weapon/coin))
			if(istype(A,/obj/item/weapon/coin/iron))
				Cashes += A
				user.drop_item()
				A.loc = src
				inserted += 1
				return
			if(istype(A,/obj/item/weapon/coin/silver))
				Cashes += A
				user.drop_item()
				A.loc = src
				inserted += 10
				return
			if(istype(A,/obj/item/weapon/coin/gold))
				Cashes += A
				user.drop_item()
				A.loc = src
				inserted += 50
				return
			if(istype(A,/obj/item/weapon/coin/plasma))
				Cashes += A
				user.drop_item()
				A.loc = src
				inserted += 2
				return
			if(istype(A,/obj/item/weapon/coin/diamond))
				Cashes += A
				user.drop_item()
				A.loc = src
				inserted += 300
				return
			user << "You insert your [A.name] in ATM"
		..()
	attack_hand(var/mob/user)
		if(!(stat && NOPOWER) && ishuman(user))
			var/dat
			user.machine = src
			if(!accepted)
				if(Scan(user))
					pincode = input(usr,"Enter a pin-code") as num
					if(Card.CheckAccess(pincode,usr))
						accepted = 1
						usr << sound('nya.mp3')
			else
				dat = null
				dat += "<h1>Welcome, [Card.registered_name]! You has [Card.money] credits</h1><br>"
				dat += "<h2>That ATM has [inserted] real moneys</h2><br>"
				dat += "Please, select action<br>"
				dat += "<a href=\"?src=\ref[src]&eca=1\">Eject inserted cashes</a><br/>"
				dat += "<a href=\"?src=\ref[src]&with=1\">Withdraw</a><br/>"
				dat += "<a href=\"?src=\ref[src]&ins=1\">Inject cashes</a><br/>"
				dat += "<a href=\"?src=\ref[src]&lock=1\">Lock</a><br/>"
			user << browse(dat,"window=atm")
			onclose(user,"close")
	proc
		Withdraw(var/mob/user)
			if(accepted)
				var/amount = input("How much would you like to withdraw?", "Amount", 0) in list(1,10,20,50,100,200,500,1000, 0)
				if(amount == 0)
					return
				if(Card.money >= amount)
					Card.money -= amount
					switch(amount)
						if(1)
							new /obj/item/weapon/spacecash(loc)
						if(10)
							new /obj/item/weapon/spacecash/c10(loc)
						if(20)
							new /obj/item/weapon/spacecash/c20(loc)
						if(50)
							new /obj/item/weapon/spacecash/c50(loc)
						if(100)
							new /obj/item/weapon/spacecash/c100(loc)
						if(200)
							new /obj/item/weapon/spacecash/c200(loc)
						if(500)
							new /obj/item/weapon/spacecash/c500(loc)
						if(1000)
							new /obj/item/weapon/spacecash/c1000(loc)
				else
					user << "\red Card don't have that amount"
					return
		Scan(var/mob/user)
			if(istype(user,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = user
				if(H.wear_id)
					if(istype(H.wear_id, /obj/item/weapon/card/id))
						Card = H.wear_id
						return 1
					if(istype(H.wear_id,/obj/item/device/pda))
						var/obj/item/device/pda/P = H.wear_id
						if(istype(P.id,/obj/item/weapon/card/id))
							Card = P.id
							return 1
					return 0
				return 0
		Insert()
			if(accepted)
				Card.money += inserted
				inserted = 0
	Topic(href,href_list)
		if (usr.machine==src && get_dist(src, usr) <= 1 || istype(usr, /mob/living/silicon/ai))
			if(href_list["eca"])
				if(accepted)
					for(var/obj/item/weapon/spacecash/M in Cashes)
						M.loc = loc
					inserted = 0
					if(!Cashes)
						Cashes = null
			if(href_list["with"] && Card)
				Withdraw(usr)
			if(href_list["ins"] && Card)
				if(accepted)
					Card.money += inserted
					inserted = 0
			if(href_list["lock"])
				Card = null
				accepted = 0
				usr.machine = null
				usr << browse(null,"window=atm")
			src.updateUsrDialog()
		else
			usr.machine = null
			usr << browse(null,"window=atm")