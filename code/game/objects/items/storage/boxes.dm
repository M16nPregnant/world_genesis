/*
 *	Everything derived from the common cardboard box.
 *	Basically everything except the original is a kit (starts full).
 *
 *	Contains:
 *		Empty box, starter boxes (survival/engineer),
 *		Latex glove and sterile mask boxes,
 *		Syringe, beaker, dna injector boxes,
 *		Blanks, flashbangs, and EMP grenade boxes,
 *		Tracking and chemical implant boxes,
 *		Prescription glasses and drinking glass boxes,
 *		Condiment bottle and silly cup boxes,
 *		Donkpocket and monkeycube boxes,
 *		ID and security PDA cart boxes,
 *		Handcuff, mousetrap, and pillbottle boxes,
 *		Snap-pops and matchboxes,
 *		Replacement light boxes,
 *		Ammo types,
 *		Action Figure Boxes,
 *		Various paper bags,
 *		Colored boxes
 *
 *		For syndicate call-ins see uplink_kits.dm
 */

/obj/item/storage/box
	name = "box"
	desc = "It's just an ordinary box."
	icon_state = "box"
	item_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	resistance_flags = FLAMMABLE
	var/foldable = /obj/item/stack/sheet/cardboard
	var/illustration = "writing"
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE //exploits ahoy

/obj/item/storage/box/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/storage/box/suicide_act(mob/living/carbon/user)
	var/obj/item/bodypart/head/myhead = user.get_bodypart(BODY_ZONE_HEAD)
	if(myhead)
		user.visible_message("<span class='suicide'>[user] puts [user.p_their()] head into \the [src], and begins closing it! It looks like [user.p_theyre()] trying to commit suicide!</span>")
		myhead.dismember()
		myhead.forceMove(src)//force your enemies to kill themselves with your head collection box!
		playsound(user,pick('sound/misc/desceration-01.ogg','sound/misc/desceration-02.ogg','sound/misc/desceration-01.ogg') ,50, 1, -1)
		return BRUTELOSS
	user.visible_message("<span class='suicide'>[user] beating [user.p_them()]self with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return BRUTELOSS

/obj/item/storage/box/update_overlays()
	. = ..()
	if(illustration)
		. += illustration

/obj/item/storage/box/attack_self(mob/user)
	..()

	if(!foldable)
		return
	if(contents.len)
		to_chat(user, "<span class='warning'>You can't fold this box with items still inside!</span>")
		return
	if(!ispath(foldable))
		return

	to_chat(user, "<span class='notice'>You fold [src] flat.</span>")
	var/obj/item/I = new foldable
	qdel(src)
	user.put_in_hands(I)

/obj/item/storage/box/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stack/packageWrap))
		return FALSE
	return ..()

//Disk boxes
/obj/item/storage/box/disks
	name = "diskette box"
	illustration = "disk_kit"

/obj/item/storage/box/disks/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/disk/data(src)

/obj/item/storage/box/disks_plantgene
	name = "plant data disks box"
	illustration = "disk_kit"

/obj/item/storage/box/disks_plantgene/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/disk/plantgene(src)

/obj/item/storage/box/disks_nanite
	name = "nanite program disks box"
	illustration = "disk_kit"

/obj/item/storage/box/disks_nanite/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/disk/nanite_program(src)

// Ordinary survival box
/obj/item/storage/box/survival
	name = "survival box"
	desc = "A box with the bare essentials of ensuring the survival of you and others."
	icon_state = "internals"
	illustration = "emergencytank"
	var/mask_type = /obj/item/clothing/mask/breath
	var/internal_type = /obj/item/tank/internals/emergency_oxygen
	var/medipen_type = /obj/item/reagent_containers/hypospray/medipen

/obj/item/storage/box/survival/PopulateContents()
	new mask_type(src)
	if(!isnull(medipen_type))
		new medipen_type(src)

	if(!isplasmaman(loc))
		new internal_type(src)
	else
		new /obj/item/tank/internals/plasmaman/belt(src)

	if(HAS_TRAIT(SSstation, STATION_TRAIT_PREMIUM_INTERNALS))
		new /obj/item/flashlight/flare(src)
		new /obj/item/radio/off(src)

/obj/item/storage/box/survival/radio/PopulateContents()
	..() // we want the survival stuff too.
	new /obj/item/radio/off(src)

// Mining survival box
/obj/item/storage/box/survival/mining
	mask_type = /obj/item/clothing/mask/gas/explorer

/obj/item/storage/box/survival/mining/PopulateContents()
	..()
	new /obj/item/crowbar/red(src)

	if(!isplasmaman(loc))
		new /obj/item/tank/internals/emergency_oxygen(src)
	else
		new /obj/item/tank/internals/plasmaman/belt(src)

// Engineer survival box
/obj/item/storage/box/survival/engineer
	name = "extended-capacity survival box"
	desc = "A box with the bare essentials of ensuring the survival of you and others. This one is labelled to contain an extended-capacity tank."
	illustration = "extendedtank"
	internal_type = /obj/item/tank/internals/emergency_oxygen/engi

/obj/item/storage/box/survival/engineer/radio/PopulateContents()
	..() // we want the regular items too.
	new /obj/item/radio/off(src)

// Syndie survival box
/obj/item/storage/box/survival/syndie //why is this its own thing if it's just the engi box with a syndie mask and medipen?
	name = "extended-capacity survival box"
	desc = "A box with the bare essentials of ensuring the survival of you and others. This one is labelled to contain an extended-capacity tank."
	illustration = "extendedtank"
	mask_type = /obj/item/clothing/mask/gas/syndicate
	internal_type = /obj/item/tank/internals/emergency_oxygen/engi
	medipen_type = null

// Security survival box
/obj/item/storage/box/survival/security
	mask_type = /obj/item/clothing/mask/gas/sechailer

/obj/item/storage/box/survival/security/radio/PopulateContents()
	..() // we want the regular stuff too
	new /obj/item/radio/off(src)

/obj/item/storage/box/seclooking
	icon_state = "secbox"
	illustration = null

/obj/item/storage/box/cells
	name = "box of powercells"
	desc = "Contains powercells."
	illustration = "power_cell"

/obj/item/storage/box/ammoshells
	name = "box of loose ammo"
	desc = "Contains loose ammo."
	illustration = "loose_ammo"

/obj/item/storage/box/otwo
	name = "box of o2 supplies"
	desc = "Contains o2 supplies."
	illustration = "02"

/obj/item/storage/box/otwo/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/tank/internals/emergency_oxygen/engi(src)

/obj/item/storage/box/gloves
	name = "box of latex gloves"
	desc = "Contains sterile latex gloves."
	illustration = "latex"

/obj/item/storage/box/gloves/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/clothing/gloves/color/latex(src)

/obj/item/storage/box/masks
	name = "box of sterile masks"
	desc = "This box contains sterile medical masks."
	illustration = "sterile"

