-- Thzin Premium - FIXED (key + buttons + teleporte seguro)
local KEY_REQUIRED = "123456"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ScreenGui em PlayerGui (seguro)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThzinPremiumGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Toggle button
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Name = "Thzin_Toggle"
ToggleButton.Size = UDim2.new(0,120,0,40)
ToggleButton.Position = UDim2.new(0,20,0.5,-20)
ToggleButton.Text = "Abrir Painel"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextScaled = true
ToggleButton.BackgroundColor3 = Color3.fromRGB(80,0,120)
ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
ToggleButton.AutoButtonColor = true
ToggleButton.Visible = true
ToggleButton.ZIndex = 10
local tbCorner = Instance.new("UICorner", ToggleButton); tbCorner.CornerRadius = UDim.new(0,8)

-- Main panel
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0,380,0,420)
MainFrame.Position = UDim2.new(0.5,-190,0.5,-210)
MainFrame.BackgroundColor3 = Color3.fromRGB(30,0,40)
MainFrame.Visible = false
local mfCorner = Instance.new("UICorner", MainFrame); mfCorner.CornerRadius = UDim.new(0,10)

-- Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1,0,0,50)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundTransparency = 1
Title.Text = "THZIN PREMIUM"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(255,255,255)

-- Key frame area (top)
local KeyBox = Instance.new("TextBox", MainFrame)
KeyBox.Size = UDim2.new(0.9,0,0,40)
KeyBox.Position = UDim2.new(0.05,0,0.12,0)
KeyBox.PlaceholderText = "Digite a Key..."
KeyBox.Text = ""
KeyBox.Font = Enum.Font.GothamBold
KeyBox.TextSize = 18
KeyBox.BackgroundColor3 = Color3.fromRGB(90,0,130)
local kbCorner = Instance.new("UICorner", KeyBox); kbCorner.CornerRadius = UDim.new(0,6)

local KeyBtn = Instance.new("TextButton", MainFrame)
KeyBtn.Size = UDim2.new(0.9,0,0,40)
KeyBtn.Position = UDim2.new(0.05,0,0.245,0)
KeyBtn.Text = "Confirmar Key"
KeyBtn.Font = Enum.Font.GothamBold
KeyBtn.TextSize = 18
KeyBtn.BackgroundColor3 = Color3.fromRGB(120,0,180)
local kbtnCorner = Instance.new("UICorner", KeyBtn); kbtnCorner.CornerRadius = UDim.new(0,6)

local AccessGranted = false
local debounceKey = false

KeyBtn.MouseButton1Click:Connect(function()
    if debounceKey then return end
    debounceKey = true
    if KeyBox.Text == KEY_REQUIRED then
        AccessGranted = true
        KeyBtn.Text = "Key OK ✔"
        KeyBtn.BackgroundColor3 = Color3.fromRGB(0,200,120)
        Title.Text = "Acesso liberado - Teste as opções"
    else
        KeyBtn.Text = "Key errada ❌"
        KeyBtn.BackgroundColor3 = Color3.fromRGB(200,60,60)
        Title.Text = "Key incorreta"
        task.delay(1.2, function()
            if not AccessGranted then
                KeyBtn.Text = "Confirmar Key"
                KeyBtn.BackgroundColor3 = Color3.fromRGB(120,0,180)
                Title.Text = "THZIN PREMIUM"
            end
        end)
    end
    debounceKey = false
end)

-- Buttons factory
local function createButton(text, ypos)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(0.9,0,0,40)
    b.Position = UDim2.new(0.05,0,ypos,0)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 18
    b.BackgroundColor3 = Color3.fromRGB(120,0,180)
    local c = Instance.new("UICorner", b); c.CornerRadius = UDim.new(0,6)
    return b
end

-- Save / Teleport (safe)
local savedPos = nil
local SaveBtn = createButton("Salvar Localização", 0.40)
local TeleportBtn = createButton("Ir para Localização", 0.52)

SaveBtn.MouseButton1Click:Connect(function()
    if not AccessGranted then Title.Text = "Valide a Key primeiro" return end
    local char = LocalPlayer.Character
    if not char then Title.Text = "Sem Character" return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then Title.Text = "Sem HumanoidRootPart" return end
    savedPos = hrp.CFrame
    Title.Text = "Localização salva ✔"
end)

TeleportBtn.MouseButton1Click:Connect(function()
    if not AccessGranted then Title.Text = "Valide a Key primeiro" return end
    if not savedPos then Title.Text = "Nenhuma posição salva" return end
    local char = LocalPlayer.Character
    if not char then Title.Text = "Sem Character" return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then Title.Text = "Sem HumanoidRootPart" return end

    -- Smooth teleport: several small lerps, clear velocity
    for i = 1, 12 do
        if not hrp.Parent then break end
        hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
        hrp.CFrame = hrp.CFrame:Lerp(savedPos, 0.25)
        task.wait(0.03)
    end
    hrp.CFrame = savedPos
    Title.Text = "Teletransportado ✔"
end)

-- Brainrot marker (safe)
local BrainBtn = createButton("Marcar Brainrots", 0.64)
BrainBtn.MouseButton1Click:Connect(function()
    if not AccessGranted then Title.Text = "Valide a Key primeiro" return end
    local count = 0
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("brain") then
            if not v:FindFirstChild("Thzin_Mark") then
                local bill = Instance.new("BillboardGui", v)
                bill.Name = "Thzin_Mark"
                bill.Size = UDim2.new(0,50,0,50)
                bill.AlwaysOnTop = true
                local label = Instance.new("TextLabel", bill)
                label.Size = UDim2.new(1,1,1,1)
                label.BackgroundTransparency = 1
                label.Text = "❗"
                label.TextScaled = true
                label.Font = Enum.Font.GothamBold
                label.TextColor3 = Color3.fromRGB(255,80,80)
                count = count + 1
            end
        end
    end
    Title.Text = "Brainrots marcados: "..tostring(count)
end)

