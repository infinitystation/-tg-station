/*������ ��� ������� ���������:
	1) code/modules/mob/living/carbon/human/human.dm
		/mob/living/carbon/human/New() (���������, ������ ������� "erp")
		/mob/living/carbon/human/Topic (���� erp)
	2) code/modules/mob/living/carbon/human/examine.dm
		��� ������ ����� � �������� (������� ��������� "erp")
	3) ���� Erp.dm
	4) ����� � ������� (sound/erp)
	5) code/modules/mob/living/carbon/human/life.dm
		/mob/living/carbon/human/Life() (������� "erp)
*/
mob/living/carbon/human/proc/sexerp(var/mob/living/carbon/human/P = usr, var/mob/living/carbon/human/M = usr.affectedsex, var/sexvibor) //P = M - ������ ; H = P - �����
//�������
	if(get_dist(M.loc,usr.loc)>1)
		usr << "\red ������� ������."
		return
	if(sexvibor == "mouthkiss")
		switch(rand(1,4))
			if(1)
				visible_message("<b>[usr]</b> <font color=#FF1493>������</font> <b>[M]</b><font color=#FF1493>.</font>")
			if(2)
				visible_message("<b>[usr]</b> <font color=#FF1493>�� �������� ������</font> <b>[M]</b><font color=#FF1493>.</font>")
			if(3)
				visible_message("<b>[usr]</b> <font color=#FF1493>��������&#255; � ����</font> <b>[M]</b><font color=#FF1493>.</font>")
			if(4)
				visible_message("<b>[usr]</b> <font color=#FF1493>������� ����</font> <b>[M]</b> <font color=#FF1493>������&#255;��.</font>")
		return

	if(get_dist(M.loc,usr.loc)>0)
		usr << "\red ������� ������."
		return
	switch(sexvibor)
