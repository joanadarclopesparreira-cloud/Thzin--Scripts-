-- THZIN SCRIPT 👾 V2 - FULL (UI Futurista, Key, Radar Neon, ESP, Teleporte otimizado)
-- Fonte escolhida: estilo HUD (GothamBold)
-- Key fixa: thzinpremium

local KEY_REQUIRED = "thzinpremium"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Parent GUI no PlayerGui (mais seguro)
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThzinxGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Helpers
local function makeUICorner(parent, radius)
	local c = Instance.new("UICorner", parent)
	c.CornerRadius = UDim.new(0, radius or 8)
	return c
end
local function makeStroke(parent, color, thickness)
	local s = Instance.new("UIStroke", parent)
	s.Color = color or Color3.fromRGB(0,170,255)
	s.Thickness = thickness or 2
	return s
end
local function safeWait(t)
	if t and t > 0 then task.wait(t) end
end

-- MAIN FRAME
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 360, 0, 420)
Main.Position = UDim2.new(0.5, -180, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(12, 18, 30)
Main.BackgroundTransparency = 0.02
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = ScreenGui
makeUICorner(Main, 14)
makeStroke(Main, Color3.fromRGB(0,170,255), 2)

-- TITLE (clean text)
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 46)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundTransparency = 1
Title.Text = "THZIN SCRIPTS 👾"
Title.TextColor3 = Color3.fromRGB(200, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextScaled = false
Title.RichText = false

-- Close/Minimize toggle button (visible always)
local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0, 64, 0, 64)
Toggle.Position = UDim2.new(0, 12, 0.5, -32)
Toggle.Text = "👾"
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 28
Toggle.TextColor3 = Color3.fromRGB(255,255,255)
Toggle.BackgroundColor3 = Color3.fromRGB(0,170,255)
makeUICorner(Toggle, 16)
Toggle.Parent = ScreenGui

local menuOpen = false
Toggle.MouseButton1Click:Connect(function()
	menuOpen = not menuOpen
	if menuOpen then
		Main.Visible = true
		TweenService:Create(Main, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.02}):Play()
	else
		TweenService:Create(Main, TweenInfo.new(0.18), {BackgroundTransparency = 1}):Play()
		task.delay(0.18, function() Main.Visible = false end)
	end
end)

-- KEY UI
local KeyBox = Instance.new("TextBox", Main)
KeyBox.Size = UDim2.new(0.9, 0, 0, 40)
KeyBox.Position = UDim2.new(0.05, 0, 0.12, 0)
KeyBox.PlaceholderText = "Digite a sua key..."
KeyBox.Text = ""
KeyBox.BackgroundColor3 = Color3.fromRGB(20,28,44)
KeyBox.TextColor3 = Color3.fromRGB(230,230,230)
KeyBox.Font = Enum.Font.GothamBold
KeyBox.TextSize = 18
makeUICorner(KeyBox, 8)

local KeyBtn = Instance.new("TextButton", Main)
KeyBtn.Size = UDim2.new(0.9, 0, 0, 40)
KeyBtn.Position = UDim2.new(0.05, 0, 0.245, 0)
KeyBtn.Text = "VALIDAR KEY"
KeyBtn.Font = Enum.Font.GothamBold
KeyBtn.TextSize = 18
KeyBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
KeyBtn.TextColor3 = Color3.fromRGB(10,10,10)
makeUICorner(KeyBtn, 8)

local AccessGranted = false
KeyBtn.MouseButton1Click:Connect(function()
	if KeyBox.Text == KEY_REQUIRED then
		AccessGranted = true
		KeyBtn.Text = "ACESSO LIBERADO ✔"
		KeyBtn.BackgroundColor3 = Color3.fromRGB(0,220,120)
		task.delay(0.4, function()
			-- open the menu after key
			if not menuOpen then
				Toggle:Activate()
			end
		end)
	else
		KeyBtn.Text = "KEY INVÁLIDA ❌"
		KeyBtn.BackgroundColor3 = Color3.fromRGB(220,60,60)
		task.delay(1.0, function()
			KeyBtn.Text = "VALIDAR KEY"
			KeyBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
		end)
	end
end)

