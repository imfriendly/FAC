AddCSLuaFile("autorun/client/cl_init.lua")
AddCSLuaFile("autorun/client/modules/cl_aimbotdetection.lua")
AddCSLuaFile("autorun/client/modules/cl_espdetection.lua")
AddCSLuaFile("autorun/client/modules/cl_buttondetection.lua")

include("modules/espdetection.lua")
include("modules/aimbotdetection.lua")
include("modules/buttondetection.lua")
include("modules/datatransfer.lua") -- Data transfer should be the last module loaded as the features are going to be added into the HandleNetwork function.

print("Server Init")