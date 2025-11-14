-- FendiModules/Teleports
local TweenService = game:GetService("TweenService")
local Teleports = {}

-- Smooth teleport to surface if player falls
function Teleports.ToSurface(hrp)
    local pos = hrp.Position
    if pos.Y < -10 then
        local goal = { CFrame = CFrame.new(pos.X, 5, pos.Z) }
        TweenService:Create(hrp, TweenInfo.new(0.7, Enum.EasingStyle.Sine), goal):Play()
    end
end

-- Smooth teleport to target player
function Teleports.ToPlayer(hrp, targetHRP)
    local goal = { CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0) }
    TweenService:Create(hrp, TweenInfo.new(0.8, Enum.EasingStyle.Sine), goal):Play()
end

return Teleports
