--=============================
-- Thzinx Scripts 👾 - Roblox
-- Funções: Key, Teleporte Temporário, Mini Pet
--=============================

-- CONFIGURAÇÃO DA KEY
local KeyCorreta = "thzin-scripts" -- <<< SUA KEY DEFINITIVA

-- CRIAÇÃO DA UI
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoidRoot = char:WaitForChild("HumanoidRootPart")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThzinxScripts"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

--==========================
-- JANELA DE LOGIN
--==========================
local LoginFrame = Instance.new("Frame", ScreenGui)
LoginFrame.Size = UDim2.new(0, 300, 0, 200)
LoginFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
LoginFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local Titulo = Instance.new("TextLabel", LoginFrame)
Titulo.Size = UDim2.new(1, 0, 0, 40)
Titulo.Text = "Thzinx Scripts 👾"
Titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
Titulo.BackgroundTransparency = 1
Titulo.Font = Enum.Font.GothamBold
Titulo.TextScaled = true

local KeyBox = Instance.new("TextBox", LoginFrame)
KeyBox.PlaceholderText = "Digite a Key..."
KeyBox.Size = UDim2.new(1, -20, 0, 40)
KeyBox.Position = UDim2.new(0, 10, 0, 60)
KeyBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.Text = ""

local BotaoEntrar = Instance.new("TextButton", LoginFrame)
BotaoEntrar.Size = UDim2.new(1, -20, 0, 40)
BotaoEntrar.Position = UDim2.new(0, 10, 0, 110)
BotaoEntrar.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
BotaoEntrar.TextColor3 = Color3.fromRGB(255, 255, 255)
BotaoEntrar.Text = "Entrar"

--==========================
-- INTERFACE PRINCIPAL
--==========================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Visible = false

local TituloMain = Instance.new("TextLabel", MainFrame)
TituloMain.Size = UDim2.new(1, 0, 0, 40)
TituloMain.Text = "Thzinx Scripts 👾"
TituloMain.TextColor3 = Color3.fromRGB(255, 255, 255)
TituloMain.BackgroundTransparency = 1
TituloMain.Font = Enum.Font.GothamBold
TituloMain.TextScaled = true

--==========================
-- BOTÕES PRINCIPAIS
--==========================
local MarcarBotao = Instance.new("TextButton", MainFrame)
MarcarBotao.Size = UDim2.new(1, -20, 0, 40)
MarcarBotao.Position = UDim2.new(0, 10, 0, 50)
MarcarBotao.Text = "Marcar Localização"
MarcarBotao.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

local TeleportarBotao = Instance.new("TextButton", MainFrame)
TeleportarBotao.Size = UDim2.new(1, -20, 0, 40)
TeleportarBotao.Position = UDim2.new(0, 10, 0, 100)
TeleportarBotao.Text = "Teletransportar"
TeleportarBotao.BackgroundColor3 = Color3.fromRGB(0, 255, 120)

local MiniToggle = Instance.new("TextButton", MainFrame)
MiniToggle.Size = UDim2.new(1, -20, 0, 40)
MiniToggle.Position = UDim2.new(0, 10, 0, 150)
MiniToggle.Text = "Mini: OFF"
MiniToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)

--==========================
-- SISTEMA DE KEY
--==========================
BotaoEntrar.MouseButton1Click:Connect(function()
    if KeyBox.Text == KeyCorreta then
        LoginFrame:Destroy()
        MainFrame.Visible = true
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "KEY ERRADA!"
    end
end)

--==========================
-- TELEPORTE
--==========================
local tpLocal = nil

MarcarBotao.MouseButton1Click:Connect(function()
    tpLocal = humanoidRoot.Position
    MarcarBotao.Text = "Marcado!"
    task.wait(1)
    MarcarBotao.Text = "Marcar Localização"
end)

TeleportarBotao.MouseButton1Click:Connect(function()
    if not tpLocal then return end

    local posOriginal = humanoidRoot.Position
    humanoidRoot.CFrame = CFrame.new(tpLocal)

    task.wait(3)

    humanoidRoot.CFrame = CFrame.new(posOriginal)
end)

--==========================
-- MINI SISTEMA
--==========================
local miniAtivo = false

MiniToggle.MouseButton1Click:Connect(function()
    miniAtivo = not miniAtivo
    MiniToggle.Text = miniAtivo and "Mini: ON" or "Mini: OFF"
    MiniToggle.BackgroundColor3 =
        miniAtivo and Color3.fromRGB(50, 255, 50)
        or Color3.fromRGB(255, 50, 50)
end)

-- Detecta quando pega um pet (brainrot)
player.Backpack.ChildAdded:Connect(function(item)
    if miniAtivo then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Size = part.Size * 0.1
            end
        end
    end
end)
