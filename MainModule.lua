local moonlightFramework = {}

-- General Utils

function moonlightFramework.getStatus()
	print("Fetching status...")
	local httpService = game:GetService("HttpService")
	local url = "https://api.github.com"
	local data = httpService:GetAsync(url .. "/repos/callmehSpear/Moonlight-Framework/releases")
	data = httpService:JSONDecode(data)
	warn("Moonlight Framework v"..data[1].tag_name.." is running.")
	local ver = data[1].tag_name
	return ver
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

return moonlightFramework
-- callmehSpear was here
