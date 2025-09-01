-- DogV1 - Premium BedWars Utility
-- Rebranded from VapeV4 with mobile support
-- Loadstring: loadstring(game:HttpGet('https://raw.githubusercontent.com/youkofrfrfr/DogV5/main/init.lua', true))()

local DogV1 = {Loaded = false, Version = "v1.0"}

-- Anti-detection
local function SafeGetService(service)
    return game:GetService(service)
end

local Players = SafeGetService("Players")
local ReplicatedStorage = SafeGetService("ReplicatedStorage")
local UserInputService = SafeGetService("UserInputService")
local RunService = SafeGetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Wait for player
if not LocalPlayer then
    Players.PlayerAdded:Wait()
    LocalPlayer = Players.LocalPlayer
end

-- Mobile detection
local IS_MOBILE = UserInputService.TouchEnabled

-- GUI Creation with mobile support
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DogV1GUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Window (Smaller for mobile)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainWindow"
MainFrame.Size = IS_MOBILE and UDim2.new(0, 300, 0, 200) or UDim2.new(0, 400, 0, 300)
MainFrame.Position = IS_MOBILE and UDim2.new(0.5, -150, 0.1, 0) or UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Make draggable
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
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

MainFrame.InputChanged:Connect(function(input)
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

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "DOG V1"
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 30, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = TitleBar

-- Close button
local CloseButton = Instance.new("TextButton")
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    DogV1.Loaded = false
end)

-- Tabs
local Tabs = {"Combat", "Movement", "Render", "Utility"}
local TabButtons = {}
local TabFrames = {}

for i, tabName in ipairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Text = tabName
    TabButton.Size = UDim2.new(0.25, 0, 0, 30)
    TabButton.Position = UDim2.new((i-1) * 0.25, 0, 0, 30)
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextSize = 12
    TabButton.Parent = MainFrame
    TabButtons[tabName] = TabButton
    
    local TabFrame = Instance.new("ScrollingFrame")
    TabFrame.Size = UDim2.new(1, 0, 1, -60)
    TabFrame.Position = UDim2.new(0, 0, 0, 60)
    TabFrame.BackgroundTransparency = 1
    TabFrame.Visible = (i == 1)
    TabFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
    TabFrame.ScrollBarThickness = 5
    TabFrame.Parent = MainFrame
    TabFrames[tabName] = TabFrame
    
    TabButton.MouseButton1Click:Connect(function()
        for _, frame in pairs(TabFrames) do
            frame.Visible = false
        end
        for _, button in pairs(TabButtons) do
            button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        end
        TabFrame.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    end)
end

TabButtons["Combat"].BackgroundColor3 = Color3.fromRGB(0, 150, 255)

-- Feature creation function
local ToggleStates = {}
local function CreateToggle(name, parent, yPos, callback)
    local Button = Instance.new("TextButton")
    Button.Text = name
    Button.Size = UDim2.new(0.9, 0, 0, 30)
    Button.Position = UDim2.new(0.05, 0, 0, yPos)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 12
    Button.Parent = parent
    
    ToggleStates[name] = false
    
    Button.MouseButton1Click:Connect(function()
        ToggleStates[name] = not ToggleStates[name]
        if ToggleStates[name] then
            Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        else
            Button.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        end
        if callback then
            callback(ToggleStates[name])
        end
    end)
    
    return Button
end

-- Combat Features
CreateToggle("KillAura", TabFrames["Combat"], 10, function(state)
    ToggleKillAura(state)
end)

CreateToggle("TriggerBot", TabFrames["Combat"], 50, function(state)
    ToggleTriggerBot(state)
end)

CreateToggle("Reach", TabFrames["Combat"], 90, function(state)
    ToggleReach(state)
end)

-- Movement Features
CreateToggle("Speed", TabFrames["Movement"], 10, function(state)
    ToggleSpeed(state)
end)

CreateToggle("Fly", TabFrames["Movement"], 50, function(state)
    ToggleFly(state)
end)

CreateToggle("InfiniteJump", TabFrames["Movement"], 90, function(state)
    ToggleInfiniteJump(state)
end)

CreateToggle("NoFall", TabFrames["Movement"], 130, function(state)
    ToggleNoFall(state)
end)

-- Render Features
CreateToggle("ESP", TabFrames["Render"], 10, function(state)
    ToggleESP(state)
end)

CreateToggle("Tracers", TabFrames["Render"], 50, function(state)
    ToggleTracers(state)
end)

