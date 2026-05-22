-- ====================================================================
-- 🍏 SHADOW VIP v13.0 : ESP RAINBOW CHAMS, SPEED/JUMP & APPLE DESIGN
-- ====================================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreLocation = (gethui and gethui()) or game:GetService("CoreGui")

-- Nettoyage strict des anciennes instances
for _, v in pairs(CoreLocation:GetChildren()) do
    if v.Name:match("PremiumFly_") then v:Destroy() end
end

-- ====================================================================
-- ⚙️ VARIABLES GLOBALES & PARAMÈTRES
-- ====================================================================
local State = {
    Fly = false,
    Spin = false,
    ShiftLock = false,
    MenuOpen = false,
    SpinAngle = 0,
    Walk = false,
    Jump = false,
    EspNames = false,
    EspChams = false
}

local DefaultConfig = {
    FlySpeed = 100,
    SpinSpeed = 500,
    WalkSpeed = 16,
    JumpPower = 50
}

local Config = {
    FlySpeed = DefaultConfig.FlySpeed,
    SpinSpeed = DefaultConfig.SpinSpeed,
    WalkSpeed = DefaultConfig.WalkSpeed,
    JumpPower = DefaultConfig.JumpPower,
    MaxSpeed = 9999 -- Maximum étendu à 9999 comme demandé
}

local Controls
pcall(function()
    local PlayerModule = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
    Controls = PlayerModule:GetControls()
end)

-- Moteurs d'animations (Style iOS)
local AnimBouncy = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local AnimSmooth = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local AnimFast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local Colors = {
    GlassBG = Color3.fromRGB(20, 20, 25),
    Surface = Color3.fromRGB(40, 40, 45),
    AppleBlue = Color3.fromRGB(10, 132, 255),
    AppleRed = Color3.fromRGB(255, 59, 48),
    AppleText = Color3.fromRGB(240, 240, 245),
    AppleSubText = Color3.fromRGB(160, 160, 170)
}

-- ====================================================================
-- 🎨 CRÉATION DE L'INTERFACE (APPLE DESIGN)
-- ====================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumFly_" .. HttpService:GenerateGUID(false)
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreLocation

-- Bouton d'ancrage principal
local GearBtn = Instance.new("TextButton")
GearBtn.Size = UDim2.new(0, 50, 0, 50)
GearBtn.Position = UDim2.new(0.5, -25, 0.85, 0)
GearBtn.BackgroundColor3 = Colors.GlassBG
GearBtn.BackgroundTransparency = 0.3
GearBtn.Text = "⌘"
GearBtn.TextSize = 24
GearBtn.TextColor3 = Colors.AppleText
GearBtn.Font = Enum.Font.GothamMedium
GearBtn.AutoButtonColor = false
GearBtn.Parent = ScreenGui

Instance.new("UICorner", GearBtn).CornerRadius = UDim.new(0.5, 0)
local GearStroke = Instance.new("UIStroke", GearBtn)
GearStroke.Color = Color3.fromRGB(255, 255, 255)
GearStroke.Thickness = 1
GearStroke.Transparency = 0.8

GearBtn.MouseEnter:Connect(function() TweenService:Create(GearBtn, AnimFast, {Size = UDim2.new(0, 54, 0, 54), Position = UDim2.new(0.5, -27, 0.85, -2), BackgroundTransparency = 0.15}):Play() end)
GearBtn.MouseLeave:Connect(function() TweenService:Create(GearBtn, AnimFast, {Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0.5, -25, 0.85, 0), BackgroundTransparency = 0.3}):Play() end)

-- Panneau Central (Glassmorphism)
local SettingsPanel = Instance.new("CanvasGroup")
SettingsPanel.Size = UDim2.new(0, 280, 0, 260)
SettingsPanel.Position = UDim2.new(0.5, -140, 0.85, -100)
SettingsPanel.BackgroundColor3 = Colors.GlassBG
SettingsPanel.BackgroundTransparency = 0.25
SettingsPanel.GroupTransparency = 1 
SettingsPanel.Visible = false
SettingsPanel.Parent = ScreenGui

