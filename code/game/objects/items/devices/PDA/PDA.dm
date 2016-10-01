
//The advanced pea-green monochrome lcd of tomorrow.

var/global/list/obj/item/device/pda/PDAs = list()


/obj/item/device/pda
	name = "\improper PDA"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. Functionality determined by a preprogrammed ROM cartridge."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pda"
	item_state = "electronic"
	flags = NOBLUDGEON
	w_class = 1
	slot_flags = SLOT_ID | SLOT_BELT
	origin_tech = "programming=2"

	//Main variables
	var/owner = null // String name of owner
	var/default_cartridge = 0 // Access level defined by cartridge
	var/obj/item/weapon/cartridge/cartridge = null //current cartridge
	var/mode = 0 //Controls what menu the PDA will display. 0 is hub; the rest are either built in or based on cartridge.
	var/icon_alert = "pda-r" //Icon to be overlayed for message alerts. Taken from the pda icon file.

	//Secondary variables
	var/scanmode = 0 //1 is medical scanner, 2 is forensics, 3 is reagent scanner.
	var/fon = 0 //Is the flashlight function on?
	var/f_lum = 3 //Luminosity for the flashlight function
	var/silent = 0 //To beep or not to beep, that is the question
	var/toff = 0 //If 1, messenger disabled
	var/tnote = null //Current Texts
	var/last_text //No text spamming
	var/last_noise //Also no honk spamming that's bad too
	var/ttone = "beep" //The ringtone!
	var/lock_code = "" // Lockcode to unlock uplink
	var/honkamt = 0 //How many honks left when infected with honk.exe
	var/mimeamt = 0 //How many silence left when infected with mime.exe
	var/note = "Congratulations, your station has chosen the Thinktronic 5230 Personal Data Assistant!" //Current note in the notepad function
	var/notehtml = ""
	var/notescanned = 0 // True if what is in the notekeeper was from a paper.
	var/cart = "" //A place to stick cartridge menu information
	var/detonate = 1 // Can the PDA be blown up?
	var/hidden = 0 // Is the PDA hidden from the PDA list?
	var/emped = 0

	var/obj/item/weapon/card/id/id = null //Making it possible to slot an ID card into the PDA so it can function as both.
	var/ownjob = null //related to above

	var/obj/item/device/paicard/pai = null	// A slot for a personal AI device

	var/image/photo = null //Scanned photo

	var/list/contained_item = list(/obj/item/weapon/pen, /obj/item/toy/crayon, /obj/item/weapon/lipstick, /obj/item/device/flashlight/pen, /obj/item/clothing/mask/cigarette)
	var/obj/item/inserted_item //Used for pen, crayon, and lipstick insertion or removal. Same as above.

/obj/item/device/pda/pickup(mob/user)
	..()
	if(fon)
		SetLuminosity(0)
		user.AddLuminosity(f_lum)

/obj/item/device/pda/dropped(mob/user)
	..()
	if(fon)
		user.AddLuminosity(-f_lum)
		SetLuminosity(f_lum)

/obj/item/device/pda/New()
	..()
	if(fon)
		if(!isturf(loc))
			loc.AddLuminosity(f_lum)
			SetLuminosity(0)
		else
			SetLuminosity(f_lum)
	PDAs += src
	if(default_cartridge)
		cartridge = new default_cartridge(src)
	inserted_item =	new /obj/item/weapon/pen(src)

/obj/item/device/pda/proc/update_label()
	name = "PDA-[owner] ([ownjob])" //Name generalisation

/obj/item/device/pda/GetAccess()
	if(id)
		return id.GetAccess()
	else
		return ..()

/obj/item/device/pda/GetID()
	return id

/obj/item/device/pda/MouseDrop(obj/over_object, src_location, over_location)
	var/mob/M = usr
	if((!istype(over_object, /obj/screen)) && usr.canUseTopic(src))
		return attack_self(M)
	return

