GLOBAL_LIST_EMPTY(allCasters)

/obj/item/wallframe/newscaster
	name = "newscaster frame"
	desc = "Used to build newscasters, just secure to the wall."
	icon_state = "newscaster"
	custom_materials = list(/datum/material/iron=14000, /datum/material/glass=8000)
	result_path = /obj/machinery/newscaster

/obj/machinery/newscaster
	name = "newscaster"
	desc = "A standard Genesis-licensed newsfeed handler for use in commercial space stations. All the news you absolutely have no use for, in one place!" //GS13 - Nanotrasen to Genesis
	icon = 'icons/obj/terminals.dmi'
	icon_state = "newscaster_normal"
	plane = ABOVE_WALL_PLANE
	verb_say = "beeps"
	verb_ask = "beeps"
	verb_exclaim = "beeps"
	armor = list(MELEE = 50, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 30)
	max_integrity = 200
	integrity_failure = 0.25
	var/screen = 0
	var/paper_remaining = 15
	var/securityCaster = 0
	var/unit_no = 0
	var/alert_delay = 500
	var/alert = FALSE
	var/scanned_user = "Unknown"
	var/msg = ""
	var/datum/picture/picture
	var/channel_name = ""
	var/c_locked=0
	var/datum/news/feed_channel/viewing_channel = null
	var/allow_comments = 1

/obj/machinery/newscaster/security_unit
	name = "security newscaster"
	securityCaster = 1

/obj/machinery/newscaster/Initialize(mapload, ndir, building)
	. = ..()
	if(building)
		setDir(ndir)
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -32 : 32)
		pixel_y = (dir & 3)? (dir ==1 ? -32 : 32) : 0

	GLOB.allCasters += src
	unit_no = GLOB.allCasters.len
	update_icon()

/obj/machinery/newscaster/Destroy()
	GLOB.allCasters -= src
	viewing_channel = null
	picture = null
	return ..()

/obj/machinery/newscaster/update_icon_state()
	if(machine_stat & (NOPOWER|BROKEN))
		icon_state = "newscaster_off"
	else
		if(GLOB.news_network.wanted_issue.active)
			icon_state = "newscaster_wanted"
		else
			icon_state = "newscaster_normal"

/obj/machinery/newscaster/update_overlays()
	. = ..()

	if(!(machine_stat & (NOPOWER|BROKEN)) && !GLOB.news_network.wanted_issue.active && alert)
		. += "newscaster_alert"

	var/hp_percent = obj_integrity * 100 /max_integrity
	switch(hp_percent)
		if(75 to 100)
			return
		if(50 to 75)
			. += "crack1"
		if(25 to 50)
			. += "crack2"
		else
			. += "crack3"

/obj/machinery/newscaster/power_change()
	if(machine_stat & BROKEN)
		return
	if(powered())
		machine_stat &= ~NOPOWER
		update_icon()
	else
		spawn(rand(0, 15))
			machine_stat |= NOPOWER
			update_icon()

/obj/machinery/newscaster/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	update_icon()

/obj/machinery/newscaster/attack_ghost(mob/dead/observer/user)
	if(istype(user))
		user.read_news()

