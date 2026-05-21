-- ====================================================================
-- 🦇 SHADOW VIP v10.0 : COMFORT UI, DOUBLE SLIDERS & PROFILE PAGE
-- ====================================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local CoreLocation = (gethui and gethui()) or game:GetService("CoreGui")

-- Nettoyage strict des anciennes instances
for _, v in pairs(CoreLocation:GetChildren()) do
    if v.Name:match("PremiumFly_") then v:Destroy() end
end

-- Variables Globales
local FlyEnabled = false
local SpinEnabled = false
local ShiftLockEnabled = false

local FlySpeed = 70
local SpinSpeed = 500

local Controls
pcall(function()
    local PlayerModule = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
    Controls = PlayerModule:GetControls()
end)

-- Moteurs d'animations
local AnimSmooth = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local AnimFast = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- ====================================================================
-- 1. CRÉATION DE L'INTERFACE UNIQUE
-- ====================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumFly_" .. HttpService:GenerateGUID(false)
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreLocation

-- Bouton d'ancrage principal (Seul bouton visible sur l'écran de jeu)
local GearBtn = Instance.new("TextButton")
GearBtn.Size = UDim2.new(0, 52, 0, 52)
GearBtn.Position = UDim2.new(0.5, -26, 0.85, 0)
GearBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
GearBtn.BackgroundTransparency = 0.25
GearBtn.Text = "⚙️"
GearBtn.TextSize = 22
GearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GearBtn.Font = Enum.Font.GothamBold
GearBtn.AutoButtonColor = false
GearBtn.Parent = ScreenGui

Instance.new("UICorner", GearBtn).CornerRadius = UDim.new(0, 16)
local GearStroke = Instance.new("UIStroke", GearBtn)
GearStroke.Color = Color3.fromRGB(255, 255, 255)
GearStroke.Thickness = 1.5

-- HOVER EFFECTS PREMIUM
GearBtn.MouseEnter:Connect(function()
    TweenService:Create(GearBtn, AnimFast, {Size = UDim2.new(0, 56, 0, 56), Position = UDim2.new(0.5, -28, 0.85, -2), BackgroundTransparency = 0.1}):Play()
end)
GearBtn.MouseLeave:Connect(function()
    TweenService:Create(GearBtn, AnimFast, {Size = UDim2.new(0, 52, 0, 52), Position = UDim2.new(0.5, -26, 0.85, 0), BackgroundTransparency = 0.25}):Play()
end)

-- ====================================================================
-- 2. PANNEAU CENTRAL SHADOW (STRUCTURE MULTI-PAGES)
-- ====================================================================
local SettingsPanel = Instance.new("CanvasGroup")
SettingsPanel.Size = UDim2.new(0, 270, 0, 250) -- Taille idéale pour caler confortablement toutes les options
SettingsPanel.Position = UDim2.new(0.5, -135, 0.85, -130)
SettingsPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
SettingsPanel.BackgroundTransparency = 0.15
SettingsPanel.GroupTransparency = 1 
SettingsPanel.Visible = false
SettingsPanel.Parent = ScreenGui

Instance.new("UICorner", SettingsPanel).CornerRadius = UDim.new(0, 20)
local PanelStroke = Instance.new("UIStroke", SettingsPanel)
PanelStroke.Color = Color3.fromRGB(255, 255, 255)
PanelStroke.Thickness = 1.2
PanelStroke.Transparency = 0.5

-- Éclairage d'ambiance en arrière-plan (Glow Néon Violet)
local Glow = Instance.new("ImageLabel")
Glow.Size = UDim2.new(1, 40, 1, 40)
Glow.Position = UDim2.new(0, -20, 0, -20)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://5028857084"
Glow.ImageTransparency = 0.5
Glow.ScaleType = Enum.ScaleType.Slice
Glow.SliceCenter = Rect.new(24, 24, 276, 276)
Glow.ImageColor3 = Color3.fromRGB(140, 20, 255)
Glow.ZIndex = 0
Glow.Parent = SettingsPanel

-- ====================================================================
-- 📂 PAGE 1 : CHEATS & UTILITIES (ONGLET PRINCIPAL)
-- ====================================================================
local CheatPage = Instance.new("Frame")
CheatPage.Size = UDim2.new(1, 0, 1, 0)
CheatPage.BackgroundTransparency = 1
CheatPage.Parent = SettingsPanel

