-- ====================================================================
-- 🦇 SHADOW FLY v8.1 : SÉCURISÉ, FLUIDE ET 100% FONCTIONNEL
-- ====================================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local CoreLocation = (gethui and gethui()) or game:GetService("CoreGui")

-- Nettoyage des anciennes versions pour éviter les conflits
for _, v in pairs(CoreLocation:GetChildren()) do
    if v.Name:match("PremiumFly_") then v:Destroy() end
end

-- Variables Globales
local FlyEnabled = false
local FlySpeed = 70
local NoclipEnabled = true
local OriginalCollisions = {} 

local Controls
pcall(function()
    local PlayerModule = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
    Controls = PlayerModule:GetControls()
end)

-- Paramètres d'animations
local AnimSmooth = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local AnimFast = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- ====================================================================
-- 1. CRÉATION UI
-- ====================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumFly_" .. HttpService:GenerateGUID(false)
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreLocation

-- Bouton principal FLY
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 100, 0, 42)
ToggleBtn.Position = UDim2.new(0.5, -70, 0.85, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleBtn.BackgroundTransparency = 0.35
ToggleBtn.Text = "FLY : OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.Parent = ScreenGui

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 12)
local BtnStroke = Instance.new("UIStroke", ToggleBtn)
BtnStroke.Color = Color3.fromRGB(255, 255, 255)
BtnStroke.Thickness = 1.5

-- Bouton PARAMÈTRES
local GearBtn = Instance.new("TextButton")
GearBtn.Size = UDim2.new(0, 42, 0, 42)
GearBtn.Position = UDim2.new(0.5, 35, 0.85, 0)
GearBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
GearBtn.BackgroundTransparency = 0.35
GearBtn.Text = "⚙️"
GearBtn.TextSize = 18
GearBtn.Parent = ScreenGui

Instance.new("UICorner", GearBtn).CornerRadius = UDim.new(0, 12)
local GearStroke = Instance.new("UIStroke", GearBtn)
GearStroke.Color = Color3.fromRGB(255, 255, 255)
GearStroke.Thickness = 1.5

-- ====================================================================
-- 2. PANEL SETTINGS (CORRIGÉ EN CANVASGROUP POUR ÉVITER LE CRASH)
-- ====================================================================
local SettingsPanel = Instance.new("CanvasGroup") -- Correction ici
SettingsPanel.Size = UDim2.new(0, 220, 0, 140)
SettingsPanel.Position = UDim2.new(0.5, -110, 0.85, -130)
SettingsPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
SettingsPanel.BackgroundTransparency = 0.25
SettingsPanel.GroupTransparency = 1 -- Fonctionne parfaitement sur un CanvasGroup
SettingsPanel.Visible = false
SettingsPanel.Parent = ScreenGui

Instance.new("UICorner", SettingsPanel).CornerRadius = UDim.new(0, 16)
local PanelStroke = Instance.new("UIStroke", SettingsPanel)
PanelStroke.Color = Color3.fromRGB(255, 255, 255)
PanelStroke.Thickness = 1
PanelStroke.Transparency = 0.6

-- Titre SHADOW avec dégradé animé
local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Size = UDim2.new(1, 0, 0, 30)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Text = "S H A D O W"
SettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsTitle.Font = Enum.Font.GothamBlack
SettingsTitle.TextSize = 16
SettingsTitle.Parent = SettingsPanel

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 20, 50)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 20, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 140, 255))
})
TitleGradient.Parent = SettingsTitle

-- Zone Vitesse
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, -50, 0, 20)
SpeedLabel.Position = UDim2.new(0, 10, 0, 35)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "VITESSE : " .. FlySpeed
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 12
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = SettingsPanel

-- Bouton Reset (♻️)
local ResetBtn = Instance.new("TextButton")
ResetBtn.Size = UDim2.new(0, 26, 0, 26)
ResetBtn.Position = UDim2.new(1, -36, 0, 32)
ResetBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
ResetBtn.Text = "♻️"
ResetBtn.TextSize = 12
ResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetBtn.Parent = SettingsPanel
Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0, 6)

