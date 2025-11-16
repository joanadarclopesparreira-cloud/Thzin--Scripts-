-- THZINX SCRIPTS V3 - Versão Melhorada (sem imagem externa)
-- Key: thzin-scripts
-- Ícone flutuante construído com GUI (redondo, arrastável, abre/fecha painel)

local KEY = "thzin-scripts"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Helper simples
local function new(class, props)
    local obj = Instance.new(class)
    if props then
        for k,v in pairs(props) do obj[k] = v end
    end
    return obj
end

-- Root GUI
local screen = new("ScreenGui", {Name = "ThzinxUI", ResetOnSpawn = false, Parent = PlayerGui})

-- =============== Loader / Tela de Key ===========
local loader = new("Frame", {Parent = screen, Size = UDim2.new(0,380,0,220), Position = UDim2.new(0.5,-190,0.5,-110), BackgroundColor3 = Color3.fromRGB(16,12,20)})
new("UICorner", {Parent = loader, CornerRadius = UDim.new(0,12)})
local title = new("TextLabel", {Parent = loader, Size = UDim2.new(1,0,0,48), BackgroundTransparency = 1, Text = "Thzinx Scripts 👾", Font = Enum.Font.GothamBold, TextSize = 22, TextColor3 = Color3.fromRGB(240,240,255), TextYAlignment = Enum.TextYAlignment.Center})
local info = new("TextLabel", {Parent = loader, Size = UDim2.new(1, -24, 0, 20), Position = UDim2.new(0,12,0,52), BackgroundTransparency = 1, Text = "Digite a key para liberar o script", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(180,200,230), TextXAlignment = Enum.TextXAlignment.Left})
local keyBox = new("TextBox", {Parent = loader, Size = UDim2.new(0.88,0,0,40), Position = UDim2.new(0.06,0,0.4,0), PlaceholderText = "Digite a key...", Font = Enum.Font.Gotham, TextSize = 16, BackgroundColor3 = Color3.fromRGB(28,24,36)})
new("UICorner", {Parent = keyBox, CornerRadius = UDim.new(0,8)})
local keyBtn = new("TextButton", {Parent = loader, Size = UDim2.new(0.88,0,0,42), Position = UDim2.new(0.06,0,0.7,0), Text = "CONFIRMAR", Font = Enum.Font.GothamBold, TextSize = 16, BackgroundColor3 = Color3.fromRGB(90,20,180)})
new("UICorner", {Parent = keyBtn, CornerRadius = UDim.new(0,8)})

-- =============== ÍCONE FLUTUANTE (construído por GUI) ===============
-- Usamos Frame + UIGradient + TextLabel para evitar imagem externa.
local floatIcon = new("ImageButton", {Parent = screen, Name = "ThzinIcon", Size = UDim2.new(0,88,0,88), Position = UDim2.new(0.03,0,0.35,0), BackgroundTransparency = 1, AutoButtonColor = false})
-- background circle
local bg = new("Frame", {Parent = floatIcon, Size = UDim2.new(1,0,1,0), Position = UDim2.new(0,0,0,0), BackgroundColor3 = Color3.fromRGB(18,10,30)})
new("UICorner", {Parent = bg, CornerRadius = UDim.new(1,0)})
-- gradient neon
local grad = new("UIGradient", {Parent = bg, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(100,0,200)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0,200,255))}})
grad.Rotation = 45
-- inner glow (frame)
local glow = new("Frame", {Parent = bg, Size = UDim2.new(0.9,0,0.9,0), Position = UDim2.new(0.05,0,0.05,0), BackgroundColor3 = Color3.fromRGB(30,10,45), BackgroundTransparency = 0.2})
new("UICorner", {Parent = glow, CornerRadius = UDim.new(1,0)})
-- text label
local iconText = new("TextLabel", {Parent = floatIcon, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "Thzinx\nScripts 👾", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.fromRGB(245,245,255), TextYAlignment = Enum.TextYAlignment.Center})
iconText.TextScaled = true

-- Initially hidden until key ok
floatIcon.Visible = false

