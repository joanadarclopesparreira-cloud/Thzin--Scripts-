-- Thzinx Scripts v3 🔧 versão melhorada com NoClip + Modo Formiga + Teleporte Cooldown
-- Key: "thzin-scripts"

local KEY = "thzin-scripts"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Função helper para instanciar
local function new(class, props)
    local obj = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            obj[k] = v
        end
    end
    return obj
end

-- GUI raiz
local screen = new("ScreenGui", {Parent = PlayerGui, Name = "ThzinxGUI", ResetOnSpawn = false})

-- Loader / tela de Key
local loader = new("Frame", {Parent = screen, Size = UDim2.new(0,380,0,220), Position = UDim2.new(0.5,-190,0.5,-110), BackgroundColor3 = Color3.fromRGB(18,12,28)})
new("UICorner", {Parent = loader, CornerRadius = UDim.new(0,12)})
local title = new("TextLabel", {Parent = loader, Size = UDim2.new(1,0,0,48), BackgroundTransparency = 1, Text = "Thzinx Scripts 👾", Font = Enum.Font.GothamBold, TextSize = 22, TextColor3 = Color3.fromRGB(245,245,255)})
local info = new("TextLabel", {Parent = loader, Size = UDim2.new(1,-24,0,20), Position = UDim2.new(0,12,0,52), BackgroundTransparency = 1, Text = "Digite a key para liberar o script", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(180,200,230), TextXAlignment = Enum.TextXAlignment.Left})
local keyBox = new("TextBox", {Parent = loader, Size = UDim2.new(0.88,0,0,40), Position = UDim2.new(0.06,0,0.4,0), PlaceholderText = "Digite a key...", Font = Enum.Font.Gotham, TextSize = 16, BackgroundColor3 = Color3.fromRGB(32,26,44), TextColor3 = Color3.fromRGB(240,240,240)})
new("UICorner", {Parent = keyBox, CornerRadius = UDim.new(0,8)})
local keyBtn = new("TextButton", {Parent = loader, Size = UDim2.new(0.88,0,0,42), Position = UDim2.new(0.06,0,0.72,0), Text = "CONFIRMAR", Font = Enum.Font.GothamBold, TextSize = 16, BackgroundColor3 = Color3.fromRGB(40,110,255), TextColor3 = Color3.fromRGB(255,255,255)})
new("UICorner", {Parent = keyBtn, CornerRadius = UDim.new(0,8)})

-- Ícone flutuante
local floatIcon = new("ImageButton", {Parent = screen, Name = "ThzinxIcon", Size = UDim2.new(0,88,0,88), Position = UDim2.new(0.03,0,0.35,0), BackgroundTransparency = 1, AutoButtonColor = false})
-- fundo do ícone (círculo)
local bg = new("Frame", {Parent = floatIcon, Size = UDim2.new(1,0,1,0), Position = UDim2.new(0,0,0,0), BackgroundColor3 = Color3.fromRGB(18,20,36)})
new("UICorner", {Parent = bg, CornerRadius = UDim.new(1,0)})
-- gradiente neon azul
local grad = new("UIGradient", {Parent = bg, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(55,110,255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0,200,255))}})
grad.Rotation = 45
-- círculo interno para contraste
local inner = new("Frame", {Parent = bg, Size = UDim2.new(0.86,0,0.86,0), Position = UDim2.new(0.07,0,0.07,0), BackgroundColor3 = Color3.fromRGB(12,8,20)})
new("UICorner", {Parent = inner, CornerRadius = UDim.new(1,0)})
-- texto no ícone
local iconText = new("TextLabel", {Parent = floatIcon, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "Thzinx\nScripts 👾", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.fromRGB(245,245,255)})
iconText.TextScaled = true

floatIcon.Visible = false

-- lógica de drag para o ícone
do
    local dragging = false
    local dragStart = Vector2.new()
    local startPos = floatIcon.Position
    floatIcon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = floatIcon.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            floatIcon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Painel principal