/obj/machinery/newscaster/ui_interact(mob/user)
	. = ..()
	if(ishuman(user) || issilicon(user))
		var/mob/living/human_or_robot_user = user
		var/dat
		scan_user(human_or_robot_user)
		switch(screen)
			if(0) //GS13 - Nanotrasen to Genesis
				dat += "Welcome to Newscasting Unit #[unit_no].<BR> Interface & News networks Operational."
				dat += "<BR><FONT SIZE=1>Property of Genesis Inc</FONT>"
				if(GLOB.news_network.wanted_issue.active)
					dat+= "<HR><A href='?src=[REF(src)];view_wanted=1'>Read Wanted Issue</A>"
				dat+= "<HR><BR><A href='?src=[REF(src)];create_channel=1'>Create Feed Channel</A>"
				dat+= "<BR><A href='?src=[REF(src)];view=1'>View Feed Channels</A>"
				dat+= "<BR><A href='?src=[REF(src)];create_feed_story=1'>Submit new Feed story</A>"
				dat+= "<BR><A href='?src=[REF(src)];menu_paper=1'>Print newspaper</A>"
				dat+= "<BR><A href='?src=[REF(src)];refresh=1'>Re-scan User</A>"
				dat+= "<BR><BR><A href='?src=[REF(human_or_robot_user)];mach_close=newscaster_main'>Exit</A>"
				if(securityCaster) //GS13 - Nanotrasen to Genesis
					var/wanted_already = 0
					if(GLOB.news_network.wanted_issue.active)
						wanted_already = 1
					dat+="<HR><B>Feed Security functions:</B><BR>"
					dat+="<BR><A href='?src=[REF(src)];menu_wanted=1'>[(wanted_already) ? ("Manage") : ("Publish")] \"Wanted\" Issue</A>"
					dat+="<BR><A href='?src=[REF(src)];menu_censor_story=1'>Censor Feed Stories</A>"
					dat+="<BR><A href='?src=[REF(src)];menu_censor_channel=1'>Mark Feed Channel with Genesis D-Notice</A>"
				dat+="<BR><HR>The newscaster recognises you as: <FONT COLOR='green'>[scanned_user]</FONT>"
			if(1)
				dat+= "Station Feed Channels<HR>"
				if( isemptylist(GLOB.news_network.network_channels) )
					dat+="<I>No active channels found...</I>"
				else
					for(var/datum/news/feed_channel/CHANNEL in GLOB.news_network.network_channels)
						if(CHANNEL.is_admin_channel)
							dat+="<B><FONT style='BACKGROUND-COLOR: LightGreen '><A href='?src=[REF(src)];show_channel=[REF(CHANNEL)]'>[CHANNEL.channel_name]</A></FONT></B><BR>"
						else
							dat+="<B><A href='?src=[REF(src)];show_channel=[REF(CHANNEL)]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : ""]<BR></B>"
				dat+="<BR><HR><A href='?src=[REF(src)];refresh=1'>Refresh</A>"
				dat+="<BR><A href='?src=[REF(src)];setScreen=[0]'>Back</A>"
			if(2)
				dat+="Creating new Feed Channel..."
				dat+="<HR><B><A href='?src=[REF(src)];set_channel_name=1'>Channel Name</A>:</B> [channel_name]<BR>"
				dat+="<B>Channel Author:</B> <FONT COLOR='green'>[scanned_user]</FONT><BR>"
				dat+="<B><A href='?src=[REF(src)];set_channel_lock=1'>Will Accept Public Feeds</A>:</B> [(c_locked) ? ("NO") : ("YES")]<BR><BR>"
				dat+="<BR><A href='?src=[REF(src)];submit_new_channel=1'>Submit</A><BR><BR><A href='?src=[REF(src)];setScreen=[0]'>Cancel</A><BR>"
			if(3)
				dat+="Creating new Feed Message..."
				dat+="<HR><B><A href='?src=[REF(src)];set_channel_receiving=1'>Receiving Channel</A>:</B> [channel_name]<BR>"
				dat+="<B>Message Author:</B> <FONT COLOR='green'>[scanned_user]</FONT><BR>"
				dat+="<B><A href='?src=[REF(src)];set_new_message=1'>Message Body</A>:</B> <BR><font face=\"[PEN_FONT]\">[parsemarkdown(msg, user)]</font><BR>"
				dat+="<B><A href='?src=[REF(src)];set_attachment=1'>Attach Photo</A>:</B>  [(picture ? "Photo Attached" : "No Photo")]</BR>"
				dat+="<B><A href='?src=[REF(src)];set_comment=1'>Comments [allow_comments ? "Enabled" : "Disabled"]</A></B><BR>"
				dat+="<BR><A href='?src=[REF(src)];submit_new_message=1'>Submit</A><BR><BR><A href='?src=[REF(src)];setScreen=[0]'>Cancel</A><BR>"
			if(4)
				dat+="Feed story successfully submitted to [channel_name].<BR><BR>"
				dat+="<BR><A href='?src=[REF(src)];setScreen=[0]'>Return</A><BR>"
			if(5)
				dat+="Feed Channel [channel_name] created successfully.<BR><BR>"
				dat+="<BR><A href='?src=[REF(src)];setScreen=[0]'>Return</A><BR>"
			if(6)
				dat+="<B><FONT COLOR='maroon'>ERROR: Could not submit Feed story to Network.</B></FONT><HR><BR>"
				if(channel_name=="")
					dat+="<FONT COLOR='maroon'>Invalid receiving channel name.</FONT><BR>"
				if(scanned_user=="Unknown")
					dat+="<FONT COLOR='maroon'>Channel author unverified.</FONT><BR>"
				if(msg == "" || msg == "\[REDACTED\]")
					dat+="<FONT COLOR='maroon'>Invalid message body.</FONT><BR>"
				dat+="<BR><A href='?src=[REF(src)];setScreen=[3]'>Return</A><BR>"
			if(7)
				dat+="<B><FONT COLOR='maroon'>ERROR: Could not submit Feed Channel to Network.</B></FONT><HR><BR>"
				var/list/existing_authors = list()
				for(var/datum/news/feed_channel/FC in GLOB.news_network.network_channels)
					if(FC.authorCensor)
						existing_authors += GLOB.news_network.redactedText
					else
						existing_authors += FC.author
				if(scanned_user in existing_authors)
					dat+="<FONT COLOR='maroon'>There is already a Feed channel under your name.</FONT><BR>"
				if(channel_name=="" || channel_name == "\[REDACTED\]")
					dat+="<FONT COLOR='maroon'>Invalid channel name.</FONT><BR>"
				var/check = 0
				for(var/datum/news/feed_channel/FC in GLOB.news_network.network_channels)
					if(FC.channel_name == channel_name)
						check = 1
						break
				if(check)
					dat+="<FONT COLOR='maroon'>Channel name already in use.</FONT><BR>"
				if(scanned_user=="Unknown")
					dat+="<FONT COLOR='maroon'>Channel author unverified.</FONT><BR>"
				dat+="<BR><A href='?src=[REF(src)];setScreen=[2]'>Return</A><BR>"
			if(8)
				var/total_num=length(GLOB.news_network.network_channels)
				var/active_num=total_num
				var/message_num=0
				for(var/datum/news/feed_channel/FC in GLOB.news_network.network_channels)
					if(!FC.censored)
						message_num += length(FC.messages)
					else
						active_num--
				dat+="Network currently serves a total of [total_num] Feed channels, [active_num] of which are active, and a total of [message_num] Feed Stories."
				dat+="<BR><BR><B>Liquid Paper remaining:</B> [(paper_remaining) *100 ] cm^3"
				dat+="<BR><BR><A href='?src=[REF(src)];print_paper=[0]'>Print Paper</A>"
				dat+="<BR><A href='?src=[REF(src)];setScreen=[0]'>Cancel</A>"
			if(9)
				dat+="<B>[viewing_channel.channel_name]: </B><FONT SIZE=1>\[created by: <FONT COLOR='maroon'>[viewing_channel.returnAuthor(-1)]</FONT>\]</FONT><HR>"
				if(viewing_channel.censored)
					dat+="<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatening to the welfare of the station, and marked with a Genesis D-Notice.<BR>"
					dat+="No further feed story additions are allowed while the D-Notice is in effect.</FONT><BR><BR>"
				else
					if( isemptylist(viewing_channel.messages) )
						dat+="<I>No feed messages found in channel...</I><BR>"
					else
						var/i = 0
						for(var/datum/news/feed_message/MESSAGE in viewing_channel.messages)
							i++
							dat+="-[MESSAGE.returnBody(-1)] <BR>"
							if(MESSAGE.img)
								usr << browse_rsc(MESSAGE.img, "tmp_photo[i].png")
								dat+="<img src='tmp_photo[i].png' width = '180'><BR>"
								if(MESSAGE.caption)
									dat+="[MESSAGE.caption]<BR>"
								dat+="<BR>"
							dat+="<FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.returnAuthor(-1)] </FONT>\] - ([MESSAGE.time_stamp])</FONT><BR>"
							dat+="<b><font size=1>[MESSAGE.comments.len] comment[MESSAGE.comments.len > 1 ? "s" : ""]</font></b><br>"
							for(var/datum/news/feed_comment/comment in MESSAGE.comments)
								dat+="<font size=1><small>[comment.body]</font><br><font size=1><small><small><small>[comment.author] [comment.time_stamp]</small></small></small></small></font><br>"
							if(MESSAGE.locked)
								dat+="<b>Comments locked</b><br>"
							else
								dat+="<a href='?src=[REF(src)];new_comment=[REF(MESSAGE)]'>Comment</a><br>"
				dat+="<BR><HR><A href='?src=[REF(src)];refresh=1'>Refresh</A>"
				dat+="<BR><A href='?src=[REF(src)];setScreen=[1]'>Back</A>"
			if(10) //GS13 - Nanotrasen to Genesis
				dat+="<B>Genesis Feed Censorship Tool</B><BR>"
				dat+="<FONT SIZE=1>NOTE: Due to the nature of news Feeds, total deletion of a Feed Story is not possible.<BR>"
				dat+="Keep in mind that users attempting to view a censored feed will instead see the \[REDACTED\] tag above it.</FONT>"
				dat+="<HR>Select Feed channel to get Stories from:<BR>"
				if(isemptylist(GLOB.news_network.network_channels))
					dat+="<I>No feed channels found active...</I><BR>"
				else
					for(var/datum/news/feed_channel/CHANNEL in GLOB.news_network.network_channels)
						dat+="<A href='?src=[REF(src)];pick_censor_channel=[REF(CHANNEL)]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : ""]<BR>"
				dat+="<BR><A href='?src=[REF(src)];setScreen=[0]'>Cancel</A>"
			if(11) //GS13 - Nanotrasen to Genesis
				dat+="<B>Genesis D-Notice Handler</B><HR>"
				dat+="<FONT SIZE=1>A D-Notice is to be bestowed upon the channel if the handling Authority deems it as harmful for the station's"
				dat+="morale, integrity or disciplinary behaviour. A D-Notice will render a channel unable to be updated by anyone, without deleting any feed"
				dat+="stories it might contain at the time. You can lift a D-Notice if you have the required access at any time.</FONT><HR>"
				if(isemptylist(GLOB.news_network.network_channels))
					dat+="<I>No feed channels found active...</I><BR>"
				else
					for(var/datum/news/feed_channel/CHANNEL in GLOB.news_network.network_channels)
						dat+="<A href='?src=[REF(src)];pick_d_notice=[REF(CHANNEL)]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : ""]<BR>"
				dat+="<BR><A href='?src=[REF(src)];setScreen=[0]'>Back</A>"
			if(12)
				dat+="<B>[viewing_channel.channel_name]: </B><FONT SIZE=1>\[ created by: <FONT COLOR='maroon'>[viewing_channel.returnAuthor(-1)]</FONT> \]</FONT><BR>"
				dat+="<FONT SIZE=2><A href='?src=[REF(src)];censor_channel_author=[REF(viewing_channel)]'>[(viewing_channel.authorCensor) ? ("Undo Author censorship") : ("Censor channel Author")]</A></FONT><HR>"
				if(isemptylist(viewing_channel.messages))
					dat+="<I>No feed messages found in channel...</I><BR>"
				else
					for(var/datum/news/feed_message/MESSAGE in viewing_channel.messages)
						dat+="-[MESSAGE.returnBody(-1)] <BR><FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.returnAuthor(-1)]</FONT>\]</FONT><BR>"
						dat+="<FONT SIZE=2><A href='?src=[REF(src)];censor_channel_story_body=[REF(MESSAGE)]'>[(MESSAGE.bodyCensor) ? ("Undo story censorship") : ("Censor story")]</A>  -  <A href='?src=[REF(src)];censor_channel_story_author=[REF(MESSAGE)]'>[(MESSAGE.authorCensor) ? ("Undo Author Censorship") : ("Censor message Author")]</A></FONT><BR>"
						dat+="[MESSAGE.comments.len] comment[MESSAGE.comments.len > 1 ? "s" : ""]: <a href='?src=[REF(src)];lock_comment=[REF(MESSAGE)]'>[MESSAGE.locked ? "Unlock" : "Lock"]</a><br>"
						for(var/datum/news/feed_comment/comment in MESSAGE.comments)
							dat+="[comment.body] <a href='?src=[REF(src)];del_comment=[REF(comment)];del_comment_msg=[REF(MESSAGE)]'>X</a><br><font size=1>[comment.author] [comment.time_stamp]</font><br>"
				dat+="<BR><A href='?src=[REF(src)];setScreen=[10]'>Back</A>"
			if(13)
				dat+="<B>[viewing_channel.channel_name]: </B><FONT SIZE=1>\[ created by: <FONT COLOR='maroon'>[viewing_channel.returnAuthor(-1)]</FONT> \]</FONT><BR>"
				dat+="Channel messages listed below. If you deem them dangerous to the station, you can <A href='?src=[REF(src)];toggle_d_notice=[REF(viewing_channel)]'>Bestow a D-Notice upon the channel</A>.<HR>"
				if(viewing_channel.censored)
					dat+="<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatening to the welfare of the station, and marked with a Genesis D-Notice.<BR>"
					dat+="No further feed story additions are allowed while the D-Notice is in effect.</FONT><BR><BR>"
				else
					if(isemptylist(viewing_channel.messages))
						dat+="<I>No feed messages found in channel...</I><BR>"
					else
						for(var/datum/news/feed_message/MESSAGE in viewing_channel.messages)
							dat+="-[MESSAGE.returnBody(-1)] <BR><FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.returnAuthor(-1)]</FONT>\]</FONT><BR>"
				dat+="<BR><A href='?src=[REF(src)];setScreen=[11]'>Back</A>"
			if(14)
				dat+="<B>Wanted Issue Handler:</B>"
				var/wanted_already = 0
				var/end_param = 1
				if(GLOB.news_network.wanted_issue.active)
					wanted_already = 1
					end_param = 2
				if(wanted_already)
					dat+="<FONT SIZE=2><BR><I>A wanted issue is already in Feed Circulation. You can edit or cancel it below.</FONT></I>"
				dat+="<HR>"
				dat+="<A href='?src=[REF(src)];set_wanted_name=1'>Criminal Name</A>: [channel_name] <BR>"
				dat+="<A href='?src=[REF(src)];set_wanted_desc=1'>Description</A>: [msg] <BR>"
				dat+="<A href='?src=[REF(src)];set_attachment=1'>Attach Photo</A>: [(picture ? "Photo Attached" : "No Photo")]</BR>"
				if(wanted_already)
					dat+="<B>Wanted Issue created by:</B><FONT COLOR='green'>[GLOB.news_network.wanted_issue.scannedUser]</FONT><BR>"
				else
					dat+="<B>Wanted Issue will be created under prosecutor:</B><FONT COLOR='green'>[scanned_user]</FONT><BR>"
				dat+="<BR><A href='?src=[REF(src)];submit_wanted=[end_param]'>[(wanted_already) ? ("Edit Issue") : ("Submit")]</A>"
				if(wanted_already)
					dat+="<BR><A href='?src=[REF(src)];cancel_wanted=1'>Take down Issue</A>"
				dat+="<BR><A href='?src=[REF(src)];setScreen=[0]'>Cancel</A>"
			if(15)
				dat+="<FONT COLOR='green'>Wanted issue for [channel_name] is now in Network Circulation.</FONT><BR><BR>"
				dat+="<BR><A href='?src=[REF(src)];setScreen=[0]'>Return</A><BR>"
			if(16)
				dat+="<B><FONT COLOR='maroon'>ERROR: Wanted Issue rejected by Network.</B></FONT><HR><BR>"
				if(channel_name=="" || channel_name == "\[REDACTED\]")
					dat+="<FONT COLOR='maroon'>Invalid name for person wanted.</FONT><BR>"
				if(scanned_user=="Unknown")
					dat+="<FONT COLOR='maroon'>Issue author unverified.</FONT><BR>"
				if(msg == "" || msg == "\[REDACTED\]")
					dat+="<FONT COLOR='maroon'>Invalid description.</FONT><BR>"
				dat+="<BR><A href='?src=[REF(src)];setScreen=[0]'>Return</A><BR>"
			if(17)
				dat+="<B>Wanted Issue successfully deleted from Circulation</B><BR>"
				dat+="<BR><A href='?src=[REF(src)];setScreen=[0]'>Return</A><BR>"
			if(18)
				if(GLOB.news_network.wanted_issue.active)
					dat+="<B><FONT COLOR ='maroon'>-- STATIONWIDE WANTED ISSUE --</B></FONT><BR><FONT SIZE=2>\[Submitted by: <FONT COLOR='green'>[GLOB.news_network.wanted_issue.scannedUser]</FONT>\]</FONT><HR>"
					dat+="<B>Criminal</B>: [GLOB.news_network.wanted_issue.criminal]<BR>"
					dat+="<B>Description</B>: [GLOB.news_network.wanted_issue.body]<BR>"
					dat+="<B>Photo:</B>: "
					if(GLOB.news_network.wanted_issue.img)
						usr << browse_rsc(GLOB.news_network.wanted_issue.img, "tmp_photow.png")
						dat+="<BR><img src='tmp_photow.png' width = '180'>"
					else
						dat+="None"
				else
					dat+="No current wanted issue found.<BR><BR>"
				dat+="<BR><BR><A href='?src=[REF(src)];setScreen=[0]'>Back</A><BR>"
			if(19)
				dat+="<FONT COLOR='green'>Wanted issue for [channel_name] successfully edited.</FONT><BR><BR>"
				dat+="<BR><A href='?src=[REF(src)];setScreen=[0]'>Return</A><BR>"
			if(20)
				dat+="<FONT COLOR='green'>Printing successful. Please receive your newspaper from the bottom of the machine.</FONT><BR><BR>"
				dat+="<A href='?src=[REF(src)];setScreen=[0]'>Return</A>"
			if(21)
				dat+="<FONT COLOR='maroon'>Unable to print newspaper. Insufficient paper. Please notify maintenance personnel to refill machine storage.</FONT><BR><BR>"
				dat+="<A href='?src=[REF(src)];setScreen=[0]'>Return</A>"
		var/datum/browser/popup = new(human_or_robot_user, "newscaster_main", "Newscaster Unit #[unit_no]", 400, 600)
		popup.set_content(dat)
		popup.open()

