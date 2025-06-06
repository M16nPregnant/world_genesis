#define SIGNAL_TRAIT(trait_ref) "trait [trait_ref]"

// trait accessor defines
#define ADD_TRAIT(target, trait, source) \
	do { \
		var/list/_L; \
		if (!target.status_traits) { \
			target.status_traits = list(); \
			_L = target.status_traits; \
			_L[trait] = list(source); \
			SEND_SIGNAL(target, SIGNAL_TRAIT(trait), COMPONENT_ADD_TRAIT); \
		} else { \
			_L = target.status_traits; \
			if (_L[trait]) { \
				_L[trait] |= list(source); \
			} else { \
				_L[trait] = list(source); \
				SEND_SIGNAL(target, SIGNAL_TRAIT(trait), COMPONENT_ADD_TRAIT); \
			} \
		} \
	} while (0)
#define REMOVE_TRAIT(target, trait, sources) \
	do { \
		var/list/_L = target.status_traits; \
		var/list/_S; \
		if (sources && !islist(sources)) { \
			_S = list(sources); \
		} else { \
			_S = sources\
		}; \
		if (_L && _L[trait]) { \
			for (var/_T in _L[trait]) { \
				if ((!_S && (_T != ROUNDSTART_TRAIT)) || (_T in _S)) { \
					_L[trait] -= _T \
				} \
			};\
			if (!length(_L[trait])) { \
				_L -= trait; \
				SEND_SIGNAL(target, SIGNAL_TRAIT(trait), COMPONENT_REMOVE_TRAIT); \
			}; \
			if (!length(_L)) { \
				target.status_traits = null \
			}; \
		} \
	} while (0)
#define REMOVE_TRAITS_NOT_IN(target, sources) \
	do { \
		var/list/_L = target.status_traits; \
		var/list/_S = sources; \
		if (_L) { \
			for (var/_T in _L) { \
				_L[_T] &= _S;\
				if (!length(_L[_T])) { \
					_L -= _T ; \
					SEND_SIGNAL(target, SIGNAL_TRAIT(_T), COMPONENT_REMOVE_TRAIT); } \
				};\
				if (!length(_L)) { \
					target.status_traits = null\
				};\
		}\
	} while (0)
#define HAS_TRAIT(target, trait) (target.status_traits ? (target.status_traits[trait] ? TRUE : FALSE) : FALSE)
#define HAS_TRAIT_FROM(target, trait, source) (target.status_traits ? (target.status_traits[trait] ? (source in target.status_traits[trait]) : FALSE) : FALSE)
#define HAS_TRAIT_FROM_ONLY(target, trait, source) (\
	target.status_traits ?\
		(target.status_traits[trait] ?\
			((source in target.status_traits[trait]) && (length(target.status_traits) == 1))\
			: FALSE)\
		: FALSE)
#define HAS_TRAIT_NOT_FROM(target, trait, source) (target.status_traits ? (target.status_traits[trait] ? (length(target.status_traits[trait] - source) > 0) : FALSE) : FALSE)

