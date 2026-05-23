-- ====================================================================
-- 🍏 SHADOW VIP v15.0 : KEY SYSTEM + FULL MOD MENU (VERSION COMPLÈTE)
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
    if v.Name:match("PremiumFly_") then v:Destroy() end
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
    local State = { Fly = false, Spin = false, ShiftLock = false, Noclip = false, MenuOpen = false, SpinAngle = 0, Walk = false, Jump = false, EspNames = false, EspChams = false, Aimbot = false }
    local DefaultConfig = { FlySpeed = 100, SpinSpeed = 500, WalkSpeed = 100, JumpPower = 150, AimbotSmoothness = 0.5 }
    local Config = { FlySpeed = DefaultConfig.FlySpeed, SpinSpeed = DefaultConfig.SpinSpeed, WalkSpeed = DefaultConfig.WalkSpeed, JumpPower = DefaultConfig.JumpPower, MaxSpeed = 9999 }
    
    local Controls
    pcall(function()
        local PlayerModule = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
        Controls = PlayerModule:GetControls()
    end)

    -- Bouton Principal ⌘ (Commence invisible)
    local GearBtn = Instance.new("TextButton", ScreenGui)
    GearBtn.Size, GearBtn.Position = UDim2.new(0, 0, 0, 0), UDim2.new(0.5, -25, 0.85, 0)
    GearBtn.BackgroundColor3, GearBtn.BackgroundTransparency = Colors.GlassBG, 1
    GearBtn.Text, GearBtn.TextSize, GearBtn.TextColor3, GearBtn.Font = "⌘", 24, Colors.AppleText, Enum.Font.GothamMedium
    GearBtn.AutoButtonColor = false
    Instance.new("UICorner", GearBtn).CornerRadius = UDim.new(0.5, 0)
    local GearStroke = Instance.new("UIStroke", GearBtn)
    GearStroke.Color, GearStroke.Thickness, GearStroke.Transparency = Color3.fromRGB(255, 255, 255), 1, 0.8

    -- Animation d'apparition
    TweenService:Create(GearBtn, AnimBouncy, {Size = UDim2.new(0, 50, 0, 50), BackgroundTransparency = 0.3}):Play()

    GearBtn.MouseEnter:Connect(function() TweenService:Create(GearBtn, AnimFast, {Size = UDim2.new(0, 54, 0, 54), Position = UDim2.new(0.5, -27, 0.85, -2), BackgroundTransparency = 0.15}):Play() end)
    GearBtn.MouseLeave:Connect(function() TweenService:Create(GearBtn, AnimFast, {Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0.5, -25, 0.85, 0), BackgroundTransparency = 0.3}):Play() end)

    -- Panel Principal
    local SettingsPanel = Instance.new("CanvasGroup", ScreenGui)
    SettingsPanel.Size, SettingsPanel.Position = UDim2.new(0, 280, 0, 260), UDim2.new(0.5, -140, 0.85, -100)
    SettingsPanel.BackgroundColor3, SettingsPanel.BackgroundTransparency, SettingsPanel.GroupTransparency = Colors.GlassBG, 0.25, 1
    SettingsPanel.Visible = false
    Instance.new("UICorner", SettingsPanel).CornerRadius = UDim.new(0, 24)
    local PanelStroke = Instance.new("UIStroke", SettingsPanel)
    PanelStroke.Color, PanelStroke.Thickness, PanelStroke.Transparency = Color3.fromRGB(255, 255, 255), 1, 0.8

    -- Helpers UI
    local function CreateTitle(parent, text)
        local Title = Instance.new("TextLabel", parent)
        Title.Size, Title.BackgroundTransparency, Title.Text = UDim2.new(1, 0, 0, 40), 1, text
        Title.TextColor3, Title.Font, Title.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBlack, 15
        local Gradient = Instance.new("UIGradient", Title)
        Gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Colors.AppleRed), ColorSequenceKeypoint.new(1, Colors.AppleBlue)})
        return Title, Gradient
    end

    local function CreateToggleButton(parent, text, posX, posY, sizeX)
        local btn = Instance.new("TextButton", parent)
        btn.Size, btn.Position = UDim2.new(0, sizeX or 76, 0, 36), UDim2.new(0, posX, 0, posY)
        btn.BackgroundColor3, btn.BackgroundTransparency = Colors.Surface, 0.4
        btn.Text, btn.TextColor3, btn.Font, btn.TextSize, btn.AutoButtonColor = text, Colors.AppleText, Enum.Font.GothamMedium, 11, false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
        return btn
    end

    local function CreateSlider(parent, titleText, posY, defaultVal)
        local label = Instance.new("TextLabel", parent)
        label.Size, label.Position, label.BackgroundTransparency = UDim2.new(1, -32, 0, 15), UDim2.new(0, 16, 0, posY), 1
        label.Text, label.TextColor3, label.Font, label.TextSize, label.TextXAlignment = titleText .. " : " .. defaultVal, Colors.AppleSubText, Enum.Font.GothamMedium, 11, Enum.TextXAlignment.Left

        local bg = Instance.new("TextButton", parent)
        bg.Size, bg.Position, bg.BackgroundColor3, bg.Text, bg.AutoButtonColor = UDim2.new(1, -32, 0, 10), UDim2.new(0, 16, 0, posY + 20), Colors.Surface, "", false
        Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
        
        local fill = Instance.new("Frame", bg)
        fill.Size, fill.BackgroundColor3 = UDim2.new(defaultVal / Config.MaxSpeed, 0, 1, 0), Colors.AppleBlue
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
        
        local resetBtn = Instance.new("TextButton", label)
        resetBtn.Size, resetBtn.Position, resetBtn.BackgroundTransparency = UDim2.new(0, 45, 0, 15), UDim2.new(1, -45, 0, 0), 1
        resetBtn.Text, resetBtn.TextColor3, resetBtn.Font, resetBtn.TextSize = "RESET ↺", Colors.AppleBlue, Enum.Font.GothamBold, 10
        
        return bg, fill, label, resetBtn
    end

    -- ================= PAGE 1: CHEAT =================
    local CheatPage = Instance.new("Frame", SettingsPanel)
    CheatPage.Size, CheatPage.BackgroundTransparency = UDim2.new(1, 0, 1, 0), 1
    local _, TitleGrad = CreateTitle(CheatPage, "S H A D O W   V I P")

    local FlyBtn = CreateToggleButton(CheatPage, "FLY ✈️", 12, 45, 60)
    local LockBtn = CreateToggleButton(CheatPage, "LOCK 🔒", 77, 45, 60)
    local SpinBtn = CreateToggleButton(CheatPage, "SPIN 🌪️", 142, 45, 60)
    local NoclipBtn = CreateToggleButton(CheatPage, "CLIP 👻", 207, 45, 60)

    local FlySliderBg, FlySliderFill, FlyLabel, FlyReset = CreateSlider(CheatPage, "Vitesse de Vol", 95, Config.FlySpeed)
    local SpinSliderBg, SpinSliderFill, SpinLabel, SpinReset = CreateSlider(CheatPage, "Vitesse de Spin", 145, Config.SpinSpeed)

    -- ================= PAGE 2: PROFIL =================
    local ProfilePage = Instance.new("Frame", SettingsPanel)
    ProfilePage.Size, ProfilePage.Position, ProfilePage.BackgroundTransparency = UDim2.new(1, 0, 1, 0), UDim2.new(1, 0, 0, 0), 1
    CreateTitle(ProfilePage, "P R O F I L")
    
    local UserImg = Instance.new("ImageLabel", ProfilePage)
    UserImg.Size, UserImg.Position, UserImg.BackgroundTransparency = UDim2.new(0, 80, 0, 80), UDim2.new(0.5, -40, 0, 50), 1
    UserImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    Instance.new("UICorner", UserImg).CornerRadius = UDim.new(1, 0)
    
    local UserName = Instance.new("TextLabel", ProfilePage)
    UserName.Size, UserName.Position, UserName.BackgroundTransparency = UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 140), 1
    UserName.Text, UserName.TextColor3, UserName.Font, UserName.TextSize = LocalPlayer.Name, Colors.AppleText, Enum.Font.GothamBold, 16

    -- ================= PAGE 3: AUTRES =================
    local OtherPage = Instance.new("Frame", SettingsPanel)
    OtherPage.Size, OtherPage.Position, OtherPage.BackgroundTransparency = UDim2.new(1, 0, 1, 0), UDim2.new(-1, 0, 0, 0), 1
    local _, OtherGrad = CreateTitle(OtherPage, "A U T R E S   M O D S")

    local WalkBtn = CreateToggleButton(OtherPage, "SPEED 🏃", 16, 45, 118)
    local JumpBtn = CreateToggleButton(OtherPage, "JUMP ⬆️", 146, 45, 118)
    local EspNamesBtn = CreateToggleButton(OtherPage, "NOMS 🌈", 16, 125, 76)
    local EspChamsBtn = CreateToggleButton(OtherPage, "CHAMS 👁️", 102, 125, 76)
    local AimbotBtn = CreateToggleButton(OtherPage, "AIM 🎯", 188, 125, 76)

    -- ================= NAVIGATION =================
    local ProfileNavBtn = CreateToggleButton(CheatPage, "👤 Profil", 16, 205, 118)
    local OtherNavBtn = CreateToggleButton(CheatPage, "⚙️ Autre", 146, 205, 118)
    
    local ProfileBackBtn = Instance.new("TextButton", ProfilePage)
    ProfileBackBtn.Size, ProfileBackBtn.Position, ProfileBackBtn.BackgroundTransparency, ProfileBackBtn.Text = UDim2.new(0, 30, 0, 30), UDim2.new(0, 12, 0, 5), 1, "⬅"
    ProfileBackBtn.TextSize, ProfileBackBtn.TextColor3, ProfileBackBtn.Font = 16, Colors.AppleBlue, Enum.Font.GothamBold
    
    local OtherBackBtn = Instance.new("TextButton", OtherPage)
    OtherBackBtn.Size, OtherBackBtn.Position, OtherBackBtn.BackgroundTransparency, OtherBackBtn.Text = UDim2.new(0, 30, 0, 30), UDim2.new(0, 12, 0, 5), 1, "⬅"
    OtherBackBtn.TextSize, OtherBackBtn.TextColor3, OtherBackBtn.Font = 16, Colors.AppleBlue, Enum.Font.GothamBold

    ProfileNavBtn.MouseButton1Click:Connect(function() TweenService:Create(CheatPage, AnimBouncy, {Position = UDim2.new(-1, 0, 0, 0)}):Play(); TweenService:Create(ProfilePage, AnimBouncy, {Position = UDim2.new(0, 0, 0, 0)}):Play() end)
    ProfileBackBtn.MouseButton1Click:Connect(function() TweenService:Create(CheatPage, AnimBouncy, {Position = UDim2.new(0, 0, 0, 0)}):Play(); TweenService:Create(ProfilePage, AnimBouncy, {Position = UDim2.new(1, 0, 0, 0)}):Play() end)
    OtherNavBtn.MouseButton1Click:Connect(function() TweenService:Create(CheatPage, AnimBouncy, {Position = UDim2.new(1, 0, 0, 0)}):Play(); TweenService:Create(OtherPage, AnimBouncy, {Position = UDim2.new(0, 0, 0, 0)}):Play() end)
    OtherBackBtn.MouseButton1Click:Connect(function() TweenService:Create(CheatPage, AnimBouncy, {Position = UDim2.new(0, 0, 0, 0)}):Play(); TweenService:Create(OtherPage, AnimBouncy, {Position = UDim2.new(-1, 0, 0, 0)}):Play() end)

    -- Toggle Menu
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

    local function UpdateButtonVisual(btn, active) TweenService:Create(btn, AnimFast, {BackgroundColor3 = active and Colors.AppleBlue or Colors.Surface, BackgroundTransparency = active and 0.1 or 0.4}):Play() end

    -- ================= SLIDERS LOGIC =================
    local function SetupSlider(bg, fill, label, resetBtn, configKey, defaultV, textPrefix)
        local dragging = false
        bg.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
        UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relativeX = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                Config[configKey] = math.floor(relativeX * Config.MaxSpeed)
                TweenService:Create(fill, AnimFast, {Size = UDim2.new(relativeX, 0, 1, 0)}):Play()
                label.Text = textPrefix .. " : " .. Config[configKey]
            end
        end)
        resetBtn.MouseButton1Click:Connect(function()
            Config[configKey] = defaultV
            TweenService:Create(fill, AnimSmooth, {Size = UDim2.new(defaultV / Config.MaxSpeed, 0, 1, 0)}):Play()
            label.Text = textPrefix .. " : " .. defaultV
        end)
    end

    SetupSlider(FlySliderBg, FlySliderFill, FlyLabel, FlyReset, "FlySpeed", DefaultConfig.FlySpeed, "Vitesse de Vol")
    SetupSlider(SpinSliderBg, SpinSliderFill, SpinLabel, SpinReset, "SpinSpeed", DefaultConfig.SpinSpeed, "Vitesse de Spin")

    -- ================= BOUTONS LOGIC =================
    FlyBtn.MouseButton1Click:Connect(function() State.Fly = not State.Fly; UpdateButtonVisual(FlyBtn, State.Fly); local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"); local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid"); if root and hum then hum.PlatformStand, root.Anchored = State.Fly, State.Fly end end)
    LockBtn.MouseButton1Click:Connect(function() State.ShiftLock = not State.ShiftLock; if State.ShiftLock then State.Spin = false; UpdateButtonVisual(SpinBtn, false) end; UpdateButtonVisual(LockBtn, State.ShiftLock) end)
    SpinBtn.MouseButton1Click:Connect(function() State.Spin = not State.Spin; if State.Spin then State.ShiftLock = false; UpdateButtonVisual(LockBtn, false) end; UpdateButtonVisual(SpinBtn, State.Spin) end)
    NoclipBtn.MouseButton1Click:Connect(function() State.Noclip = not State.Noclip; UpdateButtonVisual(NoclipBtn, State.Noclip) end)
    WalkBtn.MouseButton1Click:Connect(function() State.Walk = not State.Walk; UpdateButtonVisual(WalkBtn, State.Walk); if not State.Walk and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = 16 end end)
    JumpBtn.MouseButton1Click:Connect(function() State.Jump = not State.Jump; UpdateButtonVisual(JumpBtn, State.Jump); if not State.Jump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = 50 end end)
    EspNamesBtn.MouseButton1Click:Connect(function() State.EspNames = not State.EspNames; UpdateButtonVisual(EspNamesBtn, State.EspNames) end)
    EspChamsBtn.MouseButton1Click:Connect(function() State.EspChams = not State.EspChams; UpdateButtonVisual(EspChamsBtn, State.EspChams) end)
    AimbotBtn.MouseButton1Click:Connect(function() State.Aimbot = not State.Aimbot; UpdateButtonVisual(AimbotBtn, State.Aimbot) end)

    -- ================= ESP FONCTIONS =================
    local function UpdateESP()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                -- ESP CHAMS
                local highlight = player.Character:FindFirstChild("ShadowChams")
                if State.EspChams then
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "ShadowChams"
                        highlight.FillColor = Colors.AppleRed
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        highlight.Parent = player.Character
                    end
                else
                    if highlight then highlight:Destroy() end
                end

                -- ESP NAMES
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local bbGui = head:FindFirstChild("ShadowName")
                    if State.EspNames then
                        if not bbGui then
                            bbGui = Instance.new("BillboardGui", head)
                            bbGui.Name = "ShadowName"
                            bbGui.Size = UDim2.new(0, 100, 0, 40)
                            bbGui.StudsOffset = Vector3.new(0, 2, 0)
                            bbGui.AlwaysOnTop = true
                            local txt = Instance.new("TextLabel", bbGui)
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

    -- ================= AIMBOT FONCTION =================
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

    -- ================= NOCLIP (MURS OUI, ESCALIERS NON) =================
    RunService.Stepped:Connect(function()
        if State.Noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)

    -- ================= BOUCLE DE RENDU =================
    RunService:BindToRenderStep("ShadowRenderEngine", Enum.RenderPriority.Camera.Value - 1, function(deltaTime)
        TitleGrad.Rotation = (TitleGrad.Rotation + 1.5) % 360
        OtherGrad.Rotation = (OtherGrad.Rotation + 1.5) % 360

        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        UpdateESP()

        -- Aimbot (Lock via Clic Droit)
        if State.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local target = GetClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                local targetPos = target.Character.Head.Position
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), Config.AimbotSmoothness)
            end
        end

        if hum then
            if State.Walk then hum.WalkSpeed = Config.WalkSpeed end
            if State.Jump then hum.UseJumpPower = true; hum.JumpPower = Config.JumpPower end
        end

        if root then
            if State.Fly then
                local moveDir = Controls and Controls:GetMoveVector() or Vector3.zero
                local look = Camera.CFrame.LookVector
                local right = Camera.CFrame.RightVector
                local direction = (look * -moveDir.Z) + (right * moveDir.X)
                if direction.Magnitude > 0 then direction = direction.Unit end
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
                    if hum then hum.AutoRotate = false end
                    State.SpinAngle = State.SpinAngle + (Config.SpinSpeed * deltaTime * 2)
                    root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Config.SpinSpeed * deltaTime), 0)
                elseif State.ShiftLock then 
                    if hum then hum.AutoRotate = false end
                    local look = Camera.CFrame.LookVector
                    root.CFrame = CFrame.lookAt(root.Position, Vector3.new(root.Position.X + look.X, root.Position.Y, root.Position.Z + look.Z))
                else 
                    if hum then hum.AutoRotate = true end 
                end
            end
        end
    end)