/obj/item/storage/box/masks/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/clothing/mask/surgical(src)

/obj/item/storage/box/syringes
	name = "box of syringes"
	desc = "A box full of syringes."
	illustration = "syringe"

/obj/item/storage/box/syringes/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/syringe(src)

/obj/item/storage/box/medipens
	name = "box of medipens"
	desc = "A box full of epinephrine MediPens."
	illustration = "syringe"

/obj/item/storage/box/medipens/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/hypospray/medipen(src)

/obj/item/storage/box/medipens/utility
	name = "stimpack value kit"
	desc = "A box with several stimpack medipens for the economical miner."
	illustration = "syringe"

/obj/item/storage/box/medipens/utility/PopulateContents()
	..() // includes regular medipens.
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/hypospray/medipen/stimpack(src)

/obj/item/storage/box/beakers
	name = "box of beakers"
	illustration = "beaker"

/obj/item/storage/box/beakers/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/glass/beaker( src )

/obj/item/storage/box/beakers/bluespace
	name = "box of bluespace beakers"
	illustration = "beaker"

/obj/item/storage/box/beakers/bluespace/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/glass/beaker/bluespace(src)

/obj/item/storage/box/medsprays
	name = "box of medical sprayers"
	desc = "A box full of medical sprayers, with unscrewable caps and precision spray heads."

/obj/item/storage/box/medsprays/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/medspray( src )

/obj/item/storage/box/injectors
	name = "box of DNA injectors"
	desc = "This box contains injectors, it seems."

/obj/item/storage/box/injectors/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/dnainjector/h2m(src)
	for(var/i in 1 to 3)
		new /obj/item/dnainjector/m2h(src)

/obj/item/storage/box/flashbangs
	name = "box of flashbangs (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause blindness or deafness in repeated use.</B>"
	icon_state = "secbox"
	illustration = "flashbang"

/obj/item/storage/box/flashbangs/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/flashbang(src)

/obj/item/storage/box/stingbangs
	name = "box of stingbangs (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause severe injuries or death in repeated use.</B>"
	icon_state = "secbox"
	illustration = "flashbang"

/obj/item/storage/box/stingbangs/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/grenade/stingbang(src)

/obj/item/storage/box/flashes
	name = "box of flashbulbs"
	desc = "<B>WARNING: Flashes can cause serious eye damage, protective eyewear is required.</B>"
	icon_state = "secbox"
	illustration = "flashbang"

/obj/item/storage/box/flashes/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/assembly/flash/handheld(src)

/obj/item/storage/box/wall_flash
	name = "wall-mounted flash kit"
	desc = "This box contains everything necessary to build a wall-mounted flash. <B>WARNING: Flashes can cause serious eye damage, protective eyewear is required.</B>"
	illustration = "flashbang"

/obj/item/storage/box/wall_flash/PopulateContents()
	var/id = rand(1000, 9999)
	// FIXME what if this conflicts with an existing one?

	new /obj/item/wallframe/button(src)
	new /obj/item/electronics/airlock(src)
	var/obj/item/assembly/control/flasher/remote = new(src)
	remote.id = id
	var/obj/item/wallframe/flasher/frame = new(src)
	frame.id = id
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/screwdriver(src)

/obj/item/storage/box/teargas
	name = "box of tear gas grenades (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause blindness and skin irritation.</B>"
	illustration = "flashbang"

/obj/item/storage/box/teargas/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/chem_grenade/teargas(src)

/obj/item/storage/box/emps
	name = "box of emp grenades"
	desc = "A box with 5 emp grenades."
	illustration = "flashbang"

/obj/item/storage/box/emps/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/grenade/empgrenade(src)

/obj/item/storage/box/minibombs
	name = "box of syndicate minibombs"
	desc = "A box containing 2 highly explosive syndicate minibombs."
	icon_state = "syndiebox"
	illustration = "frag"

/obj/item/storage/box/minibombs/PopulateContents()
	new /obj/item/grenade/syndieminibomb(src)
	new /obj/item/grenade/syndieminibomb(src)

/obj/item/storage/box/bombananas
	name = "box of bombananas"
	desc = "A box containing 2 highly explosive bombananas. Discard peel at enemy after consumption."
	icon_state = "syndiebox"
	illustration = "frag"

/obj/item/storage/box/bombananas/PopulateContents()
	new /obj/item/reagent_containers/food/snacks/grown/banana/bombanana(src)
	new /obj/item/reagent_containers/food/snacks/grown/banana/bombanana(src)

/obj/item/storage/box/trackimp
	name = "boxed tracking implant kit"
	desc = "Box full of scum-bag tracking utensils."
	illustration = "implant"

/obj/item/storage/box/trackimp/PopulateContents()
	for(var/i in 1 to 4)
		new /obj/item/implantcase/tracking(src)
	new /obj/item/implanter(src)
	new /obj/item/implantpad(src)
	new /obj/item/locator(src)

/obj/item/storage/box/minertracker
	name = "boxed tracking implant kit"
	desc = "For finding those who have died on the accursed lavaworld."
	illustration = "implant"

/obj/item/storage/box/minertracker/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/implantcase/tracking(src)
	new /obj/item/implanter(src)
	new /obj/item/implantpad(src)
	new /obj/item/locator(src)

/obj/item/storage/box/chemimp
	name = "boxed chemical implant kit"
	desc = "Box of stuff used to implant chemicals."
	illustration = "implant"

/obj/item/storage/box/chemimp/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/implantcase/chem(src)
	new /obj/item/implanter(src)
	new /obj/item/implantpad(src)

/obj/item/storage/box/exileimp
	name = "boxed exile implant kit"
	desc = "Box of exile implants. It has a picture of a clown being booted through the Gateway."
	illustration = "implant"

/obj/item/storage/box/exileimp/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/implantcase/exile(src)
	new /obj/item/implanter(src)

/obj/item/storage/box/bodybags
	name = "body bags"
	desc = "The label indicates that it contains body bags."
	illustration = "bodybags"

/obj/item/storage/box/bodybags/PopulateContents()
	..()
	for(var/i in 1 to 7)
		new /obj/item/bodybag(src)

/obj/item/storage/box/rxglasses
	name = "box of prescription glasses"
	desc = "This box contains nerd glasses."
	illustration = "glasses"

/obj/item/storage/box/rxglasses/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/clothing/glasses/regular(src)

/obj/item/storage/box/drinkingglasses
	name = "box of drinking glasses"
	desc = "It has a picture of drinking glasses on it."

/obj/item/storage/box/drinkingglasses/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/food/drinks/drinkingglass(src)

/obj/item/storage/box/condimentbottles
	name = "box of condiment bottles"
	desc = "It has a large ketchup smear on it."

/obj/item/storage/box/condimentbottles/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/food/condiment(src)

