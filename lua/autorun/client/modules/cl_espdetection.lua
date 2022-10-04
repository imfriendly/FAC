local ScrW = ScrW
local ScrH = ScrH

local RenderTarget = GetRenderTarget("", ScrW(), ScrH())


local render_Capture = render.Capture
local render_SetRenderTarget = render.SetRenderTarget
local render_ReadPixel = render.ReadPixel
local render_CapturePixels = render.CapturePixels
local hook_Add = hook.Add

local function PostGamemodeLoaded()
    local WaitForPreRender = false
    
    local original_PostRender = GAMEMODE.PostRender
    function GAMEMODE:PostRender()
        original_PostRender(self)
    
		-- ghetto load balancing
        if (FrameNumber() % 12800 == 0 && not WaitForPreRender) then
            WaitForPreRender = true
            render.SetRenderTarget(RenderTarget)
            render.Clear(0, 0, 0, 0)
        end
    end
    
    local original_PreRender = GAMEMODE.PreRender
    function GAMEMODE:PreRender()
    
        if (WaitForPreRender) then
            WaitForPreRender = false
            render.PushRenderTarget(RenderTarget)
        
                render_CapturePixels()

                local Width = ScrW()
                local Height = ScrH()
                for i = 0, Width do         
                    for j = 0, Height do
                        local r, g, b = render_ReadPixel(i, j)
                        if (r ~= 0 or g ~= 0 or b ~= 0) then
                            print("ESP/Menu detection")       
                            goto done
                        end
                    end
                end

                ::done::
        
            render.PopRenderTarget()
        end
    
        original_PreRender(self)
    end
end

local function ShutDown()
    render_SetRenderTarget(nil)
end

hook_Add("ShutDown", "FAC.ShutDown", ShutDown)
hook_Add("PostGamemodeLoaded", "FAC.PostGamemodeLoaded", PostGamemodeLoaded)