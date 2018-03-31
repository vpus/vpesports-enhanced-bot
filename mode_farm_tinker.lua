local npcBot      = GetBot()
local botTeam     = GetTeam()

local sequence    = 0

function GetDesire()
	local gameTime = DotaTime()
	local bootsSlot = npcBot:FindItemSlot("item_travel_boots")
	if npcBot:GetItemSlotType(bootsSlot) == ITEM_SLOT_TYPE_MAIN or gameTime < 0 then
		return _G.desires[6]
	end
	
	return _G.desires[0]
end

function Think()
	local gameTime     = DotaTime()
	local botLoc       = npcBot:GetLocation()
	local action       = npcBot:GetCurrentActionType()
	local botMana      = npcBot:GetMana()
	local botHealth    = npcBot:GetHealth()
	local botMaxHealth = npcBot:GetMaxHealth()
	local botMaxMana   = npcBot:GetMaxMana()
	local botHPRegen   = npcBot:GetHealthRegen()
	local botManaRegen = npcBot:GetManaRegen()
	local level        = npcBot:GetLevel()
	local blinkSlot    = npcBot:FindItemSlot("item_blink")
	local bootsSlot    = npcBot:FindItemSlot("item_travel_boots")
	local currentGold  = npcBot:GetGold()
	local currentLane  = nil
	
	local boots = nil
	local blink = nil
	if npcBot:GetItemSlotType(bootsSlot) == ITEM_SLOT_TYPE_MAIN then
		boots = npcBot:GetItemInSlot(bootsSlot)
	end
	if npcBot:GetItemSlotType(blinkSlot) == ITEM_SLOT_TYPE_MAIN then
		blink = npcBot:GetItemInSlot(blinkSlot)
	end
	
	local towerStatusTopRad = _G.GetTowerStatus("top", TEAM_RADIANT)
	local towerStatusMidRad = _G.GetTowerStatus("mid", TEAM_RADIANT)
	local towerStatusBotRad = _G.GetTowerStatus("bot", TEAM_RADIANT)
	local towerStatusTopDir = _G.GetTowerStatus("top", TEAM_DIRE)
	local towerStatusMidDir = _G.GetTowerStatus("mid", TEAM_DIRE)
	local towerStatusBotDir = _G.GetTowerStatus("bot", TEAM_DIRE)
	
	local creepLaneTopRad = _G.GetLaneCreepStatus(LANE_TOP, TEAM_RADIANT)
	local creepLaneMidRad = _G.GetLaneCreepStatus(LANE_MID, TEAM_RADIANT)
	local creepLaneBotRad = _G.GetLaneCreepStatus(LANE_BOT, TEAM_RADIANT)
	local creepLaneTopDir = _G.GetLaneCreepStatus(LANE_TOP, TEAM_DIRE)
	local creepLaneMidDir = _G.GetLaneCreepStatus(LANE_MID, TEAM_DIRE)
	local creepLaneBotDir = _G.GetLaneCreepStatus(LANE_BOT, TEAM_DIRE)
	
	local laser   = npcBot:GetAbilityByName("tinker_laser");
	local missile = npcBot:GetAbilityByName("tinker_heat_seeking_missile");
	local march   = npcBot:GetAbilityByName("tinker_march_of_the_machines");
	local rearm   = npcBot:GetAbilityByName("tinker_rearm");
	
	local allies  = GetUnitList(UNIT_LIST_ALLIED_HEROES)
	local enemies = GetUnitList(UNIT_LIST_ENEMY_HEROES)
	
	local topFrontAmount = GetLaneFrontAmount(botTeam, LANE_TOP, false)
	local midFrontAmount = GetLaneFrontAmount(botTeam, LANE_MID, false)
	local botFrontAmount = GetLaneFrontAmount(botTeam, LANE_BOT, false)
	
	if currentLane == nil then
    	if topFrontAmount <= midFrontAmount and topFrontAmount <= botFrontAmount then
    		currentLane = LANE_TOP
    	elseif midFrontAmount <= topFrontAmount and midFrontAmount <= botFrontAmount then
    		currentLane = LANE_MID
    	elseif botFrontAmount <= topFrontAmount and botFrontAmount <= midFrontAmount then
    		currentLane = LANE_BOT
    	end
    end	
    
	if currentLane ~= nil and gameTime > 0 and boots ~= nil and action ~= BOT_ACTION_TYPE_USE_ABILITY and not npcBot:IsChanneling() then
		local frontLocation = GetLaneFrontLocation(botTeam, currentLane, 200)
		local distFromFront = GetUnitToLocationDistance(npcBot, frontLocation)
		local fountain      = GetShopLocation(GetTeam(), SHOP_HOME)
		local nearbyCreeps  = npcBot:GetNearbyCreeps(1600, true)
		local nearbyEnemies = npcBot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
		
		local marchMana = march:GetManaCost()
		local laserMana = laser:GetManaCost()
		local bootsMana = boots:GetManaCost()
		
		-- Return To Base
		if sequence == 0 then
			if boots:IsFullyCastable() and GetUnitToLocationDistance(npcBot, fountain) > 1000 and not npcBot:IsChanneling() then
				print("0: Casting Boots To Fountain")
				npcBot:Action_UseAbilityOnLocation(boots, fountain)
				sequence = 1
			elseif GetUnitToLocationDistance(npcBot, fountain) <= 1000 then
				sequence = 1
			elseif not boots:IsCooldownReady() and not npcBot:IsChanneling() then
				print("0: REARMING!")
				npcBot:Action_UseAbility(rearm)
			elseif not boots:IsFullyCastable() and not rearm:IsFullyCastable() then
				npcBot:Action_MoveToLocation(fountain)
			end
		-- Rearm
		elseif sequence == 1 then
			if GetUnitToLocationDistance(npcBot, fountain) <= 1000 
				and rearm:IsFullyCastable() 
				and not npcBot:IsChanneling()
				and not boots:IsCooldownReady() then
				print("1: REARMING!")
				npcBot:Action_UseAbility(rearm)
				sequence = 2
			elseif GetUnitToLocationDistance(npcBot, fountain) > 1000 then
				print("1: Too Far From Fountain, Back to 0")
				sequence = 0
			elseif GetUnitToLocationDistance(npcBot, fountain) <= 1000 
				and boots:IsCooldownReady() then
				print("2: Waiting For Mana At Fountain")
				sequence = 2
			end
		-- Wait For Mana
		elseif sequence == 2 then
			if botMana/botMaxMana >= 0.8 then
				sequence = 3
			end
		-- TP To Lane Front
		elseif sequence == 3 then
			if distFromFront >= 500 and boots:IsFullyCastable() and not npcBot:IsChanneling() then
				print("3: Casting Boots To Lane")
				npcBot:Action_UseAbilityOnLocation(boots, GetLaneFrontLocation(botTeam, currentLane, 200))
				sequence = 4
			elseif not boots:IsFullyCastable() and rearm:IsFullyCastable() and not npcBot:IsChanneling() then
				print("3: REARMING!")
				npcBot:Action_UseAbility(rearm)
			elseif distFromFront < 500 then
				sequence = 4
			end
		-- Blink If You Can!
		elseif sequence == 4 then
			if blink ~= nil and #nearbyEnemies > 0 then
				if blink:IsFullyCastable() and not npcBot:IsChanneling() then
					print("5: Time To Blink!")
					local trees    = npcBot:GetNearbyTrees(1000)
					local treeLocs = {}
					for tree in ipairs(trees) do
						table.insert(treeLocs, GetTreeLocation(tree))
					end
					
					local centroids = _G.clusterAndGetCentroids(treeLocs)
					
					if table.getn(centroids) > 0 then
						local closestDist = 0
						local closestPoint = nil
						for centroid in ipairs(centroids) do
							local dist = GetUnitToLocationDistance(npcBot, centroid)
							if closestDist == 0 then
								closestDist = dist
								closestPoint = centroid
							elseif closestDist > dist then
								closestDist = dist
								closestPoint = centroid
							end
						end
						
						npcBot:Action_UseAbilityOnLocation(blink, closestPoint)
					else
						npcBot:Action_UseAbilityOnLocation(blink, fountain)
					end
				end
			end
			-- Don't wait for Blink
			sequence = 5
		-- Cast March In Creep Lane
		elseif sequence == 5 then
			if march:IsFullyCastable() and botMana >= (marchMana + bootsMana) and #nearbyCreeps > 2 and not npcBot:IsChanneling() then
				print("4: Casting March")
				local distToPoint = GetUnitToLocationDistance(npcBot, nearbyCreeps[1]:GetLocation())
				local marchLoc    = nearbyCreeps[1]:GetLocation()
				if distToPoint < 900 then
					if distToPoint >= 300 then
						marchLoc = _G.getVectorBetweenTargetDistance(npcBot, nearbyCreeps[1], 300)
						npcBot:Action_UseAbilityOnLocation(march, marchLoc)
					else
						npcBot:Action_UseAbilityOnLocation(march, marchLoc)
					end
				else
					npcBot:Action_MoveToLocation(marchLoc)
				end
				sequence = 5
			elseif #nearbyCreeps == 0 and distFromFront >= 2000 and not npcBot:IsChanneling() then
				sequence = 3
			elseif #nearbyCreeps == 0 and distFromFront < 2000 and not npcBot:IsChanneling() then
				print("4: Too Far From Creeps, Walking")
				npcBot:Action_MoveToLocation(frontLocation)
			elseif laser:IsFullyCastable() and botMana >= (laserMana + bootsMana) and #nearbyCreeps > 0 and #nearbyCreeps < 2 and not npcBot:IsChanneling() then
				print("4: Not Enough Creeps Around, Casting Laser")
				npcBot:Action_UseAbilityOnEntity(laser, nearbyCreeps[1])
			elseif botMana >= (marchMana + bootsMana) then
				print("4: No Mana, Moving On")
				sequence = 6
			end
		-- Cast March Again Or Move On
		elseif sequence == 6 then
			if #nearbyCreeps > 2 and botMana >= (marchMana + bootsMana) and not npcBot:IsChanneling() then
				print("4: Casting March Again")
				npcBot:Action_UseAbilityOnLocation(march, nearbyCreeps[1]:GetLocation())
			end
			-- Don't wait to March twice
			sequence = 7
		-- Rearm And Start Over
		elseif sequence == 7 then
			if rearm:IsFullyCastable() and not npcBot:IsChanneling() then
				print("5: REARMING!")
				npcBot:Action_UseAbility(rearm)
				print("5: Back To 0")
				sequence = 0
			end
		end
	elseif gameTime < 0 then
		npcBot:Action_MoveToLocation(GetTower(botTeam, TOWER_MID_1):GetLocation() + RandomVector(200))
	end
end
