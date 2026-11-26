return function(Ctx)
local UserInputService = Ctx.Services.UserInputService
local TweenService = Ctx.Services.TweenService
local Players = Ctx.Services.Players
local RunService = Ctx.Services.RunService
local TeleportService = Ctx.Services.TeleportService
local HttpService = Ctx.Services.HttpService
local Lighting = Ctx.Services.Lighting
local player = Ctx.Player
local camera = Ctx.Camera
local Theme = Ctx.Theme
local FontDesc = Ctx.FontDesc
local FontMain = Ctx.FontMain
local Settings = Ctx.Settings
local CombatTab = Ctx.Pages.Combat
local MovementTab = Ctx.Pages.Movement
local PlayerTab = Ctx.Pages.Player
local VisualsTab = Ctx.Pages.Visuals
local WorldTab = Ctx.Pages.World
local MiscTab = Ctx.Pages.Misc
local CreateButton = Ctx.UI.CreateButton
local CreateToggle = Ctx.UI.CreateToggle
local CreateSlider = Ctx.UI.CreateSlider
local CreateDropdown = Ctx.UI.CreateDropdown
local CreatePlayerListDropdown = Ctx.UI.CreatePlayerListDropdown
    
local FlyFrame = nil
local function initFlyPanel()
    if FlyFrame then return FlyFrame end
    local Frame = Instance.new("Frame")
    local onof = Instance.new("TextButton")
    local TextLabel = Instance.new("TextLabel")
    local plus = Instance.new("TextButton")
    local speed = Instance.new("TextLabel")
    local mine = Instance.new("TextButton")
    local closebutton = Instance.new("TextButton")
    local Color_GraphiteDark = Color3.fromRGB(30, 30, 35)
    local Color_GraphiteLight = Color3.fromRGB(45, 45, 50)
    local Color_GraphiteLabel = Color3.fromRGB(22, 22, 25)
    local Color_Lavender = Color3.fromRGB(186, 164, 238)
    local Color_TextWhite = Color3.fromRGB(240, 240, 245)
    local Color_MutedText = Color3.fromRGB(150, 150, 160)
    local function roundCorners(element, radius)
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, radius)
        uiCorner.Parent = element
    end
    FlyFrame = Frame
    Frame.Parent = Ctx.Gui.ScreenGui
    Frame.BackgroundColor3 = Color_GraphiteDark
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0.1, 0, 0.4, 0)
    Frame.Size = UDim2.new(0, 140, 0, 105)
    roundCorners(Frame, 10)
    local frameStroke = Instance.new("UIStroke")
    frameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    frameStroke.Color = Color_Lavender
    frameStroke.Thickness = 1.2
    frameStroke.Parent = Frame
    TextLabel.Parent = Frame
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.new(0, 12, 0, 8)
    TextLabel.Size = UDim2.new(0, 80, 0, 20)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.Text = "FLY"
    TextLabel.TextColor3 = Color_Lavender
    TextLabel.TextSize = 14
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    closebutton.Name = "Close"
    closebutton.Parent = Frame
    closebutton.BackgroundTransparency = 1
    closebutton.Size = UDim2.new(0, 16, 0, 16)
    closebutton.Position = UDim2.new(1, -24, 0, 10)
    closebutton.Font = Enum.Font.GothamBold
    closebutton.Text = "×"
    closebutton.TextColor3 = Color_Lavender
    closebutton.TextSize = 18
    mine.Name = "mine"
    mine.Parent = Frame
    mine.BackgroundColor3 = Color_GraphiteLight
    mine.BorderSizePixel = 0
    mine.Position = UDim2.new(0, 12, 0, 36)
    mine.Size = UDim2.new(0, 28, 0, 26)
    mine.Font = Enum.Font.GothamBold
    mine.Text = "-"
    mine.TextColor3 = Color_Lavender
    mine.TextSize = 14
    roundCorners(mine, 6)
    speed.Name = "speed"
    speed.Parent = Frame
    speed.BackgroundColor3 = Color_GraphiteLabel
    speed.BorderSizePixel = 0
    speed.Position = UDim2.new(0, 46, 0, 36)
    speed.Size = UDim2.new(0, 48, 0, 26)
    speed.Font = Enum.Font.GothamBold
    speed.Text = "1"
    speed.TextColor3 = Color_TextWhite
    speed.TextSize = 12
    roundCorners(speed, 6)
    plus.Name = "plus"
    plus.Parent = Frame
    plus.BackgroundColor3 = Color_GraphiteLight
    plus.BorderSizePixel = 0
    plus.Position = UDim2.new(0, 100, 0, 36)
    plus.Size = UDim2.new(0, 28, 0, 26)
    plus.Font = Enum.Font.GothamBold
    plus.Text = "+"
    plus.TextColor3 = Color_Lavender
    plus.TextSize = 14
    roundCorners(plus, 6)
    onof.Name = "onof"
    onof.Parent = Frame
    onof.BackgroundColor3 = Color_GraphiteLight
    onof.BorderSizePixel = 0
    onof.Position = UDim2.new(0, 12, 0, 68)
    onof.Size = UDim2.new(0, 116, 0, 26)
    onof.Font = Enum.Font.GothamBold
    onof.Text = "OFF"
    onof.TextColor3 = Color_MutedText
    onof.TextSize = 12
    roundCorners(onof, 6)
    local btnStroke = Instance.new("UIStroke")
    btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    btnStroke.Thickness = 1
    btnStroke.Color = Color3.fromRGB(55, 55, 60)
    btnStroke.Parent = onof
    local speeds = 1
    local speaker = player
    local nowe = false
    local tpwalking = false
    Frame.Active = true
    Frame.Draggable = true
    onof.MouseButton1Down:connect(function()
        if nowe == true then
            nowe = false
            onof.Text = "OFF"
            onof.TextColor3 = Color_MutedText
            onof.BackgroundColor3 = Color_GraphiteLight
            btnStroke.Color = Color3.fromRGB(55, 55, 60)
            btnStroke.Thickness = 1
            for _, st in ipairs({
                Enum.HumanoidStateType.Climbing, Enum.HumanoidStateType.FallingDown,
                Enum.HumanoidStateType.Flying, Enum.HumanoidStateType.Freefall,
                Enum.HumanoidStateType.GettingUp, Enum.HumanoidStateType.Jumping,
                Enum.HumanoidStateType.Landed, Enum.HumanoidStateType.Physics,
                Enum.HumanoidStateType.PlatformStanding, Enum.HumanoidStateType.Ragdoll,
                Enum.HumanoidStateType.Running, Enum.HumanoidStateType.RunningNoPhysics,
                Enum.HumanoidStateType.Seated, Enum.HumanoidStateType.StrafingNoPhysics,
                Enum.HumanoidStateType.Swimming
            }) do
                speaker.Character.Humanoid:SetStateEnabled(st, true)
            end
            speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        else
            nowe = true
            onof.Text = "ON"
            onof.TextColor3 = Color_Lavender
            onof.BackgroundColor3 = Color3.fromRGB(38, 35, 45)
            btnStroke.Color = Color_Lavender
            btnStroke.Thickness = 1.5
            for i = 1, speeds do
                spawn(function()
                    local hb = RunService.Heartbeat
                    tpwalking = true
                    local chr = player.Character
                    local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                    while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                        if hum.MoveDirection.Magnitude > 0 then
                            chr:TranslateBy(hum.MoveDirection)
                        end
                    end
                end)
            end
            player.Character.Animate.Disabled = true
            local Char = player.Character
            local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
            for _, v in next, Hum:GetPlayingAnimationTracks() do
                v:AdjustSpeed(0)
            end
            for _, st in ipairs({
                Enum.HumanoidStateType.Climbing, Enum.HumanoidStateType.FallingDown,
                Enum.HumanoidStateType.Flying, Enum.HumanoidStateType.Freefall,
                Enum.HumanoidStateType.GettingUp, Enum.HumanoidStateType.Jumping,
                Enum.HumanoidStateType.Landed, Enum.HumanoidStateType.Physics,
                Enum.HumanoidStateType.PlatformStanding, Enum.HumanoidStateType.Ragdoll,
                Enum.HumanoidStateType.Running, Enum.HumanoidStateType.RunningNoPhysics,
                Enum.HumanoidStateType.Seated, Enum.HumanoidStateType.StrafingNoPhysics,
                Enum.HumanoidStateType.Swimming
            }) do
                speaker.Character.Humanoid:SetStateEnabled(st, false)
            end
            speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
        end
        local rootPart = player.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6
            and player.Character.Torso or player.Character.UpperTorso
        local ctrl = {f = 0, b = 0, l = 0, r = 0}
        local lastctrl = {f = 0, b = 0, l = 0, r = 0}
        local maxspeed = 50
        local spd = 0
        local bg = Instance.new("BodyGyro", rootPart)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = rootPart.CFrame
        local bv = Instance.new("BodyVelocity", rootPart)
        bv.velocity = Vector3.new(0, 0.1, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        if nowe == true then
            player.Character.Humanoid.PlatformStand = true
        end
        while nowe == true or player.Character.Humanoid.Health == 0 do
            RunService.RenderStepped:Wait()
            if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                spd = spd + .5 + (spd / maxspeed)
                if spd > maxspeed then spd = maxspeed end
            elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and spd ~= 0 then
                spd = spd - 1
                if spd < 0 then spd = 0 end
            end
            if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                bv.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f + ctrl.b)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * .2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * spd
                lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
            elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and spd ~= 0 then
                bv.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f + lastctrl.b)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * .2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * spd
            else
                bv.velocity = Vector3.new(0, 0, 0)
            end
            bg.cframe = workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * spd / maxspeed), 0, 0)
        end
        bg:Destroy()
        bv:Destroy()
        player.Character.Humanoid.PlatformStand = false
        player.Character.Animate.Disabled = false
        tpwalking = false
    end)
    player.CharacterAdded:Connect(function()
        wait(0.7)
        player.Character.Humanoid.PlatformStand = false
        player.Character.Animate.Disabled = false
    end)
    local function resetFlyWalk()
        tpwalking = false
        for _ = 1, speeds do
            spawn(function()
                local hb = RunService.Heartbeat
                tpwalking = true
                local chr = player.Character
                local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                    if hum.MoveDirection.Magnitude > 0 then
                        chr:TranslateBy(hum.MoveDirection)
                    end
                end
            end)
        end
    end
    plus.MouseButton1Down:connect(function()
        speeds = speeds + 1
        speed.Text = speeds
        if nowe == true then resetFlyWalk() end
    end)
    mine.MouseButton1Down:connect(function()
        if speeds > 1 then
            speeds = speeds - 1
            speed.Text = speeds
            if nowe == true then resetFlyWalk() end
        end
    end)
    closebutton.MouseButton1Click:Connect(function() Frame.Visible = false end)
    return FlyFrame
