local DataService = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ProfileStore = require(ServerScriptService.ProfileStore)
local RemoteTable = require(ReplicatedStorage.RemoteTableLight).Server
local Signal = require(ReplicatedStorage.RemoteTableLight.Shared.Zignal)

local PROFILE_TEMPLATE = {
	Cash = 0,
	Items = {},
}
local PlayerStore = ProfileStore.New("PlayerStore", PROFILE_TEMPLATE)

type PlayerProfile = typeof(PlayerStore:StartSessionAsync())
type ProfileData = typeof(PROFILE_TEMPLATE)
type PlayerData = {
	Profile: PlayerProfile,
	Data: ProfileData,
}

local PlayerDatas = {} :: {[Player]: PlayerData}

DataService.PlayerDatas = PlayerDatas
DataService.DataLoaded = Signal.new()

function DataService.GetData(player: Player): PlayerData?
	return RemoteTable.Get(`PlayerData{player.UserId}`)
end

local function PlayerAdded(player: Player)
	local data_token = `PlayerData{player.UserId}`
	
	local profile = PlayerStore:StartSessionAsync(`{player.UserId}`, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})
	
	if not profile then
		player:Kick(`[{script.Name}]: Profile load fail - Please rejoin`)
		return
	end
	
	profile:AddUserId(player.UserId)
	profile:Reconcile()

	profile.OnSessionEnd:Connect(function()
		PlayerDatas[player] = nil
		player:Kick(`[{script.Name}]: Profile session end - Please rejoin`)

		--Release the token
		RemoteTable.Destroy(data_token)
	end)
	
	if not player:IsDescendantOf(Players) then
		profile:EndSession()
		return
	end
	
	-- Connect and add client right after player data loads
	local player_data = RemoteTable.Create(data_token, profile.Data)
	RemoteTable.AddClient(data_token, player)

	-- Override profile.Data with the replicated remote table
	profile.Data = player_data
	PlayerDatas[player] = {
		Profile = profile,
		Data = player_data
	}
	print(`[{script.Name}]: Profile loaded for {player.DisplayName}!`)
	DataService.DataLoaded:Fire(player, player_data)
end

for _, player in Players:GetPlayers() do
	task.defer(PlayerAdded, player)
end

Players.PlayerAdded:Connect(PlayerAdded)
Players.PlayerRemoving:Connect(function(player)
	local profile = PlayerDatas[player].Profile
	if profile ~= nil then
		profile:EndSession()
	end
end)

-- Edit functions
DataService.Set = RemoteTable.Set
DataService.Increment = RemoteTable.Increment
DataService.Insert = RemoteTable.Insert
DataService.InsertAt = RemoteTable.InsertAt
DataService.Remove = RemoteTable.Remove
DataService.SwapRemove = RemoteTable.SwapRemove
DataService.Clear = RemoteTable.Clear

return DataService