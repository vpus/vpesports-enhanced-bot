require(GetScriptDirectory().."/UtilityData")
require(GetScriptDirectory().."/UtilityFunctions")

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
	
	local topFrontLoc = GetLaneFrontLocation(botTeam, LANE_TOP, 0)
	local midFrontLoc = GetLaneFrontLocation(botTeam, LANE_MID, 0)
	local botFrontLoc = GetLaneFrontLocation(botTeam, LANE_BOT, 0)
	
	local enemyHeroes = GetUnitList(UNIT_LIST_ENEMY_HEROES)
	local topEnemies  = 0
	local midEnemies  = 0
	local botEnemies  = 0
	
	for e = 1, table.getn(enemyHeroes) do
		local enemy = enemyHeroes[e]
		if enemy ~= nil then
			local topDist = GetUnitToLocationDistance(enemy, topFrontLoc)
			local midDist = GetUnitToLocationDistance(enemy, midFrontLoc)
			local botDist = GetUnitToLocationDistance(enemy, botFrontLoc)
			
			if topDist < 1000 then
				topEnemies = topEnemies + 1
			end
			if midDist < 1000 then
				midEnemies = midEnemies + 1
			end
			if botDist < 1000 then
				botEnemies = botEnemies + 1
			end
			
		end
	end
	
	if currentLane == nil then
		local lanes = {}
    	if topFrontAmount <= midFrontAmount and topFrontAmount <= botFrontAmount then
    		table.insert(lanes, LANE_TOP)
    		if midFrontAmount <= botFrontAmount then
    			table.insert(lanes, LANE_MID)
    			table.insert(lanes, LANE_BOT)
    		else
    			table.insert(lanes, LANE_BOT)
    			table.insert(lanes, LANE_MID)
    		end
    	elseif midFrontAmount <= topFrontAmount and midFrontAmount <= botFrontAmount then
    		table.insert(lanes, LANE_MID)
    		if topFrontAmount <= botFrontAmount then
    		   	table.insert(lanes, LANE_TOP)
    			table.insert(lanes, LANE_BOT)
    		else
    		   	table.insert(lanes, LANE_BOT)
    			table.insert(lanes, LANE_TOP)
    		end
    	elseif botFrontAmount <= topFrontAmount and botFrontAmount <= midFrontAmount then
    		table.insert(lanes, LANE_BOT)
    		if midFrontAmount <= topFrontAmount then
    		   	table.insert(lanes, LANE_MID)
    			table.insert(lanes, LANE_TOP)
    		else
    		   	table.insert(lanes, LANE_TOP)
    			table.insert(lanes, LANE_MID)
    		end
    	end
    
        for l = 1, table.getn(lanes) do
        	local lane = lanes[l]
        	
        	if lane == LANE_TOP then
        		if topEnemies < 2 then
        			currentLane = LANE_TOP
        			break
        		end
        	elseif lane == LANE_MID then
        		if midEnemies < 2 then
        			currentLane = LANE_MID
        			break
        		end
        	else
        		if botEnemies < 2 then
        			currentLane = LANE_BOT
        			break
        		end
        	end
        end
    end
    
	if currentLane ~= nil and gameTime > 0 and boots ~= nil and action ~= BOT_ACTION_TYPE_USE_ABILITY and not npcBot:IsChanneling() then
		local frontLoc      = GetLaneFrontLocation(botTeam, currentLane, 200)
		local fountainLoc   = GetShopLocation(GetTeam(), SHOP_HOME)
		local frontDist     = GetUnitToLocationDistance(npcBot, frontLoc)
		local fountainDist  = GetUnitToLocationDistance(npcBot, fountainLoc)
		local nearbyCreeps  = npcBot:GetNearbyCreeps(1600, true)
		local nearbyEnemies = npcBot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
		
		local numCreeps  = table.getn(nearbyCreeps)
		local numEnemies = table.getn(nearbyEnemies)
		
		local marchMana = march:GetManaCost()
		local laserMana = laser:GetManaCost()
		local bootsMana = boots:GetManaCost()
		
