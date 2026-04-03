local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local AURA_CONFIG = {
    Color = Color3.fromRGB(255, 0, 0),
    FillTransparency = 0.7,
    OutlineTransparency = 0.2,
    DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
}

local activeHighlights = {}

-- Criar aura (versão melhorada)
local function createAura(player)
    local character = player.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    -- Remove antiga
    if activeHighlights[player] then
        activeHighlights[player]:Destroy()
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Aura"

    highlight.FillColor = AURA_CONFIG.Color
    highlight.OutlineColor = AURA_CONFIG.Color
    highlight.FillTransparency = AURA_CONFIG.FillTransparency
    highlight.OutlineTransparency = AURA_CONFIG.OutlineTransparency
    highlight.DepthMode = AURA_CONFIG.DepthMode

    -- 🔥 ISSO AQUI RESOLVE MUITO BUG
    highlight.Adornee = character
    highlight.Parent = game:GetService("CoreGui")

    activeHighlights[player] = highlight
end

-- Monitorar player
local function trackPlayer(player)

    local function setup()
        task.wait(0.2)
        createAura(player)
    end

    if player.Character then
        setup()
    end

    player.CharacterAdded:Connect(setup)

    player.CharacterRemoving:Connect(function()
        if activeHighlights[player] then
            activeHighlights[player]:Destroy()
            activeHighlights[player] = nil
        end
    end)
end

-- Inicializar
for _, player in ipairs(Players:GetPlayers()) do
    trackPlayer(player)
end

Players.PlayerAdded:Connect(trackPlayer)

-- 🔥 LOOP ANTI-DISTÂNCIA
task.spawn(function()
    while true do
        task.wait(2)

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createAura(player)
            end
        end
    end
end)

warn("ESP COM FIX DE DISTÂNCIA 🚀")
