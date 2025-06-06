/datum/action/changeling/sting//parent path, not meant for users afaik
	name = "Tiny Prick"
	desc = "Stabby stabby"
	var/sting_icon = null

/datum/action/changeling/sting/Trigger()
	var/mob/user = owner
	if(!user || !user.mind)
		return
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	if(!changeling)
		return
	if(!changeling.chosen_sting)
		set_sting(user)
	else
		unset_sting(user)
	return

/datum/action/changeling/sting/proc/set_sting(mob/user)
	to_chat(user, "<span class='notice'>We prepare our sting, use Alt+click or click the middle mouse button on a target to sting them.</span>")
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	changeling.chosen_sting = src

	user.hud_used.lingstingdisplay.icon_state = sting_icon
	user.hud_used.lingstingdisplay.invisibility = 0

/datum/action/changeling/sting/proc/unset_sting(mob/user)
	to_chat(user, "<span class='warning'>We retract our sting, we can't sting anyone for now.</span>")
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	changeling.chosen_sting = null

	user.hud_used.lingstingdisplay.icon_state = null
	user.hud_used.lingstingdisplay.invisibility = INVISIBILITY_ABSTRACT

/mob/living/carbon/proc/unset_sting()
	if(mind)
		var/datum/antagonist/changeling/changeling = mind.has_antag_datum(/datum/antagonist/changeling)
		if(changeling && changeling.chosen_sting)
			changeling.chosen_sting.unset_sting(src)

/datum/action/changeling/sting/can_sting(mob/user, mob/target)
	if(!..())
		return
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	if(!changeling.chosen_sting)
		to_chat(user, "We haven't prepared our sting yet!")
	if(!iscarbon(target))
		return
	if(!isturf(user.loc))
		return
	if(!length(get_path_to(user, target, max_distance = changeling.sting_range, simulated_only = FALSE)))
		return // no path within the sting's range is found. what a weird place to use the pathfinding system
	if(target.mind && target.mind.has_antag_datum(/datum/antagonist/changeling))
		sting_feedback(user, target)
		changeling.chem_charges -= chemical_cost
	return TRUE

/datum/action/changeling/sting/sting_feedback(mob/user, mob/target)
	if(!target)
		return
	to_chat(user, "<span class='notice'>We stealthily sting [target.name].</span>")
	if(target.mind && target.mind.has_antag_datum(/datum/antagonist/changeling))
		to_chat(target, "<span class='warning'>You feel a tiny prick.</span>")
	return TRUE


/datum/action/changeling/sting/transformation
	name = "Temporary Transformation Sting"
	desc = "We silently sting a human, injecting a chemical that forces them to transform into a chosen being for a limited time. Additional stings extend the duration. Costs 10 chemicals."
	helptext = "The victim will transform much like a changeling would for a limited time. Does not provide a warning to others. Mutations will not be transferred, and monkeys will become human. This ability is loud, and might cause our blood to react violently to heat."
	button_icon_state = "sting_transform"
	sting_icon = "sting_transform"
	chemical_cost = 10
	dna_cost = 2
	loudness = 1
	var/datum/changelingprofile/selected_dna = null

/datum/action/changeling/sting/transformation/Trigger()
	var/mob/user = owner
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	if(changeling.chosen_sting)
		unset_sting(user)
		return
	selected_dna = changeling.select_dna()
	if(!selected_dna)
		return
	if(NOTRANSSTING in selected_dna.dna.species.species_traits)
		to_chat(user, "<span class = 'notice'>That DNA is not compatible with changeling retrovirus!</span>")
		return
	..()

/datum/action/changeling/sting/transformation/can_sting(mob/user, mob/living/carbon/target)
	if(!..())
		return
	if((HAS_TRAIT(target, TRAIT_HUSK)) || !iscarbon(target) || (NOTRANSSTING in target.dna.species.species_traits))
		to_chat(user, "<span class='warning'>Our sting appears ineffective against its DNA.</span>")
		return FALSE
	return TRUE

