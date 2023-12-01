ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/tab_mapping.lua")
CUR_INDEX = -1
SLOT_DATA = nil


function onClear(slot_data)
    SLOT_DATA = slot_data
    CUR_INDEX = -1
	--for k, v in pairs(SLOT_DATA) do
	--	print(string.format("called onClear, slot_data:\n%s %s", k, v))
	--end
    for _, v in pairs(ITEM_MAPPING) do
        if v[1] then
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[2] == "toggle" then
                    obj.Active = false
                elseif v[2] == "progressive" then
                    if obj.Active then
                        obj.CurrentStage = 0
                    end
                elseif v[2] == "consumable" then
                    obj.AcquiredCount = 0
                end
            end
        end
    end

    for k, v in pairs(LOCATION_MAPPING) do
        local loc_data = LOCATION_MAPPING[k]
        local loc_name = loc_data[1]
        local loc_type = loc_data[2]
        local level_str = "@" .. loc_name .. "/" .. loc_type
        local obj = Tracker:FindObjectForCode(level_str)
        if obj then
                obj.AvailableChestCount = obj.ChestCount
        end
        
    end

    if SLOT_DATA == nil then
        return
    end
	
	PLAYER_ID = Archipelago.PlayerNumber or -1
	TEAM_NUMBER = Archipelago.TeamNumber or 0

    if slot_data['treasure_checks'] then
        local treasure_checks = Tracker:FindObjectForCode("treasure_checks")
        treasure_checks.Active = (slot_data['treasure_checks'] ~= 0)
    end
	
	if slot_data['world_unlocks'] then
        local world_unlocks = Tracker:FindObjectForCode("world_unlocks")
        world_unlocks.Active = (slot_data['world_unlocks'] ~= 0)
    end
	
	if slot_data['boss_unlocks'] then
        local boss_unlocks = Tracker:FindObjectForCode("boss_unlocks")
        boss_unlocks.Active = (slot_data['boss_unlocks'] ~= 0)
    end
	
	if slot_data['blocksanity'] then
        local blocksanity = Tracker:FindObjectForCode("blocksanity")
        blocksanity.Active = (slot_data['blocksanity'] ~= 0)
    end
	
	if slot_data['goal']==0 then
		Tracker:FindObjectForCode("goal").Active = 0
		Tracker:FindObjectForCode("bosses_required").AcquiredCount = tonumber(slot_data["bosses_required"])
	end
	
	if slot_data['goal']==1 then
		required_cloves=tonumber(slot_data["number_of_garlic_cloves"])*(tonumber(slot_data["percentage_of_garlic_cloves"])/100)
		Tracker:FindObjectForCode("goal").Active = 1
		Tracker:FindObjectForCode("garlic_cloves_required").AcquiredCount = required_cloves
	end
	
	if Archipelago.PlayerNumber>-1 then
		EVENT_ID="warioland_curlevelid_"..TEAM_NUMBER.."_"..PLAYER_ID
		Archipelago:SetNotify({EVENT_ID})
		Archipelago:Get({EVENT_ID})
	end
	
	--Default tab switching to on
	Tracker:FindObjectForCode("tab_switch").Active = 1
end

function onItem(index, item_id, item_name, player_number)
    if index <= CUR_INDEX then return end
    local is_local = player_number == Archipelago.PlayerNumber
    CUR_INDEX = index;
    
    local v = ITEM_MAPPING[item_id]
    if not v then
        return
    end

    if not v[1] then
        return
    end

    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[2] == "toggle" then
            obj.Active = true
        elseif v[2] == "progressive" then
            if obj.Active then
                obj.CurrentStage = obj.CurrentStage + 1
            else
                obj.Active = true
            end
        elseif v[2] == "consumable" then
            obj.AcquiredCount = obj.AcquiredCount + obj.Increment
        end
    end
end

function onLocation(location_id, location_name)

    print(location_name)

    local loc_data = LOCATION_MAPPING[location_id]
    if not loc_data then
        return
    end
    local loc_name = loc_data[1]
    local loc_type = loc_data[2]
    local level_str = "@" .. loc_name .. "/" .. loc_type
    local obj = Tracker:FindObjectForCode(level_str)
    if obj then
        obj.AvailableChestCount = obj.AvailableChestCount - 1
    end
	--handle specific cases for logic
	if loc_name=="Rice Beach 05" and loc_type=="Boss" then
		local obj = Tracker:FindObjectForCode("rb_flooded")
		obj.Active = true
	end
	if loc_name=="Parsley Woods 32" and loc_type=="Normal Exit" then
		local obj = Tracker:FindObjectForCode("pw_drained")
		obj.Active = true
	end
	if loc_name=="Mt. Teapot 12" and loc_type=="Normal Exit" then
		local obj = Tracker:FindObjectForCode("mt_boss_tile_unlocked")
		obj.Active = true
	end
end

function onNotify(key, value, old_value)
	updateEvents(value)
end

function onNotifyLaunch(key, value)
	updateEvents(value)
end

function updateEvents(value)
	if value ~= nil then
		local tabswitch = Tracker:FindObjectForCode("tab_switch")
		Tracker:FindObjectForCode("cur_level_id").CurrentStage = value
		if tabswitch.Active then
			if TAB_MAPPING[value] then
				CURRENT_ROOM = TAB_MAPPING[value]
				--print(string.format("Updating ID %x to Tab %s",value,CURRENT_ROOM))
			else
				CURRENT_ROOM = 0x30
			end
        Tracker:UiHint("ActivateTab", CURRENT_ROOM)
		end
	end
end

Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
Archipelago:AddSetReplyHandler("notify handler", onNotify)
Archipelago:AddRetrievedHandler("notify launch handler", onNotifyLaunch)