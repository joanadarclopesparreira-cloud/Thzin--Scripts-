-- Thzin_Client (LocalScript em StarterPlayerScripts)
-- UI hacker-verde, teleporte cliente envia pedido ao servidor, ESP cliente, noclip cliente opcional

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local SafeTeleportEvent = ReplicatedStorage:WaitForChild("Thzin_SafeTeleport")
local RequestEvent = ReplicatedStorage:WaitForChild("Thzin_RequestAction")

-- Config cliente
local KEY = "thzin-scripts"
local CLIENT_TP_COOLDOWN = 3

local savedCFrame = nil
local tpCooldown = false
local noclipOn = false
local espOn = false
local radarOn = false

-- HUD root
local hud = Instance.new("ScreenGui", playerGui)
hud.Name = "ThzinxHUD"

-- helpers
local function new(class, props)
    local o = Instance.new(class)
    if props then for k,v in pairs(props) do o[k] = v end end
    return o
end

-- ---------- Key loader UI ----------
local loader = new("Frame", {Parent = hud, Size = UDim2.new(0,420,0,220), Position = UDim2.new(0.5,-210,0.5,-120), BackgroundColor3 = Color3.fromRGB(6,10,6)})
new("UICorner", {Parent = loader, CornerRadius = UDim.new(0,10)})
local title = new("TextLabel", {Parent = loader, Size = UDim2.new(1,0,0,48), BackgroundTransparency = 1, Text = "Thzinx Scripts 👾", Font = Enum.Font.GothamBold, TextSize = 22, TextColor3 = Color3.fromRGB(0,255,120)})
title.Position = UDim2.new(0,0,0,6)
local info = new("TextLabel", {Parent = loader, Size = UDim2.new(1,-24,0,20), Position = UDim2.new(0,12,0,52), BackgroundTransparency = 1, Text = "Digite a key para acessar", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(160,255,180)})
local keyBox = new("TextBox", {Parent = loader, Size = UDim2.new(0.88,0,0,36), Position = UDim2.new(0.06,0,0.46,0), PlaceholderText = "Key", Font = Enum.Font.Gotham, TextSize = 16, BackgroundColor3 = Color3.fromRGB(4,8,6), TextColor3 = Color3.fromRGB(0,255,140)})
new("UICorner", {Parent = keyBox, CornerRadius = UDim.new(0,6)})
local keyBtn = new("TextButton", {Parent = loader, Size = UDim2.new(0.88,0,0,40), Position = UDim2.new(0.06,0,0.76,0), Text = "CONFIRMAR", Font = Enum.Font.GothamBold, TextSize = 16, BackgroundColor3 = Color3.fromRGB(0,180,100)})
new("UICorner", {Parent = keyBtn, CornerRadius = UDim.new(0,6)})

-- floating icon
local floatBtn = new("ImageButton", {Parent = hud, Size = UDim2.new(0,80,0,80), Position = UDim2.new(0,12,0.45,0), BackgroundTransparency = 1, AutoButtonColor = false})
local floatBg = new("Frame", {Parent = floatBtn, Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(0,20,10)})
new("UICorner", {Parent = floatBg, CornerRadius = UDim.new(1,0)})
local floatLabel = new("TextLabel", {Parent = floatBtn, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "Thzinx\n👾", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(0,255,120)})
floatLabel.TextScaled = true
floatBtn.Visible = false

-- main menu
local main = new("Frame", {Parent = hud, Size = UDim2.new(0,460,0,520), Position = UDim2.new(0.5,-230,0.5,-260), BackgroundColor3 = Color3.fromRGB(6,10,6)})
new("UICorner", {Parent = main, CornerRadius = UDim.new(0,10)})
main.Visible = false
local status = new("TextLabel", {Parent = main, Size = UDim2.new(1,0,0,24), Position = UDim2.new(0,0,1,-28), BackgroundTransparency = 1, Text = "", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(180,255,170)})

-- buttons list
local container = new("ScrollingFrame", {Parent = main, Size = UDim2.new(1,-24,1,-100), Position = UDim2.new(0,12,0,64), BackgroundTransparency = 1})
container.CanvasSize = UDim2.new(0,0,2,0)
container.ScrollBarThickness = 6

local function createBtn(txt, ypos)
    local b = new("TextButton", {Parent = container, Size = UDim2.new(0.96,0,0,44), Position = UDim2.new(0.02,0,ypos,0), Text = txt, Font = Enum.Font.GothamBold, TextSize = 16, BackgroundColor3 = Color3.fromRGB(0,30,12), TextColor3 = Color3.fromRGB(0,255,140)})
    new("UICorner", {Parent = b, CornerRadius = UDim.new(0,6)})
    return b
end

local btnSave = createBtn("Salvar Localização", 0)
local btnTeleport = createBtn("Teletransportar (server)", 0.08)
local btnNoClip = createBtn("NoClip (cliente) ON/OFF", 0.16)
local btnFormiga = createBtn("Modo Formiga (server) ON/OFF", 0.24)
local btnESP = createBtn("Toggle ESP Bases/Pets", 0.32)
local btnRadar = createBtn("Toggle Radar Players", 0.40)
local btnAntiTurret = createBtn("Toggle Anti-Torreta (server)", 0.48)
local btnReset = createBtn("Resetar Tudo", 0.56)