local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Size = UDim2.new(1, 0, 0, 35)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Text = "S H A D O W  U L T I M A T E"
SettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsTitle.Font = Enum.Font.GothamBlack
SettingsTitle.TextSize = 14
SettingsTitle.Parent = CheatPage

local TitleGradient = Instance.new("UIGradient", SettingsTitle)
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 30, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 30, 255))
})

-- --- CONFIGURATION DES 3 BOUTONS DU HAUT ---
local FlyBtn = Instance.new("TextButton")
FlyBtn.Size = UDim2.new(0, 74, 0, 32)
FlyBtn.Position = UDim2.new(0, 12, 0, 42)
FlyBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
FlyBtn.Text = "FLY ✈️"
FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyBtn.Font = Enum.Font.GothamBold
FlyBtn.TextSize = 10
FlyBtn.AutoButtonColor = false
FlyBtn.Parent = CheatPage
Instance.new("UICorner", FlyBtn).CornerRadius = UDim.new(0, 8)
local StrokeFly = Instance.new("UIStroke", FlyBtn)
StrokeFly.Color = Color3.fromRGB(45, 45, 55)

local LockBtn = Instance.new("TextButton")
LockBtn.Size = UDim2.new(0, 74, 0, 32)
LockBtn.Position = UDim2.new(0.5, -37, 0, 42)
LockBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
LockBtn.Text = "LOCK 🔒"
LockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LockBtn.Font = Enum.Font.GothamBold
LockBtn.TextSize = 10
LockBtn.AutoButtonColor = false
LockBtn.Parent = CheatPage
Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0, 8)
local StrokeLock = Instance.new("UIStroke", LockBtn)
StrokeLock.Color = Color3.fromRGB(45, 45, 55)

local SpinBtn = Instance.new("TextButton")
SpinBtn.Size = UDim2.new(0, 74, 0, 32)
SpinBtn.Position = UDim2.new(1, -86, 0, 42)
SpinBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
SpinBtn.Text = "SPIN 🌪️"
SpinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpinBtn.Font = Enum.Font.GothamBold
SpinBtn.TextSize = 10
SpinBtn.AutoButtonColor = false
SpinBtn.Parent = CheatPage
Instance.new("UICorner", SpinBtn).CornerRadius = UDim.new(0, 8)
local StrokeSpin = Instance.new("UIStroke", SpinBtn)
StrokeSpin.Color = Color3.fromRGB(45, 45, 55)

-- --- SLIDER 1 : SEPARATE FLY SPEED ---
local FlyLabel = Instance.new("TextLabel")
FlyLabel.Size = UDim2.new(1, -24, 0, 15)
FlyLabel.Position = UDim2.new(0, 12, 0, 90)
FlyLabel.BackgroundTransparency = 1
FlyLabel.Text = "FLY SPEED // " .. FlySpeed
FlyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
FlyLabel.Font = Enum.Font.GothamBold
FlyLabel.TextSize = 10
FlyLabel.TextXAlignment = Enum.TextXAlignment.Left
FlyLabel.Parent = CheatPage

local FlySliderBg = Instance.new("TextButton")
FlySliderBg.Size = UDim2.new(1, -24, 0, 8)
FlySliderBg.Position = UDim2.new(0, 12, 0, 110)
FlySliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
FlySliderBg.Text = ""
FlySliderBg.AutoButtonColor = false
FlySliderBg.Parent = CheatPage
Instance.new("UICorner", FlySliderBg).CornerRadius = UDim.new(1, 0)

local FlySliderFill = Instance.new("Frame")
FlySliderFill.Size = UDim2.new(FlySpeed/9999, 0, 1, 0)
FlySliderFill.BackgroundColor3 = Color3.fromRGB(255, 30, 100)
FlySliderFill.Parent = FlySliderBg
Instance.new("UICorner", FlySliderFill).CornerRadius = UDim.new(1, 0)

-- --- SLIDER 2 : SEPARATE SPIN SPEED ---
local SpinLabel = Instance.new("TextLabel")
SpinLabel.Size = UDim2.new(1, -24, 0, 15)
SpinLabel.Position = UDim2.new(0, 12, 0, 132)
SpinLabel.BackgroundTransparency = 1
SpinLabel.Text = "SPIN SPEED // " .. SpinSpeed
SpinLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpinLabel.Font = Enum.Font.GothamBold
SpinLabel.TextSize = 10
SpinLabel.TextXAlignment = Enum.TextXAlignment.Left
SpinLabel.Parent = CheatPage

