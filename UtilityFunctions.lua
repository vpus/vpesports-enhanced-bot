require(GetScriptDirectory().."/UtilityData");

function fillTalentTable(bot)
	local skills = {};
	for i = 0, 23 
	do
		local ability = bot:GetAbilityInSlot(i);
		if ability ~= nil and ability:IsTalent() then
			table.insert(skills, ability:GetName());
		end
	end
	return skills
end

-- Gets a list of units of a specific type,
-- then narrows the list down to only ones with a specific name
function getAllUnitsByName(unitName, unitType)
	local units = {};
	for _, unit in pairs(GetUnitList(unitType)) do
		if unit:GetUnitName() == unitName then
			table.insert(units, unit);
		end
	end

	return units;
end

local currentAction = 0;
local arcaneBoots   = nil;
local pointBooster  = nil;
local droppedPB     = false;
local droppedAB     = false;

-- Use Soul Ring, after dropping Arcane Boots and Point Booster if owned
-- Returns true if at least Soul Ring was used
function useSoulRing(bot)
	local SoulRing = nil;
	local queue    = bot:NumQueuedActions();
	local action   = bot:GetCurrentActionType();

	for i = 0, 5, 1 do
		local item = bot:GetItemInSlot(i);
		if item ~= nil then
			local itemName = item:GetName();
			if itemName == "item_soul_ring" then
				SoulRing = item;
			elseif itemName == "item_arcane_boots" then
				arcaneBoots = item;
				-- hasArcane   = true;
			elseif itemName == "item_point_booster" then
				pointBooster = item;
				-- hasPB        = true;
			end
		end
	end

	if SoulRing ~= nil and SoulRing:IsFullyCastable() then
		bot:ActionPush_UseAbility(SoulRing);
	elseif arcaneBoots ~= nil and arcaneBoots:IsFullyCastable() then
		bot:ActionPush_UseAbility(arcaneBoots);
	end

	-- if SoulRing == nil then
	-- 	return false;
	-- elseif arcaneBoots == nil and pointBooster == nil and SoulRing:IsFullyCastable() and not usedRing then
	-- 	print("USING ITEM soul ring, Arcane Boots: "..((arcaneBoots == nil) and "false" or "true").." Point Booster: "..((pointBooster == nil) and "false" or "true"));
	-- 	bot:ActionPush_UseAbility(SoulRing);
	-- 	usedRing = true;
	-- elseif SoulRing:IsFullyCastable() or usedRing then
	-- 	-------------------------------------------------------------------------
	-- 	-- Bot currently drops arcane boots and point booster as intended, 
	-- 	-- but does not pick them back up after using Soul Ring
	-- 	-------------------------------------------------------------------------

	-- 	local botLoc = bot:GetLocation();
	-- 	-- if currentAction == 0 and queue == 0 then
	-- 	-- 	if arcaneBoots ~= nil then
	-- 	-- 		bot:ActionQueue_DropItem(arcaneBoots, botLoc + RandomVector(10));
	-- 	-- 		print("ARCANE BOOTS DROPPED!");
	-- 	-- 		droppedAB = true;
	-- 	-- 	end
	-- 	-- 	currentAction = 1;
	-- 	-- elseif currentAction == 1 and queue == 0 then
	-- 	-- 	if pointBooster ~= nil then
	-- 	-- 		bot:ActionQueue_DropItem(pointBooster, botLoc + RandomVector(20));
	-- 	-- 		print("POINT BOOSTER DROPPED!");
	-- 	-- 		droppedPB = true;
	-- 	-- 	end
	-- 	-- 	currentAction = 2;
	-- 	-- else
	-- 	-- if currentAction == 2 and queue == 0 then
	-- 		bot:ActionPush_UseAbility(SoulRing);
	-- 		-- currentAction = 3;
	-- 	-- elseif currentAction == 3 and queue == 0 then
	-- 	-- 	if droppedAB then
	-- 	-- 		if action ~= _G.actions["pick_item"] then
	-- 	-- 			bot:ActionQueue_PickUpItem(arcaneBoots);
	-- 	-- 			droppedAB = false;
	-- 	-- 		end
	-- 	-- 	end
	-- 	-- 	currentAction = 4;
	-- 	-- elseif currentAction == 4 and queue == 0 then
	-- 	-- 	if droppedPB then
	-- 	-- 		if action ~= _G.actions["pick_item"] then
	-- 	-- 			bot:ActionQueue_PickUpItem(pointBooster);
	-- 	-- 			droppedPB = false;
	-- 	-- 		end
	-- 	-- 	end
	-- 	-- 	currentAction = 5;
	-- 	-- end
	-- end
	-- if currentAction == 5 then
	-- 	return true;
	-- end