CreateToggle("X-Ray", TabFrames["Render"], 90, function(state)
    ToggleXRay(state)
end)

-- Utility Features
CreateToggle("AutoCollect", TabFrames["Utility"], 10, function(state)
    ToggleAutoCollect(state)
end)

CreateToggle("AutoBuild", TabFrames["Utility"], 50, function(state)
    ToggleAutoBuild(state)
end)

CreateToggle("ChatLogger", TabFrames["Utility"], 90, function(state)
    ToggleChatLogger(state)
end)

-- ACTUAL HACK IMPLEMENTATIONS

-- KillAura
function ToggleKillAura(enabled)
    if enabled then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DogV1",
            Text = "KillAura Enabled",
            Duration = 3
        })
        
        local auraConnection
        auraConnection = RunService.Heartbeat:Connect(function()
            if not ToggleStates["KillAura"] then
                auraConnection:Disconnect()
                return
            end
            
            local character = LocalPlayer.Character
            if not character then return end
            
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then return end
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    local targetHumanoid = player.Character:FindFirstChild("Humanoid")
                    
                    if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                        local distance = (humanoidRootPart.Position - targetRoot.Position).Magnitude
                        
                        if distance <= 20 then
                            -- Attack logic
                            humanoidRootPart.CFrame = targetRoot.CFrame
                        end
                    end
                end
            end
        end)
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DogV1",
            Text = "KillAura Disabled",
            Duration = 3
        })
    end
end

-- Fly Hack
function ToggleFly(enabled)
    if enabled then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DogV1",
            Text = "Fly Enabled - Use WASD",
            Duration = 3
        })
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then return end
        
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        
        local flyConnection
        flyConnection = RunService.Heartbeat:Connect(function()
            if not ToggleStates["Fly"] then
                flyConnection:Disconnect()
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                return
            end
            
            local cam = workspace.CurrentCamera
            local moveDirection = Vector3.new()
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + (cam.CFrame.LookVector * 50)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - (cam.CFrame.LookVector * 50)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - (cam.CFrame.RightVector * 50)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + (cam.CFrame.RightVector * 50)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 50, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDirection = moveDirection - Vector3.new(0, 50, 0)
            end
            
            rootPart.Velocity = moveDirection
            rootPart.AssemblyLinearVelocity = moveDirection
        end)
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DogV1",
            Text = "Fly Disabled",
            Duration = 3
        })
    end
end

-- Speed Hack
function ToggleSpeed(enabled)
    if enabled then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DogV1",
            Text = "Speed Enabled (30)",
            Duration = 3
        })
        
        local speedConnection
        speedConnection = RunService.Heartbeat:Connect(function()
            if not ToggleStates["Speed"] then
                speedConnection:Disconnect()
                return
            end
            
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 30
                end
            end
        end)
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DogV1",
            Text = "Speed Disabled",
            Duration = 3
        })
        
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end
end

-- Infinite Jump
function ToggleInfiniteJump(enabled)
    if enabled then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DogV1",
            Text = "Infinite Jump Enabled",
            Duration = 3
        })
        
        local jumpConnection
        jumpConnection = UserInputService.JumpRequest:Connect(function()
            if ToggleStates["InfiniteJump"] and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DogV1",
            Text = "Infinite Jump Disabled",
            Duration = 3
        })
    end
end

-- ESP
function ToggleESP(enabled)
    if enabled then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DogV1",
            Text = "ESP Enabled",
            Duration = 3
        })
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = player.Character
            end
        end
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DogV1",
            Text = "ESP Disabled",
            Duration = 3
        })
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                for _, child in ipairs(player.Character:GetChildren()) do
                    if child:IsA("Highlight") then
                        child:Destroy()
                    end
                end
            end
        end
    end
end

-- No Fall Damage
function ToggleNoFall(enabled)
    if enabled then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DogV1",
            Text = "No Fall Damage Enabled",
            Duration = 3
        })
        
        LocalPlayer.CharacterAdded:Connect(function(character)
            task.wait(1)
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            end
        end)
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DogV1",
            Text = "No Fall Damage Disabled",
            Duration = 3
        })
    end
end

-- Placeholder functions for other features
function ToggleTriggerBot() end
function ToggleReach() end
function ToggleTracers() end
function ToggleXRay() end
function ToggleAutoCollect() end
function ToggleAutoBuild() end
function ToggleChatLogger() end

-- Success notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "DogV1",
    Text = "Loaded successfully!",
    Duration = 5,
})

DogV1.Loaded = true

return DogV1
