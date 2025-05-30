/*ALL MOB-RELATED DEFINES THAT DON'T BELONG IN ANOTHER FILE GO HERE*/

// Misc mob defines

// Ready states at roundstart for mob/dead/new_player
#define PLAYER_NOT_READY 0
#define PLAYER_READY_TO_PLAY 1

// movement intent defines for the m_intent var
#define MOVE_INTENT_WALK "walk"
#define MOVE_INTENT_RUN  "run"

// Blood levels
#define BLOOD_VOLUME_MAX_LETHAL		2150
#define BLOOD_VOLUME_EXCESS			2100
#define BLOOD_VOLUME_MAXIMUM		2000
#define BLOOD_VOLUME_SLIME_SPLIT	1120
#define BLOOD_VOLUME_NORMAL			560
#define BLOOD_VOLUME_SAFE			475
#define BLOOD_VOLUME_OKAY			336
#define BLOOD_VOLUME_BAD			224
#define BLOOD_VOLUME_SURVIVE		122

// Sizes of mobs, used by mob/living/var/mob_size
#define MOB_SIZE_TINY 0
#define MOB_SIZE_SMALL 1
#define MOB_SIZE_HUMAN 2
#define MOB_SIZE_LARGE 3

// Ventcrawling defines
#define VENTCRAWLER_NONE   0
#define VENTCRAWLER_NUDE   1
#define VENTCRAWLER_ALWAYS 2

// Bloodcrawling defines
#define BLOODCRAWL 1
#define BLOODCRAWL_EAT 2

// Mob bio-types flags
#define MOB_ORGANIC		(1 << 0)
#define MOB_MINERAL		(1 << 1)
#define MOB_ROBOTIC		(1 << 2)
#define MOB_UNDEAD		(1 << 3)
#define MOB_HUMANOID	(1 << 4)
#define MOB_BUG			(1 << 5)
#define MOB_BEAST		(1 << 6)
#define MOB_EPIC		(1 << 7)	// Megafauna
#define MOB_REPTILE		(1 << 8)
#define MOB_SPIRIT		(1 << 9)
/// Mobs that otherwise support nanites
#define MOB_NANITES		(1 << 10)

// Organ defines for carbon mobs
#define ORGAN_ORGANIC   1
#define ORGAN_ROBOTIC   2

#define BODYPART_ORGANIC   1
#define BODYPART_ROBOTIC   2
#define BODYPART_HYBRID    3
#define BODYPART_NANITES   4

#define HYBRID_BODYPART_DAMAGE_THRESHHOLD 25 //How much damage has to be suffered until the damage threshhold counts as passed
#define HYBRID_BODYPART_THESHHOLD_MINDAMAGE 10 //Which damage value this limb cannot be healed out of via easy nonsurgical means if the threshhold has been passed, state resets if damage value goes below mindamage.

#define BODYPART_NOT_DISABLED 0
#define BODYPART_DISABLED_DAMAGE 1
#define BODYPART_DISABLED_PARALYSIS 2
#define BODYPART_DISABLED_WOUND 3

#define DEFAULT_BODYPART_ICON 'icons/mob/human_parts.dmi'
#define DEFAULT_BODYPART_ICON_ORGANIC 'icons/mob/human_parts_greyscale.dmi'
#define DEFAULT_BODYPART_ICON_ROBOTIC 'icons/mob/augmentation/augments.dmi'

#define MONKEY_BODYPART "monkey"
#define ALIEN_BODYPART  "alien"
#define LARVA_BODYPART  "larva"
#define DEVIL_BODYPART  "devil"
/*see __DEFINES/inventory.dm for bodypart bitflag defines*/

// Health/damage defines for carbon mobs
#define HUMAN_MAX_OXYLOSS 3
#define HUMAN_CRIT_MAX_OXYLOSS (SSmobs.wait/30)

#define HEAT_DAMAGE_LEVEL_1 2	// Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 3	// Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 8	// Amount of damage applied when your body temperature passes the 460K point and you are on fire

#define COLD_DAMAGE_LEVEL_1 0.5	// Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_2 1.5	// Amount of damage applied when your body temperature passes the 200K point
#define COLD_DAMAGE_LEVEL_3 3	// Amount of damage applied when your body temperature passes the 120K point

// Note that gas heat damage is only applied once every FOUR ticks.
#define HEAT_GAS_DAMAGE_LEVEL_1 2	// Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_2 4	// Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_3 8	// Amount of damage applied when the current breath's temperature passes the 1000K point

