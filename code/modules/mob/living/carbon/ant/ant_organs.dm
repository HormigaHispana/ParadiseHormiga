/obj/item/organ/internal/alien/plasmavessel/ant
	name = "ant plasma vessel"
	icon_state = "plasma"
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = "biotech=5;plasmatech=4"
	slot = "plasmavessel"
	alien_powers = list(/datum/spell/alien_spell/plant_weeds, /datum/spell/alien_spell/transfer_plasma)
	human_powers = list(/datum/spell/alien_spell/syphon_plasma)

	stored_plasma = 100
	max_plasma = 300
	heal_rate = 5
	plasma_rate = 10

/obj/item/organ/internal/alien/eggsac/ant
	name = "ant egg sac"
	icon_state = "eggsac"
	slot = "eggsac"
	w_class = WEIGHT_CLASS_BULKY
	origin_tech = "biotech=6"
	alien_powers = list(/datum/spell/alien_spell/plant_weeds/anteggs)
	human_powers = list(/datum/spell/alien_spell/combust_facehuggers)
	cargo_profit = 1000