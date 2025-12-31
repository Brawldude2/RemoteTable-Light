local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteTable = require(ReplicatedStorage.RemoteTableLight).Client

local TOKEN = `PlayerData{Player.UserId}`
local data = RemoteTable.WaitForTable(TOKEN)

--TIP: Enable "Show Tables Expanded by Default" for a better visual feedback
while task.wait(0.2) do
	--Data changes automatically
	print(data)
end