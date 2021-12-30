local moonlightFramework = {}

-- General Utils

function moonlightFramework.getVersion()
	print("Fetching version...")
	local httpService = game:GetService("HttpService")
	local url = "https://api.github.com"
	local data = httpService:GetAsync(url .. "/repos/callmehSpear/Moonlight-Framework/releases")
	data = httpService:JSONDecode(data)
	warn("Moonlight Framework v"..data[1].tag_name.." is running.")
	local ver = data[1].tag_name
	return ver
end

function moonlightFramework.checkPlayerInGroup(player, groupId)
	if player:IsInGroup(groupId) then                    
		print(player.Name.." is in group with ID "..groupId)
		local isInGroup = true
		return isInGroup
	else
		print(player.Name.." is not in group with ID "..groupId)
		local isInGroup = false
		return isInGroup
	end
end

-- Point System, for airlines, cafes, hotels etc

function moonlightFramework.postPoints(player, amountOfPoints, datastoreName)
	local DataStoreService = game:GetService("DataStoreService")

	local pointDatastore = DataStoreService:GetDataStore(datastoreName)

	local success, errorMessage = pcall(function()
		pointDatastore:IncrementAsync(player.UserId, amountOfPoints)
	end)
	if not success then
		warn("WARNING!!! Data did not save! "..errorMessage)
	end
	print("postPoints Success! Player ID: "..player.UserId.." Amount of Points added: "..amountOfPoints.." Datastore Name: "..datastoreName)
end
function moonlightFramework.getPoints(player, datastoreName)
	local DataStoreService = game:GetService("DataStoreService")

	local pointDatastore = DataStoreService:GetDataStore(datastoreName)

	local success, currentPoints = pcall(function()
		return pointDatastore:GetAsync(player.UserId)
	end)
	if success then
		return currentPoints
	end
end
function moonlightFramework.resetPoints(player, datastoreName)
	local DataStoreService = game:GetService("DataStoreService")

	local pointDatastore = DataStoreService:GetDataStore(datastoreName)

	local success, errorMessage = pcall(function()
		pointDatastore:SetAsync(player.UserId, 0)
	end)
	if not success then
		warn("WARNING!!! Data did not reset! "..errorMessage)
	end
	print("resetPoints Success! Player ID: "..player.UserId.." Datastore Name: "..datastoreName)
end

-- Moderation kick/ban

function moonlightFramework.kickPlayer(player, reason)
	player:Kick("You have been kicked for "..reason)
	print("Sucessfully kicked "..player.Name.." for "..reason..".")
end

function moonlightFramework.banPlayer(player, reason, datastoreName)
	local DataStoreService = game:GetService("DataStoreService")

	local banDatastore = DataStoreService:GetDataStore(datastoreName)

	local success, errorMessage = pcall(function()
		banDatastore:SetAsync(player.UserId.." is banned?", true)
	end)
	if not success then
		warn("WARNING!!! Ban did not save! "..errorMessage)
	end
	local success, errorMessage = pcall(function()
		banDatastore:SetAsync(player.UserId.." ban reason?", reason)
	end)
	if not success then
		warn("WARNING!!! Ban did not save! "..errorMessage)
	end
	print("Success on data save!")
	player:Kick("You have been banned forever for "..reason)
	print("Sucessfully banned "..player.Name.." forever for "..reason..".")
end

function moonlightFramework.unbanPlayer(playerID, datastoreName)
	local DataStoreService = game:GetService("DataStoreService")

	local banDatastore = DataStoreService:GetDataStore(datastoreName)

	local success, errorMessage = pcall(function()
		banDatastore:SetAsync(playerID.." is banned?", false)
	end)
	if not success then
		warn("WARNING!!! Unbanan did not save! "..errorMessage)
	end
	local success, errorMessage = pcall(function()
		banDatastore:SetAsync(playerID.." ban reason?", false)
	end)
	if not success then
		warn("WARNING!!! Unban did not save! "..errorMessage)
	end
	print("Success on data save!")
	print("Sucessfully unbanned "..playerID..".")
end

return moonlightFramework

-- callmehSpear
