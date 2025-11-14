-- FendiModules/UI
local TweenService = game:GetService("TweenService")

local UI = {}

-- Create a button factory
function UI.CreateButton(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    btn.Text = text
    btn.TextColor3 = Color3.new(0, 0, 0)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    return btn
end

-- Make frame draggable (smooth)
function UI.MakeDraggable(frame)
    local dragging = false
    local dragStart, startPos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Fade+Slide animation for list items
function UI.AnimateListItem(obj)
    obj.BackgroundTransparency = 1
    obj.TextTransparency = 1
    obj.Position = obj.Position + UDim2.new(0, -20, 0, 0)

    local ti = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    TweenService:Create(obj, ti, {
        BackgroundTransparency = 0,
        TextTransparency = 0,
        Position = obj.Position + UDim2.new(0, 20, 0, 0)
    }):Play()
end

return UI
