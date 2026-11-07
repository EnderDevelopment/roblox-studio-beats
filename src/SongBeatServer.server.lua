local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local requestEvent = ReplicatedStorage:FindFirstChild("SongBeatRequest") or Instance.new("RemoteEvent")
requestEvent.Name = "SongBeatRequest"
requestEvent.Parent = ReplicatedStorage

local beatEvent = ReplicatedStorage:FindFirstChild("SongBeatSignal") or Instance.new("RemoteEvent")
beatEvent.Name = "SongBeatSignal"
beatEvent.Parent = ReplicatedStorage

local songAliases = {
	-- Add approved Roblox audio asset IDs here when you want name-based lookup.
	-- ["example song"] = "1234567890",
}

local defaultBpm = 92
local minimumBpm = 60
local maximumBpm = 180
local requestCooldown = 1
local lastRequestAt = {}
local activeSong = ""
local activeBpm = defaultBpm
local beatNumber = 0
local elapsed = 0

local function cleanText(value)
	if typeof(value) ~= "string" then
		return ""
	end
	return value:sub(1, 160):match("^%s*(.-)%s*$") or ""
end

local function resolveAssetId(input)
	local text = cleanText(input)
	local numericId = text:match("rbxassetid://(%d+)") or text:match("[?&]id=(%d+)") or text:match("/(%d+)%s*$") or text:match("^(%d+)$")
	if numericId then
		return numericId
	end

	return songAliases[string.lower(text)]
end

local function clampBpm(value)
	local number = tonumber(value) or defaultBpm
	return math.clamp(math.floor(number + 0.5), minimumBpm, maximumBpm)
end

requestEvent.OnServerEvent:Connect(function(player, input, requestedBpm)
	local now = os.clock()
	if now - (lastRequestAt[player] or 0) < requestCooldown then
		return
	end
	lastRequestAt[player] = now

	local assetId = resolveAssetId(input)
	if not assetId then
		requestEvent:FireClient(player, false, "Enter a Roblox audio asset ID or add the song to songAliases.")
		return
	end

	activeSong = assetId
	activeBpm = clampBpm(requestedBpm)
	beatNumber = 0
	elapsed = 0
	requestEvent:FireAllClients(true, activeSong, activeBpm)
end)

Players.PlayerRemoving:Connect(function(player)
	lastRequestAt[player] = nil
end)

RunService.Heartbeat:Connect(function(deltaTime)
	if activeSong == "" then
		return
	end

	elapsed += deltaTime
	local secondsPerBeat = 60 / activeBpm
	while elapsed >= secondsPerBeat do
		elapsed -= secondsPerBeat
		beatNumber += 1
		local step = (beatNumber - 1) % 16 + 1
		local accent = step == 1 or step == 9
		beatEvent:FireAllClients(step, beatNumber, accent)
	end
end)
