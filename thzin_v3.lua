-- Thzinx Scripts 👾 - Safe Dev/Admin UI (Client-side)
-- Key: "thzin-scripts"
-- Uso: ferramenta de desenvolvimento / admin no seu próprio jogo.
-- NÃO inclui cheats contra jogadores (sem aimbot, sem auto-parry remotos, etc).

local KEY_REQUIRED = "thzin-scripts"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- helpers
local function uicorner(parent, radius) local c = Instance.new("UICorner", parent); c.CornerRadius = UDim.new(0, radius or 8); return c end
local function uistroke(parent, color, thickness) local s = Instance.new("UIStroke", parent); s.Color = color or Color3.fromRGB(100,200,255); s.Thickness = thickness or 1; return s end

-- Parent GUI
local screen = Instance.new("ScreenGui")
screen.Name = "ThzinxScriptsGui"
screen.Parent = PlayerGui
screen.ResetOnSpawn = false

-- Toggle button
local toggleBtn = Instance.new("TextButton", screen)
toggleBtn.Size = UDim2.new(0,56,0,56)
toggleBtn.Position = UDim2.new(0,14,0.5,-28)
toggleBtn.Text = "👾"
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 28
toggleBtn.BackgroundColor3 = Color3.fromRGB(30,130,200)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
uicorner(toggleBtn, 12)

-- Main Panel
local main = Instance.new("Frame", screen)
main.Size = UDim2.new(0,420,0,520)
main.Position = UDim2.new(0.5,-210,0.5,-260)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(18,20,28)
main.BackgroundTransparency = 0.15
main.Visible = false
uicorner(main, 14)
uistroke(main, Color3.fromRGB(80,170,255), 2)

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,-24,0,48)
title.Position = UDim2.new(0,12,0,8)
title.BackgroundTransparency = 1
title.Text = "Thzinx Scripts 👾"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(220,240,255)
title.TextXAlignment = Enum.TextXAlignment.Left

local info = Instance.new("TextLabel", main)
info.Size = UDim2.new(1,-24,0,20)
info.Position = UDim2.new(0,12,0,36)
info.BackgroundTransparency = 1
info.Text = "Digite a key para acessar"
info.Font = Enum.Font.Gotham
info.TextSize = 14
info.TextColor3 = Color3.fromRGB(170,200,230)
info.TextXAlignment = Enum.TextXAlignment.Left

-- Key input
local keyBox = Instance.new("TextBox", main)
keyBox.Size = UDim2.new(0.64,0,0,36)
keyBox.Position = UDim2.new(0.03,0,0.12,0)
keyBox.PlaceholderText = "Digite a key..."
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 16
keyBox.BackgroundColor3 = Color3.fromRGB(22,28,36)
uicorner(keyBox, 8)

local keyBtn = Instance.new("TextButton", main)
keyBtn.Size = UDim2.new(0.28,0,0,36)
keyBtn.Position = UDim2.new(0.69,0,0.12,0)
keyBtn.Text = "VALIDAR"
keyBtn.Font = Enum.Font.GothamBold
keyBtn.TextSize = 16
keyBtn.BackgroundColor3 = Color3.fromRGB(0,150,220)
uicorner(keyBtn, 8)

-- Glass area for buttons
local glass = Instance.new("Frame", main)
glass.Size = UDim2.new(1,-24,1,-120)
glass.Position = UDim2.new(0,12,0,76)
glass.BackgroundTransparency = 0.45
glass.BackgroundColor3 = Color3.fromRGB(10,12,16)
uicorner(glass, 12)

-- Buttons factory
local function createBtn(text, r,c)
    local b = Instance.new("TextButton", glass)
    b.Size = UDim2.new(0.46,0,0,36)
    local col = 0.03 + ( (c-1) * 0.48 )
    local row = 0.02 + ( (r-1) * 0.09 )
    b.Position = UDim2.new(col,0,row,0)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.BackgroundColor3 = Color3.fromRGB(20,26,34)
    uicorner(b, 8)
    uistroke(b, Color3.fromRGB(60,150,255), 1)
    return b
end

-- create buttons layout
local btn_save = createBtn("Salvar Localização", 1,1)
local btn_return = createBtn("Voltar para Localização", 1,2)
local btn_markBrains = createBtn("Marcar 'brains' (objetos)", 2,1)
local btn_radar = createBtn("Toggle Radar (objetos)", 2,2)
local btn_invisible = createBtn("Invisibilidade (local)", 3,1)
local btn_tele_invisible = createBtn("Teleporte Invisível (local)", 3,2)

-- states
local AccessGranted = false
local savedCFrame = nil
local markersFolder = Instance.new("Folder", workspace); markersFolder.Name = "ThzinxMarkers"
local radarOn = false

