/mob/living/carbon/human/examine(mob/user)
//this is very slightly better than it was because you can use it more places. still can't do \his[src] though.
	var/t_He = p_they(TRUE)
	var/t_His = p_their(TRUE)
	var/t_his = p_their()
	var/t_him = p_them()
	var/t_has = p_have()
	var/t_is = p_are()
	// ������� ���������! ~bear1ake
	var/e_1	= p_e_1()
	var/e_2	= p_e_2()
	var/e_3	= p_e_3()
	var/e_4	= p_e_4()
	var/e_5 = p_e_5()

	var/list/obscured = check_obscured_slots()
	var/skipface = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))

	var/msg = "<span class='info'>*---------*\n��� <EM>[src.name]</EM>!\n"

	//uniform
	if(w_uniform && !(slot_w_uniform in obscured))
		//Ties
		var/tie_msg
		if(istype(w_uniform,/obj/item/clothing/under))
			var/obj/item/clothing/under/U = w_uniform
			if(U.hastie)
				tie_msg += " � \icon[U.hastie] [U.hastie]"

		if(w_uniform.blood_DNA)
			msg += "<span class='warning'>[t_He] ����� \icon[w_uniform] [w_uniform.gender==PLURAL?"some":"a"] ������������ [w_uniform.name][tie_msg]!</span>\n"
		else
			msg += "[t_He] ����� \icon[w_uniform] \ [w_uniform][tie_msg].\n"

	//head
	if(head)
		if(head.blood_DNA)
			msg += "<span class='warning'>[t_He] ����� \icon[head] [head.gender==PLURAL?"some":"a"] ������������ [head.name] �� ������!</span>\n"
		else
			msg += "[t_He] ����� \icon[head] [head]\n"

	//suit/armor
	if(wear_suit)
		if(wear_suit.blood_DNA)
			msg += "<span class='warning'>[t_He] ����� \icon[wear_suit] [wear_suit.gender==PLURAL?"some":"a"] ������������� [wear_suit.name]!</span>\n"
		else
			msg += "[t_He] ����� \icon[wear_suit] [wear_suit].\n"

		//suit/armor storage
		if(s_store)
			if(s_store.blood_DNA)
				msg += "<span class='warning'>[t_He] ����� \icon[s_store] [s_store.gender==PLURAL?"some":"a"] ������������ [s_store.name] �� [wear_suit.name]!</span>\n"
			else
				msg += "[t_He] ����� \icon[s_store] [s_store] �� [wear_suit.name].\n"

	//back
	if(back)
		if(back.blood_DNA)
			msg += "<span class='warning'>[t_He] ����� \icon[back] ������������[back.gender==PLURAL?"�":"�"] [back] �� �����.</span>\n"
		else
			msg += "[t_He] ����� \icon[back] [back] �� �����.\n"

	//Hands
	for(var/obj/item/I in held_items)
		if(!(I.flags & ABSTRACT))
			if(I.blood_DNA)
				msg += "<span class='warning'>[t_He] ������ \icon[I] ������������[I.gender==PLURAL?"�":"�"] [I.name] �� [t_his] [get_held_index_name(get_held_index_of_item(I))]!</span>\n"
			else
				msg += "[t_He] ������ \icon[I] [I] �� [t_his] [get_held_index_name(get_held_index_of_item(I))].\n"

	//gloves
	if(gloves && !(slot_gloves in obscured))
		if(gloves.blood_DNA)
			msg += "<span class='warning'>[t_He] �����\icon[gloves] [gloves.gender==PLURAL?"some":"a"] ������������ [gloves.name]</span>\n"
		else
			msg += "[t_He] ����� \icon[gloves] [gloves] \n"
	else if(blood_DNA)
		var/hand_number = get_num_arms()
		if(hand_number)
			msg += "<span class='warning'>[t_him] ���[hand_number > 1 ? "�" : "�"] � �����!</span>\n"

	//handcuffed?

	//handcuffed?
	if(handcuffed)
		if(istype(handcuffed, /obj/item/weapon/restraints/handcuffs/cable))
			msg += "<span class='warning'>[t_He] \icon[handcuffed] ��&#255;��� � ������� �����&#255;</span>\n"
		else
			msg += "<span class='warning'>[t_He] \icon[handcuffed] � ����������!</span>\n"

	//belt
	if(belt)
		if(belt.blood_DNA)
			msg += "<span class='warning'>[t_He] ����� \icon[belt] [belt.gender==PLURAL?"some":"a"] ������������ [belt.name]</span>\n"
		else
			msg += "[t_He] ����� \icon[belt] \ [belt]\n"

	//shoes
	if(shoes && !(slot_shoes in obscured))
		if(shoes.blood_DNA)
			msg += "<span class='warning'>[t_He] ����� \icon[shoes] [shoes.gender==PLURAL?"some":"a"] ������������ [shoes.name]</span>\n"
		else
			msg += "[t_He] ����� \icon[shoes] \ [shoes]\n"

	//mask
	if(wear_mask && !(slot_wear_mask in obscured))
		if(wear_mask.blood_DNA)
			msg += "<span class='warning'>[t_He] �����\icon[wear_mask] [wear_mask.gender==PLURAL?"some":"a"] ������������ [wear_mask.name] </span>\n"
		else
			msg += "[t_He] �����\icon[wear_mask] [wear_mask]\n"

	if (wear_neck && !(slot_neck in obscured))
		msg += "[t_He] [t_is] wearing \icon[src.wear_neck] \a [src.wear_neck] around [t_his] neck.\n"

	//eyes
	if(glasses && !(slot_glasses in obscured))
		if(glasses.blood_DNA)
			msg += "<span class='warning'>[t_He] �����\icon[glasses] [glasses.gender==PLURAL?"some":"a"] ������������ [glasses]</span>\n"
		else
			msg += "[t_He] ����� \icon[glasses] [glasses]\n"

	//ears
	if(ears && !(slot_ears in obscured))
		msg += "[t_He] ����� �� ���  \icon[ears] [ears] \n"

	//ID
	if(wear_id)
		msg += "[t_He] �����  \icon[wear_id] \ [wear_id].\n"
	//Jitters


	switch(jitteriness)
		if(300 to INFINITY)
			msg += "<span class='warning'><B>[t_He] ����� ������ ������!</B></span>\n"
		if(200 to 300)
			msg += "<span class='warning'>[t_He] ������ ������.</span>\n"
		if(100 to 200)
			msg += "<span class='warning'>[t_He] ����-���� ����������c&#255;.</span>\n"


	var/appears_dead = 0
	if(stat == DEAD || (status_flags & FAKEDEATH))
		appears_dead = 1
		if(getorgan(/obj/item/organ/brain))//Only perform these checks if there is no brain
			if(suiciding)
				msg += "<span class='warning'>[t_He], ������&#255;, ��������[e_1] ������������. �������� ����������.</span>\n"
			if(hellbound)
				msg += "<span class='warning'>[t_His] soul seems to have been ripped out of [t_his] body.  Revival is impossible.</span>\n"
			msg += "<span class='deadsay'>[t_He] ������[e_3] � �������������[e_2]; [t_He] �� ����� ��������� �����"
			if(!key)
				var/foundghost = 0
				if(mind)
					for(var/mob/dead/observer/G in player_list)
						if(G.mind == mind)
							foundghost = 1
							if (G.can_reenter_corpse == 0)
								foundghost = 0
							break
				if(!foundghost)
					msg += " � [t_his] ���� ������"
			msg += "...</span>\n"
		else if(get_bodypart("head")) //Brain is gone, doesn't matter if they are AFK or present. Check for head first tho. Decapitation has similar message.
			msg += "<span class='deadsay'>������&#255;, [t_his] ���� ������...</span>\n"

	var/temp = getBruteLoss() //no need to calculate each of these twice

	msg += "<span class='warning'>"

	var/list/missing = list("head", "chest", "l_arm", "r_arm", "l_leg", "r_leg")
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		missing -= BP.body_zone
		for(var/obj/item/I in BP.embedded_objects)
			msg += "<B>[t_He] [t_has] \icon[I] [I], �����&#255;���� � [t_his] [BP.name]!</B>\n"

	//stores missing limbs
	var/l_limbs_missing = 0
	var/r_limbs_missing = 0
	for(var/t in missing)
		if(t=="head")
			msg += "<span class='deadsay'><B>[t_His] [parse_zone(t)] is missing!</B><span class='warning'>\n"
			continue
		if(t == "l_arm" || t == "l_leg")
			l_limbs_missing++
		else if(t == "r_arm" || t == "r_leg")
			r_limbs_missing++

		msg += "<B>[capitalize(t_his)] [parse_zone(t)] �����������!!</B>\n"

	var/rus_verb = ""
	switch(gender)
		if(MALE)
			rus_verb = "���"
		if(FEMALE)
			rus_verb = "����"
		if(PLURAL || NEUTER)
			rus_verb = "����"

	if(l_limbs_missing >= 2 && r_limbs_missing == 0)
		msg += "[t_He] [rus_verb]"