/obj/item/device/pda/attack_self(mob/user)
	var/datum/asset/assets = get_asset_datum(/datum/asset/simple/pda)
	assets.send(user)

	user.set_machine(src)

	if(hidden_uplink && hidden_uplink.active)
		hidden_uplink.interact(user)
		return

	var/dat = "<html><head><title>Personal Data Assistant</title></head><body bgcolor=\"#808000\"><style>a, a:link, a:visited, a:active, a:hover { color: #000000; }img {border-style:none;}</style>"

	dat += "<a href='byond://?src=\ref[src];choice=Refresh'><img src=pda_refresh.png> Refresh</a>"

	if ((!isnull(cartridge)) && (mode == 0))
		dat += " | <a href='byond://?src=\ref[src];choice=Eject'><img src=pda_eject.png> Eject [cartridge]</a>"
	if (mode)
		dat += " | <a href='byond://?src=\ref[src];choice=Return'><img src=pda_menu.png> Return</a>"

	dat += "<br>"

	if (!owner)
		dat += "Warning: No owner information entered.  Please swipe card.<br><br>"
		dat += "<a href='byond://?src=\ref[src];choice=Refresh'><img src=pda_refresh.png> Retry</a>"
	else
		switch (mode)
			if (0)
				dat += "<h2>PERSONAL DATA ASSISTANT v.1.2</h2>"
				dat += "Owner: [owner], [ownjob]<br>"
				dat += text("ID: <A href='?src=\ref[src];choice=Authenticate'>[id ? "[id.registered_name], [id.assignment]" : "----------"]")
				dat += text("<br><A href='?src=\ref[src];choice=UpdateInfo'>[id ? "Update PDA Info" : ""]</A><br><br>")

				dat += "[worldtime2text()]<br>" //:[world.time / 100 % 6][world.time / 100 % 10]"
				dat += "[time2text(world.realtime, "MMM DD")] [year_integer+540]"

				dat += "<br><br>"

				dat += "<h4>General Functions</h4>"
				dat += "<ul>"
				dat += "<li><a href='byond://?src=\ref[src];choice=1'><img src=pda_notes.png> Notekeeper</a></li>"
				dat += "<li><a href='byond://?src=\ref[src];choice=2'><img src=pda_mail.png> Messenger</a></li>"

				if (cartridge)
					if (cartridge.access_clown)
						dat += "<li><a href='byond://?src=\ref[src];choice=Honk'><img src=pda_honk.png> Honk Synthesizer</a></li>"
						dat += "<li><a href='byond://?src=\ref[src];choice=Trombone'><img src=pda_honk.png> Sad Trombone</a></li>"
					if (cartridge.access_manifest)
						dat += "<li><a href='byond://?src=\ref[src];choice=41'><img src=pda_notes.png> View Crew Manifest</a></li>"
					if(cartridge.access_status_display)
						dat += "<li><a href='byond://?src=\ref[src];choice=42'><img src=pda_status.png> Set Status Display</a></li>"
					dat += "</ul>"
					if (cartridge.access_engine)
						dat += "<h4>Engineering Functions</h4>"
						dat += "<ul>"
						dat += "<li><a href='byond://?src=\ref[src];choice=43'><img src=pda_power.png> Power Monitor</a></li>"
						dat += "</ul>"
					if (cartridge.access_medical)
						dat += "<h4>Medical Functions</h4>"
						dat += "<ul>"
						dat += "<li><a href='byond://?src=\ref[src];choice=44'><img src=pda_medical.png> Medical Records</a></li>"
						dat += "<li><a href='byond://?src=\ref[src];choice=Medical Scan'><img src=pda_scanner.png> [scanmode == 1 ? "Disable" : "Enable"] Medical Scanner</a></li>"
						dat += "</ul>"
					if (cartridge.access_security)
						dat += "<h4>Security Functions</h4>"
						dat += "<ul>"
						dat += "<li><a href='byond://?src=\ref[src];choice=45'><img src=pda_cuffs.png> Security Records</A></li>"
						dat += "</ul>"
					if(cartridge.access_quartermaster)
						dat += "<h4>Quartermaster Functions:</h4>"
						dat += "<ul>"
						dat += "<li><a href='byond://?src=\ref[src];choice=47'><img src=pda_crate.png> Supply Records</A></li>"
						dat += "</ul>"
				dat += "</ul>"

				dat += "<h4>Utilities</h4>"
				dat += "<ul>"
				if (cartridge)
					if(cartridge.bot_access_flags)
						dat += "<li><a href='byond://?src=\ref[src];choice=54'><img src=pda_medbot.png> Bots Access</a></li>"
					if (cartridge.access_janitor)
						dat += "<li><a href='byond://?src=\ref[src];choice=49'><img src=pda_bucket.png> Custodial Locator</a></li>"
					if (istype(cartridge.radio, /obj/item/radio/integrated/signal))
						dat += "<li><a href='byond://?src=\ref[src];choice=40'><img src=pda_signaler.png> Signaler System</a></li>"
					if (cartridge.access_newscaster)
						dat += "<li><a href='byond://?src=\ref[src];choice=53'><img src=pda_notes.png> Newscaster Access </a></li>"
					if (cartridge.access_reagent_scanner)
						dat += "<li><a href='byond://?src=\ref[src];choice=Reagent Scan'><img src=pda_reagent.png> [scanmode == 3 ? "Disable" : "Enable"] Reagent Scanner</a></li>"
					if (cartridge.access_engine)
						dat += "<li><a href='byond://?src=\ref[src];choice=Halogen Counter'><img src=pda_reagent.png> [scanmode == 4 ? "Disable" : "Enable"] Halogen Counter</a></li>"
					if (cartridge.access_atmos)
						dat += "<li><a href='byond://?src=\ref[src];choice=Gas Scan'><img src=pda_reagent.png> [scanmode == 5 ? "Disable" : "Enable"] Gas Scanner</a></li>"
					if (cartridge.access_remote_door)
						dat += "<li><a href='byond://?src=\ref[src];choice=Toggle Door'><img src=pda_rdoor.png> Toggle Remote Door</a></li>"
					if (cartridge.access_dronephone)
						dat += "<li><a href='byond://?src=\ref[src];choice=Drone Phone'><img src=pda_dronephone.png> Drone Phone</a></li>"
				dat += "<li><a href='byond://?src=\ref[src];choice=3'><img src=pda_atmos.png> Atmospheric Scan</a></li>"
				dat += "<li><a href='byond://?src=\ref[src];choice=Light'><img src=pda_flashlight.png> [fon ? "Disable" : "Enable"] Flashlight</a></li>"
				if (pai)
					if(pai.loc != src)
						pai = null
					else
						dat += "<li><a href='byond://?src=\ref[src];choice=pai;option=1'>pAI Device Configuration</a></li>"
						dat += "<li><a href='byond://?src=\ref[src];choice=pai;option=2'>Eject pAI Device</a></li>"
				dat += "</ul>"

			if (1)
				dat += "<h4><img src=pda_notes.png> Notekeeper V2.2</h4>"
				dat += "<a href='byond://?src=\ref[src];choice=Edit'>Edit</a><br>"
				if(notescanned)
					dat += "(This is a scanned image, editing it may cause some text formatting to change.)<br>"
				dat += "<HR><font face=\"[PEN_FONT]\">[(!notehtml ? note : notehtml)]</font>"

			if (2)
				dat += "<h4><img src=pda_mail.png> SpaceMessenger V3.9.6</h4>"
				dat += "<a href='byond://?src=\ref[src];choice=Toggle Ringer'><img src=pda_bell.png> Ringer: [silent == 1 ? "Off" : "On"]</a> | "
				dat += "<a href='byond://?src=\ref[src];choice=Toggle Messenger'><img src=pda_mail.png> Send / Receive: [toff == 1 ? "Off" : "On"]</a> | "
				dat += "<a href='byond://?src=\ref[src];choice=Ringtone'><img src=pda_bell.png> Set Ringtone</a> | "
				dat += "<a href='byond://?src=\ref[src];choice=21'><img src=pda_mail.png> Messages</a><br>"

				if (istype(cartridge, /obj/item/weapon/cartridge/syndicate))
					dat += "<b>[cartridge:shock_charges] detonation charges left.</b><HR>"
				if (istype(cartridge, /obj/item/weapon/cartridge/clown))
					dat += "<b>[cartridge:honk_charges] viral files left.</b><HR>"
				if (istype(cartridge, /obj/item/weapon/cartridge/mime))
					dat += "<b>[cartridge:mime_charges] viral files left.</b><HR>"

				dat += "<h4><img src=pda_menu.png> Detected PDAs</h4>"

				dat += "<ul>"
				var/count = 0

				if (!toff)
					for (var/obj/item/device/pda/P in sortNames(get_viewable_pdas()))
						if (P == src)
							continue
						dat += "<li><a href='byond://?src=\ref[src];choice=Message;target=\ref[P]'>[P]</a>"
						if (istype(cartridge, /obj/item/weapon/cartridge/syndicate) && P.detonate)
							dat += " (<a href='byond://?src=\ref[src];choice=Detonate;target=\ref[P]'><img src=pda_boom.png>*Detonate*</a>)"
						if (istype(cartridge, /obj/item/weapon/cartridge/clown))
							dat += " (<a href='byond://?src=\ref[src];choice=Send Honk;target=\ref[P]'><img src=pda_honk.png>*Send Virus*</a>)"
						if (istype(cartridge, /obj/item/weapon/cartridge/mime))
							dat += " (<a href='byond://?src=\ref[src];choice=Send Silence;target=\ref[P]'>*Send Virus*</a>)"
						dat += "</li>"
						count++
				dat += "</ul>"
				if (count == 0)
					dat += "None detected.<br>"
				else if(cartridge && cartridge.spam_enabled)
					dat += "<a href='byond://?src=\ref[src];choice=MessageAll'>Send To All</a>"

			if(21)
				dat += "<h4><img src=pda_mail.png> SpaceMessenger V3.9.6</h4>"
				dat += "<a href='byond://?src=\ref[src];choice=Clear'><img src=pda_blank.png> Clear Messages</a>"

				dat += "<h4><img src=pda_mail.png> Messages</h4>"

				dat += tnote
				dat += "<br>"

			if (3)
				dat += "<h4><img src=pda_atmos.png> Atmospheric Readings</h4>"

				var/turf/T = user.loc
				if (isnull(T))
					dat += "Unable to obtain a reading.<br>"
				else
					var/datum/gas_mixture/environment = T.return_air()
					var/list/env_gases = environment.gases

					var/pressure = environment.return_pressure()
					var/total_moles = environment.total_moles()

					dat += "Air Pressure: [round(pressure,0.1)] kPa<br>"

					if (total_moles)
						for(var/id in env_gases)
							var/gas_level = env_gases[id][MOLES]/total_moles
							if(gas_level > 0)
								dat += "[env_gases[id][GAS_META][META_GAS_NAME]]: [round(gas_level*100, 0.01)]%<br>"

					dat += "Temperature: [round(environment.temperature-T0C)]&deg;C<br>"
				dat += "<br>"
			else//Else it links to the cart menu proc. Although, it really uses menu hub 4--menu 4 doesn't really exist as it simply redirects to hub.
				dat += cart

	dat += "</body></html>"
	user << browse(dat, "window=pda;size=400x450;border=1;can_resize=1;can_minimize=0")
	onclose(user, "pda", src)