/obj/machinery/newscaster/Topic(href, href_list)
	if(..())
		return
	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1) && isturf(loc))) || hasSiliconAccessInArea(usr))
		usr.set_machine(src)
		scan_user(usr)
		if(href_list["set_channel_name"])
			channel_name = stripped_input(usr, "Provide a Feed Channel Name", "Network Channel Handler", "", MAX_NAME_LEN)
			updateUsrDialog()
		else if(href_list["set_channel_lock"])
			c_locked = !c_locked
			updateUsrDialog()
		else if(href_list["submit_new_channel"])
			var/list/existing_authors = list()
			for(var/datum/news/feed_channel/FC in GLOB.news_network.network_channels)
				if(FC.authorCensor)
					existing_authors += GLOB.news_network.redactedText
				else
					existing_authors += FC.author
			var/check = 0
			for(var/datum/news/feed_channel/FC in GLOB.news_network.network_channels)
				if(FC.channel_name == channel_name)
					check = 1
					break
			if(channel_name == "" || channel_name == "\[REDACTED\]" || scanned_user == "Unknown" || check || (scanned_user in existing_authors) )
				screen=7
			else
				var/choice = alert("Please confirm Feed channel creation","Network Channel Handler","Confirm","Cancel")
				if(choice=="Confirm")
					scan_user(usr)
					GLOB.news_network.CreateFeedChannel(channel_name, scanned_user, c_locked)
					SSblackbox.record_feedback("text", "newscaster_channels", 1, "[channel_name]")
					screen=5
			updateUsrDialog()
		else if(href_list["set_channel_receiving"])
			var/list/available_channels = list()
			for(var/datum/news/feed_channel/F in GLOB.news_network.network_channels)
				if( (!F.locked || F.author == scanned_user) && !F.censored)
					available_channels += F.channel_name
			channel_name = input(usr, "Choose receiving Feed Channel", "Network Channel Handler") in available_channels
			updateUsrDialog()
		else if(href_list["set_new_message"])
			var/temp_message = trim(stripped_multiline_input(usr, "Write your Feed story", "Network Channel Handler", msg))
			if(temp_message)
				msg = temp_message
				updateUsrDialog()
		else if(href_list["set_attachment"])
			AttachPhoto(usr)
			updateUsrDialog()
		else if(href_list["submit_new_message"])
			if(msg =="" || msg=="\[REDACTED\]" || scanned_user == "Unknown" || channel_name == "" )
				screen=6
			else
				GLOB.news_network.SubmitArticle("<font face=\"[PEN_FONT]\">[parsemarkdown(msg, usr)]</font>", scanned_user, channel_name, picture, 0, allow_comments)
				SSblackbox.record_feedback("amount", "newscaster_stories", 1)
				screen=4
				msg = ""
			updateUsrDialog()
		else if(href_list["create_channel"])
			screen=2
			updateUsrDialog()
		else if(href_list["create_feed_story"])
			screen=3
			updateUsrDialog()
		else if(href_list["menu_paper"])
			screen=8
			updateUsrDialog()
		else if(href_list["print_paper"])
			if(!paper_remaining)
				screen=21
			else
				print_paper()
				screen = 20
			updateUsrDialog()
		else if(href_list["menu_censor_story"])
			screen=10
			updateUsrDialog()
		else if(href_list["menu_censor_channel"])
			screen=11
			updateUsrDialog()
		else if(href_list["menu_wanted"])
			var/already_wanted = 0
			if(GLOB.news_network.wanted_issue.active)
				already_wanted = 1
			if(already_wanted)
				channel_name = GLOB.news_network.wanted_issue.criminal
				msg = GLOB.news_network.wanted_issue.body
			screen = 14
			updateUsrDialog()
		else if(href_list["set_wanted_name"])
			channel_name = stripped_input(usr, "Provide the name of the Wanted person", "Network Security Handler")
			updateUsrDialog()
		else if(href_list["set_wanted_desc"])
			msg = stripped_input(usr, "Provide a description of the Wanted person and any other details you deem important", "Network Security Handler")
			updateUsrDialog()
		else if(href_list["submit_wanted"])
			var/input_param = text2num(href_list["submit_wanted"])
			if(msg == "" || channel_name == "" || scanned_user == "Unknown")
				screen = 16
			else
				var/choice = alert("Please confirm Wanted Issue [(input_param==1) ? ("creation.") : ("edit.")]","Network Security Handler","Confirm","Cancel")
				if(choice=="Confirm")
					scan_user(usr)
					if(input_param==1)          //If input_param == 1 we're submitting a new wanted issue. At 2 we're just editing an existing one.
						GLOB.news_network.submitWanted(channel_name, msg, scanned_user, picture, 0 , 1)
						screen = 15
					else
						if(GLOB.news_network.wanted_issue.isAdminMsg)
							alert("The wanted issue has been distributed by a Genesis higherup. You cannot edit it.","Ok") //GS13 - Nanotrasen to Genesis
							return
						GLOB.news_network.submitWanted(channel_name, msg, scanned_user, picture)
						screen = 19
			updateUsrDialog()
		else if(href_list["cancel_wanted"])
			if(GLOB.news_network.wanted_issue.isAdminMsg)
				alert("The wanted issue has been distributed by a Genesis higherup. You cannot take it down.","Ok") //GS13 - Nanotrasen to Genesis
				return
			var/choice = alert("Please confirm Wanted Issue removal","Network Security Handler","Confirm","Cancel")
			if(choice=="Confirm")
				GLOB.news_network.deleteWanted()
				screen=17
			updateUsrDialog()
		else if(href_list["view_wanted"])
			screen=18
			updateUsrDialog()
		else if(href_list["censor_channel_author"])
			var/datum/news/feed_channel/FC = locate(href_list["censor_channel_author"])
			if(FC.is_admin_channel)
				alert("This channel was created by a Genesis Officer. You cannot censor it.","Ok") //GS13 - Nanotrasen to Genesis
				return
			FC.toggleCensorAuthor()
			updateUsrDialog()
		else if(href_list["censor_channel_story_author"])
			var/datum/news/feed_message/MSG = locate(href_list["censor_channel_story_author"])
			if(MSG.is_admin_message)
				alert("This message was created by a Genesis Officer. You cannot censor its author.","Ok") //GS13 - Nanotrasen to Genesis
				return
			MSG.toggleCensorAuthor()
			updateUsrDialog()
		else if(href_list["censor_channel_story_body"])
			var/datum/news/feed_message/MSG = locate(href_list["censor_channel_story_body"])
			if(MSG.is_admin_message)
				alert("This channel was created by a Genesis Officer. You cannot censor it.","Ok") //GS13 - Nanotrasen to Genesis
				return
			MSG.toggleCensorBody()
			updateUsrDialog()
		else if(href_list["pick_d_notice"])
			var/datum/news/feed_channel/FC = locate(href_list["pick_d_notice"])
			viewing_channel = FC
			screen=13
			updateUsrDialog()
		else if(href_list["toggle_d_notice"])
			var/datum/news/feed_channel/FC = locate(href_list["toggle_d_notice"])
			if(FC.is_admin_channel)
				alert("This channel was created by a Genesis Officer. You cannot place a D-Notice upon it.","Ok") //GS13 - Nanotrasen to Genesis
				return
			FC.toggleCensorDclass()
			updateUsrDialog()
		else if(href_list["view"])
			screen=1
			updateUsrDialog()
		else if(href_list["setScreen"])
			screen = text2num(href_list["setScreen"])
			if (screen == 0)
				scanned_user = "Unknown";
				msg = "";
				c_locked=0;
				channel_name="";
				viewing_channel = null
			updateUsrDialog()
		else if(href_list["show_channel"])
			var/datum/news/feed_channel/FC = locate(href_list["show_channel"])
			viewing_channel = FC
			screen = 9
			updateUsrDialog()
		else if(href_list["pick_censor_channel"])
			var/datum/news/feed_channel/FC = locate(href_list["pick_censor_channel"])
			viewing_channel = FC
			screen = 12
			updateUsrDialog()
		else if(href_list["new_comment"])
			var/datum/news/feed_message/FM = locate(href_list["new_comment"])
			var/cominput = copytext_char(stripped_input(usr, "Write your message:", "New comment", null), 140)
			if(cominput)
				scan_user(usr)
				var/datum/news/feed_comment/FC = new/datum/news/feed_comment
				FC.author = scanned_user
				FC.body = cominput
				FC.time_stamp = STATION_TIME_TIMESTAMP("hh:mm:ss", world.time)
				FM.comments += FC
				usr.log_message("(as [scanned_user]) commented on message [FM.returnBody(-1)] -- [FC.body]", LOG_COMMENT)
			updateUsrDialog()
		else if(href_list["del_comment"])
			var/datum/news/feed_comment/FC = locate(href_list["del_comment"])
			var/datum/news/feed_message/FM = locate(href_list["del_comment_msg"])
			if(istype(FC) && istype(FM))
				FM.comments -= FC
				qdel(FC)
				updateUsrDialog()
		else if(href_list["lock_comment"])
			var/datum/news/feed_message/FM = locate(href_list["lock_comment"])
			FM.locked ^= 1
			updateUsrDialog()
		else if(href_list["set_comment"])
			allow_comments ^= 1
			updateUsrDialog()
		else if(href_list["refresh"])
			updateUsrDialog()