local main = new("Frame", {Parent = screen, Name = "ThzinxMain", Size = UDim2.new(0,460,0,520), Position = UDim2.new(0.5,-230,0.5,-260), BackgroundColor3 = Color3.fromRGB(12,6,18)})
new("UICorner", {Parent = main, CornerRadius = UDim.new(0,14)})
main.Visible = false

-- Cabeçalho + botão fechar
local header = new("Frame", {Parent = main, Size = UDim2.new(1,0,0,60), BackgroundTransparency = 1})
local headerTitle = new("TextLabel", {Parent = header, Size = UDim2.new(1,0,0,60), BackgroundTransparency = 1, Text = "THZINX SCRIPTS 👾", Font = Enum.Font.GothamBold, TextSize = 20, TextColor3 = Color3.fromRGB(245,245,245), TextXAlignment = Enum.TextXAlignment.Left})
headerTitle.Position = UDim2.new(0,14,0,12)
local closeBtn = new("TextButton", {Parent = header, Size = UDim2.new(0,36,0,36), Position = UDim2.new(1,-52,0,12), Text = "✕", Font = Enum.Font.GothamBold, TextColor3 = Color3.fromRGB(255,255,255), BackgroundColor3 = Color3.fromRGB(180,30,90)})
new("UICorner", {Parent = closeBtn, CornerRadius = UDim.new(0,8)})
closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
end)

-- Área de scroll para botões
local scroll = new("ScrollingFrame", {Parent = main, Size = UDim2.new(1,-24,1,-100), Position = UDim2.new(0,12,0,70), BackgroundTransparency = 1, CanvasSize = UDim2.new(0,0,2,0)})
scroll.ScrollBarThickness = 6

-- Função para criar botões no menu
local function createButton(text, ypos)
    local b = new("TextButton", {Parent = scroll, Size = UDim2.new(0.96,0,0,44), Position = UDim2.new(0.02,0,ypos,0), Text = text, Font = Enum.Font.GothamBold, TextSize = 16, BackgroundColor3 = Color3.fromRGB(60,12,110), TextColor3 = Color3.fromRGB(240,240,255)})
    new("UICorner", {Parent = b, CornerRadius = UDim.new(0,8)})
    return b
end

-- Botões de função
local btnSave = createButton("Salvar Localização", 0)
local btnTeleport = createButton("Teletransportar + Cooldown 3s", 0.08)
local btnNoClip = createButton("NoClip (ON/OFF)", 0.16)
local btnAntFormiga = createButton("Modo Formiga (auto com Brainrot)", 0.24)
local btnESP = createButton("ESP Bases / Pets", 0.32)
local btnRadar = createButton("Radar Players", 0.40)
local btnAntiTurret = createButton("Anti-Torreta", 0.48)
local btnAutoInv = createButton("Auto Invisível com Brainrot", 0.56)
local btnReset = createButton("Resetar marcadores", 0.64)

local statusLabel = new("TextLabel", {Parent = main, Size = UDim2.new(1,0,0,20), Position = UDim2.new(0,0,1,-28), BackgroundTransparency = 1, Text = "", TextColor3 = Color3.fromRGB(200,200,200), Font = Enum.Font.Gotham, TextSize = 14})

-- ===== LÓGICA DAS FUNÇÕES =====

-- Teleporte: marcar posição
local savedCFrame = nil
btnSave.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            savedCFrame = hrp.CFrame
            statusLabel.Text = "Localização salva ✅"
        end
    end
end)

-- Teleporte com cooldown de 3s e volta
local tpCooldown = false
btnTeleport.MouseButton1Click:Connect(function()
    if tpCooldown then return end
    if not savedCFrame then
        statusLabel.Text = "Não marcou localização!"
        return
    end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    tpCooldown = true

    local originalCFrame = hrp.CFrame
    hrp.CFrame = savedCFrame
    statusLabel.Text = "Teleportou! Esperando 3s..."

    task.wait(3)

    -- volta para original
    hrp.CFrame = originalCFrame
    statusLabel.Text = "Voltou para a onde estava!"
    tpCooldown = false
end)