end

_G.TracersList = {}
_G.Skeletons = {}
local function getChar() return player.Character or player.CharacterAdded:Wait() end
local function getHum() return getChar():WaitForChild("Humanoid") end

RunService.Stepped:Connect(function()
    local char = player.Character
    if char then
        if Settings.SpeedHackEnabled and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Settings.WalkSpeed
        end
        if Settings.JumpHackEnabled and char:FindFirstChild("Humanoid") then
            char.Humanoid.UseJumpPower = true
            char.Humanoid.JumpPower = Settings.JumpPower
        end
        if Settings.Noclip then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
            end
        end
if char:FindFirstChild("HumanoidRootPart") then
    char.HumanoidRootPart.Anchored = Settings.FreezeSelf
end
if char:FindFirstChildOfClass("Humanoid") then
    char:FindFirstChildOfClass("Humanoid").PlatformStand = Settings.FreezeSelf
end
        if Settings.Spinbot and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(25), 0)
        end
    end
end)

CreateToggle(CombatTab, "Aimbot (Lock-on)", function(state)
    Settings.Aimbot = state
    if state then
        task.spawn(function()
            while Settings.Aimbot do
                local closest, maxDist = nil, math.huge
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                        local dist = (p.Character.Head.Position - camera.CFrame.Position).Magnitude
                        if dist < maxDist then closest = p; maxDist = dist end
                    end
                end
                if closest then
                    camera.CFrame = CFrame.new(camera.CFrame.Position, closest.Character.Head.Position)
                end
                task.wait()
            end
        end)
    end
end)

CreateToggle(MovementTab, "Enable Speed Hack", function(state)
    Settings.SpeedHackEnabled = state
    if not state then pcall(function() getHum().WalkSpeed = 16 end) end
end)
CreateSlider(MovementTab, "WalkSpeed Value", 16, 250, 16, function(v) Settings.WalkSpeed = v end)

CreateToggle(MovementTab, "Enable Jump Hack", function(state)
    Settings.JumpHackEnabled = state
    if not state then pcall(function() getHum().JumpPower = 50 end) end
end)
CreateSlider(MovementTab, "JumpPower Value", 50, 350, 50, function(v) Settings.JumpPower = v end)