#define COLD_GAS_DAMAGE_LEVEL_1 0.5	// Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_2 1.5	// Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_3 3	// Amount of damage applied when the current breath's temperature passes the 120K point

// Brain Damage defines
#define BRAIN_DAMAGE_MILD   20
#define BRAIN_DAMAGE_SEVERE 100
#define BRAIN_DAMAGE_DEATH  200

#define BRAIN_TRAUMA_MILD /datum/brain_trauma/mild
#define BRAIN_TRAUMA_SEVERE /datum/brain_trauma/severe
#define BRAIN_TRAUMA_SPECIAL /datum/brain_trauma/special
#define BRAIN_TRAUMA_MAGIC /datum/brain_trauma/magic

#define TRAUMA_RESILIENCE_BASIC    1	// Curable with chems
#define TRAUMA_RESILIENCE_SURGERY  2	// Curable with brain surgery
#define TRAUMA_RESILIENCE_LOBOTOMY 3	// Curable with lobotomy
#define TRAUMA_RESILIENCE_WOUND    4	// Curable by healing the head wound
#define TRAUMA_RESILIENCE_MAGIC    5	// Curable only with magic
#define TRAUMA_RESILIENCE_ABSOLUTE 6	// This is here to stay

// Limit of traumas for each resilience tier
#define TRAUMA_LIMIT_BASIC	  3
#define TRAUMA_LIMIT_SURGERY  2
#define TRAUMA_LIMIT_WOUND	  2
#define TRAUMA_LIMIT_LOBOTOMY 3
#define TRAUMA_LIMIT_MAGIC	  3
#define TRAUMA_LIMIT_ABSOLUTE INFINITY

#define BRAIN_DAMAGE_INTEGRITY_MULTIPLIER 0.5

// Surgery Defines
#define BIOWARE_GENERIC "generic"
#define BIOWARE_NERVES "nerves"
#define BIOWARE_CIRCULATION "circulation"
#define BIOWARE_LIGAMENTS "ligaments"

// Health hud screws for carbon mobs
#define SCREWYHUD_NONE	  0
#define SCREWYHUD_CRIT	  1
#define SCREWYHUD_DEAD	  2
#define SCREWYHUD_HEALTHY 3

// Threshold levels for beauty for humans
#define BEAUTY_LEVEL_HORRID -66
#define BEAUTY_LEVEL_BAD    -33
#define BEAUTY_LEVEL_DECENT  33
#define BEAUTY_LEVEL_GOOD    66
#define BEAUTY_LEVEL_GREAT  100

// Moods levels for humans
#define MOOD_LEVEL_HAPPY4  15
#define MOOD_LEVEL_HAPPY3  10
#define MOOD_LEVEL_HAPPY2   6
#define MOOD_LEVEL_HAPPY1   2
#define MOOD_LEVEL_NEUTRAL  0
#define MOOD_LEVEL_SAD1    -3
#define MOOD_LEVEL_SAD2   -12
#define MOOD_LEVEL_SAD3   -18
#define MOOD_LEVEL_SAD4   -25

// Sanity levels for humans
#define SANITY_AMAZING	 150
#define SANITY_GREAT	 125
#define SANITY_NEUTRAL	 100
#define SANITY_DISTURBED 75
#define SANITY_UNSTABLE	 50
#define SANITY_CRAZY	 25
#define SANITY_INSANE	 0

// Nutrition levels for humans
#define NUTRITION_LEVEL_FAT		 600
#define NUTRITION_LEVEL_FULL	 550
#define NUTRITION_LEVEL_WELL_FED 450
#define NUTRITION_LEVEL_FED		 350
#define NUTRITION_LEVEL_HUNGRY	 250
#define NUTRITION_LEVEL_STARVING 150

#define NUTRITION_LEVEL_START_MIN 250
#define NUTRITION_LEVEL_START_MAX 400

//GS13 Port - Hyperstation Thirst
#define THIRST_LEVEL_THRESHOLD	800		//Set to 0 to stop clamping
#define THIRST_LEVEL_QUENCHED	450
#define THIRST_LEVEL_THIRSTY	250
#define THIRST_LEVEL_PARCHED	150

#define THIRST_LEVEL_START_MIN	250
#define THIRST_LEVEL_START_MAX	400

// Disgust levels for humans
#define DISGUST_LEVEL_MAXEDOUT  150
#define DISGUST_LEVEL_DISGUSTED	 75
#define DISGUST_LEVEL_VERYGROSS	 50
#define DISGUST_LEVEL_GROSS		 25

