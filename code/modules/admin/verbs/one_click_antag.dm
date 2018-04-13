/client/proc/one_click_antag()
	set name = "Create Antagonist"
	set desc = "Auto-create an antagonist of your choice"
	set category = "Admin"

	if(holder)
		holder.one_click_antag()
	return


/datum/admins/proc/one_click_antag()

	var/dat = {"
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=traitors'>Make Traitors</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=changelings'>Make Changelings</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=revs'>Make Revs</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=cult'>Make Cult</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=clockcult'>Make Clockwork Cult</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=blob'>Make Blob</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=wizard'>Make Wizard (Requires Ghosts)</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=nukeops'>Make Nuke Team (Requires Ghosts)</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=centcom'>Make CentCom Response Team (Requires Ghosts)</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=abductors'>Make Abductor Team (Requires Ghosts)</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=revenant'>Make Revenant (Requires Ghost)</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=crew'>Make Central Command Crew (Requires Ghost)</a><br>
		"}

	var/datum/browser/popup = new(usr, "oneclickantag", "Quick-Create Antagonist", 400, 400)
	popup.set_content(dat)
	popup.open()

/datum/admins/proc/isReadytoRumble(mob/living/carbon/human/applicant, targetrole, onstation = TRUE, conscious = TRUE)
	if(applicant.mind.special_role)
		return FALSE
	if(!(targetrole in applicant.client.prefs.be_special))
		return FALSE
	if(onstation)
		var/turf/T = get_turf(applicant)
		if(!is_station_level(T.z))
			return FALSE
	if(conscious && applicant.stat) //incase you don't care about a certain antag being unconcious when made, ie if they have selfhealing abilities.
		return FALSE
	if(!considered_alive(applicant.mind) || considered_afk(applicant.mind)) //makes sure the player isn't a zombie, brain, or just afk all together
		return FALSE
	return (!jobban_isbanned(applicant, targetrole) && !jobban_isbanned(applicant, ROLE_SYNDICATE))


/datum/admins/proc/makeTraitors()
	var/datum/game_mode/traitor/temp = new

	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		temp.restricted_jobs += temp.protected_jobs

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		temp.restricted_jobs += "Assistant"

	var/list/mob/living/carbon/human/candidates = list()
	var/mob/living/carbon/human/H = null

	for(var/mob/living/carbon/human/applicant in GLOB.player_list)
		if(isReadytoRumble(applicant, ROLE_TRAITOR, FALSE))
			if(temp.age_check(applicant.client))
				if(!(applicant.job in temp.restricted_jobs))
					candidates += applicant

	if(candidates.len)
		var/numTraitors = min(candidates.len, 3)

		for(var/i = 0, i<numTraitors, i++)
			H = pick(candidates)
			H.mind.make_Traitor()
			candidates.Remove(H)

		return 1


	return 0


/datum/admins/proc/makeChanglings()

	var/datum/game_mode/changeling/temp = new
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		temp.restricted_jobs += temp.protected_jobs

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		temp.restricted_jobs += "Assistant"

	var/list/mob/living/carbon/human/candidates = list()
	var/mob/living/carbon/human/H = null

	for(var/mob/living/carbon/human/applicant in GLOB.player_list)
		if(isReadytoRumble(applicant, ROLE_CHANGELING))
			if(temp.age_check(applicant.client))
				if(!(applicant.job in temp.restricted_jobs))
					candidates += applicant

	if(candidates.len)
		var/numChanglings = min(candidates.len, 3)

		for(var/i = 0, i<numChanglings, i++)
			H = pick(candidates)
			H.mind.make_Changling()
			candidates.Remove(H)

		return 1

	return 0

/datum/admins/proc/makeRevs()

	var/datum/game_mode/revolution/temp = new
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		temp.restricted_jobs += temp.protected_jobs

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		temp.restricted_jobs += "Assistant"

	var/list/mob/living/carbon/human/candidates = list()
	var/mob/living/carbon/human/H = null

	for(var/mob/living/carbon/human/applicant in GLOB.player_list)
		if(isReadytoRumble(applicant, ROLE_REV))
			if(temp.age_check(applicant.client))
				if(!(applicant.job in temp.restricted_jobs))
					candidates += applicant

	if(candidates.len)
		var/numRevs = min(candidates.len, 3)

		for(var/i = 0, i<numRevs, i++)
			H = pick(candidates)
			H.mind.make_Rev()
			candidates.Remove(H)
		return 1

	return 0

/datum/admins/proc/makeWizard()

	var/list/mob/dead/observer/candidates = pollGhostCandidates("Do you wish to be considered for the position of a Wizard Foundation 'diplomat'?", ROLE_WIZARD, null)

	var/mob/dead/observer/selected = pick_n_take(candidates)

	var/mob/living/carbon/human/new_character = makeBody(selected)
	new_character.mind.make_Wizard()
	return TRUE


/datum/admins/proc/makeCult()
	var/datum/game_mode/cult/temp = new
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		temp.restricted_jobs += temp.protected_jobs

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		temp.restricted_jobs += "Assistant"

	var/list/mob/living/carbon/human/candidates = list()
	var/mob/living/carbon/human/H = null

	for(var/mob/living/carbon/human/applicant in GLOB.player_list)
		if(isReadytoRumble(applicant, ROLE_CULTIST))
			if(temp.age_check(applicant.client))
				if(!(applicant.job in temp.restricted_jobs))
					candidates += applicant

	if(candidates.len)
		var/numCultists = min(candidates.len, 4)

		for(var/i = 0, i<numCultists, i++)
			H = pick(candidates)
			H.mind.make_Cultist()
			candidates.Remove(H)

		return 1

	return 0


/datum/admins/proc/makeClockCult()
	var/datum/game_mode/clockwork_cult/temp = new
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		temp.restricted_jobs += temp.protected_jobs

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		temp.restricted_jobs += "Assistant"

	var/list/mob/living/carbon/human/candidates = list()
	var/mob/living/carbon/human/H = null

	for(var/mob/living/carbon/human/applicant in GLOB.player_list)
		if(isReadytoRumble(applicant, ROLE_SERVANT_OF_RATVAR))
			if(temp.age_check(applicant.client))
				if(!(applicant.job in temp.restricted_jobs))
					candidates += applicant

	if(candidates.len)
		var/numCultists = min(candidates.len, 4)

		for(var/i = 0, i<numCultists, i++)
			H = pick(candidates)
			to_chat(H, "<span class='heavy_brass'>The world before you suddenly glows a brilliant yellow. You hear the whooshing steam and clanking cogs of a billion billion machines, and all at once \
			you see the truth. Ratvar, the Clockwork Justiciar, lies derelict and forgotten in an unseen realm, and he has selected you as one of his harbringers. You are now a servant of \
			Ratvar, and you will bring him back.</span>")
			H.playsound_local(get_turf(H), 'sound/ambience/antag/clockcultalr.ogg', 100, FALSE, pressure_affected = FALSE)
			add_servant_of_ratvar(H, TRUE)
			SSticker.mode.equip_servant(H)
			candidates.Remove(H)

		return 1

	return 0



/datum/admins/proc/makeNukeTeam()
	var/datum/game_mode/nuclear/temp = new
	var/list/mob/dead/observer/candidates = pollGhostCandidates("Do you wish to be considered for a nuke team being sent in?", ROLE_OPERATIVE, temp)
	var/list/mob/dead/observer/chosen = list()
	var/mob/dead/observer/theghost = null

	if(candidates.len)
		var/numagents = 5
		var/agentcount = 0

		for(var/i = 0, i<numagents,i++)
			shuffle_inplace(candidates) //More shuffles means more randoms
			for(var/mob/j in candidates)
				if(!j || !j.client)
					candidates.Remove(j)
					continue

				theghost = j
				candidates.Remove(theghost)
				chosen += theghost
				agentcount++
				break
		//Making sure we have atleast 3 Nuke agents, because less than that is kinda bad
		if(agentcount < 3)
			return 0

		//Let's find the spawn locations
		var/leader_chosen = FALSE
		var/datum/team/nuclear/nuke_team
		for(var/mob/c in chosen)
			var/mob/living/carbon/human/new_character=makeBody(c)
			if(!leader_chosen)
				leader_chosen = TRUE
				var/datum/antagonist/nukeop/N = new_character.mind.add_antag_datum(/datum/antagonist/nukeop/leader)
				nuke_team = N.nuke_team
			else
				new_character.mind.add_antag_datum(/datum/antagonist/nukeop,nuke_team)
		return 1
	else
		return 0





/datum/admins/proc/makeAliens()
	var/datum/round_event/ghost_role/alien_infestation/E = new(FALSE)
	E.spawncount = 3
	// TODO The fact we have to do this rather than just have events start
	// when we ask them to, is bad.
	E.processing = TRUE
	return TRUE

/datum/admins/proc/makeSpaceNinja()
	new /datum/round_event/ghost_role/ninja()
	return 1

// DEATH SQUADS
/datum/admins/proc/makeDeathsquad()
	return makeEmergencyresponseteam(/datum/ert/deathsquad)

// CENTCOM RESPONSE TEAM

/datum/admins/proc/makeERTTemplateModified(list/settings)
	. = settings
	var/datum/ert/newtemplate = settings["mainsettings"]["template"]["value"]
	if (isnull(newtemplate))
		return
	if (!ispath(newtemplate))
		newtemplate = text2path(newtemplate)
	newtemplate = new newtemplate
	.["mainsettings"]["teamsize"]["value"] = newtemplate.teamsize
	.["mainsettings"]["mission"]["value"] = newtemplate.mission
	.["mainsettings"]["polldesc"]["value"] = newtemplate.polldesc


/datum/admins/proc/equipAntagOnDummy(mob/living/carbon/human/dummy/mannequin, datum/antagonist/antag)
	for(var/I in mannequin.get_equipped_items())
		qdel(I)
	if (ispath(antag, /datum/antagonist/ert))
		var/datum/antagonist/ert/ert = antag
		mannequin.equipOutfit(initial(ert.outfit), TRUE)
	else if (ispath(antag, /datum/antagonist/official))
		mannequin.equipOutfit(/datum/outfit/centcom_official, TRUE)

/datum/admins/proc/makeERTPreviewIcon(list/settings)
	// Set up the dummy for its photoshoot
	var/mob/living/carbon/human/dummy/mannequin = generate_or_wait_for_human_dummy(DUMMY_HUMAN_SLOT_ADMIN)

	var/prefs = settings["mainsettings"]
	var/datum/ert/template = prefs["template"]["value"]
	if (isnull(template))
		return null
	if (!ispath(template))
		template = text2path(prefs["template"]["value"]) // new text2path ... doesn't compile in 511

	template = new template
	var/datum/antagonist/ert/ert = template.leader_role

	equipAntagOnDummy(mannequin, ert)

	COMPILE_OVERLAYS(mannequin)
	CHECK_TICK
	var/icon/preview_icon = icon('icons/effects/effects.dmi', "nothing")
	preview_icon.Scale(48+32, 16+32)
	CHECK_TICK
	mannequin.setDir(NORTH)
	var/icon/stamp = getFlatIcon(mannequin)
	CHECK_TICK
	preview_icon.Blend(stamp, ICON_OVERLAY, 25, 17)
	CHECK_TICK
	mannequin.setDir(WEST)
	stamp = getFlatIcon(mannequin)
	CHECK_TICK
	preview_icon.Blend(stamp, ICON_OVERLAY, 1, 9)
	CHECK_TICK
	mannequin.setDir(SOUTH)
	stamp = getFlatIcon(mannequin)
	CHECK_TICK
	preview_icon.Blend(stamp, ICON_OVERLAY, 49, 1)
	CHECK_TICK
	preview_icon.Scale(preview_icon.Width() * 2, preview_icon.Height() * 2) // Scaling here to prevent blurring in the browser.
	CHECK_TICK
	unset_busy_human_dummy(DUMMY_HUMAN_SLOT_ADMIN)
	return preview_icon

/datum/admins/proc/makeEmergencyresponseteam(var/datum/ert/ertemplate = null)
	if (ertemplate)
		ertemplate = new ertemplate
	else
		ertemplate = new /datum/ert/centcom_official

	var/list/settings = list(
		"preview_callback" = CALLBACK(src, .proc/makeERTPreviewIcon),
		"mainsettings" = list(
		"template" = list("desc" = "Template", "callback" = CALLBACK(src, .proc/makeERTTemplateModified), "type" = "datum", "path" = "/datum/ert", "subtypesonly" = TRUE, "value" = ertemplate.type),
		"teamsize" = list("desc" = "Team Size", "type" = "number", "value" = ertemplate.teamsize),
		"mission" = list("desc" = "Mission", "type" = "string", "value" = ertemplate.mission),
		"polldesc" = list("desc" = "Ghost poll description", "string" = "text", "value" = ertemplate.polldesc),
		"enforce_human" = list("desc" = "Enforce human authority", "type" = "boolean", "value" = "[(CONFIG_GET(flag/enforce_human_authority) ? "Yes" : "No")]"),
		)
	)

	var/list/prefreturn = presentpreflikepicker(usr,"Customize ERT", "Customize ERT", Button1="Ok", width = 600, StealFocus = 1,Timeout = 0, settings=settings)

	if (isnull(prefreturn))
		return FALSE

	if (prefreturn["button"] == 1)
		var/list/prefs = settings["mainsettings"]

		var/templtype = prefs["template"]["value"]
		if (!ispath(prefs["template"]["value"]))
			templtype = text2path(prefs["template"]["value"]) // new text2path ... doesn't compile in 511

		if (ertemplate.type != templtype)
			ertemplate = new templtype

		ertemplate.teamsize = prefs["teamsize"]["value"]
		ertemplate.mission = prefs["mission"]["value"]
		ertemplate.polldesc = prefs["polldesc"]["value"]
		ertemplate.enforce_human = prefs["enforce_human"]["value"] == "Yes" ? TRUE : FALSE

		var/list/mob/dead/observer/candidates = pollGhostCandidates("Do you wish to be considered for [ertemplate.polldesc] ?", "deathsquad", null)
		var/teamSpawned = FALSE

		if(candidates.len > 0)
			//Pick the (un)lucky players
			var/numagents = min(ertemplate.teamsize,candidates.len)

			//Create team
			var/datum/team/ert/ert_team = new ertemplate.team
			if(ertemplate.rename_team)
				ert_team.name = ertemplate.rename_team

			//Asign team objective
			var/datum/objective/missionobj = new
			missionobj.team = ert_team
			missionobj.explanation_text = ertemplate.mission
			missionobj.completed = TRUE
			ert_team.objectives += missionobj
			ert_team.mission = missionobj

			var/list/spawnpoints = GLOB.emergencyresponseteamspawn
			while(numagents && candidates.len)
				if (numagents > spawnpoints.len)
					numagents--
					continue // This guy's unlucky, not enough spawn points, we skip him.
				var/spawnloc = spawnpoints[numagents]
				var/mob/dead/observer/chosen_candidate = pick(candidates)
				candidates -= chosen_candidate
				if(!chosen_candidate.key)
					continue

				//Spawn the body
				var/mob/living/carbon/human/ERTOperative = new ertemplate.mobtype(spawnloc)
				chosen_candidate.client.prefs.copy_to(ERTOperative)
				ERTOperative.key = chosen_candidate.key

				if(ertemplate.enforce_human || ERTOperative.dna.species.dangerous_existence) // Don't want any exploding plasmemes
					ERTOperative.set_species(/datum/species/human)

				//Give antag datum
				var/datum/antagonist/ert/ert_antag

				if(numagents == 1)
					ert_antag = new ertemplate.leader_role
				else
					ert_antag = ertemplate.roles[WRAP(numagents,1,length(ertemplate.roles) + 1)]
					ert_antag = new ert_antag

				ERTOperative.mind.add_antag_datum(ert_antag,ert_team)
				ERTOperative.mind.assigned_role = ert_antag.name

				//Logging and cleanup
				log_game("[key_name(ERTOperative)] has been selected as an [ert_antag.name]")
				numagents--
				teamSpawned++

			if (teamSpawned)
				message_admins("[ertemplate.polldesc] has spawned with the mission: [ertemplate.mission]")

			//Open the Armory doors
			if(ertemplate.opendoors)
				for(var/obj/machinery/door/poddoor/ert/door in GLOB.airlocks)
					door.open()
					CHECK_TICK
			return TRUE
		else
			return FALSE

	return

//Abductors
/datum/admins/proc/makeAbductorTeam()
	new /datum/round_event/ghost_role/abductor
	return 1

/datum/admins/proc/makeRevenant()
	new /datum/round_event/ghost_role/revenant(TRUE, TRUE)
	return 1

/datum/admins/proc/makeWar1()
	var/alert = input("����� ������� ������� ������ ���� �� ��?", "�������� ������� �������") as null|anything in list("Green: Arrival Security", "Ember: Armed Security Squad", "Biohazard: Security With Bio-Suits", "Red: Space-like Armed Security Squad", "Delta: Special Force Squad")
	if(!alert)
		return
	switch(alert)
		if("Delta: Special Force Squad")
			alert = "Delta"
		if("Biohazard: Security With Bio-Suits")
			alert = "Bio"
		if("Red: Space-like Armed Security Squad")
			alert = "Red"
		if("Ember: Armed Security Squad")
			alert = "Ember"
		if("Green: Arrival Security")
			alert = "Green"
	var/teamsize = min(7,input("������������ ���������� ������ � ������? (����: 7)", "�������� ������ ������",4) as null|num)
	var/mission = input("�������� ������� ��� ������", "��������� ����", "�������� ��.")
	mission = sanitize_a0(mission)
	var/list/mob/dead/observer/candidates = pollCandidates("�� ������� ����� ����������� ������ �� ��� ��������� ������ ������: [alert] � �����: [mission]?", "����������� � �����", null)
	var/teamSpawned = 0

	if(candidates.len > 0)
		//Pick the (un)lucky players
		var/numagents = min(teamsize,candidates.len) //How many officers to spawn
		var/deltaalert
		var/redalert
		var/bioalert
		var/emberalert
		var/greenalert
		if (alert == "Delta")
			numagents = min(teamsize,candidates.len)
			deltaalert = 1
		if (alert == "Red")
			numagents = min(teamsize,candidates.len)
			redalert = 1
		if (alert == "Bio")
			numagents = min(teamsize,candidates.len)
			bioalert = 1
		if (alert == "Ember")
			numagents = min(teamsize,candidates.len)
			emberalert = 1
		if (alert == "Green")
			numagents = min(teamsize,candidates.len)
			greenalert = 1
		var/list/spawnpoints = GLOB.centcomsecspawn
		while(numagents && candidates.len)
			if (numagents > spawnpoints.len)
				numagents--
				continue // This guy's unlucky, not enough spawn points, we skip him.
			var/spawnloc = spawnpoints[numagents]
			var/mob/dead/observer/chosen_candidate = pick(candidates)
			candidates -= chosen_candidate
			if(!chosen_candidate.key)
				continue

			//Spawn and equip the officer
			var/mob/living/carbon/human/SAVEOperative = new(spawnloc)
			var/list/lastname = GLOB.last_names
			chosen_candidate.client.prefs.copy_to(SAVEOperative)
			var/ertname = pick(lastname)
			switch(numagents)
				if(1)
					SAVEOperative.real_name = "Sergeant [ertname]"
					SAVEOperative.equipOutfit(greenalert ? /datum/outfit/security_sergeant/green : emberalert ? /datum/outfit/security_sergeant : redalert ? /datum/outfit/security_sergeant/red : bioalert ? /datum/outfit/security_sergeant/biohazard : deltaalert ? /datum/outfit/combat : /datum/outfit/security_sergeant)
				if(2)
					SAVEOperative.real_name = "Private [ertname]"
					SAVEOperative.equipOutfit(greenalert ? /datum/outfit/security_private/green : emberalert ? /datum/outfit/security_private : redalert ? /datum/outfit/security_private/red : bioalert ? /datum/outfit/security_private/biohazard : deltaalert ? /datum/outfit/combat : /datum/outfit/security_private)
				if(3)
					SAVEOperative.real_name = "Private [ertname]"
					SAVEOperative.equipOutfit(greenalert ? /datum/outfit/security_private/green : emberalert ? /datum/outfit/security_private : redalert ? /datum/outfit/security_private/red : bioalert ? /datum/outfit/security_private/biohazard : deltaalert ? /datum/outfit/combat : /datum/outfit/security_private)
				if(4)
					SAVEOperative.real_name = "Private [ertname]"
					SAVEOperative.equipOutfit(greenalert ? /datum/outfit/security_private/green : emberalert ? /datum/outfit/security_private : redalert ? /datum/outfit/security_private/red : bioalert ? /datum/outfit/security_private/biohazard : deltaalert ? /datum/outfit/combat : /datum/outfit/security_private)
				if(5)
					SAVEOperative.real_name = "Private [ertname]"
					SAVEOperative.equipOutfit(greenalert ? /datum/outfit/security_private/green : emberalert ? /datum/outfit/security_private : redalert ? /datum/outfit/security_private/red : bioalert ? /datum/outfit/security_private/biohazard : deltaalert ? /datum/outfit/combat : /datum/outfit/security_private)
				if(6)
					SAVEOperative.real_name = "Private [ertname]"
					SAVEOperative.equipOutfit(greenalert ? /datum/outfit/security_private/green : emberalert ? /datum/outfit/security_private : redalert ? /datum/outfit/security_private/red : bioalert ? /datum/outfit/security_private/biohazard : deltaalert ? /datum/outfit/combat : /datum/outfit/security_private)
				if(7)
					SAVEOperative.real_name = "Private [ertname]"
					SAVEOperative.equipOutfit(greenalert ? /datum/outfit/security_private/green : emberalert ? /datum/outfit/security_private : redalert ? /datum/outfit/security_private/red : bioalert ? /datum/outfit/security_private/biohazard : deltaalert ? /datum/outfit/combat : /datum/outfit/security_private)
			SAVEOperative.dna.update_dna_identity()
			SAVEOperative.key = chosen_candidate.key
			SAVEOperative.mind.assigned_role = "Centcome Crew"
			SAVEOperative.faction = list("nanotrasen","neutral")

			//Assign antag status and the mission
			SSticker.mode.traitors += SAVEOperative.mind
			SAVEOperative.mind.special_role = "Centcome Crew"
			var/datum/objective/missionobj = new
			missionobj.owner = SAVEOperative.mind
			missionobj.explanation_text = mission
			missionobj.completed = 1
			SAVEOperative.mind.objectives += missionobj

			//Greet the commando
			SAVEOperative << "<B><font size=3 color=red>�� - [numagents==1?"������� ������ ������������ ��":"���� ������ ������������ ��"].</font></B>"
			var/missiondesc = "�� ���� ��������� ����������� �� ������� ������� �� � ����� ���������&#255; ������ � ������ ������� �� ���������� ���� ���������: [alert]."
			if(numagents == 1) //If Squad Leader
				missiondesc += "<BR>������������ �� �������� ������� � ��������� ��������� ������, �������. ��������� ����� ����� ����������, ���� �� ����� ��������."
			else
				missiondesc += " ������&#255;��� ���������� ��������� ������� - ��������� ���� ����� �����������."
			missiondesc += "<BR><B>���� �����&#255;</B>: [mission]"
			SAVEOperative << missiondesc

			if(config.enforce_human_authority)
				SAVEOperative.set_species(/datum/species/human)

			if(alert != "Green")
				for(var/obj/machinery/door/poddoor/crew/door in GLOB.airlocks)
					spawn(0)
						door.open()

			//Logging and cleanup
			if(numagents == 1)
				message_admins("��� ������ �������� �� �������� ��������� ����: '[alert]' � �������: '[mission]'")
			log_game("[key_name(SAVEOperative)] ��� ������ � �������� ����� ��������� ��.")
			numagents--
			teamSpawned++

		if (teamSpawned)
			return 1
		else
			return 0

	return