local SpinSliderBg = Instance.new("TextButton")
SpinSliderBg.Size = UDim2.new(1, -24, 0, 8)
SpinSliderBg.Position = UDim2.new(0, 12, 0, 152)
SpinSliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
SpinSliderBg.Text = ""
SpinSliderBg.AutoButtonColor = false
SpinSliderBg.Parent = CheatPage
Instance.new("UICorner", SpinSliderBg).CornerRadius = UDim.new(1, 0)

local SpinSliderFill = Instance.new("Frame")
SpinSliderFill.Size = UDim2.new(SpinSpeed/9999, 0, 1, 0)
SpinSliderFill.BackgroundColor3 = Color3.fromRGB(140, 30, 255)
SpinSliderFill.Parent = SpinSliderBg
Instance.new("UICorner", SpinSliderFill).CornerRadius = UDim.new(1, 0)

-- --- ZONE BAS : BOUTON ACCÈS PROFIL ---
local ProfileNavBtn = Instance.new("TextButton")
ProfileNavBtn.Size = UDim2.new(0, 110, 0, 30)
ProfileNavBtn.Position = UDim2.new(0, 12, 1, -42)
ProfileNavBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
ProfileNavBtn.Text = "👤 MON PROFIL"
ProfileNavBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
ProfileNavBtn.Font = Enum.Font.GothamBold
ProfileNavBtn.TextSize = 10
ProfileNavBtn.AutoButtonColor = false
ProfileNavBtn.Parent = CheatPage
Instance.new("UICorner", ProfileNavBtn).CornerRadius = UDim.new(0, 8)
local StrokeProfileBtn = Instance.new("UIStroke", ProfileNavBtn)
StrokeProfileBtn.Color = Color3.fromRGB(60, 60, 75)

-- ====================================================================
-- 👤 PAGE 2 : USER PROFILE (L'ONGLET CACHÉ)
-- ====================================================================
local ProfilePage = Instance.new("Frame")
ProfilePage.Size = UDim2.new(1, 0, 1, 0)
ProfilePage.Position = UDim2.new(1, 0, 0, 0) -- Décalé par défaut sur la droite
ProfilePage.BackgroundTransparency = 1
ProfilePage.Parent = SettingsPanel

local ProfileTitle = Instance.new("TextLabel")
ProfileTitle.Size = UDim2.new(1, 0, 0, 35)
ProfileTitle.BackgroundTransparency = 1
ProfileTitle.Text = "ACCOUNT PROFILE"
ProfileTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ProfileTitle.Font = Enum.Font.GothamBlack
ProfileTitle.TextSize = 13
ProfileTitle.Parent = ProfilePage

-- Bouton Retour (⬅️)
local BackBtn = Instance.new("TextButton")
BackBtn.Size = UDim2.new(0, 28, 0, 28)
BackBtn.Position = UDim2.new(0, 12, 0, 5)
BackBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
BackBtn.Text = "⬅️"
BackBtn.TextSize = 11
BackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BackBtn.AutoButtonColor = false
BackBtn.Parent = ProfilePage
Instance.new("UICorner", BackBtn).CornerRadius = UDim.new(0, 6)

-- Image de Profil Circulaire (Avatar Headshot)
local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 64, 0, 64)
AvatarImg.Position = UDim2.new(0, 16, 0, 50)
AvatarImg.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
AvatarImg.Parent = ProfilePage
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)
local StrokeAvatar = Instance.new("UIStroke", AvatarImg)
StrokeAvatar.Color = Color3.fromRGB(140, 30, 255)
StrokeAvatar.Thickness = 1.5

-- Injection synchrone de l'avatar réel
task.spawn(function()
    local Type = Enum.ThumbnailType.HeadShot
    local Size = Enum.ThumbnailSize.Size100x100
    local Content, IsReady = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Type, Size)
    if IsReady then AvatarImg.Image = Content end
end)

-- Conteneur d'informations textuelles alignées
local InfoContainer = Instance.new("Frame")
InfoContainer.Size = UDim2.new(1, -104, 0, 140)
InfoContainer.Position = UDim2.new(0, 92, 0, 50)
InfoContainer.BackgroundTransparency = 1
InfoContainer.Parent = ProfilePage

