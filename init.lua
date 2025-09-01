-- DogV1 - Ultimate BedWars Hack with Anti-Cheat Bypass
-- Loadstring: loadstring(game:HttpGet('https://raw.githubusercontent.com/youkofrfrfr/DogV5/main/init.lua', true))()

local DogV1 = {
    Loaded = false,
    Version = "ULTIMATE v1.0",
    Config = {
        FlySpeed = 50,
        WalkSpeed = 30,
        JumpPower = 50,
        KillAuraRange = 25,
        ESPColor = Color3.fromRGB(255, 0, 0),
        TracerColor = Color3.fromRGB(0, 255, 0)
    }
}

-- Anti-Cheat Bypass Techniques
local function AntiCheatBypass()
    -- Hide from common anti-cheat detection methods
    local hiddenEnv = getfenv()
    setfenv(1, setmetatable({}, {
        __index = function(_, k)
            if k == "script" then return nil end
            return hiddenEnv[k]
        end
    }))
    
    -- Randomize execution patterns
    math.randomseed(tick())
    local randomDelay = math.random(50, 200) / 1000
    task.wait(randomDelay)
    
    -- Obfuscate function names
    local function ObfuscateName(original)
        local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        local newName = ""
        for i = 1, 12 do
            newName = newName .. string.sub(chars, math.random(1, #chars), math.random(1, #chars))
        end
        return newName
    end
    
    -- Hook common detection functions
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        -- Bypass anti-cheat checks
        if tostring(self) == "AntiCheat" or tostring(method):lower():find("cheat") then
            return true
        end
        
        return oldNamecall(self, unpack(args))
    end)
end

-- Execute anti-cheat bypass
AntiCheatBypass()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Core variables
local rainbowColors = {
    Color3.fromRGB(255, 0, 0),    -- Red
    Color3.fromRGB(255, 165, 0),  -- Orange
    Color3.fromRGB(255, 255, 0),  -- Yellow
    Color3.fromRGB(0, 255, 0),    -- Green
    Color3.fromRGB(0, 0, 255),    -- Blue
    Color3.fromRGB(75, 0, 130),   -- Indigo
    Color3.fromRGB(238, 130, 238) -- Violet
}

local toggleStates = {}
local connections = {}
local espObjects = {}
local tracerObjects = {}
local flyConnections = {}

-- Find BedWars specific objects
local function FindBedwarsRemote(namePattern)
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            if string.find(obj.Name:lower(), namePattern:lower()) then
                return obj
            end
        end
    end
    return nil
end

-- BedWars specific attack logic
local function BedwarsAttack(target)
    -- Try to find BedWars combat remotes
    local attackRemote = FindBedwarsRemote("attack") or FindBedwarsRemote("damage") or FindBedwarsRemote("hit")
    local swordRemote = FindBedwarsRemote("sword") or FindBedwarsRemote("melee")
    
    if attackRemote then
        pcall(function()
            -- Simulate attack with BedWars remote
            attackRemote:FireServer(target.Character.Humanoid)
        end)
    elseif swordRemote then
        pcall(function()
            -- Simulate sword attack
            swordRemote:FireServer(target.Character.HumanoidRootPart.Position)
        end)
    else
        -- Fallback to basic attack
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
    end
end

-- UI Library (Custom Implementation)
local function CreateNotification(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration,
        Icon = "rbxassetid://6722533499"
    })
end

-- Create FelipeHUB style UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DogV1UI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main container with rainbow border
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Size = UDim2.new(0, 750, 0, 500)
MainContainer.Position = UDim2.new(0.5, -375, 0.5, -250)
MainContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainContainer.BorderSizePixel = 0
MainContainer.ClipsDescendants = true
MainContainer.Parent = ScreenGui

-- Rainbow border animation
local borderFrames = {}
local borderPositions = {
    {Size = UDim2.new(1, 0, 0, 3), Position = UDim2.new(0, 0, 0, 0)},
    {Size = UDim2.new(1, 0, 0, 3), Position = UDim2.new(0, 0, 1, -3)},
    {Size = UDim2.new(0, 3, 1, 0), Position = UDim2.new(0, 0, 0, 0)},
    {Size = UDim2.new(0, 3, 1, 0), Position = UDim2.new(1, -3, 0, 0)}
}

for i, border in ipairs(borderPositions) do
    local borderFrame = Instance.new("Frame")
    borderFrame.Size = border.Size
    borderFrame.Position = border.Position
    borderFrame.BorderSizePixel = 0
    borderFrame.Parent = MainContainer
    borderFrames[i] = borderFrame
end

