-- ====================================================================
-- 🍏 SHADOW VIP v15.2 : FULL UNCOMPRESSED EDITION + ANTI-CHEAT BYPASS
-- ====================================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreLocation = (gethui and gethui()) or game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Nettoyage strict des anciennes instances pour éviter les doublons
for _, v in pairs(CoreLocation:GetChildren()) do
    if v.Name:match("PremiumFly_") then 
        v:Destroy() 
    end
end

-- ====================================================================
-- 🎨 CONFIGURATION & STYLES (GLASSMORPHISM)
-- ====================================================================
local AnimBouncy = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local AnimSmooth = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local AnimFast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local Colors = {
    GlassBG = Color3.fromRGB(20, 20, 25),
    Surface = Color3.fromRGB(40, 40, 45),
    AppleBlue = Color3.fromRGB(10, 132, 255),
    AppleRed = Color3.fromRGB(255, 59, 48),
    AppleGreen = Color3.fromRGB(48, 209, 88),
    AppleOrange = Color3.fromRGB(255, 149, 0),
    AppleText = Color3.fromRGB(240, 240, 245),
    AppleSubText = Color3.fromRGB(160, 160, 170)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumFly_" .. HttpService:GenerateGUID(false)
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreLocation

-- ====================================================================
-- 🚀 FONCTION PRINCIPALE (CHARGE LE MENU COMPLET APRÈS LA CLÉ)
-- ====================================================================
local function StartShadowVIP()
    
    local State = { 
        Fly = false, 
        Spin = false, 
        ShiftLock = false, 
        Noclip = false, 
        MenuOpen = false, 
        SpinAngle = 0, 
        Walk = false, 
        Jump = false, 
        EspNames = false, 
        EspChams = false, 
        Aimbot = false 
    }
    
    local DefaultConfig = { 
        FlySpeed = 100, 
        SpinSpeed = 500, 
        WalkSpeed = 80, 
        JumpPower = 100, 
        AimbotSmoothness = 0.5 
    }
    
    local Config = { 
        FlySpeed = DefaultConfig.FlySpeed, 
        SpinSpeed = DefaultConfig.SpinSpeed, 
        WalkSpeed = DefaultConfig.WalkSpeed, 
        JumpPower = DefaultConfig.JumpPower 
    }
    
    local Controls
    pcall(function()
        local PlayerModule = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
        Controls = PlayerModule:GetControls()
    end)

    -- ================= BOUTON D'OUVERTURE (LOGICIEL) =================
    local GearBtn = Instance.new("TextButton")
    GearBtn.Name = "ToggleMenuButton"
    GearBtn.Parent = ScreenGui
    GearBtn.Size = UDim2.new(0, 0, 0, 0)
    GearBtn.Position = UDim2.new(0.5, -25, 0.85, 0)
    GearBtn.BackgroundColor3 = Colors.GlassBG
    GearBtn.BackgroundTransparency = 1
    GearBtn.Text = "⌘"
    GearBtn.TextSize = 24
    GearBtn.TextColor3 = Colors.AppleText
    GearBtn.Font = Enum.Font.GothamMedium
    GearBtn.AutoButtonColor = false

    local GearCorner = Instance.new("UICorner")
    GearCorner.CornerRadius = UDim.new(0.5, 0)
    GearCorner.Parent = GearBtn

    local GearStroke = Instance.new("UIStroke")
    GearStroke.Parent = GearBtn
    GearStroke.Color = Color3.fromRGB(255, 255, 255)
    GearStroke.Thickness = 1
    GearStroke.Transparency = 0.8

    -- Animation d'apparition du bouton
    TweenService:Create(GearBtn, AnimBouncy, {
        Size = UDim2.new(0, 50, 0, 50), 
        BackgroundTransparency = 0.3
    }):Play()

    GearBtn.MouseEnter:Connect(function() 
        TweenService:Create(GearBtn, AnimFast, {
            Size = UDim2.new(0, 54, 0, 54), 
            Position = UDim2.new(0.5, -27, 0.85, -2), 
            BackgroundTransparency = 0.15
        }):Play() 
    end)

    GearBtn.MouseLeave:Connect(function() 
        TweenService:Create(GearBtn, AnimFast, {
            Size = UDim2.new(0, 50, 0, 50), 
            Position = UDim2.new(0.5, -25, 0.85, 0), 
            BackgroundTransparency = 0.3
        }):Play() 
    end)

    -- ================= FENÊTRE PRINCIPALE =================
    local SettingsPanel = Instance.new("CanvasGroup")
    SettingsPanel.Name = "MainSettingsPanel"
    SettingsPanel.Parent = ScreenGui
    SettingsPanel.Size = UDim2.new(0, 280, 0, 260)
    SettingsPanel.Position = UDim2.new(0.5, -140, 0.85, -100)
    SettingsPanel.BackgroundColor3 = Colors.GlassBG
    SettingsPanel.BackgroundTransparency = 0.25
    SettingsPanel.GroupTransparency = 1
    SettingsPanel.Visible = false

    local PanelCorner = Instance.new("UICorner")
    PanelCorner.CornerRadius = UDim.new(0, 24)
    PanelCorner.Parent = SettingsPanel

    local PanelStroke = Instance.new("UIStroke")
    PanelStroke.Parent = SettingsPanel
    PanelStroke.Color = Color3.fromRGB(255, 255, 255)
    PanelStroke.Thickness = 1
    PanelStroke.Transparency = 0.8

    -- ================= FONCTIONS UTILITAIRES UI =================
    local function CreateTitle(parent, text)
        local Title = Instance.new("TextLabel")
        Title.Parent = parent
        Title.Size = UDim2.new(1, 0, 0, 40)
        Title.BackgroundTransparency = 1
        Title.Text = text
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Font = Enum.Font.GothamBlack
        Title.TextSize = 15

        local Gradient = Instance.new("UIGradient")
        Gradient.Parent = Title
        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Colors.AppleRed), 
            ColorSequenceKeypoint.new(1, Colors.AppleBlue)
        })
        return Title, Gradient
    end

    local function CreateToggleButton(parent, text, posX, posY, sizeX)
        local btn = Instance.new("TextButton")
        btn.Parent = parent
        btn.Size = UDim2.new(0, sizeX or 76, 0, 36)
        btn.Position = UDim2.new(0, posX, 0, posY)
        btn.BackgroundColor3 = Colors.Surface
        btn.BackgroundTransparency = 0.4
        btn.Text = text
        btn.TextColor3 = Colors.AppleText
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 11
        btn.AutoButtonColor = false

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = btn

        return btn
    end

    local function CreateSlider(parent, titleText, posY, defaultVal, maxVal)
        local label = Instance.new("TextLabel")
        label.Parent = parent
        label.Size = UDim2.new(1, -32, 0, 15)
        label.Position = UDim2.new(0, 16, 0, posY)
        label.BackgroundTransparency = 1
        label.Text = titleText .. " : " .. defaultVal
        label.TextColor3 = Colors.AppleSubText
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left

        local bg = Instance.new("TextButton")
        bg.Parent = parent
        bg.Size = UDim2.new(1, -32, 0, 10)
        bg.Position = UDim2.new(0, 16, 0, posY + 20)
        bg.BackgroundColor3 = Colors.Surface
        bg.Text = ""
        bg.AutoButtonColor = false

        local bgCorner = Instance.new("UICorner")
        bgCorner.CornerRadius = UDim.new(1, 0)
        bgCorner.Parent = bg
        
        local fill = Instance.new("Frame")
        fill.Parent = bg
        fill.Size = UDim2.new(defaultVal / maxVal, 0, 1, 0)
        fill.BackgroundColor3 = Colors.AppleBlue

        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = fill
        
        local resetBtn = Instance.new("TextButton")
        resetBtn.Parent = label
        resetBtn.Size = UDim2.new(0, 45, 0, 15)
        resetBtn.Position = UDim2.new(1, -45, 0, 0)
        resetBtn.BackgroundTransparency = 1
        resetBtn.Text = "RESET ↺"
        resetBtn.TextColor3 = Colors.AppleBlue
        resetBtn.Font = Enum.Font.GothamBold
        resetBtn.TextSize = 10
        
        return bg, fill, label, resetBtn
    end

    -- ================= PAGE 1: CHEAT MAIN =================
    local CheatPage = Instance.new("Frame")
    CheatPage.Parent = SettingsPanel
    CheatPage.Size = UDim2.new(1, 0, 1, 0)
    CheatPage.BackgroundTransparency = 1

    local _, TitleGrad = CreateTitle(CheatPage, "S H A D O W   V I P")

    local FlyBtn = CreateToggleButton(CheatPage, "FLY ✈️", 12, 45, 60)
    local LockBtn = CreateToggleButton(CheatPage, "LOCK 🔒", 77, 45, 60)
    local SpinBtn = CreateToggleButton(CheatPage, "SPIN 🌪️", 142, 45, 60)
    local NoclipBtn = CreateToggleButton(CheatPage, "CLIP 👻", 207, 45, 60)

    -- Sliders fixés avec un Max correct !
    local FlySliderBg, FlySliderFill, FlyLabel, FlyReset = CreateSlider(CheatPage, "Vitesse de Vol", 95, Config.FlySpeed, 300)
    local SpinSliderBg, SpinSliderFill, SpinLabel, SpinReset = CreateSlider(CheatPage, "Vitesse de Spin", 145, Config.SpinSpeed, 1000)

    -- ================= PAGE 2: PROFIL =================
    local ProfilePage = Instance.new("Frame")
    ProfilePage.Parent = SettingsPanel
    ProfilePage.Size = UDim2.new(1, 0, 1, 0)
    ProfilePage.Position = UDim2.new(1, 0, 0, 0)
    ProfilePage.BackgroundTransparency = 1

    CreateTitle(ProfilePage, "P R O F I L")
    
    local UserImg = Instance.new("ImageLabel")
    UserImg.Parent = ProfilePage
    UserImg.Size = UDim2.new(0, 80, 0, 80)
    UserImg.Position = UDim2.new(0.5, -40, 0, 50)
    UserImg.BackgroundTransparency = 1
    UserImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    
    local ImgCorner = Instance.new("UICorner")
    ImgCorner.CornerRadius = UDim.new(1, 0)
    ImgCorner.Parent = UserImg
    
    local UserName = Instance.new("TextLabel")
    UserName.Parent = ProfilePage
    UserName.Size = UDim2.new(1, 0, 0, 20)
    UserName.Position = UDim2.new(0, 0, 0, 140)
    UserName.BackgroundTransparency = 1
    UserName.Text = LocalPlayer.Name
    UserName.TextColor3 = Colors.AppleText
    UserName.Font = Enum.Font.GothamBold
    UserName.TextSize = 16

    -- ================= PAGE 3: AUTRES MODS =================
    local OtherPage = Instance.new("Frame")
    OtherPage.Parent = SettingsPanel
    OtherPage.Size = UDim2.new(1, 0, 1, 0)
    OtherPage.Position = UDim2.new(-1, 0, 0, 0)
    OtherPage.BackgroundTransparency = 1

    local _, OtherGrad = CreateTitle(OtherPage, "A U T R E S   M O D S")

    -- Les boutons Walk et Jump qui utilisent le Bypass
    local WalkBtn = CreateToggleButton(OtherPage, "SPEED (Bypass) 🏃", 16, 45, 118)
    local JumpBtn = CreateToggleButton(OtherPage, "JUMP (Bypass) ⬆️", 146, 45, 118)
    
    local EspNamesBtn = CreateToggleButton(OtherPage, "NOMS 🌈", 16, 125, 76)
    local EspChamsBtn = CreateToggleButton(OtherPage, "CHAMS 👁️", 102, 125, 76)
    local AimbotBtn = CreateToggleButton(OtherPage, "AIM 🎯", 188, 125, 76)

    -- ================= NAVIGATION DU MENU =================
    local ProfileNavBtn = CreateToggleButton(CheatPage, "👤 Profil", 16, 205, 118)
    local OtherNavBtn = CreateToggleButton(CheatPage, "⚙️ Autre", 146, 205, 118)
    
    local ProfileBackBtn = Instance.new("TextButton")
    ProfileBackBtn.Parent = ProfilePage
    ProfileBackBtn.Size = UDim2.new(0, 30, 0, 30)
    ProfileBackBtn.Position = UDim2.new(0, 12, 0, 5)
    ProfileBackBtn.BackgroundTransparency = 1
    ProfileBackBtn.Text = "⬅"
    ProfileBackBtn.TextSize = 16
    ProfileBackBtn.TextColor3 = Colors.AppleBlue
    ProfileBackBtn.Font = Enum.Font.GothamBold
    
    local OtherBackBtn = Instance.new("TextButton")
    OtherBackBtn.Parent = OtherPage
    OtherBackBtn.Size = UDim2.new(0, 30, 0, 30)
    OtherBackBtn.Position = UDim2.new(0, 12, 0, 5)
    OtherBackBtn.BackgroundTransparency = 1
    OtherBackBtn.Text = "⬅"
    OtherBackBtn.TextSize = 16
    OtherBackBtn.TextColor3 = Colors.AppleBlue
    OtherBackBtn.Font = Enum.Font.GothamBold

    ProfileNavBtn.MouseButton1Click:Connect(function() 
        TweenService:Create(CheatPage, AnimBouncy, {Position = UDim2.new(-1, 0, 0, 0)}):Play()
        TweenService:Create(ProfilePage, AnimBouncy, {Position = UDim2.new(0, 0, 0, 0)}):Play() 
    end)

    ProfileBackBtn.MouseButton1Click:Connect(function() 
        TweenService:Create(CheatPage, AnimBouncy, {Position = UDim2.new(0, 0, 0, 0)}):Play()
        TweenService:Create(ProfilePage, AnimBouncy, {Position = UDim2.new(1, 0, 0, 0)}):Play() 
    end)

    OtherNavBtn.MouseButton1Click:Connect(function() 
        TweenService:Create(CheatPage, AnimBouncy, {Position = UDim2.new(1, 0, 0, 0)}):Play()
        TweenService:Create(OtherPage, AnimBouncy, {Position = UDim2.new(0, 0, 0, 0)}):Play() 
    end)

    OtherBackBtn.MouseButton1Click:Connect(function() 
        TweenService:Create(CheatPage, AnimBouncy, {Position = UDim2.new(0, 0, 0, 0)}):Play()
        TweenService:Create(OtherPage, AnimBouncy, {Position = UDim2.new(-1, 0, 0, 0)}):Play() 
    end)

    -- Toggle Ouvert/Fermé
    GearBtn.MouseButton1Click:Connect(function()
        State.MenuOpen = not State.MenuOpen
        TweenService:Create(GearBtn, AnimBouncy, {Rotation = State.MenuOpen and 90 or 0}):Play()
        
        if State.MenuOpen then
            SettingsPanel.Visible = true
            TweenService:Create(SettingsPanel, AnimBouncy, {
                Position = UDim2.new(0.5, -140, 0.85, -280), 
                GroupTransparency = 0
            }):Play()
        else
            TweenService:Create(SettingsPanel, AnimBouncy, {
                Position = UDim2.new(0.5, -140, 0.85, -100), 
                GroupTransparency = 1
            }):Play()
            task.delay(0.4, function() 
                if not State.MenuOpen then 
                    SettingsPanel.Visible = false 
                end 
            end)
        end
    end)

    -- Fonction pour le visuel des boutons actifs
    local function UpdateButtonVisual(btn, active) 
        TweenService:Create(btn, AnimFast, {
            BackgroundColor3 = active and Colors.AppleBlue or Colors.Surface, 
            BackgroundTransparency = active and 0.1 or 0.4
        }):Play() 
    end

    -- ================= LOGIQUE DES SLIDERS (RÉPARÉE) =================
    local function SetupLogicSlider(bg, fill, label, resetBtn, configKey, defaultV, maxV, textPrefix)
        local dragging = false
        
        bg.InputBegan:Connect(function(input) 
            if input.UserInputType == Enum.UserInputType.MouseButton1 then 
                dragging = true 
            end 
        end)
        
        UserInputService.InputEnded:Connect(function(input) 
            if input.UserInputType == Enum.UserInputType.MouseButton1 then 
                dragging = false 
            end 
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relativeX = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                Config[configKey] = math.floor(relativeX * maxV)
                
                TweenService:Create(fill, AnimFast, {
                    Size = UDim2.new(relativeX, 0, 1, 0)
                }):Play()
                
                label.Text = textPrefix .. " : " .. Config[configKey]
            end
        end)
        
        resetBtn.MouseButton1Click:Connect(function()
            Config[configKey] = defaultV
            TweenService:Create(fill, AnimSmooth, {
                Size = UDim2.new(defaultV / maxV, 0, 1, 0)
            }):Play()
            label.Text = textPrefix .. " : " .. defaultV
        end)
    end

    SetupLogicSlider(FlySliderBg, FlySliderFill, FlyLabel, FlyReset, "FlySpeed", DefaultConfig.FlySpeed, 300, "Vitesse de Vol")
    SetupLogicSlider(SpinSliderBg, SpinSliderFill, SpinLabel, SpinReset, "SpinSpeed", DefaultConfig.SpinSpeed, 1000, "Vitesse de Spin")

    -- ================= LOGIQUE DES BOUTONS DE MOD =================
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
        if State.ShiftLock then 
            State.Spin = false
            UpdateButtonVisual(SpinBtn, false) 
        end
        UpdateButtonVisual(LockBtn, State.ShiftLock) 
    end)

    SpinBtn.MouseButton1Click:Connect(function() 
        State.Spin = not State.Spin
        if State.Spin then 
            State.ShiftLock = false
            UpdateButtonVisual(LockBtn, false) 
        end
        UpdateButtonVisual(SpinBtn, State.Spin) 
    end)

    NoclipBtn.MouseButton1Click:Connect(function() 
        State.Noclip = not State.Noclip
        UpdateButtonVisual(NoclipBtn, State.Noclip) 
    end)
    
    WalkBtn.MouseButton1Click:Connect(function() 
        State.Walk = not State.Walk
        UpdateButtonVisual(WalkBtn, State.Walk) 
    end)

    JumpBtn.MouseButton1Click:Connect(function() 
        State.Jump = not State.Jump
        UpdateButtonVisual(JumpBtn, State.Jump) 
    end)
    
    EspNamesBtn.MouseButton1Click:Connect(function() 
        State.EspNames = not State.EspNames
        UpdateButtonVisual(EspNamesBtn, State.EspNames) 
    end)

    EspChamsBtn.MouseButton1Click:Connect(function() 
        State.EspChams = not State.EspChams
        UpdateButtonVisual(EspChamsBtn, State.EspChams) 
    end)

    AimbotBtn.MouseButton1Click:Connect(function() 
        State.Aimbot = not State.Aimbot
        UpdateButtonVisual(AimbotBtn, State.Aimbot) 
    end)

    -- ================= ESP CHAMS & NAMES =================
    local function UpdateESP()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                
                -- Gestion du Highlight (Chams)
                local highlight = player.Character:FindFirstChild("ShadowChams")
                if State.EspChams then
                    if not highlight then 
                        highlight = Instance.new("Highlight")
                        highlight.Parent = player.Character
                        highlight.Name = "ShadowChams"
                        highlight.FillColor = Colors.AppleRed
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5 
                    end
                else 
                    if highlight then highlight:Destroy() end 
                end

                -- Gestion des Noms (BillboardGui)
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local bbGui = head:FindFirstChild("ShadowName")
                    if State.EspNames then
                        if not bbGui then
                            bbGui = Instance.new("BillboardGui")
                            bbGui.Parent = head
                            bbGui.Name = "ShadowName"
                            bbGui.Size = UDim2.new(0, 100, 0, 40)
                            bbGui.StudsOffset = Vector3.new(0, 2, 0)
                            bbGui.AlwaysOnTop = true
                            
                            local txt = Instance.new("TextLabel")
                            txt.Parent = bbGui
                            txt.Size = UDim2.new(1, 0, 1, 0)
                            txt.BackgroundTransparency = 1
                            txt.Text = player.Name
                            txt.TextColor3 = Color3.fromRGB(255, 255, 255)
                            txt.TextStrokeTransparency = 0.2
                            txt.Font = Enum.Font.GothamBold
                            txt.TextSize = 12
                        end
                    else 
                        if bbGui then bbGui:Destroy() end 
                    end
                end
            end
        end
    end

    -- ================= AIMBOT (RECHERCHE DE CIBLE) =================
    local function GetClosestPlayer()
        local closestPlayer = nil
        local shortestDistance = math.huge

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                
                local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                
                if onScreen then
                    local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if magnitude < shortestDistance then 
                        closestPlayer = player
                        shortestDistance = magnitude 
                    end
                end
            end
        end
        return closestPlayer
    end

    -- ================= JUMP BYPASS ANTI-CHEAT =================
    -- On écoute la touche de saut. Si actif, on propulse le joueur vers le haut physiquement (Vélocité).
    UserInputService.JumpRequest:Connect(function()
        if State.Jump and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hum and root and hum:GetState() ~= Enum.HumanoidStateType.Freefall then
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, Config.JumpPower, root.AssemblyLinearVelocity.Z)
            end
        end
    end)

    -- ================= BOUCLE DE RENDU PRINCIPALE =================
    RunService:BindToRenderStep("ShadowRenderEngine", Enum.RenderPriority.Camera.Value - 1, function(deltaTime)
        
        TitleGrad.Rotation = (TitleGrad.Rotation + 1.5) % 360
        OtherGrad.Rotation = (OtherGrad.Rotation + 1.5) % 360

        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        UpdateESP()

        -- Execution Aimbot (Clic Droit enfoncé)
        if State.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local target = GetClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Character.Head.Position), Config.AimbotSmoothness)
            end
        end

        -- Execution Noclip (Désactive les collisions)
        if State.Noclip and char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then 
                    part.CanCollide = false 
                end
            end
        end

        if root and hum then
            
            -- SPEED BYPASS ANTI-CHEAT
            -- Au lieu de changer la propriété "WalkSpeed", on force le déplacement physique avec CFrame.
            if State.Walk and hum.MoveDirection.Magnitude > 0 then
                root.CFrame = root.CFrame + (hum.MoveDirection * (Config.WalkSpeed * deltaTime * 0.6))
            end

            if State.Fly then
                local moveDir = Controls and Controls:GetMoveVector() or Vector3.zero
                local look = Camera.CFrame.LookVector
                local right = Camera.CFrame.RightVector
                local direction = (look * -moveDir.Z) + (right * moveDir.X)
                
                if direction.Magnitude > 0 then 
                    direction = direction.Unit 
                end
                
                local newPos = root.Position + (direction * (Config.FlySpeed * deltaTime))
                
                if State.Spin then 
                    State.SpinAngle = State.SpinAngle + (Config.SpinSpeed * deltaTime * 3)
                    root.CFrame = CFrame.new(newPos) * CFrame.Angles(0, math.rad(State.SpinAngle), 0)
                elseif State.ShiftLock then 
                    root.CFrame = CFrame.lookAt(newPos, Vector3.new(newPos.X + look.X, newPos.Y, newPos.Z + look.Z))
                else 
                    root.CFrame = CFrame.new(newPos) * Camera.CFrame.Rotation 
                end
            else
                if State.Spin then 
                    hum.AutoRotate = false
                    State.SpinAngle = State.SpinAngle + (Config.SpinSpeed * deltaTime * 2)
                    root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Config.SpinSpeed * deltaTime), 0)
                elseif State.ShiftLock then 
                    hum.AutoRotate = false
                    local look = Camera.CFrame.LookVector
                    root.CFrame = CFrame.lookAt(root.Position, Vector3.new(root.Position.X + look.X, root.Position.Y, root.Position.Z + look.Z))
                else 
                    hum.AutoRotate = true
                end
            end
        end
    end)
