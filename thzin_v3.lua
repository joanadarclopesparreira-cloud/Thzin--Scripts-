-- THZINX SCRIPTS V3 👾
-- Key necessária: thzin-scripts

local KEY = "thzin-scripts"

---------------------------------------------------------------------
-- UI PRINCIPAL
---------------------------------------------------------------------

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "ThzinV3"
ScreenGui.ResetOnSpawn = false

-- Fundo inicial (tela da KEY)
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 350, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
KeyFrame.BorderSizePixel = 0
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0,12)

local Title = Instance.new("TextLabel", KeyFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "THZINX SCRIPTS 👾"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(255,255,255)

local KeyBox = Instance.new("TextBox", KeyFrame)
KeyBox.Size = UDim2.new(0.9,0,0,40)
KeyBox.Position = UDim2.new(0.05,0,0.38,0)
KeyBox.PlaceholderText = "Digite a KEY..."
KeyBox.Font = Enum.Font.GothamBold
KeyBox.TextSize = 18
KeyBox.BackgroundColor3 = Color3.fromRGB(40,40,50)
KeyBox.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0,10)

local Confirm = Instance.new("TextButton", KeyFrame)
Confirm.Size = UDim2.new(0.9,0,0,40)
Confirm.Position = UDim2.new(0.05,0,0.7,0)
Confirm.Text = "Confirmar Key"
Confirm.Font = Enum.Font.GothamBold
Confirm.TextSize = 18
Confirm.BackgroundColor3 = Color3.fromRGB(80,0,160)
Confirm.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", Confirm).CornerRadius = UDim.new(0,10)

---------------------------------------------------------------------
-- PAINEL PRINCIPAL (fica oculto até a KEY ser aceita)
---------------------------------------------------------------------

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 420, 0, 460)
Main.Position = UDim2.new(0.5, -210, 0.5, -230)
Main.BackgroundColor3 = Color3.fromRGB(25, 0, 45)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

local Titulo2 = Instance.new("TextLabel", Main)
Titulo2.Size = UDim2.new(1, 0, 0, 40)
Titulo2.BackgroundTransparency = 1
Titulo2.Text = "THZINX MENU 👾"
Titulo2.Font = Enum.Font.GothamBold
Titulo2.TextSize = 22
Titulo2.TextColor3 = Color3.fromRGB(255,255,255)

---------------------------------------------------------------------
-- FUNÇÃO PARA CRIAR BOTÕES
---------------------------------------------------------------------

function NovaOpcao(txt, pos)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.9,0,0,40)
    b.Position = UDim2.new(0.05,0,pos,0)
    b.Text = txt
    b.Font = Enum.Font.GothamBold
    b.TextSize = 18
    b.BackgroundColor3 = Color3.fromRGB(100,0,180)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    return b
end

---------------------------------------------------------------------
-- SISTEMA DE KEY
---------------------------------------------------------------------

Confirm.MouseButton1Click:Connect(function()
    if KeyBox.Text == KEY then
        Confirm.Text = "Aprovado ✔"
        Confirm.BackgroundColor3 = Color3.fromRGB(0,200,100)
        task.wait(0.6)

        KeyFrame:Destroy()
        Main.Visible = true
    else
        Confirm.Text = "KEY INCORRETA ❌"
        Confirm.BackgroundColor3 = Color3.fromRGB(200,40,40)
        task.wait(1)
        Confirm.Text = "Confirmar Key"
        Confirm.BackgroundColor3 = Color3.fromRGB(80,0,160)
    end
end)

---------------------------------------------------------------------
-- FUNÇÃO: MARCAR LOCALIZAÇÃO
---------------------------------------------------------------------

local SavedCFrame = nil

local Save = NovaOpcao("Salvar Localização", 0.18)
Save.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        SavedCFrame = char.HumanoidRootPart.CFrame
        Titulo2.Text = "Localização salva ✔"
    end
end)

---------------------------------------------------------------------
-- VOLTAR PARA LOCALIZAÇÃO (com animação)
---------------------------------------------------------------------

