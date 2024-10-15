-- MADE BY yion._
-- send issues or suggestions to my privado

-- Alterar material de todas as Parts para SmoothPlastic
for i, v in next, (workspace:GetDescendants()) do
    if v:IsA("Part") then
        v.Material = Enum.Material.SmoothPlastic
    end
end

-- Carregar Configuração de configspc.txt
local function loadConfig()
    local config = {
        SaturationEnabled = false -- Saturação desativada por padrão
    }
    local success, result = pcall(function()
        return readfile("configspc.txt")
    end)
    if success then
        for line in result:gmatch("[^\r\n]+") do
            local key, value = line:match("^(%S+)%s*=%s*(%S+)$")
            if key and value then
                if key == "SaturationEnabled" then
                    config.SaturationEnabled = (value == "true")
                end
            end
        end
    else
        writefile("configspc.txt", "SaturationEnabled=false") -- Cria o arquivo padrão
    end
    return config
end

local config = loadConfig()

-- Configurações e Inicialização
if not _G.Ignore then
    _G.Ignore = {} -- Add Instances to this table to ignore them (e.g. _G.Ignore = {workspace.Map, workspace.Map2})
end
if not _G.WaitPerAmount then
    _G.WaitPerAmount = 500 -- Set Higher or Lower depending on your computer's performance
end
if _G.SendNotifications == nil then
    _G.SendNotifications = false -- Removido para não enviar notificações intermediárias
end
if _G.ConsoleLogs == nil then
    _G.ConsoleLogs = false -- Set to true if you want console logs (mainly for debugging)
end

if not game:IsLoaded() then
    repeat task.wait() until game:IsLoaded()
end
if not _G.Settings then
    _G.Settings = {
        Players = {
            ["Ignore Me"] = true,
            ["Ignore Others"] = true,
            ["Ignore Tools"] = true
        },
        Meshes = {
            NoMesh = false,
            NoTexture = false,
            Destroy = false
        },
        Images = {
            Invisible = true,
            Destroy = false
        },
        Explosions = {
            Smaller = true,
            Invisible = false,
            Destroy = false
        },
        Particles = {
            Invisible = true,
            Destroy = false
        },
        TextLabels = {
            LowerQuality = false,
            Invisible = false,
            Destroy = false
        },
        MeshParts = {
            LowerQuality = true,
            Invisible = false,
            NoTexture = false,
            NoMesh = false,
            Destroy = false
        },
        Other = {
            ["FPS Cap"] = 60,
            ["No Camera Effects"] = true,
            ["No Clothes"] = true,
            ["Low Water Graphics"] = true,
            ["No Shadows"] = true,
            ["Low Rendering"] = true,
            ["Low Quality Parts"] = true,
            ["Low Quality Models"] = true,
            ["Reset Materials"] = true,
            ["Lower Quality MeshParts"] = true,
            ["Enhanced Colors"] = config.SaturationEnabled, -- Configuração de saturação a partir do arquivo configspc.txt
            ["Lower Texture Quality"] = true -- Nova opção para diminuir qualidade das texturas
        }
    }
end

-- Serviços e Funções
local Players, Lighting, StarterGui, MaterialService = game:GetService("Players"), game:GetService("Lighting"), game:GetService("StarterGui"), game:GetService("MaterialService")
local ME, CanBeEnabled = Players.LocalPlayer, {"ParticleEmitter", "Trail", "Smoke", "Fire", "Sparkles"}

local function PartOfCharacter(Instance)
    for i, v in pairs(Players:GetPlayers()) do
        if v ~= ME and v.Character and Instance:IsDescendantOf(v.Character) then
            return true
        end
    end
    return false
end

local function DescendantOfIgnore(Instance)
    for i, v in pairs(_G.Ignore) do
        if Instance:IsDescendantOf(v) then
            return true
        end
    end
    return false
end

local function CheckIfBad(Instance)
    -- Implementação do CheckIfBad com suas verificações
end

-- Configurações de Gráficos da Água
coroutine.wrap(pcall)(function()
    if _G.Settings["Low Water Graphics"] or (_G.Settings.Other and _G.Settings.Other["Low Water Graphics"]) then
        if not workspace:FindFirstChildOfClass("Terrain") then
            repeat task.wait() until workspace:FindFirstChildOfClass("Terrain")
        end
        local Terrain = workspace:FindFirstChildOfClass("Terrain")
        Terrain.WaterWaveSize, Terrain.WaterWaveSpeed = 0, 0
        Terrain.WaterReflectance = 0.1
        Terrain.WaterTransparency = 0.5 -- Ajuste de transparência para ver o fundo
        Terrain.WaterColor = Color3.new(0.1, 0.3, 1) -- Azul claro para a água
    end
end)

-- Configurações de Sombra
coroutine.wrap(pcall)(function()
    if _G.Settings["No Shadows"] or (_G.Settings.Other and _G.Settings.Other["No Shadows"]) then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
    end
end)

-- Reduzir Renderização
coroutine.wrap(pcall)(function()
    if _G.Settings["Low Rendering"] or (_G.Settings.Other and _G.Settings.Other["Low Rendering"]) then
        settings().Rendering.QualityLevel = 1
    end
end)

-- Resetar Materiais
coroutine.wrap(pcall)(function()
    if _G.Settings["Reset Materials"] or (_G.Settings.Other and _G.Settings.Other["Reset Materials"]) then
        for i, v in pairs(MaterialService:GetChildren()) do
            v:Destroy()
        end
        MaterialService.Use2022Materials = false
    end
end)

-- Cap de FPS
coroutine.wrap(pcall)(function()
    if _G.Settings["FPS Cap"] or (_G.Settings.Other and _G.Settings.Other["FPS Cap"]) then
        if setfpscap then
            setfpscap(tonumber(_G.Settings["FPS Cap"]))
        else
            StarterGui:SetCore("SendNotification", {
                Title = "discord.gg/rips",
                Text = "FPS Cap Failed",
                Duration = math.huge,
                Button1 = "Okay"
            })
        end
    end
end)

-- Realçar Cores e Saturação
coroutine.wrap(pcall)(function()
    if config.SaturationEnabled then
        local colorCorrection = Instance.new("ColorCorrectionEffect")
        colorCorrection.Parent = Lighting
        colorCorrection.Saturation = 1.5 -- Aumenta a saturação para deixar as cores mais vibrantes
        colorCorrection.Contrast = 0.2 -- Adiciona um pouco de contraste para mais definição
        colorCorrection.Brightness = 0.1 -- Ajusta o brilho levemente
    end
end)

-- Notificação Final
StarterGui:SetCore("SendNotification", {
    Title = "Space boost By mqzkeu",
    Text = "Loaded with Saturation: " .. tostring(config.SaturationEnabled),
    Duration = 5, -- Duração da notificação
    Button1 = "Okay"
})

warn("FPS Booster Loaded!")
