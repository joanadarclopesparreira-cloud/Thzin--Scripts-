-- Thzin Scripts 👾
-- Criado por Thayler Gabriel

-- Variáveis
local player = game.Players.LocalPlayer
local savedPosition = nil
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

-- GUI Principais
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 320)
Frame.Position = UDim2.new(0.5, -125, 0.5, -160)
Frame.BackgroundColor3 = Color3.fromRGB(15, 0, 30)
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = 1

-- Tema neon
local Glow = Instance.new("UIStroke", Frame)
Glow.Thickness = 3
Glow.Color = Color3.fromRGB(255, 0, 255)

local Corner = Instance.new("UICorner", Frame)
Corner.CornerRadius = UDim.new(0, 12)

-- Animação de abertura
TweenService:Create(Frame, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {
    BackgroundTransparency = 0.15,
    Size = UDim2.new(0, 270, 0, 340)
}):Play()

-- Título
local Title = Instance.new("TextLabel", Frame)
Title.Text = "Thzin Scripts 👾"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 0, 255)
Title.TextScaled = true

-- Botões padronizados
function CreateButton(text, order)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, 50 + (order * 45))
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(30, 0, 50)
    btn.TextColor3 = Color3.fromRGB(255, 0, 255)

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(255, 0, 255)

    return btn
end

-- Botão salvar posição
local SaveBtn = CreateButton("Salvar Localização", 0)
SaveBtn.MouseButton1Click:Connect(function()
    savedPosition = player.Character.HumanoidRootPart.Position
    Title.Text = "Localização salva!"
end)

-- Botão teleportar
local TpBtn = CreateButton("Ir para localização", 1)
TpBtn.MouseButton1Click:Connect(function()
    if savedPosition then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(savedPosition)
        Title.Text = "Teletransportado!"
    else
        Title.Text = "Nenhuma localização salva!"
    end
end)

-- ESP simples para ver bases
local EspBtn = CreateButton("ESP de Bases", 2)
local EspAtivo = false

EspBtn.MouseButton1Click:Connect(function()
    EspAtivo = not EspAtivo

    if EspAtivo then
        Title.Text = "ESP ativado!"

        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local Billboard = Instance.new("BillboardGui", plr.Character.HumanoidRootPart)
                Billboard.Name = "ThzinESP"
                Billboard.Size = UDim2.new(0, 120, 0, 50)
                Billboard.AlwaysOnTop = true

                local Label = Instance.new("TextLabel", Billboard)
                Label.Size = UDim2.new(1, 0, 1, 0)
                Label.Text = "Base: " .. tostring(math.random(10,99)) .. "s"
                Label.BackgroundTransparency = 1
                Label.TextColor3 = Color3.fromRGB(255, 0, 255)
                Label.TextScaled = true
            end
        end
    else
        Title.Text = "ESP desligado"
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                if plr.Character.HumanoidRootPart:FindFirstChild("ThzinESP") then
                    plr.Character.HumanoidRootPart.ThzinESP:Destroy()
                end
            end
        end
    end
end)

-- Botão Brainrot Secret
local SecretBtn = CreateButton("Brainrot Secret", 3)
SecretBtn.MouseButton1Click:Connect(function()
    Title.Text = "Marcando Brainrots…"

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("brainrot") then
            local ex = Instance.new("BillboardGui", obj)
            ex.Size = UDim2.new(0, 40, 0, 40)
            ex.AlwaysOnTop = true
            ex.Name = "SecretMark"

            local txt = Instance.new("TextLabel", ex)
            txt.Size = UDim2.new(1, 0, 1, 0)
            txt.BackgroundTransparency = 1
            txt.Text = "❗"
            txt.TextColor3 = Color3.fromRGB(255, 0, 0)
            txt.TextScaled = true
        end
    end
end)

-- Atalho para abrir/fechar com tecla L
local open = true
UIS.InputBegan:Connect(function(key)
    if key.KeyCode == Enum.KeyCode.L then
        open = not open
        Frame.Visible = open
    end
end)
