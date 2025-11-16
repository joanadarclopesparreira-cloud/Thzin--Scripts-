--========================================================--
-- Thzinx Scripts 👾  -  Versão Melhorada (com ícone temporário)
-- Key: thzin-scripts
-- Ícone temporário A: círculo azul neon escrito "Thzinx Scripts 👾"
-- Funcionalidades: Key loader, menu flutuante arrastável, salvar posição, teleporte suave,
-- invisibilidade toggle + auto-invis on pick, ESP bases/pets, radar players, anti-turret, reset.
-- Observação: tudo client-side; adaptações podem ser necessárias conforme seu jogo.
--========================================================--

local KEY = "thzin-scripts"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- tiny helper to create instances
local function new(class, props)
    local obj = Instance.new(class)
    if props then
        for k,v in pairs(props) do obj[k] = v end
    end
    return obj
end

-- root gui
local screen = new("ScreenGui", {Parent = PlayerGui, Name = "ThzinxGUI", ResetOnSpawn = false})

-- ---------------- Loader / KEY screen ----------------
local loader = new("Frame", {Parent = screen, Name = "Loader", Size = UDim2.new(0,380,0,220), Position = UDim2.new(0.5,-190,0.5,-110), BackgroundColor3 = Color3.fromRGB(18,12,28)})
new("UICorner", {Parent = loader, CornerRadius = UDim.new(0,12)})
local title = new("TextLabel", {Parent = loader, Size = UDim2.new(1,0,0,48), BackgroundTransparency = 1, Text = "Thzinx Scripts 👾", Font = Enum.Font.GothamBold, TextSize = 22, TextColor3 = Color3.fromRGB(245,245,255)})
local info = new("TextLabel", {Parent = loader, Size = UDim2.new(1,-24,0,20), Position = UDim2.new(0,12,0,52), BackgroundTransparency = 1, Text = "Digite a key para liberar o script", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(180,200,230), TextXAlignment = Enum.TextXAlignment.Left})
local keyBox = new("TextBox", {Parent = loader, Size = UDim2.new(0.88,0,0,40), Position = UDim2.new(0.06,0,0.4,0), PlaceholderText = "Digite a key...", Font = Enum.Font.Gotham, TextSize = 16, BackgroundColor3 = Color3.fromRGB(32,26,44), TextColor3 = Color3.fromRGB(240,240,240)})
new("UICorner", {Parent = keyBox, CornerRadius = UDim.new(0,8)})
local keyBtn = new("TextButton", {Parent = loader, Size = UDim2.new(0.88,0,0,42), Position = UDim2.new(0.06,0,0.72,0), Text = "CONFIRMAR", Font = Enum.Font.GothamBold, TextSize = 16, BackgroundColor3 = Color3.fromRGB(40,110,255), TextColor3 = Color3.fromRGB(255,255,255)})
new("UICorner", {Parent = keyBtn, CornerRadius = UDim.new(0,8)})

-- ---------------- Floating icon (TEMP IMAGE built from GUI) ----------------
local floatIcon = new("ImageButton", {Parent = screen, Name = "ThzinxIcon", Size = UDim2.new(0,88,0,88), Position = UDim2.new(0.03,0,0.35,0), BackgroundTransparency = 1, AutoButtonColor = false})
-- circular background (constructed)
local bg = new("Frame", {Parent = floatIcon, Size = UDim2.new(1,0,1,0), Position = UDim2.new(0,0,0,0), BackgroundColor3 = Color3.fromRGB(18,20,36)})
new("UICorner", {Parent = bg, CornerRadius = UDim.new(1,0)})
-- neon gradient overlay
local grad = new("UIGradient", {Parent = bg, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(55,110,255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0,200,255))}})
grad.Rotation = 45
-- inner circle for contrast
local inner = new("Frame", {Parent = bg, Size = UDim2.new(0.86,0,0.86,0), Position = UDim2.new(0.07,0,0.07,0), BackgroundColor3 = Color3.fromRGB(12,8,20), BackgroundTransparency = 0})
new("UICorner", {Parent = inner, CornerRadius = UDim.new(1,0)})
-- text over icon
local iconText = new("TextLabel", {Parent = floatIcon, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "Thzinx\nScripts 👾", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.fromRGB(245,245,255)})
iconText.TextScaled = true

