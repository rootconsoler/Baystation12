/mob/living/carbon/human/verb/blink()
	set name = "Blink"
	set category = "Emotes"
	usr.emote("blink")
/mob/living/carbon/human/verb/blink_r()
	set name = "Rapid blink"
	set category = "Emotes"
	usr.emote("blink_r")
/mob/living/carbon/human/verb/bow()
	set name = "Bow at..."
	set category = "Emotes"
	var/mob/mobs = list()
	for(var/mob/V in viewers())
		if(V != usr)
			mobs += V
	var/m = input(usr,"Bow at?") in mobs
	usr.emote("bow [m]")
/mob/living/carbon/human/verb/salute()
	set name = "Salute on"
	set category = "Emotes"
	var/mob/mobs = list()
	for(var/mob/V in viewers())
		if(V != usr)
			mobs += V
	var/m = input(usr,"Salute onto?") in mobs
	usr.emote("salute [m]")
/mob/living/carbon/human/verb/choke()
	set name = "Choke"
	set category = "Emotes"
	usr.emote("choke")
/mob/living/carbon/human/verb/clap()
	set name = "Clap"
	set category = "Emotes"
	usr.emote("clap")
/mob/living/carbon/human/verb/flap()
	set name = "Flap"
	set category = "Emotes"
	usr.emote("flap")
/mob/living/carbon/human/verb/aflap()
	set name = "Angry flap"
	set category = "Emotes"
	usr.emote("aflap")
/mob/living/carbon/human/verb/drool()
	set name = "Drool"
	set category = "Emotes"
	usr.emote("drool")
/mob/living/carbon/human/verb/eyebrow()
	set name = "Eyebrow"
	set category = "Emotes"
	usr.emote("eyebrow")
/mob/living/carbon/human/verb/chuckle()
	set name = "Chuckle"
	set category = "Emotes"
	usr.emote("chuckle")
/mob/living/carbon/human/verb/twitch()
	set name = "Twitch violently"
	set category = "Emotes"
	usr.emote("twitch")
/mob/living/carbon/human/verb/twitch_v()
	set name = "Twitch"
	set category = "Emotes"
	usr.emote("twitch_v")
/mob/living/carbon/human/verb/faint()
	set name = "Faint"
	set category = "Emotes"
	usr.emote("faint")
/mob/living/carbon/human/verb/cough()
	set name = "Cough"
	set category = "Emotes"
	usr.emote("cough")
/mob/living/carbon/human/verb/frown()
	set name = "Frown"
	set category = "Emotes"
	usr.emote("frown")
/mob/living/carbon/human/verb/nod()
	set name = "Nod"
	set category = "Emotes"
	usr.emote("nod")
/mob/living/carbon/human/verb/blush()
	set name = "Blush"
	set category = "Emotes"
	usr.emote("blush")
/mob/living/carbon/human/verb/wave()
	set name = "Wave"
	set category = "Emotes"
	usr.emote("wave")
/mob/living/carbon/human/verb/gasp()
	set name = "Gasps"
	set category = "Emotes"
	usr.emote("gasp")
/mob/living/carbon/human/verb/breath()
	set name = "Breathe"
	set category = "Emotes"
	usr.emote("breathe")
/mob/living/carbon/human/verb/stopbreathe()
	set name = "Stop breathe"
	set category = "Emotes"
	usr.emote("stopbreath")
/mob/living/carbon/human/verb/holdb()
	set name = "Hold breathe"
	set category = "Emotes"
	usr.emote("holdbreath")
/mob/living/carbon/human/verb/deathgasp()
	set name = "Fake death"
	set category = "Emotes"
	usr.emote("deathgasp")
/mob/living/carbon/human/verb/giggle()
	set name = "Giggle"
	set category = "Emotes"
	usr.emote("giggle")
/mob/living/carbon/human/verb/glare()
	set name = "Glare"
	set category = "Emotes"
	usr.emote("glare")