UserInputService.JumpRequest:Connect(function()
    if Settings.InfJump then pcall(function() getHum():ChangeState(Enum.HumanoidStateType.Jumping) end) end
end)
CreateToggle(MovementTab, "Infinite Jump", function(state) Settings.InfJump = state end)
CreateToggle(MovementTab, "Noclip", function(state) Settings.Noclip = state end)
CreateToggle(MovementTab, "Spinbot", function(state) Settings.Spinbot = state end)

CreateButton(MovementTab, "Open Fly Panel (first activation double tap)", function()
    local flyPanel = initFlyPanel()
    flyPanel.Visible = not flyPanel.Visible
end)

CreateToggle(PlayerTab, "Freeze My Character", function(state)
    Settings.FreezeSelf = state
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if state then
        if hrp then hrp.Anchored = true end
        if hum then
            hum.PlatformStand = true
            -- Отключаем все состояния движения
            for _, st in ipairs({
                Enum.HumanoidStateType.Running,
                Enum.HumanoidStateType.RunningNoPhysics,
                Enum.HumanoidStateType.Jumping,
                Enum.HumanoidStateType.FallingDown,
                Enum.HumanoidStateType.Freefall,
                Enum.HumanoidStateType.Climbing,
                Enum.HumanoidStateType.Swimming,
                Enum.HumanoidStateType.GettingUp,
                Enum.HumanoidStateType.Landed,
                Enum.HumanoidStateType.Seated,
                Enum.HumanoidStateType.Physics,
                Enum.HumanoidStateType.PlatformStanding,
                Enum.HumanoidStateType.Ragdoll,
                Enum.HumanoidStateType.StrafingNoPhysics,
                Enum.HumanoidStateType.Flying
            }) do
                pcall(function() hum:SetStateEnabled(st, false) end)
            end
        end
    else
        if hrp then hrp.Anchored = false end
        if hum then
            hum.PlatformStand = false
            -- Включаем все состояния обратно
            for _, st in ipairs({
                Enum.HumanoidStateType.Running,
                Enum.HumanoidStateType.RunningNoPhysics,
                Enum.HumanoidStateType.Jumping,
                Enum.HumanoidStateType.FallingDown,
                Enum.HumanoidStateType.Freefall,
                Enum.HumanoidStateType.Climbing,
                Enum.HumanoidStateType.Swimming,
                Enum.HumanoidStateType.GettingUp,
                Enum.HumanoidStateType.Landed,
                Enum.HumanoidStateType.Seated,
                Enum.HumanoidStateType.Physics,
                Enum.HumanoidStateType.PlatformStanding,
                Enum.HumanoidStateType.Ragdoll,
                Enum.HumanoidStateType.StrafingNoPhysics,
                Enum.HumanoidStateType.Flying
            }) do
                pcall(function() hum:SetStateEnabled(st, true) end)
            end
        end
    end
end)

-- Invisible platform (Anti-Void)
do
    local PlatformPart = nil
    local PlatformConnection = nil
    local function StopPlatform()
        if PlatformConnection then PlatformConnection:Disconnect(); PlatformConnection = nil end
        if PlatformPart then PlatformPart:Destroy(); PlatformPart = nil end
    end
    local function StartPlatform()
        StopPlatform()
        local char = player.Character
        if not char then return end
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not rootPart or not humanoid then return end
        local hipHeight = humanoid.HipHeight > 0 and humanoid.HipHeight or 2
        local spawnY = rootPart.Position.Y - (hipHeight + (rootPart.Size.Y / 2))
        PlatformPart = Instance.new("Part")
        PlatformPart.Name = "ClientAntiVoidPlatform"
        PlatformPart.Size = Vector3.new(16, 0.5, 16)
        PlatformPart.Material = Enum.Material.SmoothPlastic
        PlatformPart.Transparency = 1
        PlatformPart.Anchored = true
        PlatformPart.CanCollide = true
        PlatformPart.Position = Vector3.new(rootPart.Position.X, spawnY - 0.25, rootPart.Position.Z)
        PlatformPart.Parent = workspace
        PlatformConnection = RunService.PostSimulation:Connect(function()
            local currentChar = player.Character
            local root = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
            if root and PlatformPart then
                PlatformPart.Position = Vector3.new(root.Position.X, spawnY - 0.25, root.Position.Z)
            end
        end)
    end
    CreateToggle(MovementTab, "Invisible platform", function(state)
        if state then StartPlatform() else StopPlatform() end
    end)
end

-- ESP
do
local espFolder = Instance.new("Folder", Ctx.Gui.ScreenGui)
Settings.ESPColor = Color3.new(1, 1, 1)

local espColors = {
    ["White"] = Color3.new(1, 1, 1),
    ["Red"] = Color3.fromRGB(255, 80, 80),
    ["Green"] = Color3.fromRGB(80, 255, 120),
    ["Blue"] = Color3.fromRGB(80, 160, 255),
    ["Yellow"] = Color3.fromRGB(255, 220, 80),
    ["Purple"] = Color3.fromRGB(186, 164, 238),
    ["Cyan"] = Color3.fromRGB(80, 240, 255),
    ["Orange"] = Color3.fromRGB(255, 160, 80)
}

local function updateESP()
    espFolder:ClearAllChildren()
    if not Settings.ESP then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            local bg = Instance.new("BillboardGui", espFolder)
            bg.Adornee = p.Character.Head
            bg.Size = UDim2.new(0, 120, 0, 32)
            bg.AlwaysOnTop = true
            bg.StudsOffset = Vector3.new(0, 2.5, 0)
            bg.LightInfluence = 0 -- Видно даже в темноте
            
            local tl = Instance.new("TextLabel", bg)
            tl.Size = UDim2.new(1, 0, 1, 0)
            tl.BackgroundTransparency = 1
            tl.Text = p.Name
            tl.TextColor3 = Settings.ESPColor
            tl.Font = FontMain -- Более красивый шрифт
            tl.TextSize = 14
            tl.TextStrokeTransparency = 0.5 -- Обводка для читаемости
            tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            tl.TextScaled = false
        end
    end
end

local function updateESPColors()
    for _, bg in ipairs(espFolder:GetChildren()) do
        local tl = bg:FindFirstChildOfClass("TextLabel")
        if tl then tl.TextColor3 = Settings.ESPColor end
    end
end

Players.PlayerAdded:Connect(updateESP)
Players.PlayerRemoving:Connect(updateESP)

CreateToggle(VisualsTab, "ESP (Player Names)", function(state) 
    Settings.ESP = state
    updateESP() 
end)