Instance.new("UICorner", SettingsPanel).CornerRadius = UDim.new(0, 24)
local PanelStroke = Instance.new("UIStroke", SettingsPanel)
PanelStroke.Color = Color3.fromRGB(255, 255, 255)
PanelStroke.Thickness = 1
PanelStroke.Transparency = 0.8

-- FONCTIONS UTILITAIRES UI
local function CreateTitle(parent, text)
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = text
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 15
    Title.Parent = parent
    
    local Gradient = Instance.new("UIGradient", Title)
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Colors.AppleRed),
        ColorSequenceKeypoint.new(1, Colors.AppleBlue)
    })
    return Title, Gradient
end

local function CreateToggleButton(parent, text, posX, posY, sizeX)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, sizeX or 76, 0, 36)
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.BackgroundColor3 = Colors.Surface
    btn.BackgroundTransparency = 0.4
    btn.Text = text
    btn.TextColor3 = Colors.AppleText
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.AutoButtonColor = false
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    return btn
end

local function CreateSlider(parent, titleText, posY, defaultVal)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -32, 0, 15)
    label.Position = UDim2.new(0, 16, 0, posY)
    label.BackgroundTransparency = 1
    label.Text = titleText .. " : " .. defaultVal
    label.TextColor3 = Colors.AppleSubText
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    local bg = Instance.new("TextButton")
    bg.Size = UDim2.new(1, -32, 0, 10)
    bg.Position = UDim2.new(0, 16, 0, posY + 20)
    bg.BackgroundColor3 = Colors.Surface
    bg.Text = ""
    bg.AutoButtonColor = false
    bg.Parent = parent
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(defaultVal / Config.MaxSpeed, 0, 1, 0)
    fill.BackgroundColor3 = Colors.AppleBlue
    fill.Parent = bg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local resetBtn = Instance.new("TextButton")
    resetBtn.Size = UDim2.new(0, 45, 0, 15)
    resetBtn.Position = UDim2.new(1, -45, 0, 0)
    resetBtn.BackgroundTransparency = 1
    resetBtn.Text = "RESET ↺"
    resetBtn.TextColor3 = Colors.AppleBlue
    resetBtn.Font = Enum.Font.GothamBold
    resetBtn.TextSize = 10
    resetBtn.Parent = label
    
    resetBtn.MouseEnter:Connect(function() TweenService:Create(resetBtn, AnimFast, {TextColor3 = Colors.AppleText}):Play() end)
    resetBtn.MouseLeave:Connect(function() TweenService:Create(resetBtn, AnimFast, {TextColor3 = Colors.AppleBlue}):Play() end)

    return bg, fill, label, resetBtn
end