-- Radar / ESP
local RadarFolder = Instance.new("Folder", ScreenGui)
RadarFolder.Name = "Thzin_RadarMarkers"
local RadarBtn = createButton("Toggle Radar (Todos Players)", 0.76)
local ESPBtn = createButton("Toggle ESP (Players)", 0.88)

local radarOn = false
local espOn = false

local function createRadarFor(plr)
    if plr == LocalPlayer then return end
    if RadarFolder:FindFirstChild(plr.Name.."_marker") then return end
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end

    local marker = Instance.new("BillboardGui")
    marker.Name = plr.Name.."_marker"
    marker.Adornee = plr.Character.HumanoidRootPart
    marker.Size = UDim2.new(0,120,0,40)
    marker.AlwaysOnTop = true
    marker.Parent = RadarFolder

    local frame = Instance.new("Frame", marker)
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundTransparency = 0.45
    frame.BackgroundColor3 = Color3.fromRGB(0,120,230)
    local c = Instance.new("UICorner", frame); c.CornerRadius = UDim.new(0,10)

    local name = Instance.new("TextLabel", frame)
    name.Size = UDim2.new(1,-6,0,20)
    name.Position = UDim2.new(0,3,0,2)
    name.BackgroundTransparency = 1
    name.Text = plr.Name
    name.Font = Enum.Font.GothamBold
    name.TextSize = 14
    name.TextColor3 = Color3.fromRGB(230,255,255)
    local dist = Instance.new("TextLabel", frame)
    dist.Size = UDim2.new(1,-6,0,18)
    dist.Position = UDim2.new(0,3,0,20)
    dist.BackgroundTransparency = 1
    dist.Text = "0m"
    dist.Font = Enum.Font.GothamBold
    dist.TextSize = 14
    dist.TextColor3 = Color3.fromRGB(180,235,255)

    -- update connection
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not plr.Parent or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
            if conn then conn:Disconnect() end
            if marker then marker:Destroy() end
            return
        end
        local myhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myhrp then
            local d = (myhrp.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            dist.Text = tostring(math.floor(d)) .. "m"
        end
    end)
end

local function removeAllRadar()
    for _,c in pairs(RadarFolder:GetChildren()) do c:Destroy() end
end

RadarBtn.MouseButton1Click:Connect(function()
    if not AccessGranted then Title.Text = "Valide a Key primeiro" return end
    radarOn = not radarOn
    if radarOn then
        Title.Text = "Radar: ON"
        for _,plr in pairs(Players:GetPlayers()) do pcall(function() createRadarFor(plr) end) end
    else
        Title.Text = "Radar: OFF"
        removeAllRadar()
    end
end)

ESPMarkers = {} -- track ESP label connections
ESPBtn.MouseButton1Click:Connect(function()
    if not AccessGranted then Title.Text = "Valide a Key primeiro" return end
    espOn = not espOn
    if espOn then
        Title.Text = "ESP: ON"
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                pcall(function()
                    if not plr.Character.Head:FindFirstChild("Thzin_ESP") then
                        local bill = Instance.new("BillboardGui", plr.Character.Head)
                        bill.Name = "Thzin_ESP"
                        bill.Size = UDim2.new(0,120,0,30)
                        bill.AlwaysOnTop = true
                        local lab = Instance.new("TextLabel", bill)
                        lab.Size = UDim2.new(1,0,1,0)
                        lab.BackgroundTransparency = 1
                        lab.Font = Enum.Font.GothamBold
                        lab.TextSize = 14
                        lab.TextColor3 = Color3.fromRGB(0,255,255)
                        lab.Text = plr.Name
                    end
                end)
            end
        end
    else
        Title.Text = "ESP: OFF"
        for _,plr in pairs(Players:GetPlayers()) do
            pcall(function()
                if plr.Character and plr.Character:FindFirstChild("Head") then
                    local gg = plr.Character.Head:FindFirstChild("Thzin_ESP")
                    if gg then gg:Destroy() end
                end
            end)
        end
    end
end)

-- maintain markers on join
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        if radarOn then pcall(function() createRadarFor(plr) end) end
        if espOn then pcall(function()
            if plr.Character and plr.Character:FindFirstChild("Head") and not plr.Character.Head:FindFirstChild("Thzin_ESP") then
                local bill = Instance.new("BillboardGui", plr.Character.Head)
                bill.Name = "Thzin_ESP"
                bill.Size = UDim2.new(0,120,0,30)
                bill.AlwaysOnTop = true
                local lab = Instance.new("TextLabel", bill)
                lab.Size = UDim2.new(1,0,1,0)
                lab.BackgroundTransparency = 1
                lab.Font = Enum.Font.GothamBold
                lab.TextSize = 14
                lab.TextColor3 = Color3.fromRGB(0,255,255)
                lab.Text = plr.Name
            end
        end) end
    end)
end)

-- cleanup on leaving
Players.PlayerRemoving:Connect(function(plr)
    pcall(function() if RadarFolder:FindFirstChild(plr.Name.."_marker") then RadarFolder[plr.Name.."_marker"]:Destroy() end end)
end)

-- Toggle with key L
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.L then
        ToggleButton:Activate()
    end
end)

-- end