end

-- ====================================================================
-- 🔐 SYSTÈME DE CLÉ (AVEC CHARGEMENT DE 3 SECONDES)
-- ====================================================================
local KeyFrame = Instance.new("CanvasGroup")
KeyFrame.Parent = ScreenGui
KeyFrame.Size = UDim2.new(0, 320, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -100)
KeyFrame.BackgroundColor3 = Colors.GlassBG
KeyFrame.BackgroundTransparency = 0.25

local KeyFrameCorner = Instance.new("UICorner")
KeyFrameCorner.CornerRadius = UDim.new(0, 16)
KeyFrameCorner.Parent = KeyFrame

local KeyStroke = Instance.new("UIStroke")
KeyStroke.Parent = KeyFrame
KeyStroke.Color = Color3.fromRGB(255, 255, 255)
KeyStroke.Thickness = 1
KeyStroke.Transparency = 0.8

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Parent = KeyFrame
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.Position = UDim2.new(0, 0, 0, 10)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "SHADOW VIP KEY"
KeyTitle.Font = Enum.Font.GothamBlack
KeyTitle.TextSize = 18
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)

local KeyGrad = Instance.new("UIGradient")
KeyGrad.Parent = KeyTitle
KeyGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Colors.AppleRed), 
    ColorSequenceKeypoint.new(1, Colors.AppleBlue)
})

