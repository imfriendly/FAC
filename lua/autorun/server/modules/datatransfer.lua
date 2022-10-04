util.AddNetworkString("FAC.Network")

local function HandleFACNetworkData(len, ply)
    if not IsValid(ply) then
        return 
    end

    local network_type = net.ReadUInt(8)
    if network_type == 0 then
        -- Heartbeat should send random data for each server so people can't have static lua code that runs on each server.

    elseif network_type == 1 then -- etc other features.
        HandleAimbotDetection(len, ply)
    elseif network_type == 2 then
        HandleESPDetection(len, ply)   
    elseif network_type == 3 then
        HandleButtonCheck(len, ply)
    end
end

net.Receive("FAC.Network", HandleFACNetworkData)

print("Server Detection 2")