-- Buttons factory (clean text)
local function createButton(text, y)
	local b = Instance.new("TextButton", Main)
	b.Size = UDim2.new(0.9, 0, 0, 40)
	b.Position = UDim2.new(0.05, 0, y, 0)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 18
	b.TextColor3 = Color3.fromRGB(230,230,255)
	b.BackgroundColor3 = Color3.fromRGB(18, 26, 40)
	makeUICorner(b, 8)
	return b
end

-- Save / Teleport
local savedCFrame = nil
local SaveBtn = createButton("Salvar Localização", 0.40)
local TpBtn = createButton("Ir para Localização", 0.52)

SaveBtn.MouseButton1Click:Connect(function()
	if not AccessGranted then return end
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		savedCFrame = char.HumanoidRootPart.CFrame
		SaveBtn.Text = "Localização salva ✔"
	end
end)

-- Teleport otimizado SEM travar
TpBtn.MouseButton1Click:Connect(function()
	if not AccessGranted then return end
	if not savedCFrame then
		TpBtn.Text = "Nenhuma localização salva!"
		task.delay(1, function() TpBtn.Text = "Ir para Localização" end)
		return
	end
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local hrp = char.HumanoidRootPart

	-- Try smooth lerp movement (se jogo permitir)
	local steps = 10
	for i = 1, steps do
		hrp.CFrame = hrp.CFrame:Lerp(savedCFrame, 0.2)
		hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
		task.wait(0.03)
	end
	-- Final snap to ensure exact position
	hrp.CFrame = savedCFrame
end)

-- ESP / Brainrot Marker
local function markBrainrots()
	for _, d in pairs(workspace:GetDescendants()) do
		if d:IsA("BasePart") and d.Name:lower():find("brain") then
			if not d:FindFirstChild("Thzin_BrainMark") then
				local bill = Instance.new("BillboardGui", d)
				bill.Name = "Thzin_BrainMark"
				bill.Size = UDim2.new(0, 50, 0, 50)
				bill.AlwaysOnTop = true

				local lbl = Instance.new("TextLabel", bill)
				lbl.Size = UDim2.new(1,0,1,0)
				lbl.BackgroundTransparency = 1
				lbl.Text = "❗"
				lbl.TextScaled = true
				lbl.TextColor3 = Color3.fromRGB(255,50,50)
				lbl.Font = Enum.Font.GothamBold
			end
		end
	end
end

local BrainBtn = createButton("Marcar Brainrot Secret", 0.64)
BrainBtn.MouseButton1Click:Connect(function()
	if not AccessGranted then return end
	markBrainrots()
	BrainBtn.Text = "Brainrots Marcados ✔"
end)

-- Radar Neon (HUD markers)
local RadarFolder = Instance.new("Folder", ScreenGui)
RadarFolder.Name = "Thzin_Radar"

local RadarEnabled = false
local RadarBtn = createButton("Radar Neon (ON/OFF)", 0.76)

local function createPlayerMarker(plr)
	if plr == LocalPlayer then return end
	if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end

	-- Avoid duplicates
	if RadarFolder:FindFirstChild(plr.Name .. "_marker") then return end

	local marker = Instance.new("BillboardGui")
	marker.Name = plr.Name .. "_marker"
	marker.Adornee = plr.Character:FindFirstChild("HumanoidRootPart")
	marker.Size = UDim2.new(0, 130, 0, 40)
	marker.AlwaysOnTop = true
	marker.Parent = RadarFolder

	local bg = Instance.new("Frame", marker)
	bg.Size = UDim2.new(1,0,1,0)
	bg.BackgroundTransparency = 0.4
	bg.BackgroundColor3 = Color3.fromRGB(0, 120, 230)
	makeUICorner(bg, 20)

	local nameLabel = Instance.new("TextLabel", bg)
	nameLabel.Size = UDim2.new(1, -8, 0, 18)
	nameLabel.Position = UDim2.new(0,4,0,2)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = plr.Name
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 14
	nameLabel.TextColor3 = Color3.fromRGB(220,255,255)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left

	local distLabel = Instance.new("TextLabel", bg)
	distLabel.Size = UDim2.new(1, -8, 0, 18)
	distLabel.Position = UDim2.new(0,4,0,20)
	distLabel.BackgroundTransparency = 1
	distLabel.Text = "0m"
	distLabel.Font = Enum.Font.GothamBold
	distLabel.TextSize = 14
	distLabel.TextColor3 = Color3.fromRGB(180,235,255)
	distLabel.TextXAlignment = Enum.TextXAlignment.Left

	-- update loop connector (use RenderStepped limited list)
	local conn
	conn = RunService.RenderStepped:Connect(function()
		if not plr.Parent or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
			if conn then conn:Disconnect() end
			if marker then marker:Destroy() end
			return
		end
		local myhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if myhrp then
			local dist = (myhrp.Position - plr.Character.HumanoidRootPart.Position).Magnitude
			distLabel.Text = tostring(math.floor(dist)) .. "m"
		end
	end)
