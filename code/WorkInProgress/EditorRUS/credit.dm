//Credit card
/obj/item/weapon/credit_card
	name = "Credit card"
	icon = 'credit.dmi'
	icon_state = "Credit"
	w_class = 1.0
	var
		money = 2000
		pin_code = 123456
		rname = ""
	proc
		CheckAccess(var/aname,var/apin,var/mob/user)
			if(aname == rname)
				if(apin == pin_code)
					user << "\blue \bold Correct!"
					return 1
				else
					user << "\red \bold Pin code incorrect"
			else
				user << "\red \bold That ID name not registered to credit"
			return 0
	attack_self(var/mob/user)
		user << "That credit card has [money] credits, registered to [rname]."