//mob traits
/// Prevents voluntary movement.
#define TRAIT_IMMOBILIZED "immobilized"
/// Prevents usage of manipulation appendages (picking, holding or using items, manipulating storage).
#define TRAIT_HANDS_BLOCKED "handsblocked"
#define TRAIT_BLIND 			"blind"
#define TRAIT_MUTE				"mute"
#define TRAIT_EMOTEMUTE			"emotemute"
#define TRAIT_LOOC_MUTE			"looc_mute" //Just like unconsciousness, it disables LOOC salt.
#define TRAIT_AOOC_MUTE			"aooc_mute" //Same as above but for AOOC.
#define TRAIT_DEAF				"deaf"
#define TRAIT_NEARSIGHT			"nearsighted"
#define TRAIT_FAT				"fat"
#define TRAIT_HUSK				"husk"
#define TRAIT_NOCLONE			"noclone"
#define TRAIT_CLUMSY			"clumsy"
#define TRAIT_CHUNKYFINGERS		"chunkyfingers" //means that you can't use weapons with normal trigger guards.
#define TRAIT_DUMB				"dumb"
#define TRAIT_MONKEYLIKE		"monkeylike" //sets IsAdvancedToolUser to FALSE
#define TRAIT_PACIFISM			"pacifism"
#define TRAIT_IGNORESLOWDOWN	"ignoreslow"
#define TRAIT_IGNOREDAMAGESLOWDOWN "ignoredamageslowdown"
#define TRAIT_DEATHCOMA			"deathcoma" //Causes death-like unconsciousness
#define TRAIT_FAKEDEATH			"fakedeath" //Makes the owner appear as dead to most forms of medical examination
#define TRAIT_DISFIGURED		"disfigured"
#define TRAIT_XENO_HOST			"xeno_host"	//Tracks whether we're gonna be a baby alien's mummy.
#define TRAIT_STUNIMMUNE		"stun_immunity"
#define TRAIT_TASED_RESISTANCE	"tased_resistance" //prevents you from suffering most of the effects of being tased
#define TRAIT_SLEEPIMMUNE		"sleep_immunity"
#define TRAIT_PUSHIMMUNE		"push_immunity"
#define TRAIT_SHOCKIMMUNE		"shock_immunity"
#define TRAIT_TESLA_SHOCKIMMUNE	"tesla_shock_immunity"
#define TRAIT_STABLEHEART		"stable_heart"
#define TRAIT_STABLELIVER		"stable_liver"
#define TRAIT_RESISTHEAT		"resist_heat"
#define TRAIT_RESISTHEATHANDS	"resist_heat_handsonly" //For when you want to be able to touch hot things, but still want fire to be an issue.
#define TRAIT_RESISTCOLD		"resist_cold"
#define TRAIT_RESISTHIGHPRESSURE	"resist_high_pressure"
#define TRAIT_RESISTLOWPRESSURE	"resist_low_pressure"
#define TRAIT_LOWPRESSURECOOLING "low_pressure_cooling"
#define TRAIT_BOMBIMMUNE		"bomb_immunity"
#define TRAIT_RADIMMUNE			"rad_immunity"
#define TRAIT_GENELESS			"geneless"
#define TRAIT_VIRUSIMMUNE		"virus_immunity"
#define TRAIT_PIERCEIMMUNE		"pierce_immunity"
#define TRAIT_NODISMEMBER		"dismember_immunity"
#define TRAIT_NOFIRE			"nonflammable"
#define TRAIT_NOGUNS			"no_guns"
#define TRAIT_NOHUNGER			"no_hunger"
#define TRAIT_EASYDISMEMBER		"easy_dismember"
#define TRAIT_LIMBATTACHMENT 	"limb_attach"
#define TRAIT_NOLIMBDISABLE		"no_limb_disable"
#define TRAIT_EASYLIMBDISABLE	"easy_limb_disable"
#define TRAIT_TOXINLOVER		"toxinlover"
#define TRAIT_ROBOTIC_ORGANISM	"robotic_organism"
#define TRAIT_ROBOT_RADSHIELDING	"robot_radshielding"
#define TRAIT_NOBREATH			"no_breath"
#define TRAIT_AUXILIARY_LUNGS	"auxiliary_lungs"	//Lungs not neccessary required due to nobreath, but provides some other helpful function.
#define TRAIT_ANTIMAGIC			"anti_magic"
#define TRAIT_HOLY				"holy"
#define TRAIT_DEPRESSION		"depression"
#define TRAIT_JOLLY				"jolly"
#define TRAIT_NOCRITDAMAGE		"no_crit"
#define TRAIT_NOSLIPWATER		"noslip_water"
#define TRAIT_NOSLIPALL			"noslip_all"
#define TRAIT_NODEATH			"nodeath"
#define TRAIT_NOHARDCRIT		"nohardcrit"
#define TRAIT_NOSOFTCRIT		"nosoftcrit"
#define TRAIT_MINDSHIELD		"mindshield"
#define TRAIT_HIJACKER			"hijacker"
#define TRAIT_SIXTHSENSE		"sixthsense"
#define TRAIT_DISSECTED			"dissected"
#define TRAIT_FEARLESS			"fearless"
#define TRAIT_UNSTABLE			"unstable"
#define TRAIT_PARALYSIS_L_ARM	"para-l-arm" //These are used for brain-based paralysis, where replacing the limb won't fix it
#define TRAIT_PARALYSIS_R_ARM	"para-r-arm"
#define TRAIT_PARALYSIS_L_LEG	"para-l-leg"
#define TRAIT_PARALYSIS_R_LEG	"para-r-leg"
#define TRAIT_DISK_VERIFIER     "disk-verifier"
#define TRAIT_UNINTELLIGIBLE_SPEECH "unintelligible-speech"
#define TRAIT_SOOTHED_THROAT    "soothed-throat"
#define TRAIT_LAW_ENFORCEMENT_METABOLISM "law-enforcement-metabolism"
#define TRAIT_QUICK_CARRY		"quick-carry"
#define TRAIT_QUICKER_CARRY		"quicker-carry"
#define TRAIT_QUICK_BUILD		"quick-build"
#define TRAIT_STRONG_GRABBER	"strong_grabber"
#define TRAIT_CALCIUM_HEALER	"calcium_healer"
#define TRAIT_MAGIC_CHOKE		"magic_choke"
#define TRAIT_CAPTAIN_METABOLISM "captain-metabolism"
/// Like antimagic, but doesn't block the user from casting
#define TRAIT_ANTIMAGIC_NO_SELFBLOCK "anti_magic_no_selfblock"
/// Gives us turf, mob and object vision through walls
#define TRAIT_XRAY_VISION "xray_vision"
/// Gives us mob vision through walls and slight night vision
#define TRAIT_THERMAL_VISION "thermal_vision"
/// Gives us turf vision through walls and slight night vision
#define TRAIT_MESON_VISION "meson_vision"
/// Gives us Night vision
#define TRAIT_TRUE_NIGHT_VISION "true_night_vision"
/// Lets us scan reagents
#define TRAIT_REAGENT_SCANNER "reagent_scanner"
#define TRAIT_ABDUCTOR_TRAINING "abductor-training"
#define TRAIT_ABDUCTOR_SCIENTIST_TRAINING "abductor-scientist-training"
#define TRAIT_SURGEON           "surgeon"
#define TRAIT_COLDBLOODED		"coldblooded"	// Your body is literal room temperature. Does not make you immune to the temp.
#define TRAIT_NONATURALHEAL		"nonaturalheal"	// Only Admins can heal you. NOTHING else does it unless it's given the god tag.
#define TRAIT_NORUNNING			"norunning"		// You walk!
#define TRAIT_NOMARROW			"nomarrow"		// You don't make blood, with chemicals or nanites.
#define TRAIT_NOPULSE			"nopulse"		// Your heart doesn't beat.
#define TRAIT_NOGUT				"nogutting"		//Your chest cant be gutted of organs
#define TRAIT_NODECAP			"nodecapping"	//Your head cant be cut off in combat
#define TRAIT_EXEMPT_HEALTH_EVENTS	"exempt-health-events"
#define TRAIT_NO_MIDROUND_ANTAG	"no-midround-antag" //can't be turned into an antag by random events
#define TRAIT_PUGILIST	"pugilist" //This guy punches people for a living
#define TRAIT_NOPUGILIST "nopugilist" // for preventing ((((((((((extreme)))))))))) punch stacking
#define TRAIT_KI_VAMPIRE	"ki-vampire" //when someone with this trait rolls maximum damage on a punch and stuns the target, they regain some stamina and do clone damage
#define TRAIT_MAULER	"mauler" // this guy punches the shit out of people to hurt them, not to drain their stamina
#define TRAIT_PASSTABLE			"passtable"
#define TRAIT_GIANT				"giant"
#define TRAIT_DWARF				"dwarf"
#define TRAIT_ALCOHOL_TOLERANCE	"alcohol_tolerance"
#define TRAIT_AGEUSIA			"ageusia"
#define TRAIT_ANOSMIA			"anosmia"
#define TRAIT_GOODSMELL			"super_smeller"
#define TRAIT_HEAVY_SLEEPER		"heavy_sleeper"
#define TRAIT_NIGHT_VISION		"night_vision"
#define TRAIT_LIGHT_STEP		"light_step"
#define TRAIT_SILENT_STEP		"silent_step"
#define TRAIT_SPEEDY_STEP		"speedy_step"
#define TRAIT_SPIRITUAL			"spiritual"
#define TRAIT_VORACIOUS			"voracious"
#define TRAIT_SELF_AWARE		"self_aware"
#define TRAIT_FREERUNNING		"freerunning"
#define TRAIT_SKITTISH			"skittish"
#define TRAIT_POOR_AIM			"poor_aim"
#define TRAIT_INSANE_AIM		"insane_aim" //they don't miss. they never miss. it was all part of their immaculate plan.
#define TRAIT_PROSOPAGNOSIA		"prosopagnosia"
#define TRAIT_DRUNK_HEALING		"drunk_healing"
#define TRAIT_TAGGER			"tagger"
#define TRAIT_PHOTOGRAPHER		"photographer"
#define TRAIT_MUSICIAN			"musician"
#define TRAIT_PERMABONER		"permanent_arousal"
#define TRAIT_NEVERBONER		"never_aroused"
#define TRAIT_NYMPHO			"nymphomaniac"
#define TRAIT_MASO              "masochism"
#define	TRAIT_HIGH_BLOOD        "high_blood"
#define TRAIT_PARA              "paraplegic"
#define TRAIT_EMPATH			"empath"
#define TRAIT_FRIENDLY			"friendly"
#define TRAIT_SNOB				"snob"
#define TRAIT_MULTILINGUAL		"multilingual"
#define TRAIT_HEARING_SENSITIVE "hearing_sensitive"
#define TRAIT_CULT_EYES 		"cult_eyes"
#define TRAIT_AUTO_CATCH_ITEM	"auto_catch_item"
#define TRAIT_CLOWN_MENTALITY	"clown_mentality" // The future is now, clownman.
#define TRAIT_FREESPRINT		"free_sprinting"
#define TRAIT_NO_TELEPORT		"no-teleport" //you just can't
#define TRAIT_NO_INTERNALS		"no-internals"
#define TRAIT_TOXIC_ALCOHOL		"alcohol_intolerance"
#define TRAIT_MUTATION_STASIS			"mutation_stasis" //Prevents processed genetics mutations from processing.
#define TRAIT_FAST_PUMP				"fast_pump"
#define TRAIT_NO_PROCESS_FOOD	"no-process-food" // You don't get benefits from nutriment, nor nutrition from reagent consumables
#define TRAIT_NICE_SHOT			"nice_shot" //hnnnnnnnggggg..... you're pretty good...
#define TRAIT_NO_STAMINA_BUFFER_REGENERATION			"block_stamina_buffer_regen" /// Prevents stamina buffer regeneration
#define TRAIT_NO_STAMINA_REGENERATION					"block_stamina_regen" /// Prevents stamina regeneration
#define TRAIT_ARMOR_BROKEN		"armor_broken" //acts as if you are wearing no clothing when taking damage, does not affect non-clothing sources of protection
#define TRAIT_IWASBATONED "iwasbatoned" //some dastardly fellow has struck you with a baton and thought to use another to strike you again, the rogue
/// forces update_density to make us not dense
#define TRAIT_LIVING_NO_DENSITY			"living_no_density"
/// forces us to not render our overlays
#define TRAIT_HUMAN_NO_RENDER			"human_no_render"
#define TRAIT_TRASHCAN					"trashcan"
///Used for fireman carry to have mobe not be dropped when passing by a prone individual.
#define TRAIT_BEING_CARRIED "being_carried"
#define TRAIT_GLASS_BONES "glass_bones"
#define TRAIT_PAPER_SKIN "paper_skin"
//used because it's more reliable than checking for the component
#define TRAIT_DULLAHAN "dullahan"