local function CreateBackButton(parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = UDim2.new(0, 12, 0, 5)
    btn.BackgroundTransparency = 1
    btn.Text = "⬅" 
    btn.TextSize = 16
    btn.TextColor3 = Colors.AppleBlue
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    return btn
end

-- ====================================================================
-- 📂 PAGE 1 : CHEATS PRINCIPAUX
-- ====================================================================
local CheatPage = Instance.new("Frame")
CheatPage.Size = UDim2.new(1, 0, 1, 0)
CheatPage.BackgroundTransparency = 1
CheatPage.Parent = SettingsPanel

local _, TitleGrad = CreateTitle(CheatPage, "S H A D O W")
local FlyBtn = CreateToggleButton(CheatPage, "FLY ✈️", 16, 45)
local LockBtn = CreateToggleButton(CheatPage, "LOCK 🔒", 102, 45)
local SpinBtn = CreateToggleButton(CheatPage, "SPIN 🌪️", 188, 45)

local FlySliderBg, FlySliderFill, FlyLabel, FlyReset = CreateSlider(CheatPage, "Vitesse de Vol", 95, Config.FlySpeed)
local SpinSliderBg, SpinSliderFill, SpinLabel, SpinReset = CreateSlider(CheatPage, "Vitesse de Spin", 145, Config.SpinSpeed)

FlyReset.MouseButton1Click:Connect(function()
    Config.FlySpeed = DefaultConfig.FlySpeed
    FlyLabel.Text = "Vitesse de Vol : " .. Config.FlySpeed
    TweenService:Create(FlySliderFill, AnimBouncy, {Size = UDim2.new(Config.FlySpeed / Config.MaxSpeed, 0, 1, 0)}):Play()
end)
SpinReset.MouseButton1Click:Connect(function()
    Config.SpinSpeed = DefaultConfig.SpinSpeed
    SpinLabel.Text = "Vitesse de Spin : " .. Config.SpinSpeed
    TweenService:Create(SpinSliderFill, AnimBouncy, {Size = UDim2.new(Config.SpinSpeed / Config.MaxSpeed, 0, 1, 0)}):Play()
end)

-- Nouveaux boutons de Navigation Divisés (Bottom)
local ProfileNavBtn = CreateToggleButton(CheatPage, "👤 Profil", 16, 205, 118)
local OtherNavBtn = CreateToggleButton(CheatPage, "⚙️ Autre", 146, 205, 118)

-- ====================================================================
-- 👤 PAGE 2 : PROFIL (CACHÉE À GAUCHE)
-- ====================================================================
local ProfilePage = Instance.new("Frame")
ProfilePage.Size = UDim2.new(1, 0, 1, 0)
ProfilePage.Position = UDim2.new(1, 0, 0, 0)
ProfilePage.BackgroundTransparency = 1
ProfilePage.Parent = SettingsPanel

CreateTitle(ProfilePage, "PROFIL")
local ProfileBackBtn = CreateBackButton(ProfilePage)

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 70, 0, 70)
AvatarImg.Position = UDim2.new(0, 20, 0, 55)
AvatarImg.BackgroundColor3 = Colors.Surface
AvatarImg.Parent = ProfilePage
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    local Content, IsReady = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    if IsReady then AvatarImg.Image = Content end
end)

local InfoContainer = Instance.new("Frame")
InfoContainer.Size = UDim2.new(1, -110, 0, 140)
InfoContainer.Position = UDim2.new(0, 105, 0, 55)
InfoContainer.BackgroundTransparency = 1
InfoContainer.Parent = ProfilePage

local function CreateInfoLabel(text, order)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, (order - 1) * 22)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.AppleSubText
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = InfoContainer
end

CreateInfoLabel("📛 " .. LocalPlayer.Name, 1)
CreateInfoLabel("✨ " .. LocalPlayer.DisplayName, 2)
CreateInfoLabel("🆔 " .. LocalPlayer.UserId, 3)
CreateInfoLabel("📆 " .. LocalPlayer.AccountAge .. " jours", 4)

-- ====================================================================
-- ⚙️ PAGE 3 : AUTRES MODULES (CACHÉE À DROITE)
-- ====================================================================
local OtherPage = Instance.new("Frame")
OtherPage.Size = UDim2.new(1, 0, 1, 0)
OtherPage.Position = UDim2.new(-1, 0, 0, 0)
OtherPage.BackgroundTransparency = 1
OtherPage.Parent = SettingsPanel

local _, OtherGrad = CreateTitle(OtherPage, "A U T R E S")
local OtherBackBtn = CreateBackButton(OtherPage)

local WalkBtn = CreateToggleButton(OtherPage, "SPEED 🏃", 16, 45, 118)
local JumpBtn = CreateToggleButton(OtherPage, "JUMP ⬆️", 146, 45, 118)

local WalkSliderBg, WalkSliderFill, WalkLabel, WalkReset = CreateSlider(OtherPage, "Vitesse", 85, Config.WalkSpeed)
local JumpSliderBg, JumpSliderFill, JumpLabel, JumpReset = CreateSlider(OtherPage, "Saut", 125, Config.JumpPower)

