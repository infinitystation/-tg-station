//TODO@inf-dev ��������� �� datum ������. ~bear1ake@inf-dev
/mob/living/var/emoteCooldown = 100 // each 10 is real second
/mob/living/var/emoteLastUse = -1000

/mob/living/proc/emoteCooldownCheck()
	if(emoteLastUse <= (world.time - emoteCooldown))
		emoteLastUse = world.time
		return 1
	else
		src << "����� �����&#255;�� ������ ������ ����� 10 ������"
		return 0

/mob/living/verb/vomit_verb()
	set name = "�������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("vomit")

/mob/living/verb/shit()
	set name = "������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("shit")

/mob/living/verb/laugh()
	set name = "��������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("laugh")

/mob/living/verb/giggle()
	set name = "��������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("giggle")

/mob/living/verb/scream()
	set name = "�������������� �������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("scream")

/mob/living/verb/blush()
	set name = "��������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("blush")

/mob/living/verb/bow()
	set name = "�����������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("bow")

/mob/living/verb/burp()
	set name = "���������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("burp")

/mob/living/verb/choke()
	set name = "����������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("choke")

/mob/living/verb/chuckle()
	set name = "�����������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("chuckle")

/mob/living/verb/collapse()
	set name = "�������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("collapse")

/mob/living/verb/cough()
	set name = "�������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("cough")

/mob/living/verb/dance()
	set name = "���������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("dance")

/mob/living/verb/drool()
	set name = "����� ������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("drool")

/mob/living/verb/faint()
	set name = "�������� ��������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("faint")

/mob/living/verb/frown()
	set name = "���������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("frown")

/mob/living/verb/gasp()
	set name = "����������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("gasp")

/mob/living/verb/glare()
	set name = "������� ����������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("glare")

/mob/living/verb/grin()
	set name = "���������� � ������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("grin")

/mob/living/verb/jump()
	set name = "�������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("jump")

/mob/living/verb/look()
	set name = "����������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("look")

/mob/living/verb/nod()
	set name = "�������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("nod")

/mob/living/verb/shake()
	set name = "������ �������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("shake")

/mob/living/verb/sigh()
	set name = "��������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("sigh")

/mob/living/verb/sit()
	set name = "��������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("sit")

/mob/living/verb/smile()
	set name = "����������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("smile")

/mob/living/verb/sneeze()
	set name = "�������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("sneeze")

/mob/living/verb/sniff()
	set name = "������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("sniff")

/mob/living/verb/snore()
	set name = "�������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("snore")

/mob/living/verb/stare()
	set name = "��������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("stare")

/mob/living/verb/sulk()
	set name = "�������� ������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("sulk")

/mob/living/verb/sway()
	set name = "������������� �� ��������������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("sway")

/mob/living/verb/tremble()
	set name = "��������� � ������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("tremble")

/mob/living/verb/twitch()
	set name = "������ ��������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("twitch")

/mob/living/verb/twitch_s()
	set name = "ĸ�������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("twitch_s")

/mob/living/verb/wave()
	set name = "������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("wave")

/mob/living/verb/whimper()
	set name = "�������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("whimper")

/mob/living/verb/yawn()
	set name = "������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		emote("yawn")

/mob/living/var/hallucinate_emote_id = 0

/mob/living/proc/give_hallucinate_emote()
	src.verbs |= /mob/living/verb/hallucinate_emote
	hallucinate_emote_id = 0

/mob/living/verb/hallucinate_emote()
	set name = "������"
	set category = "Emotions"
	if(emoteCooldownCheck() == 1)
		message_admins("[key_name_admin(src)]<A HREF='?_src_=holder;adminmoreinfo=\ref[src]'>?</A> (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[src]'>FLW</A>) �������&#255;(-���)! ������� �� ����������.")
		src.hallucination += 60
		hallucinate_emote_id = addtimer(src, "give_hallucinate_emote", 6000, FALSE)
		src.verbs -= /mob/living/verb/hallucinate_emote


