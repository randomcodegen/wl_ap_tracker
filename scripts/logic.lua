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

function world_access(code)
    return not has("world_unlocks") or has(code)
end

function course_access(code)
    return not has("level_unlocks") or has(code)
end

function boss_access(code)
    return not has("boss_unlocks") or has(code)
end

function can_flood_rice_beach()
    return world_access("ricebeach") and boss_access("ricebeach_bossunlock")
end

function can_clear_course12()
    return world_access("mtteapot") and course_access("course12") and (can_jet() or can_climb())
end

function can_drain_lake()
    return world_access("parsleywoods") and course_access("course32")
end

function has_powerup(code, tier)
    if has(code) or has("powerup_" .. tier) then return true end
    if has("get_previous_powerups") then
        local powers = {"garlic_powerup", "bull", "dragon", "jet"}
        for i = tier + 1, #powers do
            if has(powers[i]) then return true end
        end
    end
    return false
end

function can_garlic()
    return has_powerup("garlic_powerup", 1)
end

function can_bull()
    return has_powerup("bull", 2)
end

function can_dragon()
    return has_powerup("dragon", 3)
end

function can_jet()
    return has_powerup("jet", 4)
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