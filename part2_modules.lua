return function(Ctx)
local UserInputService = Ctx.Services.UserInputService
local TweenService = Ctx.Services.TweenService
local Players = Ctx.Services.Players
local RunService = Ctx.Services.RunService
local Lighting = Ctx.Services.Lighting
local player = Ctx.Player
 local Theme = Ctx.Theme
 local FontMain = Ctx.FontMain
 local FontDesc = Ctx.FontDesc
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
 -- Notification System
 local NotifyContainer = nil
 local function initNotifyContainer()
     if NotifyContainer then return NotifyContainer end
     local sg = Instance.new("ScreenGui")
     sg.Name = "NotifyGui"
     sg.ResetOnSpawn = false
     sg.IgnoreGuiInset = true
     sg.DisplayOrder = 100
     sg.Parent = player:WaitForChild("PlayerGui")
     NotifyContainer = Instance.new("Frame", sg)
     NotifyContainer.Name = "Container"
     NotifyContainer.Size = UDim2.new(0, 280, 1, -20)
     NotifyContainer.BackgroundTransparency = 1
     NotifyContainer.AnchorPoint = Vector2.new(0, 1)
     NotifyContainer.Position = UDim2.new(1, -290, 1, -10)
     local list = Instance.new("UIListLayout", NotifyContainer)
     list.VerticalAlignment = Enum.VerticalAlignment.Bottom
     list.Padding = UDim.new(0, 6)
     list.SortOrder = Enum.SortOrder.LayoutOrder
     return NotifyContainer
 end
 Ctx.Notify = function(title, text, duration, ntype)
     duration = duration or 3
     ntype = ntype or "info"
     initNotifyContainer()
     local colors = {
         info = Theme.Lavender,
         success = Color3.fromRGB(100, 220, 140),
         error = Color3.fromRGB(230, 90, 90),
         warning = Color3.fromRGB(255, 200, 100)
     }
     local accentColor = colors[ntype] or Theme.Lavender
     local frame = Instance.new("Frame")
     frame.Size = UDim2.new(1, 0, 0, 0)
     frame.BackgroundColor3 = Theme.MainBg
     frame.BackgroundTransparency = 0.05
     frame.BorderSizePixel = 0
     frame.AutomaticSize = Enum.AutomaticSize.Y
     frame.Parent = NotifyContainer
     frame.ClipsDescendants = true
     Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
     local stroke = Instance.new("UIStroke", frame)
     stroke.Color = accentColor; stroke.Thickness = 1.5; stroke.Transparency = 0.3
     local accentBar = Instance.new("Frame", frame)
     accentBar.Size = UDim2.new(0, 4, 1, -10)
     accentBar.Position = UDim2.new(0, 5, 0, 5)
     accentBar.BackgroundColor3 = accentColor
     accentBar.BorderSizePixel = 0
     Instance.new("UICorner", accentBar).CornerRadius = UDim.new(0, 2)
     local titleLabel = Instance.new("TextLabel", frame)
     titleLabel.Size = UDim2.new(1, -25, 0, 18)
     titleLabel.Position = UDim2.new(0, 18, 0, 6)
     titleLabel.BackgroundTransparency = 1
     titleLabel.Text = title; titleLabel.TextColor3 = accentColor; titleLabel.Font = FontMain; titleLabel.TextSize = 13
     titleLabel.TextXAlignment = Enum.TextXAlignment.Left
     local textLabel = Instance.new("TextLabel", frame)
     textLabel.Size = UDim2.new(1, -25, 0, 0)
     textLabel.Position = UDim2.new(0, 18, 0, 24)
     textLabel.BackgroundTransparency = 1
     textLabel.Text = text; textLabel.TextColor3 = Theme.Text; textLabel.Font = FontDesc; textLabel.TextSize = 12
     textLabel.TextXAlignment = Enum.TextXAlignment.Left; textLabel.TextYAlignment = Enum.TextYAlignment.Top
     textLabel.TextWrapped = true; textLabel.AutomaticSize = Enum.AutomaticSize.Y
     Instance.new("UIPadding", frame).PaddingBottom = UDim.new(0, 8)
     TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
         Size = UDim2.new(1, 0, 0, 50 + (text:len() > 40 and 14 or 0))
     }):Play()
     task.delay(duration, function()
         local tween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
             BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0)
         })
         TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
         TweenService:Create(textLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
         TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
         TweenService:Create(accentBar, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
         tween:Play()
         tween.Completed:Connect(function() frame:Destroy() end)
     end)
 end
 -- Time & Gravity
 do
     local CustomTimeModule = { Param = 14, IsEnabled = false, OriginalTime = nil }
     local ct_conn
     function CustomTimeModule:Enable()
         if self.IsEnabled then return end
         self.IsEnabled = true
         self.OriginalTime = Lighting.ClockTime
         Lighting.ClockTime = self.Param or 14
         if ct_conn then ct_conn:Disconnect() end
         local self_ref = self
         ct_conn = Lighting.Changed:Connect(function(prop)
             local targetHour = self_ref.Param or 14
             if prop == "ClockTime" and Lighting.ClockTime ~= targetHour then
                 Lighting.ClockTime = targetHour
             end
         end)
     end
     function CustomTimeModule:Disable()
         if not self.IsEnabled then return end
         self.IsEnabled = false
         if ct_conn then ct_conn:Disconnect(); ct_conn = nil end
         if self.OriginalTime then Lighting.ClockTime = self.OriginalTime; self.OriginalTime = nil end
     end
     local NoGravityModule = {}
     local ng_conn
     function NoGravityModule:Enable()
         if ng_conn then return end
         ng_conn = RunService.Heartbeat:Connect(function() workspace.Gravity = 0 end)
     end
     function NoGravityModule:Disable()
         if ng_conn then ng_conn:Disconnect(); ng_conn = nil end
         workspace.Gravity = 196.2
     end
local CustomGravityModule = { Param = 50, IsEnabled = false }
local cg_conn = nil
function CustomGravityModule:Enable()
if cg_conn then return end
self.IsEnabled = true
workspace.Gravity = self.Param or 50
cg_conn = RunService.Heartbeat:Connect(function()
workspace.Gravity = self.Param or 50
end)
end
function CustomGravityModule:Disable()
self.IsEnabled = false
if cg_conn then cg_conn:Disconnect(); cg_conn = nil end
workspace.Gravity = 196.2
end
    local FastTimeCycleModule = { Speed = 1, IsEnabled = false }
     local ftc_conn = nil
     local ftc_originalTime = nil
     function FastTimeCycleModule:Enable()
         if self.IsEnabled then return end
         self.IsEnabled = true
         ftc_originalTime = Lighting.ClockTime
         if CustomTimeModule.IsEnabled then
             CustomTimeModule:Disable()
             Ctx.Notify("Time Cycle", "Custom Time (Lock) отключен, чтобы не мешать", 2, "warning")
         end
         ftc_conn = RunService.RenderStepped:Connect(function(dt)
             local currentTime = Lighting.ClockTime
             local speedMultiplier = ((currentTime >= 5 and currentTime <= 7) or (currentTime >= 17 and currentTime <= 19)) and 0.25 or 1.0
             local newTime = currentTime + (self.Speed * (10 / 60) * dt * speedMultiplier)
             if newTime >= 24 then newTime = newTime - 24 end
             Lighting.ClockTime = newTime
         end)
     end
     function FastTimeCycleModule:Disable()
         if not self.IsEnabled then return end
         self.IsEnabled = false
         if ftc_conn then ftc_conn:Disconnect(); ftc_conn = nil end
         if ftc_originalTime then Lighting.ClockTime = ftc_originalTime; ftc_originalTime = nil end
     end
     CreateToggle(WorldTab, "Custom Time (Lock)", function(state)
         if state then CustomTimeModule:Enable() else CustomTimeModule:Disable() end
     end)
     CreateSlider(WorldTab, "Time (Hours)", 0, 24, 14, function(v)
         CustomTimeModule.Param = v
         if CustomTimeModule.IsEnabled then Lighting.ClockTime = v end
     end)
     CreateToggle(WorldTab, "No Gravity", function(state)
         if state then NoGravityModule:Enable() else NoGravityModule:Disable() end
     end)
     CreateToggle(WorldTab, "Custom Gravity", function(state)
         if state then CustomGravityModule:Enable() else CustomGravityModule:Disable() end
     end)
     CreateSlider(WorldTab, "Gravity Value", 0, 500, 50, function(v)
         CustomGravityModule.Param = v
         if CustomGravityModule.IsEnabled then workspace.Gravity = v end
     end)
     CreateToggle(WorldTab, "Fast Day/Night Cycle", function(state)
         if state then FastTimeCycleModule:Enable() else FastTimeCycleModule:Disable() end
     end)
     CreateSlider(WorldTab, "Time Cycle Speed", 1, 100, 1, function(v)
         FastTimeCycleModule.Speed = v
     end)
 end
 -- Hitbox, Particles, FPS/Ping, XRay, Fullbright, NoFog
 do
     local HitboxExpanderModule = { Param = 10 }
     local originalSizes = {}
     function HitboxExpanderModule:Enable()
         local size = self.Param or 10
         for _, p in ipairs(Players:GetPlayers()) do
             if p ~= player and p.Character then
                 local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                 if hrp then
                     if not originalSizes[hrp] then originalSizes[hrp] = hrp.Size end
                     hrp.Size = Vector3.new(size, size, size)
                     hrp.Transparency = 0.7
                 end
             end
         end
     end
     function HitboxExpanderModule:Disable()
         for hrp, sz in pairs(originalSizes) do
             if hrp and hrp.Parent then hrp.Size = sz; hrp.Transparency = 1 end
         end
         originalSizes = {}
     end
     CreateToggle(CombatTab, "Hitbox Expander", function(state)
         if state then HitboxExpanderModule:Enable() else HitboxExpanderModule:Disable() end
     end)
     CreateSlider(CombatTab, "Hitbox Size", 1, 20, 10, function(v)
         HitboxExpanderModule.Param = v
     end)
     local RemoveParticlesModule = {}
     local rp_conn
     function RemoveParticlesModule:Enable()
         for _, obj in pairs(workspace:GetDescendants()) do
             if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then obj.Enabled = false end
         end
         rp_conn = workspace.DescendantAdded:Connect(function(d)
             if d:IsA("ParticleEmitter") or d:IsA("Trail") then d.Enabled = false end
         end)
     end
     function RemoveParticlesModule:Disable()
         if rp_conn then rp_conn:Disconnect(); rp_conn = nil end
         for _, obj in pairs(workspace:GetDescendants()) do
             if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then obj.Enabled = true end
         end
     end
     CreateToggle(VisualsTab, "Remove Particles & Trails", function(state)
         if state then RemoveParticlesModule:Enable() else RemoveParticlesModule:Disable() end
     end)
     local FpsPingModule = {}
     local fp_conn, fp_gui, fpsLabel, pingLabel
     local lastT, frames, fps_val = tick(), 0, 0
     function FpsPingModule:Enable()
         if fp_conn then return end
         local sg = Instance.new("ScreenGui")
         sg.Name = "StatsGui"; sg.ResetOnSpawn = false; sg.IgnoreGuiInset = true; sg.Parent = player:WaitForChild("PlayerGui")
         fp_gui = sg
         local container = Instance.new("Frame", sg)
         container.Size = UDim2.new(0, 160, 0, 60); container.Position = UDim2.new(0, 15, 0, 15)
         container.BackgroundColor3 = Theme.MainBg; container.BackgroundTransparency = 0.1; container.BorderSizePixel = 0; container.Active = true
         Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)
         local st = Instance.new("UIStroke", container); st.Color = Theme.Lavender; st.Thickness = 2; st.Transparency = 0.3
         fpsLabel = Instance.new("TextLabel", container)
         fpsLabel.Size = UDim2.new(1, -20, 0, 25); fpsLabel.Position = UDim2.new(0, 10, 0, 5)
         fpsLabel.BackgroundTransparency = 1; fpsLabel.TextColor3 = Theme.Lavender; fpsLabel.Font = FontMain; fpsLabel.TextSize = 16
         fpsLabel.TextXAlignment = Enum.TextXAlignment.Left; fpsLabel.Text = "FPS: --"
         local divider = Instance.new("Frame", container)
         divider.Size = UDim2.new(1, -20, 0, 1); divider.Position = UDim2.new(0, 10, 0, 30)
         divider.BackgroundColor3 = Theme.Lavender; divider.BackgroundTransparency = 0.5; divider.BorderSizePixel = 0
         pingLabel = Instance.new("TextLabel", container)
         pingLabel.Size = UDim2.new(1, -20, 0, 25); pingLabel.Position = UDim2.new(0, 10, 0, 32)
         pingLabel.BackgroundTransparency = 1; pingLabel.TextColor3 = Theme.Lavender; pingLabel.Font = FontMain; pingLabel.TextSize = 16
         pingLabel.TextXAlignment = Enum.TextXAlignment.Left; pingLabel.Text = "Ping: -- ms"
         local dragging, dragInput, dragStart, startPos
         container.InputBegan:Connect(function(input)
             if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                 dragging = true; dragStart = input.Position; startPos = container.Position
                 input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
             end
         end)
         container.InputChanged:Connect(function(input)
             if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
         end)
         UserInputService.InputChanged:Connect(function(input)
             if input == dragInput and dragging then
                 local delta = input.Position - dragStart
                 container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
             end
         end)