-- drag floatBtn
do
    local dragging, startPos, dragStart = false, floatBtn.Position, Vector2.new()
    floatBtn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = inp.Position
            startPos = floatBtn.Position
            inp.Changed:Connect(function() if inp.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = inp.Position - dragStart
            floatBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- status helper
local function setStatus(txt) status.Text = txt end

-- Key validation
keyBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == KEY then
        keyBtn.Text = "ACESSO ✅"
        keyBtn.BackgroundColor3 = Color3.fromRGB(0,180,80)
        task.wait(0.2)
        loader:Destroy()
        floatBtn.Visible = true
        TweenService:Create(floatBtn, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0,12,0.35,0)}):Play()
    else
        keyBtn.Text = "KEY ERRADA ❌"
        keyBtn.BackgroundColor3 = Color3.fromRGB(120,20,20)
        task.wait(1)
        keyBtn.Text = "CONFIRMAR"
        keyBtn.BackgroundColor3 = Color3.fromRGB(0,180,100)
    end
end)

floatBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

-- Save pos
btnSave.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char then setStatus("Sem personagem"); return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then setStatus("Sem HRP"); return end
    savedCFrame = hrp.CFrame
    setStatus("Localização salva")
end)

-- Teleport (client requests server)
btnTeleport.MouseButton1Click:Connect(function()
    if tpCooldown then setStatus("Cooldown ativo"); return end
    if not savedCFrame then setStatus("Nenhuma localização salva"); return end
    SafeTeleportEvent:FireServer(savedCFrame)
    tpCooldown = true
    setStatus("Teleport solicitado (server).")
    task.delay(CLIENT_TP_COOLDOWN, function() tpCooldown = false; setStatus("Pronto") end)
end)

-- NoClip client toggle
btnNoClip.MouseButton1Click:Connect(function()
    noclipOn = not noclipOn
    setStatus(noclipOn and "NoClip ON" or "NoClip OFF")
end)

RunService.Stepped:Connect(function()
    if noclipOn and player.Character then
        for _,part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() part.CanCollide = false end)
            end
        end
    end
end)

-- Formiga toggle (client asks server to apply)
btnFormiga.MouseButton1Click:Connect(function()
    -- toggle server-side behavior
    RequestEvent:FireServer("SET_FORMIGA", true) -- para simplificar: liga; botão pode ser alternado por você com estado
    setStatus("Pedido enviado: SET_FORMIGA true")
end)

-- ESP (client-only)
local espGuis = {}
btnESP.MouseButton1Click:Connect(function()
    espOn = not espOn
    if not espOn then
        for _,g in pairs(espGuis) do pcall(function() g:Destroy() end) end
        espGuis = {}
        setStatus("ESP OFF")
    else
        setStatus("ESP ON")
        for _,obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (string.find(string.lower(obj.Name),"base") or string.find(string.lower(obj.Name),"pet")) then
                local bill = Instance.new("BillboardGui", obj)
                bill.Name = "ThzinxESP"
                bill.Adornee = obj
                bill.Size = UDim2.new(0,140,0,40)
                bill.AlwaysOnTop = true
                local frame = Instance.new("Frame", bill)
                frame.Size = UDim2.new(1,0,1,0); frame.BackgroundTransparency = 0.4; frame.BackgroundColor3 = Color3.fromRGB(0,80,60)
                local txt = Instance.new("TextLabel", frame)
                txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.Font = Enum.Font.GothamBold; txt.TextSize = 14; txt.TextColor3 = Color3.fromRGB(0,255,140)
                txt.Text = obj.Name
                table.insert(espGuis, bill)
            end
        end
    end
end)

-- Radar (client)
local radarGuis = {}
btnRadar.MouseButton1Click:Connect(function()
    radarOn = not radarOn
    if not radarOn then
        for _,g in pairs(radarGuis) do pcall(function() g:Destroy() end) end
        radarGuis = {}
        setStatus("Radar OFF")
    else
        setStatus("Radar ON")
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
                local bill = Instance.new("BillboardGui", plr.Character.Head)
                bill.Name = "ThzinxRadar"
                bill.Adornee = plr.Character.Head
                bill.Size = UDim2.new(0,160,0,48)
                bill.AlwaysOnTop = true
                local frame = Instance.new("Frame", bill)
                frame.Size = UDim2.new(1,0,1,0); frame.BackgroundTransparency = 0.45; frame.BackgroundColor3 = Color3.fromRGB(0,60,40)
                local label = Instance.new("TextLabel", frame)
                label.Size = UDim2.new(1,-8,0,18); label.Position = UDim2.new(0,4,0,2)
                label.BackgroundTransparency = 1; label.Font = Enum.Font.GothamBold; label.TextSize = 14; label.TextColor3 = Color3.fromRGB(0,255,140)
                label.Text = plr.Name
                table.insert(radarGuis, bill)
            end
        end
    end
end)

-- Anti-turret toggle (server attribute)
local antiTurretOn = false
btnAntiTurret.MouseButton1Click:Connect(function()
    antiTurretOn = not antiTurretOn
    RequestEvent:FireServer("ANTI_TURRET_TOGGLE", antiTurretOn)
    setStatus(antiTurretOn and "Anti-torreta ON" or "Anti-torreta OFF")
end)

-- Reset
btnReset.MouseButton1Click:Connect(function()
    RequestEvent:FireServer("SET_FORMIGA", false)
    RequestEvent:FireServer("ANTI_TURRET_TOGGLE", false)
    for _,g in pairs(espGuis) do pcall(function() g:Destroy() end) end
    for _,g in pairs(radarGuis) do pcall(function() g:Destroy() end) end
    espGuis = {}; radarGuis = {}
    noclipOn = false
    setStatus("Reset completo")
end)

-- ensure hud persists
player.CharacterAdded:Connect(function()
    hud.Parent = player:WaitForChild("PlayerGui")
end)

print("Thzin_Client pronto.")