/mob/living/carbon/human/verb/stare()
	set name = "Stare"
	set category = "Emotes"
	usr.emote("stare")
/mob/living/carbon/human/verb/look()
	set name = "Look at"
	set category = "Emotes"
	var/mob/mobs = list()
	for(var/mob/V in viewers())
		if(V != usr)
			mobs += V
	var/m = input(usr,"Look at?") in mobs
	usr.emote("look [m]")
/mob/living/carbon/human/verb/grin()
	set name = "Grin"
	set category = "Emotes"
	usr.emote("grin")
/mob/living/carbon/human/verb/sigh()
	set name = "Sigh"
	set category = "Emotes"
	usr.emote("sigh")
/mob/living/carbon/human/verb/laugh()
	set name = "Laugh"
	set category = "Emotes"
	usr.emote("laugh")
/mob/living/carbon/human/verb/cry()
	set name = "Cry"
	set category = "Emotes"
	usr.emote("cry")
/mob/living/carbon/human/verb/mumble()
	set name = "Mumble"
	set category = "Emotes"
	usr.emote("mumble")
/mob/living/carbon/human/verb/grumble()
	set name = "Grumble"
	set category = "Emotes"
	usr.emote("grumble")
/mob/living/carbon/human/verb/groan()
	set name = "Groan"
	set category = "Emotes"
	usr.emote("groan")
/mob/living/carbon/human/verb/moan()
	set name = "Moan"
	set category = "Emotes"
	usr.emote("moan")
/mob/living/carbon/human/verb/raise()
	set name = "Raise hand"
	set category = "Emotes"
	usr.emote("raise")
/mob/living/carbon/human/verb/shake()
	set name = "Shake head"
	set category = "Emotes"
	usr.emote("shake")
/mob/living/carbon/human/verb/shrug()
	set name = "Shrug"
	set category = "Emotes"
	usr.emote("shrug")
/mob/living/carbon/human/verb/smile()
	set name = "Smile"
	set category = "Emotes"
	usr.emote("smile")
/mob/living/carbon/human/verb/shiver()
	set name = "Shiver"
	set category = "Emotes"
	usr.emote("shiver")
/mob/living/carbon/human/verb/pale()
	set name = "Pale"
	set category = "Emotes"
	usr.emote("pale")
/mob/living/carbon/human/verb/tremble()
	set name = "Tremble"
	set category = "Emotes"
	usr.emote("tremble")
/mob/living/carbon/human/verb/sneeze()
	set name = "Sneeze"
	set category = "Emotes"
	usr.emote("sneeze")
/mob/living/carbon/human/verb/sniff()
	set name = "Sniff"
	set category = "Emotes"
	usr.emote("sniff")
/mob/living/carbon/human/verb/snore()
	set name = "Snore"
	set category = "Emotes"
	usr.emote("snore")
/mob/living/carbon/human/verb/whimper()
	set name = "Whimper"
	set category = "Emotes"
	usr.emote("whimper")
/mob/living/carbon/human/verb/wink()
	set name = "Wink"
	set category = "Emotes"
	usr.emote("wink")
/mob/living/carbon/human/verb/collapse()
	set name = "Collapse"
	set category = "Emotes"
	usr.emote("collapse")
/mob/living/carbon/human/verb/hugs()
	set name = "Hugs a..."
	set category = "Emotes"
	var/mob/mobs = list()
	for(var/mob/V in viewers())
		if(V != usr)
			mobs += V
	var/m = input(usr,"Hugs a?") in mobs
	usr.emote("hug [m]")
/mob/living/carbon/human/verb/handshake()
	set name = "Handshake"
	set category = "Emotes"
	usr.emote("handshake")
/mob/living/carbon/human/verb/daps()
	set name = "Daps"
	set category = "Emotes"
	usr.emote("daps")
/mob/living/carbon/human/verb/scream()
	set name = "Scream"
	set category = "Emotes"
	usr.emote("scream")