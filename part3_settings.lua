return function(Ctx)
    local UserInputService = Ctx.Services.UserInputService
    local Theme = Ctx.Theme
    local FontMain = Ctx.FontMain
    local MainFrame = Ctx.Gui.MainFrame
    local MainCorner = Ctx.Gui.MainCorner
    local Sidebar = Ctx.Gui.Sidebar
    local Container = Ctx.Gui.Container
    local OpenBtn = Ctx.Gui.OpenBtn
    local SettingsPage = Ctx.Pages.Settings

    local CreateButton = Ctx.UI.CreateButton
    local CreateToggle = Ctx.UI.CreateToggle
    local CreateSlider = Ctx.UI.CreateSlider
    local CreateDropdown = Ctx.UI.CreateDropdown

    -- Resize Handle
    do
        local ResizeHandle = Instance.new("TextButton")
        ResizeHandle.Size = UDim2.new(0, 24, 0, 24)
        ResizeHandle.BackgroundTransparency = 1
        ResizeHandle.Text = ""
        ResizeHandle.BorderSizePixel = 0
        ResizeHandle.ZIndex = 100
        ResizeHandle.Position = UDim2.new(1, -26, 1, -26)
        ResizeHandle.Parent = MainFrame

        local InnerCornerV = Instance.new("Frame", ResizeHandle)
        InnerCornerV.Size = UDim2.new(0, 2, 0, 8)
        InnerCornerV.Position = UDim2.new(1, -10, 0.5, -4)
        InnerCornerV.BackgroundColor3 = Theme.Lavender
        InnerCornerV.BorderSizePixel = 0
        Instance.new("UICorner", InnerCornerV).CornerRadius = UDim.new(0, 1)

        local InnerCornerH = Instance.new("Frame", ResizeHandle)
        InnerCornerH.Size = UDim2.new(0, 8, 0, 2)
        InnerCornerH.Position = UDim2.new(0.5, -4, 1, -10)
        InnerCornerH.BackgroundColor3 = Theme.Lavender
        InnerCornerH.BorderSizePixel = 0
        Instance.new("UICorner", InnerCornerH).CornerRadius = UDim.new(0, 1)

        local isResizing, startMousePos, startFrameSize = false, nil, nil
        local MIN_SIZE, MAX_SIZE = Vector2.new(400, 280), Vector2.new(800, 520)

        local function setCornerColor(color)
            InnerCornerV.BackgroundColor3 = color
            InnerCornerH.BackgroundColor3 = color
        end

        ResizeHandle.MouseButton1Down:Connect(function()
            isResizing = true
            startMousePos = UserInputService:GetMouseLocation()
            startFrameSize = Vector2.new(MainFrame.Size.X.Offset, MainFrame.Size.Y.Offset)
            setCornerColor(Theme.LavenderGlow)
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and isResizing then
                isResizing = false; setCornerColor(Theme.Lavender)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if isResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = UserInputService:GetMouseLocation() - startMousePos
                MainFrame.Size = UDim2.new(0, math.clamp(startFrameSize.X + delta.X, MIN_SIZE.X, MAX_SIZE.X), 0, math.clamp(startFrameSize.Y + delta.Y, MIN_SIZE.Y, MAX_SIZE.Y))
            end
        end)
        ResizeHandle.MouseEnter:Connect(function() if not isResizing then setCornerColor(Theme.LavenderGlow) end end)
        ResizeHandle.MouseLeave:Connect(function() if not isResizing then setCornerColor(Theme.Lavender) end end)
    end

    -- Transparency & Corner Radius
    do
        local OriginalTransparency = {}
        local function SaveOriginalTransparency()
            OriginalTransparency = {
                Sidebar = Sidebar.BackgroundTransparency,
                Container = Container.BackgroundTransparency,
            }
            for _, desc in ipairs(MainFrame:GetDescendants()) do
                if (desc:IsA("Frame") or desc:IsA("TextButton") or desc:IsA("TextLabel")) and desc.BackgroundTransparency < 1 then
                    OriginalTransparency[desc] = desc.BackgroundTransparency
                end
            end
        end
        local function ApplyTransparency(value)
            local t = value / 100
            MainFrame.BackgroundTransparency = t
            if OriginalTransparency.Sidebar then Sidebar.BackgroundTransparency = OriginalTransparency.Sidebar + (t * 0.3) end
            if OriginalTransparency.Container then Container.BackgroundTransparency = OriginalTransparency.Container + (t * 0.2) end
            for _, desc in ipairs(MainFrame:GetDescendants()) do
                if (desc:IsA("Frame") or desc:IsA("TextButton") or desc:IsA("TextLabel")) and OriginalTransparency[desc] ~= nil then
                    desc.BackgroundTransparency = math.min(OriginalTransparency[desc] + (t * 0.1), 0.9)
                end
            end
        end
        SaveOriginalTransparency()
        CreateSlider(SettingsPage, "Menu Transparency", 0, 90, 0, ApplyTransparency)

        CreateSlider(SettingsPage, "Corner Radius", 0, 20, 12, function(v)
            MainCorner.CornerRadius = UDim.new(0, v)
            for _, corner in ipairs(MainFrame:GetDescendants()) do
                if corner:IsA("UICorner") then corner.CornerRadius = UDim.new(0, v) end
            end
        end)
    end

    -- Themes
    do
        local Themes = {
            ["Lavender"] = { accent = Color3.fromRGB(155, 130, 240), sidebar = Color3.fromRGB(32, 32, 38), element = Color3.fromRGB(38, 38, 45), mainBg = Color3.fromRGB(24, 24, 28) },
            ["Mint Brew"] = { accent = Color3.fromRGB(185, 229, 200), sidebar = Color3.fromRGB(55, 38, 28), element = Color3.fromRGB(68, 48, 36), mainBg = Color3.fromRGB(43, 26, 18) },
            ["Golden Ink"] = { accent = Color3.fromRGB(242, 208, 107), sidebar = Color3.fromRGB(42, 51, 64), element = Color3.fromRGB(52, 63, 78), mainBg = Color3.fromRGB(30, 37, 48) },
            ["Olive Gum"] = { accent = Color3.fromRGB(255, 169, 214), sidebar = Color3.fromRGB(52, 58, 25), element = Color3.fromRGB(66, 74, 32), mainBg = Color3.fromRGB(38, 42, 18) },
            ["Mocha Mist"] = { accent = Color3.fromRGB(199, 218, 232), sidebar = Color3.fromRGB(88, 62, 52), element = Color3.fromRGB(108, 76, 64), mainBg = Color3.fromRGB(68, 48, 40) },
            ["Violet Peach"] = { accent = Color3.fromRGB(255, 196, 155), sidebar = Color3.fromRGB(103, 75, 182), element = Color3.fromRGB(117, 89, 196), mainBg = Color3.fromRGB(91, 63, 168) }
        }
        local function IsColorSimilar(c1, c2, tol)
            tol = tol or 15
            return math.abs(c1.R - c2.R) < tol / 255 and math.abs(c1.G - c2.G) < tol / 255 and math.abs(c1.B - c2.B) < tol / 255
        end
        local OldColors = { accent = Color3.fromRGB(155, 130, 240), sidebar = Color3.fromRGB(32, 32, 38), element = Color3.fromRGB(38, 38, 45), mainBg = Color3.fromRGB(24, 24, 28) }

        CreateDropdown(SettingsPage, "Color Theme", {"Lavender", "Mint Brew", "Golden Ink", "Olive Gum", "Mocha Mist", "Violet Peach"}, "Lavender", function(themeName)
            local theme = Themes[themeName]
            if not theme then return end
            Theme.Lavender, Theme.SidebarBg, Theme.ElementBg, Theme.MainBg = theme.accent, theme.sidebar, theme.element, theme.mainBg
            for _, desc in ipairs(MainFrame:GetDescendants()) do
                if desc:IsA("TextLabel") or desc:IsA("TextButton") then
                    if IsColorSimilar(desc.TextColor3, OldColors.accent) then desc.TextColor3 = theme.accent end
                    if IsColorSimilar(desc.TextColor3, OldColors.sidebar) then desc.TextColor3 = theme.sidebar end
                end
                if desc:IsA("Frame") or desc:IsA("TextButton") then
                    if IsColorSimilar(desc.BackgroundColor3, OldColors.accent) then desc.BackgroundColor3 = theme.accent
                    elseif IsColorSimilar(desc.BackgroundColor3, OldColors.sidebar) then desc.BackgroundColor3 = theme.sidebar
                    elseif IsColorSimilar(desc.BackgroundColor3, OldColors.element) then desc.BackgroundColor3 = theme.element
                    elseif IsColorSimilar(desc.BackgroundColor3, OldColors.mainBg) then desc.BackgroundColor3 = theme.mainBg end
                end
                if desc:IsA("UIStroke") and IsColorSimilar(desc.Color, OldColors.accent) then
                    desc.Color = theme.accent
                end
            end
            MainFrame.BackgroundColor3 = theme.mainBg
            Sidebar.BackgroundColor3 = theme.sidebar
            OldColors = { accent = theme.accent, sidebar = theme.sidebar, element = theme.element, mainBg = theme.mainBg }
            if Ctx.Notify then Ctx.Notify("Theme", "Тема: " .. themeName, 2, "success") end
        end)
    end

    -- Keybinds, Panic, NotifyDuration, Reset, Auto-hide
    do
        local MenuToggleKey = Enum.KeyCode.RightShift
        local PanicKey = Enum.KeyCode.End
        local PanicEnabled = false
        local NotifyDuration = 3
        local AutoHideEnabled = false
        local AutoHideTime = 30
        local LastMenuInteraction = tick()

        local MenuKeybindFrame = Instance.new("Frame")
        MenuKeybindFrame.Size = UDim2.new(1, -6, 0, 40); MenuKeybindFrame.BackgroundColor3 = Theme.ElementBg; MenuKeybindFrame.Parent = SettingsPage
        Instance.new("UICorner", MenuKeybindFrame).CornerRadius = UDim.new(0, 6)
        local MenuKeybindLabel = Instance.new("TextLabel", MenuKeybindFrame)
        MenuKeybindLabel.Size = UDim2.new(0.6, -10, 1, 0); MenuKeybindLabel.Position = UDim2.new(0, 12, 0, 0); MenuKeybindLabel.BackgroundTransparency = 1; MenuKeybindLabel.Text = "Menu Toggle Key"; MenuKeybindLabel.TextColor3 = Theme.TextDark; MenuKeybindLabel.Font = FontMain; MenuKeybindLabel.TextSize = 13; MenuKeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
        local MenuKeybindBtn = Instance.new("TextButton", MenuKeybindFrame)
        MenuKeybindBtn.Size = UDim2.new(0.35, -10, 0, 26); MenuKeybindBtn.Position = UDim2.new(0.65, 0, 0.5, -13); MenuKeybindBtn.BackgroundColor3 = Theme.MainBg; MenuKeybindBtn.Text = "RightShift"; MenuKeybindBtn.TextColor3 = Theme.Text; MenuKeybindBtn.Font = FontMain; MenuKeybindBtn.TextSize = 11
        Instance.new("UICorner", MenuKeybindBtn).CornerRadius = UDim.new(0, 4)

        MenuKeybindBtn.MouseButton1Click:Connect(function()
            MenuKeybindBtn.Text = "Press a key..."
            local conn
            conn = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    MenuToggleKey = input.KeyCode
                    MenuKeybindBtn.Text = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                    conn:Disconnect()
                    if Ctx.Notify then Ctx.Notify("Keybind", "Клавиша меню: " .. MenuKeybindBtn.Text, 2, "success") end
                end
            end)
        end)

        CreateToggle(SettingsPage, "Enable Panic Key", function(state) PanicEnabled = state end)

        local PanicKeybindFrame = Instance.new("Frame")
        PanicKeybindFrame.Size = UDim2.new(1, -6, 0, 40); PanicKeybindFrame.BackgroundColor3 = Theme.ElementBg; PanicKeybindFrame.Parent = SettingsPage
        Instance.new("UICorner", PanicKeybindFrame).CornerRadius = UDim.new(0, 6)
        local PanicKeybindLabel = Instance.new("TextLabel", PanicKeybindFrame)
        PanicKeybindLabel.Size = UDim2.new(0.6, -10, 1, 0); PanicKeybindLabel.Position = UDim2.new(0, 12, 0, 0); PanicKeybindLabel.BackgroundTransparency = 1; PanicKeybindLabel.Text = "Panic Key"; PanicKeybindLabel.TextColor3 = Theme.TextDark; PanicKeybindLabel.Font = FontMain; PanicKeybindLabel.TextSize = 13; PanicKeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
        local PanicKeybindBtn = Instance.new("TextButton", PanicKeybindFrame)
        PanicKeybindBtn.Size = UDim2.new(0.35, -10, 0, 26); PanicKeybindBtn.Position = UDim2.new(0.65, 0, 0.5, -13); PanicKeybindBtn.BackgroundColor3 = Theme.MainBg; PanicKeybindBtn.Text = "End"; PanicKeybindBtn.TextColor3 = Theme.Text; PanicKeybindBtn.Font = FontMain; PanicKeybindBtn.TextSize = 11
        Instance.new("UICorner", PanicKeybindBtn).CornerRadius = UDim.new(0, 4)

        PanicKeybindBtn.MouseButton1Click:Connect(function()
            PanicKeybindBtn.Text = "Press a key..."
            local conn
            conn = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    PanicKey = input.KeyCode
                    PanicKeybindBtn.Text = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                    conn:Disconnect()
                    if Ctx.Notify then Ctx.Notify("Panic Key", "Panic клавиша: " .. PanicKeybindBtn.Text, 2, "success") end
                end
            end)
        end)

        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == MenuToggleKey then
                    MainFrame.Visible = not MainFrame.Visible
                    OpenBtn.Visible = not MainFrame.Visible
                elseif PanicEnabled and input.KeyCode == PanicKey then
                    MainFrame.Visible = false
                    OpenBtn.Visible = false
                    if Ctx.Notify then Ctx.Notify("Panic", "Все функции отключены!", 2, "error") end
                end
            end
        end)

        CreateSlider(SettingsPage, "Notify Duration", 1, 10, 3, function(v) NotifyDuration = v end)
        local OldNotify = Ctx.Notify
        Ctx.Notify = function(title, text, duration, ntype)
            if OldNotify then OldNotify(title, text, duration or NotifyDuration, ntype) end
        end

        CreateButton(SettingsPage, "Reset All Settings", function()
            MainFrame.BackgroundTransparency = 0
            MainFrame.Size = UDim2.new(0, 520, 0, 340)
            MainCorner.CornerRadius = UDim.new(0, 12)
            Theme.Lavender = Color3.fromRGB(155, 130, 240)
            NotifyDuration = 3
            if Ctx.Notify then Ctx.Notify("Settings", "Настройки сброшены", 2, "success") end
        end)

        local function ResetMenuTimer() LastMenuInteraction = tick() end
        MainFrame.InputBegan:Connect(ResetMenuTimer)
        MainFrame.InputChanged:Connect(ResetMenuTimer)

        CreateSlider(SettingsPage, "Auto-hide Time (sec)", 30, 300, 30, function(v) AutoHideTime = v end)
        CreateToggle(SettingsPage, "Enable Auto-hide", function(state)
            AutoHideEnabled = state
            if state then
                LastMenuInteraction = tick()
                if Ctx.Notify then Ctx.Notify("Settings", "Меню скроется через " .. AutoHideTime .. " сек бездействия", 2, "info") end
            end
        end)

        task.spawn(function()
            while true do
                if AutoHideEnabled and MainFrame.Visible and (tick() - LastMenuInteraction >= AutoHideTime) then
                    MainFrame.Visible = false
                    OpenBtn.Visible = true
                    if Ctx.Notify then Ctx.Notify("Menu", "Меню скрыто (бездействие)", 2, "info") end
                end
                task.wait(1)
            end
        end)
    end
end