WalkReset.MouseButton1Click:Connect(function()
    Config.WalkSpeed = DefaultConfig.WalkSpeed
    WalkLabel.Text = "Vitesse : " .. Config.WalkSpeed
    TweenService:Create(WalkSliderFill, AnimBouncy, {Size = UDim2.new(Config.WalkSpeed / Config.MaxSpeed, 0, 1, 0)}):Play()
end)
JumpReset.MouseButton1Click:Connect(function()
    Config.JumpPower = DefaultConfig.JumpPower
    JumpLabel.Text = "Saut : " .. Config.JumpPower
    TweenService:Create(JumpSliderFill, AnimBouncy, {Size = UDim2.new(Config.JumpPower / Config.MaxSpeed, 0, 1, 0)}):Play()
end)

local EspNamesBtn = CreateToggleButton(OtherPage, "ESP NOMS 🌈", 16, 175, 118)
local EspChamsBtn = CreateToggleButton(OtherPage, "ESP CHAMS 🌈", 146, 175, 118)

-- ====================================================================
-- 🎚️ LOGIQUE DE NAVIGATION & INTERFACE
-- ====================================================================
GearBtn.MouseButton1Click:Connect(function()
    State.MenuOpen = not State.MenuOpen
    TweenService:Create(GearBtn, AnimBouncy, {Rotation = State.MenuOpen and 90 or 0}):Play()
    if State.MenuOpen then
        SettingsPanel.Visible = true
        TweenService:Create(SettingsPanel, AnimBouncy, {Position = UDim2.new(0.5, -140, 0.85, -280), GroupTransparency = 0}):Play()
    else
        TweenService:Create(SettingsPanel, AnimBouncy, {Position = UDim2.new(0.5, -140, 0.85, -100), GroupTransparency = 1}):Play()
        task.delay(0.4, function() if not State.MenuOpen then SettingsPanel.Visible = false end end)
    end
end)

-- Navigation Profil (Vers la droite)
ProfileNavBtn.MouseButton1Click:Connect(function()
    TweenService:Create(CheatPage, AnimBouncy, {Position = UDim2.new(-1, 0, 0, 0)}):Play()
    TweenService:Create(ProfilePage, AnimBouncy, {Position = UDim2.new(0, 0, 0, 0)}):Play()
end)
ProfileBackBtn.MouseButton1Click:Connect(function()
    TweenService:Create(CheatPage, AnimBouncy, {Position = UDim2.new(0, 0, 0, 0)}):Play()
    TweenService:Create(ProfilePage, AnimBouncy, {Position = UDim2.new(1, 0, 0, 0)}):Play()
end)

-- Navigation Autre (Vers la gauche)
OtherNavBtn.MouseButton1Click:Connect(function()
    TweenService:Create(CheatPage, AnimBouncy, {Position = UDim2.new(1, 0, 0, 0)}):Play()
    TweenService:Create(OtherPage, AnimBouncy, {Position = UDim2.new(0, 0, 0, 0)}):Play()
end)
OtherBackBtn.MouseButton1Click:Connect(function()
    TweenService:Create(CheatPage, AnimBouncy, {Position = UDim2.new(0, 0, 0, 0)}):Play()
    TweenService:Create(OtherPage, AnimBouncy, {Position = UDim2.new(-1, 0, 0, 0)}):Play()
end)

-- GESTION UNIVERSELLE DES SLIDERS
local Dragging = {Fly = false, Spin = false, Walk = false, Jump = false}

local function UpdateSlider(bg, fill, label, prefix, configKey)
    if bg.AbsoluteSize.X == 0 then return end 
    local relativeX = math.clamp(Mouse.X - bg.AbsolutePosition.X, 0, bg.AbsoluteSize.X)
    local percent = relativeX / bg.AbsoluteSize.X
    TweenService:Create(fill, AnimFast, {Size = UDim2.new(percent, 0, 1, 0)}):Play()
    Config[configKey] = math.max(1, math.floor(percent * Config.MaxSpeed))
    label.Text = prefix .. " : " .. Config[configKey]
end

local function BindSlider(bg, fill, label, prefix, dragKey, configKey)
    bg.InputBegan:Connect(function(i)
        if i.UserInputType.Name:match("MouseButton1") or i.UserInputType.Name:match("Touch") then
            Dragging[dragKey] = true
            UpdateSlider(bg, fill, label, prefix, configKey)
        end
    end)
end