/obj/item/device/pda/Topic(href, href_list)
	..()
	var/mob/living/U = usr
	//Looking for master was kind of pointless since PDAs don't appear to have one.

	if(usr.canUseTopic(src) && !href_list["close"])
		add_fingerprint(U)
		U.set_machine(src)

		switch(href_list["choice"])

//BASIC FUNCTIONS===================================

			if("Refresh")//Refresh, goes to the end of the proc.
			if("Return")//Return
				if(mode<=9)
					mode = 0
				else
					mode = round(mode/10)
					if(mode==4 || mode == 5)//Fix for cartridges. Redirects to hub.
						mode = 0
					else if(mode >= 40 && mode <= 59)//Fix for cartridges. Redirects to refresh the menu.
						cartridge.mode = mode
						cartridge.unlock()
			if ("Authenticate")//Checks for ID
				id_check(U, 1)
			if("UpdateInfo")
				ownjob = id.assignment
				update_label()
			if("Eject")//Ejects the cart, only done from hub.
				if (!isnull(cartridge))
					U.put_in_hands(cartridge)
					U << "<span class='notice'>You remove [cartridge] from [src].</span>"
					scanmode = 0
					if (cartridge.radio)
						cartridge.radio.hostpda = null
					cartridge = null

//MENU FUNCTIONS===================================

			if("0")//Hub
				mode = 0
			if("1")//Notes
				mode = 1
			if("2")//Messenger
				mode = 2
			if("21")//Read messeges
				mode = 21
			if("3")//Atmos scan
				mode = 3
			if("4")//Redirects to hub
				mode = 0


