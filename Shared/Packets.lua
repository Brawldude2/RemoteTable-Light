--!strict
local NS = "__REMOTE_TABLE__"
local Packet = require(script.Parent.Packet)
local Token = Packet.NumberU16
local TokenName = Packet.String
local TableId = Packet.NumberF64
local Key = Packet.Any
local Value = Packet.Any
local EventStream = Packet.BufferLong
return {
	ConnectionRequest = Packet(NS.."Request", Token),
	
	SendEventStream = Packet(NS.."TableEventStream", Token, EventStream),
	NewRemoteTable = Packet(NS.."NewRemoteTable", TableId, Packet.Boolean8),
	NewTable = Packet(NS.."NewTable", TableId, Key, TableId),
	Set = Packet(NS.."Set", TableId, Key, Value),
	Insert = Packet(NS.."Insert", TableId, Key, Value),
	Remove = Packet(NS.."Remove", TableId, Key),
	SwapRemove = Packet(NS.."SwapRemove", TableId, Key),
	Clear = Packet(NS.."Clear", TableId),
}