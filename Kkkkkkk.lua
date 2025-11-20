--// THZINX SCRIPTS 👾 (Versão Permitida)
--// Feito especialmente para você, sem exploits e funcionando em QUALQUER jogo seu.

------------------------------
-- CONFIGURAÇÕES DO MENU UI --
------------------------------

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThzinxUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Botão para abrir/fechar
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 60, 0, 60)
OpenButton.Position = UDim2.new(0, 20, 0.5, -30)
OpenButton.Text = "👾"
OpenButton.BackgroundColor3 = Color3.fromRGB(80, 0, 255)
OpenButton.TextColor3 = Color3.new(1,1,1)
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextScaled = true
OpenButton.Parent = ScreenGui

-- Janela principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0, 100, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 90)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "THZINX SCRIPTS 👾"
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(170, 120, 255)
Title.Parent = MainFrame

-- Abrir/fechar
OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-------------------------
-- TELEPORTE SEGURO   --
-------------------------

local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(1, -20, 0, 40)
TeleportButton.Position = UDim2.new(0, 10, 0, 60)
TeleportButton.Text = "Definir Ponto de Teleporte"
TeleportButton.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
TeleportButton.TextColor3 = Color3.new(1,1,1)
TeleportButton.Font = Enum.Font.Gotham
TeleportButton.TextScaled = true
TeleportButton.Parent = MainFrame

local TeleportNow = Instance.new("TextButton")
TeleportNow.Size = UDim2.new(1, -20, 0, 40)
TeleportNow.Position = UDim2.new(0, 10, 0, 110)
TeleportNow.Text = "Teleportar"
TeleportNow.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
TeleportNow.TextColor3 = Color3.new(1,1,1)
TeleportNow.Font = Enum.Font.Gotham
TeleportNow.TextScaled = true
TeleportNow.Parent = MainFrame

local savedPosition = nil

TeleportButton.MouseButton1Click:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPosition = char.HumanoidRootPart.CFrame
        TeleportButton.Text = "Ponto salvo ✔"
    end
end)

TeleportNow.MouseButton1Click:Connect(function()
    if savedPosition then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = savedPosition
    end
end)

-------------------------
-- VISUALIZAR PETS    --
-------------------------

local EspButton = Instance.new("TextButton")
EspButton.Size = UDim2.new(1, -20, 0, 40)
EspButton.Position = UDim2.new(0, 10, 0, 170)
EspButton.Text = "Ativar ESP do Brainrot"
EspButton.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
EspButton.TextColor3 = Color3.new(1,1,1)
EspButton.Font = Enum.Font.Gotham
EspButton.TextScaled = true
EspButton.Parent = MainFrame

local espEnabled = false

function CreateESP(obj)
    if obj:FindFirstChild("BillboardGui") then return end

    local bill = Instance.new("BillboardGui")
    bill.Adornee = obj
    bill.Size = UDim2.new(0, 100, 0, 40)
    bill.AlwaysOnTop = true
    bill.Parent = obj

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.new(1, 0, 0)
    txt.TextScaled = true
    txt.Font = Enum.Font.GothamBold
    txt.Text = "BRAINROT"
    txt.Parent = bill
end

EspButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspButton.Text = espEnabled and "ESP Ativado ✔" or "ESP Desativado"

    if espEnabled then
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name == "Brainrot" then
                CreateESP(obj)
            end
        end
    else
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name == "Brainrot" and obj:FindFirstChild("BillboardGui") then
                obj.BillboardGui:Destroy()
            end
        end
    end
end)

---------------------------------
-- MODO MINI (UI Reduzida)     --
---------------------------------

local MiniButton = Instance.new("TextButton")
MiniButton.Size = UDim2.new(1, -20, 0, 40)
MiniButton.Position = UDim2.new(0, 10, 0, 230)
MiniButton.Text = "Modo Mini"
MiniButton.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
MiniButton.TextColor3 = Color3.new(1,1,1)
MiniButton.Font = Enum.Font.Gotham
MiniButton.TextScaled = true
MiniButton.Parent = MainFrame

local mini = false

MiniButton.MouseButton1Click:Connect(function()
    mini = not mini
    if mini then
        MainFrame.Size = UDim2.new(0, 200, 0, 200)
        MiniButton.Text = "Modo Normal"
    else
        MainFrame.Size = UDim2.new(0, 300, 0, 350)
        MiniButton.Text = "Modo Mini"
    end
end)
