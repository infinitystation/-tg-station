/obj/machinery/computer/holo/atmos_alert
	name = "Atmospherics Alert"
	desc = "Shows atmospherics alarms across the station"
	icon_screen = "screen_generic"
	icon_screen_contents = "atmos"
	var/list/priority_alarms = list()
	var/list/minor_alarms = list()
	var/receive_frequency = 1437
	var/datum/radio_frequency/radio_connection

	light_color = LIGHT_COLOR_CYAN

/obj/machinery/computer/holo/atmos_alert/Initialize()
	..()
	set_frequency(receive_frequency)

/obj/machinery/computer/holo/atmos_alert/Destroy()
	if(SSradio)
		SSradio.remove_object(src, receive_frequency)
	return ..()

/obj/machinery/computer/holo/atmos_alert/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, \
									datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "atmos_alert", name, 350, 300, master_ui, state)
		ui.open()

/obj/machinery/computer/holo/atmos_alert/ui_data(mob/user)
	var/list/data = list()

	data["priority"] = list()
	for(var/zone in priority_alarms)
		data["priority"] += zone
	data["minor"] = list()
	for(var/zone in minor_alarms)
		data["minor"] += zone

	return data

/obj/machinery/computer/holo/atmos_alert/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("clear")
			var/zone = params["zone"]
			if(zone in priority_alarms)
				usr << "Priority alarm for [zone] cleared."
				priority_alarms -= zone
				. = TRUE
			if(zone in minor_alarms)
				usr << "Minor alarm for [zone] cleared."
				minor_alarms -= zone
				. = TRUE
	update_icon()

/obj/machinery/computer/holo/atmos_alert/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, receive_frequency)
	receive_frequency = new_frequency
	radio_connection = SSradio.add_object(src, receive_frequency, RADIO_ATMOSIA)

/obj/machinery/computer/holo/atmos_alert/receive_signal(datum/signal/signal)
	if(!signal)
		return

	var/zone = signal.data["zone"]
	var/severity = signal.data["alert"]

	if(!zone || !severity) return

	minor_alarms -= zone
	priority_alarms -= zone
	if(severity == "severe")
		priority_alarms += zone
	else if (severity == "minor")
		minor_alarms += zone
	update_icon()
	return

/obj/machinery/computer/holo/atmos_alert/update_icon()
	..()
	if(stat & (NOPOWER|BROKEN))
		return
	if(priority_alarms.len)
		overlays += "atmos_1"
	else if(minor_alarms.len)
		overlays += "atmos_0"