end

-- ====================================================================
-- 🔐 SYSTÈME DE CLÉ (KEY SYSTEM) SECRET AU LANCEMENT
-- ====================================================================
local KeyFrame = Instance.new("CanvasGroup")
KeyFrame.Size = UDim2.new(0, 320, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -100)
KeyFrame.BackgroundColor3 = Colors.GlassBG
KeyFrame.BackgroundTransparency = 0.25
KeyFrame.Parent = ScreenGui

Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 16)
local KeyStroke = Instance.new("UIStroke", KeyFrame)
KeyStroke.Color, KeyStroke.Thickness, KeyStroke.Transparency = Color3.fromRGB(255, 255, 255), 1, 0.8

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size, KeyTitle.Position = UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 10)
KeyTitle.BackgroundTransparency, KeyTitle.Text = 1, "SHADOW VIP KEY"
KeyTitle.Font, KeyTitle.TextSize, KeyTitle.TextColor3 = Enum.Font.GothamBlack, 18, Color3.fromRGB(255, 255, 255)
local KeyGrad = Instance.new("UIGradient", KeyTitle)
KeyGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Colors.AppleRed), ColorSequenceKeypoint.new(1, Colors.AppleBlue)})

local KeySub = Instance.new("TextLabel", KeyFrame)
KeySub.Size, KeySub.Position, KeySub.BackgroundTransparency = UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 45), 1
KeySub.Text, KeySub.TextColor3, KeySub.Font, KeySub.TextSize = "Veuillez entrer votre clé d'accès.", Colors.AppleSubText, Enum.Font.GothamMedium, 12

