-- ====================================================================
-- 🍏 SHADOW VIP v11.5 : ANTI-KICK BYPASS, RESET BUTTON & APPLE DESIGN
-- ====================================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
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
    SpinAngle = 0
}

local DefaultConfig = {
    FlySpeed = 100,
    SpinSpeed = 500
}

local Config = {
    FlySpeed = DefaultConfig.FlySpeed,
    SpinSpeed = DefaultConfig.SpinSpeed,
    MaxSpeed = 5000
}

local Controls
pcall(function()
    local PlayerModule = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
    Controls = PlayerModule:GetControls()
end)

-- Moteurs d'animations (Style iOS très fluide)
local AnimBouncy = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local AnimSmooth = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local AnimFast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local Colors = {
    GlassBG = Color3.fromRGB(20, 20, 25),
    Surface = Color3.fromRGB(40, 40, 45),
    AppleBlue = Color3.fromRGB(10, 132, 255),
    AppleText = Color3.fromRGB(240, 240, 245),
    AppleSubText = Color3.fromRGB(160, 160, 170),
    AppleRed = Color3.fromRGB(255, 59, 48)
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

-- Effets Hover
GearBtn.MouseEnter:Connect(function()
    TweenService:Create(GearBtn, AnimFast, {Size = UDim2.new(0, 54, 0, 54), Position = UDim2.new(0.5, -27, 0.85, -2), BackgroundTransparency = 0.15}):Play()
end)
GearBtn.MouseLeave:Connect(function()
    TweenService:Create(GearBtn, AnimFast, {Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0.5, -25, 0.85, 0), BackgroundTransparency = 0.3}):Play()
end)

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

-- ====================================================================
-- 📂 PAGE 1 : CHEATS & UTILITIES
-- ====================================================================
local CheatPage = Instance.new("Frame")
CheatPage.Size = UDim2.new(1, 0, 1, 0)
CheatPage.BackgroundTransparency = 1
CheatPage.Parent = SettingsPanel

local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Size = UDim2.new(1, 0, 0, 40)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Text = "S H A D O W"
SettingsTitle.TextColor3 = Colors.AppleText
SettingsTitle.Font = Enum.Font.GothamBold
SettingsTitle.TextSize = 14
SettingsTitle.Parent = CheatPage

local function CreateToggleButton(text, posX, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 76, 0, 36)
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.BackgroundColor3 = Colors.Surface
    btn.BackgroundTransparency = 0.4
    btn.Text = text
    btn.TextColor3 = Colors.AppleText
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.AutoButtonColor = false
    btn.Parent = CheatPage
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    return btn
end

local FlyBtn = CreateToggleButton("FLY ✈️", 16, 45)
local LockBtn = CreateToggleButton("LOCK 🔒", 102, 45)
local SpinBtn = CreateToggleButton("SPIN 🌪️", 188, 45)

local function CreateSlider(titleText, posY, defaultVal)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -32, 0, 15)
    label.Position = UDim2.new(0, 16, 0, posY)
    label.BackgroundTransparency = 1
    label.Text = titleText .. " : " .. defaultVal
    label.TextColor3 = Colors.AppleSubText
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = CheatPage

    local bg = Instance.new("TextButton")
    bg.Size = UDim2.new(1, -32, 0, 10)
    bg.Position = UDim2.new(0, 16, 0, posY + 20)
    bg.BackgroundColor3 = Colors.Surface
    bg.Text = ""
    bg.AutoButtonColor = false
    bg.Parent = CheatPage
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(defaultVal / Config.MaxSpeed, 0, 1, 0)
    fill.BackgroundColor3 = Colors.AppleBlue
    fill.Parent = bg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    return bg, fill, label
end

local FlySliderBg, FlySliderFill, FlyLabel = CreateSlider("Vitesse de Vol", 95, Config.FlySpeed)
local SpinSliderBg, SpinSliderFill, SpinLabel = CreateSlider("Vitesse de Spin", 145, Config.SpinSpeed)

-- 🔄 BOUTON RESET VITESSE DE VOL 🔄
local ResetFlyBtn = Instance.new("TextButton")
ResetFlyBtn.Size = UDim2.new(0, 45, 0, 15)
ResetFlyBtn.Position = UDim2.new(1, -45, 0, 0) -- Collé à droite du FlyLabel
ResetFlyBtn.BackgroundTransparency = 1
ResetFlyBtn.Text = "RESET ↺"
ResetFlyBtn.TextColor3 = Colors.AppleBlue
ResetFlyBtn.Font = Enum.Font.GothamBold
ResetFlyBtn.TextSize = 10
ResetFlyBtn.Parent = FlyLabel

-- Animation et logique du bouton Reset
ResetFlyBtn.MouseEnter:Connect(function() TweenService:Create(ResetFlyBtn, AnimFast, {TextColor3 = Colors.AppleText}):Play() end)
ResetFlyBtn.MouseLeave:Connect(function() TweenService:Create(ResetFlyBtn, AnimFast, {TextColor3 = Colors.AppleBlue}):Play() end)
ResetFlyBtn.MouseButton1Click:Connect(function()
    Config.FlySpeed = DefaultConfig.FlySpeed
    FlyLabel.Text = "Vitesse de Vol : " .. Config.FlySpeed
    TweenService:Create(FlySliderFill, AnimBouncy, {Size = UDim2.new(Config.FlySpeed / Config.MaxSpeed, 0, 1, 0)}):Play()
end)

local ProfileNavBtn = CreateToggleButton("👤 Profil", 16, 205)
ProfileNavBtn.Size = UDim2.new(1, -32, 0, 36)
ProfileNavBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)

