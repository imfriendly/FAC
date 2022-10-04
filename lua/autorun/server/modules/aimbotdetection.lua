local bit_band = bit.band
local bit_ror = bit.ror
local bit_rshift = bit.rshift

function HandleAimbotDetection(len, ply)
    
    if not ply.AimbotDetectionCounter then
        ply.AimbotDetectionCounter = 0
    end

    local bits = net.ReadUInt(32) 
    for i = 0, 16 do
        local angle = bit_band(bits, 1)
        bits = bit_rshift(bits, 1)

        local cmd = bit_band(bits, 1)
        bits = bit_rshift(bits, 1)

        if cmd == 0 then
            if angle == 1 then
                ply.AimbotDetectionCounter = 0
            end
        else
            if angle == 1 then
                ply.AimbotDetectionCounter = ply.AimbotDetectionCounter + 1
            else
                ply.AimbotDetectionCounter = 0
            end
        end
    end

    if ply.AimbotDetectionCounter > 32 then
        --ply:Kick("FAC OFF")
		ply:PrintMessage(HUD_PRINTTALK, "Aimbot Detection!!")
    end
end

print("Server Detection 1")