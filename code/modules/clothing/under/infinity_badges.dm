/*
	Badges are worn on the belt or neck, and can be used to show that the holder is an authorized
	Security agent - the user details can be imprinted on holobadges with a Security-access ID card,
	or they can be emagged to accept any ID for use in disguises.
	Ported from BayStation 12
*/

/obj/item/clothing/tie/badge
	name = "detective's badge"
	desc = "A corporate security badge, made from gold and set on false leather."
	icon = 'icons/obj/infinity_object.dmi'
	worn_icon = 'icons/mob/infinity_work.dmi'
	icon_state = "badge"

	var/stored_name
	var/badge_string = "Corporate Security"

/obj/item/clothing/tie/badge/old
	name = "faded badge"
	desc = "A faded badge, backed with leather. It bears the emblem of the Forensic division."
	icon_state = "badge_round"
	item_color = "badge_round"

/obj/item/clothing/tie/badge/proc/set_name(var/new_name)
	stored_name = new_name
	name = "[initial(name)] ([stored_name])"

/obj/item/clothing/tie/badge/attack_self(mob/user as mob)

	if(!stored_name)
		user << "You polish your badge fondly, shining up the surface."
		set_name(user.real_name)
		return

	if(isliving(user))
		if(stored_name)
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [stored_name], [badge_string].</span>","<span class='notice'>You display your [src.name].\nIt reads: [stored_name], [badge_string].</span>")
		else
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [badge_string].</span>","<span class='notice'>You display your [src.name]. It reads: [badge_string].</span>")

/obj/item/clothing/tie/badge/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message("<span class='danger'>[user] invades [M]'s personal space, thrusting [src] into their face insistently.</span>","<span class='danger'>You invade [M]'s personal space, thrusting [src] into their face insistently.</span>")

//Holobadges.
/obj/item/clothing/tie/badge/holo
	name = "holobadge"
	desc = "This glowing blue badge marks the holder as a member of corporate security."
	icon_state = "holobadge"

/*/obj/item/clothing/tie/badge/holo/cord
	icon_state = "holobadge-cord"
	slot_flags = SLOT_NECK

/obj/item/clothing/tie/badge/holo/cord/attach(obj/item/clothing/under/U, user)
	return*/

/obj/item/clothing/tie/badge/holo/attack_self(mob/user as mob)
	if(!stored_name)
		user << "Waving around a holobadge before swiping an ID would be pretty pointless."
		return
	return ..()

/obj/item/clothing/tie/badge/holo/emag_act(var/remaining_charges, var/mob/user)
	if (obj_flags & EMAGGED)
		user << "<span class='danger'>\The [src] is already cracked.</span>"
		return
	else
		obj_flags |= EMAGGED
		user << "<span class='danger'>You crack the holobadge security checks.</span>"
		return 1

/obj/item/clothing/tie/badge/holo/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/card/id) || istype(O, /obj/item/pda))

		var/obj/item/card/id/id_card = null

		if(istype(O, /obj/item/card/id))
			id_card = O
		else
			var/obj/item/pda/pda = O
			id_card = pda.id

		if(ACCESS_SECURITY in id_card.access || obj_flags & EMAGGED)
			user << "You imprint your ID details onto the badge."
			set_name(user.real_name)
		else
			user << "[src] rejects your insufficient access rights."
		return
	..()

/obj/item/storage/box/holobadge
	name = "holobadge box"
	desc = "A box claiming to contain holobadges."
	New()
		new /obj/item/clothing/tie/badge/holo(src)
		new /obj/item/clothing/tie/badge/holo(src)
		new /obj/item/clothing/tie/badge/holo(src)
		new /obj/item/clothing/tie/badge/holo(src)
		/*new /obj/item/clothing/tie/badge/holo/cord(src)
		new /obj/item/clothing/tie/badge/holo/cord(src)*/
		..()
		return


/obj/item/clothing/tie/badge/warden
	name = "warden's badge"
	desc = "A silver corporate security badge. Stamped with the words 'Brig Officer.'"
	icon_state = "silverbadge"
	item_color = "silverbadge"

/obj/item/clothing/tie/badge/hos
	name = "commander's badge"
	desc = "An immaculately polished gold security badge. Labeled 'Commander.'"
	icon_state = "goldbadge"
	item_color = "goldbadge"

/obj/item/clothing/tie/badge/marshal
	name = "marshal's badge"
	desc = "A leather-backed gold badge displaying the crest of the Colonial Marshals."
	icon_state = "marshalbadge"
	item_color = "marshalbadge"
	badge_string = "Colonial Marshal Bureau"