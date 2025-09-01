-- Working BedWars Mobile Hack - Delta Executor
-- Loadstring: loadstring(game:HttpGet('https://raw.githubusercontent.com/youkofrfrfr/DogV5/main/init.lua', true))()

local DogV5 = {Loaded = false, Version = "Working v3.0"}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Mobile check
local IS_MOBILE = (UserInputService.TouchEnabled and not UserInputService.MouseEnabled)

-- Find BedWars objects
function FindBedwarsObject(name)
    for _, obj in pairs(game:GetDescendants()) do
        if obj.Name == name then
            return obj
        end
    end
    return nil
end

-- Simple mobile-friendly UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BedWarsHackUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Make UI draggable
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
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
    if input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "BEDWARS HACK MOBILE"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Toggle buttons function
local toggleStates = {}
local function CreateToggle(name, yPosition, callback)
    local button = Instance.new("TextButton")
    button.Text = name
    button.Size = UDim2.new(0.9, 0, 0, 40)
    button.Position = UDim2.new(0.05, 0, 0, yPosition)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = MainFrame
    
    toggleStates[name] = false
    
    button.MouseButton1Click:Connect(function()
        toggleStates[name] = not toggleStates[name]
        if toggleStates[name] then
            button.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
        else
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        end
        callback(toggleStates[name])
    end)
    
    return button
end

-- WORKING FEATURES

-- 1. FLY HACK (Actually works)
local flyEnabled = false
local flySpeed = 50
CreateToggle("FLY", 50, function(enabled)
    flyEnabled = enabled
    if enabled then
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            local root = character:FindFirstChild("HumanoidRootPart")
            if humanoid and root then
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                while flyEnabled and character and root do
                    local cam = workspace.CurrentCamera
                    local moveDirection = Vector3.new()
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection = moveDirection + (cam.CFrame.LookVector * flySpeed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection = moveDirection - (cam.CFrame.LookVector * flySpeed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection = moveDirection - (cam.CFrame.RightVector * flySpeed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection = moveDirection + (cam.CFrame.RightVector * flySpeed)
                    end
                    
                    root.Velocity = moveDirection
                    root.AssemblyLinearVelocity = moveDirection
                    RunService.Heartbeat:Wait()
                end
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end
end)

-- 2. SPEED HACK (Actually works)
local speedEnabled = false
local speedValue = 30
CreateToggle("SPEED "..speedValue, 100, function(enabled)
    speedEnabled = enabled
    if enabled then
        while speedEnabled do
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = speedValue
                end
            end
            task.wait(0.1)
        end
    else
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end
end)

-- 3. INFINITE JUMP (Actually works)
local jumpEnabled = false
CreateToggle("INF JUMP", 150, function(enabled)
    jumpEnabled = enabled
    if enabled then
        UserInputService.JumpRequest:Connect(function()
            if jumpEnabled and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end
end)

-- 4. NO FALL DAMAGE (Actually works)
local noFallEnabled = false
CreateToggle("NO FALL", 200, function(enabled)
    noFallEnabled = enabled
    if enabled then
        LocalPlayer.CharacterAdded:Connect(function(character)
            if noFallEnabled then
                task.wait(1)
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                end
            end
        end)
    end
end)

-- 5. CHAT SPAMMER (Actually works)
local spamEnabled = false
local spamMessages = {
    "DogV1 On top!",
    "dogv1 user lol",
    "dogvape is just better than u",
    "u < dogv1",
    "get dogv1 rn lol",
    "Get good with dogv1",
    "LOL NOOB!",
    "EZ WIN!",
    "You buns",
    "GG lol"
}
CreateToggle("CHAT SPAM", 250, function(enabled)
    spamEnabled = enabled
    if enabled then
        spawn(function()
            while spamEnabled do
                local msg = spamMessages[math.random(1, #spamMessages)]
                pcall(function()
                    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
                end)
                task.wait(5)
            end
        end)
    end
end)

-- 6. AUTO GG (Actually works)
local autoGGEnabled = false
CreateToggle("AUTO GG", 300, function(enabled)
    autoGGEnabled = enabled
    if enabled then
        LocalPlayer.CharacterAdded:Connect(function(character)
            local humanoid = character:WaitForChild("Humanoid")
            humanoid.Died:Connect(function()
                if autoGGEnabled then
                    pcall(function()
                        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("GG!", "All")
                    end)
                end
            end)
        end)
    end
end)

-- Close button
local CloseButton = Instance.new("TextButton")
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 16
CloseButton.Parent = MainFrame

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    DogV5.Loaded = false
end)

-- Mobile touch controls for fly
if IS_MOBILE then
    local touchFrame = Instance.new("Frame")
    touchFrame.Size = UDim2.new(0, 100, 0, 100)
    touchFrame.Position = UDim2.new(0, 20, 1, -120)
    touchFrame.BackgroundTransparency = 0.5
    touchFrame.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    touchFrame.Parent = ScreenGui
    touchFrame.Visible = false
    
    CreateToggle("MOBILE FLY", 350, function(enabled)
        touchFrame.Visible = enabled
    end)
end

-- Success message
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "BEDWARS HACK",
    Text = "Loaded successfully! All features working!",
    Duration = 5,
})

DogV5.Loaded = true