/obj/machinery/newscaster/attackby(obj/item/I, mob/living/user, params)
	if(I.tool_behaviour == TOOL_WRENCH)
		to_chat(user, "<span class='notice'>You start [anchored ? "un" : ""]securing [name]...</span>")
		I.play_tool_sound(src)
		if(I.use_tool(src, user, 60))
			playsound(loc, 'sound/items/deconstruct.ogg', 50, 1)
			if(machine_stat & BROKEN)
				to_chat(user, "<span class='warning'>The broken remains of [src] fall on the ground.</span>")
				new /obj/item/stack/sheet/metal(loc, 5)
				new /obj/item/shard(loc)
				new /obj/item/shard(loc)
			else
				to_chat(user, "<span class='notice'>You [anchored ? "un" : ""]secure [name].</span>")
				new /obj/item/wallframe/newscaster(loc)
			qdel(src)
	else if(I.tool_behaviour == TOOL_WELDER && user.a_intent != INTENT_HARM)
		if(machine_stat & BROKEN)
			if(!I.tool_start_check(user, amount=0))
				return
			user.visible_message("[user] is repairing [src].", \
							"<span class='notice'>You begin repairing [src]...</span>", \
							"<span class='italics'>You hear welding.</span>")
			if(I.use_tool(src, user, 40, volume=50))
				if(!(machine_stat & BROKEN))
					return
				to_chat(user, "<span class='notice'>You repair [src].</span>")
				obj_integrity = max_integrity
				machine_stat &= ~BROKEN
				update_icon()
		else
			to_chat(user, "<span class='notice'>[src] does not need repairs.</span>")
	else
		return ..()