end

function hasItem(itemToFind, bot)
	itemSlot = bot:FindItemSlot(itemToFind);
	if itemSlot >= 0 then
		return true;
	end
	return false;
end

-- Find an item in the bot's inventory and use it if it's
-- able to be used or hasn't already been used.
-- Returns false if the item was not able to be used
function useItem(bot, item_name, target, modifier)
	if bot:HasModifier(modifier) then
		return false;
	else
		local item = nil;
		for i = 0, 5, 1 do
			local itemSlot = bot:GetItemInSlot(i);
			if itemSlot ~= nil then
				local itemName = itemSlot:GetName();
				if itemName == item_name then
					item = itemSlot;
					break;
				end
			end
		end

		if item ~= nil then
			if target ~= nil then
				if item_name == "item_tango" then
					bot:ActionPush_UseAbilityOnTree(item, bot);
				else
					bot:ActionPush_UseAbilityOnEntity(item, bot);
				end
			else
				bot:ActionPush_UseAbility(item);
			end
			return true;
		end
		return false;
	end
end

-- Get's the distance between two points on the map
function getDistanceBetweenTwoPoints(vector1, vector2)
	x1 = vector1[1];
	y1 = vector1[2];
	x2 = vector2[1];
	y2 = vector2[2];

	xd = x1-x2;
	yd = y1-y2
	return math.sqrt((xd * xd) + (yd * yd));
end

-- Get a location farther away from a point
-- Used to get a location to move away from an enemy
-- Since there may be obstacles in the way, best to use a very far distance
-- and cancel move when needed
-- TODO: be able to consider more than one enemy and find the optimal fallback location
function getRetreatLocation(botLoc, enemyLoc, distance)
	-- local currDistance = getDistanceBetweenTwoPoints(vector1, vector2);
	local slope = (botLoc[2] - enemyLoc[2]) / (botLoc[1] - enemyLoc[1])
	local theta = math.atan(slope);
	local newX  = botLoc[1] + distance * (math.cos(theta));
	local newY  = botLoc[2] + distance * (math.sin(theta));

	if newX > 8200 then
		newX = 8200;
	elseif newX < -8200 then
		newX = -8200;
	end

	if newY > 8200 then
		newY = 8200;
	elseif newY < -8200 then
		newY = -8200;
	end
	
	return Vector(newX, newY);
end

