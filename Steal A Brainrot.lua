local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 130)
frame.Position = UDim2.new(0.5, -100, 0.5, -65)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundTransparency = 1
title.Text = "Brainrot Script"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

local speedBtn = Instance.new("TextButton", frame)
speedBtn.Position = UDim2.new(0, 20, 0, 35)
speedBtn.Size = UDim2.new(0, 160, 0, 30)
speedBtn.Text = "Speed: OFF"
speedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedBtn.TextColor3 = Color3.new(1, 1, 1)
speedBtn.Font = Enum.Font.Gotham
speedBtn.TextSize = 14

local reachBtn = Instance.new("TextButton", frame)
reachBtn.Position = UDim2.new(0, 20, 0, 80)
reachBtn.Size = UDim2.new(0, 160, 0, 30)
reachBtn.Text = "Long Reach: OFF"
reachBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
reachBtn.TextColor3 = Color3.new(1, 1, 1)
reachBtn.Font = Enum.Font.Gotham
reachBtn.TextSize = 14

local speedOn = false
local reachOn = false

task.spawn(function()
	while true do
		task.wait(0.2)
		if speedOn then
			local tool = player.Backpack:FindFirstChild("Speed Coil") or character:FindFirstChild("Speed Coil")
			if tool then
				tool.Parent = character
				task.wait(0.1)
				tool.Parent = player.Backpack
			end
		end
	end
end)

task.spawn(function()
	while true do
		task.wait(0.1)
		if reachOn then
			for _, brainrot in pairs(workspace:GetDescendants()) do
				if brainrot:IsA("BasePart") and brainrot.Name:lower():find("brain") then
					local mag = (hrp.Position - brainrot.Position).Magnitude
					if mag < 25 then
						firetouchinterest(hrp, brainrot, 0)
						firetouchinterest(hrp, brainrot, 1)
					end
				end
			end
		end
	end
end)

speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	speedBtn.Text = "Speed: " .. (speedOn and "ON" or "OFF")
end)

reachBtn.MouseButton1Click:Connect(function()
	reachOn = not reachOn
	reachBtn.Text = "Long Reach: " .. (reachOn and "ON" or "OFF")
end)
