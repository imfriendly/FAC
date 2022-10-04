local net_Start = net.Start
local net_SendToServer = net.SendToServer
local net_WriteUInt = net.WriteUInt
local CUserCmd = FindMetaTable("CUserCmd")

local CommandNumber = CUserCmd.CommandNumber
local Buttons = CUserCmd.GetButtons

local SendNextCommand = false
local PreviousCommandNumber = 0
local AllowSending = false

local function PostGamemodeLoaded()
    local original_CreateMove = GAMEMODE.CreateMove
    function GAMEMODE:CreateMove(cmd)
        original_CreateMove(self, cmd)
        
        local command_number = CommandNumber(cmd)
        local buttons = Buttons(cmd)
        if command_number != 0 then
            SendNextCommand = command_number % 4 == 0
            PreviousCommandNumber = command_number
        else
            if SendNextCommand == true and AllowSending then
                SendNextCommand = false
                net_Start("FAC.Network")
                net_WriteUInt(3, 8)
                net_WriteUInt(PreviousCommandNumber, 32)
                net_WriteUInt(buttons, 32)
                net_SendToServer()
            end
        end
    end
end

local function Timer()
    AllowSending = true
    timer.Simple(10, Timer)
end

timer.Simple(0, Timer)

hook.Add("PostGamemodeLoaded", "FAC.PostGamemodeLoaded2", PostGamemodeLoaded)