-- Check where the bot is within the lane and return a fallback location
-- in the opposite direction from the enemy
function getFallbackInLane(lane, botLoc, fallbackDist)
	if lane ~= LANE_MID then
		if botTeam == TEAM_RADIANT then
			if lane == LANE_TOP then
				local dist1 = PointToLineDistance(_G.top_lane[1], _G.top_lane[2], botLoc);
				local dist2 = PointToLineDistance(_G.top_lane[2], _G.top_lane[3], botLoc);

				if dist1 ~= nil and dist2 ~= nil then
					if dist1[1] < dist2[1] then
						return (botLoc - Vector(0, fallbackDist));
					else
						return (botLoc - Vector(fallbackDist, 0));
					end
				end
			else
				local dist1 = PointToLineDistance(_G.bot_lane[1], _G.bot_lane[2], botLoc);
				local dist2 = PointToLineDistance(_G.bot_lane[2], _G.bot_lane[3], botLoc);

				if dist1 ~= nil and dist2 ~= nil then
					if dist1.distance < dist2.distance then
						return (botLoc - Vector(fallbackDist, 0));
					else
						return (botLoc - Vector(0, fallbackDist));
					end
				end
			end
		else
			if lane == LANE_TOP then
				local dist1 = PointToLineDistance(_G.top_lane[3], _G.top_lane[2], botLoc);
				local dist2 = PointToLineDistance(_G.top_lane[2], _G.top_lane[1], botLoc);

				print("Fallback1: "..dist1.closest_point[1]..","..dist1.closest_point[2]);
                print("Fallback2: "..dist2.closest_point[1]..","..dist2.closest_point[2]);

                if dist1 == nil or dist2 == nil then
                    if dist1 == nil then
                        return (botLoc + Vector(0, fallbackDist));
                    else
                        return (botLoc + Vector(fallbackDist, 0));
                    end
                end

				if dist1 ~= nil and dist2 ~= nil then
					if dist1.distance < dist2.distance then
                        local fallbackPoint = botLoc + Vector(0, fallbackDist);
						return fallbackPoint;
					else
                        local fallbackPoint = botLoc + Vector(fallbackDist, 0);
						return fallbackPoint;
					end
				end
			else
				local dist1 = PointToLineDistance(_G.bot_lane[3], _G.bot_lane[2], botLoc);
				local dist2 = PointToLineDistance(_G.bot_lane[2], _G.bot_lane[1], botLoc);

				if dist1 ~= nil and dist2 ~= nil then
					if dist1.distance < dist2.distance then
						return (botLoc + Vector(fallbackDist, 0));
					else
						return (botLoc + Vector(0, fallbackDist));
					end
				end
			end
		end
	else
		return (botLoc - Vector(fallbackDist / 2, fallbackDist / 2));
	end
end

-- Returns all towers within a lane that are still alive
-- The two towers at base are referenced by LANE_NONE
-- if lane == 5, then all living towers will be returned
function getAllTowersInLane(lane, team)
	local towersStatus = {};
	if lane == LANE_NONE or lane == 5 then
		T1 = GetTower(team, _G.towers[10]);
		T2 = GetTower(team, _G.towers[11]);
		if T1 ~= nil then table.insert(towersStatus, T1) end;
		if T2 ~= nil then table.insert(towersStatus, T2) end;
	elseif lane == LANE_TOP or lane == 5 then
		T1 = GetTower(team, _G.towers[1]);
		T2 = GetTower(team, _G.towers[4]);
		T3 = GetTower(team, _G.towers[7]);
		if T1 ~= nil then table.insert(towersStatus, T1) end;
		if T2 ~= nil then table.insert(towersStatus, T2) end;
		if T3 ~= nil then table.insert(towersStatus, T3) end;
	elseif lane == LANE_MID or lane == 5 then
		T1 = GetTower(team, _G.towers[2]);
		T2 = GetTower(team, _G.towers[5]);
		T3 = GetTower(team, _G.towers[8]);
		if T1 ~= nil then table.insert(towersStatus, T1) end;
		if T2 ~= nil then table.insert(towersStatus, T2) end;
		if T3 ~= nil then table.insert(towersStatus, T3) end;
	elseif lane == LANE_BOT or lane == 5 then
		T1 = GetTower(team, _G.towers[3]);
		T2 = GetTower(team, _G.towers[6]);
		T3 = GetTower(team, _G.towers[9]);
		if T1 ~= nil then table.insert(towersStatus, T1) end;
		if T2 ~= nil then table.insert(towersStatus, T2) end;
		if T3 ~= nil then table.insert(towersStatus, T3) end;
	end
	return towersStatus;
end

-- Returns the team's specific object
function getTeamObject(team, rad, dir)
	if team == _G.teams[1] then
		return rad;
	else
		return dir;
	end
end

-- Checks if a bot is stuck and not moving
-- Use this function for sequences where a 
-- bot can possible stop moving for no reason
function isStuck(locArray, currentLoc)
	-- Bot's been stuck long enough
	if table.getn(locArray) >= 15 then
		locArray = {};
		return true;
	else
		-- Since all entries are the same, 
		-- check only first element
		if table.getn(locArray) > 0 then
			if locArray[1] ~= currentLoc then
				locArray = {};
			else
				table.insert(currentLoc);
			end
		end
	end
	return false;