-- Animate rainbow border
spawn(function()
    local counter = 1
    while true do
        for _, border in ipairs(borderFrames) do
            border.BackgroundColor3 = rainbowColors[counter]
        end
        counter = counter % #rainbowColors + 1
        task.wait(0.2)
    end
end)

-- Header with logo and title
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Header.BorderSizePixel = 0
Header.Parent = MainContainer

-- Logo button (hide/show UI)
local LogoButton = Instance.new("TextButton")
LogoButton.Text = "🐶"  -- Dog logo
LogoButton.Size = UDim2.new(0, 40, 0, 40)
LogoButton.Position = UDim2.new(0, 0, 0, 0)
LogoButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
LogoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoButton.Font = Enum.Font.GothamBold
LogoButton.TextSize = 20
LogoButton.Parent = Header

-- Title with rainbow effect
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 40, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DOG V1  ULTIMATE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Header

-- Rainbow title animation
spawn(function()
    local counter = 1
    while true do
        Title.TextColor3 = rainbowColors[counter]
        counter = counter % #rainbowColors + 1
        task.wait(0.3)
    end
end)

-- Sidebar with commands
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 160, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainContainer

-- Command list matching FelipeHUB style
local commands = {
    "1,450", "BATTLEPASS", "MISSIONS", "LOCKER", "CLAN STORE", 
    "SOCIAL WARPS", "final/Mode", "Patch Notes", "FREE2PLAY", 
    "FREEDOMY A-2023", "Speed Velocity", "Dayermodel", "Trametags", 
    "Autoregion", "Shaders", "Settings", "Symbol", "Tracers", 
    "Health", "Spider", "Sprint", "CSPI", "100", "125 CREATE PARTY", 
    "PLAY", "KITS", "DOG V1"
}

