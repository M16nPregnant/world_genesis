/obj/item/borg_chameleon
	name = "cyborg chameleon projector"
	icon = 'icons/obj/device.dmi'
	icon_state = "shield0"
	flags_1 = CONDUCT_1
	item_flags = NOBLUDGEON
	item_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/friendlyName
	var/savedName
	var/active = FALSE
	var/activationCost = 300
	var/activationUpkeep = 50
	var/disguise = null
	var/disguise_icon_override = null
	var/disguise_pixel_offset = null
	var/mob/listeningTo
	var/static/list/signalCache = list( // list here all signals that should break the camouflage
			COMSIG_PARENT_ATTACKBY,
			COMSIG_ATOM_ATTACK_HAND,
			COMSIG_MOVABLE_IMPACT_ZONE,
			COMSIG_ATOM_BULLET_ACT,
			COMSIG_ATOM_EX_ACT,
			COMSIG_ATOM_FIRE_ACT,
			COMSIG_ATOM_EMP_ACT,
			)
	var/mob/living/silicon/robot/user // needed for process()
	var/animation_playing = FALSE

	var/list/engymodels = list("Default", "Default - Treads", "Heavy", "Sleek", "Marina", "Can", "Spider", "Loader","Handy", "Pup Dozer", "Vale")


/obj/item/borg_chameleon/Initialize(mapload)
	. = ..()
	friendlyName = pick(GLOB.ai_names)

/obj/item/borg_chameleon/Destroy()
	listeningTo = null
	return ..()

/obj/item/borg_chameleon/dropped(mob/user)
	. = ..()
	disrupt(user)

/obj/item/borg_chameleon/equipped(mob/user)
	. = ..()
	disrupt(user)

/obj/item/borg_chameleon/attack_self(mob/living/silicon/robot/user)
	if (user && user.cell && user.cell.charge >  activationCost)
		if (isturf(user.loc))
			toggle(user)
		else
			to_chat(user, "<span class='warning'>You can't use [src] while inside something!</span>")
	else
		to_chat(user, "<span class='warning'>You need at least [activationCost] charge in your cell to use [src]!</span>")

/obj/item/borg_chameleon/proc/toggle(mob/living/silicon/robot/user)
	if(active)
		playsound(src, 'sound/effects/pop.ogg', 100, TRUE, -6)
		to_chat(user, "<span class='notice'>You deactivate \the [src].</span>")
		deactivate(user)
	else
		if(animation_playing)
			to_chat(user, "<span class='notice'>\the [src] is recharging.</span>")
			return
		var/borg_icon = input(user, "Select an icon!", "Robot Icon", null) as null|anything in engymodels
		if(!borg_icon)
			return FALSE
		switch(borg_icon)
			if("Default")
				disguise = "engineer"
				disguise_icon_override = 'icons/mob/robots.dmi'
			if("Default - Treads")
				disguise = "engi-tread"
				disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
			if("Loader")
				disguise = "loaderborg"
				disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
			if("Handy")
				disguise = "handyeng"
				disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
			if("Sleek")
				disguise = "sleekeng"
				disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
			if("Can")
				disguise = "caneng"
				disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
			if("Marina")
				disguise = "marinaeng"
				disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
			if("Spider")
				disguise = "spidereng"
				disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
			if("Heavy")
				disguise = "heavyeng"
				disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
			if("Pup Dozer")
				disguise = "pupdozer"
				disguise_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
				disguise_pixel_offset = -16
			if("Vale")
				disguise = "valeeng"
				disguise_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
				disguise_pixel_offset = -16
		animation_playing = TRUE
		to_chat(user, "<span class='notice'>You activate \the [src].</span>")
		playsound(src, 'sound/effects/seedling_chargeup.ogg', 100, TRUE, -6)
		var/start = user.filters.len
		var/X,Y,rsq,i,f
		for(i=1, i<=7, ++i)
			do
				X = 60*rand() - 30
				Y = 60*rand() - 30
				rsq = X*X + Y*Y
			while(rsq<100 || rsq>900)
			user.filters += filter(type="wave", x=X, y=Y, size=rand()*2.5+0.5, offset=rand())
		for(i=1, i<=7, ++i)
			f = user.filters[start+i]
			animate(f, offset=f:offset, time=0, loop=3, flags=ANIMATION_PARALLEL)
			animate(offset=f:offset-1, time=rand()*20+10)
		if (do_after(user, 50, target=user) && user.cell.use(activationCost))
			playsound(src, 'sound/effects/bamf.ogg', 100, TRUE, -6)
			to_chat(user, "<span class='notice'>You are now disguised as the Genesis engineering borg \"[friendlyName]\".</span>")
			activate(user)
		else
			to_chat(user, "<span class='warning'>The chameleon field fizzles.</span>")
			do_sparks(3, FALSE, user)
			for(i=1, i<=min(7, user.filters.len), ++i) // removing filters that are animating does nothing, we gotta stop the animations first
				f = user.filters[start+i]
				animate(f)
		user.filters = null
		animation_playing = FALSE

/obj/item/borg_chameleon/process()
	if (user)
		if (!user.cell || !user.cell.use(activationUpkeep))
			disrupt(user)
	else
		return PROCESS_KILL

/obj/item/borg_chameleon/proc/activate(mob/living/silicon/robot/user)
	START_PROCESSING(SSobj, src)
	src.user = user
	savedName = user.name
	user.name = friendlyName
	user.module.cyborg_base_icon = disguise
	user.module.cyborg_icon_override = disguise_icon_override
	user.module.cyborg_pixel_offset = disguise_pixel_offset
	user.bubble_icon = "robot"
	active = TRUE
	user.update_icons()

	if(listeningTo == user)
		return
	if(listeningTo)
		UnregisterSignal(listeningTo, signalCache)
	RegisterSignal(user, signalCache, PROC_REF(disrupt))
	listeningTo = user

/obj/item/borg_chameleon/proc/deactivate(mob/living/silicon/robot/user)
	STOP_PROCESSING(SSobj, src)
	if(listeningTo)
		UnregisterSignal(listeningTo, signalCache)
		listeningTo = null
	do_sparks(5, FALSE, user)
	user.name = savedName
	user.module.cyborg_base_icon = initial(user.module.cyborg_base_icon)
	user.module.cyborg_icon_override = 'icons/mob/robots.dmi'
	user.bubble_icon = "syndibot"
	active = FALSE
	user.update_icons()
	user.pixel_x = 0 //this solely exists because of dogborgs. I want anyone who ever reads this code later on to know this. Don't ask me why it's here, doesn't work above update_icons()
	src.user = user

/obj/item/borg_chameleon/proc/disrupt(mob/living/silicon/robot/user)
	if(active)
		to_chat(user, "<span class='danger'>Your chameleon field deactivates.</span>")
		deactivate(user)