//GS13
#define TRAIT_WEIGHT_LOSS_IMMUNE "weight_loss_immune"
#define TRAIT_UNIVERSAL_GAINER "universal_gainer"
#define TRAIT_NO_MOVE "no_move"
#define TRAIT_NO_JUMPSUIT "no_jumpsuit"
#define TRAIT_NO_MISC "no_misc"
#define TRAIT_NO_BACKPACK "no_backpack"
#define TRAIT_NO_BUCKLE "no_buckle"
#define TRAIT_DOCILE "docile"
#define TRAIT_LIVESTOCK "livestock"
#define TRAIT_NO_FAT_SLOWDOWN "no_fat_slowdown"
#define HELPLESSNESS_TRAIT "helplessness"
#define TRAIT_NO_HELPLESSNESS "no_helplessness"

#define TRAIT_RADRESONANCE "radresonance" //FIX THIS LATER
#define COMSIG_MICRO_PICKUP_FEET "micro_force_grabbed"			//From /datum/element/mob_holder/micro
#define COMSIG_MOBSIZE_CHANGED "mobsize_changed"				//Adding this in so items and whatnot can check when someone changes size. -Cap'n

#define TRAIT_MACROPHILE		"macrophile" //likes the big
#define TRAIT_MICROPHILE		"microphile" //likes the small
#define TRAIT_APATHETIC			"apathetic" //doesn't care