fp_conn = RunService.RenderStepped:Connect(function()
    frames = frames + 1
    if tick() - lastT >= 1 then fps_val = frames; frames = 0; lastT = tick() end
    fpsLabel.Text = "FPS: " .. fps_val
    fpsLabel.TextColor3 = Theme.Lavender  -- <-- ДОБАВЛЕНО
    local ok, ping = pcall(function() return math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) end)
    pingLabel.Text = "Ping: " .. (ok and ping or "?") .. " ms"
    pingLabel.TextColor3 = Theme.Lavender  -- <-- ДОБАВЛЕНО
    
    -- Обновляем цвет обводки контейнера
    if fp_gui then
        local container = fp_gui:FindFirstChildOfClass("Frame")
        if container then
            local st = container:FindFirstChildOfClass("UIStroke")
            if st then st.Color = Theme.Lavender end
        end
    end
end)
     end
     function FpsPingModule:Disable()
         if fp_conn then fp_conn:Disconnect(); fp_conn = nil end
         if fp_gui then fp_gui:Destroy(); fp_gui = nil end
     end
     CreateToggle(MiscTab, "Show FPS & Ping Overlay", function(state)
         if state then FpsPingModule:Enable() else FpsPingModule:Disable() end
     end)
     local XRayModule = {}
     local xr_conn
     function XRayModule:Enable()
         if xr_conn then return end
         local cam = workspace.CurrentCamera
         xr_conn = RunService.RenderStepped:Connect(function()
             if cam then cam.CameraType = Enum.CameraType.Follow; cam.FieldOfView = 70 end
         end)
     end
     function XRayModule:Disable()
         if xr_conn then xr_conn:Disconnect(); xr_conn = nil end
         local cam = workspace.CurrentCamera
         if cam then cam.CameraType = Enum.CameraType.Custom end
     end
     CreateToggle(VisualsTab, "XRay (Follow Camera)", function(state)
         if state then XRayModule:Enable() else XRayModule:Disable() end
     end)
     local fb_orig = nil
     CreateToggle(VisualsTab, "Fullbright", function(state)
         if state then
             if fb_orig then return end
             fb_orig = { Lighting.Ambient, Lighting.OutdoorAmbient, Lighting.Brightness, Lighting.GlobalShadows }
             Lighting.Ambient = Color3.new(1, 1, 1); Lighting.OutdoorAmbient = Color3.new(1, 1, 1); Lighting.Brightness = 2; Lighting.GlobalShadows = false
         elseif fb_orig then
             Lighting.Ambient, Lighting.OutdoorAmbient, Lighting.Brightness, Lighting.GlobalShadows = unpack(fb_orig)
             fb_orig = nil
         end
     end)
     local nf_orig = nil
     CreateToggle(VisualsTab, "Disable Fog", function(state)
         if state then
             if nf_orig then return end
             nf_orig = { Lighting.FogEnd, Lighting.FogStart, Lighting.FogColor }
             Lighting.FogEnd = 100000; Lighting.FogStart = 100000
         elseif nf_orig then
             Lighting.FogEnd, Lighting.FogStart, Lighting.FogColor = unpack(nf_orig)
             nf_orig = nil
         end
     end)
 end
