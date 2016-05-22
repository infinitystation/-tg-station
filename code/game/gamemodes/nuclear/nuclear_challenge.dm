#define CHALLENGE_TELECRYSTALS 280
#define CHALLENGE_TIME_LIMIT 3000
#define CHALLENGE_MIN_PLAYERS 22
#define CHALLENGE_SHUTTLE_DELAY 15000 // 25 minutes, so the ops have at least 5 minutes before the shuttle is callable.

/obj/item/device/nuclear_challenge
	name = "Declaration of War (Challenge Mode)"
	icon_state = "gangtool-red"
	item_state = "walkietalkie"
	desc = "������ ���������� ������������ � ����� '���������� �����' �������, �� ������� �������� ���������� ��������� ������. ����� ����������, ����� ������ ������ ����� �������� �� 20 �����.  \
			����� ������ ��� ��������� �������� ������ ��������������� � ������ ���������, ������� ����� ���������� ����� ������� �������� ����������� �������� ������������� (280).  \
			������ ����������� ������ ���� ������������ �� ��������� ���� ����� ����� ������ ��������� �� ���� - � ��������� ������, ���� �������� � ���� ��������� ���������� �������� �������.  \
			��������� ����� ������� ������������� ������ � ��� ������, ���� �� ������ ���������� � ���������������� � ����� ������� ����� �����."
	var/declaring_war = 0

/obj/item/device/nuclear_challenge/attack_self(mob/living/user)
	if(declaring_war)
		return
	if(player_list.len < CHALLENGE_MIN_PLAYERS)
		user << "��������� ������ ������� ���, ����� ��������� �� �����.."
		return
	if(user.z != ZLEVEL_CENTCOM)
		user << "�� ������ ���� �� ����� ����, ����� ������������ ���."
		return

	if(world.time > CHALLENGE_TIME_LIMIT)
		user << "������� ������ ��� ���������� �����. ���� �������� �������� �������. ��� �������� ��������� �������� � ���, ��� �� ������ �� �����."
		return

	declaring_war = 1
	var/are_you_sure = alert(user, "������������������� �� ����� �������� ����� ����������� ����� ������� [station_name()]. �� ������������� ������� ������������ ����� ����� ����� ������? ", "�������� �����?", "��", "���")
	if(are_you_sure == "���")
		user << "� ����� ���� - ������� ������������� �� ��� �� � ����.."
		declaring_war = 0
		return

	var/war_declaration = "[user.real_name] ������� � ����� �������������� ���������� ������� [station_name()] � ������� �������� ���������� � ��� ������� ����������� ���������� ��� ��������� ����� - ������, ����������� �������."
	priority_announce(war_declaration, title = "������� ������!", sound = 'sound/effects/nuclear_alert.ogg')
	user << "�� ��������� �������� ����������� ��������� ���������. �������� ����� �������������� ��� ������������ ������ ������. ������� ������� ���� ���, ���� �� ��������� ������."

	for(var/obj/machinery/computer/shuttle/syndicate/S in machines)
		S.challenge = TRUE

	var/obj/item/device/radio/uplink/nuclear/U = new(get_turf(user))
	U.hidden_uplink.owner = "[user.key]"
	U.hidden_uplink.telecrystals = CHALLENGE_TELECRYSTALS
	U.hidden_uplink.gamemode = /datum/game_mode/nuclear
	config.shuttle_refuel_delay = max(config.shuttle_refuel_delay, CHALLENGE_SHUTTLE_DELAY)
	qdel(src)


#undef CHALLENGE_TELECRYSTALS
#undef CHALLENGE_TIME_LIMIT
#undef CHALLENGE_MIN_PLAYERS
#undef CHALLENGE_SHUTTLE_DELAY
