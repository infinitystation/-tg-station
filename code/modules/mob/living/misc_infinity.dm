/mob/living/proc/Shit()
	if(stat != DEAD || stat != UNCONSCIOUS)
		need_to_shit = max(0, need_to_shit - rand(0, 150))
		AdjustStunned(3)
		var/turf/pos = get_turf(src)
		pos.add_shit_floor(src)
		playsound(pos, 'sound/emotions/shit.ogg', 50, 1)
	else
		src << "�� ������ � �� �������� ������ �������&#255;���&#255;."
		return 0

/mob/living/carbon/human/verb/set_flavor()
	set name = "Set Flavor Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	if(jobban_isbanned(usr, "appearance"))
		return

	update_flavor_text()

/datum/emote/living/carbon/shit
	key = "shit"
	key_third_person = "�������&#255;���&#255;."
	message = "�������&#255;���&#255;."
	message_mime = "�������&#255;���&#255;."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/shit/run_emote(mob/living/user, params = null, type_override = null)
	//we need to shit? no
	if(user.need_to_shit < 70)
		user << "����� �������&#255;��&#255;"
		return

	//we need to shit?
	if((user.need_to_shit > 100) && (user.need_to_shit < SHIT_LEVEL_MAX))
		for(var/obj/structure/toilet/T in view(0, src))	//checking toilets
			if(T.shit > 0 || T.w_items > 0)
				user.Shit()
				. = ..()
				return
			else
				user.need_to_shit = max(0, user.need_to_shit - rand(0, 150))
				T.open = 1
				T.shit++
				T.update_icon()
				user << "�� �������� �����, �� �������� ����� �� �����. Object -> Wash Off."
				return
		user << "����� ����� ��������� ������"
		return
	user.Shit()
	. = ..()