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

function can_duck()
    return has("duck")
end

function can_dash()
    return (has("dash") and (can_garlic() or can_bull()))
end

function can_open_treasure()
    return can_jet() or can_dragon() or can_dash()
end

function can_hit_groundblock()
    return can_jet() or (can_dragon() and can_duck()) or can_dash()
end

function can_hit_elevated_groundblock()
	return can_jet() or can_dragon() or can_dash()
end

function can_grow()
	return can_garlic() or can_bull() or can_dragon() or can_jet()
end