//MAIN FUNCTIONS===================================

			if("Light")
				if(fon)
					fon = 0
					if(src in U.contents)
						U.AddLuminosity(-f_lum)
					else
						SetLuminosity(0)
				else
					fon = 1
					if(src in U.contents)
						U.AddLuminosity(f_lum)
					else
						SetLuminosity(f_lum)
			if("Medical Scan")
				if(scanmode == 1)
					scanmode = 0
				else if((!isnull(cartridge)) && (cartridge.access_medical))
					scanmode = 1
			if("Reagent Scan")
				if(scanmode == 3)
					scanmode = 0
				else if((!isnull(cartridge)) && (cartridge.access_reagent_scanner))
					scanmode = 3
			if("Halogen Counter")
				if(scanmode == 4)
					scanmode = 0
				else if((!isnull(cartridge)) && (cartridge.access_engine))
					scanmode = 4
			if("Honk")
				if ( !(last_noise && world.time < last_noise + 20) )
					playsound(loc, 'sound/items/bikehorn.ogg', 50, 1)
					last_noise = world.time
			if("Trombone")
				if ( !(last_noise && world.time < last_noise + 20) )
					playsound(loc, 'sound/misc/sadtrombone.ogg', 50, 1)
					last_noise = world.time
			if("Gas Scan")
				if(scanmode == 5)
					scanmode = 0
				else if((!isnull(cartridge)) && (cartridge.access_atmos))
					scanmode = 5
			if("Drone Phone")
				var/area/A = get_area(U)
				var/alert_s = input(U,"Alert severity level","Ping Drones",null) as null|anything in list("Low","Medium","High","Critical")
				if(A && alert_s)
					var/msg = "<span class='boldnotice'>NON-DRONE PING: [U.name]: [alert_s] priority alert in [A.name]!</span>"
					_alert_drones(msg, 1)
					U << msg


//NOTEKEEPER FUNCTIONS===================================

			if ("Edit")
				var/n = stripped_multiline_input(U, "Please enter message", name, note)
				if (in_range(src, U) && loc == U)
					if (mode == 1 && n)
						note = n
						notehtml = parsepencode(n, U, SIGNFONT)
						notescanned = 0
				else
					U << browse(null, "window=pda")
					return

//MESSENGER FUNCTIONS===================================

			if("Toggle Messenger")
				toff = !toff
			if("Toggle Ringer")//If viewing texts then erase them, if not then toggle silent status
				silent = !silent
			if("Clear")//Clears messages
				tnote = null
			if("Ringtone")
				var/t = input(U, "Please enter new ringtone", name, ttone) as text
				if(in_range(src, U) && loc == U)
					if(t)
						if(hidden_uplink && (trim(lowertext(t)) == trim(lowertext(lock_code))))
							hidden_uplink.interact(U)
							U << "The PDA softly beeps."
							U << browse(null, "window=pda")
							src.mode = 0
						else
							t = copytext(sanitize(t), 1, 20)
							ttone = t
				else
					U << browse(null, "window=pda")
					return
			if("Message")
				var/obj/item/device/pda/P = locate(href_list["target"])
				src.create_message(U, P)

			if("MessageAll")
				src.send_to_all(U)

			if("Send Honk")//Honk virus
				if(istype(cartridge, /obj/item/weapon/cartridge/clown))//Cartridge checks are kind of unnecessary since everything is done through switch.
					var/obj/item/device/pda/P = locate(href_list["target"])//Leaving it alone in case it may do something useful, I guess.
					if(!isnull(P))
						if (!P.toff && cartridge:honk_charges > 0)
							cartridge:honk_charges--
							U.show_message("<span class='notice'>Virus sent!</span>", 1)
							P.honkamt = (rand(15,20))
					else
						U << "PDA not found."
				else
					U << browse(null, "window=pda")
					return
			if("Send Silence")//Silent virus
				if(istype(cartridge, /obj/item/weapon/cartridge/mime))
					var/obj/item/device/pda/P = locate(href_list["target"])
					if(!isnull(P))
						if (!P.toff && cartridge:mime_charges > 0)
							cartridge:mime_charges--
							U.show_message("<span class='notice'>Virus sent!</span>", 1)
							P.silent = 1
							P.ttone = "silence"
					else
						U << "PDA not found."
				else
					U << browse(null, "window=pda")
					return