-- ====================================================================
-- 👤 PAGE 2 : PROFIL (CACHÉE)
-- ====================================================================
local ProfilePage = Instance.new("Frame")
ProfilePage.Size = UDim2.new(1, 0, 1, 0)
ProfilePage.Position = UDim2.new(1, 0, 0, 0)
ProfilePage.BackgroundTransparency = 1
ProfilePage.Parent = SettingsPanel

local ProfileTitle = Instance.new("TextLabel")
ProfileTitle.Size = UDim2.new(1, 0, 0, 40)
ProfileTitle.BackgroundTransparency = 1
ProfileTitle.Text = "PROFIL"
ProfileTitle.TextColor3 = Colors.AppleText
ProfileTitle.Font = Enum.Font.GothamBold
ProfileTitle.TextSize = 14
ProfileTitle.Parent = ProfilePage

local BackBtn = Instance.new("TextButton")
BackBtn.Size = UDim2.new(0, 30, 0, 30)
BackBtn.Position = UDim2.new(0, 12, 0, 5)
BackBtn.BackgroundTransparency = 1
BackBtn.Text = "⬅" 
BackBtn.TextSize = 16
BackBtn.TextColor3 = Colors.AppleBlue
BackBtn.Font = Enum.Font.GothamBold
BackBtn.Parent = ProfilePage

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
-- ⚙️ LOGIQUE INTERFACE & ANIMATIONS
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

ProfileNavBtn.MouseButton1Click:Connect(function()
    TweenService:Create(CheatPage, AnimBouncy, {Position = UDim2.new(-1, 0, 0, 0)}):Play()
    TweenService:Create(ProfilePage, AnimBouncy, {Position = UDim2.new(0, 0, 0, 0)}):Play()
end)

BackBtn.MouseButton1Click:Connect(function()
    TweenService:Create(CheatPage, AnimBouncy, {Position = UDim2.new(0, 0, 0, 0)}):Play()
    TweenService:Create(ProfilePage, AnimBouncy, {Position = UDim2.new(1, 0, 0, 0)}):Play()
end)

-- Gestion Sliders Fluide
local function HandleSlider(Input, Bg, Fill, Label, Prefix, ConfigKey)
    local Pos = math.clamp((Input.Position.X - Bg.AbsolutePosition.X) / Bg.AbsoluteSize.X, 0, 1)
    TweenService:Create(Fill, AnimFast, {Size = UDim2.new(Pos, 0, 1, 0)}):Play()
    Config[ConfigKey] = math.max(1, math.floor(Pos * Config.MaxSpeed))
    Label.Text = Prefix .. " : " .. Config[ConfigKey]
end

local DraggingFly, DraggingSpin = false, false
FlySliderBg.InputBegan:Connect(function(i) if i.UserInputType.Name:match("MouseButton1") then DraggingFly = true; HandleSlider(i, FlySliderBg, FlySliderFill, FlyLabel, "Vitesse de Vol", "FlySpeed") end end)
SpinSliderBg.InputBegan:Connect(function(i) if i.UserInputType.Name:match("MouseButton1") then DraggingSpin = true; HandleSlider(i, SpinSliderBg, SpinSliderFill, SpinLabel, "Vitesse de Spin", "SpinSpeed") end end)

UserInputService.InputChanged:Connect(function(i)
    if i.UserInputType.Name:match("MouseMovement") then
        if DraggingFly then HandleSlider(i, FlySliderBg, FlySliderFill, FlyLabel, "Vitesse de Vol", "FlySpeed") end
        if DraggingSpin then HandleSlider(i, SpinSliderBg, SpinSliderFill, SpinLabel, "Vitesse de Spin", "SpinSpeed") end
    end
end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType.Name:match("MouseButton1") then DraggingFly, DraggingSpin = false, false end end)

-- ====================================================================
-- 🚀 MOTEUR DE VOL "ANCHORED" AVEC BYPASS CAMÉRA JITTER
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

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if root and hum then
        if State.Fly then
            hum.PlatformStand = true
            root.Anchored = true -- Sécurité 100% Anti-Kick (Aucune Vélocité réelle)
        else
            hum.PlatformStand = false
            root.Anchored = false
        end
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

-- MOTEUR PHYSIQUE PRIORITAIRE (BindToRenderStep au lieu de RenderStepped)
-- L'astuce : Enum.RenderPriority.Camera.Value - 1 force ton personnage à bouger
-- EXACTEMENT avant que la caméra ne calcule sa position. Zéro tremblement !
RunService:BindToRenderStep("ShadowRenderEngine", Enum.RenderPriority.Camera.Value - 1, function(deltaTime)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local cam = workspace.CurrentCamera

    if not root or not cam then return end

    if State.Fly then
        local moveDir = Controls and Controls:GetMoveVector() or Vector3.zero
        local look = cam.CFrame.LookVector
        local right = cam.CFrame.RightVector
        
        -- Calcul de la direction (-moveDir.Z car Z négatif = avant)
        local direction = (look * -moveDir.Z) + (right * moveDir.X)
        if direction.Magnitude > 0 then
            direction = direction.Unit
        end

        local displacement = direction * (Config.FlySpeed * deltaTime)
        local newPos = root.Position + displacement

        -- Application fluide des CFrame
        if State.Spin then
            State.SpinAngle = State.SpinAngle + (Config.SpinSpeed * deltaTime * 3)
            root.CFrame = CFrame.new(newPos) * CFrame.Angles(0, math.rad(State.SpinAngle), 0)
        elseif State.ShiftLock then
            root.CFrame = CFrame.lookAt(newPos, Vector3.new(newPos.X + look.X, newPos.Y, newPos.Z + look.Z))
        else
            -- Suit la rotation de la caméra au millimètre près
            root.CFrame = CFrame.new(newPos) * cam.CFrame.Rotation
        end

    elseif not State.Fly then
        -- Comportement au sol
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
end)
