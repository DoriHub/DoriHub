-- Dori Hub v3.2 (Ronix Edition)
-- Optimized for Ronix mobile executor

-- Core Configurations
local Config = {
    WaterWalk = false,
    LavaImmune = false,
    Logia = false,
    AutoStats = {
        Enabled = false,
        Melee = 0,
        Defense = 0,
        Sword = 0,
        Gun = 0,
        Fruit = 0
    }
}

-- Ronix Storage
local function SaveConfig()
    if Ronix then
        Ronix:SetGlobal("DoriHub_Config", Config)
    end
end

local function LoadConfig()
    if Ronix then
        local saved = Ronix:GetGlobal("DoriHub_Config")
        if saved then
            for k, v in pairs(saved) do
                if typeof(v) == "table" then
                    for sk, sv in pairs(v) do
                        Config[k][sk] = sv
                    end
                else
                    Config[k] = v
                end
            end
        end
    end
end
LoadConfig()

-- Anti-AFK (Ronix Style)
local VirtualInput = game:GetService("VirtualInputManager")
task.spawn(function()
    while task.wait(30) do
        pcall(function()
            VirtualInput:SendMouseMoveEvent(100, 100, game:GetService("Workspace"))
            task.wait(0.5)
            VirtualInput:SendMouseButtonEvent(100, 100, 0, true, game, 1)
            task.wait(0.1)
            VirtualInput:SendMouseButtonEvent(100, 100, 0, false, game, 1)
        end)
    end
end)

-- GUI Setup
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "DoriHub"
ScreenGui.ResetOnSpawn = false

local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 70, 0, 70)
ToggleBtn.Position = UDim2.new(1, -80, 0.5, -35)
ToggleBtn.Image = "rbxassetid://14922141953"
ToggleBtn.BackgroundTransparency = 1

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 310, 0, 410)
MainFrame.Position = UDim2.new(0.5, -155, 0.5, -205)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Visible = false

-- Drag System (Touch)
local DragBar = Instance.new("Frame", MainFrame)
DragBar.Size = UDim2.new(1, 0, 0, 40)
DragBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local Tabs = {}
local function CreateTab(name)
    local Button = Instance.new("TextButton", DragBar)
    Button.Size = UDim2.new(0, 80, 0, 30)
    Button.Position = UDim2.new(0, 10 + (#Tabs * 90), 0, 5)
    Button.Text = name

    local Frame = Instance.new("Frame", MainFrame)
    Frame.Size = UDim2.new(1, -20, 1, -50)
    Frame.Position = UDim2.new(0, 10, 0, 50)
    Frame.BackgroundTransparency = 1
    Frame.Visible = false

    Button.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Visible = false
        end
        Frame.Visible = true
    end)

    table.insert(Tabs, Frame)
    return Frame
end

-- ======= FEATURES =======

local OthersTab = CreateTab("Others")

local function CreateToggle(parent, text, y, key, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 180, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = text .. ": " .. (Config[key] and "ON" or "OFF")
    btn.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        btn.Text = text .. ": " .. (Config[key] and "ON" or "OFF")
        SaveConfig()
        callback(Config[key])
    end)
end

-- Water Walk
CreateToggle(OthersTab, "Water Walk", 10, "WaterWalk", function(state)
    task.spawn(function()
        while state do
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") and (part.Name:lower():find("water") or part.Name:lower():find("sea")) then
                    part.CanTouch = not state
                    part.CanCollide = not state
                end
            end
            task.wait(1)
        end
    end)
end)

-- Lava Immune
CreateToggle(OthersTab, "Lava Immune", 50, "LavaImmune", function(state)
    task.spawn(function()
        while state do
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Name:lower():find("lava") then
                    part.CanTouch = not state
                end
            end
            task.wait(1)
        end
    end)
end)

-- Logia Effect
CreateToggle(OthersTab, "Logia Effect", 90, "Logia", function(state)
    task.spawn(function()
        while state do
            pcall(function()
                local aura = Player.Character:FindFirstChild("Aura")
                if aura then
                    aura.Transparency = state and 0 or 1
                end
            end)
            task.wait(0.5)
        end
    end)
end)

-- Auto Factory Core (NEW)
local FactoryTab = CreateTab("Factory")
local afcBtn = Instance.new("TextButton", FactoryTab)
afcBtn.Size = UDim2.new(0, 180, 0, 30)
afcBtn.Position = UDim2.new(0, 10, 0, 10)
afcBtn.Text = "Auto Collect Core"
afcBtn.MouseButton1Click:Connect(function()
    task.spawn(function()
        while true do
            pcall(function()
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name:lower():find("core") and v:IsA("BasePart") then
                        firetouchinterest(Player.Character.HumanoidRootPart, v, 0)
                        firetouchinterest(Player.Character.HumanoidRootPart, v, 1)
                    end
                end
            end)
            task.wait(1)
        end
    end)
end)

-- Auto Stats Tab
local StatsTab = CreateTab("Stats")

local function CreateStatInput(stat, y)
    local box = Instance.new("TextBox", StatsTab)
    box.Size = UDim2.new(0, 100, 0, 25)
    box.Position = UDim2.new(0, 10, 0, y)
    box.PlaceholderText = stat .. " (0-100)"
    box.Text = tostring(Config.AutoStats[stat])

    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val and val >= 0 and val <= 100 then
            Config.AutoStats[stat] = val
            SaveConfig()
        else
            box.Text = tostring(Config.AutoStats[stat])
        end
    end)
end

CreateStatInput("Melee", 10)
CreateStatInput("Defense", 40)
CreateStatInput("Sword", 70)
CreateStatInput("Gun", 100)
CreateStatInput("Fruit", 130)

local enableBtn = Instance.new("TextButton", StatsTab)
enableBtn.Size = UDim2.new(0, 180, 0, 30)
enableBtn.Position = UDim2.new(0, 10, 0, 170)
enableBtn.Text = "Auto Stats: " .. (Config.AutoStats.Enabled and "ON" or "OFF")
enableBtn.MouseButton1Click:Connect(function()
    Config.AutoStats.Enabled = not Config.AutoStats.Enabled
    enableBtn.Text = "Auto Stats: " .. (Config.AutoStats.Enabled and "ON" or "OFF")
    SaveConfig()
end)

-- Auto Stats Logic
task.spawn(function()
    while task.wait(2) do
        if Config.AutoStats.Enabled then
            local Remote = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer
            for stat, amount in pairs(Config.AutoStats) do
                if stat ~= "Enabled" and amount > 0 then
                    pcall(function()
                        Remote("AddPoint", stat, amount)
                    end)
                    task.wait(0.5)
                end
            end
        end
    end
end)

-- Drag System
local dragging, dragInput, dragStart, startPos
DragBar.InputBegan:Connect(function(input)
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

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Toggle GUI Visibility
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Default Tab
if #Tabs > 0 then
    Tabs[1].Visible = true
end

print("Dori Hub v3.2 Loaded (Ronix Edition)")