//SYNDICATE FUNCTIONS===================================

			if("Toggle Door")
				if(cartridge && cartridge.access_remote_door)
					for(var/obj/machinery/door/poddoor/M in machines)
						if(M.id == cartridge.remote_door_id)
							if(M.density)
								M.open()
							else
								M.close()


			if("Detonate")//Detonate PDA
				if(istype(cartridge, /obj/item/weapon/cartridge/syndicate))
					var/obj/item/device/pda/P = locate(href_list["target"])
					if(!isnull(P))
						if (!P.toff && cartridge:shock_charges > 0)
							cartridge:shock_charges--

							var/difficulty = 0

							if(P.cartridge)
								difficulty += P.cartridge.access_medical
								difficulty += P.cartridge.access_security
								difficulty += P.cartridge.access_engine
								difficulty += P.cartridge.access_clown
								difficulty += P.cartridge.access_janitor
								difficulty += P.cartridge.access_manifest * 2
							else
								difficulty += 2

							if(prob(difficulty * 15) || (P.hidden_uplink))
								U.show_message("<span class='danger'>An error flashes on your [src].</span>", 1)
							else
								U.show_message("<span class='notice'>Success!</span>", 1)
								P.explode()
					else
						U << "PDA not found."
				else
					U.unset_machine()
					U << browse(null, "window=pda")
					return

//pAI FUNCTIONS===================================
			if("pai")
				switch(href_list["option"])
					if("1")		// Configure pAI device
						pai.attack_self(U)
					if("2")		// Eject pAI device
						var/turf/T = get_turf(src.loc)
						if(T)
							pai.loc = T

//LINK FUNCTIONS===================================

			else//Cartridge menu linking
				mode = text2num(href_list["choice"])
				if(cartridge)
					cartridge.mode = mode
					cartridge.unlock()
	else//If not in range, can't interact or not using the pda.
		U.unset_machine()
		U << browse(null, "window=pda")
		return

//EXTRA FUNCTIONS===================================

	if (mode == 2||mode == 21)//To clear message overlays.
		cut_overlays()

	if ((honkamt > 0) && (prob(60)))//For clown virus.
		honkamt--
		playsound(loc, 'sound/items/bikehorn.ogg', 30, 1)

	if(U.machine == src && href_list["skiprefresh"]!="1")//Final safety.
		attack_self(U)//It auto-closes the menu prior if the user is not in range and so on.
	else
		U.unset_machine()
		U << browse(null, "window=pda")
	return

/obj/item/device/pda/proc/remove_id()
	if (id)
		if (ismob(loc))
			var/mob/M = loc
			M.put_in_hands(id)
			usr << "<span class='notice'>You remove the ID from the [name].</span>"
		else
			id.loc = get_turf(src)
		id = null

/obj/item/device/pda/proc/msg_input(mob/living/U = usr)
	var/t = stripped_input(U, "Please enter message", name, null, MAX_MESSAGE_LEN)
	t = sanitize_a0(t)
	if (!t || toff)
		return
	if (!in_range(src, U) && loc != U)
		return
	if(!U.canUseTopic(src))
		return
	if(emped)
		t = Gibberish(t, 100)
	return t

/obj/item/device/pda/proc/send_message(mob/living/user = usr,list/obj/item/device/pda/targets)
	var/message = msg_input(user)

	if(!message || !targets.len)
		return

	if(last_text && world.time < last_text + 5)
		return

	var/multiple = targets.len > 1

	var/datum/data_pda_msg/last_sucessful_msg
	for(var/obj/item/device/pda/P in targets)
		if(P == src)
			continue
		var/obj/machinery/message_server/MS = null
		MS = can_send(P)
		if(MS)
			var/datum/data_pda_msg/msg = MS.send_pda_message("[P.owner]","[owner]","[message]",photo)
			if(msg)
				last_sucessful_msg = msg
			if(!multiple)
				show_to_sender(msg)
			P.show_recieved_message(msg,src)
			if(!multiple)
				show_to_ghosts(user,msg)
				log_pda("[user] (PDA: [src.name]) sent \"[message]\" to [P.name]")
		else
			if(!multiple)
				user << "<span class='notice'>ERROR: Server isn't responding.</span>"
				return
	photo = null

	if(multiple)
		show_to_sender(last_sucessful_msg,1)
		show_to_ghosts(user,last_sucessful_msg,1)
		log_pda("[user] (PDA: [src.name]) sent \"[message]\" to Everyone")