local Tp = NovaOpcao("Voltar à Localização", 0.30)
Tp.MouseButton1Click:Connect(function()
    if not SavedCFrame then
        Titulo2.Text = "Nenhum local salvo"
        return
    end

    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for i = 1,20 do
        hrp.CFrame = hrp.CFrame:Lerp(SavedCFrame, 0.25)
        task.wait(0.03)
    end

    hrp.CFrame = SavedCFrame
    Titulo2.Text = "Retornado ✔"
end)

---------------------------------------------------------------------
-- INVISIBILIDADE (client-side simples)
---------------------------------------------------------------------

local Invisible = false
local Invis = NovaOpcao("Invisível ON/OFF", 0.42)

Invis.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end

    Invisible = not Invisible

    for _,v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = Invisible and 1 or 0
        elseif v:IsA("Decal") then
            v.Transparency = Invisible and 1 or 0
        end
    end

    Titulo2.Text = Invisible and "Invisível ✔" or "Visível ✔"
end)

---------------------------------------------------------------------
-- ESP BASES + PETS
---------------------------------------------------------------------

local EspOn = false
local Esp = NovaOpcao("ESP Bases / Pets", 0.54)

Esp.MouseButton1Click:Connect(function()
    EspOn = not EspOn

    if EspOn then
        Titulo2.Text = "ESP ON ✔"
        
        for _,obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("base") or obj.Name:lower():find("pet")) then
                local bill = Instance.new("BillboardGui", obj)
                bill.Name = "Thzin_Tag"
                bill.Size = UDim2.new(0,80,0,20)
                bill.AlwaysOnTop = true

                local txt = Instance.new("TextLabel", bill)
                txt.Size = UDim2.new(1,0,1,0)
                txt.Text = obj.Name
                txt.BackgroundTransparency = 1
                txt.Font = Enum.Font.GothamBold
                txt.TextColor3 = Color3.fromRGB(0,255,255)
                txt.TextScaled = true
            end
        end

    else
        Titulo2.Text = "ESP OFF ❌"
        for _,v in pairs(workspace:GetDescendants()) do
            if v.Name == "Thzin_Tag" then v:Destroy() end
        end
    end
end)

---------------------------------------------------------------------
-- PROTEÇÃO CONTRA TORRETAS
---------------------------------------------------------------------

local NoShoot = false
local Prot = NovaOpcao("Anti-Torreta", 0.66)

Prot.MouseButton1Click:Connect(function()
    NoShoot = not NoShoot
    Titulo2.Text = NoShoot and "Torretas bloqueadas ✔" or "Anti-torreta OFF"

    if NoShoot then
        task.spawn(function()
            while NoShoot do
                for _,v in pairs(workspace:GetDescendants()) do
                    if v.Name:lower():find("turret") or v.Name:lower():find("torreta") then
                        pcall(function() v:Destroy() end)
                    end
                end
                task.wait(1)
            end
        end)
    end
end)

---------------------------------------------------------------------
-- INVISIBILIDADE AUTO AO PEGAR PET
---------------------------------------------------------------------

local AutoInv = false
local Auto = NovaOpcao("Auto Invisível (pet)", 0.78)

Auto.MouseButton1Click:Connect(function()
    AutoInv = not AutoInv
    Titulo2.Text = AutoInv and "Auto invisível ON" or "Auto invisível OFF"

    if AutoInv then
        task.spawn(function()
            while AutoInv do
                for _,v in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if v.Name:lower():find("brain") then
                        -- invisibilidade imediata
                        LocalPlayer.Character.HumanoidRootPart.Transparency = 1
                        for _,p in pairs(LocalPlayer.Character:GetDescendants()) do
                            if p:IsA("BasePart") then p.Transparency = 1 end
                        end
                    end
                end
                task.wait(0.2)
            end
        end)
    end
end)

---------------------------------------------------------------------
-- FIM DO SCRIPT
---------------------------------------------------------------------
print("THZIN V3 carregado ✔")
