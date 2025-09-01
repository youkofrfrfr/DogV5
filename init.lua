-- DogV5 - Premium BedWars Utility
-- Loadstring: loadstring(game:HttpGet('https://raw.githubusercontent.com/youkofrfrfr/DogV5/main/init.lua', true))()

local DogV5 = {Loaded = false, Version = "v1.0"}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("DogV5 - Premium", "DarkTheme")

-- Main Tab
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Combat Features")

-- KillAura
local KillAura = false
local KillAuraRange = 15
MainSection:NewToggle("KillAura", "Automatically attacks nearby players", function(state)
    KillAura = state
    if state then
        Library:SendNotification("KillAura", "Enabled KillAura", 5)
    else
        Library:SendNotification("KillAura", "Disabled KillAura", 5)
    end
end)

MainSection:NewSlider("KillAura Range", "Range for KillAura", 50, 5, function(value)
    KillAuraRange = value
end)

-- Infinite Jump
local InfiniteJump = false
MainSection:NewToggle("Infinite Jump", "Jump infinitely in the air", function(state)
    InfiniteJump = state
    if state then
        Library:SendNotification("Infinite Jump", "Enabled Infinite Jump", 5)
    else
        Library:SendNotification("Infinite Jump", "Disabled Infinite Jump", 5)
    end
end)

-- Chat Spammer Tab
local ChatTab = Window:NewTab("Chat")
local ChatSection = ChatTab:NewSection("Chat Spammer")

-- Chat Spammer
local ChatSpammer = false
local SpamDelay = 5
local SpamMessages = {
    "Get DogV5 - Best BedWars Script!",
    "You just got destroyed by DogV5!",
    "gg ez - DogV5 user btw",
    "Imagine not using DogV5 lol",
    "DogV5 > Your script",
    "Free win with DogV5!",
    "This is what DogV5 can do!",
    "Get good with DogV5!",
    "Another DogV5 victory!",
    "You can't beat DogV5 users!"
}

ChatSection:NewToggle("Chat Spammer", "Spams messages in chat", function(state)
    ChatSpammer = state
    if state then
        Library:SendNotification("Chat Spammer", "Enabled Chat Spammer", 5)
        spawn(function()
            while ChatSpammer and task.wait(SpamDelay) do
                local randomMessage = SpamMessages[math.random(1, #SpamMessages)]
                pcall(function()
                    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(randomMessage, "All")
                end)
            end
        end)
    else
        Library:SendNotification("Chat Spammer", "Disabled Chat Spammer", 5)
    end
end)

ChatSection:NewSlider("Spam Delay", "Delay between messages", 30, 1, function(value)
    SpamDelay = value
end)

-- Auto GG
local AutoGG = false
ChatSection:NewToggle("Auto GG", "Sends GG when you kill someone", function(state)
    AutoGG = state
    if state then
        Library:SendNotification("Auto GG", "Enabled Auto GG", 5)
    else
        Library:SendNotification("Auto GG", "Disabled Auto GG", 5)
    end
end)

-- Player Tab
local PlayerTab = Window:NewTab("Player")
local PlayerSection = PlayerTab:NewSection("Player Modifications")

-- Speed
local SpeedEnabled = false
local SpeedValue = 20
PlayerSection:NewToggle("Speed", "Increases walk speed", function(state)
    SpeedEnabled = state
    if state then
        Library:SendNotification("Speed", "Enabled Speed", 5)
    else
        Library:SendNotification("Speed", "Disabled Speed", 5)
    end
end)

PlayerSection:NewSlider("Speed Value", "Walk speed multiplier", 100, 16, function(value)
    SpeedValue = value
end)

-- High Jump
local HighJumpEnabled = false
local JumpPower = 50
PlayerSection:NewToggle("High Jump", "Increases jump power", function(state)
    HighJumpEnabled = state
    if state then
        Library:SendNotification("High Jump", "Enabled High Jump", 5)
    else
        Library:SendNotification("High Jump", "Disabled High Jump", 5)
    end
end)

PlayerSection:NewSlider("Jump Power", "Jump power value", 100, 50, function(value)
    JumpPower = value
end)

-- Visuals Tab
local VisualsTab = Window:NewTab("Visuals")
local VisualsSection = VisualsTab:NewSection("ESP Features")

-- Tracers
local Tracers = false
VisualsSection:NewToggle("Tracers", "Shows lines to players", function(state)
    Tracers = state
    if state then
        Library:SendNotification("Tracers", "Enabled Tracers", 5)
    else
        Library:SendNotification("Tracers", "Disabled Tracers", 5)
    end
end)

-- Name ESP
local NameESP = false
VisualsSection:NewToggle("Name ESP", "Shows player names", function(state)
    NameESP = state
    if state then
        Library:SendNotification("Name ESP", "Enabled Name ESP", 5)
    else
        Library:SendNotification("Name ESP", "Disabled Name ESP", 5)
    end
end)

-- Settings Tab
local SettingsTab = Window:NewTab("Settings")
local SettingsSection = SettingsTab:NewSection("Configuration")

SettingsSection:NewButton("Unload Script", "Unloads DogV5", function()
    Library:Unload()
    DogV5.Loaded = false
end)

SettingsSection:NewKeybind("UI Toggle", "Toggle the UI", Enum.KeyCode.RightShift, function()
    Library:ToggleUI()
end)

-- Main Functions
local function onCharacterAdded(character)
    if character then
        local humanoid = character:WaitForChild("Humanoid")
        
        -- Speed hack
        if SpeedEnabled then
            humanoid.WalkSpeed = SpeedValue
        end
        
        -- High jump
        if HighJumpEnabled then
            humanoid.JumpPower = JumpPower
        end
        
        -- Kill event
        humanoid.Died:Connect(function()
            if AutoGG then
                pcall(function()
                    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("gg", "All")
                end)
            end
        end)
    end
end

-- Connect character added
if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if InfiniteJump and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:ChangeState("Jumping")
        end
    end
end)

-- KillAura function
RunService.Heartbeat:Connect(function()
    if KillAura and LocalPlayer.Character then
        local character = LocalPlayer.Character
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoidRootPart then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    local targetHumanoid = player.Character:FindFirstChild("Humanoid")
                    
                    if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                        local distance = (humanoidRootPart.Position - targetRoot.Position).Magnitude
                        
                        if distance <= KillAuraRange then
                            -- Simulate attack
                            humanoidRootPart.CFrame = targetRoot.CFrame
                        end
                    end
                end
            end
        end
    end
end)

-- Speed modifier
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and SpeedEnabled then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = SpeedValue
        end
    end
end)

-- Load notification
Library:SendNotification("DogV5", "Successfully loaded! Version: " .. DogV5.Version, 10)
DogV5.Loaded = true

return DogV5
