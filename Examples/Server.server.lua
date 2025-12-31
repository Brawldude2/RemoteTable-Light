local RemoteTable = require(game.ReplicatedStorage.RemoteTableLight).Server

local SelectiveReplicationData = {
	Progression = {
		Private = false
	},
}

local PlayerDataTemplate = {
	Cash = 1,
	Experience = 0,
	Progression = {
		Private = {
			PrivateValue = "This won't replicate",
		}
	},
	Inventory = {"Phone", "Keys", "Wallet"},
	Perks = {},
}

game.Players.PlayerRemoving:Connect(function(player: Player)
	RemoteTable.Destroy("PlayerData"..player.UserId)
end)

game.Players.PlayerAdded:Connect(function(player: Player)
	local token = "PlayerData"..player.UserId
	local player_data = RemoteTable.Create(token, PlayerDataTemplate, SelectiveReplicationData)
	RemoteTable.AddClient(token, player)

	--[[
		Give client a small delay to connect
		This is only for demonstration purposes
		In production it doesn't matter when client connects
		as long as server does .AddClient() for the client
	]]
	task.wait(2)
	
	RemoteTable.Set(player_data, "Cash", 1000)
	task.wait(1)
	
	RemoteTable.Set(player_data.Progression.Private, "PrivateValue", "This change won't be replicated.")
	task.wait(1)
	
	local perk = {Type = "Additive", Target = "WalkSpeed", Value = 5}
	RemoteTable.Set(player_data.Perks, "SpeedPerk", perk)
	task.wait(1)
	
	-- We can reuse the perk reference to edit the perk value
	RemoteTable.Increment(perk, "Value", 3)
	task.wait(1)
	
	RemoteTable.Increment(player_data, "Experience", 100)
	task.wait(1)
	
	-- {"Coffee", "Phone", "Keys", "Wallet"}
	RemoteTable.Insert(player_data.Inventory, 1, "Coffee")
	task.wait(1)
	
	-- {"Coffee", "Phone", "Wallet"}
	RemoteTable.Remove(player_data.Inventory, 3)
	task.wait(1)

	-- {"Wallet", "Phone"}
	RemoteTable.SwapRemove(player_data.Inventory, 1)
	task.wait(1)

	-- {}
	RemoteTable.Clear(player_data.Inventory)
	task.wait(1)
	
	RemoteTable.RemoveClient(token, player)
	
	-- This won't replicate as the client is removed from listeners
	RemoteTable.Set(player_data, "Cash", 99999)
	task.wait(1)
end)