--		local castedMarch = false
--        local castedBlink = false
--        
--        local maxFountDist = 500
--        local maxFrontDist = 500
--        
--        local queueSize = npcBot:NumQueuedActions()
--        
--        if not npcBot:IsChanneling() and queueSize == 0 then
--            -- At Fountain
--            if fountainDist < maxFountDist then
--                if fountainDist < 300 then
--                    if botMana/botMaxMana > 0.75 then
--                        if boots:IsFullyCastable() then
--                            -- TP to lane
--                            print("    Teleporting to Lane Front")
--                            npcBot:Action_UseAbilityOnLocation(boots, frontLoc)
--                        else
--                        	print("    Rearming!")
--                            npcBot:Action_UseAbility(rearm)
--                        end
--                    end
--                else
--                    -- Move to fountain
--                    print("    Walking to Fountain")
--                    npcBot:Action_MoveToLocation(fountainLoc)
--                end
--            -- At Lane Front
--            elseif frontDist < maxFrontDist then
--                -- Cast March
--                if numCreeps > 0 and botMana >= (march:GetManaCost() + boots:GetManaCost() + rearm:GetManaCost()) then
--                    local distToPoint = GetUnitToLocationDistance(npcBot, nearbyCreeps[1]:GetLocation())
--    				local marchLoc    = nearbyCreeps[1]:GetLocation()
--    				if distToPoint < 900 then
--    					if distToPoint >= 300 then
--    						marchLoc = _G.getVectorBetweenTargetDistance(npcBot, nearbyCreeps[1], 300)
--    						npcBot:Action_UseAbilityOnLocation(march, marchLoc)
--    					else
--    						npcBot:Action_UseAbilityOnLocation(march, marchLoc)
--    					end
--    				else
--    					npcBot:Action_MoveToLocation(marchLoc)
--    				end
--					print("    Casting March")
--                    npcBot:Action_UseAbilityOnLocation(march, marchLoc)
--                    if botMana < (march:GetManaCost() + boots:GetManaCost() + rearm:GetManaCost()) then
--                        -- Don't cast March again if mana isn't enough
--                        print("    Done Marching!")
--                        castedMarch = true
--                    end
--                -- Done Marching, TP to fountain
--                elseif castedMarch then
--                    -- Queue rearm if boots is under cooldown
--                    if not boots:IsCooldownReady() then
--                    	print("    Queueing Rearm AND TP to Fountain")
--                        npcBot:ActionQueue_UseAbility(rearm)
--                    else
--                    	print("    Teleporting to Fountain")
--                    end
--                    npcBot:ActionQueue_UseAbilityOnLocation(boots, fountainLoc)
--                -- Walk to Front
--                elseif numCreeps == 0 and not castedMarch then
--                	print("    Walking to Front")
--                    npcBot:Action_MoveToLocation(frontLoc)
--                -- Can't do anything else but attack
--                elseif numCreeps > 0 and not castedMarch and action ~= BOT_ACTION_TYPE_ATTACK then
--                	print("    Nothing To Do, Attacking Creeps")
--                    npcBot:Action_AttackUnit(nearbyCreeps[1], true)
--                elseif boots:IsFullyCastable() then
--                	npcBot:Action_UseAbilityOnLocation(boots, fountainLoc)
--                end
--            end
--        end
		
		print(sequence)
		-- Return To Base
		if sequence == 0 then
			if boots:IsFullyCastable() and GetUnitToLocationDistance(npcBot, fountainLoc) > 1000 and not npcBot:IsChanneling() then
				print("0: Casting Boots To Fountain")
				npcBot:Action_UseAbilityOnLocation(boots, fountainLoc)
				sequence = 1
			elseif GetUnitToLocationDistance(npcBot, fountainLoc) <= 1000 then
				sequence = 1
			elseif not boots:IsCooldownReady() and not npcBot:IsChanneling() then
				print("0: REARMING!")
				npcBot:Action_UseAbility(rearm)
			elseif not boots:IsFullyCastable() and not rearm:IsFullyCastable() then
				npcBot:Action_MoveToLocation(fountainLoc)
			end
		-- Rearm
		elseif sequence == 1 then
			if GetUnitToLocationDistance(npcBot, fountainLoc) <= 1000 
				and rearm:IsFullyCastable() 
				and not npcBot:IsChanneling()
				and not boots:IsCooldownReady() then
				print("1: REARMING!")
				npcBot:Action_UseAbility(rearm)
				sequence = 2
			elseif GetUnitToLocationDistance(npcBot, fountainLoc) > 1000 then
				print("1: Too Far From Fountain, Back to 0")
				sequence = 0
			elseif GetUnitToLocationDistance(npcBot, fountainLoc) <= 1000 
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
			if frontDist >= 500 and boots:IsFullyCastable() and not npcBot:IsChanneling() then
				print("3: Casting Boots To Lane")
				npcBot:Action_UseAbilityOnLocation(boots, GetLaneFrontLocation(botTeam, currentLane, 200))
				sequence = 4
			elseif not boots:IsFullyCastable() and rearm:IsFullyCastable() and not npcBot:IsChanneling() then
				print("3: REARMING!")
				npcBot:Action_UseAbility(rearm)
			elseif frontDist < 500 then
				sequence = 4
			end
		-- Blink If You Can!
		elseif sequence == 4 then
			if blink ~= nil and numEnemies > 0 then
				if blink:IsFullyCastable() and not npcBot:IsChanneling() then
					print("4: Time To Blink!")