/obj/machinery/newscaster/play_attack_sound(damage, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(machine_stat & BROKEN)
				playsound(loc, 'sound/effects/hit_on_shattered_glass.ogg', 100, 1)
			else
				playsound(loc, 'sound/effects/glasshit.ogg', 90, 1)
		if(BURN)
			playsound(src.loc, 'sound/items/welder.ogg', 100, 1)


/obj/machinery/newscaster/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stack/sheet/metal(loc, 2)
		new /obj/item/shard(loc)
		new /obj/item/shard(loc)
	qdel(src)

/obj/machinery/newscaster/obj_break()
	if(!(machine_stat & BROKEN) && !(flags_1 & NODECONSTRUCT_1))
		machine_stat |= BROKEN
		playsound(loc, 'sound/effects/glassbr3.ogg', 100, 1)
		update_icon()


/obj/machinery/newscaster/attack_paw(mob/user)
	if(user.a_intent != INTENT_HARM)
		to_chat(user, "<span class='warning'>The newscaster controls are far too complicated for your tiny brain!</span>")
	else
		take_damage(5, BRUTE, MELEE)

/obj/machinery/newscaster/proc/AttachPhoto(mob/user)
	var/obj/item/photo/photo = user.is_holding_item_of_type(/obj/item/photo)
	if(photo)
		picture = photo.picture
	if(issilicon(user))
		var/obj/item/camera/siliconcam/targetcam
		if(isAI(user))
			var/mob/living/silicon/ai/R = user
			targetcam = R.aicamera
		else if(iscyborg(user))
			var/mob/living/silicon/robot/R = user
			if(R.connected_ai)
				targetcam = R.connected_ai.aicamera
			else
				targetcam = R.aicamera
		else
			to_chat(user, "<span class='warning'>You cannot interface with silicon photo uploading!</span>")
		if(!targetcam.stored.len)
			to_chat(usr, "<span class='boldannounce'>No images saved</span>")
			return
		var/datum/picture/selection = targetcam.selectpicture(user)
		if(selection)
			picture = selection

/obj/machinery/newscaster/proc/scan_user(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(human_user.wear_id)
			if(istype(human_user.wear_id, /obj/item/pda))
				var/obj/item/pda/P = human_user.wear_id
				if(P.id)
					scanned_user = "[P.id.registered_name] ([P.id.assignment])"
				else
					scanned_user = "Unknown"
			else if(istype(human_user.wear_id, /obj/item/card/id) )
				var/obj/item/card/id/ID = human_user.wear_id
				scanned_user ="[ID.registered_name] ([ID.assignment])"
			else
				scanned_user ="Unknown"
		else
			scanned_user ="Unknown"
	else if(issilicon(user))
		var/mob/living/silicon/ai_user = user
		scanned_user = "[ai_user.name] ([ai_user.job])"
	else
		CRASH("Invalid user for this proc")

/obj/machinery/newscaster/proc/print_paper()
	SSblackbox.record_feedback("amount", "newspapers_printed", 1)
	var/obj/item/newspaper/NEWSPAPER = new /obj/item/newspaper
	for(var/datum/news/feed_channel/FC in GLOB.news_network.network_channels)
		NEWSPAPER.news_content += FC
	if(GLOB.news_network.wanted_issue.active)
		NEWSPAPER.wantedAuthor = GLOB.news_network.wanted_issue.scannedUser
		NEWSPAPER.wantedCriminal = GLOB.news_network.wanted_issue.criminal
		NEWSPAPER.wantedBody = GLOB.news_network.wanted_issue.body
		if(GLOB.news_network.wanted_issue.img)
			NEWSPAPER.wantedPhoto = GLOB.news_network.wanted_issue.img
	NEWSPAPER.forceMove(drop_location())
	NEWSPAPER.creationTime = GLOB.news_network.lastAction
	paper_remaining--

/obj/machinery/newscaster/proc/remove_alert()
	alert = FALSE
	update_icon()

/obj/machinery/newscaster/proc/newsAlert(channel)
	if(channel)
		say("Breaking news from [channel]!")
		alert = TRUE
		update_icon()
		addtimer(CALLBACK(src,PROC_REF(remove_alert)),alert_delay,TIMER_UNIQUE|TIMER_OVERRIDE)
		playsound(loc, 'sound/machines/twobeep.ogg', 75, 1)
	else
		say("Attention! Wanted issue distributed!")
		playsound(loc, 'sound/machines/warning-buzzer.ogg', 75, 1)