-- Health Bars ESP (Исправленная), Rainbow, AutoJump, WallHop, TP Player, TP Mouse, Aimbot FOV
do
local HealthBarsESPModule = {}
local hbe_conn, hbe_espBars = nil, {}

local function hbe_getHealthColor(hp)
    if hp <= 0.1 then
        return Color3.fromRGB(230, 90, 90)
    elseif hp <= 0.5 then
        return Color3.fromRGB(255, 210, 100)
    else
        return Color3.fromRGB(100, 220, 100)
    end
end

local function hbe_createBar(p)
    if p == player then return end
    local function cleanup()
        if hbe_espBars[p] then
            if hbe_espBars[p].gui then hbe_espBars[p].gui:Destroy() end
            hbe_espBars[p] = nil
        end
    end
    
    local function setupBar()
        cleanup()
        if not p.Character then return end
        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        local bg = Instance.new("BillboardGui")
        bg.Name = "HealthBarESP"
        bg.Size = UDim2.new(6, 0, 1.5, 0)
        bg.StudsOffset = Vector3.new(0, 3.5, 0)
        bg.AlwaysOnTop = true
        bg.Adornee = hrp
        bg.Parent = hrp
        bg.LightInfluence = 0

        local bgFrame = Instance.new("Frame", bg)
        bgFrame.Name = "BarContainer"
        bgFrame.Size = UDim2.new(1, 0, 0.525, 0)
        bgFrame.Position = UDim2.new(0, 0, 0.45, 0)
        bgFrame.AnchorPoint = Vector2.new(0, 0.5)
        bgFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        bgFrame.BackgroundTransparency = 0.2
        bgFrame.BorderSizePixel = 0
        Instance.new("UICorner", bgFrame).CornerRadius = UDim.new(0, 12)

        local stroke = Instance.new("UIStroke", bgFrame)
        stroke.Color = Theme.Lavender
        stroke.Thickness = 1.5
        stroke.Transparency = 0.4

        local fill = Instance.new("Frame", bgFrame)
        fill.Name = "Fill"
        fill.Size = UDim2.new(1, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(100, 220, 100)
        fill.BorderSizePixel = 0
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 12)

        local hpText = Instance.new("TextLabel", bgFrame)
        hpText.Name = "HpText"
        hpText.Size = UDim2.new(1, 0, 1, 0)
        hpText.BackgroundTransparency = 1
        hpText.TextColor3 = Color3.fromRGB(255, 255, 255)
        hpText.Font = FontMain
        hpText.TextScaled = true
        hpText.TextStrokeTransparency = 0.3
        hpText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        hpText.Text = "100%"

        hbe_espBars[p] = {gui = bg, fill = fill, hpText = hpText}
    end
    
    setupBar()
    p.CharacterAdded:Connect(setupBar)
