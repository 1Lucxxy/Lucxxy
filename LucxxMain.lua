-- Buat GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

-- Buat frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 200)
Frame.Position = UDim2.new(0.5, -100, 0.5, -100)
Frame.BackgroundColor3 = Color3.new(1, 1, 1)
Frame.Parent = ScreenGui

-- Buat tombol 1
local Button1 = Instance.new("TextButton")
Button1.Size = UDim2.new(0.8, 0, 0, 50)
Button1.Position = UDim2.new(0.1, 0, 0.1, 0)
Button1.Text = "Jalankan Script 1"
Button1.FontSize = Enum.FontSize.Size14
Button1.Parent = Frame

-- Buat tombol 2
local Button2 = Instance.new("TextButton")
Button2.Size = UDim2.new(0.8, 0, 0, 50)
Button2.Position = UDim2.new(0.1, 0, 0.5, 0)
Button2.Text = "Jalankan Script 2"
Button2.FontSize = Enum.FontSize.Size14
Button2.Parent = Frame

-- Fungsi untuk menjalankan script 1
local function RunScript1()
    -- Script 1
    print("loadstring(game:HttpGet("https://raw.githubusercontent.com/1Lucxxy/LucxxHub/refs/heads/main/LucxxHub.lua"))()")
    -- Tambahkan kode script 1 di sini
    local player = game.Players.LocalPlayer
    local character = player.Character
    character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame + Vector3.new(0, 0, 10)
end

-- Fungsi untuk menjalankan script 2
local function RunScript2()
    -- Script 2
    print("loadstring(game:HttpGet(“https://raw.githubusercontent.com/1Lucxxy/LucxxHub/refs/heads/main/lucxx2.lua”))()")
    -- Tambahkan kode script 2 di sini
    local player = game.Players.LocalPlayer
    local character = player.Character
    character.Humanoid.Jump = true
end

-- Koneksi tombol ke fungsi
Button1.MouseButton1Click:Connect(RunScript1)
Button2.MouseButton1Click:Connect(RunScript2)
