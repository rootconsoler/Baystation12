/obj/machinery/EATM
	name = "ATM"
	desc = "ATM for credit card operations"
	icon = 'terminals.dmi'
	icon_state = "atm"
	anchored = 1
	use_power = 1
	idle_power_usage = 50
	var
		obj/item/weapon/credit_card/Card
		obj/item/weapon/spacecash/Cashes = list()
		inserted = 0
		accepted = 0
		sname
		pincode = 0
	attackby(var/obj/A, var/mob/user)
		if(istype(A,/obj/item/weapon/spacecash))
			Cashes += A
			user.drop_item()
			A.loc = src
			inserted += A:worth
			return
		..()
	attack_hand(var/mob/user)
		var/dat
		user.machine = src
		if(!accepted)
			dat += "<a href=\"?src=\ref[src]&sid=1\">Swing ID</a><br>"
			dat += "<a href=\"?src=\ref[src]&scr=1\">Swing credit card</a><br>"
			dat += "<a href=\"?src=\ref[src]&pin=1\">Enter pin-code</a><br>"
			dat += "Entered pin-code is: [pincode]<br>"
			dat += "<a href=\"?src=\ref[src]&ent=1\">Access</a><br>"
		else
			dat = null
			dat += "<h1>Welcome, [sname]! You has [Card.money] credits</h1><br>"
			dat += "That ATM has [inserted] real moneys<br>"
			dat += "Please, select action<br>"
			dat += "<a href=\"?src=\ref[src]&ecr=1\">Eject credit card</a><br/>"
			dat += "<a href=\"?src=\ref[src]&eca=1\">Eject inserted cashes</a><br/>"
			dat += "<a href=\"?src=\ref[src]&with=1&us=\ref[user]\">Withdraw</a><br/>"
			dat += "<a href=\"?src=\ref[src]&ins=1\">Inject cashes</a><br/>"
			dat += "<a href=\"?src=\ref[src]&lock=1\">Lock</a><br/>"
		user << browse(dat,"window=atm")
		onclose(user,"close")
	proc
		EjectCredit()
			Card.loc = loc
			Card = null
		EjectCashes()
			if(accepted)
				for(var/obj/item/weapon/spacecash/M in Cashes)
					M.loc = loc
				inserted = 0
				if(!Cashes)
					Cashes = null
		Withdraw(var/mob/user)
			if(accepted)
				var/amount = input("How much would you like to withdraw?", "Amount", 0) in list(1,10,20,50,100,200,500,1000, 0)
				if(amount == 0)
					return
				if(Card.money > amount)
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
					user << "Card don't have that amount"
					return
		Insert()
			if(accepted)
				Card.money += inserted
				inserted = 0
	Topic(href,href_list)
		if (usr.machine==src && get_dist(src, usr) <= 1 || istype(usr, /mob/living/silicon/ai))
			if(href_list["sid"])
				var/obj/item/weapon/card/id/Q = usr.equipped()
				if(Q && istype(Q,/obj/item/weapon/card/id))
					sname = Q.registered_name
					usr << "You swipe your ID"
			if(href_list["scr"])
				var/obj/item/weapon/credit_card/C = usr.equipped()
				if(C && istype(C, /obj/item/weapon/credit_card) && !Card)
					usr.drop_item()
					C.loc = src
					Card = C
					usr << "You insert card to ATM"
			if(href_list["pin"])
				pincode = input(usr,"Enter a pin-code") as num
			if(href_list["ent"])
				if(Card.CheckAccess(sname,pincode,usr))
					accepted = 1
					usr << sound('nippa.ogg')
			if(href_list["ecr"])
				EjectCredit()
			if(href_list["eca"])
				EjectCashes()
			if(href_list["with"] && href_list["us"] && Card)
				Withdraw(href_list["us"])
			if(href_list["ins"] && Card)
				Insert()
			if(href_list["lock"])
				if(!Card)
					accepted = 0
			src.updateUsrDialog()
		else
			usr.machine = null
			usr << browse(null,"window=atm")