floatIcon.Visible = false -- hidden until key correct

-- icon drag logic
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

-- ---------------- Main menu panel ----------------
local main = new("Frame", {Parent = screen, Name = "ThzinxMain", Size = UDim2.new(0,460,0,520), Position = UDim2.new(0.5,-230,0.5,-260), BackgroundColor3 = Color3.fromRGB(12,6,18)})
new("UICorner", {Parent = main, CornerRadius = UDim.new(0,14)})
main.Visible = false

-- header + close
local header = new("Frame", {Parent = main, Size = UDim2.new(1,0,0,60), BackgroundTransparency = 1})
local headerTitle = new("TextLabel", {Parent = header, Size = UDim2.new(1,0,0,60), BackgroundTransparency = 1, Text = "THZINX SCRIPTS 👾", Font = Enum.Font.GothamBold, TextSize = 20, TextColor3 = Color3.fromRGB(245,245,245), TextXAlignment = Enum.TextXAlignment.Left})
headerTitle.Position = UDim2.new(0,14,0,12)
local closeBtn = new("TextButton", {Parent = header, Size = UDim2.new(0,36,0,36), Position = UDim2.new(1,-52,0,12), Text = "✕", Font = Enum.Font.GothamBold, TextColor3 = Color3.fromRGB(255,255,255), BackgroundColor3 = Color3.fromRGB(180,30,90)})
new("UICorner", {Parent = closeBtn, CornerRadius = UDim.new(0,8)})
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)

-- scroll container for buttons
local scroll = new("ScrollingFrame", {Parent = main, Size = UDim2.new(1,-24,1,-100), Position = UDim2.new(0,12,0,70), BackgroundTransparency = 1, CanvasSize = UDim2.new(0,0,2,0)})
scroll.ScrollBarThickness = 6

-- helper to create buttons
local function createButton(text, ypos)
    local b = new("TextButton", {Parent = scroll, Size = UDim2.new(0.96,0,0,44), Position = UDim2.new(0.02,0,ypos,0), Text = text, Font = Enum.Font.GothamBold, TextSize = 16, BackgroundColor3 = Color3.fromRGB(60,12,110), TextColor3 = Color3.fromRGB(240,240,255)})
    new("UICorner", {Parent = b, CornerRadius = UDim.new(0,8)})
    return b
end

-- create all buttons (features)
local btnSave = createButton("Salvar Localização", 0)
local btnReturn = createButton("Voltar à Localização (instant)", 0.08)
local btnInvisToggle = createButton("Invisível ON/OFF", 0.16)
local btnEsp = createButton("ESP Bases / Pets", 0.24)
local btnRadar = createButton("Radar Players", 0.32)
local btnAntiTurret = createButton("Anti-Torreta (limpa partes)", 0.40)
local btnAutoInvPet = createButton("Auto Invisível ao pegar pet (brainrot)", 0.48)
local btnReset = createButton("Reset: Limpar marcadores", 0.56)

-- status bar
local statusLabel = new("TextLabel", {Parent = main, Size = UDim2.new(1,0,0,20), Position = UDim2.new(0,0,1,-28), BackgroundTransparency = 1, Text = "", TextColor3 = Color3.fromRGB(200,200,200), Font = Enum.Font.Gotham, TextSize = 14})

-- ---------------- Feature implementations ----------------

-- save position
local savedCFrame = nil
btnSave.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char then statusLabel.Text = "Sem personagem"; return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then statusLabel.Text = "Sem HumanoidRootPart"; return end
    savedCFrame = hrp.CFrame
    statusLabel.Text = "Localização salva ✔"
end)