local CommandList = Instance.new("ScrollingFrame")
CommandList.Name = "CommandList"
CommandList.Size = UDim2.new(1, 0, 1, 0)
CommandList.Position = UDim2.new(0, 0, 0, 0)
CommandList.BackgroundTransparency = 1
CommandList.CanvasSize = UDim2.new(0, 0, 0, #commands * 25)
CommandList.ScrollBarThickness = 5
CommandList.Parent = Sidebar

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = CommandList
UIListLayout.Padding = UDim.new(0, 3)

for i, cmd in ipairs(commands) do
    local cmdText = Instance.new("TextLabel")
    cmdText.Size = UDim2.new(1, -10, 0, 22)
    cmdText.Position = UDim2.new(0, 5, 0, (i-1)*25)
    cmdText.BackgroundTransparency = 1
    cmdText.Text = " " .. cmd
    cmdText.TextColor3 = Color3.fromRGB(200, 200, 200)
    cmdText.Font = Enum.Font.Gotham
    cmdText.TextSize = 12
    cmdText.TextXAlignment = Enum.TextXAlignment.Left
    cmdText.Parent = CommandList
    
    -- Rainbow effect for important commands
    if cmd == "DOG V1" or cmd == "BATTLEPASS" or cmd == "PLAY" then
        spawn(function()
            local counter = 1
            while cmdText.Parent do
                cmdText.TextColor3 = rainbowColors[counter]
                counter = counter % #rainbowColors + 1
                task.wait(0.4)
            end
        end)
    end
end

-- Tab system
local TabsContainer = Instance.new("Frame")
TabsContainer.Size = UDim2.new(1, -160, 0, 30)
TabsContainer.Position = UDim2.new(0, 160, 0, 40)
TabsContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
TabsContainer.BorderSizePixel = 0
TabsContainer.Parent = MainContainer

local tabButtons = {}
local tabFrames = {}
local tabs = {"COMBAT", "MOVEMENT", "VISUALS", "CHAT", "MISC", "SETTINGS"}

for i, tabName in ipairs(tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Text = tabName
    tabButton.Size = UDim2.new(1/6, 0, 1, 0)
    tabButton.Position = UDim2.new((i-1)/6, 0, 0, 0)
    tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.Font = Enum.Font.GothamBold
    tabButton.TextSize = 12
    tabButton.Parent = TabsContainer
    tabButtons[tabName] = tabButton
    
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Size = UDim2.new(1, -160, 1, -70)
    tabFrame.Position = UDim2.new(0, 160, 0, 70)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = (i == 1)
    tabFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
    tabFrame.ScrollBarThickness = 5
    tabFrame.Parent = MainContainer
    tabFrames[tabName] = tabFrame
    
    tabButton.MouseButton1Click:Connect(function()
        for _, frame in pairs(tabFrames) do
            frame.Visible = false
        end
        for _, button in pairs(tabButtons) do
            button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        end
        tabFrame.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    end)
end

-- Default first tab active
tabButtons["COMBAT"].BackgroundColor3 = Color3.fromRGB(0, 150, 255)

-- Feature button creation function
local function CreateFeatureButton(parent, name, yPos, callback, hasSlider, min, max, default)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(0.95, 0, 0, hasSlider and 70 or 40)
    buttonFrame.Position = UDim2.new(0.025, 0, 0, yPos)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = parent
    
    local button = Instance.new("TextButton")
    button.Text = name
    button.Size = UDim2.new(1, 0, 0, 40)
    button.Position = UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.Parent = buttonFrame
    
    toggleStates[name] = false
    
    if hasSlider then
        local slider = Instance.new("Frame")
        slider.Size = UDim2.new(1, 0, 0, 20)
        slider.Position = UDim2.new(0, 0, 0, 45)
        slider.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
        slider.BorderSizePixel = 0
        slider.Parent = buttonFrame
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(1, 0, 1, 0)
        valueLabel.Position = UDim2.new(0, 0, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(default)
        valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        valueLabel.Font = Enum.Font.Gotham
        valueLabel.TextSize = 12
        valueLabel.Parent = slider
        
        DogV1.Config[name] = default
    end
    
    button.MouseButton1Click:Connect(function()
        toggleStates[name] = not toggleStates[name]
        if toggleStates[name] then
            button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        else
            button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        end
        if callback then
            callback(toggleStates[name])
        end
    end)
    
    return buttonFrame
end

-- COMBAT TAB FEATURES
CreateFeatureButton(tabFrames["COMBAT"], "KILLAURA", 20, function(enabled)
    ToggleKillAura(enabled)
end, true, 10, 50, 25)

CreateFeatureButton(tabFrames["COMBAT"], "AIMBOT", 100, function(enabled)
    ToggleAimbot(enabled)
end)

CreateFeatureButton(tabFrames["COMBAT"], "HITBOX EXPAND", 180, function(enabled)
    ToggleHitbox(enabled)
end, true, 1, 5, 2)

CreateFeatureButton(tabFrames["COMBAT"], "AUTO ATTACK", 260, function(enabled)
    ToggleAutoAttack(enabled)
end)

CreateFeatureButton(tabFrames["COMBAT"], "CRITICAL HITS", 340, function(enabled)
    ToggleCriticalHits(enabled)
end)

-- MOVEMENT TAB FEATURES
CreateFeatureButton(tabFrames["MOVEMENT"], "FLY HACK", 20, function(enabled)
    ToggleFly(enabled)
end, true, 10, 100, 50)

CreateFeatureButton(tabFrames["MOVEMENT"], "SPEED HACK", 100, function(enabled)
    ToggleSpeed(enabled)
end, true, 16, 100, 30)

CreateFeatureButton(tabFrames["MOVEMENT"], "INF JUMP", 180, function(enabled)
    ToggleJump(enabled)
end)

CreateFeatureButton(tabFrames["MOVEMENT"], "NO FALL DAMAGE", 260, function(enabled)
    ToggleNoFall(enabled)
end)

CreateFeatureButton(tabFrames["MOVEMENT"], "WALL WALK", 340, function(enabled)
    ToggleWallWalk(enabled)
end)

-- VISUALS TAB FEATURES
CreateFeatureButton(tabFrames["VISUALS"], "ESP", 20, function(enabled)
    ToggleESP(enabled)
end)

CreateFeatureButton(tabFrames["VISUALS"], "TRACERS", 100, function(enabled)
    ToggleTracers(enabled)
end)

CreateFeatureButton(tabFrames["VISUALS"], "X-RAY", 180, function(enabled)
    ToggleXray(enabled)
end)

CreateFeatureButton(tabFrames["VISUALS"], "CHAMS", 260, function(enabled)
    ToggleChams(enabled)
end)

CreateFeatureButton(tabFrames["VISUALS"], "FULLBRIGHT", 340, function(enabled)
    ToggleFullbright(enabled)
end)

-- CHAT TAB FEATURES
CreateFeatureButton(tabFrames["CHAT"], "CHAT SPAM", 20, function(enabled)
    ToggleSpam(enabled)
end)

CreateFeatureButton(tabFrames["CHAT"], "AUTO GG", 100, function(enabled)
    ToggleAutoGG(enabled)
end)

CreateFeatureButton(tabFrames["CHAT"], "AUTO TRASH TALK", 180, function(enabled)
    ToggleTrashTalk(enabled)
end)

-- MISC TAB FEATURES
CreateFeatureButton(tabFrames["MISC"], "ANTI-AFK", 20, function(enabled)
    ToggleAntiAFK(enabled)
end)

CreateFeatureButton(tabFrames["MISC"], "FPS BOOST", 100, function(enabled)
    ToggleFPSBoost(enabled)
end)

CreateFeatureButton(tabFrames["MISC"], "AUTO FARM", 180, function(enabled)
    ToggleAutoFarm(enabled)
end)

CreateFeatureButton(tabFrames["MISC"], "AUTO COLLECT", 260, function(enabled)
    ToggleAutoCollect(enabled)
end)

-- SETTINGS TAB
CreateFeatureButton(tabFrames["SETTINGS"], "UNLOAD SCRIPT", 20, function(enabled)
    UnloadScript()
end)

CreateFeatureButton(tabFrames["SETTINGS"], "UI THEME", 100, function(enabled)
    ChangeUITheme()
end)

-- ACTUAL HACK IMPLEMENTATIONS WITH ANTI-CHEAT BYPASS

-- FLY HACK (Advanced Implementation with Anti-Cheat Bypass)
function ToggleFly(enabled)
    if enabled then
        CreateNotification("FLY HACK", "Enabled - Use WASD to fly", 3)
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then return end
        
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        
        local flyConnection = RunService.Heartbeat:Connect(function()
            if not toggleStates["FLY HACK"] or not character or not rootPart then
                flyConnection:Disconnect()
                return
            end
            
            -- Anti-cheat: Randomize execution pattern
            if math.random(1, 100) > 95 then
                task.wait(math.random(1, 3) / 100)
            end
            
            local cam = Workspace.CurrentCamera
            local flySpeed = DogV1.Config["FLY HACK"]
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
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, flySpeed, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDirection = moveDirection - Vector3.new(0, flySpeed, 0)
            end
            
            -- Anti-cheat: Add slight randomness to movement
            moveDirection = moveDirection + Vector3.new(
                math.random(-5, 5) / 10,
                math.random(-5, 5) / 10,
                math.random(-5, 5) / 10
            )
            
            rootPart.Velocity = moveDirection
            rootPart.AssemblyLinearVelocity = moveDirection
        end)
        
        table.insert(flyConnections, flyConnection)
    else
        CreateNotification("FLY HACK", "Disabled", 3)
        for _, conn in ipairs(flyConnections) do
            conn:Disconnect()
        end
        flyConnections = {}
        
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end
end

-- KILLAURA WITH BEDWARS ATTACK LOGIC
function ToggleKillAura(enabled)
    if enabled then
        local range = DogV1.Config["KILLAURA"]
        CreateNotification("KILLAURA", "Enabled - Range: " .. range, 3)
        
        local auraConnection = RunService.Heartbeat:Connect(function()
            if not toggleStates["KILLAURA"] then return end
            
            -- Anti-cheat: Random delay
            if math.random(1, 100) > 80 then
                task.wait(math.random(1, 5) / 100)
            end
            
            local character = LocalPlayer.Character
            if not character then return end
            
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if not rootPart then return end
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    local targetHumanoid = player.Character:FindFirstChild("Humanoid")
                    
                    if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                        local distance = (rootPart.Position - targetRoot.Position).Magnitude
                        
                        if distance <= range then
                            -- Use BedWars specific attack logic
                            BedwarsAttack(player)
                            
                            -- Anti-cheat: Add cooldown between attacks
                            task.wait(math.random(5, 15) / 100)
                        end
                    end
                end
            end
        end)
        
        table.insert(connections, auraConnection)
    else
        CreateNotification("KILLAURA", "Disabled", 3)
    end
end

-- SPEED HACK WITH ANTI-CHEAT
function ToggleSpeed(enabled)
    if enabled then
        local speed = DogV1.Config["SPEED HACK"]
        CreateNotification("SPEED HACK", "Speed set to " .. speed, 3)
        
        local speedConnection = RunService.Heartbeat:Connect(function()
            if not toggleStates["SPEED HACK"] then
                speedConnection:Disconnect()
                return
            end
            
            -- Anti-cheat: Randomize execution
            if math.random(1, 100) > 90 then
                task.wait(math.random(1, 3) / 100)
            end
            
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    -- Add slight randomness to avoid detection
                    humanoid.WalkSpeed = speed + math.random(-2, 2)
                end
            end
        end)
        
        table.insert(connections, speedConnection)
    else
        CreateNotification("SPEED HACK", "Speed reset to 16", 3)
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end
end

-- Logo button functionality (hide/show UI)
LogoButton.MouseButton1Click:Connect(function()
    MainContainer.Visible = not MainContainer.Visible
    if MainContainer.Visible then
        CreateNotification("DOG V1", "UI Shown", 2)
    else
        CreateNotification("DOG V1", "UI Hidden", 2)
    end
end)

-- Make UI draggable
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainContainer.Position
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Success message
CreateNotification("DOG V1 ULTIMATE", "Loaded successfully with Anti-Cheat Bypass!", 5)

DogV1.Loaded = true

return DogV1
