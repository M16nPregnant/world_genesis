/datum/job/captain
	title = "Captain"
	flag = CAPTAIN
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY //:eyes:
	department_head = list("CentCom")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Genesis officials and Space law" //GS13 - Nanotrasen to Genesis
	selection_color = "#aac1ee"
	req_admin_notify = 1
	minimal_player_age = 20
	exp_requirements = 180
	exp_type = EXP_TYPE_COMMAND
	exp_type_department = EXP_TYPE_COMMAND
	considered_combat_role = TRUE


	outfit = /datum/outfit/job/captain
	plasma_outfit = /datum/outfit/plasmaman/captain

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	mind_traits = list(TRAIT_CAPTAIN_METABOLISM, TRAIT_DISK_VERIFIER)

	display_order = JOB_DISPLAY_ORDER_CAPTAIN
	departments = DEPARTMENT_BITFLAG_COMMAND

	blacklisted_quirks = list(/datum/quirk/mute, /datum/quirk/brainproblems, /datum/quirk/insanity)
	threat = 5

	family_heirlooms = list(
		/obj/item/reagent_containers/food/drinks/flask/gold,
		/obj/item/toy/figure/captain
	)

	mail_goodies = list(
		/obj/item/clothing/mask/cigarette/cigar/havana = 20,
		/obj/item/storage/fancy/cigarettes/cigars/havana = 15,
		/obj/item/reagent_containers/food/drinks/bottle/champagne = 10
	)

/datum/job/captain/get_access()
	return get_all_accesses()

/datum/job/captain/announce(mob/living/carbon/human/H)
	..()
	var/displayed_rank = H.client?.prefs?.alt_titles_preferences[title]
	if(!displayed_rank)	//Default to Captain
		displayed_rank = "Captain"
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(minor_announce), "[displayed_rank] [H.nameless ? "" : "[H.real_name] "]on deck!"))

/datum/outfit/job/captain
	name = "Captain"
	jobtype = /datum/job/captain

	id = /obj/item/card/id/gold
	belt = /obj/item/pda/captain
	glasses = /obj/item/clothing/glasses/sunglasses
	ears = /obj/item/radio/headset/heads/captain/alt
	gloves = /obj/item/clothing/gloves/color/captain
	uniform =  /obj/item/clothing/under/rank/captain
	suit = /obj/item/clothing/suit/armor/vest/capcarapace
	shoes = /obj/item/clothing/shoes/sneakers/brown
	head = /obj/item/clothing/head/caphat
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1, /obj/item/station_charter=1)

	backpack = /obj/item/storage/backpack/captain
	satchel = /obj/item/storage/backpack/satchel/cap
	duffelbag = /obj/item/storage/backpack/duffelbag/captain

	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/medal/gold/captain

	chameleon_extras = list(/obj/item/gun/energy/e_gun, /obj/item/stamp/captain)

/datum/outfit/job/captain/hardsuit
	name = "Captain (Hardsuit)"

	mask = /obj/item/clothing/mask/gas/sechailer
	suit = /obj/item/clothing/suit/space/hardsuit/captain
	suit_store = /obj/item/tank/internals/oxygen