// Charge levels for Ethereals
#define ETHEREAL_CHARGE_NONE		0
#define ETHEREAL_CHARGE_LOWPOWER   20
#define ETHEREAL_CHARGE_NORMAL	   50
#define ETHEREAL_CHARGE_ALMOSTFULL 75
#define ETHEREAL_CHARGE_FULL	  100
#define ETHEREAL_CHARGE_OVERLOAD  125
#define ETHEREAL_CHARGE_DANGEROUS 150

// Slime evolution threshold. Controls how fast slimes can split/grow
#define SLIME_EVOLUTION_THRESHOLD 10

// Slime extract crossing. Controls how many extracts is required to feed to a slime to core-cross.
#define SLIME_EXTRACT_CROSSING_REQUIRED 10

// Slime commands defines
#define SLIME_FRIENDSHIP_FOLLOW 			3 // Min friendship to order it to follow
#define SLIME_FRIENDSHIP_STOPEAT 			5 // Min friendship to order it to stop eating someone
#define SLIME_FRIENDSHIP_STOPEAT_NOANGRY	7 // Min friendship to order it to stop eating someone without it losing friendship
#define SLIME_FRIENDSHIP_STOPCHASE			4 // Min friendship to order it to stop chasing someone (their target)
#define SLIME_FRIENDSHIP_STOPCHASE_NOANGRY	6 // Min friendship to order it to stop chasing someone (their target) without it losing friendship
#define SLIME_FRIENDSHIP_STAY				3 // Min friendship to order it to stay
#define SLIME_FRIENDSHIP_ATTACK				8 // Min friendship to order it to attack

// Sentience types, to prevent things like sentience potions from giving bosses sentience
#define SENTIENCE_ORGANIC	 1
#define SENTIENCE_ARTIFICIAL 2
//#define SENTIENCE_OTHER	 3	// Unused
#define SENTIENCE_MINEBOT	 4
#define SENTIENCE_BOSS		 5

// Mob AI Status

// Hostile simple animals
// If you add a new status, be sure to add a list for it to the simple_animals global in _globalvars/lists/mobs.dm
#define AI_ON		1
#define AI_IDLE		2
#define AI_OFF		3
#define AI_Z_OFF	4

// determines if a mob can smash through it
#define ENVIRONMENT_SMASH_NONE		  0
#define ENVIRONMENT_SMASH_STRUCTURES (1<<0)	// crates, lockers, ect
#define ENVIRONMENT_SMASH_WALLS		 (1<<1)	// walls
#define ENVIRONMENT_SMASH_RWALLS	 (1<<2)	// rwalls

#define NO_SLIP_WHEN_WALKING (1<<0)
#define SLIDE				 (1<<1)
#define GALOSHES_DONT_HELP	 (1<<2)
#define FLYING_DOESNT_HELP	 (1<<3)
#define SLIDE_ICE			 (1<<4)
#define SLIP_WHEN_CRAWLING	 (1<<5)	// clown planet ruin amongst others
#define SLIP_WHEN_JOGGING	 (1<<6)	// slips prevented by walking are also dodged if the mob is nor sprinting or fatigued... unless this flag is on.


#define MAX_CHICKENS 50

// /Flags used by the flags parameter of electrocute act.

// /Makes it so that the shock doesn't take gloves into account.
#define SHOCK_NOGLOVES   (1 << 0)
// /Used when the shock is from a tesla bolt.
#define SHOCK_TESLA		 (1 << 1)
// /Used when an illusion shocks something. Makes the shock deal stamina damage and not trigger certain secondary effects.
#define SHOCK_ILLUSION	 (1 << 2)
// /The shock doesn't stun.
#define SHOCK_NOSTUN	 (1 << 3)


#define INCORPOREAL_MOVE_BASIC  1
#define INCORPOREAL_MOVE_SHADOW 2	// leaves a trail of shadows
#define INCORPOREAL_MOVE_JAUNT  3	// is blocked by holy water/salt

// Secbot and ED209 judgement criteria bitflag values
#define JUDGE_EMAGGED		(1<<0)
#define JUDGE_IDCHECK		(1<<1)
#define JUDGE_WEAPONCHECK	(1<<2)
#define JUDGE_RECORDCHECK	(1<<3)
// ED209's ignore monkeys
#define JUDGE_IGNOREMONKEYS	(1<<4)

#define MEGAFAUNA_DEFAULT_RECOVERY_TIME 5