end

function HealthBarsESPModule:Enable()
    if hbe_conn then return end
    for _, p in ipairs(Players:GetPlayers()) do hbe_createBar(p) end
    
    local addConn = Players.PlayerAdded:Connect(hbe_createBar)
    local removeConn = Players.PlayerRemoving:Connect(function(p)
        if hbe_espBars[p] then
            if hbe_espBars[p].gui then hbe_espBars[p].gui:Destroy() end
            hbe_espBars[p] = nil
        end
    end)
    
local updConn = RunService.RenderStepped:Connect(function()
    for p, data in pairs(hbe_espBars) do
        if p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and data.fill and data.hpText then
                local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                data.fill.Size = UDim2.new(hp, 0, 1, 0)
                data.fill.BackgroundColor3 = hbe_getHealthColor(hp)
                data.hpText.Text = math.floor(hp * 100) .. "%"
                
                -- Обновляем цвет обводки
                local bg = data.gui
                if bg then
                    local container = bg:FindFirstChild("BarContainer")
                    if container then
                        local stroke = container:FindFirstChildOfClass("UIStroke")
                        if stroke then stroke.Color = Theme.Lavender end
                    end
                end
            end
        end
    end
end)
    hbe_conn = {addConn, removeConn, updConn}
end

function HealthBarsESPModule:Disable()
    if hbe_conn then
        for _, c in ipairs(hbe_conn) do c:Disconnect() end
        hbe_conn = nil
    end
    for _, data in pairs(hbe_espBars) do
        if data.gui then data.gui:Destroy() end
    end
    hbe_espBars = {}
