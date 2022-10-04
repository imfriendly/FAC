
local bits = 0
local bit_counter = 0
local angle = nil

local bit_bxor = bit.bxor
local bit_lshift = bit.lshift
local bit_rshift = bit.rshift
local bit_ror  = bit.ror
local bit_rol  = bit.rol

local hook_Add = hook.Add

local registry = debug.getregistry()

local CommandNumber = registry.CUserCmd.CommandNumber
local GetViewAngles = registry.CUserCmd.GetViewAngles

local net_Start = net.Start
local net_WriteUInt = net.WriteUInt
local net_SendToServer = net.SendToServer

local function CreateMove(cmd)
    local command_number = CommandNumber(cmd)
    local viewangles = GetViewAngles(cmd)

    bits = bit_bxor(bits, command_number == 0 and 1 or 0)
    bits = bit_lshift(bits, 1)

    if command_number ~= 0 then
        bits = bit_bxor(bits, angle == viewangles and 1 or 0)
        angle = viewangles
    else
        bits = bit_bxor(bits, angle == viewangles and 1 or 0)
    end

    bit_counter = bit_counter + 2
    if bit_counter == 32 then        
        net_Start("FAC.Network")
        net_WriteUInt(1, 8)
        net_WriteUInt(bits, 32)
        net_SendToServer()
        bit_counter = 0
        bits = 0
    else
        bits = bit_lshift(bits, 1) 
    end

end

hook_Add("CreateMove", "FAC.CreateMove", CreateMove)