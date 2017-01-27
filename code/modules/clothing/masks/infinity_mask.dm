/obj/item/clothing/mask/black_fox
	name = "black fox mask"
	desc = "Just black fox mask."
	icon_state = "dei_foxmask"
	icon = 'icons/obj/clothing/infinity_work.dmi'
	worn_icon = 'icons/mob/infinity_work.dmi'
	flags_inv = HIDEFACE
	flags_cover = MASKCOVERSMOUTH

/obj/item/clothing/mask/skull_smile
	name = "skull smile"
	desc = "Mask with a crazy smile."
	icon_state = "skull_smile"
	icon = 'icons/obj/clothing/infinity_work.dmi'
	worn_icon = 'icons/mob/infinity_work.dmi'
	flags_cover = MASKCOVERSMOUTH

/obj/item/clothing/mask/fawkes
	name = "Guy Fawkes mask"
	desc = "A mask designed to help you remember a specific date."
	icon = 'icons/obj/clothing/infinity_work.dmi'
	worn_icon = 'icons/mob/infinity_work.dmi'
	icon_state = "fawkes"
	item_state = "fawkes"
	flags_inv = HIDEFACE
	flags_cover = MASKCOVERSMOUTH
	w_class = 2

/obj/item/clothing/mask/rubbermask
	name = "Dallas mask"
	desc = "That's a some old mask with flag of acient destroyed country. Looks like a clown mask, but more creepy. It smells a bills,blood and gunpowder. Officers for some reason are afraid of it."
	icon = 'icons/obj/clothing/infinity_work.dmi'
	worn_icon = 'icons/mob/infinity_work.dmi'
	icon_state = "rubbermask"
	item_state = "rubbermask"
	flags_inv = HIDEFACE
	flags_cover = MASKCOVERSMOUTH
	w_class = 2

/obj/item/clothing/mask/gas/mercenaries
	name = "mercenaries gas mask"
	desc = "�������&#255; ����� � ������������ ���������� �������. �����&#255; ������� ���������� ������� �������� �� ��, ��� ��������� ��� ���-�� ��� ������ ���������� ����... �� �������� ������� �&#255;��� ����� ������� 'Umbrella Corporation'."
	icon = 'icons/obj/clothing/infinity_work.dmi'
	worn_icon = 'icons/mob/infinity_work.dmi'
	icon_state = "gas_alt"
	flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_inv = HIDEEARS|HIDEFACIALHAIR
	armor = list(melee = 15, bullet = 10, laser = 0, energy = 0, bomb = 20, bio = 100, rad = 0, fire = 40, acid = 60)
	item_state = "gas_alt"
	gas_transfer_coefficient = 0.02
	permeability_coefficient = 0.01
	flags_cover = MASKCOVERSMOUTH
	resistance_flags = FIRE_PROOF

/obj/item/clothing/mask/gas/sechailer/swat/syndicate
	name = "syndicate mask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "syndicate"
	strip_delay = 60
	aggressiveness = 1

/obj/item/clothing/mask/gas/sechailer/swat/syndicate/ui_action_click(mob/user, action)
	if(istype(action, /datum/action/item_action/halt))
		shalt()

/obj/item/clothing/mask/gas/sechailer/swat/syndicate/emag_act(mob/user as mob)
	if(safety)
		safety = FALSE
		user << "<span class='warning'>You silently fry [src]'s vocal circuit with the cryptographic sequencer."
	else
		return

/obj/item/clothing/mask/gas/sechailer/swat/syndicate/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/screwdriver))
		switch(aggressiveness)
			if(1)
				user << "<span class='notice'>�� ������� ����� ��������.</span>"
				aggressiveness = 2
			if(2)
				user << "<span class='notice'>�� ������� ����� ������� � ������.</span>"
				aggressiveness = 1

/obj/item/clothing/mask/gas/sechailer/swat/syndicate/verb/shalt()
	set category = "Object"
	set name = "HALT"
	set src in usr
	if(!isliving(usr))
		return
	if(!can_use(usr))
		return
	if(broken_hailer)
		usr << "<span class='warning'>C������ ���������&#255; ����� ����������.</span>"
		return

	var/phrase = 0	//selects which phrase to use
	var/phrase_text = null

	if(cooldown < world.time - 30) // A cooldown, to stop people being jerks
		recent_uses++
		if(cooldown_special < world.time - 180) //A better cooldown that burns jerks
			recent_uses = initial(recent_uses)

		switch(recent_uses)
			if(5)
				usr << "<span class='warning'>����� ��������� ��-�� ������� ������������&#255;.</span>"
			if(6)
				usr << "<span class='userdanger'>����� ��������� �� �������� �����&#255;! ����� ���������� ������������ ����������.</span>"
			if(7) //overload
				broken_hailer = 1
				usr << "<span class='userdanger'>�����-��������� ������������ ��������� ��-�� ���������...</span>"
				return

		switch(aggressiveness)
			if(1)
				phrase = rand(1,8) //��� ������ ������� ������ ����� ������������� ������� �������.
			if(2)
				phrase = rand(9,18) //��� ������ ������� ������ ����� ������������� ��������.

		if(!safety)
			phrase_text = "FUCK YOUR CUNT YOU SHIT EATING COCKSTORM AND EAT A DONG FUCKING ASS RAMMING SHIT FUCK EAT PENISES IN YOUR FUCK FACE AND SHIT OUT ABORTIONS OF FUCK AND POO AND SHIT IN YOUR ASS YOU COCK FUCK SHIT MONKEY FUCK ASS WANKER FROM THE DEPTHS OF SHIT."
		else

			switch(phrase)
				if(1)	//������ � �����
					phrase_text = "����� � ���, ���� �����!"
				if(2)
					phrase_text = "���� �� ������, ���� ����� ������!"
				if(3)
					phrase_text = "����� � ��� ��� � �� ���� �� �������!"
				if(4)
					phrase_text = "��������, ������!"
				if(5)
					phrase_text = "��-�� �� ������!"
				if(6)
					phrase_text = "�� ���, ����!!"
				if(7)
					phrase_text = "������������� ����������!"
				if(8)
					phrase_text = "������ ������, ������ � ���!"
				if(9)	//��������
					phrase_text = "�����, ����� ����!"
				if(10)
					phrase_text = "�٨ ����!"
				if(11)
					phrase_text = "�� � ������ �������, ��������!"
				if(12)
					phrase_text = "���� �� ���� ������!"
				if(13)
					phrase_text = "���� �������, Ϩ�!"
				if(14)
					phrase_text = "�����, ���!"
				if(15)
					phrase_text = "�� ������� ������ �������, � �� �����������!"
				if(16)
					phrase_text = "�� ����� ������ ������ �������� ������!"
				if(17)
					phrase_text = "������� ���� ������!"
				if(18)
					phrase_text = "�������� � ������!"

		usr.audible_message("[usr]'s Compli-o-Nator: <font color='red' size='3'><b>[phrase_text]</b></font>")
		playsound(src.loc, "sound/items/megaphone.ogg", 100, 0, 4)
		cooldown = world.time
		cooldown_special = world.time