end

CreateToggle(VisualsTab, "Health Bars ESP", function(state)
    if state then HealthBarsESPModule:Enable() else HealthBarsESPModule:Disable() end
end)

local rc_conn, rc_hue = nil, 0
local rc_originalColors = {}
local rc_charAddedConn = nil

local function rc_saveColors()
    local char = player.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and not rc_originalColors[part] then
            rc_originalColors[part] = part.Color
        end
    end
end

local function rc_restoreColors()
    for part, color in pairs(rc_originalColors) do
        if part and part.Parent then
            part.Color = color
        end
    end
    rc_originalColors = {}
end

  -- Invisible Character (Visible only to you)
do
local ic_conn, ic_charAddedConn = nil, nil
local ic_originalTransparency = {}

local function ic_saveTransparency()
    local char = player.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and not ic_originalTransparency[part] then
            ic_originalTransparency[part] = part.Transparency
        end
    end
end

local function ic_restoreTransparency()
    for part, transparency in pairs(ic_originalTransparency) do
        if part and part.Parent then
            part.Transparency = transparency
        end
    end
    ic_originalTransparency = {}
end

local function ic_makeInvisible()
    local char = player.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = 1
        end
    end
end

CreateToggle(PlayerTab, "Invisible Character (Visible only to you)", function(state)
    if state then
        if ic_conn then return end
        ic_originalTransparency = {}
        ic_saveTransparency()
        ic_makeInvisible()
        
        -- Делаем новые части невидимыми при респауне
        ic_charAddedConn = player.CharacterAdded:Connect(function()
            task.wait(0.5) -- Ждём загрузки частей
            ic_saveTransparency()
            ic_makeInvisible()
        end)
        
        -- Следим за появлением новых частей (например, при загрузке аксессуаров)
        ic_conn = player.Character.DescendantAdded:Connect(function(descendant)
            if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" then
                if not ic_originalTransparency[descendant] then
                    ic_originalTransparency[descendant] = descendant.Transparency
                end
                descendant.Transparency = 1
            end
        end)
    else
        if ic_conn then
            ic_conn:Disconnect()
            ic_conn = nil
        end
        if ic_charAddedConn then
            ic_charAddedConn:Disconnect()
            ic_charAddedConn = nil
        end
        ic_restoreTransparency()
    end
end)
end
  