/obj/item/storage/box/cups
	name = "box of paper cups"
	desc = "It has pictures of paper cups on the front."

/obj/item/storage/box/cups/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/food/drinks/sillycup( src )

/obj/item/storage/box/donkpockets
	name = "box of donk-pockets"
	desc = "<B>Instructions:</B> <I>Heat in microwave. Product will cool if not eaten within seven minutes.</I>"
	icon_state = "donkpocketbox"
	illustration=null
	custom_premium_price = PRICE_ABOVE_NORMAL // git gud
	//GS13 EDIT
	var/donktype = /obj/item/reagent_containers/food/snacks/donkpocket
	var/warmtype = /obj/item/reagent_containers/food/snacks/donkpocket/warm

/obj/item/storage/box/donkpockets/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.can_hold = typecacheof(list(/obj/item/reagent_containers/food/snacks/donkpocket))

/obj/item/storage/box/donkpockets/PopulateContents()
	for(var/i in 1 to 6)
		new donktype(src) //GS13 EDIT

/obj/item/storage/box/monkeycubes
	name = "monkey cube box"
	desc = "Drymate brand monkey cubes. Just add water!"
	icon_state = "monkeycubebox"
	illustration = null

/obj/item/storage/box/monkeycubes/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 7
	STR.can_hold = typecacheof(list(/obj/item/reagent_containers/food/snacks/cube/monkey))

/obj/item/storage/box/monkeycubes/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/food/snacks/cube/monkey(src)

/obj/item/storage/box/ids
	name = "box of spare IDs"
	desc = "Has so many empty IDs."
	illustration = "id"

/obj/item/storage/box/ids/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/card/id(src)

//Some spare PDAs in a box
/obj/item/storage/box/PDAs
	name = "spare PDAs"
	desc = "A box of spare PDA microcomputers."
	illustration = "pda"

/obj/item/storage/box/PDAs/PopulateContents()
	new /obj/item/pda(src)
	new /obj/item/pda(src)
	new /obj/item/pda(src)
	new /obj/item/pda(src)
	new /obj/item/cartridge/head(src)

	var/newcart = pick(	/obj/item/cartridge/engineering,
						/obj/item/cartridge/security,
						/obj/item/cartridge/medical,
						/obj/item/cartridge/signal/toxins,
						/obj/item/cartridge/quartermaster)
	new newcart(src)

/obj/item/storage/box/silver_ids
	name = "box of spare silver IDs"
	desc = "Shiny IDs for important people."
	illustration = "id"

/obj/item/storage/box/silver_ids/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/card/id/silver(src)

/obj/item/storage/box/prisoner
	name = "box of prisoner IDs"
	desc = "Take away their last shred of dignity, their name."
	illustration = "id"

/obj/item/storage/box/prisoner/PopulateContents()
	..()
	new /obj/item/card/id/prisoner/one(src)
	new /obj/item/card/id/prisoner/two(src)
	new /obj/item/card/id/prisoner/three(src)
	new /obj/item/card/id/prisoner/four(src)
	new /obj/item/card/id/prisoner/five(src)
	new /obj/item/card/id/prisoner/six(src)
	new /obj/item/card/id/prisoner/seven(src)

/obj/item/storage/box/seccarts
	name = "box of PDA security cartridges"
	desc = "A box full of PDA cartridges used by Security."
	illustration = "pda"

/obj/item/storage/box/seccarts/PopulateContents()
	new /obj/item/cartridge/detective(src)
	for(var/i in 1 to 6)
		new /obj/item/cartridge/security(src)

/obj/item/storage/box/firingpins
	name = "box of standard firing pins"
	desc = "A box full of standard firing pins, to allow newly-developed firearms to operate."
	illustration = "firing_pins"

/obj/item/storage/box/firingpins/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/firing_pin(src)

/obj/item/storage/box/lasertagpins
	name = "box of laser tag firing pins"
	desc = "A box full of laser tag firing pins, to allow newly-developed firearms to require wearing brightly coloured plastic armor before being able to be used."
	illustration = "firing_pins"

/obj/item/storage/box/lasertagpins/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/firing_pin/tag/red(src)
		new /obj/item/firing_pin/tag/blue(src)

/obj/item/storage/box/handcuffs
	name = "box of spare handcuffs"
	desc = "A box full of handcuffs."
	icon_state = "secbox"
	illustration = "handcuff"

/obj/item/storage/box/handcuffs/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/restraints/handcuffs(src)

/obj/item/storage/box/zipties
	name = "box of spare zipties"
	desc = "A box full of zipties."
	icon_state = "secbox"
	illustration = "handcuff"

/obj/item/storage/box/zipties/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/restraints/handcuffs/cable/zipties(src)

/obj/item/storage/box/alienhandcuffs
	name = "box of spare handcuffs"
	desc = "A box full of handcuffs."
	icon_state = "alienbox"
	illustration = "handcuff"

/obj/item/storage/box/alienhandcuffs/PopulateContents()
	for(var/i in 1 to 7)
		new	/obj/item/restraints/handcuffs/alien(src)

/obj/item/storage/box/fakesyndiesuit
	name = "boxed space suit and helmet"
	desc = "A sleek, sturdy box used to hold replica spacesuits."
	icon_state = "syndiebox"

/obj/item/storage/box/fakesyndiesuit/PopulateContents()
	new /obj/item/clothing/head/syndicatefake(src)
	new /obj/item/clothing/suit/syndicatefake(src)

/obj/item/storage/box/mousetraps
	name = "box of Pest-B-Gon mousetraps"
	desc = "<span class='alert'>Keep out of reach of children.</span>"
	illustration = "mousetraps"

/obj/item/storage/box/mousetraps/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/assembly/mousetrap(src)

/obj/item/storage/box/pillbottles
	name = "box of pill bottles"
	desc = "It has pictures of pill bottles on its front."
	illustration = "pillbox"

/obj/item/storage/box/pillbottles/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/storage/pill_bottle(src)

/obj/item/storage/box/snappops
	name = "snap pop box"
	desc = "Eight wrappers of fun! Ages 8 and up. Not suitable for children."
	icon = 'icons/obj/toys/toy.dmi'
	icon_state = "spbox"
	illustration = null

/obj/item/storage/box/snappops/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.can_hold = typecacheof(list(/obj/item/toy/snappop))
	STR.max_items = 8

/obj/item/storage/box/snappops/PopulateContents()
	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_FILL_TYPE, /obj/item/toy/snappop)

/obj/item/storage/box/matches
	name = "matchbox"
	desc = "A small box of Almost But Not Quite Plasma Premium Matches."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "matchbox"
	item_state = "zippo"
	illustration = null
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_BELT
	custom_price = PRICE_REALLY_CHEAP

/obj/item/storage/box/matches/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 10
	STR.can_hold = typecacheof(list(/obj/item/match))

/obj/item/storage/box/matches/PopulateContents()
	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_FILL_TYPE, /obj/item/match)

