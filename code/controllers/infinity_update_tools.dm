/datum/subsystem/ticker
	var/update_waiting = 0				//build updating?
	var/updater_ckey = ""				//who updating build?

/client/proc/update_server()
	set category = "Server"
	set name = "Update Server"
	if (!usr.client.holder)
		return
	if(currentbuild.folder == currentbuild.update)
		usr << "������. ����������� ���� �� ��������"
		return
	var/confirm = alert("End the round and update server?", "End Round", "Yes", "Cancel")
	if(confirm == "Cancel")
		return
	if(confirm == "Yes")
		message_admins("[key_name_admin(usr)] ��������(�) ���������� �������.")
		log_game("[key_name_admin(usr)] ��������(�) ���������� �������.")
		force_update_server()

/client/proc/update_server_round_end()
	set category = "Server"
	set name = "Update Server at Round End"
	if (!usr.client.holder)
		return
	if(currentbuild.folder == currentbuild.update)
		usr << "������. ����������� ���� �� ��������"
		return
	var/confirm = alert("������������ ���������� � ����� ������?", "End Round", "Yes", "Cancel")
	if(confirm == "Cancel")
		return
	if(confirm == "Yes")
		message_admins("[key_name_admin(usr)] �����������(�) ���������� ������� � ����� �������� ������.")
		log_game("[key_name_admin(usr)] �����������(�) ���������� ������� � ����� �������� ������.")
		world << "<span class='adminooc'>������������� [usr.key] �����������(�) ���������� ������� � ����� �������� ������.</span>"
		ticker.updater_ckey = usr.key
		ticker.update_waiting = 1

/proc/force_update_server()
	if(currentbuild.folder == currentbuild.update)
		world << "������ ���������&#255;. ������������� �� ��������� ����� �� ��������."
		return
	world << "<span class='adminooc'><FONT size=5>��������! ������ ����������� ����� 10 ������! ������ �� ����� �������� ��������� �����!</FONT><br>���������� � ����� ������ ������������ ��������������� [ticker.updater_ckey]</span>."
	playsound_global('sound/effects/alarm.ogg', repeat=0, channel=1, volume=100)
	sleep(100)
	shell("sh ../update.sh [currentbuild.dmb_file] [currentbuild.folder] [world.port] [currentbuild.update]")