/obj/item/device/pda/proc/show_to_sender(datum/data_pda_msg/msg,multiple = 0)
	tnote += "<i><b>&rarr; To [multiple ? "Everyone" : msg.recipient]:</b></i><br>[msg.message][msg.get_photo_ref()]<br>"

/obj/item/device/pda/proc/show_recieved_message(datum/data_pda_msg/msg,obj/item/device/pda/source)
	tnote += "<i><b>&larr; From <a href='byond://?src=\ref[src];choice=Message;target=\ref[source]'>[source.owner]</a> ([source.ownjob]):</b></i><br>[msg.message][msg.get_photo_ref()]<br>"

	if (!silent)
		playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
		audible_message("\icon[src] *[ttone]*", null, 3)
	//Search for holder of the PDA.
	var/mob/living/L = null
	if(loc && isliving(loc))
		L = loc
	//Maybe they are a pAI!
	else
		L = get(src, /mob/living/silicon)

	if(L && L.stat != UNCONSCIOUS)
		L << "\icon[src] <b>Message from [source.owner] ([source.ownjob]), </b>\"[msg.message]\"[msg.get_photo_ref()] (<a href='byond://?src=\ref[src];choice=Message;skiprefresh=1;target=\ref[source]'>Reply</a>)"

	cut_overlays()
	add_overlay(image(icon, icon_alert))

/obj/item/device/pda/proc/show_to_ghosts(mob/living/user, datum/data_pda_msg/msg,multiple = 0)
	for(var/mob/M in player_list)
		if(isobserver(M) && M.client && (M.client.prefs.chat_toggles & CHAT_GHOSTPDA))
			var/link = FOLLOW_LINK(M, user)
			M << "[link] <span class='name'>[msg.sender] </span><span class='game say'>PDA Message</span> --> <span class='name'>[multiple ? "Everyone" : msg.recipient]</span>: <span class='message'>[msg.message][msg.get_photo_ref()]</span></span>"

/obj/item/device/pda/proc/can_send(obj/item/device/pda/P)
	if(!P || qdeleted(P) || P.toff)
		return null

	var/obj/machinery/message_server/useMS = null
	if(message_servers)
		for (var/obj/machinery/message_server/MS in message_servers)
		//PDAs are now dependant on the Message Server.
			if(MS.active)
				useMS = MS
				break

	var/datum/signal/signal = src.telecomms_process()

	if(!P || qdeleted(P) || P.toff) //in case the PDA or mob gets destroyed during telecomms_process()
		return null

	var/useTC = 0
	if(signal)
		if(signal.data["done"])
			useTC = 1
			var/turf/pos = get_turf(P)
			if(pos.z in signal.data["level"])
				useTC = 2

	if(useTC == 2)
		return useMS
	else
		return null


/obj/item/device/pda/proc/send_to_all(mob/living/U = usr)
	send_message(U,get_viewable_pdas())

/obj/item/device/pda/proc/create_message(mob/living/U = usr, obj/item/device/pda/P)
	send_message(U,list(P))

/obj/item/device/pda/AltClick()
	..()

	if(issilicon(usr))
		return

	if(usr.canUseTopic(src))
		if(id)
			remove_id()
		else
			usr << "<span class='warning'>This PDA does not have an ID in it!</span>"

/obj/item/device/pda/verb/verb_remove_id()
	set category = "Object"
	set name = "Eject ID"
	set src in usr

	if(issilicon(usr))
		return

	if (usr.canUseTopic(src))
		if(id)
			remove_id()
		else
			usr << "<span class='warning'>This PDA does not have an ID in it!</span>"

/obj/item/device/pda/verb/verb_remove_pen()
	set category = "Object"
	set name = "Remove Pen"
	set src in usr

	if(issilicon(usr))
		return

	if (usr.canUseTopic(src))
		if(inserted_item)
			if(ismob(loc))
				var/mob/M = loc
				M.put_in_hands(inserted_item)
			else
				inserted_item.forceMove(loc)
			usr << "<span class='notice'>You remove \the [inserted_item] from \the [src].</span>"
			inserted_item = null
		else
			usr << "<span class='warning'>This PDA does not have a pen in it!</span>"
/obj/item/device/pda/proc/id_check(mob/user, choice as num)//To check for IDs; 1 for in-pda use, 2 for out of pda use.
	if(choice == 1)
		if (id)
			remove_id()
		else
			var/obj/item/I = user.get_active_held_item()
			if (istype(I, /obj/item/weapon/card/id))
				if(!user.unEquip(I))
					return 0
				I.loc = src
				id = I
	else
		var/obj/item/weapon/card/I = user.get_active_held_item()
		if (istype(I, /obj/item/weapon/card/id) && I:registered_name)
			if(!user.unEquip(I))
				return 0
			var/obj/old_id = id
			I.loc = src
			id = I
			user.put_in_hands(old_id)
	return 1

