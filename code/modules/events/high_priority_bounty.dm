/datum/round_event_control/high_priority_bounty
	name = "High Priority Bounty"
	typepath = /datum/round_event/high_priority_bounty
	max_occurrences = 6 //GS13 - because why not
	weight = 20
	earliest_start = 10 MINUTES
	category = EVENT_CATEGORY_BUREAUCRATIC
	description = "Creates bounties that are three times original worth."

/datum/round_event/high_priority_bounty/announce(fake)
	priority_announce("Central Command has issued a high-priority cargo bounty. Details have been sent to all bounty consoles.", "Genesis Bounty Program") //GS13 - Nanotrasen to Genesis

/datum/round_event/high_priority_bounty/start()
	var/datum/bounty/B
	for(var/attempts = 0; attempts < 50; ++attempts)
		B = random_bounty()
		if(!B)
			continue
		B.mark_high_priority(3)
		if(try_add_bounty(B))
			break