-- Slider
local SliderBg = Instance.new("TextButton")
SliderBg.Size = UDim2.new(1, -20, 0, 10)
SliderBg.Position = UDim2.new(0, 10, 0, 68)
SliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
SliderBg.Text = ""
SliderBg.Parent = SettingsPanel
Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(FlySpeed/9999, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
SliderFill.Parent = SliderBg
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

-- Bouton NoClip
local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Size = UDim2.new(1, -20, 0, 32)
NoclipBtn.Position = UDim2.new(0, 10, 0, 95)
NoclipBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
NoclipBtn.Text = "TRAVERSER MURS : ON"
NoclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipBtn.Font = Enum.Font.GothamBold
NoclipBtn.TextSize = 12
NoclipBtn.Parent = SettingsPanel
Instance.new("UICorner", NoclipBtn).CornerRadius = UDim.new(0, 8)

-- ====================================================================
-- 3. SYSTÈME NOCLIP ANTI-BUG
-- ====================================================================
local function SaveCollisions()
    table.clear(OriginalCollisions)
    local Character = LocalPlayer.Character
    if Character then
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                OriginalCollisions[part] = part.CanCollide
            end
        end
    end
end

local function RestoreCollisions()
    for part, state in pairs(OriginalCollisions) do
        if part and part.Parent then
            part.CanCollide = state
        end
    end
end

-- ====================================================================
-- 4. INTERACTIONS ET ANIMATIONS (SÉCURISÉES)
-- ====================================================================

-- Animation rotation continue du dégradé SHADOW
RunService.RenderStepped:Connect(function()
    TitleGradient.Rotation = (TitleGradient.Rotation + 1.5) % 360
end)

-- Ouvrir / Fermer le menu avec glissement + fondu propre
local MenuOpen = false
GearBtn.MouseButton1Click:Connect(function()
    MenuOpen = not MenuOpen
    
    -- Petit effet de clic visuel sur l'engrenage
    TweenService:Create(GearBtn, AnimFast, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
    task.delay(0.1, function() TweenService:Create(GearBtn, AnimFast, {BackgroundColor3 = Color3.fromRGB(20, 20, 25)}):Play() end)

    if MenuOpen then
        SettingsPanel.Visible = true
        TweenService:Create(SettingsPanel, AnimSmooth, {Position = UDim2.new(0.5, -110, 0.85, -155), GroupTransparency = 0}):Play()
    else
        TweenService:Create(SettingsPanel, AnimSmooth, {Position = UDim2.new(0.5, -110, 0.85, -130), GroupTransparency = 1}):Play()
        task.delay(0.25, function() if not MenuOpen then SettingsPanel.Visible = false end end)
    end
end)

-- Bouton Reset Vitesse à 70
ResetBtn.MouseButton1Click:Connect(function()
    FlySpeed = 70
    SpeedLabel.Text = "VITESSE : " .. FlySpeed
    TweenService:Create(SliderFill, AnimSmooth, {Size = UDim2.new(FlySpeed/9999, 0, 1, 0)}):Play()
    
    TweenService:Create(ResetBtn, AnimFast, {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
    task.delay(0.1, function() TweenService:Create(ResetBtn, AnimFast, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play() end)
end)

-- Switch NoClip
NoclipBtn.MouseButton1Click:Connect(function()
    NoclipEnabled = not NoclipEnabled
    if NoclipEnabled then
        TweenService:Create(NoclipBtn, AnimSmooth, {BackgroundColor3 = Color3.fromRGB(0, 122, 255)}):Play()
        NoclipBtn.Text = "TRAVERSER MURS : ON"
        SaveCollisions()
    else
        TweenService:Create(NoclipBtn, AnimSmooth, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
        NoclipBtn.Text = "TRAVERSER MURS : OFF"
        RestoreCollisions() -- Remet instantanément les murs solides
    end
end)

-- Logique interactive du Slider
local Dragging = false
local function UpdateSlider(input)
    local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
    FlySpeed = math.floor(pos * 9999)
    if FlySpeed < 1 then FlySpeed = 1 end
    SpeedLabel.Text = "VITESSE : " .. FlySpeed
end

SliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        UpdateSlider(input)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then UpdateSlider(input) end
end)

-- Bouton de Vol Principal
ToggleBtn.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")

    if FlyEnabled then
        TweenService:Create(ToggleBtn, AnimSmooth, {BackgroundColor3 = Color3.fromRGB(0, 122, 255)}):Play()
        ToggleBtn.Text = "FLY : ON"
        SaveCollisions()
        if Humanoid then Humanoid.PlatformStand = true end
        if Root then Root.Anchored = true end
    else
        TweenService:Create(ToggleBtn, AnimSmooth, {BackgroundColor3 = Color3.fromRGB(20, 20, 25)}):Play()
        ToggleBtn.Text = "FLY : OFF"
        RestoreCollisions()
        if Humanoid then Humanoid.PlatformStand = false end
        if Root then Root.Anchored = false end
    end
end)

-- ====================================================================
-- 5. BOUCLE DE VOL & VERROU PHYSIQUE
-- ====================================================================

-- Forcer le NoClip à chaque calcul physique si activé
RunService.Stepped:Connect(function()
    if FlyEnabled and NoclipEnabled then
        local Character = LocalPlayer.Character
        if Character then
            for _, part in ipairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

-- Moteur de déplacement
RunService.RenderStepped:Connect(function(deltaTime)
    if FlyEnabled then
        local Character = LocalPlayer.Character
        local Root = Character and Character:FindFirstChild("HumanoidRootPart")
        local Camera = workspace.CurrentCamera

        if Root and Camera then
            local MoveVector = Vector3.new(0, 0, 0)
            if Controls then MoveVector = Controls:GetMoveVector() end

            local Direction = (Camera.CFrame.LookVector * -MoveVector.Z) + (Camera.CFrame.RightVector * MoveVector.X)
            local Displacement = Direction.Unit * (FlySpeed * deltaTime)
            
            if Direction.Magnitude > 0 then
                Root.CFrame = CFrame.new(Root.Position + Displacement) * CFrame.fromEulerAnglesXYZ(Camera.CFrame:ToEulerAnglesXYZ())
            else
                Root.CFrame = CFrame.new(Root.Position) * CFrame.fromEulerAnglesXYZ(Camera.CFrame:ToEulerAnglesXYZ())
            end
        end
    end
end)
