-- // Violence District Utility GUI (Rayfield Edition)
-- // by GPT-5

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Violence District Utility",
    LoadingTitle = "Rayfield Hub",
    LoadingSubtitle = "by GPT-5",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ViolenceDistrict",
        FileName = "Config"
    },
    Discord = { Enabled = false },
    KeySystem = false
})

------------------------------------------------------------
-- VISUAL TAB
------------------------------------------------------------

local VisualTab = Window:CreateTab("Visual", 4483362458)

local highlightTransparency = 0.8
local playerHighlights, generatorHighlights, pumpkinHighlights = {}, {}, {}

local function clearHighlights(tbl)
    for _, h in pairs(tbl) do
        if h and h.Parent then h:Destroy() end
    end
    table.clear(tbl)
end

local function createHighlight(target, color, tbl)
    local h = Instance.new("Highlight")
    h.Adornee = target
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.FillColor = color
    h.FillTransparency = highlightTransparency
    h.OutlineTransparency = 1
    h.Parent = target
    table.insert(tbl, h)
end

-- 🟩 Survivor & Killer
local function updatePlayerHighlights()
    clearHighlights(playerHighlights)
    local localPlayer = game.Players.LocalPlayer
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if player.Team and player.Team.Name == "Survivors" then
                createHighlight(player.Character, Color3.fromRGB(0, 255, 0), playerHighlights)
            elseif player.Team and player.Team.Name == "Killer" then
                createHighlight(player.Character, Color3.fromRGB(255, 0, 0), playerHighlights)
            end
        end
    end
end

-- 🟨 Generator
local function updateGeneratorHighlights()
    clearHighlights(generatorHighlights)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == "Generator" then
            createHighlight(obj, Color3.fromRGB(255, 255, 0), generatorHighlights)
        end
    end
end

-- 🎃 Pumpkin (semua nama yang diawali “pumpkin”)
local function updatePumpkinHighlights()
    clearHighlights(pumpkinHighlights)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Part") then
            local name = string.lower(obj.Name)
            if string.find(name, "^pumpkin") then
                createHighlight(obj, Color3.fromRGB(255, 125, 0), pumpkinHighlights)
            end
        end
    end
end

-- Toggles
local playerHL, genHL, pumpkinHL = false, false, false

VisualTab:CreateToggle({
    Name = "Highlight Survivor & Killer",
    CurrentValue = false,
    Callback = function(state)
        playerHL = state
        if state then updatePlayerHighlights() else clearHighlights(playerHighlights) end
    end
})

VisualTab:CreateToggle({
    Name = "Highlight Generator",
    CurrentValue = false,
    Callback = function(state)
        genHL = state
        if state then updateGeneratorHighlights() else clearHighlights(generatorHighlights) end
    end
})

VisualTab:CreateToggle({
    Name = "Highlight Pumpkin (semua)",
    CurrentValue = false,
    Callback = function(state)
        pumpkinHL = state
        if state then updatePumpkinHighlights() else clearHighlights(pumpkinHighlights) end
    end
})

VisualTab:CreateButton({
    Name = "Reload Highlights",
    Callback = function()
        if playerHL then updatePlayerHighlights() end
        if genHL then updateGeneratorHighlights() end
        if pumpkinHL then updatePumpkinHighlights() end
        Rayfield:Notify({
            Title = "Highlights Reloaded",
            Content = "Semua highlight diperbarui.",
            Duration = 2
        })
    end
})

-- Auto refresh setiap 5 detik
task.spawn(function()
    while task.wait(5) do
        if playerHL then updatePlayerHighlights() end
        if genHL then updateGeneratorHighlights() end
        if pumpkinHL then updatePumpkinHighlights() end
    end
end)

------------------------------------------------------------
-- COMBAT TAB
------------------------------------------------------------

local CombatTab = Window:CreateTab("Combat", 4483362458)

local SmartHitboxEnabled = false
local hitboxRange = 10

CombatTab:CreateToggle({
    Name = "Smart Hitbox (radius 10, tanpa visual box)",
    CurrentValue = false,
    Callback = function(v)
        SmartHitboxEnabled = v
        if v then
            task.spawn(function()
                while SmartHitboxEnabled do
                    task.wait(0.1)
                    local player = game.Players.LocalPlayer
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local hrp = char.HumanoidRootPart
                        for _, enemy in pairs(game.Players:GetPlayers()) do
                            if enemy ~= player and enemy.Team and enemy.Team.Name ~= player.Team.Name then
                                local enemyChar = enemy.Character
                                if enemyChar and enemyChar:FindFirstChild("HumanoidRootPart") then
                                    local dist = (enemyChar.HumanoidRootPart.Position - hrp.Position).Magnitude
                                    if dist <= hitboxRange then
                                        -- di sini bisa tambahkan efek/logika attack proximity
                                        print("Musuh terdeteksi dalam radius:", math.floor(dist))
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
})

------------------------------------------------------------
-- MISC TAB
------------------------------------------------------------

local MiscTab = Window:CreateTab("Misc", 4483362458)

local crosshairEnabled = false
local crosshairUI = nil

local function createCrosshair()
    if crosshairUI then crosshairUI:Destroy() end
    crosshairUI = Instance.new("ScreenGui")
    crosshairUI.Name = "CrosshairUI"
    crosshairUI.ResetOnSpawn = false
    crosshairUI.Parent = game.CoreGui

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 6, 0, 6)
    dot.Position = UDim2.new(0.5, 0, 0.5, 0)
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.BackgroundTransparency = 0.3
    dot.BorderSizePixel = 0
    dot.Parent = crosshairUI

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = dot
end

local function removeCrosshair()
    if crosshairUI then crosshairUI:Destroy() crosshairUI = nil end
end

MiscTab:CreateToggle({
    Name = "Crosshair Bulat Putih",
    CurrentValue = false,
    Callback = function(state)
        crosshairEnabled = state
        if state then createCrosshair() else removeCrosshair() end
    end
})
