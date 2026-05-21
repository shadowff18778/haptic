-- ====================================================================
-- 🦇 SHADOW v9.0 : CLEAN UI, SHIFT LOCK & SPIN BOT
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
local MainSpeed = 70
local ShiftLockEnabled = false
local SpinEnabled = false

local Controls
pcall(function()
    local PlayerModule = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
    Controls = PlayerModule:GetControls()
end)

-- Paramètres d'animations
local AnimSmooth = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local AnimFast = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- ====================================================================
-- 1. CRÉATION UI PRINCIPALE
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
ToggleBtn.AutoButtonColor = false
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
GearBtn.AutoButtonColor = false
GearBtn.Parent = ScreenGui

Instance.new("UICorner", GearBtn).CornerRadius = UDim.new(0, 12)
local GearStroke = Instance.new("UIStroke", GearBtn)
GearStroke.Color = Color3.fromRGB(255, 255, 255)
GearStroke.Thickness = 1.5

-- ====================================================================
-- 2. PANEL SETTINGS (UI ÉPURÉE)
-- ====================================================================
local SettingsPanel = Instance.new("CanvasGroup")
SettingsPanel.Size = UDim2.new(0, 230, 0, 140)
SettingsPanel.Position = UDim2.new(0.5, -115, 0.85, -130)
SettingsPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
SettingsPanel.BackgroundTransparency = 0.25
SettingsPanel.GroupTransparency = 1 
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
SpeedLabel.Position = UDim2.new(0, 12, 0, 35)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "SPEED // " .. MainSpeed
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 11
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = SettingsPanel

-- Bouton Reset (♻️)
local ResetBtn = Instance.new("TextButton")
ResetBtn.Size = UDim2.new(0, 26, 0, 26)
ResetBtn.Position = UDim2.new(1, -38, 0, 32)
ResetBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
ResetBtn.Text = "♻️"
ResetBtn.TextSize = 12
ResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetBtn.AutoButtonColor = false
ResetBtn.Parent = SettingsPanel
Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0, 6)

-- Slider
local SliderBg = Instance.new("TextButton")
SliderBg.Size = UDim2.new(1, -24, 0, 10)
SliderBg.Position = UDim2.new(0, 12, 0, 68)
SliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
SliderBg.Text = ""
SliderBg.AutoButtonColor = false
SliderBg.Parent = SettingsPanel
Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(MainSpeed/9999, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
SliderFill.Parent = SliderBg
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

local SliderGrad = Instance.new("UIGradient", SliderFill)
SliderGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 30, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 30, 255))
})