local KeySub = Instance.new("TextLabel")
KeySub.Parent = KeyFrame
KeySub.Size = UDim2.new(1, 0, 0, 20)
KeySub.Position = UDim2.new(0, 0, 0, 45)
KeySub.BackgroundTransparency = 1
KeySub.Text = "Veuillez entrer votre clé d'accès."
KeySub.TextColor3 = Colors.AppleSubText
KeySub.Font = Enum.Font.GothamMedium
KeySub.TextSize = 12

local KeyBox = Instance.new("TextBox")
KeyBox.Parent = KeyFrame
KeyBox.Size = UDim2.new(0, 280, 0, 40)
KeyBox.Position = UDim2.new(0.5, -140, 0, 75)
KeyBox.BackgroundColor3 = Colors.Surface
KeyBox.BackgroundTransparency = 0.5
KeyBox.Text = ""
-- Retrait de l'ancien placeholder text shadow_xxxx
KeyBox.PlaceholderText = "Clé secrète ici..." 
KeyBox.TextColor3 = Colors.AppleText
KeyBox.PlaceholderColor3 = Colors.AppleSubText
KeyBox.Font = Enum.Font.GothamMedium
KeyBox.TextSize = 14

local KeyBoxCorner = Instance.new("UICorner")
KeyBoxCorner.CornerRadius = UDim.new(0, 8)
KeyBoxCorner.Parent = KeyBox

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Parent = KeyFrame
GetKeyBtn.Size = UDim2.new(0, 135, 0, 40)
GetKeyBtn.Position = UDim2.new(0, 20, 0, 135)
GetKeyBtn.BackgroundColor3 = Colors.Surface
GetKeyBtn.Text = "GET KEY"
GetKeyBtn.TextColor3 = Colors.AppleText
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextSize = 12

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.CornerRadius = UDim.new(0, 8)
GetKeyCorner.Parent = GetKeyBtn