//WG13 Weight Stages
#define TRAIT_FATNESS_1			"Pudgy"
#define TRAIT_FATNESS_2			"Paunchy"
#define TRAIT_FATNESS_3			"Plump"
#define TRAIT_FATNESS_4			"Slightly Chubby"
#define TRAIT_FATNESS_5			"Chubby"
#define TRAIT_FATNESS_6			"Extremely Chubby"
#define TRAIT_FATNESS_7			"Slightly Overweight"
#define TRAIT_FATNESS_8			"Overweight"
#define TRAIT_FATNESS_9			"Extremely Overweight"
#define TRAIT_FATNESS_10		"Obese"
#define TRAIT_FATNESS_11		"Extremely Obese"
#define TRAIT_FATNESS_12		"Morbidly Obese"
#define TRAIT_FATNESS_13		"Fatty Blob"
#define TRAIT_FATNESS_14		"Large Fatty Blob"
#define TRAIT_FATNESS_15		"Super Fatty Blob"
#define TRAIT_FATNESS_16		"Mega Fatty Blob"
#define TRAIT_FATNESS_17		"Ultra Fatty Blob"
#define TRAIT_FATNESS_18		"Nearly Immobile Lardass"
#define TRAIT_FATNESS_19		"Immobile Lardass"

//GS13 quirks
#define TRAIT_FAT_GOOD			"fat_good"
#define TRAIT_FAT_BAD			"fat_bad"
#define TRAIT_LIPOLICIDE_TOLERANCE "lipolicide_tolerance"
#define TRAIT_WEAKLEGS			"weak_legs"
#define TRAIT_STRONGLEGS		"strong_legs"
#define TRAIT_WEB_WEAVER		"web_weaving"
#define TRAIT_METAL_CRUNCHER 	"metal_cruncher"
#define TRAIT_WATER_SPONGE 		"water_sponge"
#define TRAIT_FATROUSAL         "fatrousal"
#define TRAIT_BIOFUEL			"biofuel_processor"