-- NoClip (atravessar paredes)
local noclipOn = false
btnNoClip.MouseButton1Click:Connect(function()
    noclipOn = not noclipOn
    statusLabel.Text = noclipOn and "NoClip ON" or "NoClip OFF"
    local function setCollision(state)
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = state
            end
        end
    end
    if noclipOn then
        setCollision(false)
    else
        setCollision(true)
    end
end)

-- Modo formiga automático ao pegar Brainrot
-- Quando detectar objeto no backpack ou na character com “brain” no nome, muda o tamanho
local antFormigaOn = false
local originalSize = nil

btnAntFormiga.MouseButton1Click:Connect(function()
    antFormigaOn = not antFormigaOn
    statusLabel.Text = antFormigaOn and "Modo Formiga ON" or "Modo Formiga OFF"
end)

-- Função que verifica e ajusta tamanho
local function checkFormiga()
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local inBackpack = false
    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
        if string.find(string.lower(item.Name), "brain") then
            inBackpack = true
            break
        end
    end
    local inChar = false
    for _, desc in pairs(char:GetDescendants()) do
        if string.find(string.lower(desc.Name), "brain") then
            inChar = true
            break
        end
    end

    if antFormigaOn and (inBackpack or inChar) then
        -- liga o modo formiga
        if humanoid.HipHeight then
            originalSize = humanoid.HipHeight
        end
        humanoid:Resize(0.2) -- reduz bastante
        -- reduz partes visuais também
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.Size = part.Size * 0.2
            end
        end
        statusLabel.Text = "Você ficou formiga!"
    else
        -- restaura tamanho
        if originalSize then
            humanoid:Resize(originalSize)
        end
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.Size = part.Size / 0.2
            end
        end
        statusLabel.Text = "Tamanho normal restaurado"
    end
end

-- Monitorar mudança (loop)
RunService.Heartbeat:Connect(function()
    checkFormiga()
end)

-- ESP bases/pets
local espOn = false
local espObjs = {}
local function clearESP()
    for _, gui in pairs(espObjs) do
        pcall(function() gui:Destroy() end)
    end
    espObjs = {}
end

btnESP.MouseButton1Click:Connect(function()
    espOn = not espOn
    if not espOn then
        clearESP()
        statusLabel.Text = "ESP OFF"
    else
        statusLabel.Text = "ESP ON"
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (string.find(string.lower(obj.Name), "base") or string.find(string.lower(obj.Name), "pet")) then
                local bill = new("BillboardGui", obj)
                bill.Name = "ThzinxTag"
                bill.Adornee = obj
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0,120,0,40)
                local frame = new("Frame", {Parent = bill, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 0.45, BackgroundColor3 = Color3.fromRGB(0,120,180)})
                new("UICorner", {Parent = frame, CornerRadius = UDim.new(0,8)})
                local lbl = new("TextLabel", {Parent = frame, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = obj.Name, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(230,255,255)})
                table.insert(espObjs, bill)
            end
        end
    end
end)

-- Radar de players (distância)
local radarOn = false
local radarObjs = {}
local function clearRadar()
    for _, g in pairs(radarObjs) do
        pcall(function() g:Destroy() end)
    end
    radarObjs = {}
end