local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Parent = KeyFrame
VerifyBtn.Size = UDim2.new(0, 135, 0, 40)
VerifyBtn.Position = UDim2.new(0, 165, 0, 135)
VerifyBtn.BackgroundColor3 = Colors.AppleBlue
VerifyBtn.Text = "VERIFY"
VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextSize = 12

local VerifyCorner = Instance.new("UICorner")
VerifyCorner.CornerRadius = UDim.new(0, 8)
VerifyCorner.Parent = VerifyBtn

local KeyRender = RunService.RenderStepped:Connect(function()
    KeyGrad.Rotation = (KeyGrad.Rotation + 1.5) % 360
end)

GetKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard("https://shadow-key.base44.app")
        GetKeyBtn.Text = "COPIED !"
        TweenService:Create(GetKeyBtn, AnimFast, {BackgroundColor3 = Colors.AppleGreen}):Play()
        task.wait(1.5)
        GetKeyBtn.Text = "GET KEY"
        TweenService:Create(GetKeyBtn, AnimFast, {BackgroundColor3 = Colors.Surface}):Play()
    end
end)

-- Validation et Animation de 3 secondes demandée
VerifyBtn.MouseButton1Click:Connect(function()
    local input = string.lower(KeyBox.Text)
    
    if string.sub(input, 1, 7) == "shadow_" then
        
        -- ⏳ ANIMATION DE CHARGEMENT EXACTEMENT DE 3 SECONDES
        VerifyBtn.AutoButtonColor = false
        TweenService:Create(VerifyBtn, AnimFast, {BackgroundColor3 = Colors.AppleOrange}):Play()
        
        for i = 1, 3 do
            VerifyBtn.Text = "VÉRIFICATION."
            task.wait(0.33)
            VerifyBtn.Text = "VÉRIFICATION.."
            task.wait(0.33)
            VerifyBtn.Text = "VÉRIFICATION..."
            task.wait(0.34)
        end
        
        -- 🎉 SUCCÈS
        VerifyBtn.Text = "SUCCESS !"
        TweenService:Create(VerifyBtn, AnimFast, {BackgroundColor3 = Colors.AppleGreen}):Play()
        task.wait(0.8)
        
        KeyRender:Disconnect()
        local closeTween = TweenService:Create(KeyFrame, AnimBouncy, {
            Size = UDim2.new(0, 0, 0, 0), 
            GroupTransparency = 1
        })
        closeTween:Play()
        closeTween.Completed:Wait()
        KeyFrame:Destroy()
        
        -- Lancement final
        StartShadowVIP()
    else
        -- ❌ REFUSÉ
        VerifyBtn.Text = "INVALID"
        TweenService:Create(VerifyBtn, AnimFast, {BackgroundColor3 = Colors.AppleRed}):Play()
        local originalPos = KeyFrame.Position
        
        for i = 1, 3 do
            KeyFrame.Position = originalPos + UDim2.new(0, math.random(-5, 5), 0, 0)
            task.wait(0.05)
        end
        KeyFrame.Position = originalPos
        
        task.wait(1)
        VerifyBtn.Text = "VERIFY"
        TweenService:Create(VerifyBtn, AnimFast, {BackgroundColor3 = Colors.AppleBlue}):Play()
    end
end)
