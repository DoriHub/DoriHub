local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

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
title.Text = "Steal A Brainrot Hack"
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

local noclipBtn = Instance.new("TextButton", frame)
noclipBtn.Position = UDim2.new(0, 20, 0, 80)
noclipBtn.Size = UDim2.new(0, 160, 0, 30)
noclipBtn.Text = "Noclip: OFF"
noclipBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
noclipBtn.TextColor3 = Color3.new(1, 1, 1)
noclipBtn.Font = Enum.Font.Gotham
noclipBtn.TextSize = 14

local speedOn = false
local noclipOn = false
local speedValue = 3

local moveVector = Vector3.zero

UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.W then moveVector = Vector3.new(0,0,-1)
	elseif input.KeyCode == Enum.KeyCode.S then moveVector = Vector3.new(0,0,1)
	elseif input.KeyCode == Enum.KeyCode.A then moveVector = Vector3.new(-1,0,0)
	elseif input.KeyCode == Enum.KeyCode.D then moveVector = Vector3.new(1,0,0)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then
		moveVector = Vector3.zero
	end
end)

speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	speedBtn.Text = "Speed: " .. (speedOn and "ON" or "OFF")
end)

noclipBtn.MouseButton1Click:Connect(function()
	noclipOn = not noclipOn
	noclipBtn.Text = "Noclip: " .. (noclipOn and "ON" or "OFF")
end)

RunService.RenderStepped:Connect(function()
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end

	if speedOn and moveVector.Magnitude > 0 then
		local cf = hrp.CFrame
		local dir = cf:VectorToWorldSpace(moveVector)
		hrp.CFrame = cf + dir.Unit * speedValue
	end

	if noclipOn then
		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)