CreateDropdown(VisualsTab, "ESP Color", {
    "White", "Red", "Green", "Blue", 
    "Yellow", "Purple", "Cyan", "Orange"
}, "White", function(colorName)
    Settings.ESPColor = espColors[colorName] or Color3.new(1, 1, 1)
    updateESPColors()
end)
end

-- Tracers & Chams
do
    local function clearTracer(p)
        if _G.TracersList[p] then
            pcall(function() _G.TracersList[p]:Destroy() end)
            _G.TracersList[p] = nil
        end
    end
    local TracerStyleDropdown
    CreateToggle(VisualsTab, "Tracers", function(state)
        Settings.Tracers = state
        if TracerStyleDropdown then TracerStyleDropdown.Visible = state end
        if not state then
            for p, _ in pairs(_G.TracersList) do clearTracer(p) end
        end
    end)
    TracerStyleDropdown = CreateDropdown(VisualsTab, "Tracer Style", {"Top", "Center", "Mouse"}, "Center", function(style)
        Settings.TracerStyle = style
    end)
    TracerStyleDropdown.Visible = false
    local function updateTracers()
        if not Settings.Tracers or not Drawing then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                if not _G.TracersList[p] then
                    _G.TracersList[p] = Drawing.new("Line")
                    _G.TracersList[p].Color = Theme.Lavender
                    _G.TracersList[p].Thickness = 1.5
                    _G.TracersList[p].Transparency = 1
                end
                local vec, onScreen = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if not onScreen and vec.Z < 0 then
                    local cx, cy = camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2
                    vec = Vector3.new(cx - (vec.X - cx), cy - (vec.Y - cy), vec.Z)
                end
                local startPoint = Settings.TracerStyle == "Top" and Vector2.new(camera.ViewportSize.X / 2, 0)
                    or (Settings.TracerStyle == "Mouse" and UserInputService:GetMouseLocation()
                    or Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2))
                _G.TracersList[p].From = startPoint
                _G.TracersList[p].To = Vector2.new(vec.X, vec.Y)
                _G.TracersList[p].Visible = true
            else
                clearTracer(p)
            end
        end
    end
    local function clearCham(p)
        if _G.Skeletons[p] then
            for _, obj in pairs(_G.Skeletons[p]) do pcall(function() obj:Destroy() end) end
            _G.Skeletons[p] = nil
        end
    end
    local ChamStyleDropdown
    CreateToggle(VisualsTab, "Chams", function(state)
        Settings.Chams = state
        if ChamStyleDropdown then ChamStyleDropdown.Visible = state end
        if not state then
            for p, _ in pairs(_G.Skeletons) do clearCham(p) end
        end
    end)
    ChamStyleDropdown = CreateDropdown(VisualsTab, "Cham Style", {"Skeleton", "Box"}, "Skeleton", function(style)
        Settings.ChamStyle = style
        for p, _ in pairs(_G.Skeletons) do clearCham(p) end
    end)
    ChamStyleDropdown.Visible = false
    local skeletonParts = {"Head", "UpperTorso", "LowerTorso", "Spine", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}
    local boxParts = {"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
    local function updateChams()
        if not Settings.Chams or not Drawing then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                if not _G.Skeletons[p] then
                    _G.Skeletons[p] = {}
                    if Settings.ChamStyle == "Skeleton" then
                        for _, partName in ipairs(skeletonParts) do
                            local line = Drawing.new("Line")
                            line.Color = Theme.Lavender; line.Thickness = 2.5; line.Transparency = 1; line.Visible = false
                            _G.Skeletons[p][partName] = line
                        end
                    else
                        local box = Drawing.new("Square")
                        box.Color = Theme.Lavender; box.Thickness = 2; box.Transparency = 1; box.Filled = false; box.Visible = false
                        _G.Skeletons[p].Box = box
                    end
                end
                local char = p.Character
                local cham = _G.Skeletons[p]
                if Settings.ChamStyle == "Skeleton" then
                    if not cham.Head then
                        for _, obj in pairs(cham) do pcall(function() obj:Destroy() end) end
                        for _, partName in ipairs(skeletonParts) do
                            local line = Drawing.new("Line")
                            line.Color = Theme.Lavender; line.Thickness = 2.5; line.Transparency = 1; line.Visible = false
                            cham[partName] = line
                        end
                    end
                    local function gp(name)
                        local part = char:FindFirstChild(name)
                        if part then
                            local vec, onScreen = camera:WorldToViewportPoint(part.Position)
                            if onScreen then return Vector2.new(vec.X, vec.Y) end
                        end
                        return nil
                    end
                    local function connect(lineObj, p1, p2)
                        if p1 and p2 then lineObj.From = p1; lineObj.To = p2; lineObj.Visible = true else lineObj.Visible = false end
                    end
                    if char.Humanoid.RigType == Enum.HumanoidRigType.R15 then
                        connect(cham.Head, gp("Head"), gp("UpperTorso"))
                        connect(cham.LeftUpperArm, gp("UpperTorso"), gp("LeftUpperArm"))
                        connect(cham.LeftLowerArm, gp("LeftUpperArm"), gp("LeftLowerArm"))
                        connect(cham.LeftHand, gp("LeftLowerArm"), gp("LeftHand"))
                        connect(cham.RightUpperArm, gp("UpperTorso"), gp("RightUpperArm"))
                        connect(cham.RightLowerArm, gp("RightUpperArm"), gp("RightLowerArm"))
                        connect(cham.RightHand, gp("RightLowerArm"), gp("RightHand"))
                        connect(cham.LeftUpperLeg, gp("LowerTorso"), gp("LeftUpperLeg"))
                        connect(cham.LeftLowerLeg, gp("LeftUpperLeg"), gp("LeftLowerLeg"))
                        connect(cham.LeftFoot, gp("LeftLowerLeg"), gp("LeftFoot"))
                        connect(cham.RightUpperLeg, gp("LowerTorso"), gp("RightUpperLeg"))
                        connect(cham.RightLowerLeg, gp("RightUpperLeg"), gp("RightLowerLeg"))
                        connect(cham.RightFoot, gp("RightLowerLeg"), gp("RightFoot"))
                        connect(cham.Spine, gp("LowerTorso"), gp("UpperTorso"))
                    else
                        connect(cham.Head, gp("Head"), gp("Torso"))
                        connect(cham.LeftUpperArm, gp("Torso"), gp("Left Arm"))
                        connect(cham.RightUpperArm, gp("Torso"), gp("Right Arm"))
                        connect(cham.LeftUpperLeg, gp("Torso"), gp("Left Leg"))
                        connect(cham.RightUpperLeg, gp("Torso"), gp("Right Leg"))
                    end
                else
                    if not cham.Box then
                        for _, obj in pairs(cham) do pcall(function() obj:Destroy() end) end
                        local box = Drawing.new("Square")
                        box.Color = Theme.Lavender; box.Thickness = 2; box.Transparency = 1; box.Filled = false; box.Visible = false
                        cham.Box = box
                    end
                    local minX, minY = math.huge, math.huge
                    local maxX, maxY = -math.huge, -math.huge
                    local hasPart = false
                    for _, partName in ipairs(boxParts) do
                        local part = char:FindFirstChild(partName)
                        if part and part:IsA("BasePart") then
                            local vec, onScreen = camera:WorldToViewportPoint(part.Position)
                            if onScreen then
                                hasPart = true
                                if vec.X < minX then minX = vec.X end
                                if vec.Y < minY then minY = vec.Y end
                                if vec.X > maxX then maxX = vec.X end
                                if vec.Y > maxY then maxY = vec.Y end
                            end
                        end
                    end
                    if hasPart then
                        local padding = 5
                        cham.Box.Position = Vector2.new(minX, minY)
                        cham.Box.Size = Vector2.new(maxX - minX, maxY - minY)
                        cham.Box.Visible = true
                    else
                        cham.Box.Visible = false
                    end
                end
            else
                clearCham(p)
            end
        end
    end
    Players.PlayerRemoving:Connect(function(p) clearTracer(p); clearCham(p) end)
    RunService.RenderStepped:Connect(function() pcall(updateTracers); pcall(updateChams) end)
-- Freecam & FOV
do
local freecamConnection = nil
local freecamCFrame = nil
local wasPlatformStand = false
local wasWalkSpeed = 16
local wasJumpPower = 50
local wasJumpHeight = 7.2
local wasAutoRotate = true
local mouseDelta = Vector2.new(0, 0)
local cameraAngles = Vector2.new(0, 0)

CreateToggle(VisualsTab, "Freecam", function(state)
Settings.Freecam = state
local char = player.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
local hum = char and char:FindFirstChildOfClass("Humanoid")

if state then
     if hum then
         -- Сохраняем текущие значения
         wasPlatformStand = hum.PlatformStand
         wasWalkSpeed = hum.WalkSpeed
         wasJumpPower = hum.JumpPower
         wasJumpHeight = hum.JumpHeight
         wasAutoRotate = hum.AutoRotate
         
         -- Блокируем движение персонажа
         hum.PlatformStand = true
         hum.WalkSpeed = 0
         hum.JumpPower = 0
         hum.JumpHeight = 0
         hum.AutoRotate = false
         
         -- Отключаем все состояния движения, чтобы персонаж не двигался
         for _, st in ipairs({
             Enum.HumanoidStateType.Running,
             Enum.HumanoidStateType.RunningNoPhysics,
             Enum.HumanoidStateType.Jumping,
             Enum.HumanoidStateType.FallingDown,
             Enum.HumanoidStateType.Freefall,
             Enum.HumanoidStateType.Climbing,
             Enum.HumanoidStateType.Swimming,
             Enum.HumanoidStateType.GettingUp,
             Enum.HumanoidStateType.Landed,
             Enum.HumanoidStateType.Seated,
             Enum.HumanoidStateType.Physics,
             Enum.HumanoidStateType.PlatformStanding,
             Enum.HumanoidStateType.Ragdoll,
             Enum.HumanoidStateType.StrafingNoPhysics,
             Enum.HumanoidStateType.Flying
         }) do
             pcall(function() hum:SetStateEnabled(st, false) end)
         end
     end
     if hrp then hrp.Anchored = true end
     
     freecamCFrame = camera.CFrame
     cameraAngles = Vector2.new(0, 0)
     camera.CameraType = Enum.CameraType.Scriptable
     
     freecamConnection = RunService.RenderStepped:Connect(function(dt)
         local move = Vector3.new(0, 0, 0)
         local speed = Settings.FreecamSpeed * dt
         if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + freecamCFrame.LookVector end
         if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - freecamCFrame.LookVector end
         if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - freecamCFrame.RightVector end
         if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + freecamCFrame.RightVector end
         if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
         if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 1, 0) end
         
         if move.Magnitude > 0 then
             freecamCFrame = freecamCFrame + (move.Unit * speed)
         end
         
         if mouseDelta.Magnitude > 0 then
             cameraAngles = cameraAngles + Vector2.new(-mouseDelta.X * Settings.FreecamMouseSensitivity, -mouseDelta.Y * Settings.FreecamMouseSensitivity)
             cameraAngles = Vector2.new(
                 math.clamp(cameraAngles.X, -math.rad(90), math.rad(90)),
                 cameraAngles.Y % (math.pi * 2)
             )
             freecamCFrame = CFrame.new(freecamCFrame.Position) * CFrame.Angles(0, cameraAngles.Y, 0) * CFrame.Angles(cameraAngles.X, 0, 0)
         end
         
         camera.CFrame = freecamCFrame
         mouseDelta = Vector2.new(0, 0)
     end)
     
else
     if freecamConnection then
         freecamConnection:Disconnect()
         freecamConnection = nil
     end
     camera.CameraType = Enum.CameraType.Custom
     
     if hum then
         hum.PlatformStand = wasPlatformStand
         
         -- Восстанавливаем значения с учетом включенных хуков
         hum.WalkSpeed = Settings.SpeedHackEnabled and Settings.WalkSpeed or wasWalkSpeed
         hum.JumpPower = Settings.JumpHackEnabled and Settings.JumpPower or wasJumpPower
         hum.JumpHeight = wasJumpHeight
         hum.AutoRotate = wasAutoRotate
         
         -- Включаем все состояния обратно
         for _, st in ipairs({
             Enum.HumanoidStateType.Running,
             Enum.HumanoidStateType.RunningNoPhysics,
             Enum.HumanoidStateType.Jumping,
             Enum.HumanoidStateType.FallingDown,
             Enum.HumanoidStateType.Freefall,
             Enum.HumanoidStateType.Climbing,
             Enum.HumanoidStateType.Swimming,
             Enum.HumanoidStateType.GettingUp,
             Enum.HumanoidStateType.Landed,
             Enum.HumanoidStateType.Seated,
             Enum.HumanoidStateType.Physics,
             Enum.HumanoidStateType.PlatformStanding,
             Enum.HumanoidStateType.Ragdoll,
             Enum.HumanoidStateType.StrafingNoPhysics,
             Enum.HumanoidStateType.Flying
         }) do
             pcall(function() hum:SetStateEnabled(st, true) end)
         end
     end
     if hrp then hrp.Anchored = false end
end
end)