-- ====================================================================
-- 3. BOUTONS UTILITAIRES (SHIFT LOCK & SPIN)
-- ====================================================================
local ShiftLockBtn = Instance.new("TextButton")
ShiftLockBtn.Size = UDim2.new(0, 98, 0, 32)
ShiftLockBtn.Position = UDim2.new(0, 12, 0, 95)
ShiftLockBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ShiftLockBtn.Text = "LOCK 🔒"
ShiftLockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ShiftLockBtn.Font = Enum.Font.GothamBold
ShiftLockBtn.TextSize = 11
ShiftLockBtn.AutoButtonColor = false
ShiftLockBtn.Parent = SettingsPanel
Instance.new("UICorner", ShiftLockBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", ShiftLockBtn).Color = Color3.fromRGB(50, 50, 60)

local SpinBtn = Instance.new("TextButton")
SpinBtn.Size = UDim2.new(0, 98, 0, 32)
SpinBtn.Position = UDim2.new(1, -110, 0, 95)
SpinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
SpinBtn.Text = "SPIN 🌪️"
SpinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpinBtn.Font = Enum.Font.GothamBold
SpinBtn.TextSize = 11
SpinBtn.AutoButtonColor = false
SpinBtn.Parent = SettingsPanel
Instance.new("UICorner", SpinBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", SpinBtn).Color = Color3.fromRGB(50, 50, 60)

-- ====================================================================
-- 4. INTERACTIONS ET ANIMATIONS
-- ====================================================================

-- Animation rotation continue du dégradé SHADOW
RunService.RenderStepped:Connect(function()
    TitleGradient.Rotation = (TitleGradient.Rotation + 1.5) % 360
end)

-- Ouvrir / Fermer le menu
local MenuOpen = false
GearBtn.MouseButton1Click:Connect(function()
    MenuOpen = not MenuOpen
    TweenService:Create(GearBtn, AnimSmooth, {Rotation = MenuOpen and 180 or 0}):Play()

    if MenuOpen then
        SettingsPanel.Visible = true
        TweenService:Create(SettingsPanel, AnimSmooth, {Position = UDim2.new(0.5, -115, 0.85, -155), GroupTransparency = 0}):Play()
    else
        TweenService:Create(SettingsPanel, AnimSmooth, {Position = UDim2.new(0.5, -115, 0.85, -130), GroupTransparency = 1}):Play()
        task.delay(0.25, function() if not MenuOpen then SettingsPanel.Visible = false end end)
    end
end)

-- Bouton Reset Vitesse à 70
ResetBtn.MouseButton1Click:Connect(function()
    MainSpeed = 70
    SpeedLabel.Text = "SPEED // " .. MainSpeed
    TweenService:Create(SliderFill, AnimSmooth, {Size = UDim2.new(MainSpeed/9999, 0, 1, 0)}):Play()
    TweenService:Create(ResetBtn, AnimFast, {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
    task.delay(0.1, function() TweenService:Create(ResetBtn, AnimFast, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play() end)
end)

-- Logique du Slider (Jusqu'à 9999)
local Dragging = false
local function UpdateSlider(input)
    local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
    MainSpeed = math.floor(pos * 9999)
    if MainSpeed < 1 then MainSpeed = 1 end
    SpeedLabel.Text = "SPEED // " .. MainSpeed
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

-- Switch SHIFT LOCK
ShiftLockBtn.MouseButton1Click:Connect(function()
    ShiftLockEnabled = not ShiftLockEnabled
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    
    if ShiftLockEnabled then
        SpinEnabled = false -- Désactive le Spin si on active le Lock (pour éviter les bugs)
        TweenService:Create(SpinBtn, AnimSmooth, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
        TweenService:Create(ShiftLockBtn, AnimSmooth, {BackgroundColor3 = Color3.fromRGB(0, 122, 255)}):Play()
        if Humanoid then Humanoid.AutoRotate = false end
    else
        TweenService:Create(ShiftLockBtn, AnimSmooth, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
        if Humanoid then Humanoid.AutoRotate = true end
    end
end)

-- Switch SPIN BOT
SpinBtn.MouseButton1Click:Connect(function()
    SpinEnabled = not SpinEnabled
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if SpinEnabled then
        ShiftLockEnabled = false -- Désactive le Lock si on active le Spin
        TweenService:Create(ShiftLockBtn, AnimSmooth, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
        TweenService:Create(SpinBtn, AnimSmooth, {BackgroundColor3 = Color3.fromRGB(150, 30, 255)}):Play()
        if Humanoid then Humanoid.AutoRotate = false end
    else
        TweenService:Create(SpinBtn, AnimSmooth, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
        if Humanoid then Humanoid.AutoRotate = true end
    end
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
        if Humanoid then Humanoid.PlatformStand = true end
        if Root then Root.Anchored = true end
    else
        TweenService:Create(ToggleBtn, AnimSmooth, {BackgroundColor3 = Color3.fromRGB(20, 20, 25)}):Play()
        ToggleBtn.Text = "FLY : OFF"
        if Humanoid then Humanoid.PlatformStand = false end
        if Root then Root.Anchored = false end
    end
end)

-- ====================================================================
-- 5. BOUCLE DE VOL & MANIPULATION CORPORELLE
-- ====================================================================

RunService.RenderStepped:Connect(function(deltaTime)
    local Character = LocalPlayer.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")
    local Camera = workspace.CurrentCamera

    if Root and Camera then
        local LookVector = Camera.CFrame.LookVector
        
        -- Si on VOL
        if FlyEnabled then
            local MoveVector = Vector3.new(0, 0, 0)
            if Controls then MoveVector = Controls:GetMoveVector() end

            local Direction = (Camera.CFrame.LookVector * -MoveVector.Z) + (Camera.CFrame.RightVector * MoveVector.X)
            local Displacement = Direction.Unit * (MainSpeed * deltaTime)
            
            -- Calcul de la position
            local newPos = Root.Position
            if Direction.Magnitude > 0 then newPos = Root.Position + Displacement end
            
            -- Calcul de l'orientation
            if SpinEnabled then
                -- Fait tourner l'orientation pendant le vol
                Root.CFrame = CFrame.new(newPos) * (Root.CFrame - Root.Position) * CFrame.Angles(0, math.rad(MainSpeed * deltaTime * 3), 0)
            elseif ShiftLockEnabled then
                -- Oriente selon la caméra
                Root.CFrame = CFrame.new(newPos, Vector3.new(newPos.X + LookVector.X, newPos.Y, newPos.Z + LookVector.Z))
            else
                -- Vol normal
                Root.CFrame = CFrame.new(newPos) * CFrame.fromEulerAnglesXYZ(Camera.CFrame:ToEulerAnglesXYZ())
            end

        -- Si on MARCHE NORMALEMENT (Mais avec des mods activés)
        else
            if SpinEnabled then
                -- Tourne le personnage sur place ou en marchant
                Root.CFrame = Root.CFrame * CFrame.Angles(0, math.rad(MainSpeed * deltaTime * 5), 0)
            elseif ShiftLockEnabled then
                -- Aligne le personnage sur la caméra
                Root.CFrame = CFrame.new(Root.Position, Vector3.new(Root.Position.X + LookVector.X, Root.Position.Y, Root.Position.Z + LookVector.Z))
            end
        end
    end
end)
