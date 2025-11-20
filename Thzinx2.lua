-- Thzinx.lua — Ferramenta administrativa para seu jogo (teleporte, invisibilidade, noclip, esconder pet)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Config de admins (substitua pelos seus UserIds)
local ADMIN_USERIDS = {
    12345678, -- coloque o seu UserId, e outros que serão admins
}

-- Criar RemoteEvents se não existirem
local TeleportEvent = ReplicatedStorage:FindFirstChild("Thzinx_AdminTeleport")
if not TeleportEvent then
    TeleportEvent = Instance.new("RemoteEvent")
    TeleportEvent.Name = "Thzinx_AdminTeleport"
    TeleportEvent.Parent = ReplicatedStorage
end

local ActionEvent = ReplicatedStorage:FindFirstChild("Thzinx_AdminAction")
if not ActionEvent then
    ActionEvent = Instance.new("RemoteEvent")
    ActionEvent.Name = "Thzinx_AdminAction"
    ActionEvent.Parent = ReplicatedStorage
end

-- Cooldown de teleporte por admin
local TELEPORT_COOLDOWN = 2
local lastTeleport = {}

local function isAdmin(player)
    for _, id in ipairs(ADMIN_USERIDS) do
        if player.UserId == id then
            return true
        end
    end
    return false
end

-- Função para invisibilizar modelo (personagem ou pet)
local function setInvisibleModel(model, invisible)
    for _, descendant in ipairs(model:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Transparency = invisible and 1 or 0
            descendant.CanCollide = not invisible
        elseif descendant:IsA("Decal") then
            descendant.Transparency = invisible and 1 or 0
        elseif descendant:IsA("Accessory") then
            local handle = descendant:FindFirstChild("Handle")
            if handle then
                handle.Transparency = invisible and 1 or 0
            end
        end
    end
end

-- Função para encontrar o pet/brainrot do jogador (heurística simples)
local function findPlayerPet(player)
    local lowerName = string.lower(player.Name)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local n = obj.Name and string.lower(obj.Name) or ""
            if n:find("brain") or n:find("pet") or n:find(lowerName) then
                local primary = obj:IsA("Model") and obj.PrimaryPart or (obj:IsA("BasePart") and obj)
                if primary and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (primary.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 10 then
                        return obj
                    end
                end
            end
        end
    end
    return nil
end

-- Evento do teleporte (servidor)
TeleportEvent.OnServerEvent:Connect(function(player, targetCFrame)
    if not isAdmin(player) then return end
    if typeof(targetCFrame) ~= "CFrame" then return end

    local now = tick()
    if lastTeleport[player] and now - lastTeleport[player] < TELEPORT_COOLDOWN then
        return
    end
    lastTeleport[player] = now

    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- desativa colisão rapidamente
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part:SetAttribute("Thzinx_StoredCanCollide", part.CanCollide)
            part.CanCollide = false
        end
    end

    hrp.Anchored = true
    hrp.CFrame = targetCFrame
    hrp.Velocity = Vector3.new(0, 0, 0)

    task.wait(0.2)

    hrp.Anchored = false

    task.delay(0.4, function()
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    local old = part:GetAttribute("Thzinx_StoredCanCollide")
                    if old ~= nil then
                        part.CanCollide = old
                        part:SetAttribute("Thzinx_StoredCanCollide", nil)
                    else
                        part.CanCollide = true
                    end
                end
            end
        end
    end)
end)

-- Evento para outras ações de admin: invisibilidade, noclip, esconder pet, reset
ActionEvent.OnServerEvent:Connect(function(player, action, enable)
    if not isAdmin(player) then return end
    local char = player.Character
    if not char then return end

    if action == "INVISIBLE" then
        setInvisibleModel(char, enable)

    elseif action == "NOCLIP" then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not enable
            end
        end

    elseif action == "HIDE_PET" then
        local pet = findPlayerPet(player)
        if pet then
            setInvisibleModel(pet, enable)
        end

    elseif action == "RESET" then
        setInvisibleModel(char, false)
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                local old = part:GetAttribute("Thzinx_StoredCanCollide")
                if old ~= nil then
                    part.CanCollide = old
                    part:SetAttribute("Thzinx_StoredCanCollide", nil)
                else
                    part.CanCollide = true
                end
            end
        end
        local pet = findPlayerPet(player)
        if pet then
            setInvisibleModel(pet, false)
        end
    end
end)

print("[Thzinx] Script admin carregado (servidor).")