btnRadar.MouseButton1Click:Connect(function()
    radarOn = not radarOn
    if not radarOn then
        clearRadar()
        statusLabel.Text = "Radar OFF"
    else
        statusLabel.Text = "Radar ON"
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                local bill = new("BillboardGui", plr.Character.Head)
                bill.Name = "ThzinxRadar"
                bill.Adornee = plr.Character.Head
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0,160,0,48)
                local frame = new("Frame", {Parent = bill, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 0.45, BackgroundColor3 = Color3.fromRGB(0,100,180)})
                new("UICorner", {Parent = frame, CornerRadius = UDim.new(0,10)})
                local nameLabel = new("TextLabel", {Parent = frame, Size = UDim2.new(1,-8,0,20), Position = UDim2.new(0,4,0,2), BackgroundTransparency = 1, Text = plr.Name, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(240,255,255)})
                local distLabel = new("TextLabel", {Parent = frame, Size = UDim2.new(1,-8,0,18), Position = UDim2.new(0,4,0,22), BackgroundTransparency = 1, Text = "0m", Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Color3.fromRGB(200,230,255)})
                table.insert(radarObjs, bill)
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if radarOn then
        local myhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myhrp then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local head = plr.Character:FindFirstChild("Head")
                    if head then
                        for _, g in pairs(head:GetChildren()) do
                            if g.Name == "ThzinxRadar" and g:FindFirstChildOfClass("TextLabel") then
                                local lab = g:FindFirstChildOfClass("TextLabel")
                                local d = (myhrp.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                                lab.Text = plr.Name .. " - " .. tostring(math.floor(d)) .. " m"
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Anti-torreta
local antiOn = false
local antiTask = nil
btnAntiTurret.MouseButton1Click:Connect(function()
    antiOn = not antiOn
    if antiOn then
        statusLabel.Text = "Anti-Torreta ON"
        antiTask = task.spawn(function()
            while antiOn do
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and (string.find(string.lower(v.Name), "turret") or string.find(string.lower(v.Name), "torreta")) then
                        pcall(function() v:Destroy() end)
                    end
                end
                task.wait(1)
            end
        end)
    else
        statusLabel.Text = "Anti-Torreta OFF"
        antiTask = nil
    end
end)

-- Auto invisível ao pegar brainrot (redundância com mode formiga, mas separado)
local autoInv = false
local autoTask2 = nil
btnAutoInv.MouseButton1Click:Connect(function()
    autoInv = not autoInv
    if autoInv then
        statusLabel.Text = "Auto Invisível ON"
        autoTask2 = task.spawn(function()
            while autoInv do
                local found = false
                for _, it in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if string.find(string.lower(it.Name), "brain") then
                        found = true
                        break
                    end
                end
                if not found and LocalPlayer.Character then
                    for _, d in pairs(LocalPlayer.Character:GetDescendants()) do
                        if string.find(string.lower(d.Name), "brain") then
                            found = true
                            break
                        end
                    end
                end
                if found then
                    -- invisível: desativa colisão e deixa transparente
                    local char = LocalPlayer.Character
                    if char then
                        for _, p in pairs(char:GetDescendants()) do
                            if p:IsA("BasePart") then
                                p.Transparency = 1
                            elseif p:IsA("Decal") then
                                p.Transparency = 1
                            end
                        end
                        statusLabel.Text = "Invisível (Brainrot)"
                    end
                end
                task.wait(0.3)
            end
        end)
    else
        statusLabel.Text = "Auto Invisível OFF"
        autoTask2 = nil
    end
end)

-- Reset geral
btnReset.MouseButton1Click:Connect(function()
    statusLabel.Text = "Resetando..."
    clearESP()
    clearRadar()
    antiOn = false
    autoInv = false
    antFormigaOn = false
    -- restaurar NoClip
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    statusLabel.Text = "Reset completo!"
end)

-- Key confirm & mostrar ícone
keyBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == KEY then
        keyBtn.Text = "ACESSO ✅"
        keyBtn.BackgroundColor3 = Color3.fromRGB(0,200,120)
        task.wait(0.5)
        loader:Destroy()
        floatIcon.Visible = true
        main.Visible = false
        -- animação de surgimento do ícone
        floatIcon.Position = UDim2.new(0.03,0,0.5,0)
        TweenService:Create(floatIcon, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.03,0,0.35,0)}):Play()
    else
        keyBtn.Text = "KEY ERRADA ❌"
        keyBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
        task.wait(1)
        keyBtn.Text = "CONFIRMAR"
        keyBtn.BackgroundColor3 = Color3.fromRGB(40,110,255)
    end
end)

-- Toggle menu clicando no ícone
floatIcon.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- Atalho de teclado L para mostrar ícone / menu
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.L then
        floatIcon:Activate()
    end
end)

-- Garante que a GUI fique ativa se personagem reaparecer
LocalPlayer.CharacterAdded:Connect(function()
    screen.Parent = PlayerGui
end)

print("Thzinx Scripts v3 atualizado com NoClip + Modo Formiga + Teleporte (cooldown) carregado!")
