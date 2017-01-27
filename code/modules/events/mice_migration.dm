/datum/round_event_control/mice_migration
	name = "Mice Migration"
	typepath = /datum/round_event/mice_migration
	weight = 10

/datum/round_event/mice_migration
	announceWhen = 0
	var/minimum_mice = 5
	var/maximum_mice = 15

/datum/round_event/mice_migration/announce()
	var/cause = pick("����������� ����", "���������� �������", "���������",
		"������ ������", "\[��������\]", "��������� �������",
		"������ �����")
	var/plural = pick("���������", "����", "�������", "���",
		"�����", "�� ������ [maximum_mice]")
	var/name = pick("��������", "�����", "������� �������",
		"�������������, ������� ���� �������, ", "\[��������\]", "���������, ������ �������, ")
	var/movement = pick("�����������", "�����", "�����", "���������")
	var/location = pick("� ����������� �������", "� ���� ������������",
		"\[��������\]", "� ����� � �������� ���������")

	priority_announce("��-�� [cause], [plural] [name] [movement] [location].", "�������� ������� ��������!",
		'sound/effects/mousesqueek.ogg', 100, 1)

/datum/round_event/mice_migration/start()
	SSsqueak.trigger_migration(rand(minimum_mice, maximum_mice))
