//��� ��������� ����: ����� ��������� ���������� �� ����� infi_human_parts_greyscale.dmi � human_parts_greyscale.dmi (�) Terror4000rus
//����� ��������, ��� �� �������� ������, ��� ����� ���������� �� ����� ��������.

/datum/species/tajaran // Tajaran are a humanoid race possesing cat-like features.
	name = "Tajaran"
	id = "tajaran"
	say_mod = "��������"
	default_color = "FFFFF"
	species_traits = list(EYECOLOR,MUTCOLORS) //LIPS �� ����������. ������ ���� �������, ��� � ��������.
	mutant_organs = list(/obj/item/organ/tongue/tajaran)
	mutant_bodyparts = list("tail_tajaran", "ears_tajaran", "tajaran_hair")
	default_features = list("mcolor" = "FFF", "ears_tajaran" = "Default", "tail_tajaran" = "Default", "tajaran_hair" = "Straight")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human
	skinned_type = /obj/item/stack/sheet/animalhide/generic

/datum/species/tajaran/qualifies_for_rank(rank, list/features)
	if(rank in command_positions)
		return 0
	return 1

/obj/item/organ/tongue/tajaran
	say_mod = "��������"

/obj/item/organ/tongue/tajaran/TongueSpeech(var/message)
	var/regex/tajaran_rrr = new("�+", "g")
	var/regex/tajaran_rRR = new("�+", "g")
	var/regex/tajaran_rAr = new("r+", "g")
	var/regex/tajaran_rAR = new("R+", "g")
	if(copytext(message, 1, 2) != "*")
//		var/begin = get_custom_quote(message)
//		var/quote = copytext(message, 1, begin)
//		message = copytext(message, begin)
		message = tajaran_rrr.Replace(message, "���")
		message = tajaran_rRR.Replace(message, "���")
		message = tajaran_rAr.Replace(message, "rrr")
		message = tajaran_rAR.Replace(message, "RRR")
//		message = quote + message
	return message