UserInputService.InputChanged:Connect(function(input)
if Settings.Freecam and input.UserInputType == Enum.UserInputType.MouseMovement then
mouseDelta = input.Delta
end
end)

CreateSlider(VisualsTab, "Freecam Speed", 10, 200, 50, function(v) Settings.FreecamSpeed = v end)
CreateSlider(VisualsTab, "FOV", 70, 120, 70, function(v) camera.FieldOfView = v end)
end

-- No Camera Bob
do
    local noBobConn = nil
    CreateToggle(VisualsTab, "No Camera Bob", function(state)
        Settings.NoCameraBob = state
        if state then
            if noBobConn then noBobConn:Disconnect() end
            noBobConn = RunService.RenderStepped:Connect(function()
                local char = player.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.CameraOffset = Vector3.new(0, 0, 0)
                end
            end)
        else
            if noBobConn then noBobConn:Disconnect(); noBobConn = nil end
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.CameraOffset = Vector3.new(0, 0, 0)
            end
        end
    end)
end

-- No Grass
do
    local originalGrass = {}
    local grassConn = nil
    local function removeGrass()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (
                obj.Name:lower():find("grass") or
                obj.Name:lower():find("bush") or
                obj.Material == Enum.Material.Grass
            ) then
                if not originalGrass[obj] then
                    originalGrass[obj] = {Transparency = obj.Transparency, CanCollide = obj.CanCollide}
                end
                obj.Transparency = 1
                obj.CanCollide = false
            end
        end
    end
    local function restoreGrass()
        for obj, data in pairs(originalGrass) do
            if obj and obj.Parent then
                obj.Transparency = data.Transparency
                obj.CanCollide = data.CanCollide
            end
        end
        originalGrass = {}
    end
    CreateToggle(VisualsTab, "No Grass", function(state)
        Settings.NoGrass = state
        if state then
            removeGrass()
            if grassConn then grassConn:Disconnect() end
            grassConn = workspace.DescendantAdded:Connect(function(obj)
                if Settings.NoGrass and obj:IsA("BasePart") and (
                    obj.Name:lower():find("grass") or
                    obj.Name:lower():find("bush") or
                    obj.Material == Enum.Material.Grass
                ) then
                    obj.Transparency = 1
                    obj.CanCollide = false
                end
            end)
        else
            restoreGrass()
            if grassConn then grassConn:Disconnect(); grassConn = nil end
        end
    end)
