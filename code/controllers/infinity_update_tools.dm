// TODO@inf-dev ������������ ��� ����� ������� ~bear1ake
/*
/datum/controller/subsystem/ticker
	var/update_waiting = 0				//build updating?
	var/updater_ckey = ""				//who updating build?
*/
/client/proc/update_server()
	set category = "Server"
	set name = "Update Server"
	if (!usr.client.holder)
		return
	if(GLOB.currentbuild.folder == GLOB.currentbuild.update)
		to_chat(usr, "������. ����������� ���� �� ��������")
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
	if(GLOB.currentbuild.folder == GLOB.currentbuild.update)
		to_chat(usr, "������. ����������� ���� �� ��������")
		return
	var/confirm = alert("������������ ���������� � ����� ������?", "End Round", "Yes", "Cancel")
	if(confirm == "Cancel")
		return
	if(confirm == "Yes")
		message_admins("[key_name_admin(usr)] �����������(�) ���������� ������� � ����� �������� ������.")
		log_game("[key_name_admin(usr)] �����������(�) ���������� ������� � ����� �������� ������.")
		to_chat(world, "<span class='adminooc'>������������� [usr.key] �����������(�) ���������� ������� � ����� �������� ������.</span>")
		SSticker.updater_ckey = usr.key
		SSticker.update_waiting = 1

/proc/force_update_server()
	if(GLOB.currentbuild.folder == GLOB.currentbuild.update)
		to_chat(world, "������ ���������&#255;. ������������� �� ��������� ����� �� ��������.")
		return
	to_chat(world, "<span class='adminooc'><FONT size=5>��������! ������ ����������� ����� 10 ������! ������ �� ����� �������� ��������� �����!</FONT><br>���������� � ����� ������ ������������ ��������������� [SSticker.updater_ckey]</span>.")
	playsound_global('sound/effects/alarm.ogg', repeat=0, channel=1, volume=100)
	sleep(100)
	shell("sudo sh ../update.sh [GLOB.currentbuild.dmb_file] [GLOB.currentbuild.folder] [world.port] [GLOB.currentbuild.update]")