--					local trees    = npcBot:GetNearbyTrees(1000)
--					local treeLocs = {}
--					for tree in ipairs(trees) do
--						table.insert(treeLocs, GetTreeLocation(tree))
--					end
--					
--					local centroids = _G.clusterAndGetCentroids(treeLocs)
--					print(table.getn(centroids))
--					if table.getn(centroids) > 0 then
--						local closestDist = 0
--						local closestPoint = nil
--						for centroid in ipairs(centroids) do
--							local dist = GetUnitToLocationDistance(npcBot, centroid)
--							if closestDist == 0 then
--								closestDist = dist
--								closestPoint = centroid
--							elseif closestDist > dist then
--								closestDist = dist
--								closestPoint = centroid
--							end
--						end
--						
--						npcBot:Action_UseAbilityOnLocation(blink, closestPoint)
--					else
--						npcBot:Action_UseAbilityOnLocation(blink, fountain)
--					end
					npcBot:Action_UseAbilityOnLocation(blink, fountainLoc)
					sequence = 5
				end
			else
				sequence = 5
			end
		-- Cast March In Creep Lane
		elseif sequence == 5 then
			if march:IsFullyCastable() and botMana >= (marchMana + bootsMana) and numCreeps > 1 and not npcBot:IsChanneling() then
				print("5: Casting March!")
				local distToPoint = GetUnitToLocationDistance(npcBot, nearbyCreeps[1]:GetLocation())
				local marchLoc    = nearbyCreeps[1]:GetLocation()
				print(distToPoint)
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
				sequence = 6
			elseif numCreeps == 0 and frontDist >= 2000 and not npcBot:IsChanneling() then
				sequence = 3
			elseif numCreeps == 0 and frontDist < 2000 and not npcBot:IsChanneling() then
				print("5: Too Far From Creeps, Walking")
				npcBot:Action_MoveToLocation(frontLoc)
			elseif laser:IsFullyCastable() and botMana >= (laserMana + bootsMana) and numCreeps > 0 and numCreeps < 2 and not npcBot:IsChanneling() then
				print("5: Not Enough Creeps Around, Casting Laser")
				npcBot:Action_UseAbilityOnEntity(laser, nearbyCreeps[1])
			elseif botMana < (marchMana + bootsMana) then
				print("5: No Mana, Moving On")
				sequence = 6
			end
		-- Cast March Again Or Move On
		elseif sequence == 6 then
			if march:IsFullyCastable() and numCreeps > 1 and botMana >= (marchMana + bootsMana) and not npcBot:IsChanneling() then
				print("6: Casting March Again")
				npcBot:Action_UseAbilityOnLocation(march, nearbyCreeps[1]:GetLocation())
				sequence = 7
			elseif not march:IsFullyCastable() and numCreeps > 1 and botMana >= (marchMana + bootsMana) and not npcBot:IsChanneling() then
				npcBot:Action_UseAbility(rearm)
			else
				sequence = 7
			end
		-- Rearm And Start Over
		elseif sequence == 7 then
			if rearm:IsFullyCastable() and not npcBot:IsChanneling() then
				print("7: REARMING!")
				npcBot:Action_UseAbility(rearm)
				print("7: Back To 0")
				sequence = 0
			end
		end
	elseif gameTime < 0 then
		npcBot:Action_MoveToLocation(GetTower(botTeam, TOWER_MID_1):GetLocation() + RandomVector(200))
	end
end