-- make icon circular clickable area (already Frame + UICorner)
-- Dragging implementation
do
    local dragging = false
    local dragStart = Vector2.new()
    local startPos = UDim2.new()
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

-- =============== MAIN PANEL (menu) ===============
local main = new("Frame", {Parent = screen, Name = "ThzinMain", Size = UDim2.new(0,460,0,520), Position = UDim2.new(0.5,-230,0.5,-260), BackgroundColor3 = Color3.fromRGB(14,8,20)})
new("UICorner", {Parent = main, CornerRadius = UDim.new(0,14)})
main.Visible = false

local header = new("Frame", {Parent = main, Size = UDim2.new(1,0,0,60), BackgroundTransparency = 1})
local headerTitle = new("TextLabel", {Parent = header, Size = UDim2.new(1,0,0,60), BackgroundTransparency = 1, Text = "THZINX SCRIPTS 👾 - Premium", Font = Enum.Font.GothamBold, TextSize = 20, TextColor3 = Color3.fromRGB(240,240,255), TextXAlignment = Enum.TextXAlignment.Left})
headerTitle.Position = UDim2.new(0,14,0,12)

-- Close button
local closeBtn = new("TextButton", {Parent = header, Size = UDim2.new(0,36,0,36), Position = UDim2.new(1,-46,0,12), Text = "✕", BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(180,30,90), Font = Enum.Font.GothamBold, TextColor3 = Color3.fromRGB(255,255,255)})
new("UICorner", {Parent = closeBtn, CornerRadius = UDim.new(0,8)})

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
end)

-- Content scroll area
local scroll = new("ScrollingFrame", {Parent = main, Size = UDim2.new(1,-20,1,-80), Position = UDim2.new(0,10,0,70), CanvasSize = UDim2.new(0,0,2,0), BackgroundTransparency = 1})
scroll.ScrollBarThickness = 6

-- helper to create buttons inside panel
local function createButton(text, y)
    local b = new("TextButton", {Parent = scroll, Size = UDim2.new(0.96,0,0,44), Position = UDim2.new(0.02,0,y,0), Text = text, Font = Enum.Font.GothamBold, TextSize = 16, BackgroundColor3 = Color3.fromRGB(60,12,110), TextColor3 = Color3.fromRGB(240,240,255)})
    new("UICorner", {Parent = b, CornerRadius = UDim.new(0,8)})
    return b
end

-- We'll create the buttons for features
local btnSave = createButton("Salvar Localização", 0)
local btnReturn = createButton("Voltar à Localização (instant)", 0.08)
local btnInvisToggle = createButton("Invisível ON/OFF", 0.16)
local btnEsp = createButton("ESP Bases / Pets", 0.24)
local btnRadar = createButton("Radar Players", 0.32)
local btnAntiTurret = createButton("Anti-Torreta (limpa torretas)", 0.40)
local btnAutoInvPet = createButton("Auto Invisível ao pegar pet", 0.48)
local btnReset = createButton("Reset: Limpar marcadores", 0.56)

-- status label
local statusLabel = new("TextLabel", {Parent = main, Size = UDim2.new(1,0,0,20), Position = UDim2.new(0,0,1,-28), BackgroundTransparency = 1, Text = "", TextColor3 = Color3.fromRGB(200,200,200), Font = Enum.Font.Gotham, TextSize = 14})

-- =============== CORE FEATURES IMPLEMENTATION ===============

-- Save/Teleport storage
local savedCFrame = nil

btnSave.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char then statusLabel.Text = "Sem personagem" ; return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then statusLabel.Text = "Sem HumanoidRootPart" ; return end
    savedCFrame = hrp.CFrame
    statusLabel.Text = "Localização salva ✔"
end)

-- Smooth teleport instant but safe
btnReturn.MouseButton1Click:Connect(function()
    if not savedCFrame then statusLabel.Text = "Nenhuma posição salva" ; return end
    local char = LocalPlayer.Character
    if not char then statusLabel.Text = "Sem personagem" ; return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then statusLabel.Text = "Sem HumanoidRootPart" ; return end

    -- smooth lerp steps with small waits to avoid freezing
    local steps = 14
    for i = 1, steps do
        if not hrp.Parent then break end
        hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
        hrp.CFrame = hrp.CFrame:Lerp(savedCFrame, 0.28)
        task.wait(0.03)
    end
    hrp.CFrame = savedCFrame
    statusLabel.Text = "Teletransportado ✔"
end)

