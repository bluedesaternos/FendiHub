local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local UI = require(script.Parent.FendiModules.UI)
local Tele = require(script.Parent.FendiModules.Teleports)

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart")
end)

--===== GUI CREATION =====--

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Name = "FendiHub"
gui.Parent = PlayerGui

-- MAIN FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.25
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Glass border glow
local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(255, 140, 0)
stroke.Transparency = 0.5
stroke.Parent = frame

-- Drop shadow
local shadow = Instance.new("ImageLabel")
shadow.Image = "rbxassetid://6015897843"
shadow.BackgroundTransparency = 1
shadow.ImageColor3 = Color3.fromRGB(255, 140, 0)
shadow.ScaleType = Enum.ScaleType.Stretch
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.Position = UDim2.new(0, -15, 0, -15)
shadow.ImageTransparency = 0.7
shadow.Parent = frame

-- TITLE
local title = Instance.new("TextLabel")
title.Text = "Fendi Hub"
title.Size = UDim2.new(1, -50, 0, 40)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 140, 0)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = frame

-- Minimize
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
minimizeBtn.Position = UDim2.new(1, -40, 0, 5)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextColor3 = Color3.fromRGB(255, 140, 0)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Parent = frame

-- Close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -80, 0, 5)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.BackgroundTransparency = 1
closeBtn.Parent = frame

-- Buttons
local b1 = UI.CreateButton("Teleport To Surface")
b1.Position = UDim2.new(0, 10, 0, 60)
b1.Parent = frame

local b2 = UI.CreateButton("Teleport To Player")
b2.Position = UDim2.new(0, 10, 0, 110)
b2.Parent = frame

-- Make draggable
UI.MakeDraggable(frame)

--===== PLAYER LIST FRAME =====--

local listFrame = Instance.new("Frame")
listFrame.Size = UDim2.new(0, 300, 0, 250)
listFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
listFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
listFrame.BackgroundTransparency = 0.25
listFrame.BorderSizePixel = 0
listFrame.Visible = false
listFrame.Parent = gui

Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 10)

local lfTitle = Instance.new("TextLabel")
lfTitle.Text = "Select Player"
lfTitle.Size = UDim2.new(1, 0, 0, 40)
lfTitle.BackgroundTransparency = 1
lfTitle.TextColor3 = Color3.fromRGB(255, 140, 0)
lfTitle.Font = Enum.Font.GothamBold
lfTitle.TextScaled = true
lfTitle.Parent = listFrame

-- Scroll container
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -50)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.Parent = listFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.Parent = scroll

local back = UI.CreateButton("Back")
back.Size = UDim2.new(1, -20, 0, 40)
back.Position = UDim2.new(0, 10, 1, -50)
back.Parent = listFrame

--===== LOGIC =====--

local function RefreshList()
    scroll:ClearAllChildren()
    listLayout.Parent = scroll

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local btn = UI.CreateButton(plr.Name)
            btn.Parent = scroll
            UI.AnimateListItem(btn)

            btn.MouseButton1Click:Connect(function()
                local targetChar = plr.Character
                if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                    Tele.ToPlayer(HRP, targetChar.HumanoidRootPart)
                end
            end)
        end
    end

    scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
end

-- Button actions
b1.MouseButton1Click:Connect(function()
    Tele.ToSurface(HRP)
end)

b2.MouseButton1Click:Connect(function()
    RefreshList()
    frame.Visible = false
    listFrame.Visible = true
end)

back.MouseButton1Click:Connect(function()
    frame.Visible = true
    listFrame.Visible = false
end)

-- Minimize logic
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(frame, TweenInfo.new(0.3), {Size = UDim2.new(0, 300, 0, 45)}):Play()
    else
        TweenService:Create(frame, TweenInfo.new(0.3), {Size = UDim2.new(0, 300, 0, 200)}):Play()
    end
end)

-- Close button
closeBtn.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

-- Opening animation
frame.Position = UDim2.new(0.05, 0, 1.2, 0)
TweenService:Create(frame, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {
    Position = UDim2.new(0.05, 0, 0.3, 0)
}):Play()