/datum/action/changeling/sting/transformation/sting_action(mob/user, mob/target)
	if(ismonkey(target))
		to_chat(user, "<span class='notice'>Our genes cry out as we sting [target.name]!</span>")

	var/mob/living/carbon/C = target
	. = TRUE
	if(istype(C))
		if(C.reagents.has_reagent(/datum/reagent/changeling_string))
			C.reagents.add_reagent(/datum/reagent/changeling_string,120)
			log_combat(user, target, "stung", "transformation sting", ", extending the duration.")
		else
			C.reagents.add_reagent(/datum/reagent/changeling_string,120,list("desired_dna" = selected_dna.dna))
			log_combat(user, target, "stung", "transformation sting", " new identity is '[selected_dna.dna.real_name]'")

/datum/action/changeling/sting/false_armblade
	name = "False Armblade Sting"
	desc = "We silently sting a human, injecting a retrovirus that mutates their arm to temporarily appear as an armblade. Costs 20 chemicals."
	helptext = "The victim will form an armblade much like a changeling would, except the armblade is dull and useless. This ability is somewhat loud, and carries a small risk of our blood gaining violent sensitivity to heat."
	button_icon_state = "sting_armblade"
	sting_icon = "sting_armblade"
	chemical_cost = 20
	dna_cost = 1
	loudness = 1

/obj/item/melee/arm_blade/false
	desc = "A grotesque mass of flesh that used to be your arm. Although it looks dangerous at first, you can tell it's actually quite dull and useless."
	force = 5 //Basically as strong as a punch
	fake = TRUE

/datum/action/changeling/sting/false_armblade/can_sting(mob/user, mob/target)
	if(!..())
		return
	if(isliving(target))
		var/mob/living/L = target
		if((HAS_TRAIT(L, TRAIT_HUSK)) || !L.has_dna())
			to_chat(user, "<span class='warning'>Our sting appears ineffective against its DNA.</span>")
			return FALSE
	return TRUE

/datum/action/changeling/sting/false_armblade/sting_action(mob/user, mob/target)
	log_combat(user, target, "stung", object="false armblade sting")

	var/obj/item/held = target.get_active_held_item()
	if(held && !target.dropItemToGround(held))
		to_chat(user, "<span class='warning'>[held] is stuck to [target.p_their()] hand, you cannot grow a false armblade over it!</span>")
		return

	if(ismonkey(target))
		to_chat(user, "<span class='notice'>Our genes cry out as we sting [target.name]!</span>")

	var/obj/item/melee/arm_blade/false/blade = new(target,1)
	target.put_in_hands(blade)
	target.visible_message("<span class='warning'>A grotesque blade forms around [target.name]'s arm!</span>", "<span class='userdanger'>Your arm twists and mutates, transforming into a horrific monstrosity!</span>", "<span class='italics'>You hear organic matter ripping and tearing!</span>")
	playsound(target, 'sound/effects/blobattack.ogg', 30, 1)

	addtimer(CALLBACK(src, PROC_REF(remove_fake), target, blade), 600)
	return TRUE

/datum/action/changeling/sting/false_armblade/proc/remove_fake(mob/target, obj/item/melee/arm_blade/false/blade)
	playsound(target, 'sound/effects/blobattack.ogg', 30, 1)
	target.visible_message("<span class='warning'>With a sickening crunch, \
	[target] reforms [target.p_their()] [blade.name] into an arm!</span>",
	"<span class='warning'>[blade] reforms back to normal.</span>",
	"<span class='italics>You hear organic matter ripping and tearing!</span>")

	qdel(blade)
	target.update_inv_hands()

/datum/action/changeling/sting/extract_dna
	name = "Extract DNA Sting"
	desc = "We stealthily sting a target and extract their DNA. Costs 25 chemicals."
	helptext = "Will give you the DNA of your target, allowing you to transform into them."
	button_icon_state = "sting_extract"
	sting_icon = "sting_extract"
	chemical_cost = 25
	dna_cost = 0