// access to status display signals
/obj/item/device/pda/attackby(obj/item/C, mob/user, params)
	if(istype(C, /obj/item/weapon/cartridge) && !cartridge)
		cartridge = C
		if(!user.unEquip(C))
			return
		cartridge.loc = src
		user << "<span class='notice'>You insert [cartridge] into [src].</span>"
		if(cartridge.radio)
			cartridge.radio.hostpda = src

	else if(istype(C, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/idcard = C
		if(!idcard.registered_name)
			user << "<span class='warning'>\The [src] rejects the ID!</span>"
			return
		if(!owner)
			owner = idcard.registered_name
			ownjob = idcard.assignment
			update_label()
			user << "<span class='notice'>Card scanned.</span>"
		else
			//Basic safety check. If either both objects are held by user or PDA is on ground and card is in hand.
			if(((src in user.contents) && (C in user.contents)) || (istype(loc, /turf) && in_range(src, user) && (C in user.contents)) )
				if(!id_check(user, 2))
					return
				user << "<span class='notice'>You put the ID into \the [src]'s slot.</span>"
				updateSelfDialog()//Update self dialog on success.
			return	//Return in case of failed check or when successful.
		updateSelfDialog()//For the non-input related code.
	else if(istype(C, /obj/item/device/paicard) && !src.pai)
		if(!user.unEquip(C))
			return
		C.loc = src
		pai = C
		user << "<span class='notice'>You slot \the [C] into [src].</span>"
		updateUsrDialog()
	else if(is_type_in_list(C, contained_item)) //Checks if there is a pen
		if(inserted_item)
			user << "<span class='warning'>There is already \a [inserted_item] in \the [src]!</span>"
		else
			if(!user.unEquip(C))
				return
			C.forceMove(src)
			user << "<span class='notice'>You slide \the [C] into \the [src].</span>"
			inserted_item = C
	else if(istype(C, /obj/item/weapon/photo))
		var/obj/item/weapon/photo/P = C
		photo = P.img
		user << "<span class='notice'>You scan \the [C].</span>"
	else if(hidden_uplink && hidden_uplink.active)
		hidden_uplink.attackby(C, user, params)
	else
		return ..()

/obj/item/device/pda/attack(mob/living/carbon/C, mob/living/user)
	if(istype(C))
		switch(scanmode)

			if(1)
				C.visible_message("<span class='alert'>[user] has analyzed [C]'s vitals!</span>")
				healthscan(user, C, 1)
				add_fingerprint(user)

			if(2)
				// Unused

			if(4)
				C.visible_message("<span class='warning'>[user] has analyzed [C]'s radiation levels!</span>")

				user.show_message("<span class='notice'>Analyzing Results for [C]:</span>")
				if(C.radiation)
					user.show_message("\green Radiation Level: \black [C.radiation]")
				else
					user.show_message("<span class='notice'>No radiation detected.</span>")

/obj/item/device/pda/afterattack(atom/A as mob|obj|turf|area, mob/user, proximity)
	if(!proximity) return
	switch(scanmode)

		if(3)
			if(!isnull(A.reagents))
				if(A.reagents.reagent_list.len > 0)
					var/reagents_length = A.reagents.reagent_list.len
					user << "<span class='notice'>[reagents_length] chemical agent[reagents_length > 1 ? "s" : ""] found.</span>"
					for (var/re in A.reagents.reagent_list)
						user << "<span class='notice'>\t [re]</span>"
				else
					user << "<span class='notice'>No active chemical agents found in [A].</span>"
			else
				user << "<span class='notice'>No significant chemical agents found in [A].</span>"

		if(5)
			if (istype(A, /obj/item/weapon/tank))
				var/obj/item/weapon/tank/T = A
				atmosanalyzer_scan(T.air_contents, user, T)
			else if (istype(A, /obj/machinery/portable_atmospherics))
				var/obj/machinery/portable_atmospherics/PA = A
				atmosanalyzer_scan(PA.air_contents, user, PA)
			else if (istype(A, /obj/machinery/atmospherics/pipe))
				var/obj/machinery/atmospherics/pipe/P = A
				atmosanalyzer_scan(P.parent.air, user, P)
			else if (istype(A, /obj/machinery/power/rad_collector))
				var/obj/machinery/power/rad_collector/RC = A
				if(RC.loaded_tank)
					atmosanalyzer_scan(RC.loaded_tank.air_contents, user, RC)
			else if (istype(A, /obj/item/weapon/flamethrower))
				var/obj/item/weapon/flamethrower/F = A
				if(F.ptank)
					atmosanalyzer_scan(F.ptank.air_contents, user, F)

	if (!scanmode && istype(A, /obj/item/weapon/paper) && owner)
		var/obj/item/weapon/paper/PP = A
		if (!PP.info)
			user << "<span class='warning'>Unable to scan! Paper is blank.</span>"
			return
		notehtml = PP.info
		note = replacetext(notehtml, "<BR>", "\[br\]")
		note = replacetext(note, "<li>", "\[*\]")
		note = replacetext(note, "<ul>", "\[list\]")
		note = replacetext(note, "</ul>", "\[/list\]")
		note = html_encode(note)
		notescanned = 1
		user << "<span class='notice'>Paper scanned. Saved to PDA's notekeeper.</span>" //concept of scanning paper copyright brainoblivion 2009


/obj/item/device/pda/proc/explode() //This needs tuning.
	if(!detonate) return
	var/turf/T = get_turf(src)

	if (ismob(loc))
		var/mob/M = loc
		M.show_message("<span class='userdanger'>Your [src] explodes!</span>", 1)
	else
		visible_message("<span class='danger'>[src] explodes!</span>", "<span class='warning'>You hear a loud *pop*!</span>")

	if(T)
		T.hotspot_expose(700,125)
		if(istype(cartridge, /obj/item/weapon/cartridge/syndicate))
			explosion(T, -1, 1, 3, 4)
		else
			explosion(T, -1, -1, 2, 3)
	qdel(src)
	return

/obj/item/device/pda/Destroy()
	PDAs -= src
	if(inserted_item)
		qdel(inserted_item)
		inserted_item = null
	return ..()

//AI verb and proc for sending PDA messages.

/mob/living/silicon/ai/proc/cmd_send_pdamesg(mob/user)
	var/list/names = list()
	var/list/plist = list()
	var/list/namecounts = list()

	if(user.stat == 2)
		return //won't work if dead

	if(src.aiPDA.toff)
		user << "Turn on your receiver in order to send messages."
		return

	for (var/obj/item/device/pda/P in get_viewable_pdas())
		if (P == src)
			continue
		else if (P == src.aiPDA)
			continue

		var/name = P.owner
		if (name in names)
			namecounts[name]++
			name = text("[name] ([namecounts[name]])")
		else
			names.Add(name)
			namecounts[name] = 1

		plist[text("[name]")] = P

	var/c = input(user, "Please select a PDA") as null|anything in sortList(plist)

	if (!c)
		return

	var/selected = plist[c]

	if(aicamera.aipictures.len>0)
		var/add_photo = input(user,"Do you want to attach a photo?","Photo","No") as null|anything in list("Yes","No")
		if(add_photo=="Yes")
			var/datum/picture/Pic = aicamera.selectpicture(aicamera)
			src.aiPDA.photo = Pic.fields["img"]
	src.aiPDA.create_message(src, selected)


/mob/living/silicon/ai/verb/cmd_toggle_pda_receiver()
	set category = "AI Commands"
	set name = "PDA - Toggle Sender/Receiver"
	if(usr.stat == 2)
		return //won't work if dead
	if(!isnull(aiPDA))
		aiPDA.toff = !aiPDA.toff
		usr << "<span class='notice'>PDA sender/receiver toggled [(aiPDA.toff ? "Off" : "On")]!</span>"
	else
		usr << "You do not have a PDA. You should make an issue report about this."

/mob/living/silicon/ai/verb/cmd_toggle_pda_silent()
	set category = "AI Commands"
	set name = "PDA - Toggle Ringer"
	if(usr.stat == 2)
		return //won't work if dead
	if(!isnull(aiPDA))
		//0
		aiPDA.silent = !aiPDA.silent
		usr << "<span class='notice'>PDA ringer toggled [(aiPDA.silent ? "Off" : "On")]!</span>"
	else
		usr << "You do not have a PDA. You should make an issue report about this."

/mob/living/silicon/ai/proc/cmd_show_message_log(mob/user)
	if(user.stat == 2)
		return //won't work if dead
	if(!isnull(aiPDA))
		var/HTML = "<html><head><title>AI PDA Message Log</title></head><body>[aiPDA.tnote]</body></html>"
		user << browse(HTML, "window=log;size=400x444;border=1;can_resize=1;can_close=1;can_minimize=0")
	else
		user << "You do not have a PDA. You should make an issue report about this."

//Some spare PDAs in a box
/obj/item/weapon/storage/box/PDAs
	name = "spare PDAs"
	desc = "A box of spare PDA microcomputers."
	icon = 'icons/obj/storage.dmi'
	icon_state = "pda"

/obj/item/weapon/storage/box/PDAs/New()
	..()
	new /obj/item/device/pda(src)
	new /obj/item/device/pda(src)
	new /obj/item/device/pda(src)
	new /obj/item/device/pda(src)
	new /obj/item/weapon/cartridge/head(src)

	var/newcart = pick(	/obj/item/weapon/cartridge/engineering,
						/obj/item/weapon/cartridge/security,
						/obj/item/weapon/cartridge/medical,
						/obj/item/weapon/cartridge/signal/toxins,
						/obj/item/weapon/cartridge/quartermaster)
	new newcart(src)

// Pass along the pulse to atoms in contents, largely added so pAIs are vulnerable to EMP
/obj/item/device/pda/emp_act(severity)
	for(var/atom/A in src)
		A.emp_act(severity)
	emped += 1
	spawn(200 * severity)
		emped -= 1

/proc/get_viewable_pdas()
	. = list()
	// Returns a list of PDAs which can be viewed from another PDA/message monitor.
	for(var/obj/item/device/pda/P in PDAs)
		if(!P.owner || P.toff || P.hidden) continue
		. += P
	return .