local function CreateInfoLabel(text, order)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, (order - 1) * 24)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = InfoContainer
    return label
end

CreateInfoLabel("📛 NAME: @" .. LocalPlayer.Name, 1)
CreateInfoLabel("✨ DISPLAY: " .. LocalPlayer.DisplayName, 2)
CreateInfoLabel("🆔 USER ID: " .. LocalPlayer.UserId, 3)
CreateInfoLabel("📆 AGE: " .. LocalPlayer.AccountAge .. " jours", 4)
local PlatLabel = CreateInfoLabel("📱 ENGINE: Premium Exec", 5)
PlatLabel.TextColor3 = Color3.fromRGB(0, 200, 255)

-- ====================================================================
-- 3. LOGIQUE INTERACTIVE DU MENU ET NAVIGATION SLIDERS
-- ====================================================================

-- Rotation constante du dégradé de titre
RunService.RenderStepped:Connect(function()
    TitleGradient.Rotation = (TitleGradient.Rotation + 1.2) % 360
end)

-- Animation d'Ouverture / Fermeture Générale du Panneau
local MenuOpen = false
GearBtn.MouseButton1Click:Connect(function()
    MenuOpen = not MenuOpen
    TweenService:Create(GearBtn, AnimSmooth, {Rotation = MenuOpen and 180 or 0}):Play()

    if MenuOpen then
        SettingsPanel.Visible = true
        TweenService:Create(SettingsPanel, AnimSmooth, {Position = UDim2.new(0.5, -135, 0.85, -265), GroupTransparency = 0}):Play()
    else
        TweenService:Create(SettingsPanel, AnimSmooth, {Position = UDim2.new(0.5, -135, 0.85, -130), GroupTransparency = 1}):Play()
        task.delay(0.3, function() if not MenuOpen then SettingsPanel.Visible = false end end)
    end
end)

-- Navigation : Aller vers la page Profil
ProfileNavBtn.MouseButton1Click:Connect(function()
    TweenService:Create(CheatPage, AnimSmooth, {Position = UDim2.new(-1, 0, 0, 0)}):Play()
    TweenService:Create(ProfilePage, AnimSmooth, {Position = UDim2.new(0, 0, 0, 0)}):Play()
end)

-- Navigation : Revenir vers la page Tricherie
BackBtn.MouseButton1Click:Connect(function()
    TweenService:Create(CheatPage, AnimSmooth, {Position = UDim2.new(0, 0, 0, 0)}):Play()
    TweenService:Create(ProfilePage, AnimSmooth, {Position = UDim2.new(1, 0, 0, 0)}):Play()
end)

-- --- LOGIQUE INDÉPENDANTE DES SLIDERS ---
local FlyDragging = false
local SpinDragging = false

local function UpdateFlySlider(input)
    local pos = math.clamp((input.Position.X - FlySliderBg.AbsolutePosition.X) / FlySliderBg.AbsoluteSize.X, 0, 1)
    FlySliderFill.Size = UDim2.new(pos, 0, 1, 0)
    FlySpeed = math.floor(pos * 9999)
    if FlySpeed < 1 then FlySpeed = 1 end
    FlyLabel.Text = "FLY SPEED // " .. FlySpeed
end

local function UpdateSpinSlider(input)
    local pos = math.clamp((input.Position.X - SpinSliderBg.AbsolutePosition.X) / SpinSliderBg.AbsoluteSize.X, 0, 1)
    SpinSliderFill.Size = UDim2.new(pos, 0, 1, 0)
    SpinSpeed = math.floor(pos * 9999)
    if SpinSpeed < 1 then SpinSpeed = 1 end
    SpinLabel.Text = "SPIN SPEED // " .. SpinSpeed
end

-- Attachements Input Fly Slider
FlySliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        FlyDragging = true UpdateFlySlider(input)
    end
end)
-- Attachements Input Spin Slider
SpinSliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        SpinDragging = true UpdateSpinSlider(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        FlyDragging = false 
        SpinDragging = false 
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if FlyDragging then UpdateFlySlider(input) end
        if SpinDragging then UpdateSpinSlider(input) end
    end
end)