//	else if(l_limbs_missing || r_limbs_missing)
	//	msg += "[capitalize(t_him)] ����-�� �� �������..."

	if(temp)
		if(temp < 30)
			msg += "[t_He] [t_has] �������������� ����������&#255;.\n"
		else
			msg += "<B>[t_He] [t_has] ������� ����������&#255;!</B>\n"

	temp = getFireLoss()
	if(temp)
		if(temp < 30)
			msg += "[t_He] [t_has] �������������� �����.\n"
		else
			msg += "<B>[t_He] [t_has] ������� �����!</B>\n"

	temp = getCloneLoss()
	if(temp)
		if(temp < 30)
			msg += "[t_He] [t_has] �������������� ��������� ����������&#255;.\n"
		else
			msg += "<B>[t_He] [t_has] ������� ��������� ����������&#255;.</B>\n"


	if(fire_stacks > 0)
		msg += "[t_He] � ���-�� �����������.\n"
	if(fire_stacks < 0)
		msg += "[t_He] ����&#255;��� ������� �������[e_4].\n"


	if(pulledby && pulledby.grab_state)
		msg += "[t_his] ���������� [pulledby].\n"

	if(nutrition < NUTRITION_LEVEL_STARVING - 50)
		msg += "[t_He] ������ ���������!\n"
	else if(nutrition >= NUTRITION_LEVEL_FAT)
		if(user.nutrition < NUTRITION_LEVEL_STARVING - 50)
			msg += "[t_He] ����[e_2] � ������ ����&#255;�� - ��� ������&#255; ��������&#255; ������, ������&#255; ������.\n"
		else
			msg += "[t_He] ������� ��������[e_1].\n"

	if(blood_volume < BLOOD_VOLUME_SAFE)
		msg += "[t_He] ���������[e_1].\n"

	if(bleedsuppress)
		msg += "[t_He] �����&#255;���[e_1] ���-��.\n"
	else if(bleed_rate)
		if(reagents.has_reagent("heparin"))
			msg += "<b>[t_He] ������� ����������!</b>\n"
		else
			msg += "<B>[t_He] ����������!</B>\n"

	if(reagents.has_reagent("teslium"))
		msg += "[t_He] ��������� ������ ������� ��������!\n"

	if(islist(stun_absorption))
		for(var/i in stun_absorption)
			if(stun_absorption[i]["end_time"] > world.time && stun_absorption[i]["examine_message"])
				msg += "[t_He] [t_is][stun_absorption[i]["examine_message"]]\n"

	if(drunkenness && !skipface && !appears_dead) //Drunkenness
		switch(drunkenness)
			if(11 to 21)
				msg += "[t_He] �������� ��&#255;�[e_1].\n"
			if(21.01 to 41) //.01s are used in case drunkenness ends up to be a small decimal
				msg += "[t_He] ������� ��&#255;�[e_1].\n"
			if(41.01 to 51)
				msg += "[t_He] ��&#255;�[e_1] � �[t_his] ������� ������ ��������.\n"
			if(51.01 to 61)
				msg += "[t_He] ������ ��&#255;�[e_1] � [t_his] �������&#255; ��&#255;���, [t_his] ������� ������ ������ ���������.\n"
			if(61.01 to 91)
				msg += "[t_He] �����[e_5] � ����.\n"
			if(91.01 to INFINITY)
				msg += "[t_He] ��������� ��&#255;�[e_1], ��� ��� ����� �� �����. �������� [t_him]!\n"

	msg += "</span>"

	if(!appears_dead)
		if(stat == UNCONSCIOUS)
			msg += "[t_He] �� ��������� �� ���, ��� �������� [t_his] �, ������, �����[e_1].\n"
		else if(getBrainLoss() >= 60)
			msg += "[t_He] [t_has] ������ ��������� �� [t_his] ����.\n"

		if(getorgan(/obj/item/organ/brain))
			if(istype(src,/mob/living/carbon/human/interactive))
				var/mob/living/carbon/human/interactive/auto = src
				if(auto.showexaminetext)
					msg += "<span class='deadsay'>[t_He], ������, ������ ������������, [t_his] ����� ���������� � [t_his] ��� ������ �������.</span>\n"
				if(auto.debugexamine)
					var/dodebug = auto.doing2string(auto.doing)
					var/interestdebug = auto.interest2string(auto.interest)
					msg += "<span class='deadsay'>[t_He] [t_is] appears to be [interestdebug] and [dodebug].</span>\n"
			else if(!key)
				msg += "<span class='deadsay'>[t_He] �������� ����������. ������� ����� � �������� ������� �������� [t_his]. �������� ��&#255;� �� �������.</span>\n"
			else if(!client)
				msg += "[t_He] � ������...\n"

		if(digitalcamo)
			msg += "[t_He] ������� ����� ����� ������ � �������������� �������.\n"

	temp = getFireLoss() + getBruteLoss()
	if(!skipface && temp<80 && !(disabilities & HUSK))
		if(visual_age < AGE_MAX-10)
			msg += "[t_He] ����&#255;��� �� [visual_age-2]-[visual_age+2] ���.\n"
		else
			msg += "�� �� ������ ���������� [t_his] �������.\n"

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/cyberimp/eyes/hud/CIH = H.getorgan(/obj/item/organ/cyberimp/eyes/hud)
		if(istype(H.glasses, /obj/item/clothing/glasses/hud) || CIH)
			var/perpname = get_face_name(get_id_name(""))
			if(perpname)
				var/datum/data/record/R = find_record("name", perpname, data_core.general)
				if(R)
					msg += "<span class='deptradio'>Rank:</span> [R.fields["rank"]]<br>"
					msg += "<a href='?src=\ref[src];hud=1;photo_front=1'>\[Front photo\]</a> "
					msg += "<a href='?src=\ref[src];hud=1;photo_side=1'>\[Side photo\]</a><br>"
				if(istype(H.glasses, /obj/item/clothing/glasses/hud/health) || istype(CIH,/obj/item/organ/cyberimp/eyes/hud/medical))
					var/cyberimp_detect
					for(var/obj/item/organ/cyberimp/CI in internal_organs)
						if(CI.status == ORGAN_ROBOTIC)
							cyberimp_detect += "[name] is modified with a [CI.name].<br>"
					if(cyberimp_detect)
						msg += "Detected cybernetic modifications:<br>"
						msg += cyberimp_detect
					if(R)
						var/health_r = R.fields["p_stat"]
						msg += "<a href='?src=\ref[src];hud=m;p_stat=1'>\[[health_r]\]</a>"
						health_r = R.fields["m_stat"]
						msg += "<a href='?src=\ref[src];hud=m;m_stat=1'>\[[health_r]\]</a><br>"
					R = find_record("name", perpname, data_core.medical)
					if(R)
						msg += "<a href='?src=\ref[src];hud=m;evaluation=1'>\[Medical evaluation\]</a><br>"


				if(istype(H.glasses, /obj/item/clothing/glasses/hud/security) || istype(CIH,/obj/item/organ/cyberimp/eyes/hud/security))
					if(!user.stat && user != src)
					//|| !user.canmove || user.restrained()) Fluff: Sechuds have eye-tracking technology and sets 'arrest' to people that the wearer looks and blinks at.
						var/criminal = "None"

						R = find_record("name", perpname, data_core.security)
						if(R)
							criminal = R.fields["criminal"]

						msg += "<span class='deptradio'>Criminal status:</span> <a href='?src=\ref[src];hud=s;status=1'>\[[criminal]\]</a>\n"
						msg += "<span class='deptradio'>Security record:</span> <a href='?src=\ref[src];hud=s;view=1'>\[View\]</a> "
						msg += "<a href='?src=\ref[src];hud=s;add_crime=1'>\[Add crime\]</a> "
						msg += "<a href='?src=\ref[src];hud=s;view_comment=1'>\[View comment log\]</a> "
						msg += "<a href='?src=\ref[src];hud=s;add_comment=1'>\[Add comment\]</a>\n"

	if(print_flavor_text())
		msg += "[print_flavor_text()]\n"

	msg += "*---------*</span>"

	user << msg