/obj/item/storage/box/matches/attackby(obj/item/match/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/match))
		W.matchignite()

/obj/item/storage/box/lights
	name = "box of replacement bulbs"
	icon = 'icons/obj/storage.dmi'
	illustration = "light"
	desc = "This box is shaped on the inside so that only light tubes and bulbs fit."
	item_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	foldable = /obj/item/stack/sheet/cardboard //BubbleWrap

/obj/item/storage/box/lights/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 21
	STR.can_hold = typecacheof(list(/obj/item/light/tube, /obj/item/light/bulb))
	STR.max_combined_w_class = 21
	STR.click_gather = TRUE

/obj/item/storage/box/lights/bulbs/PopulateContents()
	for(var/i in 1 to 21)
		new /obj/item/light/bulb(src)

/obj/item/storage/box/lights/tubes
	name = "box of replacement tubes"
	illustration = "lighttube"

/obj/item/storage/box/lights/tubes/PopulateContents()
	for(var/i in 1 to 21)
		new /obj/item/light/tube(src)

/obj/item/storage/box/lights/mixed
	name = "box of replacement lights"
	illustration = "lightmixed"

/obj/item/storage/box/lights/mixed/PopulateContents()
	for(var/i in 1 to 14)
		new /obj/item/light/tube(src)
	for(var/i in 1 to 7)
		new /obj/item/light/bulb(src)

/obj/item/storage/box/deputy
	name = "box of deputy armbands"
	desc = "To be issued to those authorized to act as deputy of security."

/obj/item/storage/box/deputy/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/clothing/accessory/armband/deputy(src)

/obj/item/storage/box/metalfoam
	name = "box of metal foam grenades"
	desc = "To be used to rapidly seal hull breaches."
	illustration = "flashbang"

/obj/item/storage/box/metalfoam/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/chem_grenade/metalfoam(src)

/obj/item/storage/box/smart_metal_foam
	name = "box of smart metal foam grenades"
	desc = "Used to rapidly seal hull breaches. This variety conforms to the walls of its area."
	illustration = "flashbang"

/obj/item/storage/box/smart_metal_foam/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/grenade/chem_grenade/smart_metal_foam(src)

/obj/item/storage/box/hug
	name = "box of hugs"
	desc = "A special box for sensitive people."
	icon_state = "hugbox"
	illustration = "heart"
	foldable = null

/obj/item/storage/box/hug/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] clamps the box of hugs on [user.p_their()] jugular! Guess it wasn't such a hugbox after all..</span>")
	return (BRUTELOSS)

/obj/item/storage/box/hug/attack_self(mob/user)
	. = ..()
	user.DelayNextAction(CLICK_CD_MELEE)
	playsound(src, "rustle", 50, 1, -5)
	user.visible_message("<span class='notice'>[user] hugs \the [src].</span>","<span class='notice'>You hug \the [src].</span>")
	SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT,"hugbox", /datum/mood_event/hugbox)

/////clown box & honkbot assembly
/obj/item/storage/box/clown
	name = "clown box"
	desc = "A colorful cardboard box for the clown"
	illustration = "clown"

/obj/item/storage/box/clown/attackby(obj/item/I, mob/user, params)
	if((istype(I, /obj/item/bodypart/l_arm/robot)) || (istype(I, /obj/item/bodypart/r_arm/robot)))
		if(contents.len) //prevent accidently deleting contents
			to_chat(user, "<span class='warning'>You need to empty [src] out first!</span>")
			return
		if(!user.temporarilyRemoveItemFromInventory(I))
			return
		qdel(I)
		to_chat(user, "<span class='notice'>You add some wheels to the [src]! You've got an honkbot assembly now! Honk!</span>")
		var/obj/item/bot_assembly/honkbot/A = new
		qdel(src)
		user.put_in_hands(A)
	else
		return ..()

//////
/obj/item/storage/box/hug/medical/PopulateContents()
	new /obj/item/stack/medical/suture(src)
	new /obj/item/stack/medical/mesh(src)
	new /obj/item/reagent_containers/hypospray/medipen(src)

// Clown survival box
/obj/item/storage/box/hug/survival/PopulateContents()
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/reagent_containers/hypospray/medipen(src)

	if(!isplasmaman(loc))
		new /obj/item/tank/internals/emergency_oxygen(src)
	else
		new /obj/item/tank/internals/plasmaman/belt(src)

	if(HAS_TRAIT(SSstation, STATION_TRAIT_PREMIUM_INTERNALS))
		new /obj/item/flashlight/flare(src)
		new /obj/item/radio/off(src)

/obj/item/storage/box/rubbershot
	name = "box of rubber shots"
	desc = "A box full of rubber shots, designed for riot shotguns."
	icon_state = "rubbershot_box"
	illustration = null

/obj/item/storage/box/rubbershot/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun/rubbershot(src)

/obj/item/storage/box/lethalshot
	name = "box of buckshot (Lethal)"
	desc = "A box full of lethal shots, designed for riot shotguns."
	icon_state = "lethalshot_box"
	illustration = null

/obj/item/storage/box/lethalshot/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun/buckshot(src)

/obj/item/storage/box/beanbag
	name = "box of beanbags"
	desc = "A box full of beanbag shells."
	icon_state = "rubbershot_box"
	illustration = null

/obj/item/storage/box/beanbag/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/ammo_casing/shotgun/beanbag(src)

/obj/item/storage/box/lethalslugs
	name = "box of 12g shotgun slugs"
	desc = "A box full of lethal 12g slug, designed for riot shotguns."
	icon_state = "12g_box"
	illustration = null

/obj/item/storage/box/lethalslugs/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun(src)

/obj/item/storage/box/stunslug
	name = "box of stun slugs"
	desc = "A box full of stun 12g slugs."
	icon_state = "stunslug_box"
	illustration = null

/obj/item/storage/box/stunslug/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun/stunslug(src)

/obj/item/storage/box/techsslug
	name = "box of tech shotgun shells"
	desc = "A box full of tech shotgun shells."
	icon_state = "techslug_box"
	illustration = null

/obj/item/storage/box/techsslug/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun/techshell(src)

/obj/item/storage/box/fireshot
	name = "box of incendiary ammo"
	desc = "A box full of incendiary ammo."
	icon_state = "fireshot_box"
	illustration = null

/obj/item/storage/box/fireshot/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun/incendiary(src)

/obj/item/storage/box/actionfigure
	name = "box of action figures"
	desc = "The latest set of collectable action figures."
	icon_state = "box"

/obj/item/storage/box/actionfigure/PopulateContents()
	for(var/i in 1 to 4)
		var/randomFigure = pick(subtypesof(/obj/item/toy/figure))
		new randomFigure(src)

/obj/item/storage/box/mechfigures
	name = "box of mech figures"
	desc = "The latest set of collectable mech figures."
	icon_state = "box"

