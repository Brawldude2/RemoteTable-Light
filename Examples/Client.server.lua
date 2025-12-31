local Player = game:GetService("Players").LocalPlayer
local RemoteTable = require(game.ReplicatedStorage.RemoteTableLight).Client

local token = "PlayerData"..Player.UserId
local data = RemoteTable.WaitForTable(token)

RemoteTable.GetSignal(token, "ChildAdded", {"Inventory"}):Connect(function(child, key)
	warn("Inventory added: ", child)
end)

RemoteTable.GetSignal(token, "ChildRemoved", {"Inventory"}):Connect(function(child, key)
	warn("Inventory removed: ", child)
end)

RemoteTable.GetSignal(token, "Changed", {"Cash"}):Connect(function(new, old)
	warn("Cash changed: ", new)
end)


--TIP: Enable "Show Tables Expanded by Default" for a better visual feedback
while task.wait(0.2) do
	--Data changes automatically
	print(data)
end