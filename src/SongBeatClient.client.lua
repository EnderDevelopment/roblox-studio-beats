local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local requestEvent = ReplicatedStorage:WaitForChild("SongBeatRequest")
local beatEvent = ReplicatedStorage:WaitForChild("SongBeatSignal")

local gui = Instance.new("ScreenGui")
gui.Name = "SongBeatGui"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.fromScale(0.5, 0.82)
panel.Size = UDim2.fromOffset(430, 190)
panel.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
panel.BorderSizePixel = 0
panel.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = panel

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(18, 12)
title.Size = UDim2.new(1, -36, 0, 28)
title.Font = Enum.Font.GothamBold
title.Text = "RAP BEAT PLAYER"
title.TextColor3 = Color3.fromRGB(255, 220, 80)
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local songBox = Instance.new("TextBox")
songBox.Name = "SongInput"
songBox.PlaceholderText = "Roblox audio ID, URL, or configured song name"
songBox.Text = ""
songBox.ClearTextOnFocus = false
songBox.Position = UDim2.fromOffset(18, 52)
songBox.Size = UDim2.fromOffset(290, 38)
songBox.BackgroundColor3 = Color3.fromRGB(45, 45, 56)
songBox.TextColor3 = Color3.fromRGB(255, 255, 255)
songBox.PlaceholderColor3 = Color3.fromRGB(170, 170, 180)
songBox.Font = Enum.Font.Gotham
songBox.TextSize = 14
songBox.Parent = panel

local bpmBox = Instance.new("TextBox")
bpmBox.Name = "BpmInput"
bpmBox.PlaceholderText = "BPM"
bpmBox.Text = "92"
bpmBox.ClearTextOnFocus = false
bpmBox.Position = UDim2.fromOffset(318, 52)
bpmBox.Size = UDim2.fromOffset(94, 38)
bpmBox.BackgroundColor3 = Color3.fromRGB(45, 45, 56)
bpmBox.TextColor3 = Color3.fromRGB(255, 255, 255)
bpmBox.PlaceholderColor3 = Color3.fromRGB(170, 170, 180)
bpmBox.Font = Enum.Font.Gotham
bpmBox.TextSize = 14
bpmBox.Parent = panel

local playButton = Instance.new("TextButton")
playButton.Name = "PlayButton"
playButton.Position = UDim2.fromOffset(18, 101)
playButton.Size = UDim2.fromOffset(394, 38)
playButton.BackgroundColor3 = Color3.fromRGB(220, 55, 75)
playButton.TextColor3 = Color3.fromRGB(255, 255, 255)
playButton.Font = Enum.Font.GothamBold
playButton.Text = "LOAD SONG + START BEAT"
playButton.TextSize = 15
playButton.Parent = panel

local status = Instance.new("TextLabel")
status.Name = "Status"
status.BackgroundTransparency = 1
status.Position = UDim2.fromOffset(18, 148)
status.Size = UDim2.new(1, -36, 0, 28)
status.Font = Enum.Font.Gotham
status.Text = "Use a Roblox audio asset ID."
status.TextColor3 = Color3.fromRGB(190, 190, 200)
status.TextSize = 13
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = panel

local song = Instance.new("Sound")
song.Name = "CurrentSong"
song.Volume = 0.7
song.Looped = true
song.Parent = workspace

local function setStatus(text, color)
	status.Text = text
	status.TextColor3 = color or Color3.fromRGB(190, 190, 200)
end

local function extractAssetId(value)
	return value:match("rbxassetid://(%d+)") or value:match("[?&]id=(%d+)") or value:match("/(%d+)%s*$") or value:match("^(%d+)$")
end

playButton.Activated:Connect(function()
	local input = songBox.Text:match("^%s*(.-)%s*$")
	if input == "" then
		setStatus("Enter a song name or Roblox audio link.", Color3.fromRGB(255, 130, 130))
		return
	end

	setStatus("Loading approved Roblox audio...", Color3.fromRGB(255, 220, 80))
	requestEvent:FireServer(input, tonumber(bpmBox.Text))
end)

requestEvent.OnClientEvent:Connect(function(success, value, bpm)
	if not success then
		setStatus(value, Color3.fromRGB(255, 130, 130))
		return
	end

	song.SoundId = "rbxassetid://" .. value
	song:Play()
	setStatus(string.format("Playing asset %s at %d BPM", value, bpm), Color3.fromRGB(130, 255, 160))
end)

beatEvent.OnClientEvent:Connect(function(step, beatNumber, accent)
	local scale = accent and 1.08 or 1
	panel.Size = UDim2.fromOffset(430 * scale, 190 * scale)
	task.delay(0.08, function()
		panel.Size = UDim2.fromOffset(430, 190)
	end)
	status.Text = string.format("Beat %d  •  step %d/16", beatNumber, step)
end)