BindSlider(FlySliderBg, FlySliderFill, FlyLabel, "Vitesse de Vol", "Fly", "FlySpeed")
BindSlider(SpinSliderBg, SpinSliderFill, SpinLabel, "Vitesse de Spin", "Spin", "SpinSpeed")
BindSlider(WalkSliderBg, WalkSliderFill, WalkLabel, "Vitesse", "Walk", "WalkSpeed")
BindSlider(JumpSliderBg, JumpSliderFill, JumpLabel, "Saut", "Jump", "JumpPower")

UserInputService.InputChanged:Connect(function(i)
    if i.UserInputType.Name:match("MouseMovement") or i.UserInputType.Name:match("Touch") then
        if Dragging.Fly then UpdateSlider(FlySliderBg, FlySliderFill, FlyLabel, "Vitesse de Vol", "FlySpeed") end
        if Dragging.Spin then UpdateSlider(SpinSliderBg, SpinSliderFill, SpinLabel, "Vitesse de Spin", "SpinSpeed") end
        if Dragging.Walk then UpdateSlider(WalkSliderBg, WalkSliderFill, WalkLabel, "Vitesse", "WalkSpeed") end
        if Dragging.Jump then UpdateSlider(JumpSliderBg, JumpSliderFill, JumpLabel, "Saut", "JumpPower") end
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType.Name:match("MouseButton1") or i.UserInputType.Name:match("Touch") then
        for k, v in pairs(Dragging) do Dragging[k] = false end
    end
end)

-- ====================================================================
-- 🚀 LOGIQUE DES BOUTONS D'ACTION
-- ====================================================================
local function UpdateButtonVisual(btn, active)
    TweenService:Create(btn, AnimFast, {
        BackgroundColor3 = active and Colors.AppleBlue or Colors.Surface,
        BackgroundTransparency = active and 0.1 or 0.4
    }):Play()
end

FlyBtn.MouseButton1Click:Connect(function()
    State.Fly = not State.Fly
    UpdateButtonVisual(FlyBtn, State.Fly)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if root and hum then
        hum.PlatformStand = State.Fly
        root.Anchored = State.Fly
    end
end)

LockBtn.MouseButton1Click:Connect(function()
    State.ShiftLock = not State.ShiftLock
    if State.ShiftLock then State.Spin = false; UpdateButtonVisual(SpinBtn, false) end
    UpdateButtonVisual(LockBtn, State.ShiftLock)
end)

SpinBtn.MouseButton1Click:Connect(function()
    State.Spin = not State.Spin
    if State.Spin then State.ShiftLock = false; UpdateButtonVisual(LockBtn, false) end
    UpdateButtonVisual(SpinBtn, State.Spin)
end)

WalkBtn.MouseButton1Click:Connect(function()
    State.Walk = not State.Walk
    UpdateButtonVisual(WalkBtn, State.Walk)
    if not State.Walk and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16 -- Reset par défaut
    end
end)

JumpBtn.MouseButton1Click:Connect(function()
    State.Jump = not State.Jump
    UpdateButtonVisual(JumpBtn, State.Jump)
    if not State.Jump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 50 -- Reset par défaut
    end
end)

EspNamesBtn.MouseButton1Click:Connect(function() State.EspNames = not State.EspNames; UpdateButtonVisual(EspNamesBtn, State.EspNames) end)
EspChamsBtn.MouseButton1Click:Connect(function() State.EspChams = not State.EspChams; UpdateButtonVisual(EspChamsBtn, State.EspChams) end)

