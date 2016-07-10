#define CHALLENGE_TELECRYSTALS 280
#define CHALLENGE_TIME_LIMIT 3000
#define CHALLENGE_MIN_PLAYERS 25
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
	if(!check_allowed(user))
		return

	declaring_war = 1
	var/are_you_sure = alert(user, "������������������� �� ����� �������� ����� ����������� ����� ������� [station_name()]. �� ������������� ������� ������������ ����� ����� ����� ������? ", "�������� �����?", "��", "���")
	declaring_war = 0
	if(are_you_sure == "���")
		user << "� ����� ���� - ������� ������������� �� ��� �� � ����.."
		return
	if(!check_allowed(user))
		return

	declaring_war = 1
	var/war_declaration = "[user.real_name] ������� � ����� �������������� ���������� ������� [station_name()] � ������� �������� ���������� � ��� ������� ����������� ���������� ��� ��������� ����� - ������, ����������� �������."
	priority_announce(war_declaration, title = "������� ������!", sound = 'sound/effects/nuclear_alert.ogg')
	user << "�� ��������� �������� ����������� ��������� ���������. �������� ����� �������������� ��� ������������ ������ ������. ������� ������� ���� ���, ���� �� ��������� ������."

	for(var/V in syndicate_shuttle_boards)
		var/obj/item/weapon/circuitboard/computer/syndicate_shuttle/board = V
		board.challenge = TRUE

	var/obj/item/device/radio/uplink/nuclear/U = new(get_turf(user))
	U.hidden_uplink.owner = "[user.key]"
	U.hidden_uplink.telecrystals = CHALLENGE_TELECRYSTALS
	U.hidden_uplink.gamemode = /datum/game_mode/nuclear
	config.shuttle_refuel_delay = max(config.shuttle_refuel_delay, CHALLENGE_SHUTTLE_DELAY)
	qdel(src)

/obj/item/device/nuclear_challenge/proc/check_allowed(mob/living/user)
	if(declaring_war)
		return 0
	if(player_list.len < CHALLENGE_MIN_PLAYERS)
		user << "The enemy crew is too small to be worth declaring war on."
		return 0
	if(user.z != ZLEVEL_CENTCOM)
		user << "You have to be at your base to use this."
		return 0
	if(world.time-round_start_time > CHALLENGE_TIME_LIMIT)
		user << "It's too late to declare hostilities. Your benefactors are already busy with other schemes. You'll have to make do with what you have on hand."
		return 0
	for(var/V in syndicate_shuttle_boards)
		var/obj/item/weapon/circuitboard/computer/syndicate_shuttle/board = V
		if(board.moved)
			user << "The shuttle has already been moved! You have forfeit the right to declare war."
			return 0
	return 1

#undef CHALLENGE_TELECRYSTALS
#undef CHALLENGE_MIN_PLAYERS
#undef CHALLENGE_SHUTTLE_DELAY