end

-- Returns the unit that has the lowest amount of HP in the group
function getWeakestEnemyUnit(unitTable)
	local currHP     = 10000;
	local lowestUnit = nil;

	for _, unit in pairs(unitTable) do
		local unitHP = unit:GetHeath();
		if unitHP < currHP then
			currHP = unitHP;
			lowestUnit = unit;
		end
	end

	return unit;
end

function getLocationFromPoint(botLoc, targetLoc, distFromPoint)
	local newX = botLoc[1];
	local newY = botLoc[2];
	local newLoc = Vector(newX, newY);

	while true do
		local dist = getDistanceBetweenTwoPoints(botLoc, newLoc);
		if math.abs(dist) <= distFromPoint then
			return newLoc
		else
			newX = (newLoc[1] + targetLoc[1])/2;
			newY = (newLoc[2] + targetLoc[2])/2;
			newLoc = Vector(newX, newY);
		end
	end
end

-- Returns a list of all towers HP status in the lane specified
function GetTowerStatus(lane, side)
	local t1HP = 0
	local t2HP = 0
	local t3HP = 0
	if side == TEAM_RADIANT then
		if lane == "top" then
			local t1 = GetTower(side, TOWER_TOP_1)
			local t2 = GetTower(side, TOWER_TOP_2)
			local t3 = GetTower(side, TOWER_TOP_3)
			if t1 ~= nil then
				t1HP = t1:GetHealth()
			end
			if t1 ~= nil then
				t2HP = t2:GetHealth()
			end
			if t1 ~= nil then
				t3HP = t3:GetHealth()
			end
			return {t1HP, t2HP, t3HP}
		elseif lane == "mid" then
			local t1 = GetTower(side, TOWER_MID_1)
			local t2 = GetTower(side, TOWER_MID_2)
			local t3 = GetTower(side, TOWER_MID_3)
			if t1 ~= nil then
				t1HP = t1:GetHealth()
			end
			if t1 ~= nil then
				t2HP = t2:GetHealth()
			end
			if t1 ~= nil then
				t3HP = t3:GetHealth()
			end
			return {t1HP, t2HP, t3HP}
		elseif lane == "bot" then
			local t1 = GetTower(side, TOWER_BOT_1)
			local t2 = GetTower(side, TOWER_BOT_2)
			local t3 = GetTower(side, TOWER_BOT_3)
			if t1 ~= nil then
				t1HP = t1:GetHealth()
			end
			if t1 ~= nil then
				t2HP = t2:GetHealth()
			end
			if t1 ~= nil then
				t3HP = t3:GetHealth()
			end
			return {t1HP, t2HP, t3HP}
		else
			local t1 = GetTower(side, TOWER_BASE_1)
			local t2 = GetTower(side, TOWER_BASE_2)
			if t1 ~= nil then
				t1HP = t1:GetHealth()
			end
			if t1 ~= nil then
				t2HP = t2:GetHealth()
			end
			return {t1HP, t2HP}
		end
	end
end

-- Returns the lane's front location and amount as a list
function GetLaneCreepStatus(lane, side)
	local frontLocation = GetLaneFrontLocation(side, lane, 50)
	local frontAmount   = GetLaneFrontAmount(side, lane, true)
	
	return {frontLocation, frontAmount}
end

-- Gets the vector location of a point p percentage between you and the target
function getVectorBetweenTargetPercentage(you, target, p)
	local youLoc = you:GetLocation()
	local youX   = youLoc[1]
	local youY   = youLoc[2]
	
	local targetLoc = target:GetLocation()
	local targetX   = targetLoc[1]
	local targetY   = targetLoc[2]
--	
--	local a = p*(targetX - youX)
--	local b = p*(targetY - youY)
--	
--	return Vector(youX + a, youY + a, 0)

	local locX = youX + (math.abs(youX) - math.abs(targetX))*p
	local locY = youY + (math.abs(youY) - math.abs(targetY))*p
	
	return Vector(locX, locY, 0)