end

-- Long Jump
do
    local longJumpConn = nil
    local longJumpForce = 50
    CreateToggle(MovementTab, "Long Jump", function(state)
        Settings.LongJump = state
        if state then
            if longJumpConn then longJumpConn:Disconnect() end
            longJumpConn = UserInputService.JumpRequest:Connect(function()
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.FloorMaterial ~= Enum.Material.Air then
                    local direction = hum.MoveDirection
                    if direction.Magnitude > 0 then
                        hrp.Velocity = hrp.Velocity + direction * longJumpForce
                    else
                        hrp.Velocity = hrp.Velocity + hrp.CFrame.LookVector * longJumpForce
                    end
                end
            end)
        else
            if longJumpConn then longJumpConn:Disconnect(); longJumpConn = nil end
        end
    end)
    CreateSlider(MovementTab, "Long Jump Force", 50, 2000, 150, function(v)
        longJumpForce = v / 10
    end)
end

-- Speed Boost on Key (раскрывающийся, тумблер не улетает)
do
    local speedBoostConn = nil
    local inputEndedConn = nil
    local boostKey = Enum.KeyCode.LeftShift
    local boostSpeed = 100
    local originalSpeed = 16
    local isBoosting = false
    local isListeningForKey = false
    local speedBoostEnabled = false
    local isSliderDragging = false

    local HEADER_H = 38
    local BODY_H = 94

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -6, 0, HEADER_H)
    Container.BackgroundColor3 = Theme.ElementBg
    Container.ClipsDescendants = true
    Container.Parent = MovementTab
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", Container)
    Label.Size = UDim2.new(1, -60, 0, HEADER_H) 
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = "Speed Boost on Key"
    Label.TextColor3 = Theme.TextDark
    Label.Font = FontMain
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Switch = Instance.new("TextButton", Container)
    Switch.Size = UDim2.new(0, 36, 0, 20)
    Switch.Position = UDim2.new(1, -48, 0, 9) 
    Switch.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    Switch.Text = ""
    Switch.ZIndex = 10
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame", Switch)
    Circle.Size = UDim2.new(0, 14, 0, 14)
    Circle.Position = UDim2.new(0, 3, 0.5, -7)
    Circle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Circle.ZIndex = 11
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local Body = Instance.new("Frame", Container)
    Body.Size = UDim2.new(1, 0, 0, 0)
    Body.Position = UDim2.new(0, 0, 0, HEADER_H)
    Body.BackgroundTransparency = 1
    Body.Visible = false
    Body.ZIndex = 1

    local KeybindFrame = Instance.new("Frame", Body)
    KeybindFrame.Size = UDim2.new(1, -12, 0, 40)
    KeybindFrame.Position = UDim2.new(0, 6, 0, 6)
    KeybindFrame.BackgroundColor3 = Theme.MainBg
    Instance.new("UICorner", KeybindFrame).CornerRadius = UDim.new(0, 6)

    local KeybindLabel = Instance.new("TextLabel", KeybindFrame)
    KeybindLabel.Size = UDim2.new(0.6, -10, 1, 0)
    KeybindLabel.Position = UDim2.new(0, 12, 0, 0)
    KeybindLabel.BackgroundTransparency = 1
    KeybindLabel.Text = "Boost Key"
    KeybindLabel.TextColor3 = Theme.TextDark
    KeybindLabel.Font = FontMain
    KeybindLabel.TextSize = 13
    KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left

    local KeybindBtn = Instance.new("TextButton", KeybindFrame)
    KeybindBtn.Size = UDim2.new(0.35, -10, 0, 26)
    KeybindBtn.Position = UDim2.new(0.65, 0, 0.5, -13)
    KeybindBtn.BackgroundColor3 = Theme.ElementBg
    KeybindBtn.Text = "LeftShift"
    KeybindBtn.TextColor3 = Theme.Text
    KeybindBtn.Font = FontMain
    KeybindBtn.TextSize = 11
    Instance.new("UICorner", KeybindBtn).CornerRadius = UDim.new(0, 4)

    KeybindBtn.MouseButton1Click:Connect(function()
        if isListeningForKey then return end
        isListeningForKey = true
        KeybindBtn.Text = "Press a key..."
        KeybindBtn.TextColor3 = Theme.Lavender
        local conn
        conn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                boostKey = input.KeyCode
                KeybindBtn.Text = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                KeybindBtn.TextColor3 = Theme.Text
                isListeningForKey = false
                conn:Disconnect()
                if Ctx.Notify then
                    Ctx.Notify("Speed Boost", "Клавиша: " .. KeybindBtn.Text, 2, "success")
                end
            end
        end)
        task.delay(5, function()
            if isListeningForKey then
                isListeningForKey = false
                KeybindBtn.Text = tostring(boostKey):gsub("Enum.KeyCode.", "")
                KeybindBtn.TextColor3 = Theme.Text
                conn:Disconnect()
            end
        end)
    end)

    local SliderFrame = Instance.new("Frame", Body)
    SliderFrame.Size = UDim2.new(1, -12, 0, 48)
    SliderFrame.Position = UDim2.new(0, 6, 0, 52)
    SliderFrame.BackgroundColor3 = Theme.MainBg
    Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

    local SliderLabel = Instance.new("TextLabel", SliderFrame)
    SliderLabel.Size = UDim2.new(1, -20, 0, 22)
    SliderLabel.Position = UDim2.new(0, 12, 0, 4)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = "Boost Speed: " .. boostSpeed
    SliderLabel.TextColor3 = Theme.Text
    SliderLabel.Font = FontMain
    SliderLabel.TextSize = 12
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left

    local SliderBar = Instance.new("TextButton", SliderFrame)
    SliderBar.Size = UDim2.new(1, -24, 0, 6)
    SliderBar.Position = UDim2.new(0, 12, 0, 32)
    SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    SliderBar.Text = ""
    Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)

    local Progress = Instance.new("Frame", SliderBar)
    Progress.Size = UDim2.new((boostSpeed - 50) / (300 - 50), 0, 1, 0)
    Progress.BackgroundColor3 = Theme.Lavender
    Instance.new("UICorner", Progress).CornerRadius = UDim.new(1, 0)

    local function updateSlider(input)
        local xOffset = math.clamp(input.Position.X - SliderBar.AbsolutePosition.X, 0, SliderBar.AbsoluteSize.X)
        local percentage = xOffset / SliderBar.AbsoluteSize.X
        boostSpeed = math.round(50 + (300 - 50) * percentage)
        SliderLabel.Text = "Boost Speed: " .. boostSpeed
        Progress.Size = UDim2.new(percentage, 0, 1, 0)
        if isBoosting then
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = boostSpeed end
        end
    end

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliderDragging = true
            updateSlider(input)
        end
    end)

    -- Локальный обработчик движения мыши именно для этого слайдера
    UserInputService.InputChanged:Connect(function(input)
        if isSliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    -- Локальный обработчик отпускания кнопки мыши
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliderDragging = false
        end
    end)

    local function setExpanded(expanded)
        if expanded then
            Body.Visible = true
            TweenService:Create(Container, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -6, 0, HEADER_H + BODY_H)}):Play()
            TweenService:Create(Body, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, BODY_H)}):Play()
        else
            local tw = TweenService:Create(Container, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(1, -6, 0, HEADER_H)})
            TweenService:Create(Body, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            tw:Play()
            tw.Completed:Connect(function()
                if not speedBoostEnabled then Body.Visible = false end
            end)
        end
    end

    local function setupBoostConnections()
        if speedBoostConn then speedBoostConn:Disconnect() end
        if inputEndedConn then inputEndedConn:Disconnect() end
        speedBoostConn = UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == boostKey and speedBoostEnabled and not isBoosting then
                isBoosting = true
                local char = player.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    originalSpeed = hum.WalkSpeed
                    hum.WalkSpeed = boostSpeed
                end
            end
        end)
        inputEndedConn = UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == boostKey and isBoosting then
                isBoosting = false
                local char = player.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = originalSpeed end
            end
        end)
    end

    Switch.MouseButton1Click:Connect(function()
        speedBoostEnabled = not speedBoostEnabled
        Settings.SpeedBoost = speedBoostEnabled
        if speedBoostEnabled then
            TweenService:Create(Switch, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Theme.Lavender}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -17, 0.5, -7)}):Play()
            Label.TextColor3 = Theme.Text
            setupBoostConnections()
            setExpanded(true)
            if Ctx.Notify then Ctx.Notify("Speed Boost", Ctx.UIStrings[Ctx.Language].Enabled, 2, "success") end
        else
            TweenService:Create(Switch, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 3, 0.5, -7)}):Play()
            Label.TextColor3 = Theme.TextDark
            isBoosting = false
            if speedBoostConn then speedBoostConn:Disconnect(); speedBoostConn = nil end
            if inputEndedConn then inputEndedConn:Disconnect(); inputEndedConn = nil end
            setExpanded(false)
            if Ctx.Notify then Ctx.Notify("Speed Boost", Ctx.UIStrings[Ctx.Language].Disabled, 2, "info") end
        end
    end)
