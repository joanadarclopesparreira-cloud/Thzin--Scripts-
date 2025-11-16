--========================================================--
--   THZINX SCRIPTS 👾  -  MENU FLUTUANTE + ICON + DRAG    --
--========================================================--

local KEY = "thzin-scripts"

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

-- UI principal
local gui = Instance.new("ScreenGui", pg)
gui.Name = "Thzin_FloatUI"
gui.ResetOnSpawn = false

------------------------------------------------------------
-- 🔵 ÍCONE FLUTUANTE (GOJO + THZINX SCRIPTS 👾)
------------------------------------------------------------

local icon = Instance.new("ImageButton", gui)
icon.Name = "ThzinIcon"
icon.Size = UDim2.new(0,90,0,90)
icon.Position = UDim2.new(0.05,0,0.35,0)
icon.BackgroundTransparency = 1
icon.Image = "https://raw.githubusercontent.com/joanadarclopesparreira-cloud/Thzin--Scripts-/main/thzin_icon.png" -- <<< AQUI SUA IMAGEM
icon.Visible = false

local round = Instance.new("UICorner", icon)
round.CornerRadius = UDim.new(1,0)

-- Drag do ícone
do
    local dragging, dragStart, startPos
    icon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = icon.Position
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
            icon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                      startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

------------------------------------------------------------
-- 🔵 JANELA PRINCIPAL DO SCRIPT
------------------------------------------------------------

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,420,0,450)
main.Position = UDim2.new(0.5,-210,0.5,-225)
main.BackgroundColor3 = Color3.fromRGB(20,0,35)
main.Visible = false

Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,50)
title.BackgroundTransparency = 1
title.Text = "THZINX SCRIPTS 👾"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22

------------------------------------------------------------
-- 🔵 SISTEMA DE KEY (Página inicial)
------------------------------------------------------------

local keyFrame = Instance.new("Frame", main)
keyFrame.Size = UDim2.new(1,0,1,0)
keyFrame.BackgroundTransparency = 0
keyFrame.BackgroundColor3 = Color3.fromRGB(40,0,60)

Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0,10)

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(0.8,0,0,40)
keyBox.Position = UDim2.new(0.1,0,0.35,0)
keyBox.PlaceholderText = "Digite a Key..."
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 18
keyBox.BackgroundColor3 = Color3.fromRGB(90,0,120)
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0,8)

local keyBtn = Instance.new("TextButton", keyFrame)
keyBtn.Size = UDim2.new(0.8,0,0,40)
keyBtn.Position = UDim2.new(0.1,0,0.50,0)
keyBtn.Text = "Confirmar Key"
keyBtn.Font = Enum.Font.GothamBold
keyBtn.TextSize = 18
keyBtn.BackgroundColor3 = Color3.fromRGB(120,0,180)
Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0,8)

------------------------------------------------------------
-- 🔵 FUNÇÃO PARA MOSTRAR OU ESCONDER MENU
------------------------------------------------------------

local menuVisible = false

local function ToggleMenu()
    menuVisible = not menuVisible
    main.Visible = menuVisible
end

icon.MouseButton1Click:Connect(ToggleMenu)

------------------------------------------------------------
-- 🔵 QUANDO DIGITAR A KEY CERTA
------------------------------------------------------------

keyBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == KEY then
        keyBtn.Text = "✔ Acesso Liberado"
        task.wait(0.8)

        -- Esconde tela de key
        keyFrame.Visible = false

        -- Mostra o ícone flutuante
        icon.Visible = true

        -- Esconde o painel
        main.Visible = false
    else
        keyBtn.Text = "❌ Key incorreta"
        task.wait(1)
        keyBtn.Text = "Confirmar Key"
    end
end)

------------------------------------------------------------
-- 🔵 AQUI FICA O RESTANTE DO SEU SCRIPT ORIGINAL (OPÇÕES)
------------------------------------------------------------

-- Aqui você insere:
-- salvar localização
-- teleporte com animação
-- invisibilidade automática
-- radar
-- ESP completo
-- ignorar torretas
-- brainrot invisível automático
-- etc

-- (posso colar tudo pronto aqui quando você pedir)
