/obj/item/weapon/implant/mindshield
	name = "loyalty implant"
	desc = "God bless Nanotrasen!"
	icon_state = "loyal"
	origin_tech = "materials=2;biotech=4;programming=4"
	activated = 0

/obj/item/weapon/implant/mindshield/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Nanotrasen Employee Management Implant<BR>
				<b>Life:</b> Ten years.<BR>
				<b>Important Notes:</b> Personnel injected with this device tend to be much more loyal to the company.<BR>
				<HR>
				<b>Implant Details:</b><BR>
				<b>Function:</b> Contains a small pod of nanobots that protects the host's mental functions from manipulation.<BR>
				<b>Special Features:</b> Will prevent and cure most forms of brainwashing.<BR>
				<b>Integrity:</b> Implant will last so long as the nanobots are inside the bloodstream."}
	return dat

/obj/screen/alert/loyalty_imp
	name = "loyalty implanted"
	desc = "� �������� ��&#1103;������� � �����������! ����� ����������!"
	icon = 'icons/mob/alert_infinity.dmi'
	icon_state = "loyal"

/*/obj/item/weapon/implant/mindshield/activate(cause)
	if(!cause || !imp_in)
		return 0
	if(cause == "action_button" && alert(imp_in, "�� ������������� ������ ������, ��� ������ ���� �������?", "�������������", "��", "���") != "��")
		return 0
	imp_in << "<span class='notice'>� �������� ��&#255;������� � �����������! ����� ����������!</span>" */

/obj/item/weapon/implant/mindshield/implant(mob/living/target, mob/user, silent = 0)
	if(..())
		if((target.mind in (ticker.mode.changelings | ticker.mode.abductors | ticker.mode.cult)) || target.isntloyal())
			if(!silent)
				target.visible_message("<span class='warning'>[target] ��������&#255;, ���������&#255;&#255;�� ��������!</span>", "<span class='warning'>�� ����������, ��� ����������� �������&#255; ��������� ���� ���� ����! ���������&#255;�����!</span>")
			removed(target, 1)
			qdel(src)
			return 0
		if(target.mind)
			target.mind.remove_all_antag_light()
		if(!silent)
			target << "<span class='notice'>�� ���������� ������� ��&#255;������� � �����������...</span>"
		target.throw_alert("loyalty_implanted", /obj/screen/alert/loyalty_imp)
		return 1
	return 0

/obj/item/weapon/implant/mindshield/removed(mob/target, silent = 0, special = 0)
	if(..())
		if(target.stat != DEAD && !silent)
			target << "<span class='boldnotice'>�� ����������, ��� ��&#255;������� � ����������� �������� ��� ������ � ����� ������...</span>"
		target.clear_alert("loyalty_implanted")
		return 1
	return 0

/obj/item/weapon/implanter/mindshield
	name = "implanter (loyalty)"

/obj/item/weapon/implanter/mindshield/New()
	imp = new /obj/item/weapon/implant/mindshield(src)
	..()
	update_icon()


/obj/item/weapon/implantcase/mindshield
	name = "implant case - 'Loyalty'"
	desc = "A glass case containing a loyalty implant."

/obj/item/weapon/implantcase/mindshield/New()
	imp = new /obj/item/weapon/implant/mindshield(src)
	..()