local KeyBox = Instance.new("TextBox", KeyFrame)
KeyBox.Size, KeyBox.Position = UDim2.new(0, 280, 0, 40), UDim2.new(0.5, -140, 0, 75)
KeyBox.BackgroundColor3, KeyBox.BackgroundTransparency = Colors.Surface, 0.5
KeyBox.Text, KeyBox.PlaceholderText = "", "shadow_xxxxxxxx..."
KeyBox.TextColor3, KeyBox.PlaceholderColor3 = Colors.AppleText, Colors.AppleSubText
KeyBox.Font, KeyBox.TextSize = Enum.Font.GothamMedium, 14
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)

local GetKeyBtn = Instance.new("TextButton", KeyFrame)
GetKeyBtn.Size, GetKeyBtn.Position = UDim2.new(0, 135, 0, 40), UDim2.new(0, 20, 0, 135)
GetKeyBtn.BackgroundColor3, GetKeyBtn.Text = Colors.Surface, "GET KEY"
GetKeyBtn.TextColor3, GetKeyBtn.Font, GetKeyBtn.TextSize = Colors.AppleText, Enum.Font.GothamBold, 12
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 8)

local VerifyBtn = Instance.new("TextButton", KeyFrame)
VerifyBtn.Size, VerifyBtn.Position = UDim2.new(0, 135, 0, 40), UDim2.new(0, 165, 0, 135)
VerifyBtn.BackgroundColor3, VerifyBtn.Text = Colors.AppleBlue, "VERIFY"
VerifyBtn.TextColor3, VerifyBtn.Font, VerifyBtn.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12
Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 8)

local KeyRender = RunService.RenderStepped:Connect(function()
    KeyGrad.Rotation = (KeyGrad.Rotation + 1.5) % 360
end)

-- Bouton "GET KEY"
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

-- Validation
VerifyBtn.MouseButton1Click:Connect(function()
    local input = string.lower(KeyBox.Text)
    
    if string.sub(input, 1, 7) == "shadow_" then
        VerifyBtn.Text = "SUCCESS"
        TweenService:Create(VerifyBtn, AnimFast, {BackgroundColor3 = Colors.AppleGreen}):Play()
        task.wait(0.5)
        
        KeyRender:Disconnect()
        local closeTween = TweenService:Create(KeyFrame, AnimBouncy, {Size = UDim2.new(0, 0, 0, 0), GroupTransparency = 1})
        closeTween:Play()
        closeTween.Completed:Wait()
        KeyFrame:Destroy()
        
        StartShadowVIP() -- Charge TOUT le script ci-dessus !
    else
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