-- Invis toggle (restores previous transparency)
local wasInvisible = false
local savedTransparencies = {}

local function setCharacterTransparency(char, t)
    for _,v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = t
        elseif v:IsA("Decal") then
            v.Transparency = t
        end
    end
end

btnInvisToggle.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char then statusLabel.Text = "Sem personagem" ; return end
    if not wasInvisible then
        -- store old transparencies for restore
        savedTransparencies = {}
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                savedTransparencies[v] = v.Transparency
                v.Transparency = 1
            elseif v:IsA("Decal") then
                savedTransparencies[v] = v.Transparency
                v.Transparency = 1
            end
        end
        wasInvisible = true
        statusLabel.Text = "Invisível ✔"
    else
        for obj,tran in pairs(savedTransparencies) do
            pcall(function() obj.Transparency = tran end)
        end
        savedTransparencies = {}
        wasInvisible = false
        statusLabel.Text = "Visível ✔"
    end
end)

-- ESP (mark bases/pets)
local espOn = false
local espTags = {}

local function clearEsp()
    for _,v in pairs(espTags) do pcall(function() v:Destroy() end) end
    espTags = {}
end

btnEsp.MouseButton1Click:Connect(function()
    espOn = not espOn
    if not espOn then
        clearEsp()
        statusLabel.Text = "ESP OFF"
        return
    end
    statusLabel.Text = "ESP ON - marcando bases & pets"
    -- simple marking: search workspace for parts with 'base' or 'pet' in name
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (string.match(string.lower(obj.Name),"base") or string.match(string.lower(obj.Name),"pet")) then
            if not obj:FindFirstChild("ThzinTag") then
                local bill = new("BillboardGui", obj)
                bill.Name = "ThzinTag"
                bill.Adornee = obj
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0,120,0,40)
                bill.MaxDistance = 999999
                local frame = new("Frame", bill)
                frame.Size = UDim2.new(1,0,1,0)
                frame.BackgroundTransparency = 0.4
                frame.BackgroundColor3 = Color3.fromRGB(0,120,180)
                new("UICorner", {Parent = frame, CornerRadius = UDim.new(0,8)})
                local label = new("TextLabel", {Parent = frame, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = obj.Name, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(230,255,255)})
                table.insert(espTags, bill)
            end
        end
    end
end)

-- Radar players (simple distance labels)
local radarOn = false
local radarMarkers = {}

local function clearRadar()
    for _,m in pairs(radarMarkers) do pcall(function() m:Destroy() end) end
    radarMarkers = {}
end

btnRadar.MouseButton1Click:Connect(function()
    radarOn = not radarOn
    if not radarOn then
        clearRadar()
        statusLabel.Text = "Radar OFF"
        return
    end
    statusLabel.Text = "Radar ON"
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local head = plr.Character:FindFirstChild("Head")
            if head and not head:FindFirstChild("ThzinRadar") then
                local bill = new("BillboardGui", head)
                bill.Name = "ThzinRadar"
                bill.Adornee = head
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0,120,0,36)
                local txt = new("TextLabel", bill)
                txt.Size = UDim2.new(1,0,1,0)
                txt.BackgroundTransparency = 1
                txt.Font = Enum.Font.GothamBold
                txt.TextSize = 14
                txt.TextColor3 = Color3.fromRGB(0,240,255)
                table.insert(radarMarkers, bill)
            end
        end
    end
end)