-- ====================================================================
-- 🔄 MOTEUR DE RENDU PRINCIPAL (ESP + MOUVEMENTS)
-- ====================================================================
RunService:BindToRenderStep("ShadowRenderEngine", Enum.RenderPriority.Camera.Value - 1, function(deltaTime)
    -- Effets Arc-en-Ciel Généraux
    local rainbowColor = Color3.fromHSV((tick() % 3) / 3, 1, 1)
    TitleGrad.Rotation = (TitleGrad.Rotation + 1.5) % 360
    OtherGrad.Rotation = (OtherGrad.Rotation + 1.5) % 360

    -- Gestion du Joueur Local
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local cam = workspace.CurrentCamera

    -- Overrides Vitesse / Saut Constants (Anti-Cheat bypass)
    if hum then
        if State.Walk then hum.WalkSpeed = Config.WalkSpeed end
        if State.Jump then 
            hum.UseJumpPower = true 
            hum.JumpPower = Config.JumpPower 
        end
    end

    if root and cam then
        if State.Fly then
            local moveDir = Controls and Controls:GetMoveVector() or Vector3.zero
            local look = cam.CFrame.LookVector
            local right = cam.CFrame.RightVector
            
            local direction = (look * -moveDir.Z) + (right * moveDir.X)
            if direction.Magnitude > 0 then direction = direction.Unit end

            local displacement = direction * (Config.FlySpeed * deltaTime)
            local newPos = root.Position + displacement

            if State.Spin then
                State.SpinAngle = State.SpinAngle + (Config.SpinSpeed * deltaTime * 3)
                root.CFrame = CFrame.new(newPos) * CFrame.Angles(0, math.rad(State.SpinAngle), 0)
            elseif State.ShiftLock then
                root.CFrame = CFrame.lookAt(newPos, Vector3.new(newPos.X + look.X, newPos.Y, newPos.Z + look.Z))
            else
                root.CFrame = CFrame.new(newPos) * cam.CFrame.Rotation
            end
        else
            if State.Spin then
                if hum then hum.AutoRotate = false end
                State.SpinAngle = State.SpinAngle + (Config.SpinSpeed * deltaTime * 2)
                root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Config.SpinSpeed * deltaTime), 0)
            elseif State.ShiftLock then
                if hum then hum.AutoRotate = false end
                local look = cam.CFrame.LookVector
                root.CFrame = CFrame.lookAt(root.Position, Vector3.new(root.Position.X + look.X, root.Position.Y, root.Position.Z + look.Z))
            else
                if hum then hum.AutoRotate = true end
            end
        end
    end

    -- =================================================================
    -- 👁️ GESTION DU SYSTÈME ESP (NOMS & CHAMS) EN TEMPS RÉEL
    -- =================================================================
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local pChar = player.Character
            local pHum = pChar:FindFirstChildOfClass("Humanoid")
            
            -- LOGIQUE ESP NOMS RAINBOW
            if State.EspNames then
                if pHum then pHum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end -- Cache le vrai nom
                local espName = pChar.Head:FindFirstChild("ShadowESP_Name")
                if not espName then
                    espName = Instance.new("BillboardGui")
                    espName.Name = "ShadowESP_Name"
                    espName.Size = UDim2.new(0, 200, 0, 50)
                    espName.StudsOffset = Vector3.new(0, 3, 0)
                    espName.AlwaysOnTop = true
                    
                    local txt = Instance.new("TextLabel", espName)
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.Font = Enum.Font.GothamBold
                    txt.TextSize = 14
                    txt.Text = player.DisplayName .. " (@" .. player.Name .. ")"
                    txt.TextStrokeTransparency = 0 -- Contour noir pour bien lire
                    
                    espName.Parent = pChar.Head
                end
                espName.TextLabel.TextColor3 = rainbowColor -- Applique l'arc-en-ciel
            else
                if pHum then pHum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer end -- Remet le vrai nom
                local espName = pChar.Head:FindFirstChild("ShadowESP_Name")
                if espName then espName:Destroy() end
            end

            -- LOGIQUE ESP CHAMS RAINBOW (X-RAY)
            if State.EspChams then
                local cham = pChar:FindFirstChild("ShadowESP_Cham")
                if not cham then
                    cham = Instance.new("Highlight")
                    cham.Name = "ShadowESP_Cham"
                    cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Visible à travers TOUS les murs
                    cham.FillTransparency = 0.5
                    cham.OutlineTransparency = 0.1
                    cham.Parent = pChar
                end
                cham.FillColor = rainbowColor
                cham.OutlineColor = rainbowColor
            else
                local cham = pChar:FindFirstChild("ShadowESP_Cham")
                if cham then cham:Destroy() end
            end
        end
    end
end)