end

-- Water Walk
do
    local waterWalkConn = nil
    local waterPlatforms = {}
    CreateToggle(MovementTab, "Water Walk", function(state)
        Settings.WaterWalk = state
        if state then
            if waterWalkConn then waterWalkConn:Disconnect() end
            waterWalkConn = RunService.Heartbeat:Connect(function()
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hrp and hum then
                    local rayResult = workspace:Raycast(hrp.Position, Vector3.new(0, -10, 0))
                    if rayResult and rayResult.Material == Enum.Material.Water then
                        local platform = waterPlatforms[char]
                        if not platform then
                            platform = Instance.new("Part")
                            platform.Name = "WaterWalkPlatform"
                            platform.Size = Vector3.new(4, 0.2, 4)
                            platform.Material = Enum.Material.SmoothPlastic
                            platform.Transparency = 0.7
                            platform.Anchored = true
                            platform.CanCollide = true
                            platform.Color = Color3.fromRGB(100, 150, 255)
                            platform.Parent = workspace
                            waterPlatforms[char] = platform
                        end
                        platform.Position = Vector3.new(hrp.Position.X, rayResult.Position.Y - 0.1, hrp.Position.Z)
                    else
                        local platform = waterPlatforms[char]
                        if platform then
                            platform:Destroy()
                            waterPlatforms[char] = nil
                        end
                    end
                end
            end)
        else
            if waterWalkConn then waterWalkConn:Disconnect(); waterWalkConn = nil end
            for _, platform in pairs(waterPlatforms) do
                pcall(function() platform:Destroy() end)
            end
            waterPlatforms = {}
        end
    end)