//GS13 Port
#define TRAIT_HEADPAT_SLUT		"headpat_slut"
#define TRAIT_NEVER_CLONE       "donotclone"
#define TRAIT_HEAT				"heat"
#define TRAIT_DISTANT			"headpat_hater"
#define TRAIT_CUM_PLUS			"cum_plus"
#define TRAIT_TRANSFORMED 		"transformed"

// mobility flag traits
// IN THE FUTURE, IT WOULD BE NICE TO DO SOMETHING SIMILAR TO https://github.com/tgstation/tgstation/pull/48923/files (ofcourse not nearly the same because I have my.. thoughts on it)
// BUT FOR NOW, THESE ARE HOOKED TO DO update_mobility() VIA COMSIG IN living_mobility.dm
// SO IF YOU ADD MORE, BESURE TO UPDATE IT THERE.

/// Disallow movement
#define TRAIT_MOBILITY_NOMOVE		"mobility_nomove"
/// Disallow pickup
#define TRAIT_MOBILITY_NOPICKUP		"mobility_nopickup"
/// Disallow item use
#define TRAIT_MOBILITY_NOUSE		"mobility_nouse"
///Disallow resting/unresting
#define TRAIT_MOBILITY_NOREST		"mobility_norest"

#define TRAIT_SWIMMING			"swimming"			//only applied by /datum/element/swimming, for checking