end

-- Gets the vector location of a point p percentage between you and the target
function getVectorBetweenTargetDistance(you, target, d)
	local youLoc = you:GetLocation()
	local youX   = youLoc[1]
	local youY   = youLoc[2]
	
	local targetLoc = target:GetLocation()
	local targetX   = targetLoc[1]
	local targetY   = targetLoc[2]

	local dist = GetUnitToUnitDistance(you, target)
	local p = dist/d*100

	local locX = youX + (math.abs(youX) - math.abs(targetX))*p
	local locY = youY + (math.abs(youY) - math.abs(targetY))*p
	
	return Vector(locX, locY, 0)
end

-- Returns a list of the point locations of each tree ID
function getTreeLocations(trees)
	local treeLocs = {} 
	for tree in ipairs(trees) do
		local loc = GetTreeLocation(tree)
		table.insert(treeLocs, loc)
	end
	
	return treeLocs
end

-- Clusters points (trees) with a defined minimum distance
-- Returns a list of lists (tree clusters) of tree locations
function cluster(points)
    local clusters = {}
    
    while #points > 0 do
        local s     = {}
        local loc   = table.remove(points, 1)
        local queue = {loc}
        
        while #queue > 0 do
            local tempQueue = {}
            for i = 1, #queue do
            	local p1 = queue[i]
            	for j = 1, #points do
            		local p2 = points[j]
                    if not samePoint(p1, p2) then
                        local dist = getDistance(p1, p2)
                        
                        if dist < 200 then
                            table.insert(tempQueue, p2)
                        end
                     end
                 end
            end
            
            for i = 1, #queue do
            	local p1 = queue[1]
                if not inGroup(s, p1) then
                    table.insert(s, p1)
                end
            end
            
            queue = tempQueue;
            
            for i = 1, #tempQueue do
            	local p1 = tempQueue[i]
            	for j = 1, #points do
            		local p2 = points[j]
                    if samePoint(p1, p2) then
                        table.remove(points, i)
                        break
                    end
                end
            end
        end
        if table.getn(s) > 1 then
        	table.insert(clusters, s)
        end
    end
    
    return clusters
end

function clusterAndGetCentroids(points)
	if table.getn(points) == 0 then return nil end
	
	local clusters  = cluster(points)
	local centroids = {}
	
	for group in ipairs(clusters) do
		local centroid = nil
		local xavg = 0
		local yavg = 0
		for i,point in ipairs(group) do
			xavg = xavg + group[1]
			yavg = yavg + group[2]
		end
		local size = table.getn(group)
		centroid = Vector(xavg/size, yavg/size, 0)
		table.insert(centroids, centroid)
	end
	
	return centroids
end

function getCentroid(points)
	local centroid = nil
	local numPoints = table.getn(points)
	local x = 0
	local y = 0
	
	for p = 1, numPoints do
		local point = points[p]
		
		x = x + point[1]
		y = y + point[2]
	end
	
	return Vector(x/numPoints, y/numPoints, 0)
end

-- Returns the distance between two points
function getDistance(p1, p2)
	return math.sqrt((p1[1] - p2[1])*(p1[1] - p2[1]) + (p1[2] - p2[2])*(p1[2] - p2[2]))
end

-- Gets the coordinates of a point C X degrees from A about the point of origin B
function getAnglePoint(origin, point, degrees)
	local diffX = origin[1]
	local diffY = origin[2]

	local creepX = point[1] - diffX
	local creepY = point[2] - diffY
	
	local newX = creepX * math.cos(math.rad(degrees)) - creepY * math.sin(math.rad(45))
	local newY = creepY * math.cos(math.rad(degrees)) - creepX * math.sin(math.rad(45))
	
	return Vector(newX + diffX, newY + diffY, 0)
end

-- Checks if the two points are the same point by location
function samePoint(p1, p2)
	return math.floor(p1[1]) == math.floor(p2[1]) and math.floor(p1[2]) == math.floor(p2[2]) 