-- ====================================================================
-- 4. LOGIQUE D'ACTION DES COMMANDES INTERNES
-- ====================================================================

-- Interrupteur VOL (FLY)
FlyBtn.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")

    if FlyEnabled then
        TweenService:Create(FlyBtn, AnimFast, {BackgroundColor3 = Color3.fromRGB(255, 30, 100)}):Play()
        if Humanoid then Humanoid.PlatformStand = true end
        if Root then Root.Anchored = true end
    else
        TweenService:Create(FlyBtn, AnimFast, {BackgroundColor3 = Color3.fromRGB(22, 22, 28)}):Play()
        if Humanoid then Humanoid.PlatformStand = false end
        if Root then Root.Anchored = false end
    end
end)

-- Interrupteur SHIFT LOCK
LockBtn.MouseButton1Click:Connect(function()
    ShiftLockEnabled = not ShiftLockEnabled
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    
    if ShiftLockEnabled then
        SpinEnabled = false
        TweenService:Create(SpinBtn, AnimFast, {BackgroundColor3 = Color3.fromRGB(22, 22, 28)}):Play()
        TweenService:Create(LockBtn, AnimFast, {BackgroundColor3 = Color3.fromRGB(0, 122, 255)}):Play()
        if Humanoid then Humanoid.AutoRotate = false end
    else
        TweenService:Create(LockBtn, AnimFast, {BackgroundColor3 = Color3.fromRGB(22, 22, 28)}):Play()
        if Humanoid then Humanoid.AutoRotate = true end
    end
end)

-- Interrupteur SPIN BOT
SpinBtn.MouseButton1Click:Connect(function()
    SpinEnabled = not SpinEnabled
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if SpinEnabled then
        ShiftLockEnabled = false
        TweenService:Create(LockBtn, AnimFast, {BackgroundColor3 = Color3.fromRGB(22, 22, 28)}):Play()
        TweenService:Create(SpinBtn, AnimFast, {BackgroundColor3 = Color3.fromRGB(140, 30, 255)}):Play()
        if Humanoid then Humanoid.AutoRotate = false end
    else
        TweenService:Create(SpinBtn, AnimFast, {BackgroundColor3 = Color3.fromRGB(22, 22, 28)}):Play()
        if Humanoid then Humanoid.AutoRotate = true end
    end
end)

-- ====================================================================
-- 5. MOTEUR RENDU PHYSIQUE (DÉPLACEMENT & ROTATION CALCULÉS)
-- ====================================================================
RunService.RenderStepped:Connect(function(deltaTime)
    local Character = LocalPlayer.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")
    local Camera = workspace.CurrentCamera

    if Root and Camera then
        local LookVector = Camera.CFrame.LookVector
        
        if FlyEnabled then
            local MoveVector = Vector3.new(0, 0, 0)
            if Controls then MoveVector = Controls:GetMoveVector() end

            local Direction = (Camera.CFrame.LookVector * -MoveVector.Z) + (Camera.CFrame.RightVector * MoveVector.X)
            local Displacement = Direction.Unit * (FlySpeed * deltaTime)
            
            local newPos = Root.Position
            if Direction.Magnitude > 0 then newPos = Root.Position + Displacement end
            
            if SpinEnabled then
                -- Applique la vitesse du SpinSlider distinct lors du vol
                Root.CFrame = CFrame.new(newPos) * (Root.CFrame - Root.Position) * CFrame.Angles(0, math.rad(SpinSpeed * deltaTime * 3), 0)
            elseif ShiftLockEnabled then
                Root.CFrame = CFrame.new(newPos, Vector3.new(newPos.X + LookVector.X, newPos.Y, newPos.Z + LookVector.Z))
            else
                Root.CFrame = CFrame.new(newPos) * CFrame.fromEulerAnglesXYZ(Camera.CFrame:ToEulerAnglesXYZ())
            end
        else
            -- Si on est au sol
            if SpinEnabled then
                -- Applique la vitesse du SpinSlider distinct lors de la marche au sol
                Root.CFrame = Root.CFrame * CFrame.Angles(0, math.rad(SpinSpeed * deltaTime * 5), 0)
            elseif ShiftLockEnabled then
                Root.CFrame = CFrame.new(Root.Position, Vector3.new(Root.Position.X + LookVector.X, Root.Position.Y, Root.Position.Z + LookVector.Z))
            end
        end
    end
end)