#define SHADOW_SPECIES_LIGHT_THRESHOLD 0.05

// Offsets defines

#define OFFSET_UNIFORM	"uniform"
#define OFFSET_ID		"id"
#define OFFSET_GLOVES	"gloves"
#define OFFSET_GLASSES	"glasses"
#define OFFSET_EARS		"ears"
#define OFFSET_SHOES	"shoes"
#define OFFSET_S_STORE	"s_store"
#define OFFSET_FACEMASK	"mask"
#define OFFSET_HEAD		"head"
#define OFFSET_EYES		"eyes"
#define OFFSET_LIPS		"lips"
#define OFFSET_BELT		"belt"
#define OFFSET_BACK		"back"
#define OFFSET_SUIT		"suit"
#define OFFSET_NECK		"neck"
#define OFFSET_HAIR		"hair"
#define OFFSET_FHAIR	"fhair"
#define OFFSET_MUTPARTS	"mutantparts"

// MINOR TWEAKS/MISC
#define AGE_MIN					21	// youngest a character can be // CITADEL EDIT - 17 --> 18 //GS13 EDIT - 18 --> 21
#define AGE_MAX					85	// oldest a character can be randomly generated
#define AGE_MAX_INPUT			85	// oldest a character's age can be manually set
#define WIZARD_AGE_MIN			30	// youngest a wizard can be
#define APPRENTICE_AGE_MIN		29	// youngest an apprentice can be
#define SHOES_SLOWDOWN			 0	// How much shoes slow you down by default. Negative values speed you up
#define SHOES_SPEED_SLIGHT	SHOES_SLOWDOWN - 1 // slightest speed boost to movement
#define POCKET_STRIP_DELAY (4 SECONDS) //time taken to search somebody's pockets
#define DOOR_CRUSH_DAMAGE		15	// the amount of damage that airlocks deal when they crush you

#define	HUNGER_FACTOR			 0.1	// factor at which mob nutrition decreases
#define	ETHEREAL_CHARGE_FACTOR	 0.08	// factor at which ethereal's charge decreases
#define	REAGENTS_METABOLISM		 0.4	// How many units of reagent are consumed per tick, by default.
#define REAGENTS_EFFECT_MULTIPLIER (REAGENTS_METABOLISM / 0.4)	// By defining the effect multiplier this way, it'll exactly adjust all effects according to how they originally were with the 0.4 metabolism

// Roundstart trait system

#define MAX_QUIRKS 6 // The maximum amount of quirks one character can have at roundstart

#define MAX_REVIVE_FIRE_DAMAGE  180
#define MAX_REVIVE_BRUTE_DAMAGE 180

// AI Toggles
#define AI_CAMERA_LUMINOSITY	5
#define AI_VOX // Comment out if you don't want VOX to be enabled and have players download the voice sounds.

// /obj/item/bodypart on_mob_life() retval flag
#define BODYPART_LIFE_UPDATE_HEALTH	(1<<0)

#define HUMAN_FIRE_STACK_ICON_NUM	3

#define TYPING_INDICATOR_TIMEOUT 20 MINUTES

#define GRAB_PIXEL_SHIFT_PASSIVE	6
#define GRAB_PIXEL_SHIFT_AGGRESSIVE	12
#define GRAB_PIXEL_SHIFT_NECK		16

#define SLEEP_CHECK_DEATH(X) sleep(X); if(QDELETED(src) || stat == DEAD) return;
#define INTERACTING_WITH(X, Y) (Y in X.do_afters)

// / Field of vision defines.
#define FOV_90_DEGREES	90
#define FOV_180_DEGREES	180
#define FOV_270_DEGREES	270

// / How far away you can be to make eye contact with someone while examining
#define EYE_CONTACT_RANGE	5

// / If you examine the same atom twice in this timeframe, we call examine_more() instead of examine()
#define EXAMINE_MORE_TIME	1 SECONDS

#define SILENCE_RANGED_MESSAGE	(1<<0)

///Define for spawning megafauna instead of a mob for cave gen
#define SPAWN_MEGAFAUNA "bluh bluh huge boss"

/*
 * Defines for "AI emotions", allowing the AI to expression emotions
 * with status displays via emotes.
 */