end

-- Checks if a point is already contained in a group of points
function inGroup(group, point)
	for i = 1, #group do
		local p = group[i]
		if samePoint(p, point) then
			return true
		end
	end
	
	return false
end

function getDesireString(mode)
	if mode == BOT_MODE_NONE then
		return "None"
	elseif mode == BOT_MODE_LANING then
		return "Laning"
	elseif mode == BOT_MODE_ATTACK then
		return "Attack"
	elseif mode == BOT_MODE_RETREAT then
		return "Retreat"
	elseif mode == BOT_MODE_SECRET_SHOP then
		return "Secret Shop"
	elseif mode == BOT_MODE_SIDE_SHOP then
		return "Side Shop"
	elseif mode == BOT_MODE_PUSH_TOWER_TOP then
		return "Push Top Tower"
	elseif mode == BOT_MODE_PUSH_TOWER_MID then
		return "Push Mid Tower"
	elseif mode == BOT_MODE_PUSH_TOWER_BOT then
		return "Push Bot Tower"
	elseif mode == BOT_MODE_DEFEND_TOWER_TOP then
		return "Defend Top Tower"
	elseif mode == BOT_MODE_DEFEND_TOWER_MID then
		return "Defend Mid Tower"
	elseif mode == BOT_MODE_DEFEND_TOWER_BOT then
		return "Defend Bot Tower"
	elseif mode == BOT_MODE_ASSEMBLE then
		return "Assemble"
	elseif mode == BOT_MODE_TEAM_ROAM then
		return "Team Roam"
	elseif mode == BOT_MODE_FARM then
		return "Farm"
	elseif mode == BOT_MODE_DEFEND_ALLY then
		return "Defend Ally"
	elseif mode == BOT_MODE_EVASIVE_MANEUVERS then
		return "Evasive Maneuvers"
	elseif mode == BOT_MODE_ROSHAN then
		return "Roshan"
	elseif mode == BOT_MODE_ITEM then
		return "Item"
	elseif mode == BOT_MODE_WARD then
		return "Ward"
	end
end

-- Get the best target to use Hand of Midas on
function getMidasTarget(npcBot)
	local creeps      = npcBot:GetNearbyLaneCreeps(1600, true)
	local neutrals    = npcBot:GetNearbyNeutralCreeps(1600, true)
	local creepsToUse = nil
	local target      = nil
	
	if table.getn(creeps) > 0 then
		creepsToUse = creeps
	else
		creepsToUse = neutrals
	end
	
	if table.getn(creepsToUse) > 0 then
		target = creepsToUse[1]
		
		for i = 2, table.getn(creepsToUse) do
			if target:GetMaxHealth() < creepsToUse[i]:GetMaxHealth() then
				target = creepsToUse[i]
			end
		end
	end
	
	return target
end

-- Returns whether it's safe to attack a tower
function isTowerSafe(npcBot, tower)
	local towerTarget = tower:GetAttackTarget()
	if towerTarget == nil then
		return false
	end
	local targetHP = towerTarget:GetHealth()
	local targetMaxHP = towerTarget:GetMaxHealth()
	local distToTower = GetUnitToUnitDistance(npcBot, tower)
	local nearbyCreeps = tower:GetNearbyLaneCreeps(800, false)
	
	if targetHP / targetMaxHP <= 0.5 then
		if table.getn(nearbyCreeps) > 0 then
			local creepDistToTower = GetUnitToUnitDistance(nearbyCreeps[1], tower)
			local botDistToTower   = GetUnitToUnitDistance(npcBot, tower)
			
			if creepDistToTower < botDistToTower then
				return true
			end
		else
			return false
		end
	else
		return true
	end
end

-- Returns if the item is in a main slot or not and the item itself
function getItemAvailable(itemName, bot)
	local itemSlot = bot:FindItemSlot(itemName)
	return (bot:GetItemSlotType(itemSlot) == ITEM_SLOT_TYPE_MAIN), bot:GetItemInSlot(itemSlot)
end