function has(item, amount)
	--print(string.format("Looking for item: %s",item))
    local count = Tracker:ProviderCountForCode(item)
    if not amount then
        return count > 0
    else
        amount = tonumber(amount)
        return count >= amount
    end
end

function GenieCost()
	local currentTokens = Tracker:ProviderCountForCode("boss_tokens")
	local requiredTokens = Tracker:ProviderCountForCode("bosses_required")
	return (currentTokens >= requiredTokens)
end

function can_garlic()
    return has("garlic_powerup") or has("powerup_1")
end

function can_bull()
    return has("bull") or has("powerup_2")
end

function can_dragon()
    return has("dragon") or has("powerup_3")
end

function can_jet()
    return has("jet") or has("powerup_4")
end

function can_create_coin()
	return has("create_coin")
end

function can_climb()
    return has("climb")
end

function can_highjump()
    return has("highjump")
end

function pw_flooded()
	chests_left = Tracker:FindObjectForCode("@Parsley Woods 32/Normal Exit").AvailableChestCount
	print(string.format("PW32 Chests left: %s",chests_left))
	if chests_left == 0 then
		return 1
	else
		return 0
	end
end

function rb_flooded()
	chests_left = Tracker:FindObjectForCode("@Rice Beach 02/Normal Exit").AvailableChestCount
	print(string.format("RB02 Chests left: %s",chests_left))
	if chests_left == 0 then
		return 1
	else
		return 0
	end
end

function teapot_bossspot()
	chests_left = Tracker:FindObjectForCode("@Mt. Teapot 12/Normal Exit").AvailableChestCount
	print(string.format("MTT12 Chests left: %s",chests_left))
	if chests_left == 0 then
		return 1
	else
		return 0
	end
end

function can_duck()
    return has("duck")
end

function can_dash()
    return ((has("dash") and can_garlic()) or can_bull())
end

function can_open_treasure()
    return can_jet() or can_dragon() or can_dash()
end