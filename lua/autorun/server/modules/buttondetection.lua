function HandleButtonCheck(len, ply)
    local command_number = net.ReadUInt(32)
    local buttons = net.ReadUInt(32)

    ply.LastCommandNumber = command_number
    ply.LastButtons = buttons
    ply.CheckUserCommand = true
end



local function StartCommand(ply, cmd)
    local CommandNumber = cmd:CommandNumber()
    if (CommandNumber % 4 > 0) then
        return
    end

    local CommandList = ply.CommandList
    local Buttons = cmd:GetButtons()
    local ButtonCheck = ply.CheckUserCommand
    for k, v in next, CommandList do
        if CommandNumber - k > 16 then
            CommandList[k] = nil
        end
    end

    CommandList[CommandNumber] = Buttons   
    if ButtonCheck == true then
        ButtonCheck = false       
        local LastCommandNumber = ply.LastCommandNumber
        local LastButtons = ply.LastButtons
 
        local Buttons = CommandList[LastCommandNumber]
        if (Buttons == nil) then
            return 
        end

        if (Buttons != LastButtons) then
            ply:PrintMessage(HUD_PRINTTALK, "Cheating")
        end
    end
    
end

hook.Add("StartCommand", "", StartCommand)

local function PlayerInitialSpawn(ply)
    ply.CommandList = {}
    ply.CheckUserCommand = false
end

hook.Add("PlayerInitialSpawn", "FAC.PlayerInitialSpawn", PlayerInitialSpawn)