CreateToggle(PlayerTab, "Rainbow Character (Visible only to you)", function(state)
    if state then
        if rc_conn then return end
        rc_originalColors = {}
        rc_saveColors()
        
        -- Сохраняем цвета новых частей при респауне
        rc_charAddedConn = player.CharacterAdded:Connect(function()
            task.wait(0.5) -- Ждём загрузки частей
            rc_saveColors()
        end)
        
        rc_conn = RunService.RenderStepped:Connect(function(dt)
            rc_hue = (rc_hue + dt * 0.2) % 1
            local char = player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Color = Color3.fromHSV(rc_hue, 1, 1)
                    end
                end
            end
        end)
    elseif rc_conn then
        rc_conn:Disconnect()
        rc_conn = nil
        if rc_charAddedConn then
            rc_charAddedConn:Disconnect()
            rc_charAddedConn = nil
        end
        rc_restoreColors()
    end
end)

local aj_conn
CreateToggle(MovementTab, "Auto Jump", function(state)
    if state then
        if aj_conn then return end
        aj_conn = RunService.Heartbeat:Connect(function()
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.FloorMaterial ~= Enum.Material.Air then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    elseif aj_conn then aj_conn:Disconnect(); aj_conn = nil end
end)

local wh_conn
CreateToggle(MovementTab, "Wall Hop", function(state)
    if state then
        if wh_conn then return end
        wh_conn = RunService.Heartbeat:Connect(function()
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hum and hrp then
                local params = RaycastParams.new(); params.FilterDescendantsInstances = {char}
                local res = workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * 2, params)
                if hum.FloorMaterial == Enum.Material.Air and res then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
    elseif wh_conn then wh_conn:Disconnect(); wh_conn = nil end
end)

CreatePlayerListDropdown(MovementTab, "Teleport to Player", function(selectedName)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local target = Players:FindFirstChild(selectedName)
    local tHrp = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if hrp and tHrp then hrp.CFrame = tHrp.CFrame * CFrame.new(0, 0, -5) end
end)

local ttm_conn
CreateToggle(MovementTab, "Teleport to Mouse (LMB)", function(state)
    if state then
        if ttm_conn then return end
        ttm_conn = UserInputService.InputBegan:Connect(function(input, gp)
            if not gp and input.UserInputType == Enum.UserInputType.MouseButton1 then
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                local mouse = player:GetMouse()
                if hrp and mouse and mouse.Hit then hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0)) end
            end
        end)
    elseif ttm_conn then ttm_conn:Disconnect(); ttm_conn = nil end
end)

local af_conn, af_circle, af_radius = nil, nil, 150
CreateToggle(CombatTab, "Show Aimbot FOV Circle", function(state)
    if state then
        if af_conn or not Drawing then return end
        af_circle = Drawing.new("Circle")
        af_circle.Thickness = 1; af_circle.NumSides = 60; af_circle.Radius = af_radius; af_circle.Filled = false; af_circle.Color = Theme.Lavender; af_circle.Visible = true; af_circle.Transparency = 0.8
af_conn = RunService.RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera
    if cam and af_circle then
        af_circle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        af_circle.Color = Theme.Lavender  -- <-- ДОБАВЛЕНО
    end
end)
    else
        if af_conn then af_conn:Disconnect(); af_conn = nil end
        if af_circle then af_circle:Remove(); af_circle = nil end
    end
end)

CreateSlider(CombatTab, "FOV Circle Radius", 50, 400, 150, function(v)
    af_radius = v
    if af_circle then af_circle.Radius = v end
end)
end
 
-- Crosshair, Distance ESP, Copy
do
local ch_cfg = { Gap = 6, Length = 10, Thickness = 2, Color = Theme.Lavender, Style = "Cross", ColorMode = "Theme" }
local ch_lines, ch_dot, ch_conn = {}, nil, nil

local function ch_clear()
    for _, line in pairs(ch_lines) do pcall(function() line:Remove() end) end
    ch_lines = {}
    if ch_dot then pcall(function() ch_dot:Remove() end); ch_dot = nil end
end

local function ch_create()
ch_clear()
-- Определяем цвет: Theme.Lavender если режим "Theme", иначе ch_cfg.Color
local finalColor = ch_cfg.ColorMode == "Theme" and Theme.Lavender or ch_cfg.Color
if ch_cfg.Style == "Dot" then
ch_dot = Drawing.new("Circle")
ch_dot.Radius = ch_cfg.Thickness
ch_dot.Thickness = 0
ch_dot.Filled = true
ch_dot.Color = finalColor
ch_dot.Transparency = 1
ch_dot.Visible = true
else
local lineCount = ch_cfg.Style == "3Lines" and 3 or 4
for i = 1, lineCount do
local line = Drawing.new("Line")
line.Thickness = ch_cfg.Thickness
line.Color = finalColor
line.Visible = true
line.Transparency = 1
ch_lines[i] = line
end
end
end

