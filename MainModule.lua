local moonlightFramework = {}

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

return moonlightFramework
