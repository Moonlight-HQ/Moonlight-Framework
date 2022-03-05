local moonlightFramework = {}

-- General Utils

function moonlightFramework.getVersion()

	local httpService = game:GetService("HttpService")
	local url = "https://api.github.com"
	local data = httpService:GetAsync(url .. "/repos/callmehSpear/Moonlight-Framework/releases")
	data = httpService:JSONDecode(data)

	return data[1].tag_name

end

function moonlightFramework.checkPlayerInGroup(player, groupId)

	if player:IsInGroup(groupId) then                    
		local isInGroup = true
		return isInGroup
	else
		local isInGroup = false
		return isInGroup
	end

end

function moonlightFramework.r(min, max)
	return math.random(min, max)
end

-- Point System, for airlines, cafes, hotels etc

function moonlightFramework.postPoints(player, amountOfPoints, datastoreName)
	local DataStoreService = game:GetService("DataStoreService")
	local pointDatastore = DataStoreService:GetDataStore(datastoreName)

	local success, errorMessage = pcall(function()
		pointDatastore:IncrementAsync(player.UserId, amountOfPoints)
	end)
	if not success then
		warn(errorMessage)
	end
end

function moonlightFramework.getPoints(player, datastoreName)
	local DataStoreService = game:GetService("DataStoreService")
	local pointDatastore = DataStoreService:GetDataStore(datastoreName)

	local success, currentPoints = pcall(function()
		return pointDatastore:GetAsync(player.UserId)
	end)
	if not success then
		warn(errorMessage)
	end
end

function moonlightFramework.resetPoints(player, datastoreName)
	local DataStoreService = game:GetService("DataStoreService")
	local pointDatastore = DataStoreService:GetDataStore(datastoreName)

	local success, errorMessage = pcall(function()
		pointDatastore:SetAsync(player.UserId, 0)
	end)
	if not success then
		warn(errorMessage)
	end
end

-- Moderation kick/ban

function moonlightFramework.kickPlayer(player, reason)
	player:Kick("You have been kicked for "..reason)
end

function moonlightFramework.banPlayer(player, reason, datastoreName)
	local DataStoreService = game:GetService("DataStoreService")
	local banDatastore = DataStoreService:GetDataStore(datastoreName)

	local success, errorMessage = pcall(function()
		banDatastore:SetAsync(player.UserId.." is banned?", true)
	end)
	if not success then
		warn(errorMessage)
	end

	local success, errorMessage = pcall(function()
		banDatastore:SetAsync(player.UserId.." ban reason?", reason)
	end)
	if not success then
		warn(errorMessage)
	end

	player:Kick("You have been banned forever for "..reason)
end

function moonlightFramework.unbanPlayer(playerID, datastoreName)
	local DataStoreService = game:GetService("DataStoreService")
	local banDatastore = DataStoreService:GetDataStore(datastoreName)

	local success, errorMessage = pcall(function()
		banDatastore:SetAsync(playerID.." is banned?", false)
	end)
	if not success then
		warn(errorMessage)
	end

	local success, errorMessage = pcall(function()
		banDatastore:SetAsync(playerID.." ban reason?", false)
	end)
	if not success then
		warn(errorMessage)
	end
end

return moonlightFramework

-- callmehSpear
