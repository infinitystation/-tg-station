/datum/round_event_control/grid_check
	name = "Grid Check"
	typepath = /datum/round_event/grid_check
	weight = 10
	max_occurrences = 3

/datum/round_event/grid_check
	announceWhen	= 1
	startWhen = 1

/datum/round_event/grid_check/announce()
	priority_announce("������������������� ���������� ���������� � ����������� [station_name()]. � �������� ����������������� ���� ������� ������� ��������� �� �������������� �����.", "����������� ���� � �����������", 'sound/AI/poweroff.ogg')


/datum/round_event/grid_check/start()
	for(var/P in apcs_list)
		var/obj/machinery/power/apc/C = P
		if(C.cell && C.z == ZLEVEL_STATION)
			C.energy_fail(rand(30,120))