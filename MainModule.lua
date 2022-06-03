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

[[--
function moonlightFrameowrk.uuid(v, id)
	if v == 1 then
		if id => 0 then
			
		end
	else
		
end
]]--

function moonlightFramework.r(min, max)
	return math.random(min, max)
end

-- Encode / Decode

function moonlightFramework.encodeb64(data)
	local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
	return ((data:gsub('.', function(x) 
        	local r,b='',x:byte()
        	for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        	return r;
    	end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        	if (#x < 6) then return '' end
        	local c=0
        	for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        	return b:sub(c+1,c+1)
    	end)..({ '', '==', '=' })[#data%3+1])
end

function moonlightFramework.decodeb64(data)
	local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
	data = string.gsub(data, '[^'..b..'=]', '')
    	return (data:gsub('.', function(x)
        	if (x == '=') then return '' end
        	local r,f='',(b:find(x)-1)
        	for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        	return r;
    	end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        	if (#x ~= 8) then return '' end
        	local c=0
        	for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
           		return string.char(c)
    	end))
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
