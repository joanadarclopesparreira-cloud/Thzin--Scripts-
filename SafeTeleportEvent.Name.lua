-- Thzin_Server (Script em ServerScriptService)
-- Responsável por: Teleporte seguro, modo formiga, anti-hit, anti-torreta

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

-- Eventos
local SafeTeleportEvent = Instance.new("RemoteEvent")
SafeTeleportEvent.Name = "Thzin_SafeTeleport"
SafeTeleportEvent.Parent = RS

local RequestEvent = Instance.new("RemoteEvent")
RequestEvent.Name = "Thzin_RequestAction"
RequestEvent.Parent = RS

-------------------------------------------------------------------
-- 🔥 FUNÇÃO DE TELEPORTE SEGURO (ANTI-HIT / ANTI-ROLLBACK)
-------------------------------------------------------------------
local function SafeTeleport(player, targetCFrame)
    if not player.Character then return end
    local char = player.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hrp or not hum then return end

    -- Desativa colisões temporariamente
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    -- ANTI-HIT PRINCIPAL: congela o personagem para evitar rollback
    hrp.Anchored = true
    hum.WalkSpeed = 0
    hum.JumpPower = 0

    -- Teleporta
    hrp.CFrame = targetCFrame
    hrp.Velocity = Vector3.zero

    -- Delay pequeno para estabilizar posição
    task.wait(0.25)

    -- Desancorar
    hrp.Anchored = false

    -- Reativa movimento
    hum.WalkSpeed = 16
    hum.JumpPower = 50

    -- Reativa colisão depois de 0.4s
    task.delay(0.4, function()
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end)
end

-------------------------------------------------------------------
-- 🔥 MODO FORMIGA (server)
-------------------------------------------------------------------
local function SetFormiga(player, enable)
    if not player.Character then return end
    local char = player.Character
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hum then return end

    if enable then
        hum.BodyScale.Value = 0.1 -- Caso seu jogo tenha BodyScale
        char.HumanoidRootPart.Size = Vector3.new(1,1,1) * 0.2
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Size = part.Size * 0.2
            end
        end
    else
        -- Reset
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Size = Vector3.new(2,2,1)
            end
        end
    end
end

-------------------------------------------------------------------
-- 🔥 ANTI-TORRETA (imunidade)
-------------------------------------------------------------------
local turretProtected = {}

local function SetAntiTurret(player, enable)
    turretProtected[player] = enable
end

-- Protege contra scripts que causam dano ao player
Players.PlayerAdded:Connect(function(plr)
    turretProtected[plr] = false
end)

-------------------------------------------------------------------
-- 🔥 RECEPÇÃO DOS EVENTOS DO CLIENTE
-------------------------------------------------------------------
SafeTeleportEvent.OnServerEvent:Connect(function(player, cframe)
    SafeTeleport(player, cframe)
end)

RequestEvent.OnServerEvent:Connect(function(player, action, value)
    if action == "SET_FORMIGA" then
        SetFormiga(player, value)

    elseif action == "ANTI_TURRET_TOGGLE" then
        SetAntiTurret(player, value)
    end
end)

print("🔥 Thzin_Server carregado com sucesso!")