end

RadarBtn.MouseButton1Click:Connect(function()
	if not AccessGranted then return end
	RadarEnabled = not RadarEnabled
	if RadarEnabled then
		RadarBtn.Text = "Radar: ON ✔"
		-- create markers for all players
		for _, plr in pairs(Players:GetPlayers()) do
			pcall(function() createPlayerMarker(plr) end)
		end
	else
		RadarBtn.Text = "Radar: OFF"
		-- clear markers
		for _, child in pairs(RadarFolder:GetChildren()) do
			child:Destroy()
		end
	end
end)

-- Maintain markers when players join
Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		if RadarEnabled then
			pcall(function() createPlayerMarker(plr) end)
		end
	end)
end)

-- Simple ESP toggle (adds small head label for each player)
local ESPEnabled = false
local ESPBtn = createButton("ESP Players (ON/OFF)", 0.88)
local function createESPFor(plr)
	if plr == LocalPlayer then return end
	if not plr.Character or not plr.Character:FindFirstChild("Head") then return end
	if plr.Character.Head:FindFirstChild("Thzin_ESP") then return end

	local bill = Instance.new("BillboardGui", plr.Character.Head)
	bill.Name = "Thzin_ESP"
	bill.Size = UDim2.new(0,120,0,35)
	bill.AlwaysOnTop = true
	local lab = Instance.new("TextLabel", bill)
	lab.Size = UDim2.new(1,0,1,0)
	lab.BackgroundTransparency = 1
	lab.Text = plr.Name
	lab.Font = Enum.Font.GothamBold
	lab.TextSize = 14
	lab.TextColor3 = Color3.fromRGB(0,255,255)
end

local function removeESPFor(plr)
	if plr.Character and plr.Character:FindFirstChild("Head") then
		local bill = plr.Character.Head:FindFirstChild("Thzin_ESP")
		if bill then bill:Destroy() end
	end
end

ESPBtn.MouseButton1Click:Connect(function()
	if not AccessGranted then return end
	ESPEnabled = not ESPEnabled
	if ESPEnabled then
		ESPBtn.Text = "ESP: ON ✔"
		for _, plr in pairs(Players:GetPlayers()) do
			pcall(function() createESPFor(plr) end)
		end
	else
		ESPBtn.Text = "ESP: OFF"
		for _, plr in pairs(Players:GetPlayers()) do
			pcall(function() removeESPFor(plr) end)
		end
	end
end)

-- Clean up markers when players leave
Players.PlayerRemoving:Connect(function(plr)
	if RadarFolder:FindFirstChild(plr.Name .. "_marker") then
		RadarFolder[plr.Name .. "_marker"]:Destroy()
	end
end)

-- Key hint: open menu with L too
UIS.InputBegan:Connect(function(inp, gpe)
	if gpe then return end
	if inp.KeyCode == Enum.KeyCode.L then
		Toggle:Activate()
	end
end)

-- Final: initial instructions label
local Info = Instance.new("TextLabel", Main)
Info.Size = UDim2.new(0.9, 0, 0, 30)
Info.Position = UDim2.new(0.05, 0, 0.02, 0)
Info.BackgroundTransparency = 1
Info.Text = "Use a key para liberar. Pressione L para abrir."
Info.Font = Enum.Font.GothamBold
Info.TextSize = 12
Info.TextColor3 = Color3.fromRGB(180,220,255)
Info.TextXAlignment = Enum.TextXAlignment.Left

-- Safety: ensure script doesn't run features before key is validated
-- (All buttons check AccessGranted before performing actions.)

-- END OF SCRIPT