/obj/item/storage/box/mechfigures/PopulateContents()
	for(var/i in 1 to 4)
		var/randomFigure = pick(subtypesof(/obj/item/toy/mecha))
		new randomFigure(src)




/obj/item/storage/box/papersack
	name = "paper sack"
	desc = "A sack neatly crafted out of paper."
	icon_state = "paperbag_None"
	item_state = "paperbag_None"
	resistance_flags = FLAMMABLE
	foldable = null
	/// A list of all available papersack reskins
	var/list/papersack_designs = list()

/obj/item/storage/box/papersack/Initialize(mapload)
	. = ..()
	papersack_designs = sort_list(list(
		"None" = image(icon = src.icon, icon_state = "paperbag_None"),
		"NanotrasenStandard" = image(icon = src.icon, icon_state = "paperbag_NanotrasenStandard"),
		"SyndiSnacks" = image(icon = src.icon, icon_state = "paperbag_SyndiSnacks"),
		"Heart" = image(icon = src.icon, icon_state = "paperbag_Heart"),
		"SmileyFace" = image(icon = src.icon, icon_state = "paperbag_SmileyFace")
		))

/obj/item/storage/box/papersack/update_icon_state()
	if(contents.len == 0)
		icon_state = "[item_state]"
	else
		icon_state = "[item_state]_closed"


/obj/item/storage/box/papersack/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/pen))
		var/choice = show_radial_menu(user, src , papersack_designs, custom_check = CALLBACK(src, PROC_REF(check_menu), user, W), radius = 36, require_near = TRUE)
		if(!choice)
			return FALSE
		if(icon_state == "paperbag_[choice]")
			return FALSE
		switch(choice)
			if("None")
				desc = "A sack neatly crafted out of paper."
			if("NanotrasenStandard")
				desc = "A standard Nanotrasen paper lunch sack for loyal employees on the go."
			if("SyndiSnacks")
				desc = "The design on this paper sack is a remnant of the notorious 'SyndieSnacks' program."
			if("Heart")
				desc = "A paper sack with a heart etched onto the side."
			if("SmileyFace")
				desc = "A paper sack with a crude smile etched onto the side."
			else
				return FALSE
		to_chat(user, "<span class='notice'>You make some modifications to [src] using your pen.</span>")
		icon_state = "paperbag_[choice]"
		item_state = "paperbag_[choice]"
		return FALSE
	else if(W.get_sharpness())
		if(!contents.len)
			if(item_state == "paperbag_None")
				user.show_message("<span class='notice'>You cut eyeholes into [src].</span>", MSG_VISUAL)
				new /obj/item/clothing/head/papersack(user.loc)
				qdel(src)
				return FALSE
			else if(item_state == "paperbag_SmileyFace")
				user.show_message("<span class='notice'>You cut eyeholes into [src] and modify the design.</span>", MSG_VISUAL)
				new /obj/item/clothing/head/papersack/smiley(user.loc)
				qdel(src)
				return FALSE
	return ..()

/**
  * check_menu: Checks if we are allowed to interact with a radial menu
  *
  * Arguments:
  * * user The mob interacting with a menu
  * * P The pen used to interact with a menu
  */
/obj/item/storage/box/papersack/proc/check_menu(mob/user, obj/item/pen/P)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	if(contents.len)
		to_chat(user, "<span class='warning'>You can't modify [src] with items still inside!</span>")
		return FALSE
	if(!P || !user.is_holding(P))
		to_chat(user, "<span class='warning'>You need a pen to modify [src]!</span>")
		return FALSE
	return TRUE

/obj/item/storage/box/ingredients //This box is for the randomly chosen version the chef spawns with, it shouldn't actually exist.
	name = "ingredients box"
	illustration = "fruit"
	var/theme_name

/obj/item/storage/box/ingredients/Initialize(mapload)
	. = ..()
	if(theme_name)
		name = "[name] ([theme_name])"
		desc = "A box containing supplementary ingredients for the aspiring chef. The box's theme is '[theme_name]'."
		item_state = "syringe_kit"

/obj/item/storage/box/ingredients/wildcard
	theme_name = "wildcard"

/obj/item/storage/box/ingredients/wildcard/PopulateContents()
	for(var/i in 1 to 7)
		var/randomFood = pick(/obj/item/reagent_containers/food/snacks/grown/chili,
							  /obj/item/reagent_containers/food/snacks/grown/tomato,
							  /obj/item/reagent_containers/food/snacks/grown/carrot,
							  /obj/item/reagent_containers/food/snacks/grown/potato,
							  /obj/item/reagent_containers/food/snacks/grown/potato/sweet,
							  /obj/item/reagent_containers/food/snacks/grown/apple,
							  /obj/item/reagent_containers/food/snacks/chocolatebar,
							  /obj/item/reagent_containers/food/snacks/grown/cherries,
							  /obj/item/reagent_containers/food/snacks/grown/berries,
							  /obj/item/reagent_containers/food/snacks/grown/banana,
							  /obj/item/reagent_containers/food/snacks/grown/cabbage,
							  /obj/item/reagent_containers/food/snacks/grown/soybeans,
							  /obj/item/reagent_containers/food/snacks/grown/corn,
							  /obj/item/reagent_containers/food/snacks/grown/mushroom/plumphelmet,
							  /obj/item/reagent_containers/food/snacks/grown/mushroom/chanterelle,
							  /obj/item/reagent_containers/food/snacks/meatball,
							  /obj/item/reagent_containers/food/snacks/grown/citrus/orange,
							  /obj/item/reagent_containers/food/snacks/grown/citrus/lemon,
							  /obj/item/reagent_containers/food/snacks/grown/citrus/lime,
							  /obj/item/reagent_containers/food/snacks/grown/bluecherries,
							  /obj/item/reagent_containers/food/snacks/grown/cocoapod,
							  /obj/item/reagent_containers/food/snacks/grown/vanillapod,
							  /obj/item/reagent_containers/food/snacks/grown/grapes,
							  /obj/item/reagent_containers/food/snacks/grown/strawberry,
							  /obj/item/reagent_containers/food/snacks/grown/whitebeet,
							  /obj/item/reagent_containers/food/snacks/meat/slab/bear,
							  /obj/item/reagent_containers/food/snacks/meat/slab/spider,
							  /obj/item/reagent_containers/food/snacks/spidereggs,
							  /obj/item/reagent_containers/food/snacks/carpmeat,
							  /obj/item/reagent_containers/food/snacks/meat/slab/xeno,
							  /obj/item/reagent_containers/food/snacks/meat/slab/corgi,
							  /obj/item/reagent_containers/food/snacks/grown/oat,
							  /obj/item/reagent_containers/food/snacks/grown/wheat,
							  /obj/item/reagent_containers/honeycomb,
							  /obj/item/reagent_containers/food/snacks/grown/watermelon,
							  /obj/item/reagent_containers/food/snacks/grown/onion,
							  /obj/item/reagent_containers/food/snacks/grown/peach,
							  /obj/item/reagent_containers/food/snacks/grown/peanut,
							  /obj/item/reagent_containers/food/snacks/grown/pineapple,
							  /obj/item/reagent_containers/food/snacks/grown/pumpkin,
							  /obj/item/reagent_containers/food/snacks/meat/rawcrab,
							  /obj/item/reagent_containers/food/snacks/meat/slab/goliath,
							  /obj/item/reagent_containers/food/snacks/meat/slab/chicken,
							  /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/slime,
							  /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/golem,
							  /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/lizard,
							  /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/skeleton,
							  /obj/item/reagent_containers/food/snacks/egg,
							  /obj/item/reagent_containers/food/snacks/grown/eggplant)
		new randomFood(src)