local function ch_update()
local cam = workspace.CurrentCamera
if not cam then return end
local cx, cy = cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2
local g, l = ch_cfg.Gap, ch_cfg.Length
-- Определяем цвет
local finalColor = ch_cfg.ColorMode == "Theme" and Theme.Lavender or ch_cfg.Color
if ch_cfg.Style == "Dot" then
     if ch_dot then
         ch_dot.Position = Vector2.new(cx, cy)
         ch_dot.Radius = ch_cfg.Thickness
         ch_dot.Color = finalColor
     end
 elseif ch_cfg.Style == "3Lines" then
     if ch_lines[1] then ch_lines[1].From = Vector2.new(cx, cy + g); ch_lines[1].To = Vector2.new(cx, cy + g + l); ch_lines[1].Color = finalColor end
     if ch_lines[2] then ch_lines[2].From = Vector2.new(cx - g, cy); ch_lines[2].To = Vector2.new(cx - g - l, cy); ch_lines[2].Color = finalColor end
     if ch_lines[3] then ch_lines[3].From = Vector2.new(cx + g, cy); ch_lines[3].To = Vector2.new(cx + g + l, cy); ch_lines[3].Color = finalColor end
 else
     if ch_lines[1] then ch_lines[1].From = Vector2.new(cx, cy - g); ch_lines[1].To = Vector2.new(cx, cy - g - l); ch_lines[1].Color = finalColor end
     if ch_lines[2] then ch_lines[2].From = Vector2.new(cx, cy + g); ch_lines[2].To = Vector2.new(cx, cy + g + l); ch_lines[2].Color = finalColor end
     if ch_lines[3] then ch_lines[3].From = Vector2.new(cx - g, cy); ch_lines[3].To = Vector2.new(cx - g - l, cy); ch_lines[3].Color = finalColor end
     if ch_lines[4] then ch_lines[4].From = Vector2.new(cx + g, cy); ch_lines[4].To = Vector2.new(cx + g + l, cy); ch_lines[4].Color = finalColor end
 end
end

local CrosshairStyleDropdown
CreateToggle(VisualsTab, "Crosshair", function(state)
    if state then
        if ch_conn then return end
        if not Drawing then Ctx.Notify("Crosshair", "Drawing API недоступен", 3, "error"); return end
        ch_create()
        ch_conn = RunService.RenderStepped:Connect(ch_update)
        if CrosshairStyleDropdown then CrosshairStyleDropdown.Visible = true end
        if CrosshairColorModeDropdown then CrosshairColorModeDropdown.Visible = true end
    else
        if ch_conn then ch_conn:Disconnect(); ch_conn = nil end
        ch_clear()
        if CrosshairStyleDropdown then CrosshairStyleDropdown.Visible = false end
        if CrosshairColorModeDropdown then CrosshairColorModeDropdown.Visible = false end
    end
end)

-- Сначала создаём оба dropdown'а
local CrosshairStyleDropdown = CreateDropdown(VisualsTab, "Crosshair Style", {"Cross", "3Lines", "Dot"}, "Cross", function(style)
    ch_cfg.Style = style
    if ch_conn then ch_create() end
end)
CrosshairStyleDropdown.Visible = false

local CrosshairColorModeDropdown = CreateDropdown(VisualsTab, "Crosshair Color", {"Theme", "Black", "White", "Red", "Green", "Yellow", "Pink", "Blue"}, "Theme", function(mode)
    ch_cfg.ColorMode = mode
    local colorMap = {
        ["Theme"] = Theme.Lavender,
        ["Black"] = Color3.fromRGB(0, 0, 0),
        ["White"] = Color3.fromRGB(255, 255, 255),
        ["Red"] = Color3.fromRGB(255, 20, 20),
        ["Green"] = Color3.fromRGB(80, 255, 120),
        ["Yellow"] = Color3.fromRGB(255, 220, 50),
        ["Pink"] = Color3.fromRGB(255, 120, 180),
        ["Blue"] = Color3.fromRGB(20, 20, 255)
    }
    ch_cfg.Color = colorMap[mode] or Theme.Lavender
    if ch_conn then ch_create() end
end)
CrosshairColorModeDropdown.Visible = false