#define AI_EMOTION_VERY_HAPPY "Very Happy"
#define AI_EMOTION_HAPPY "Happy"
#define AI_EMOTION_NEUTRAL "Neutral"
#define AI_EMOTION_UNSURE "Unsure"
#define AI_EMOTION_CONFUSED "Confused"
#define AI_EMOTION_SAD "Sad"
#define AI_EMOTION_BSOD "BSOD"
#define AI_EMOTION_BLANK "Blank"
#define AI_EMOTION_PROBLEMS "Problems?"
#define AI_EMOTION_AWESOME "Awesome"
#define AI_EMOTION_FACEPALM "Facepalm"
#define AI_EMOTION_THINKING "Thinking"
#define AI_EMOTION_FRIEND_COMPUTER "Friend Computer"
#define AI_EMOTION_DORFY "Dorfy"
#define AI_EMOTION_BLUE_GLOW "Blue Glow"
#define AI_EMOTION_RED_GLOW "Red Glow"

// / Breathing types. Lungs can access either by these or by a string, which will be considered a gas ID.
#define BREATH_OXY		/datum/breathing_class/oxygen
#define BREATH_PLASMA	/datum/breathing_class/plasma
#define BREATH_METHANE	/datum/breathing_class/methane

//Gremlins
#define NPC_TAMPER_ACT_FORGET 1 //Don't try to tamper with this again
#define NPC_TAMPER_ACT_NOMSG  2 //Don't produce a visible message

//Game mode list indexes
#define CURRENT_LIVING_PLAYERS	"living_players_list"
#define CURRENT_LIVING_ANTAGS	"living_antags_list"
#define CURRENT_DEAD_PLAYERS	"dead_players_list"
#define CURRENT_OBSERVERS		"current_observers_list"

//Fullness levels, no more infinite eating my dudes!
#define FULLNESS_LEVEL_NOMOREPLZ 280
#define FULLNESS_LEVEL_BEEG 140
#define FULLNESS_LEVEL_BLOATED 80
#define FULLNESS_LEVEL_FILLED 40
#define FULLNESS_LEVEL_HALF_FULL 20
#define FULLNESS_LEVEL_EMPTY 0
#define FULLNESS_STUFFED_EXTRA_SPRITE_SIZES 2 //GS13 - Stuffed sprite range

//Fullness emote cooldown
#define FULLNESS_REDUCTION_COOLDOWN 50

//Fatness levels, Here we go!
#define FATNESS_LEVEL_19 8500
#define FATNESS_LEVEL_18 8000
#define FATNESS_LEVEL_17 7500
#define FATNESS_LEVEL_16 7000
#define FATNESS_LEVEL_15 6500
#define FATNESS_LEVEL_14 6000
#define FATNESS_LEVEL_13 5500
#define FATNESS_LEVEL_12 5000
#define FATNESS_LEVEL_11 4500
#define FATNESS_LEVEL_10 4000
#define FATNESS_LEVEL_9 3440
#define FATNESS_LEVEL_8 2540
#define FATNESS_LEVEL_7 1840
#define FATNESS_LEVEL_6 1240
#define FATNESS_LEVEL_5 840
#define FATNESS_LEVEL_4 440
#define FATNESS_LEVEL_3 330
#define FATNESS_LEVEL_2 250
#define FATNESS_LEVEL_1 170

//Math stuff for fatness movement speed
#define FATNESS_DIVISOR 860
#define FATNESS_MAX_MOVE_PENALTY 4
#define FATNESS_WEAKLEGS_MODIFIER 35 // GS13 tweak
#define FATNESS_STRONGLEGS_MODIFIER 0.5

#define RESIZE_MACRO 6
#define RESIZE_HUGE 4
#define RESIZE_BIG 2
#define RESIZE_NORMAL 1
#define RESIZE_SMALL 0.75
#define RESIZE_TINY 0.50
#define RESIZE_MICRO 0.25

#define MOVESPEED_ID_SIZE      "SIZECODE"
#define MOVESPEED_ID_STOMP     "STEPPY"

//averages
#define RESIZE_A_MACROHUGE (RESIZE_MACRO + RESIZE_HUGE) / 2
#define RESIZE_A_HUGEBIG (RESIZE_HUGE + RESIZE_BIG) / 2
#define RESIZE_A_BIGNORMAL (RESIZE_BIG + RESIZE_NORMAL) / 2
#define RESIZE_A_NORMALSMALL (RESIZE_NORMAL + RESIZE_SMALL) / 2
#define RESIZE_A_SMALLTINY (RESIZE_SMALL + RESIZE_TINY) / 2
#define RESIZE_A_TINYMICRO (RESIZE_TINY + RESIZE_MICRO) / 2
