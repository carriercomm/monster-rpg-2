music = "Muttrace.caf"

function start()
	out = Portal:new{x=3, y=7}
	cat = Object:new{x=3, y=3, anim_set="Kitty", person=true, direction=DIRECTION_SOUTH}
end

function stop()
end

function update(step)
	if (out:update()) then
		change_areas("Muttrace", 33, 20, DIRECTION_SOUTH)
	end
end

function activate(activator, activated)
	if (activated == cat.id) then
		if (getMilestone(MS_GOT_LOOKING_SCOPE)) then
			if (getMilestone(MS_GOT_ORB)) then
				doDialogue("Female: Good luck.\n")
			else
				doDialogue("Female: Nice looking scope...\nFemale: I'm really going to be on the losing end of this deal but...\nFemale: Here, I'll trade you for this Light Orb.\nFemale: The orb will light your path even in darkness.\n", true)
				slot = findUsedInventorySlot(ITEM_LOOKING_SCOPE)
				setInventory(slot, ITEM_LIGHT_ORB, 1)
				setMilestone(MS_GOT_ORB, true)
				loadPlayDestroy("chest.ogg")
			end
		else
			doDialogue("Female: How did you get here?\n")
		end
	end
end

function collide(id1, id2)
end