-- small UI feedback
local function setInfo(txt, time)
    info.Text = txt or ""
    if time and time>0 then
        delay(time, function()
            if AccessGranted then info.Text = "Funções liberadas" else info.Text = "Digite a key para acessar" end
        end)
    end
end

-- toggle main menu (with simple animation)
local menuOpen = false
local function animateOpen()
    main.Visible = true
    main.BackgroundTransparency = 1
    TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.15}):Play()
end
local function animateClose()
    TweenService:Create(main, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
    delay(0.18, function() main.Visible = false end)
end

toggleBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    if menuOpen then animateOpen() else animateClose() end
end)

UIS.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.L then
        toggleBtn:Activate()
    end
end)

-- Key validation
keyBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == KEY_REQUIRED then
        AccessGranted = true
        keyBtn.Text = "ACESSO ✔"
        keyBtn.BackgroundColor3 = Color3.fromRGB(0,200,120)
        setInfo("Key válida — funções liberadas", 2)
        -- auto open menu with animation
        animateOpen()
        menuOpen = true
    else
        keyBtn.Text = "ERRADO ❌"
        keyBtn.BackgroundColor3 = Color3.fromRGB(220,70,70)
        setInfo("Key inválida", 1.2)
        delay(1.2, function()
            if not AccessGranted then
                keyBtn.Text = "VALIDAR"
                keyBtn.BackgroundColor3 = Color3.fromRGB(0,150,220)
                setInfo("Digite a key para acessar")
            end
        end)
    end
end)

-- Save location (client-only)
btn_save.MouseButton1Click:Connect(function()
    if not AccessGranted then setInfo("Valide a key primeiro",2); return end
    local char = LocalPlayer.Character
    if not char then setInfo("Personagem não encontrado",2); return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then setInfo("HumanoidRootPart ausente",2); return end
    savedCFrame = hrp.CFrame
    setInfo("Localização salva ✔",2)
end)

-- Smooth teleport with animation overlay
local overlay = Instance.new("Frame", screen)
overlay.Size = UDim2.new(1,0,1,0)
overlay.BackgroundTransparency = 1
overlay.Visible = false

local overlayText = Instance.new("TextLabel", overlay)
overlayText.Size = UDim2.new(1,0,0,60)
overlayText.Position = UDim2.new(0,0,0.5,-30)
overlayText.BackgroundTransparency = 1
overlayText.Font = Enum.Font.GothamBold
overlayText.TextSize = 22
overlayText.TextColor3 = Color3.fromRGB(255,255,255)
overlayText.Text = ""

local function smoothTeleportTo(cframe)
    overlay.Visible = true
    overlay.BackgroundTransparency = 0.6
    overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    overlayText.Text = "Voltando para local..."
    local char = LocalPlayer.Character
    if not char then
        overlay.Visible = false
        setInfo("Personagem ausente",2)
        return
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then overlay.Visible = false; setInfo("HRP ausente",2); return end

    -- lerp in steps to saved CFrame
    local steps = 14
    for i = 1, steps do
        if not hrp.Parent then break end
        hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
        local a = i / steps
        hrp.CFrame = hrp.CFrame:Lerp(cframe, a)
        task.wait(0.03)
    end
    hrp.CFrame = cframe
    overlay.Visible = false
    setInfo("Teletransportado ✔", 2)
end

btn_return.MouseButton1Click:Connect(function()
    if not AccessGranted then setInfo("Valide a key primeiro",2); return end
    if not savedCFrame then setInfo("Nenhuma localização salva",2); return end
    -- call the smooth teleport (wrapped to not block)
    task.spawn(function() smoothTeleportTo(savedCFrame) end)
end)

-- Mark 'brain' objects (ESP for objects only)
local function markBrains()
    -- remove old
    for _,c in pairs(markersFolder:GetChildren()) do pcall(function() c:Destroy() end) end
    local found = 0
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and tostring(v.Name):lower():find("brain") then
            if not v:FindFirstChild("Thzinx_BrainMark") then
                local bill = Instance.new("BillboardGui", v)
                bill.Name = "Thzinx_BrainMark"
                bill.Size = UDim2.new(0,60,0,40)
                bill.Adornee = v
                bill.AlwaysOnTop = true
                bill.Parent = markersFolder
                local lbl = Instance.new("TextLabel", bill)
                lbl.Size = UDim2.new(1,0,1,0)
                lbl.BackgroundTransparency = 1
                lbl.Text = "❗ Brain"
                lbl.Font = Enum.Font.GothamBold
                lbl.TextSize = 14
                lbl.TextColor3 = Color3.fromRGB(255,120,80)
                found = found + 1
            end
        end
    end
    setInfo("Brain objects marcados: "..tostring(found), 3)
end