-- return teleport (smooth then final)
btnReturn.MouseButton1Click:Connect(function()
    if not savedCFrame then statusLabel.Text = "Nenhuma posição salva"; return end
    local char = LocalPlayer.Character
    if not char then statusLabel.Text = "Sem personagem"; return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then statusLabel.Text = "Sem HumanoidRootPart"; return end

    -- smooth lerp (small steps) to avoid freeze
    local steps = 12
    for i = 1, steps do
        if not hrp.Parent then break end
        hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
        hrp.CFrame = hrp.CFrame:Lerp(savedCFrame, 0.28)
        task.wait(0.03)
    end
    hrp.CFrame = savedCFrame
    statusLabel.Text = "Teletransportado ✔"
end)

-- invis toggle (stores previous transparencies to restore)
local wasInvisible = false
local storedTrans = {}
local function makeInvisibleChar(char)
    storedTrans = {}
    for _,v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            storedTrans[v] = v.Transparency
            v.Transparency = 1
        elseif v:IsA("Decal") then
            storedTrans[v] = v.Transparency
            v.Transparency = 1
        end
    end
end
local function restoreVisibility()
    for obj,tran in pairs(storedTrans) do
        pcall(function() obj.Transparency = tran end)
    end
    storedTrans = {}
end

btnInvisToggle.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char then statusLabel.Text = "Sem personagem"; return end
    if not wasInvisible then
        makeInvisibleChar(char)
        wasInvisible = true
        statusLabel.Text = "Invisível ✔"
    else
        restoreVisibility()
        wasInvisible = false
        statusLabel.Text = "Visível ✔"
    end
end)

-- ESP bases/pets
local espOn = false
local espTags = {}
local function clearESP()
    for _,v in pairs(espTags) do pcall(function() v:Destroy() end) end
    espTags = {}
end

btnEsp.MouseButton1Click:Connect(function()
    espOn = not espOn
    if not espOn then
        clearESP()
        statusLabel.Text = "ESP OFF"
        return
    end
    statusLabel.Text = "ESP ON - marcando bases/pets"
    -- find likely bases/pets (heuristic: parts with 'base' or 'pet' in name)
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (string.match(string.lower(obj.Name),"base") or string.match(string.lower(obj.Name),"pet")) then
            if not obj:FindFirstChild("ThzinxTag") then
                local bill = new("BillboardGui", obj)
                bill.Name = "ThzinxTag"
                bill.Adornee = obj
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0,140,0,40)
                bill.MaxDistance = 999999
                local frame = new("Frame", bill)
                frame.Size = UDim2.new(1,0,1,0)
                frame.BackgroundTransparency = 0.45
                frame.BackgroundColor3 = Color3.fromRGB(0,120,180)
                new("UICorner", {Parent = frame, CornerRadius = UDim.new(0,8)})
                local label = new("TextLabel", {Parent = frame, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = obj.Name, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(230,255,255)})
                table.insert(espTags, bill)
            end
        end
    end
end)

-- radar players
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
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            if not plr.Character.Head:FindFirstChild("ThzinxRadar") then
                local bill = new("BillboardGui", plr.Character.Head)
                bill.Name = "ThzinxRadar"
                bill.Adornee = plr.Character.Head
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0,160,0,48)
                local frame = new("Frame", {Parent = bill, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 0.45, BackgroundColor3 = Color3.fromRGB(0,100,180)})
                new("UICorner", {Parent = frame, CornerRadius = UDim.new(0,10)})
                local nameLabel = new("TextLabel", {Parent = frame, Size = UDim2.new(1,-8,0,20), Position = UDim2.new(0,4,0,2), BackgroundTransparency = 1, Text = plr.Name, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(240,255,255)})
                local distLabel = new("TextLabel", {Parent = frame, Size = UDim2.new(1,-8,0,18), Position = UDim2.new(0,4,0,22), BackgroundTransparency = 1, Text = "0m", Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Color3.fromRGB(200,230,255)})
                table.insert(radarMarkers, bill)
            end
        end
    end
end)