/datum/action/changeling/sting/extract_dna/can_sting(mob/user, mob/target)
	if(..())
		var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
		return changeling.can_absorb_dna(target)

/datum/action/changeling/sting/extract_dna/sting_action(mob/user, mob/living/carbon/human/target)
	log_combat(user, target, "stung", "extraction sting")
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	if(!(changeling.has_dna(target.dna)))
		changeling.add_new_profile(target)
	if(target.reagents)
		target.reagents.add_reagent(/datum/reagent/consumable/lipoifier, 30)
	return TRUE

/datum/action/changeling/sting/mute
	name = "Mute Sting"
	desc = "We silently sting a human, completely silencing them for a short time. Costs 20 chemicals."
	helptext = "Does not provide a warning to the victim that they have been stung, until they try to speak and cannot. This ability is loud, and might cause our blood to react violently to heat."
	button_icon_state = "sting_mute"
	sting_icon = "sting_mute"
	chemical_cost = 20
	dna_cost = 2
	loudness = 2

/datum/action/changeling/sting/mute/sting_action(mob/user, mob/living/carbon/target)
	log_combat(user, target, "stung", "mute sting")
	target.silent += 30
	return TRUE

/datum/action/changeling/sting/blind
	name = "Blind Sting"
	desc = "Temporarily blinds the target. Costs 25 chemicals."
	helptext = "This sting completely blinds a target for a short time. This ability is somewhat loud, and carries a small risk of our blood gaining violent sensitivity to heat."
	button_icon_state = "sting_blind"
	sting_icon = "sting_blind"
	chemical_cost = 25
	dna_cost = 1
	loudness = 1

/datum/action/changeling/sting/blind/sting_action(mob/user, mob/living/carbon/target)
	log_combat(user, target, "stung", "blind sting")
	to_chat(target, "<span class='danger'>Your eyes burn horrifically!</span>")
	target.become_nearsighted(EYE_DAMAGE)
	target.blind_eyes(20)
	target.blur_eyes(40)
	return TRUE

/datum/action/changeling/sting/LSD
	name = "Hallucination Sting"
	desc = "Causes terror in the target and deals a minor amount of toxin damage. Costs 10 chemicals."
	helptext = "We evolve the ability to sting a target with a powerful toxic hallucinogenic chemical. The target does not notice they have been stung, and the effect begins instantaneously. This ability is somewhat loud, and carries a small risk of our blood gaining violent sensitivity to heat."
	button_icon_state = "sting_lsd"
	sting_icon = "sting_lsd"
	chemical_cost = 10
	dna_cost = 1
	loudness = 1

/datum/action/changeling/sting/LSD/sting_action(mob/user, mob/target)
	log_combat(user, target, "stung", "LSD sting")
	if(target.reagents)
		target.reagents.add_reagent(/datum/reagent/blob/regenerative_materia, 5)
		target.reagents.add_reagent(/datum/reagent/toxin/mindbreaker, 5)
	return TRUE

/datum/action/changeling/sting/cryo
	name = "Cryogenic Sting"
	desc = "We silently sting our victim with a cocktail of chemicals that freezes them from the inside. Costs 15 chemicals."
	helptext = "Does not provide a warning to the victim, though they will likely realize they are suddenly freezing. This ability is somewhat loud, and carries a small risk of our blood gaining violent sensitivity to heat."
	button_icon_state = "sting_cryo"
	sting_icon = "sting_cryo"
	chemical_cost = 15
	dna_cost = 2
	loudness = 1

/datum/action/changeling/sting/cryo/sting_action(mob/user, mob/target)
	log_combat(user, target, "stung", "fatty sting")
	if(target.reagents)
		target.reagents.add_reagent(/datum/reagent/consumable/lipoifier, 30)
	return TRUE
