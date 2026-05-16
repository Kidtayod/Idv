-- 🌌 Denoting2 HUB
-- UI สวยขึ้น + เปิดปิดเมนู + เอฟเฟกต์เนียนๆ

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- STATES
local ESP_ON = false
local TRACER_ON = false
local FULLBRIGHT_ON = false
local ALERT_ON = false

local highlights = {}
local tracers = {}
local lastAlert = 0

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.Name = "Denoting2"

-- ปุ่มเปิดเมนู
local openBtn = Instance.new("TextButton")
openBtn.Parent = gui
openBtn.Size = UDim2.new(0,55,0,55)
openBtn.Position = UDim2.new(0,15,0.5,-27)
openBtn.BackgroundColor3 = Color3.fromRGB(25,25,35)
openBtn.Text = "☰"
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 24
openBtn.Active = true
openBtn.Draggable = true

Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1,0)

-- Glow
local stroke = Instance.new("UIStroke", openBtn)
stroke.Color = Color3.fromRGB(120,120,255)
stroke.Thickness = 2

-- Main
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,260,0,370)
frame.Position = UDim2.new(0,80,0.5,-185)
frame.BackgroundColor3 = Color3.fromRGB(18,18,28)
frame.Visible = true
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

local frameStroke = Instance.new("UIStroke", frame)
frameStroke.Color = Color3.fromRGB(90,90,255)
frameStroke.Thickness = 2

-- Gradient
local grad = Instance.new("UIGradient", frame)
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(20,20,35)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(35,35,60))
}

-- Title
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,45)
title.BackgroundTransparency = 1
title.Text = "🌌 Denoting2 HUB"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 24

-- Divider
local line = Instance.new("Frame")
line.Parent = frame
line.Size = UDim2.new(0.85,0,0,2)
line.Position = UDim2.new(0.075,0,0,45)
line.BackgroundColor3 = Color3.fromRGB(100,100,255)
line.BorderSizePixel = 0

-- Layout
local holder = Instance.new("Frame")
holder.Parent = frame
holder.BackgroundTransparency = 1
holder.Size = UDim2.new(1,0,1,-55)
holder.Position = UDim2.new(0,0,0,55)

local layout = Instance.new("UIListLayout", holder)
layout.Padding = UDim.new(0,8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- เปิดปิดเมนู
openBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- Button Creator
function CreateButton(text, callback)
	local btn = Instance.new("TextButton")
	btn.Parent = holder
	btn.Size = UDim2.new(0.88,0,0,38)
	btn.BackgroundColor3 = Color3.fromRGB(32,32,50)
	btn.Text = text
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 15
	btn.AutoButtonColor = false
	
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)
	
	local s = Instance.new("UIStroke", btn)
	s.Color = Color3.fromRGB(90,90,255)
	s.Thickness = 1.5
	
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn,TweenInfo.new(0.15),{
			BackgroundColor3 = Color3.fromRGB(50,50,80)
		}):Play()
	end)
	
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn,TweenInfo.new(0.15),{
			BackgroundColor3 = Color3.fromRGB(32,32,50)
		}):Play()
	end)
	
	btn.MouseButton1Click:Connect(callback)
end

-- ESP
function AddESP(plr)
	if plr == LocalPlayer then return end
	
	local function Setup(char)
		if highlights[plr] then
			highlights[plr]:Destroy()
		end
		
		local h = Instance.new("Highlight")
		h.Parent = game.CoreGui
		h.Adornee = char
		h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		
		if plr.Team == LocalPlayer.Team then
			h.FillColor = Color3.fromRGB(0,255,180)
		else
			h.FillColor = Color3.fromRGB(255,60,60)
		end
		
		h.FillTransparency = 0.45
		h.OutlineColor = Color3.new(1,1,1)
		
		highlights[plr] = h
	end
	
	if plr.Character then
		Setup(plr.Character)
	end
	
	plr.CharacterAdded:Connect(Setup)
end

-- Tracer
RunService.RenderStepped:Connect(function()
	if not TRACER_ON then return end
	
	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			
			if not tracers[plr] then
				local line = Drawing.new("Line")
				line.Thickness = 2
				line.Transparency = 1
				tracers[plr] = line
			end
			
			local pos, visible = Camera:WorldToViewportPoint(
				plr.Character.HumanoidRootPart.Position
			)
			
			if visible then
				tracers[plr].Visible = true
				tracers[plr].From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
				tracers[plr].To = Vector2.new(pos.X,pos.Y)
				
				if plr.Team == LocalPlayer.Team then
					tracers[plr].Color = Color3.fromRGB(0,255,180)
				else
					tracers[plr].Color = Color3.fromRGB(255,60,60)
				end
			else
				tracers[plr].Visible = false
			end
		end
	end
end)

-- Killer Alert
RunService.RenderStepped:Connect(function()
	if not ALERT_ON then return end
	
	if tick() - lastAlert < 4 then
		return
	end
	
	for _,plr in pairs(Players:GetPlayers()) do
		
		if plr ~= LocalPlayer
		and plr.Team ~= LocalPlayer.Team
		and plr.Character
		and LocalPlayer.Character
		then
			
			local enemy = plr.Character:FindFirstChild("HumanoidRootPart")
			local me = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			
			if enemy and me then
				local dist = (enemy.Position - me.Position).Magnitude
				
				if dist <= 14 then
					lastAlert = tick()
					
					StarterGui:SetCore("SendNotification",{
						Title = "🚨 Killer Nearby",
						Text = plr.Name.." อยู่ใกล้มาก",
						Duration = 2
					})
					
					break
				end
			end
		end
	end
end)

-- BUTTONS
CreateButton("👁 ESP PLAYER", function()
	ESP_ON = not ESP_ON
	
	if ESP_ON then
		for _,plr in pairs(Players:GetPlayers()) do
			AddESP(plr)
		end
	else
		for _,v in pairs(highlights) do
			v:Destroy()
		end
	end
end)

CreateButton("📍 TRACER", function()
	TRACER_ON = not TRACER_ON
	
	if not TRACER_ON then
		for _,v in pairs(tracers) do
			v.Visible = false
		end
	end
end)

CreateButton("🌞 FULLBRIGHT", function()
	FULLBRIGHT_ON = not FULLBRIGHT_ON
	
	if FULLBRIGHT_ON then
		Lighting.Brightness = 4
		Lighting.ClockTime = 14
		Lighting.FogEnd = 100000
		Lighting.GlobalShadows = false
	else
		Lighting.Brightness = 2
		Lighting.GlobalShadows = true
	end
end)

CreateButton("🚨 KILLER ALERT", function()
	ALERT_ON = not ALERT_ON
end)

CreateButton("⚡ SPEED BOOST", function()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = 19
	end
end)

CreateButton("💀 RESET SPEED", function()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = 16
	end
end)