/**
  * COMBAT MODE/SPRINT MODE TRAITS
  */

/// Prevents combat mode from being active.
#define TRAIT_COMBAT_MODE_LOCKED		"combatmode_locked"
/// Prevents sprinting from being active.
#define TRAIT_SPRINT_LOCKED				"sprint_locked"

/// Weather immunities, also protect mobs inside them.
#define TRAIT_LAVA_IMMUNE "lava_immune" //Used by lava turfs and The Floor Is Lava.
#define TRAIT_ASHSTORM_IMMUNE "ashstorm_immune"
#define TRAIT_SNOWSTORM_IMMUNE "snowstorm_immune"
#define TRAIT_RADSTORM_IMMUNE "radstorm_immune"
#define TRAIT_VOIDSTORM_IMMUNE "voidstorm_immune"
#define TRAIT_WEATHER_IMMUNE "weather_immune" //Immune to ALL weather effects.

 //non-mob traits
#define TRAIT_PARALYSIS				"paralysis" //Used for limb-based paralysis, where replacing the limb will fix it
#define VEHICLE_TRAIT "vehicle" // inherited from riding vehicles
#define INNATE_TRAIT "innate"

///Used for managing KEEP_TOGETHER in [appearance_flags]
#define TRAIT_KEEP_TOGETHER 	"keep-together"

// item traits
#define TRAIT_NODROP            "nodrop"
#define TRAIT_SPOOKY_THROW      "spooky_throw"

// common trait sources
#define TRAIT_GENERIC "generic"
#define EYE_DAMAGE "eye_damage"
#define GENETIC_MUTATION "genetic"
#define OBESITY "obesity"
#define MAGIC_TRAIT "magic"
#define TRAUMA_TRAIT "trauma"
#define DISEASE_TRAIT "disease"
#define SPECIES_TRAIT "species"
#define ORGAN_TRAIT "organ"
#define JOB_TRAIT "job"
#define CYBORG_ITEM_TRAIT "cyborg-item"
#define ADMIN_TRAIT "admin" // (B)admins only.
#define CHANGELING_TRAIT "changeling"
#define CULT_TRAIT "cult"
#define CURSED_ITEM_TRAIT "cursed-item" // The item is magically cursed
#define ABSTRACT_ITEM_TRAIT "abstract-item"
#define STATUS_EFFECT_TRAIT "status-effect"
#define CLOTHING_TRAIT "clothing"
#define ROUNDSTART_TRAIT "roundstart" //cannot be removed without admin intervention
#define GHOSTROLE_TRAIT "ghostrole"
#define APHRO_TRAIT "aphro"
#define BLOODSUCKER_TRAIT "bloodsucker"
#define GLOVE_TRAIT "glove" //inherited by your cool gloves
#define SHOES_TRAIT "shoes" //inherited from your sweet kicks
#define BOOK_TRAIT "granter (book)" // knowledge is power
#define TURF_TRAIT "turf"
#define STATION_TRAIT "station-trait"

