local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Settings = {
    AutoFish = false,
    AutoCast = false,
    AutoShake = false,
    AutoReel = false
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "chutmarani_hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 230, 0, 280)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = false
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 80)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1
TopBar.Active = true
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "chutmarani hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 5)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.TextSize = 28
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Active = true
MinimizeBtn.Parent = TopBar

local isMinimized = false
MinimizeBtn.MouseButton1Down:Connect(function()
    isMinimized = not isMinimized
    local targetSize = isMinimized and UDim2.new(0, 230, 0, 40) or UDim2.new(0, 230, 0, 280)
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
end)

local BottomText = Instance.new("TextLabel")
BottomText.Size = UDim2.new(1, 0, 0, 20)
BottomText.Position = UDim2.new(0, 0, 1, -25)
BottomText.BackgroundTransparency = 1
BottomText.Text = "aap gay he"
BottomText.TextColor3 = Color3.fromRGB(130, 130, 150)
BottomText.TextSize = 12
BottomText.Font = Enum.Font.GothamSemibold
BottomText.Parent = MainFrame

local buttons = {}

local function updateButtonVisual(key)
    local btn = buttons[key]
    if not btn then return end
    if Settings[key] then
        btn.Text = key .. " [ON]"
        btn.BackgroundColor3 = Color3.fromRGB(65, 165, 100)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        btn.Text = key .. " [OFF]"
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    end
end

local function syncAllButtons(state)
    Settings.AutoFish = state
    Settings.AutoCast = state
    Settings.AutoShake = state
    Settings.AutoReel = state

    updateButtonVisual("AutoFish")
    updateButtonVisual("AutoCast")
    updateButtonVisual("AutoShake")
    updateButtonVisual("AutoReel")
end

local function createToggle(key, yOffset)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -30, 0, 36)
    btn.Position = UDim2.new(0, 15, 0, yOffset)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.Active = true
    btn.Parent = MainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(50, 50, 65)
    btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    btnStroke.Parent = btn
    
    buttons[key] = btn
    updateButtonVisual(key)

    btn.MouseButton1Down:Connect(function()
        if key == "AutoFish" then
            syncAllButtons(not Settings.AutoFish)
        else
            Settings[key] = not Settings[key]
            updateButtonVisual(key)
        end
    end)
end

createToggle("AutoFish", 50)
createToggle("AutoCast", 95)
createToggle("AutoShake", 140)
createToggle("AutoReel", 185)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F6 then
        syncAllButtons(not Settings.AutoFish)
    elseif input.KeyCode == Enum.KeyCode.F7 then
        Settings.AutoReel = not Settings.AutoReel
        updateButtonVisual("AutoReel")
    elseif input.KeyCode == Enum.KeyCode.F8 then
        Settings.AutoCast = not Settings.AutoCast
        updateButtonVisual("AutoCast")
    elseif input.KeyCode == Enum.KeyCode.F9 then
        Settings.AutoShake = not Settings.AutoShake
        updateButtonVisual("AutoShake")
    end
end)

local function getOrEquipRod()
    local char = LocalPlayer.Character
    if not char then return nil end

    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool:FindFirstChild("events") or tool.Name:lower():find("rod")) then
            return tool
        end
    end

    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool:FindFirstChild("events") or tool.Name:lower():find("rod")) then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:EquipTool(tool)
                    task.wait(0.2)
                    return tool
                end
            end
        end
    end
    return nil
end

local ReelController = ReplicatedStorage:WaitForChild("client"):WaitForChild("legacyControllers"):FindFirstChild("ReelController")
if ReelController then
    local ReelModule = require(ReelController)
    if not ReelModule._OldStartReel then
        ReelModule._OldStartReel = ReelModule.StartReel
    end

    ReelModule.StartReel = function(minigameParams)
        local reelInstance = ReelModule._OldStartReel(minigameParams)
        if not reelInstance then return end

        task.spawn(function()
            if Settings.AutoReel or Settings.AutoFish then
                while reelInstance and reelInstance.AddModifier do
                    reelInstance:AddModifier("progress", "force", 100)
                    task.wait()
                end
                
                reelInstance:WaitUntilReady()
                task.wait(0.7)
                
                if reelInstance and reelInstance.active then
                    reelInstance.perfect = true
                    task.wait(0.15)
                    if reelInstance.EndMinigame then
                        reelInstance:EndMinigame(true)
                    end
                end
            end
        end)
        return reelInstance
    end
end

task.spawn(function()
    while true do
        task.wait(0.01)
        if Settings.AutoShake or Settings.AutoFish then
            local shakeUI = PlayerGui:FindFirstChild("shakeui")
            if shakeUI and shakeUI.Enabled then
                local safeZone = shakeUI:FindFirstChild("safezone")
                if safeZone then
                    local button = safeZone:FindFirstChildWhichIsA("GuiButton") or safeZone:FindFirstChildWhichIsA("ImageButton")
                    if button then
                        button.Visible = false
                        if firesignal then
                            firesignal(button.Activated)
                        else
                            for _, connection in pairs(getconnections(button.Activated)) do
                                connection:Fire()
                            end
                        end
                        task.wait(0.05)
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    local Net = ReplicatedStorage:WaitForChild("packages"):WaitForChild("Net")
    local CastRemote = Net:WaitForChild("RF/FishingRod/Cast")

    while true do
        task.wait(0.1)
        if Settings.AutoCast or Settings.AutoFish then
            local shakeUI = PlayerGui:FindFirstChild("shakeui")
            
            if not (shakeUI and shakeUI.Enabled) then
                local passedRod = getOrEquipRod()
                
                if passedRod then
                    local isCasted = false
                    local charFolder = passedRod:FindFirstChild("char")
                    local valuesFolder = passedRod:FindFirstChild("values")
                    
                    if valuesFolder and valuesFolder:FindFirstChild("casted") then
                        isCasted = valuesFolder.casted.Value
                    elseif charFolder and #charFolder:GetChildren() > 0 then
                        isCasted = true
                    end

                    if not isCasted then
                        pcall(function()
                            CastRemote:InvokeServer(100, true)
                        end)
                        task.wait(0.5)
                    end
                end
            end
        end
    end
end)
