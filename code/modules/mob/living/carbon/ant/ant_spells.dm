/mob/living/carbon/proc/ant_use_plasma_spell(amount, mob/living/carbon/user)
	var/obj/item/organ/internal/alien/ant/plasmavessel/vessel = get_int_organ(/obj/item/organ/internal/alien/ant/plasmavessel)
	if(amount > vessel.stored_plasma)
		return FALSE
	add_plasma(-amount)
	return TRUE

/* add_plasma just requires the plasma amount, so admins can easily varedit it and stuff
Updates the spell's actions on use as well, so they know when they can or can't use their powers*/

/mob/living/carbon/proc/ant_add_plasma(amount)
	var/obj/item/organ/internal/alien/ant/plasmavessel/vessel = get_int_organ(/obj/item/organ/internal/alien/ant/plasmavessel)
	if(!vessel)
		return
	vessel.stored_plasma = clamp(vessel.stored_plasma + amount, 0, vessel.max_plasma)
	if(vessel.stored_plasma == null)
		vessel.stored_plasma = 1
	update_plasma_display(src)
	for(var/datum/action/spell_action/action in actions)
		action.UpdateButtons()

/datum/spell/ant_spell
	action_background_icon_state = "bg_alien"
	clothes_req = FALSE
	base_cooldown = 0
	create_attack_logs = FALSE
	/// Every alien spell creates only logs, no attack messages on someone placing weeds, but you DO get attack messages on neurotoxin and corrosive acid
	create_custom_logs = TRUE
	/// How much plasma it costs to use this
	var/plasma_cost = 0

/// Every single alien spell uses a "spell name + plasmacost" format
/datum/spell/ant_spell/New()
	..()
	if(plasma_cost)
		name = "[name] ([plasma_cost])"
		action.name = name
		action.desc = desc
		action.UpdateButtons()

/datum/spell/ant_spell/write_custom_logs(list/targets, mob/user)
	user.create_log(ATTACK_LOG, "Cast the spell [name]")

/datum/spell/ant_spell/create_new_handler()
	var/datum/spell_handler/alien/handler = new
	handler.plasma_cost = plasma_cost
	return handler

// POR ALGUNA RAZÓN PARADISE TIENE UN DM PARA CADA SPELL, PODEMOS AGREGAR LOS SPELLS DE LAS HORMIGAS TODOS AQUÍ MISMO A PARTIR DE AQUÍ
// =================================================================================

//AQUÍ ABAJO UN EJEMPLO DE SPELL XENO RENOMBRADO PARA HORMIGAS
/datum/spell/ant_spell/plant_weeds
	name = "Plant weeds"
	desc = "Allows you to plant some alien weeds on the floor below you. Does not work while in space."
	plasma_cost = 50
	var/atom/weed_type = /obj/structure/alien/weeds/node
	var/weed_name = "alien weed node"
	action_icon_state = "alien_plant"
	var/requires_do_after = TRUE

/datum/spell/ant_spell/plant_weeds/create_new_targeting()
	return new /datum/spell_targeting/self

/datum/spell/ant_spell/plant_weeds/cast(list/targets, mob/living/carbon/user)
	var/turf/T = user.loc
	if(locate(weed_type) in T)
		to_chat(user, "<span class='noticealien'>There's already \a [weed_name] here.</span>")
		revert_cast()
		return

	if(isspaceturf(T))
		to_chat(user, "<span class='noticealien'>You cannot plant [weed_name]s in space.</span>")
		revert_cast()
		return

	if(!isturf(T))
		to_chat(user, "<span class='noticealien'>You cannot plant [weed_name]s inside something!</span>")
		revert_cast()
		return

	user.visible_message("<span class='warning'>Vines burst from the back of [user], quickly scurring to the ground and swarm onto [user.loc].</span>", "<span class='warning'>You begin infesting [user.loc] with [initial(weed_type.name)].</span>")
	if(requires_do_after && !do_mob(user, user, 2 SECONDS))
		revert_cast()
		return

	user.visible_message("<span class='alertalien'>[user] has planted \a [weed_name]!</span>")
	new weed_type(T)


/datum/spell/ant_spell/plant_weeds/eggs
	name = "Plant ant eggs"
	desc = "Allows you to plant ant eggs on your current turf, does not work while in space."
	plasma_cost = 0
	weed_type = /obj/structure/alien/egg
	weed_name = "alien egg"
	action_icon_state = "alien_egg"
	requires_do_after = FALSE

/datum/spell/ant_spell/combust_facehuggers
	name = "Combust facehuggers and eggs"
	desc = "Take over the programming of facehuggers and eggs, sending out a shockwave which causes them to combust."
	plasma_cost = 25
	action_icon_state = "alien_egg"
	base_cooldown = 3 SECONDS

/datum/spell/ant_spell/combust_facehuggers/create_new_targeting()
	return new /datum/spell_targeting/clicked_atom