// unique trait sources, still defines
#define STATUE_TRAIT "statue"
#define CLONING_POD_TRAIT "cloning-pod"
#define VIRTUAL_REALITY_TRAIT "vr_trait"
#define CHANGELING_DRAIN "drain"
#define CHANGELING_HIVEMIND_MUTE "ling_mute"
#define ABYSSAL_GAZE_BLIND "abyssal_gaze"
#define HIGHLANDER "highlander"
#define TRAIT_HULK "hulk"
#define STASIS_MUTE "stasis"
#define GENETICS_SPELL "genetics_spell"
#define EYES_COVERED "eyes_covered"
#define CLOWN_NUKE_TRAIT "clown-nuke"
#define STICKY_MOUSTACHE_TRAIT "sticky-moustache"
#define CHAINSAW_FRENZY_TRAIT "chainsaw-frenzy"
#define CHRONO_GUN_TRAIT "chrono-gun"
#define REVERSE_BEAR_TRAP_TRAIT "reverse-bear-trap"
#define GLUED_ITEM_TRAIT "glued-item"
#define CURSED_MASK_TRAIT "cursed-mask"
#define HIS_GRACE_TRAIT "his-grace"
#define HAND_REPLACEMENT_TRAIT "magic-hand"
#define HOT_POTATO_TRAIT "hot-potato"
#define SABRE_SUICIDE_TRAIT "sabre-suicide"
#define ABDUCTOR_VEST_TRAIT "abductor-vest"
#define CAPTURE_THE_FLAG_TRAIT "capture-the-flag"
#define EYE_OF_GOD_TRAIT "eye-of-god"
#define SHAMEBRERO_TRAIT "shamebrero"
#define CHRONOSUIT_TRAIT "chronosuit"
#define FLIGHTSUIT_TRAIT "flightsuit"
#define LOCKED_HELMET_TRAIT "locked-helmet"
#define NINJA_SUIT_TRAIT "ninja-suit"
#define ANTI_DROP_IMPLANT_TRAIT "anti-drop-implant"
#define ROBOT_RADSHIELDING_IMPLANT_TRAIT "robot-radshielding-implant"
#define MARTIAL_ARTIST_TRAIT "martial_artist"
#define SLEEPING_CARP_TRAIT "sleeping_carp"
#define RISING_BASS_TRAIT "rising_bass"
#define ABDUCTOR_ANTAGONIST "abductor-antagonist"
#define MADE_UNCLONEABLE "made-uncloneable"
#define TIMESTOP_TRAIT "timestop"
#define DOMAIN_TRAIT "domain"
#define NUKEOP_TRAIT "nuke-op"
#define CLOWNOP_TRAIT "clown-op"
#define MEGAFAUNA_TRAIT "megafauna"
#define DEATHSQUAD_TRAIT "deathsquad"
#define SLIMEPUDDLE_TRAIT "slimepuddle"
#define CORRUPTED_SYSTEM "corrupted-system"
///Turf trait for when a turf is transparent
#define TURF_Z_TRANSPARENT_TRAIT "turf_z_transparent"
/// This trait is added by the active directional block system.
#define ACTIVE_BLOCK_TRAIT				"active_block"
/// This trait is added by the parry system.
#define ACTIVE_PARRY_TRAIT				"active_parry"
#define STICKY_NODROP "sticky-nodrop" //sticky nodrop sounds like a bad soundcloud rapper's name
#define TRAIT_SACRIFICED "sacrificed" //Makes sure that people cant be cult sacrificed twice.
#define TRAIT_SPACEWALK "spacewalk"
#define TRAIT_SALT_SENSITIVE "salt_sensitive"


/// obtained from mapping helper
#define MAPPING_HELPER_TRAIT "mapping-helper"
/// Trait associated with mafia
#define MAFIA_TRAIT "mafia"

///Traits given by station traits
#define STATION_TRAIT_BANANIUM_SHIPMENTS "station_trait_bananium_shipments"
#define STATION_TRAIT_UNNATURAL_ATMOSPHERE "station_trait_unnatural_atmosphere"
#define STATION_TRAIT_UNIQUE_AI "station_trait_unique_ai"
#define STATION_TRAIT_CARP_INFESTATION "station_trait_carp_infestation"
#define STATION_TRAIT_PREMIUM_INTERNALS "station_trait_premium_internals"
#define STATION_TRAIT_LATE_ARRIVALS "station_trait_late_arrivals"
#define STATION_TRAIT_RANDOM_ARRIVALS "station_trait_random_arrivals"
#define STATION_TRAIT_HANGOVER "station_trait_hangover"
#define STATION_TRAIT_FILLED_MAINT "station_trait_filled_maint"
#define STATION_TRAIT_EMPTY_MAINT "station_trait_empty_maint"
#define STATION_TRAIT_PDA_GLITCHED "station_trait_pda_glitched"
/// Trait applied by MODsuits.
#define MOD_TRAIT "mod"