-- Теперь CreateToggle, который использует уже созданные dropdown'ы
CreateToggle(VisualsTab, "Crosshair", function(state)
    if state then
        if ch_conn then return end
        if not Drawing then Ctx.Notify("Crosshair", "Drawing API недоступен", 3, "error"); return end
        ch_create()
        ch_conn = RunService.RenderStepped:Connect(ch_update)
        if CrosshairStyleDropdown then CrosshairStyleDropdown.Visible = true end
        if CrosshairColorModeDropdown then CrosshairColorModeDropdown.Visible = true end
    else
        if ch_conn then ch_conn:Disconnect(); ch_conn = nil end
        ch_clear()
        if CrosshairStyleDropdown then CrosshairStyleDropdown.Visible = false end
        if CrosshairColorModeDropdown then CrosshairColorModeDropdown.Visible = false end
    end
end)

CreateSlider(VisualsTab, "Crosshair Gap", 2, 20, 6, function(v) ch_cfg.Gap = v end)
CreateSlider(VisualsTab, "Crosshair Length", 4, 30, 10, function(v) ch_cfg.Length = v end)
CreateSlider(VisualsTab, "Crosshair Thickness", 1, 10, 2, function(v)
    ch_cfg.Thickness = v
    for i = 1, #ch_lines do if ch_lines[i] then ch_lines[i].Thickness = v end end
    if ch_dot then ch_dot.Radius = v end
end)
    
     local de_conn, de_bars = nil, {}
     local function de_createBar(p)
         if p == player then return end
         local function setupBar()
             if not p.Character then return end
             local hrp = p.Character:FindFirstChild("HumanoidRootPart")
             if not hrp then return end
             if de_bars[p] then de_bars[p]:Destroy() end
             local bg = Instance.new("BillboardGui")
             bg.Name = "DistanceESP"; bg.Size = UDim2.new(0, 80, 0, 20); bg.StudsOffset = Vector3.new(0, -2.5, 0); bg.AlwaysOnTop = true; bg.Adornee = hrp; bg.Parent = hrp
             local label = Instance.new("TextLabel", bg)
             label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.Font = FontMain; label.TextSize = 14; label.TextStrokeTransparency = 0.5; label.Text = "0m"
             de_bars[p] = bg
         end
         setupBar()
         p.CharacterAdded:Connect(setupBar)
     end
     CreateToggle(CombatTab, "Distance ESP", function(state)
         if state then
             if de_conn then return end
             for _, p in ipairs(Players:GetPlayers()) do de_createBar(p) end
             local addConn = Players.PlayerAdded:Connect(de_createBar)
             local remConn = Players.PlayerRemoving:Connect(function(p) if de_bars[p] then de_bars[p]:Destroy(); de_bars[p] = nil end end)
             local updConn = RunService.RenderStepped:Connect(function()
                 local cam = workspace.CurrentCamera
                 if not cam then return end
                 for p, bg in pairs(de_bars) do
                     local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                     local label = hrp and bg:FindFirstChildOfClass("TextLabel")
                     if label then
                         local d = (hrp.Position - cam.CFrame.Position).Magnitude
                         label.Text = math.floor(d) .. "m"
                         label.TextColor3 = d < 30 and Color3.fromRGB(255, 90, 90) or (d < 80 and Color3.fromRGB(255, 210, 120) or Theme.Lavender)
                     end
                 end
             end)
             de_conn = {addConn, remConn, updConn}
         else
             if de_conn then for _, c in ipairs(de_conn) do c:Disconnect() end; de_conn = nil end
             for _, bg in pairs(de_bars) do pcall(function() bg:Destroy() end) end
             de_bars = {}
         end
     end)
     local function copyToClipboard(text, label)
         local ok = pcall(function()
             if setclipboard then setclipboard(text)
             elseif toclipboard then toclipboard(text)
             elseif copy then copy(text)
             else error("Clipboard API not available") end
         end)
         if ok then Ctx.Notify("Copied!", label .. " скопирован в буфер обмена", 2, "success")
         else Ctx.Notify("Error", "Буфер обмена недоступен в этом эксплоите", 3, "error") end
     end
     CreateButton(MiscTab, "Copy My Username", function() copyToClipboard(player.Name, "Username") end)
     CreateButton(MiscTab, "Copy My UserId", function() copyToClipboard(tostring(player.UserId), "UserId") end)
     CreateButton(MiscTab, "Copy Server ID", function() copyToClipboard(game.JobId, "Server ID") end)
     CreateButton(MiscTab, "Copy My Coordinates", function()
         local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
         if not hrp then Ctx.Notify("Error", "Персонаж не найден", 2, "error"); return end
         local pos = hrp.Position
         copyToClipboard(string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z), "Coordinates")
     end)
 end
end