/obj/item/storage/box/ingredients/fiesta
	theme_name = "fiesta"

/obj/item/storage/box/ingredients/fiesta/PopulateContents()
	new /obj/item/reagent_containers/food/snacks/tortilla(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/food/snacks/grown/corn(src)
		new /obj/item/reagent_containers/food/snacks/grown/soybeans(src)
		new /obj/item/reagent_containers/food/snacks/grown/chili(src)

/obj/item/storage/box/ingredients/italian
	theme_name = "italian"

/obj/item/storage/box/ingredients/italian/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/food/snacks/grown/tomato(src)
		new /obj/item/reagent_containers/food/snacks/meatball(src)
	new /obj/item/reagent_containers/food/drinks/bottle/wine(src)

/obj/item/storage/box/ingredients/vegetarian
	theme_name = "vegetarian"

/obj/item/storage/box/ingredients/vegetarian/PopulateContents()
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/food/snacks/grown/carrot(src)
	new /obj/item/reagent_containers/food/snacks/grown/eggplant(src)
	new /obj/item/reagent_containers/food/snacks/grown/potato(src)
	new /obj/item/reagent_containers/food/snacks/grown/apple(src)
	new /obj/item/reagent_containers/food/snacks/grown/corn(src)
	new /obj/item/reagent_containers/food/snacks/grown/tomato(src)

/obj/item/storage/box/ingredients/american
	theme_name = "american"

/obj/item/storage/box/ingredients/american/PopulateContents()
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/food/snacks/grown/potato(src)
		new /obj/item/reagent_containers/food/snacks/grown/tomato(src)
		new /obj/item/reagent_containers/food/snacks/grown/corn(src)
	new /obj/item/reagent_containers/food/snacks/meatball(src)

/obj/item/storage/box/ingredients/fruity
	theme_name = "fruity"

/obj/item/storage/box/ingredients/fruity/PopulateContents()
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/food/snacks/grown/apple(src)
		new /obj/item/reagent_containers/food/snacks/grown/citrus/orange(src)
	new /obj/item/reagent_containers/food/snacks/grown/citrus/lemon(src)
	new /obj/item/reagent_containers/food/snacks/grown/citrus/lime(src)
	new /obj/item/reagent_containers/food/snacks/grown/watermelon(src)

/obj/item/storage/box/ingredients/sweets
	theme_name = "sweets"

/obj/item/storage/box/ingredients/sweets/PopulateContents()
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/food/snacks/grown/cherries(src)
		new /obj/item/reagent_containers/food/snacks/grown/banana(src)
	new /obj/item/reagent_containers/food/snacks/chocolatebar(src)
	new /obj/item/reagent_containers/food/snacks/grown/cocoapod(src)
	new /obj/item/reagent_containers/food/snacks/grown/apple(src)

/obj/item/storage/box/ingredients/delights
	theme_name = "delights"

/obj/item/storage/box/ingredients/delights/PopulateContents()
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/food/snacks/grown/potato/sweet(src)
		new /obj/item/reagent_containers/food/snacks/grown/bluecherries(src)
	new /obj/item/reagent_containers/food/snacks/grown/vanillapod(src)
	new /obj/item/reagent_containers/food/snacks/grown/cocoapod(src)
	new /obj/item/reagent_containers/food/snacks/grown/berries(src)

/obj/item/storage/box/ingredients/grains
	theme_name = "grains"

/obj/item/storage/box/ingredients/grains/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/food/snacks/grown/oat(src)
	new /obj/item/reagent_containers/food/snacks/grown/wheat(src)
	new /obj/item/reagent_containers/food/snacks/grown/cocoapod(src)
	new /obj/item/reagent_containers/honeycomb(src)
	new /obj/item/seeds/poppy(src)

/obj/item/storage/box/ingredients/carnivore
	theme_name = "carnivore"

/obj/item/storage/box/ingredients/carnivore/PopulateContents()
	new /obj/item/reagent_containers/food/snacks/meat/slab/bear(src)
	new /obj/item/reagent_containers/food/snacks/meat/slab/spider(src)
	new /obj/item/reagent_containers/food/snacks/spidereggs(src)
	new /obj/item/reagent_containers/food/snacks/carpmeat(src)
	new /obj/item/reagent_containers/food/snacks/meat/slab/xeno(src)
	new /obj/item/reagent_containers/food/snacks/meat/slab/corgi(src)
	new /obj/item/reagent_containers/food/snacks/meatball(src)

/obj/item/storage/box/ingredients/exotic
	theme_name = "exotic"

/obj/item/storage/box/ingredients/exotic/PopulateContents()
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/food/snacks/carpmeat(src)
		new /obj/item/reagent_containers/food/snacks/grown/soybeans(src)
		new /obj/item/reagent_containers/food/snacks/grown/cabbage(src)
	new /obj/item/reagent_containers/food/snacks/grown/chili(src)

/obj/item/storage/box/ingredients/sushi
	theme_name = "sushi"

/obj/item/storage/box/ingredients/sushi/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/food/snacks/sea_weed(src)
		new /obj/item/reagent_containers/food/snacks/carpmeat(src)
	new /obj/item/reagent_containers/food/snacks/meat/rawcrab(src)

/obj/item/storage/box/emptysandbags
	name = "box of empty sandbags"

/obj/item/storage/box/emptysandbags/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/emptysandbag(src)

/obj/item/storage/box/rndboards
	name = "\proper the liberator's legacy"
	desc = "A box containing a gift for worthy golems."

/obj/item/storage/box/rndboards/PopulateContents()
	new /obj/item/circuitboard/machine/protolathe(src)
	new /obj/item/circuitboard/machine/destructive_analyzer(src)
	new /obj/item/circuitboard/machine/circuit_imprinter(src)
	new /obj/item/circuitboard/computer/rdconsole(src)

/obj/item/storage/box/silver_sulf
	name = "box of silver sulfadiazine patches"
	desc = "Contains patches used to treat burns."

/obj/item/storage/box/silver_sulf/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/pill/patch/silver_sulf(src)

/obj/item/storage/box/fountainpens
	name = "box of fountain pens"

/obj/item/storage/box/fountainpens/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/pen/fountain(src)

/obj/item/storage/box/holy_grenades
	name = "box of holy hand grenades"
	desc = "Contains several grenades used to rapidly purge heresy."
	illustration = "flashbang"

/obj/item/storage/box/holy_grenades/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/grenade/chem_grenade/holy(src)

/obj/item/storage/box/stockparts/basic //for ruins where it's a bad idea to give access to an autolathe/protolathe, but still want to make stock parts accessible
	name = "box of stock parts"
	desc = "Contains a variety of basic stock parts."

/obj/item/storage/box/stockparts/basic/PopulateContents()
	new /obj/item/stock_parts/capacitor(src)
	new /obj/item/stock_parts/capacitor(src)
	new /obj/item/stock_parts/capacitor(src)
	new /obj/item/stock_parts/scanning_module(src)
	new /obj/item/stock_parts/scanning_module(src)
	new /obj/item/stock_parts/scanning_module(src)
	new /obj/item/stock_parts/manipulator(src)
	new /obj/item/stock_parts/manipulator(src)
	new /obj/item/stock_parts/manipulator(src)
	new /obj/item/stock_parts/micro_laser(src)
	new /obj/item/stock_parts/micro_laser(src)
	new /obj/item/stock_parts/micro_laser(src)
	new /obj/item/stock_parts/matter_bin(src)
	new /obj/item/stock_parts/matter_bin(src)
	new /obj/item/stock_parts/matter_bin(src)

/obj/item/storage/box/stockparts/deluxe
	name = "box of deluxe stock parts"
	desc = "Contains a variety of deluxe stock parts."
	icon_state = "syndiebox"

/obj/item/storage/box/stockparts/deluxe/PopulateContents()
	new /obj/item/stock_parts/capacitor/quadratic(src)
	new /obj/item/stock_parts/capacitor/quadratic(src)
	new /obj/item/stock_parts/capacitor/quadratic(src)
	new /obj/item/stock_parts/scanning_module/triphasic(src)
	new /obj/item/stock_parts/scanning_module/triphasic(src)
	new /obj/item/stock_parts/scanning_module/triphasic(src)
	new /obj/item/stock_parts/manipulator/femto(src)
	new /obj/item/stock_parts/manipulator/femto(src)
	new /obj/item/stock_parts/manipulator/femto(src)
	new /obj/item/stock_parts/micro_laser/quadultra(src)
	new /obj/item/stock_parts/micro_laser/quadultra(src)
	new /obj/item/stock_parts/micro_laser/quadultra(src)
	new /obj/item/stock_parts/matter_bin/bluespace(src)
	new /obj/item/stock_parts/matter_bin/bluespace(src)
	new /obj/item/stock_parts/matter_bin/bluespace(src)

//Colored boxes.
/obj/item/storage/box/green
	icon_state = "box_green"
	illustration = null

/obj/item/storage/box/blue
	icon_state = "box_blue"
	illustration = null

/obj/item/storage/box/purple
	icon_state = "box_purple"
	illustration = null

/obj/item/storage/box/red
	icon_state = "box_red"
	illustration = null

/obj/item/storage/box/yellow
	icon_state = "box_yellow"
	illustration = null

/obj/item/storage/box/brown
	icon_state = "box_brown"
	illustration = null

/obj/item/storage/box/pink
	icon_state = "box_pink"
	illustration = null

/obj/item/storage/box/emergencytank
	name = "emergency oxygen tank box"
	desc = "A box of emergency oxygen tanks."
	illustration = "emergencytank"

/obj/item/storage/box/emergencytank/PopulateContents()
	..()
	for(var/i in 1 to 7)
		new /obj/item/tank/internals/emergency_oxygen(src) //in case anyone ever wants to do anything with spawning them, apart from crafting the box

/obj/item/storage/box/engitank
	name = "extended-capacity emergency oxygen tank box"
	desc = "A box of extended-capacity emergency oxygen tanks."
	illustration = "extendedtank"

/obj/item/storage/box/engitank/PopulateContents()
	..()
	for(var/i in 1 to 7)
		new /obj/item/tank/internals/emergency_oxygen/engi(src) //in case anyone ever wants to do anything with spawning them, apart from crafting the box

/obj/item/storage/box/mre //base MRE type.
	name = "Genesis MRE Ration Kit Menu 0" //GS13 - Nanotrasen to Genesis
	desc = "A package containing food suspended in an outdated bluespace pocket which lasts for centuries. If you're lucky you may even be able to enjoy the meal without getting food poisoning."
	icon_state = "mre"
	illustration = null
	var/can_expire = TRUE
	var/spawner_chance = 2
	var/expiration_date
	var/expiration_date_min = 2300
	var/expiration_date_max = 2700

/obj/item/storage/box/mre/Initialize(mapload)
	. = ..()
	if(can_expire)
		expiration_date = rand(expiration_date_min, expiration_date_max)
		desc += "\n<span_clas='notice'>An expiry date is listed on it. It reads: [expiration_date]</span>"
		var/spess_current_year = GLOB.year_integer
		if(expiration_date < spess_current_year)
			var/gross_risk = min(round(spess_current_year - expiration_date * 0.1), 1)
			var/toxic_risk = min(round(spess_current_year - expiration_date * 0.01), 1)
			for(var/obj/item/reagent_containers/food/snacks/S in contents)
				if(prob(gross_risk))
					S.foodtype |= GROSS
				if(prob(toxic_risk))
					S.foodtype |= TOXIC

/obj/item/storage/box/mre/menu1
	name = "\improper Genesis MRE Ration Kit Menu 1" //GS13 - Nanotrasen to Genesis

/obj/item/storage/box/mre/menu1/safe
	desc = "A package containing food suspended in a bluespace pocket capable of lasting till the end of time."
	spawner_chance = 0
	can_expire = FALSE

/obj/item/storage/box/mre/menu1/PopulateContents()
	new /obj/item/reagent_containers/food/snacks/breadslice/plain(src)
	new /obj/item/reagent_containers/food/snacks/breadslice/creamcheese(src)
	new /obj/item/reagent_containers/food/condiment/pack/ketchup(src)
	new /obj/item/reagent_containers/food/snacks/chocolatebar(src)
	new /obj/item/tank/internals/emergency_oxygen(src)

/obj/item/storage/box/mre/menu2
	name = "\improper Genesis MRE Ration Kit Menu 2" //GS13 - Nanotrasen to Genesis

/obj/item/storage/box/mre/menu2/safe
	spawner_chance = 0
	desc = "A package containing food suspended in a bluespace pocket capable of lasting till the end of time."
	can_expire = FALSE

/obj/item/storage/box/mre/menu2/PopulateContents()
	new /obj/item/reagent_containers/food/snacks/omelette(src)
	new /obj/item/reagent_containers/food/snacks/meat/cutlet/plain(src)
	new /obj/item/reagent_containers/food/snacks/fries(src)
	new /obj/item/reagent_containers/food/snacks/chocolatebar(src)
	new /obj/item/tank/internals/emergency_oxygen(src)

/obj/item/storage/box/mre/menu3
	name = "\improper Genesis MRE Ration Kit Menu 3" //GS13 - Nanotrasen to Genesis
	desc = "The holy grail of MREs. This item contains the fabled MRE pizza, spicy nachos and a sample of coffee instant type 2. Any GT employee lucky enough to get their hands on one of these is truly blessed." //GS13 - NT to GT
	icon_state = "menu3"
	can_expire = FALSE //always fresh, never expired.
	spawner_chance = 1

/obj/item/storage/box/mre/menu3/PopulateContents()
	new /obj/item/reagent_containers/food/snacks/pizzaslice/pepperoni(src)
	new /obj/item/reagent_containers/food/snacks/breadslice/plain(src)
	new /obj/item/reagent_containers/food/snacks/cubannachos(src)
	new /obj/item/reagent_containers/food/snacks/grown/chili(src)
	new /obj/item/reagent_containers/food/drinks/coffee/type2(src)
	new /obj/item/tank/internals/emergency_oxygen(src)

/obj/item/storage/box/mre/menu4
	name = "\improper Genesis MRE Ration Kit Menu 4" //GS13 - Nanotrasen to Genesis

/obj/item/storage/box/mre/menu4/safe
	spawner_chance = 0
	desc = "A package containing food suspended in a bluespace pocket capable of lasting till the end of time."
	can_expire = FALSE

/obj/item/storage/box/mre/menu4/PopulateContents()
	if(prob(66))
		new /obj/item/reagent_containers/food/snacks/salad/boiledrice(src)
	else
		new /obj/item/reagent_containers/food/snacks/salad/ricebowl(src)
	new /obj/item/reagent_containers/food/snacks/burger/tofu(src)
	new /obj/item/reagent_containers/food/snacks/salad/fruit(src)
	new /obj/item/reagent_containers/food/snacks/cracker(src)
	new /obj/item/tank/internals/emergency_oxygen(src)

//Where do I put this?
/obj/item/secbat
	name = "Secbat box"
	desc = "Contained inside is a secbat for use with law enforcement."
	icon = 'icons/obj/storage.dmi'
	icon_state = "box"
	item_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'

/obj/item/secbat/attack_self(mob/user)
	new /mob/living/simple_animal/hostile/retaliate/bat/secbat(user.loc)
	to_chat(user, "<span class='notice'>You open the box, releasing the secbat!</span>")
	var/obj/item/stack/sheet/cardboard/I = new(user.drop_location())
	qdel(src)
	user.put_in_hands(I)

/obj/item/storage/box/marshmallow
	name = "box of marshmallows"
	desc = "A box of marshmallows."
	illustration = "marshmallow"
	custom_premium_price = PRICE_BELOW_NORMAL

/obj/item/storage/box/marshmallow/PopulateContents()
	for (var/i in 1 to 5)
		new /obj/item/reagent_containers/food/snacks/marshmallow(src)

/obj/item/storage/box/material/PopulateContents() 	//less uranium because radioactive
	var/static/items_inside = list(
		/obj/item/stack/sheet/metal/fifty=1,\
		/obj/item/stack/sheet/glass/fifty=1,\
		/obj/item/stack/sheet/rglass=50,\
		/obj/item/stack/sheet/plasmaglass=50,\
		/obj/item/stack/sheet/titaniumglass=50,\
		/obj/item/stack/sheet/plastitaniumglass=50,\
		/obj/item/stack/sheet/plasteel=50,\
		/obj/item/stack/sheet/mineral/plastitanium=50,\
		/obj/item/stack/sheet/mineral/titanium=50,\
		/obj/item/stack/sheet/mineral/gold=50,\
		/obj/item/stack/sheet/mineral/silver=50,\
		/obj/item/stack/sheet/mineral/plasma=50,\
		/obj/item/stack/sheet/mineral/uranium=50,\
		/obj/item/stack/sheet/mineral/diamond=50,\
		/obj/item/stack/sheet/bluespace_crystal=50,\
		/obj/item/stack/sheet/mineral/bananium=50,\
		/obj/item/stack/sheet/mineral/wood=50,\
		/obj/item/stack/sheet/plastic/fifty=1,\
		/obj/item/stack/sheet/runed_metal/fifty=1
		)
	generate_items_inside(items_inside, src)

/obj/item/storage/box/debugtools
	name = "box of debug tools"
	icon_state = "syndiebox"

/obj/item/storage/box/debugtools/PopulateContents()
	var/static/items_inside = list(
		/obj/item/flashlight/emp/debug=1,\
		/obj/item/pda=1,\
		/obj/item/modular_computer/tablet/preset/advanced=1,\
		/obj/item/geiger_counter=1,\
		/obj/item/construction/rcd/combat/admin=1,\
		/obj/item/pipe_dispenser=1,\
		/obj/item/card/emag=1,\
		/obj/item/healthanalyzer/advanced=1,\
		/obj/item/disk/tech_disk/debug=1,\
		/obj/item/uplink/debug=1,\
		/obj/item/uplink/nuclear/debug=1,\
		/obj/item/storage/box/beakers/bluespace=1,\
		/obj/item/storage/box/beakers/variety=1,\
		/obj/item/storage/box/material=1,\
		/obj/item/storage/belt/medical/surgery_belt_adv=1
		)
	generate_items_inside(items_inside, src)

/obj/item/storage/box/beakers/variety
	name = "beaker variety box"

/obj/item/storage/box/beakers/variety/PopulateContents()
	new /obj/item/reagent_containers/glass/beaker(src)
	new /obj/item/reagent_containers/glass/beaker/large(src)
	new /obj/item/reagent_containers/glass/beaker/plastic(src)
	new /obj/item/reagent_containers/glass/beaker/meta(src)
	new /obj/item/reagent_containers/glass/beaker/noreact(src)
	new /obj/item/reagent_containers/glass/beaker/bluespace(src)

/obj/item/storage/box/strange_seeds_5pack

/obj/item/storage/box/strange_seeds_5pack/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/seeds/random(src)

/obj/item/storage/box/shipping
	name = "box of shipping supplies"
	desc = "Contains several scanners and labelers for shipping things. Wrapping Paper not included."
	illustration = "shipping"

/obj/item/storage/box/shipping/PopulateContents()
	var/static/items_inside = list(
		/obj/item/dest_tagger=1,\
		/obj/item/sales_tagger=1,\
		/obj/item/export_scanner=1,\
		/obj/item/stack/packageWrap/small=2,\
		/obj/item/stack/wrapping_paper/small=1
		)
	generate_items_inside(items_inside,src)