-- update radar distances each frame if enabled
RunService.RenderStepped:Connect(function()
    if radarOn then
        local myhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myhrp then
            for _,p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local head = p.Character:FindFirstChild("Head")
                    if head then
                        local g = head:FindFirstChild("ThzinRadar")
                        if g then
                            local lab = g:FindFirstChildOfClass("TextLabel")
                            if lab then
                                local d = (myhrp.Position - p.Character.HumanoidRootPart.Position).Magnitude
                                lab.Text = p.Name .. " - " .. tostring(math.floor(d)) .. "m"
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Anti-turret: attempt to destroy parts named turret/torreta periodically
local antiTurret = false
local antiLoop = nil
btnAntiTurret.MouseButton1Click:Connect(function()
    antiTurret = not antiTurret
    if antiTurret then
        statusLabel.Text = "Anti-torreta ON"
        antiLoop = task.spawn(function()
            while antiTurret do
                for _,v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and (string.match(string.lower(v.Name),"turret") or string.match(string.lower(v.Name),"torreta")) then
                        pcall(function() v:Destroy() end)
                    end
                end
                task.wait(1)
            end
        end)
    else
        statusLabel.Text = "Anti-torreta OFF"
        if antiLoop then antiLoop = nil end
    end
end)

-- Auto invis on pick pet: monitors Backpack & Character for "brain" name
local autoInv = false
local autoLoop = nil
btnAutoInvPet.MouseButton1Click:Connect(function()
    autoInv = not autoInv
    if autoInv then
        statusLabel.Text = "AutoInvisible ON"
        autoLoop = task.spawn(function()
            while autoInv do
                -- check backpack and character for items named with 'brain'
                local found = false
                for _,it in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if string.match(string.lower(it.Name),"brain") then found = true; break end
                end
                if not found and LocalPlayer.Character then
                    for _,it in pairs(LocalPlayer.Character:GetDescendants()) do
                        if string.match(string.lower(it.Name),"brain") then found = true; break end
                    end
                end
                if found then
                    -- make player invisible client-side
                    if LocalPlayer.Character then
                        for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
                            if v:IsA("BasePart") then
                                pcall(function() v.Transparency = 1 end)
                            elseif v:IsA("Decal") then
                                pcall(function() v.Transparency = 1 end)
                            end
                        end
                        statusLabel.Text = "Auto invisível ativo (pegou pet)"
                    end
                end
                task.wait(0.25)
            end
        end)
    else
        statusLabel.Text = "AutoInvisible OFF"
        if autoLoop then autoLoop = nil end
    end
end)

-- Reset: clear all markers and GUI-created objects
btnReset.MouseButton1Click:Connect(function()
    statusLabel.Text = "Resetando..."
    -- clear esp tags
    clearEsp()
    -- clear radar
    clearRadar()
    -- try remove any Thzin objects in workspace
    for _,v in pairs(workspace:GetDescendants()) do
        if v.Name == "ThzinTag" or v.Name == "ThzinRadar" then
            pcall(function() v:Destroy() end)
        end
    end
    statusLabel.Text = "Reset concluído"
end)

-- =============== KEY / Toggle logic ===============
-- clicking float icon toggles menu
floatIcon.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- close button already wired

-- Key validation button
keyBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == KEY then
        -- confirm
        keyBtn.Text = "ACESSO ✔"
        keyBtn.BackgroundColor3 = Color3.fromRGB(0,200,120)
        task.wait(0.5)
        loader:Destroy()
        floatIcon.Visible = true
        main.Visible = false
        -- small spawn animation for icon
        floatIcon.Position = UDim2.new(0.03,0,0.5,0)
        TweenService:Create(floatIcon, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.03,0,0.35,0)}):Play()
    else
        keyBtn.Text = "KEY INCORRETA ❌"
        keyBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
        task.wait(1)
        keyBtn.Text = "CONFIRMAR"
        keyBtn.BackgroundColor3 = Color3.fromRGB(90,20,180)
    end
end)

-- Keyboard hotkey L to open icon
UIS.InputBegan:Connect(function(inp, processed)
    if processed then return end
    if inp.KeyCode == Enum.KeyCode.L then
        floatIcon:Activate()
    end
end)

-- safety: cleanup created gui on character removing/rejoining
LocalPlayer.CharacterAdded:Connect(function()
    -- ensure GUI remains
    screen.Parent = PlayerGui
end)

print("Thzinx Scripts v3 (improved) carregado.")