end

-- World & Misc
do
    local zoomConn = nil
    CreateToggle(WorldTab, "Infinite Zoom", function(state)
        Settings.InfZoom = state
        if zoomConn then zoomConn:Disconnect(); zoomConn = nil end
        if state then
            player.CameraMaxZoomDistance = 100000
            zoomConn = RunService.Heartbeat:Connect(function()
                if player and Settings.InfZoom and player.CameraMaxZoomDistance < 99999 then
                    player.CameraMaxZoomDistance = 100000
                end
            end)
        else
            player.CameraMaxZoomDistance = 128
        end
    end)
    CreateToggle(WorldTab, "Night Vision", function(state)
        Settings.NightVision = state
        Lighting.Ambient = state and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5)
    end)
    local afkConnection = nil
    CreateToggle(MiscTab, "Anti-AFK", function(state)
        if state and not afkConnection then
            afkConnection = player.Idled:Connect(function()
                local vu = game:GetService("VirtualUser")
                vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        elseif not state and afkConnection then
            afkConnection:Disconnect(); afkConnection = nil
        end
    end)
    CreateButton(MiscTab, "Rejoin", function()
        pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player) end)
    end)
    CreateButton(MiscTab, "Server Hop", function()
        task.spawn(function()
            pcall(function()
                local data = HttpService:JSONDecode(game:HttpGet("https://games.roproxy.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"))
                if data and data.data then
                    for _, s in ipairs(data.data) do
                        if s.playing and s.playing < s.maxPlayers and s.id ~= game.JobId then
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, player)
                            return
                        end
                    end
                end
                TeleportService:Teleport(game.PlaceId, player)
            end)
        end)
    end)
    CreateButton(MiscTab, "Uncap FPS", function()
        if setfpscap then setfpscap(999) end
    end)
end

-- Follow Behind Player (телепортация и полёт сзади выбранного игрока)
do
    local followTarget = nil
    local followConnection = nil
    local followDistance = 5
    local followHeight = 3
    local followEnabled = false
    local savedNoclip = nil
    local savedPosition = nil  -- <-- ДОБАВЛЕНО: объявляем переменную на уровне блока

    CreatePlayerListDropdown(MovementTab, "Follow Target", function(name)
        followTarget = Players:FindFirstChild(name)
        if Ctx.Notify then
            Ctx.Notify("Follow", "Цель: " .. (name or "не выбрана"), 2, "info")
        end
    end)

    CreateToggle(MovementTab, "Follow Behind Player", function(state)
        followEnabled = state
        if state then
            local myChar = player.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            savedPosition = myHRP and myHRP.CFrame or nil  -- <-- УБРАЛИ local, теперь пишем во внешнюю переменную
            if followConnection then followConnection:Disconnect() end
            -- Сохраняем состояние noclip и включаем его, чтобы не застревать в стенах
            savedNoclip = Settings.Noclip
            Settings.Noclip = true

            followConnection = RunService.Heartbeat:Connect(function()
                local myChar = player.Character
                local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")

                -- Проверяем цель (игрок мог выйти)
                if not followTarget or not followTarget.Parent then
                    followTarget = nil
                    return
                end

                local targetChar = followTarget.Character
                local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

                if myHRP and targetHRP then
                    -- CFrame цели * смещение: вверх на followHeight, назад на followDistance
                    local offset = CFrame.new(0, followHeight, followDistance)
                    myHRP.CFrame = targetHRP.CFrame * offset
                    -- Обнуляем скорость, чтобы не было инерции/падения
                    myHRP.Velocity = Vector3.new(0, 0, 0)
                    myHRP.RotVelocity = Vector3.new(0, 0, 0)
                    -- Отключаем гравитацию на персонаже через PlatformStand
                    if myHum then myHum.PlatformStand = true end
                end
            end)

        else
            if followConnection then
                followConnection:Disconnect()
                followConnection = nil
            end
            -- Возвращаем персонажа на сохранённую позицию
            if savedPosition and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = savedPosition
                player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                player.Character.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
            end
            savedPosition = nil  -- очищаем, чтобы не держать ссылку
            
            -- Возвращаем noclip в исходное состояние
            if savedNoclip ~= nil then
                Settings.Noclip = savedNoclip
                savedNoclip = nil
            end
            local myChar = player.Character
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            if myHum then myHum.PlatformStand = false end

        end
    end)

    CreateSlider(MovementTab, "Follow Distance", 1, 20, 5, function(v)
        followDistance = v
    end)

    CreateSlider(MovementTab, "Follow Height", 0, 10, 3, function(v)
        followHeight = v
    end)
end
-- Единая функция обновления цветов при смене темы
Ctx.UpdateVisualTheme = function()
    local accent = Theme.Lavender
    
    -- 1. Трассеры
    if Settings.Tracers then
        for _, line in pairs(_G.TracersList) do
            if line and line.Color then line.Color = accent end
        end
    end
    
    -- 2. Чамсы
    if Settings.Chams then
        for _, skeleton in pairs(_G.Skeletons) do
            for _, obj in pairs(skeleton) do
                if obj and obj.Color then obj.Color = accent end
            end
        end
    end
    
    -- 3. ESP имена
    if Settings.ESP then
        for _, bg in ipairs(Ctx.Gui.ScreenGui:GetChildren()) do
            if bg:IsA("BillboardGui") then
                local tl = bg:FindFirstChildOfClass("TextLabel")
                if tl then tl.TextColor3 = Settings.ESPColor end
            end
        end
    end
    
    -- 4. Fly Panel
    if FlyFrame then
        local textLabel = FlyFrame:FindFirstChildOfClass("TextLabel")
        if textLabel then textLabel.TextColor3 = accent end
        local closebutton = FlyFrame:FindFirstChild("Close")
        if closebutton then closebutton.TextColor3 = accent end
        local mine = FlyFrame:FindFirstChild("mine")
        if mine then mine.TextColor3 = accent end
        local plus = FlyFrame:FindFirstChild("plus")
        if plus then plus.TextColor3 = accent end
        local onof = FlyFrame:FindFirstChild("onof")
        if onof and onof.Text == "ON" then
            onof.TextColor3 = accent
            local btnStroke = onof:FindFirstChildOfClass("UIStroke")
            if btnStroke then btnStroke.Color = accent end
        end
        local frameStroke = FlyFrame:FindFirstChildOfClass("UIStroke")
        if frameStroke then frameStroke.Color = accent end
    end
end
end