-- update radar distances per frame
RunService.RenderStepped:Connect(function()
    if radarOn then
        local myhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myhrp then
            for _,plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local head = plr.Character:FindFirstChild("Head")
                    if head then
                        local g = head:FindFirstChild("ThzinxRadar")
                        if g then
                            local lab = g:FindFirstChildOfClass("TextLabel")
                            if lab then
                                local d = (myhrp.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                                lab.Text = plr.Name .. " - " .. tostring(math.floor(d)) .. "m"
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- anti-turret (destroy parts with 'turret' or 'torreta' in name) - use with caution
local antiTurret = false
local antiTask = nil
btnAntiTurret.MouseButton1Click:Connect(function()
    antiTurret = not antiTurret
    if antiTurret then
        statusLabel.Text = "Anti-torreta ON"
        antiTask = task.spawn(function()
            while antiTurret do
                for _,v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and (string.find(string.lower(v.Name),"turret") or string.find(string.lower(v.Name),"torreta")) then
                        pcall(function() v:Destroy() end)
                    end
                end
                task.wait(1)
            end
        end)
    else
        statusLabel.Text = "Anti-torreta OFF"
        antiTask = nil
    end
end)

-- auto invis on pick pet (search for 'brain' name in Backpack or Character)
local autoInv = false
local autoTask = nil
btnAutoInvPet.MouseButton1Click:Connect(function()
    autoInv = not autoInv
    if autoInv then
        statusLabel.Text = "AutoInvis ON"
        autoTask = task.spawn(function()
            while autoInv do
                local found = false
                for _,it in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if string.find(string.lower(it.Name),"brain") then found = true; break end
                end
                if not found and LocalPlayer.Character then
                    for _,it in pairs(LocalPlayer.Character:GetDescendants()) do
                        if string.find(string.lower(it.Name),"brain") then found = true; break end
                    end
                end
                if found then
                    if LocalPlayer.Character then
                        makeInvisibleChar(LocalPlayer.Character)
                        statusLabel.Text = "Auto invisível ativo (pegou pet)"
                    end
                end
                task.wait(0.25)
            end
        end)
    else
        statusLabel.Text = "AutoInvis OFF"
        autoTask = nil
    end
end)

-- Reset button clears created GUI and markers (client-side)
btnReset.MouseButton1Click:Connect(function()
    statusLabel.Text = "Resetando..."
    -- clear ESP tags
    clearESP()
    -- clear radar
    clearRadar()
    -- try remove any Thzinx created in workspace (safety: only Billboards added by this client)
    for _,v in pairs(workspace:GetDescendants()) do
        pcall(function()
            if v:IsA("BillboardGui") and (v.Name == "ThzinxTag" or v.Name == "ThzinxRadar" or v.Name == "ThzinTag" or v.Name == "ThzinRadar") then
                v:Destroy()
            end
        end)
    end
    statusLabel.Text = "Reset concluído"
end)

-- ---------------- Key logic & icon toggle ----------------
-- clicking floatIcon toggles main panel
floatIcon.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- Key confirm
keyBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == KEY then
        keyBtn.Text = "ACESSO ✔"
        keyBtn.BackgroundColor3 = Color3.fromRGB(0,200,120)
        task.wait(0.45)
        loader:Destroy()
        floatIcon.Visible = true
        main.Visible = false
        -- small icon spawn animation
        floatIcon.Position = UDim2.new(0.03,0,0.5,0)
        TweenService:Create(floatIcon, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.03,0,0.35,0)}):Play()
    else
        keyBtn.Text = "KEY INVÁLIDA ❌"
        keyBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
        task.wait(1)
        keyBtn.Text = "CONFIRMAR"
        keyBtn.BackgroundColor3 = Color3.fromRGB(40,110,255)
    end
end)

-- hotkey L to toggle icon (and menu)
UIS.InputBegan:Connect(function(inp, processed)
    if processed then return end
    if inp.KeyCode == Enum.KeyCode.L then
        floatIcon:Activate()
    end
end)

-- ensure GUI reparent on character added (safety)
LocalPlayer.CharacterAdded:Connect(function()
    screen.Parent = PlayerGui
end)

print("Thzinx Scripts v3 - improved (temp icon A) loaded.")