//���
		if("mouthpenis")
			if(P.gender=="male")
				switch(rand(1,5))
					if(1)
						visible_message("<b>[usr]</b> <font color=#FF1493>��������� ������</font> <b>[M]</b> <font color=#FF1493>� ����.</font>")
						if(prob(50))
							spawn(5)
							visible_message("<b>[M]</b> <font color=#aa7243>���������� [M.gender=="male"?"�����":"�������"] � [pick("���","�������")]</font> <b>[usr]</b> <font color=#aa7243>������ ����������� ��� [M.gender=="male"?"������":"�������"].</font>")
					if(2 || 3 || 4)
						visible_message("<b>[usr]</b> <font color=#FF1493>�������</font> <b>[M]</b> <font color=#FF1493>� ���.</font>")
						if(prob(50))
							spawn(5)
							visible_message("<b>[M]</b> <font color=#aa7243>�������� [M.gender=="male"?"�����":"������"] ��������� � ���&#255; ����� �������.</font>")
					if(5)
						visible_message("<b>[usr]</b> <font color=#FF1493>����� ���� �� ������</font> <b>[M]</b> <font color=#FF1493>� ��������� � � ����.</font>")
						if(prob(50))
							spawn(5)
							visible_message("<b>[M]</b> <font color=#aa7243>����������� ����</font> <b>[M]</b> <font color=#aa7243>���������.</font>")
				if (M.lust < 6)
					M.lust += 6
				if (prob(5) && P.stat != DEAD)
					P.lust += 5
				if (P.stat != DEAD && P.stat != UNCONSCIOUS)
					P.lust += 5
					if (P.lust >= P.resistenza)
						P.cum(P, M, "mouth")
				playsound(loc, "sound/erp/bj[rand(1, 11)].ogg", 50, 1, -1)
				M.do_fucking_animation(P)
				if (prob(P.potenzia))
					M.oxyloss += 3
					M.visible_message("<B>[M]</B> [pick("<font color=#FF1493>������&#255; ������������</font> <B>[P]</B>", "<font color=#FF1493>���������&#255;</font>", "<font color=#FF1493>�������&#255; � ������� ������</font>")].")
					if (istype(P.loc, /obj/structure/closet))
						P.visible_message("<B>[M]</B> [pick("<font color=#FF1493>������&#255; ������������</font> <B>[P]</B>", "<font color=#FF1493>���������&#255;</font>", "<font color=#FF1493>�������&#255; � ������� ������</font>")].")
			else
				switch(rand(1,4))
					if(1)
						visible_message("<b>[usr]</b> <font color=#FF1493>��������� ������</font> <b>[M]</b> <font color=#FF1493>� �����.</font>")
						if(prob(40))
							spawn(5)
							visible_message("<b>[M]</b> <font color=#aa7243>[pick("����������","������ ������� ����","����� &#255;����� � ���������", "����������", "����������")]</font> <b>[usr]</b><font color=#aa7243>.</font>")
					if(2 || 3 || 4)
						visible_message("<b>[usr]</b> <font color=#FF1493>������ ���� �� ������� �</font> <b>[M]</b> <font color=#FF1493>��������� [M.gender=="male"?"���":"�"] � �����.</font>")
						if(prob(40))
							spawn(5)
							visible_message("<b>[M]</b> <font color=#aa7243>[pick("����������","������ ������� ����","����� &#255;����� � ���������", "����������", "����������")]</font> <b>[usr]</b><font color=#aa7243>.</font>")
				if (P.lastfucked != M || P.lfhole != sexvibor)
					P.lastfucked = M
					P.lfhole = sexvibor
				if (prob(5) && M.stat != DEAD)
					M.lust += 5
				if (M.stat != DEAD && M.stat != UNCONSCIOUS)
					M.lust += 5
					if (M.lust >= M.resistenza)
						M.cum(M, P)
					else
						M.moan()
				playsound(loc, "sound/erp/champ[rand(1, 2)].ogg", 50, 1, -1)
				P.do_fucking_animation(M)
//�����
		if("chestmouth")
			if(M.gender == "male")
				switch(rand(1,3))
					if(1)
						visible_message("<b>[usr]</b> <font color=#FF1493>����� &#255;����� �� �����</font> <b>[M]</b><font color=#FF1493>.</font>")
					if(2)
						visible_message("<b>[usr]</b> <font color=#FF1493>������� �����</font> <b>[M]</b><font color=#FF1493> ������&#255;.</font>")
					if(3)
						visible_message("<b>[usr]</b> <font color=#FF1493>���������� ������� �</font> <b>[M]</b><font color=#FF1493>.</font>")
			if(M.gender == "female")
				switch(rand(1,3))
					if(1)
						visible_message("<b>[usr]</b> <font color=#FF1493>�������� &#255;����� �� �����</font> <b>[M]</b><font color=#FF1493>.</font>")
					if(2)
						visible_message("<b>[usr]</b> <font color=#FF1493>[pick("","������ �������� ")]���������� �����</font> <b>[M]</b><font color=#FF1493>.</font>")
					if(3)
						visible_message("<b>[usr]</b> <font color=#FF1493>������ �����</font> <b>[M]</b><font color=#FF1493>.</font>")
		if("chesthands")
			if(P.gender=="male")
				switch(rand(1,4))
					if(1)
						visible_message("<b>[usr]</b> <font color=#FF1493>������� ����� ������� ������.</font>")
					if(2)
						visible_message("<b>[usr]</b> <font color=#FF1493>����������� �����</font> <b>[M]'a</b><font color=#FF1493>.</font>")
					if(3 || 4)
						visible_message("<b>[usr]</b> <font color=#FF1493>������ ����</font> <b>[M]</b><font color=#FF1493>.</font>")
			else
				switch(rand(1,3))
					if(1)
						visible_message("<b>[usr]</b> <font color=#FF1493>������� �����</font> <b>[M]</b><font color=#FF1493>.</font>")
					if(2 || 3)
						visible_message("<b>[usr]</b> <font color=#FF1493>������ ����</font> <b>[M]</b><font color=#FF1493>.</font>")
		if("chestpenis")
			if(P.gender=="male")
				switch(rand(1,3))
					if(1)
						visible_message("<b>[usr]</b> <font color=#FF1493>��������&#255; ������� � �����</font> <b>[M]</b><font color=#FF1493>.</font>")
					if(2)
						visible_message("<b>[usr]</b> <font color=#FF1493>������� ����� ��������.</font>")
					if(3)
						visible_message("<b>[usr]</b> <font color=#FF1493>������� ������ �����-����� ��� ������</font> <b>[M]</b><font color=#FF1493>.</font>")
				if (M.lust < 3)
					M.lust += 3
				if (prob(5) && P.stat != DEAD)
					P.lust += 4
				if (P.stat != DEAD && P.stat != UNCONSCIOUS)
					P.lust += 4
					if (P.lust >= P.resistenza)
						P.cum(P, M, "chest")
				P.do_fucking_animation(M)
			else
				src << "<span class='warning'>�� ��� �������.</span>"
				return
//���
		if("groinmouth")
			if(M.gender=="male")
				switch(rand(1,8))
					if(1)
						visible_message("<b>[usr]</b> <font color=#FF1493>����� ���� ������� ���� � ���.</font>")
					if(2)
						visible_message("<b>[usr]</b> <font color=#FF1493>������ ����</font> <b>[M]</b> <font color=#FF1493>� ����������� ���.</font>")
					if(3)
						visible_message("<b>[usr]</b> <font color=#FF1493>������� ������� ��� ���������� ����� �������.</font>")
					if(4)
						visible_message("<b>[usr]</b> <font color=#FF1493>�������� &#255;����� �� ������</font> <b>[M]</b><font color=#FF1493>.</font>")
					if(5)
						visible_message("<b>[usr]</b> <font color=#FF1493>������ �������� �����.</font>")
					if(6)
						visible_message("<b>[usr]</b> <font color=#FF1493>����������&#255; ���� ����</font> <b>[M]'�</b><font color=#FF1493>.</font>")
					if(7 || 8)
						visible_message("<b>[usr]</b> <font color=#FF1493>����������</font> <b>[M]'�</b><font color=#FF1493>.</font>")
				if (P.lust < 6)
					P.lust += 6
				if (prob(5) && M.stat != DEAD)
					M.lust += 7
				if (M.stat != DEAD && M.stat != UNCONSCIOUS)
					M.lust += 7
					if (M.lust >= M.resistenza)
						M.cum(M, P, "mouth")
				playsound(loc, "sound/erp/bj[rand(1, 11)].ogg", 50, 1, -1)
				P.do_fucking_animation(M)
				if (prob(M.potenzia))
					P.oxyloss += 3
					P.visible_message("<B>[P]</B> [pick("<font color=#FF1493>������&#255; ������������</font> <B>[M]</B>", "<font color=#FF1493>���������&#255;</font>", "<font color=#FF1493>�������&#255; � ������� ������</font>")].")
					if (istype(M.loc, /obj/structure/closet))
						M.visible_message("<B>[P]</B> [pick("<font color=#FF1493>������&#255; ������������</font> <B>[M]</B>", "<font color=#FF1493>���������&#255;</font>", "<font color=#FF1493>�������&#255; � ������� ������</font>")].")
			else
				switch(rand(1,6))
					if(1)
						visible_message("<b>[usr]</b> <font color=#FF1493>��������� ������&#255;�� ���� �����</font> <b>[M]</b><font color=#FF1493>.</font>")
					if(2)
						visible_message("<b>[usr]</b> <font color=#FF1493>������ ������� ���� ��������.</font>")
					if(3 || 4 || 5)
						visible_message("<b>[usr]</b> <font color=#FF1493>����������</font> <b>[M]</b><font color=#FF1493>.</font>")
					if(6)
						visible_message("<b>[usr]</b> <font color=#FF1493>������ ������ ������</font> <b>[M]</b><font color=#FF1493>, ����y&#255; ������.</font>")
				if (P.lastfucked != M || P.lfhole != sexvibor)
					P.lastfucked = M
					P.lfhole = sexvibor
				if (prob(5) && M.stat != DEAD)
					M.lust += 7
				if (M.stat != DEAD && M.stat != UNCONSCIOUS)
					M.lust += 7
					if (M.lust >= M.resistenza)
						M.cum(M, P)
					else
						M.moan()
				playsound(loc, "sound/erp/champ[rand(1, 2)].ogg", 70, 1, -1)
				P.do_fucking_animation(M)
		if("groinhands")
			if(M.gender=="male")
				switch(rand(1,4))
					if(1 || 2 || 3)
						visible_message("<b>[usr]</b> <font color=#FF1493>����������� ����</font> <b>[M]'�</b><font color=#FF1493>.</font>")
					if(4)
						visible_message("<b>[usr]</b> <font color=#FF1493>����������� ����</font> <b>[M]'�</b> <font color=#FF1493>�����&#255;�� �����&#255; ��� �����-�����.</font>")
				if (P.lust < 3)
					P.lust += 3
				if (prob(5) && M.stat != DEAD)
					M.lust += 7
				if (M.stat != DEAD && M.stat != UNCONSCIOUS)
					M.lust += 7
					if (M.lust >= M.resistenza)
						M.cum(M, P, "mouth")
				P.do_fucking_animation(M)
			else
				switch(rand(1,2))
					if(1)
						visible_message("<b>[usr]</b> <font color=#FF1493>������� �������� � ������� �</font> <b>[M]</b><font color=#FF1493>.</font>")
					if(2)
						visible_message("<b>[usr]</b> <font color=#FF1493>��������� �������� ������</font> <b>[M]</b><font color=#FF1493>.</font>")
				if (P.lastfucked != M || P.lfhole != sexvibor)
					P.lastfucked = M
					P.lfhole = sexvibor
				if (prob(5) && M.stat != DEAD)
					M.lust += 8
				if (M.stat != DEAD && M.stat != UNCONSCIOUS)
					M.lust += 8
					if (M.lust >= M.resistenza)
						M.cum(M, P)
					else
						M.moan()
				playsound(loc, "sound/erp/champ_fingering.ogg", 50, 1, -1)
				P.do_fucking_animation(M)
		if("groinpenis")
			if(M.gender=="male")
				switch(rand(1,2))
					if(1)
						visible_message("<b>[usr]</b> <font color=#FF1493>�����������&#255; �� ����� �������.</font>")
					if(2)
						visible_message("<b>[usr]</b> <font color=#FF1493>������� ���&#255; �������</font> <b>[M]</b><font color=#FF1493>.</font>")
				if (P.lastfucked != M || P.lfhole != sexvibor)
					P.lastfucked = M
					P.lfhole = sexvibor
				if (prob(5) && M.stat != DEAD)
					M.lust += P.potenzia * 2
				if (istype(M.loc, /obj/structure/closet))
					playsound(M.loc.loc, 'sound/effects/clang.ogg', 50, 0, 0)
				P.lust += M.potenzia
				if (M.potenzia > 20)
					P.staminaloss += M.potenzia * 0.25
				if (P.lust >= P.resistenza)
					P.cum(P, M)
				else
					P.moan()
				if (M.stat != DEAD && M.stat != UNCONSCIOUS)
					M.lust += P.potenzia
					if (M.lust >= M.resistenza)
						M.cum(M, P, "vagina")
					else
						M.moan()
				P.do_fucking_animation(M)
				playsound(loc, "sound/erp/bang[rand(1, 3)].ogg", 70, 1, -1)
			else
				switch(rand(1,5))
					if(1)
						visible_message("<b>[usr]</b> <font color=#FF1493>�������</font> <b>[M]</b> <font color=#FF1493>.</font>")
					if(2)
						visible_message("<b>[usr]</b> <font color=#FF1493>�����&#255; ����</font> <b>[M]</b> <font color=#FF1493>������� �.</font>")
					if(3)
						visible_message("<b>[usr]</b> <font color=#FF1493>��������&#255; ������</font> <b>[M]</b> <font color=#FF1493>.</font>")
					if(4)
						visible_message("<b>[usr]</b> <font color=#FF1493>������� �������&#255;�� ����&#255;�� ���� �</font> <b>[M]</b><font color=#FF1493>.</font>")
					if(5)
						visible_message("<b>[usr]</b> <font color=#FF1493>�������&#255;�� �</font> <b>[M]</b> <font color=#FF1493>����&#255;�� � �� ����.</font>")
				if (P.lastfucked != M || P.lfhole != sexvibor)
					P.lastfucked = M
					P.lfhole = sexvibor
				if (prob(5) && M.stat != DEAD)
					M.lust += P.potenzia * 2
				if (istype(M.loc, /obj/structure/closet))
					playsound(M.loc.loc, 'sound/effects/clang.ogg', 50, 0, 0)
				P.lust += 10
				if (P.lust >= P.resistenza)
					P.cum(P, M, "vagina")
				if (M.stat != DEAD && M.stat != UNCONSCIOUS)
					M.lust += P.potenzia * 0.5
					if (P.potenzia > 20)
						M.staminaloss += P.potenzia * 0.25
					if (M.lust >= M.resistenza)
						M.cum(M, P)
					else
						M.moan()
				P.do_fucking_animation(P)
				playsound(loc, "sound/erp/bang[rand(1, 3)].ogg", 70, 1, -1)
//����
		if("assmouth")
			switch(rand(1,3))
				if(1)
					visible_message("<b>[usr]</b> <font color=#FF1493>����� [pick("����","�������� ������","����")]</font> <b>[M]</b><font color=#FF1493>.</font>")
				if(2)
					visible_message("<b>[usr]</b> <font color=#FF1493>����� &#255;����� �� [pick("����","��������� ������","�����","����")]</font> <b>[M]</b><font color=#FF1493>.</font>")
				if(3)
					visible_message("<b>[usr]</b> <font color=#FF1493>������� &#255;����� � [pick("����","�������� ������","����")]</font> <b>[M]</b><font color=#FF1493>.</font>")
		if("asshands")
			switch(rand(1,3))
				if(1)
					visible_message("<b>[usr]</b> <font color=#FF1493>������ ���� ������ � [pick("����","�������� ������","����")]</font> <b>[M]</b><font color=#FF1493>.</font>")
				if(2)
					visible_message("<b>[usr]</b> <font color=#FF1493>��������� �������� � [pick("����","�������� ������","����")]</font> <b>[M]</b><font color=#FF1493>.</font>")
				if(2)
					visible_message("<b>[usr]</b> <font color=#FF1493>����� ������� �������� � [pick("�������� ������","����")]</font> <b>[M]</b><font color=#FF1493>.</font>")
			if (P.lastfucked != M || P.lfhole != sexvibor)
				P.lastfucked = M
				P.lfhole = sexvibor
			if (prob(5) && M.stat != DEAD)
				M.lust += 8
			if (M.stat != DEAD && M.stat != UNCONSCIOUS)
				M.lust += 8
				if (M.lust >= M.resistenza)
					M.cum(M, P)
				else
					M.moan()
			playsound(loc, "sound/erp/champ_fingering.ogg", 50, 1, -1)
			P.do_fucking_animation(M)
		if("asspenis")
			if (P.gender=="male")
				switch(rand(1,5))
					if(1)
						visible_message("<b>[usr]</b> <font color=#FF1493>�������</font> <b>[M]</b> <font color=#FF1493>� [pick("�������","����","�����","�������� ������")].</font>")
					if(2)
						visible_message("<b>[usr]</b> <font color=#FF1493>� ����� �������</font> <b>[M]</b> <font color=#FF1493>� [pick("�������","����","�����","�������� ������")].</font>")
					if(3)
						visible_message("<b>[usr]</b> <font color=#FF1493>������� ��������� ���� ���� � [pick("�������","����","�����","�������� ������")]</font> <b>[M]</b><font color=#FF1493>.</font>")
					if(4)
						visible_message("<b>[usr]</b> <font color=#FF1493>�� ����� &#255;��� ���������� ���� � [pick("�������","����","�����","�������� ������")]</font> <b>[M]</b><font color=#FF1493>.</font>")
					if(5)
						visible_message("<b>[usr]</b> <font color=#FF1493>�����&#255; [pick("�����","����","����","����")]</font> <b>[M]</b> <font color=#FF1493>[pick("����� �������", "�������")] [M.gender=="male"?"���":"�"] � [pick("�������","����","�����","�������� ������")].</font>")
				if (P.lastfucked != M || P.lfhole != sexvibor)
					P.lastfucked = M
					P.lfhole = sexvibor
				if (prob(5) && M.stat != DEAD)
					M.lust += P.potenzia * 2
				if (istype(M.loc, /obj/structure/closet))
					playsound(M.loc.loc, 'sound/effects/clang.ogg', 50, 0, 0)
				P.lust += 10
				if (P.lust >= P.resistenza)
					P.cum(P, M, "anus")
				if (M.stat != DEAD && M.stat != UNCONSCIOUS)
					M.lust += P.potenzia * 0.5
					if (P.potenzia > 20)
						M.staminaloss += P.potenzia * 0.25
					if (M.lust >= M.resistenza)
						M.cum(M, P)
					else
						M.moan()
				P.do_fucking_animation(P)
				playsound(loc, "sound/erp/bang[rand(1, 3)].ogg", 70, 1, -1)
			else
				src << "<span class='warning'>�� ��� �������.</span>"
				return

/mob/living/carbon/human/MouseDrop_T(mob/M as mob, mob/user as mob)
	if(M==src && src!=usr)		return
	if(!Adjacent(src))			return
	if(M!=usr)					return
	usr.affectedsex = src
	make_sex(machine)

/mob/proc/make_sex()
	usr.set_machine(src)
	return

	//erp defines
/mob/living/carbon/human
	var/potenzia = 10
	var/resistenza = 200
	var/lust = 0
	var/lastmoan
	var/erpcooldown = 0
	var/multiorgasms = 0
	var/lfhole
	var/mob/living/carbon/human/lastfucked
/mob
	var/affectedsex = null
	//

mob/living/carbon/human/proc/handle_lust()
	lust -= 4
	if (lust <= 0)
		lust = 0
		lastfucked = null
		lfhole = ""
		multiorgasms = 0
	if (lust == 0)
		erpcooldown -= 1
	if (erpcooldown < 0)
		erpcooldown = 0

mob/living/carbon/human/proc/moan()
	var/mob/living/carbon/human/H = src
	if (prob(H.lust / H.resistenza * 65))
		var/message = pick("�����������", "������ �� �����������&#255;", "���������� �����", "���������� ����")
		H.visible_message("<B>[H]</B> [message].")
		var/g = H.gender == FEMALE ? "f" : "m"
		var/moan = rand(1, 7)
		if (moan == lastmoan)
			moan--
		if(!istype(loc, /obj/structure/closet))
			playsound(loc, "sound/erp/moan_[g][moan].ogg", 70, 1, 0)
		else if (g == "f")
			playsound(loc, "sound/erp/under_moan_f[rand(1, 4)].ogg", 70, 1, 0)
		lastmoan = moan
		if (istype(H.head, /obj/item/clothing/head/kitty)  || istype(H.head, /obj/item/clothing/head/collectable/kitty))
			playsound(loc, "sound/erp/purr_f[rand(1, 3)].ogg", 70, 1, 0)

/mob/living/carbon/proc/do_fucking_animation(mob/living/carbon/human/P) //anim
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/final_pixel_y = initial(pixel_y)

	var/direction = get_dir(src, P)
	if(direction & NORTH)
		pixel_y_diff = 8
	else if(direction & SOUTH)
		pixel_y_diff = -8

	if(direction & EAST)
		pixel_x_diff = 8
	else if(direction & WEST)
		pixel_x_diff = -8

	if(pixel_x_diff == 0 && pixel_y_diff == 0)
		pixel_x_diff = rand(-3,3)
		pixel_y_diff = rand(-3,3)
		animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
		animate(pixel_x = initial(pixel_x), pixel_y = initial(pixel_y), time = 2)
		return
	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
	animate(pixel_x = initial(pixel_x), pixel_y = final_pixel_y, time = 2)

mob/living/carbon/human/proc/cum(mob/living/carbon/human/H, mob/living/carbon/human/P, var/hole = "floor") // cum
	var/message = "������� �� ���!"
	var/turf/T
	if (H.gender == MALE)
		if (P)
			T = get_turf(P)
		else
			T = get_turf(H)

		if (H.multiorgasms < H.potenzia)
			var/obj/effect/decal/cleanable/cum/C = new(T)
			C.blood_DNA = list()

		if (hole == "mouth" || H.zone_selected == "mouth")
			message = pick("������� [P] � ���.", "������&#255; � ���� [P], �����&#255;�� ����� ����� �������, �� ������������&#255;.", "������������� ���&#255; �� ���� [P].", "������� �� ���.")

		else if (hole == "vagina")
			message = pick("������� � [P]", "����� ���&#255;������ ���� �� [P], � ����� �������� �� ���.", "��������� � [P] ��������� ���, ����� ����������&#255;. ������ �������� �������� �� ���� [P].")

		else if (hole == "anus")
			message = pick("������� [P] � ���.", "����������� ���� �� [P], � ����� ������� ������� �� [P.gender == MALE ? "���" : "�"] �����.", "���&#255;������ ���� �� ������� [P] � ����� �� �������� �� ���.")

		else if (hole == "floor")
			message = "������� �� ���!"

		else if (hole == "chest")
			message = "������� �� ����� [P]!"

		playsound(loc, "sound/erp/final_m[rand(1, 5)].ogg", 70, 1, 0)

		H.visible_message("<B>[H] [message]</B>")
		if (istype(P.loc, /obj/structure/closet))
			P.visible_message("<B>[H] [message]</B>")
		H.lust = 5
		H.resistenza += 50

	else
		message = pick("���������&#255; � �������� �������", "���������� ����� � ����� ������", "����������&#255;, � ����� ����� ��������&#255;���&#255;", "��������, ������� �����")
		H.visible_message("<B>[H] [message].</B>")
		if (istype(P.loc, /obj/structure/closet))
			P.visible_message("<B>[H] [message].</B>")
		playsound(loc, "sound/erp/final_f[rand(1, 3)].ogg", 90, 1, 0)
		var/delta = pick(20, 30, 40, 50)
		src.lust -= delta

	H.druggy = 60
	H.multiorgasms += 1
	H.erpcooldown = rand(200, 450)
	if (H.multiorgasms > H.potenzia / 3)
		if (H.staminaloss < P.potenzia * 4)
			H.staminaloss += H.potenzia
		if (H.staminaloss > 100)
			H.druggy = 300
			H.erpcooldown = 600

/mob/living/carbon/human/proc/checksuituniform(suit_only = 0, uniform_only = 0) //proverka odezdi
	if( (!suit_only && wear_suit && (wear_suit.flags_inv & HIDEJUMPSUIT)) || (!uniform_only && w_uniform) )
		return 1

/mob/living/carbon/human/proc/checksuituniformtwo(mob/T, mob/user)
	if(!iscarbon(T))
		return 0
	var/mob/living/carbon/human/C = T
	var/covered = ""
	if(C.checksuituniform(suit_only = 1))
		covered = "��������"
	else if(C.checksuituniform(uniform_only = 1))
		covered = "����� ��� ���"
	if(covered)
		var/who = (isnull(user) || T == user) ? "�� ������" : "������ ������"
		user << "<span class='warning'>[who] ��&#255;�� [covered]!</span>"
		return 0
	return 1

/mob/living/carbon/human/proc/is_nude()
	return (!wear_suit && !w_uniform) ? 1 : 0

/mob/living/carbon/human/proc/checkheadmask(mob/T, mob/user)
	if(!iscarbon(T))
		return 0
	var/mob/living/carbon/C = T
	var/covered = ""
	if(C.is_mouth_covered(head_only = 1))
		covered = "����"
	else if(C.is_mouth_covered(mask_only = 1))
		covered = "�����"
	if(covered)
		var/who = (isnull(user) || T == user) ? "�� ������" : "������ ������"
		user << "<span class='warning'>[who] ��&#255;�� [covered]!</span>"
		return 0
	return 1

/mob/living/carbon/human/make_sex()
	usr.set_machine(src)
	var/dat = {"<style type="text/css">
	body{
	background-color: #222222;
	}
	A {
	text-decoration: none;
	font-size: 12pt;
	color: #0066cc;
	}
	A:visited {
	color: #0066cc;
	}
	A:hover {
	text-decoration: underline;
	color: #821213;
	}
	</style>
	<B><FONT color=#be6209 size=4>����� c [name]</FONT></B>
	<HR>
	<font color=#be6209 size=3>���</font><BR>
	[in_range(usr.affectedsex,usr)? \
	"<font color=#be6209>-</font> <A href='?src=\ref[src];sex=mouthkiss'>�������</A><BR> \
	 <A href='?src=\ref[src];sex=mouthpenis'>�����</A><BR>":"������� ������"]

	<font color=#be6209 size=3>�����</font><BR>
	[in_range(usr.affectedsex,usr)? \
	"<font color=#be6209>-</font> <A href='?src=\ref[src];sex=chestmouth'>���</A><BR> \
	 <A href='?src=\ref[src];sex=chesthands'>����</A><BR> \
	 <A href='?src=\ref[src];sex=chestpenis'>�����</A><BR>":"������� ������"]

	<font color=#be6209 size=3>���</font><BR>
	[in_range(usr.affectedsex,usr)? \
	"<font color=#be6209>-</font> <A href='?src=\ref[src];sex=groinmouth'>���</A><BR> \
	 <A href='?src=\ref[src];sex=groinhands'>����</A><BR> \
	 <A href='?src=\ref[src];sex=groinpenis'>�����</A><BR>":"������� ������"]
	<font color=#be6209 size=3>�����</font><BR>
	[in_range(usr.affectedsex,usr)? \
	"<font color=#be6209>-</font> <A href='?src=\ref[src];sex=assmouth'>���</A><BR> \
	 <A href='?src=\ref[src];sex=asshands'>����</A><BR> \
	 <A href='?src=\ref[src];sex=asspenis'>�����</A><BR>":"������� ������"]
	"}
	usr << browse(dat, text("window=mob[name];size=340x480"))
	onclose(usr, "mob[name]")
	return


/obj/effect/decal/cleanable/cum //semya
	name = "cum"
	desc = "Wow, that is something thick and white..."
	density = 0
	layer = 2
	icon = 'sound/erp/icons/cum.dmi'
	blood_DNA = list()
	anchored = 1
	random_icon_states = list("cum1", "cum3", "cum4", "cum5", "cum6", "cum7", "cum8", "cum9", "cum10", "cum11", "cum12")
                          ///////////ERP End/////////////