btn_markBrains.MouseButton1Click:Connect(function()
    if not AccessGranted then setInfo("Valide a key primeiro",2); return end
    markBrains()
end)

-- Radar: create simple distance labels for objects found (non-player)
local radarMarkers = {}
local function enableRadar()
    -- clear
    for _,m in pairs(radarMarkers) do pcall(function() m:Destroy() end) end
    radarMarkers = {}

    -- find interesting objects (e.g., named brain)
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and tostring(v.Name):lower():find("brain") then
            if v:FindFirstChildOfClass("Attachment") == nil then
                -- create a lightweight billboard for radar
                local gui = Instance.new("BillboardGui")
                gui.Size = UDim2.new(0,120,0,34)
                gui.Adornee = v
                gui.AlwaysOnTop = true
                gui.Parent = markersFolder
                local frame = Instance.new("Frame", gui)
                frame.Size = UDim2.new(1,0,1,0)
                frame.BackgroundTransparency = 0.6
                frame.BackgroundColor3 = Color3.fromRGB(0,120,200)
                uicorner(frame, 8)
                local txt = Instance.new("TextLabel", frame)
                txt.Size = UDim2.new(1,-8,1, -4)
                txt.Position = UDim2.new(0,4,0,2)
                txt.BackgroundTransparency = 1
                txt.Font = Enum.Font.Gotham
                txt.TextSize = 13
                txt.TextColor3 = Color3.fromRGB(240,255,255)
                txt.Text = v.Name.." • 0m"
                table.insert(radarMarkers, gui)

                -- update routine
                local conn
                conn = RunService.RenderStepped:Connect(function()
                    if not v.Parent then
                        if conn then conn:Disconnect() end
                        if gui and gui.Parent then gui:Destroy() end
                        return
                    end
                    local myhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if myhrp then
                        local d = (myhrp.Position - v.Position).Magnitude
                        txt.Text = v.Name.." • "..tostring(math.floor(d)).."m"
                    end
                end)
            end
        end
    end
end

local function disableRadar()
    for _,m in pairs(radarMarkers) do pcall(function() m:Destroy() end) end
    radarMarkers = {}
end

btn_radar.MouseButton1Click:Connect(function()
    if not AccessGranted then setInfo("Valide a key primeiro",2); return end
    radarOn = not radarOn
    if radarOn then
        enableRadar()
        setInfo("Radar ativado",2)
    else
        disableRadar()
        setInfo("Radar desativado",2)
    end
end)

-- Local invisibility toggle (client-only)
local invisibleOn = false
local function setLocalInvisibility(on)
    local char = LocalPlayer.Character
    if not char then setInfo("Sem personagem",2); return end
    for _,part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") or part:IsA("MeshPart") then
            if on then
                -- store original transparency in attribute
                if not part:GetAttribute("thzinx_orig_trans") then
                    part:SetAttribute("thzinx_orig_trans", part.Transparency or 0)
                end
                part.Transparency = 1
            else
                local orig = part:GetAttribute("thzinx_orig_trans")
                if orig then part.Transparency = orig; part:SetAttribute("thzinx_orig_trans", nil) end
            end
        end
    end
    invisibleOn = on
    setInfo("Invisibilidade local: "..(on and "ON" or "OFF"),2)
end

btn_invisible.MouseButton1Click:Connect(function()
    if not AccessGranted then setInfo("Valide a key primeiro",2); return end
    setLocalInvisibility(not invisibleOn)
end)

-- Teleporte invisível (smooth + local invis)
btn_tele_invisible.MouseButton1Click:Connect(function()
    if not AccessGranted then setInfo("Valide a key primeiro",2); return end
    if not savedCFrame then setInfo("Nenhuma posição salva",2); return end
    -- make invisible locally
    setLocalInvisibility(true)
    task.spawn(function() smoothTeleportTo(savedCFrame) end)
    -- restore invis off after short delay
    delay(1.0, function()
        setLocalInvisibility(false)
    end)
end)

-- cleanup on respawn: remove markers & radar
LocalPlayer.CharacterAdded:Connect(function(char)
    delay(0.5, function()
        -- remove client-side markers to avoid duplicates
        for _,c in pairs(markersFolder:GetChildren()) do pcall(function() c:Destroy() end) end
    end)
end)

-- initial animation when script is loaded (small entry animation)
do
    main.BackgroundTransparency = 1
    main.Visible = true
    main.Position = UDim2.new(0.5,-210,0.3,-260)
    TweenService:Create(main, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Position = UDim2.new(0.5,-210,0.5,-260), BackgroundTransparency = 0.15}):Play()
    delay(0.9, function()
        TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
        delay(0.28, function() main.Visible = false end)
    end)
end

-- show that script loaded
setInfo("Thzinx Scripts carregado. Digite a key para acessar", 4)
