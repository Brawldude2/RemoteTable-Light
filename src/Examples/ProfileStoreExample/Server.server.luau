local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local DataService = require(ReplicatedStorage.RemoteTableLight.Examples.ProfileStoreExample.DataService)

DataService.DataLoaded:Once(function(player: Player, data)
	-- Add 100 cash each join
	DataService.Increment(data, "Cash", 100)
	
	-- Grant a ticket to player everytime they join
	DataService.Insert(data.Items, {Name = "Ticket", Value = 10})
end)