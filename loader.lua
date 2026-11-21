local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local Ctx = {
    Services = {
        UserInputService = UserInputService,
        TweenService = TweenService,
        Players = Players,
        RunService = RunService,
        TeleportService = TeleportService,
        HttpService = HttpService,
        Lighting = Lighting,
    },
    Player = Players.LocalPlayer,
    Camera = workspace.CurrentCamera,
    Language = "ru",
    UIStrings = {
        ru = { Enabled = "Включено", Disabled = "Выключено", InfoTitle = "INFO - Выберите категорию" },
        en = { Enabled = "Enabled", Disabled = "Disabled", InfoTitle = "INFO - Select a category" }
    },
    Theme = {
        MainBg = Color3.fromRGB(24, 24, 28),
        SidebarBg = Color3.fromRGB(32, 32, 38),
        Lavender = Color3.fromRGB(155, 130, 240),
        LavenderGlow = Color3.fromRGB(180, 160, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(150, 150, 160),
        TabActive = Color3.fromRGB(58, 58, 68),
        CloseRed = Color3.fromRGB(230, 75, 75),
        ElementBg = Color3.fromRGB(38, 38, 45)
    },
    FontMain = Enum.Font.GothamBold,
    FontDesc = Enum.Font.SourceSansBold,
    HoverInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    SlideInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Settings = {
        WalkSpeed = 16, JumpPower = 50, SpeedHackEnabled = false, JumpHackEnabled = false,
        InfJump = false, InfZoom = false, Noclip = false, FreezeSelf = false,
        NightVision = false, Aimbot = false,
        Spinbot = false, Freecam = false, FreecamSpeed = 50, FreecamMouseSensitivity = 0.002,
        ESP = false, Tracers = false, TracerStyle = "Center", Chams = false, ChamStyle = "Skeleton"
    },
    Notify = nil,
    Tabs = {},
    UI = {},
    Gui = {}
}

local Theme = Ctx.Theme
local FontMain = Ctx.FontMain
local FontDesc = Ctx.FontDesc
local HoverInfo = Ctx.HoverInfo
local SlideInfo = Ctx.SlideInfo
local player = Ctx.Player

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LavenderPremiumMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Theme.MainBg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local function makeDraggable(guiObject)
    local dragging, dragInput, dragStart, startPos
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
        end
    end)
    guiObject.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(MainFrame)

local function makeScrollable(scrollFrame, uiListLayout)
    local function update()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 15)
    end
    uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
    task.spawn(update)
end

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Rite Cheat Menu"
Title.TextColor3 = Theme.Lavender
Title.Font = FontMain
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -12)
CloseBtn.BackgroundColor3 = Theme.SidebarBg
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Theme.TextDark
CloseBtn.Font = FontMain
CloseBtn.TextSize = 16
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 24, 0, 24)
MinBtn.Position = UDim2.new(1, -66, 0.5, -12)
MinBtn.BackgroundColor3 = Theme.SidebarBg
MinBtn.Text = "-"
MinBtn.TextColor3 = Theme.TextDark
MinBtn.Font = FontMain
MinBtn.TextSize = 16
MinBtn.Parent = TopBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 135, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Theme.SidebarBg
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local SidebarScroll = Instance.new("ScrollingFrame")
SidebarScroll.Size = UDim2.new(1, 0, 1, -55)
SidebarScroll.BackgroundTransparency = 1
SidebarScroll.BorderSizePixel = 0
SidebarScroll.ScrollBarThickness = 0
SidebarScroll.Parent = Sidebar

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 6)
SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarList.Parent = SidebarScroll
Instance.new("UIPadding", SidebarScroll).PaddingTop = UDim.new(0, 12)
makeScrollable(SidebarScroll, SidebarList)

local SidebarBottom = Instance.new("Frame")
SidebarBottom.Size = UDim2.new(1, 0, 0, 45)
SidebarBottom.Position = UDim2.new(0, 0, 1, -45)
SidebarBottom.BackgroundTransparency = 1
SidebarBottom.Parent = Sidebar

local BottomList = Instance.new("UIListLayout")
BottomList.FillDirection = Enum.FillDirection.Horizontal
BottomList.HorizontalAlignment = Enum.HorizontalAlignment.Center
BottomList.VerticalAlignment = Enum.VerticalAlignment.Center
BottomList.Padding = UDim.new(0, 8)
BottomList.Parent = SidebarBottom

local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Size = UDim2.new(0, 34, 0, 34)
SettingsBtn.BackgroundColor3 = Theme.SidebarBg
SettingsBtn.Text = "Set"
SettingsBtn.TextColor3 = Theme.TextDark
SettingsBtn.Font = FontMain
SettingsBtn.TextSize = 14
SettingsBtn.Parent = SidebarBottom
Instance.new("UICorner", SettingsBtn).CornerRadius = UDim.new(0, 8)

local InfoBtn = Instance.new("TextButton")
InfoBtn.Size = UDim2.new(0, 34, 0, 34)
InfoBtn.BackgroundColor3 = Theme.SidebarBg
InfoBtn.Text = "Info"
InfoBtn.TextColor3 = Theme.TextDark
InfoBtn.Font = FontMain
InfoBtn.TextSize = 14
InfoBtn.Parent = SidebarBottom
Instance.new("UICorner", InfoBtn).CornerRadius = UDim.new(0, 8)

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -155, 1, -55)
Container.Position = UDim2.new(0, 145, 0, 45)
Container.BackgroundTransparency = 1
Container.ClipsDescendants = true
Container.Parent = MainFrame

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.3, 0)
OpenBtn.BackgroundColor3 = Theme.MainBg
OpenBtn.Text = "R"
OpenBtn.TextColor3 = Theme.Lavender
OpenBtn.Font = Enum.Font.Gotham
OpenBtn.TextSize = 23
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local OS = Instance.new("UIStroke", OpenBtn)
OS.Color = Theme.Lavender
OS.Thickness = 2
makeDraggable(OpenBtn)

MinBtn.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, 0)})
    tween:Play()
    tween.Completed:Connect(function()
        MainFrame.Visible = false
        OpenBtn.Visible = true
    end)
end)

OpenBtn.MouseButton1Click:Connect(function()
    OpenBtn.Visible = false
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 520, 0, 340)}):Play()
end)

CloseBtn.MouseButton1Click:Connect(function()
    if _G.TracersList then
        for _, line in pairs(_G.TracersList) do pcall(function() line:Destroy() end) end
        _G.TracersList = {}
    end
    if _G.Skeletons then
        for _, skeleton in pairs(_G.Skeletons) do
            for _, line in pairs(skeleton) do pcall(function() line:Destroy() end) end
        end
        _G.Skeletons = {}
    end
    ScreenGui:Destroy()
end)

local ActiveTab = nil
local function SwitchToTab(tabName)
    if ActiveTab == tabName then return end
    local oldTab = Ctx.Tabs[ActiveTab]
    local newTab = Ctx.Tabs[tabName]
    local previousActive = ActiveTab
    ActiveTab = tabName

    if oldTab then
        if oldTab.Indicator then TweenService:Create(oldTab.Indicator, HoverInfo, {Size = UDim2.new(0, 0, 1, 0)}):Play() end
        if oldTab.Button then TweenService:Create(oldTab.Button, HoverInfo, {BackgroundColor3 = Theme.SidebarBg, TextColor3 = Theme.TextDark}):Play() end
        local slideOut = TweenService:Create(oldTab.Page, SlideInfo, {Position = UDim2.new(-1.2, 0, 0, 0)})
        slideOut:Play()
        slideOut.Completed:Connect(function() if ActiveTab ~= previousActive then oldTab.Page.Visible = false end end)
    end

    if newTab then
        if newTab.Indicator then TweenService:Create(newTab.Indicator, HoverInfo, {Size = UDim2.new(0, 4, 1, 0)}):Play() end
        if newTab.Button then TweenService:Create(newTab.Button, HoverInfo, {BackgroundColor3 = Theme.TabActive, TextColor3 = Theme.Text}):Play() end
        newTab.Page.Visible = true
        newTab.Page.Position = UDim2.new(1.2, 0, 0, 0)
        TweenService:Create(newTab.Page, SlideInfo, {Position = UDim2.new(0, 0, 0, 0)}):Play()
    end
end

local function CreateTab(name)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 115, 0, 34)
    Button.BackgroundColor3 = Theme.SidebarBg
    Button.Text = name
    Button.TextColor3 = Theme.TextDark
    Button.Font = FontMain
    Button.TextSize = 13
    Button.Parent = SidebarScroll
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

    local Indicator = Instance.new("Frame", Button)
    Indicator.Size = UDim2.new(0, 0, 1, 0)
    Indicator.BackgroundColor3 = Theme.Lavender
    Indicator.BorderSizePixel = 0
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 4)

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Theme.Lavender
    Page.Visible = false
    Page.Parent = Container

    local PageList = Instance.new("UIListLayout", Page)
    PageList.Padding = UDim.new(0, 6)
    makeScrollable(Page, PageList)

    Ctx.Tabs[name] = {Name = name, Button = Button, Page = Page, Indicator = Indicator}
    Button.MouseButton1Click:Connect(function() SwitchToTab(name) end)

    if not ActiveTab then
        ActiveTab = name
        Button.BackgroundColor3 = Theme.TabActive
        Button.TextColor3 = Theme.Text
        Indicator.Size = UDim2.new(0, 4, 1, 0)
        Page.Visible = true
    end
    return Page
end

local function CreateSpecialTab(name, buttonInstance)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Theme.Lavender
    Page.Visible = false
    Page.Parent = Container

    local PageList = Instance.new("UIListLayout", Page)
    PageList.Padding = UDim.new(0, 6)
    makeScrollable(Page, PageList)

    Ctx.Tabs[name] = {Name = name, Button = buttonInstance, Page = Page}
    buttonInstance.MouseButton1Click:Connect(function() SwitchToTab(name) end)
    return Page
end

local function CreateButton(page, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -6, 0, 36)
    Btn.BackgroundColor3 = Theme.ElementBg
    Btn.Text = text
    Btn.TextColor3 = Theme.Text
    Btn.Font = FontMain
    Btn.TextSize = 13
    Btn.Parent = page
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    Btn.MouseButton1Click:Connect(function()
        Btn.BackgroundColor3 = Theme.Lavender
        task.delay(0.1, function() Btn.BackgroundColor3 = Theme.ElementBg end)
        if type(Ctx.Notify) == "function" then
            Ctx.Notify(text, "Выполнено", 2, "success")
        end
        pcall(callback)
    end)
    return Btn
end

local function CreateToggle(page, text, callback)
    local Enabled = false
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -6, 0, 38)
    Frame.BackgroundColor3 = Theme.ElementBg
    Frame.Parent = page
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.TextDark
    Label.Font = FontMain
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Switch = Instance.new("TextButton", Frame)
    Switch.Size = UDim2.new(0, 36, 0, 20)
    Switch.Position = UDim2.new(1, -48, 0.5, -10)
    Switch.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    Switch.Text = ""
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame", Switch)
    Circle.Size = UDim2.new(0, 14, 0, 14)
    Circle.Position = UDim2.new(0, 3, 0.5, -7)
    Circle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    Switch.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        if Enabled then
            TweenService:Create(Switch, HoverInfo, {BackgroundColor3 = Theme.Lavender}):Play()
            TweenService:Create(Circle, HoverInfo, {Position = UDim2.new(1, -17, 0.5, -7)}):Play()
            Label.TextColor3 = Theme.Text
        else
            TweenService:Create(Switch, HoverInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
            TweenService:Create(Circle, HoverInfo, {Position = UDim2.new(0, 3, 0.5, -7)}):Play()
            Label.TextColor3 = Theme.TextDark
        end
        if type(Ctx.Notify) == "function" then
            local statusText = Enabled and Ctx.UIStrings[Ctx.Language].Enabled or Ctx.UIStrings[Ctx.Language].Disabled
            Ctx.Notify(text, statusText, 2, Enabled and "success" or "info")
        end
        pcall(callback, Enabled)
    end)
    return Frame
end

local activeSlider = nil
UserInputService.InputChanged:Connect(function(input)
    if activeSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        activeSlider.update(input)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        activeSlider = nil
    end
end)

local function CreateSlider(page, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -6, 0, 48)
    Frame.BackgroundColor3 = Theme.ElementBg
    Frame.Parent = page
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -20, 0, 22)
    Label.Position = UDim2.new(0, 12, 0, 4)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. default
    Label.TextColor3 = Theme.Text
    Label.Font = FontMain
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local SliderBar = Instance.new("TextButton", Frame)
    SliderBar.Size = UDim2.new(1, -24, 0, 6)
    SliderBar.Position = UDim2.new(0, 12, 0, 32)
    SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    SliderBar.Text = ""
    Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)

    local Progress = Instance.new("Frame", SliderBar)
    Progress.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Progress.BackgroundColor3 = Theme.Lavender
    Instance.new("UICorner", Progress).CornerRadius = UDim.new(1, 0)

    local SliderValue = default
    local function update(input)
        local xOffset = math.clamp(input.Position.X - SliderBar.AbsolutePosition.X, 0, SliderBar.AbsoluteSize.X)
        local percentage = xOffset / SliderBar.AbsoluteSize.X
        SliderValue = math.round(min + (max - min) * percentage)
        Label.Text = text .. ": " .. SliderValue
        Progress.Size = UDim2.new(percentage, 0, 1, 0)
        pcall(callback, SliderValue)
    end

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            activeSlider = { update = update }
            update(input)
        end
    end)
    return Frame
end

local function CreateDropdown(page, text, options, default, callback)
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(1, -6, 0, 40)
    MainFrame.BackgroundColor3 = Theme.ElementBg
    MainFrame.Parent = page
    MainFrame.ClipsDescendants = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", MainFrame)
    Label.Size = UDim2.new(0.6, -10, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 4)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.Font = FontMain
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ValueLabel = Instance.new("TextLabel", MainFrame)
    ValueLabel.Size = UDim2.new(0.4, -40, 0, 24)
    ValueLabel.Position = UDim2.new(0.6, 0, 0, 8)
    ValueLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    ValueLabel.Text = default
    ValueLabel.TextColor3 = Theme.Text
    ValueLabel.Font = FontMain
    ValueLabel.TextSize = 11
    Instance.new("UICorner", ValueLabel).CornerRadius = UDim.new(0, 4)

    local OptionsBtn = Instance.new("TextButton", MainFrame)
    OptionsBtn.Size = UDim2.new(0, 30, 0, 24)
    OptionsBtn.Position = UDim2.new(1, -36, 0, 8)
    OptionsBtn.BackgroundColor3 = Theme.Lavender
    OptionsBtn.Text = "▼"
    OptionsBtn.TextColor3 = Theme.MainBg
    OptionsBtn.Font = FontMain
    OptionsBtn.TextSize = 10
    Instance.new("UICorner", OptionsBtn).CornerRadius = UDim.new(0, 4)

    local DropList = Instance.new("Frame", MainFrame)
    DropList.Size = UDim2.new(1, -20, 0, 0)
    DropList.Position = UDim2.new(0, 10, 0, 40)
    DropList.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    DropList.BorderSizePixel = 0
    Instance.new("UICorner", DropList).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", DropList).Color = Color3.fromRGB(60, 60, 70)
    Instance.new("UIListLayout", DropList).Padding = UDim.new(0, 2)

    local isOpen = false
    local optionHeight = 22
    local totalListHeight = (#options * optionHeight) + ((#options - 1) * 2) + 4

    OptionsBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            TweenService:Create(MainFrame, HoverInfo, {Size = UDim2.new(1, -6, 0, 40 + totalListHeight)}):Play()
            TweenService:Create(DropList, HoverInfo, {Size = UDim2.new(1, -20, 0, totalListHeight)}):Play()
            OptionsBtn.Text = "▲"
        else
            TweenService:Create(MainFrame, HoverInfo, {Size = UDim2.new(1, -6, 0, 40)}):Play()
            TweenService:Create(DropList, HoverInfo, {Size = UDim2.new(1, -20, 0, 0)}):Play()
            OptionsBtn.Text = "▼"
        end
    end)

    for _, opt in ipairs(options) do
        local OptBtn = Instance.new("TextButton", DropList)
        OptBtn.Size = UDim2.new(1, 0, 0, optionHeight)
        OptBtn.BackgroundTransparency = 1
        OptBtn.Text = opt
        OptBtn.TextColor3 = Theme.TextDark
        OptBtn.Font = FontMain
        OptBtn.TextSize = 12
        Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 4)
        OptBtn.MouseEnter:Connect(function() OptBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70) end)
        OptBtn.MouseLeave:Connect(function() OptBtn.BackgroundTransparency = 1 end)
        OptBtn.MouseButton1Click:Connect(function()
            ValueLabel.Text = opt
            isOpen = false
            TweenService:Create(MainFrame, HoverInfo, {Size = UDim2.new(1, -6, 0, 40)}):Play()
            TweenService:Create(DropList, HoverInfo, {Size = UDim2.new(1, -20, 0, 0)}):Play()
            OptionsBtn.Text = "▼"
            pcall(callback, opt)
        end)
    end
    return MainFrame
end

local function CreatePlayerListDropdown(page, text, onSelectCallback)
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(1, -6, 0, 40)
    MainFrame.BackgroundColor3 = Theme.ElementBg
    MainFrame.Parent = page
    MainFrame.ClipsDescendants = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", MainFrame)
    Label.Size = UDim2.new(0.6, -10, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 4)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.Font = FontMain
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ValueLabel = Instance.new("TextLabel", MainFrame)
    ValueLabel.Size = UDim2.new(0.4, -40, 0, 24)
    ValueLabel.Position = UDim2.new(0.6, 0, 0, 8)
    ValueLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    ValueLabel.Text = "Select..."
    ValueLabel.TextColor3 = Theme.Text
    ValueLabel.Font = FontMain
    ValueLabel.TextSize = 11
    Instance.new("UICorner", ValueLabel).CornerRadius = UDim.new(0, 4)

    local OptionsBtn = Instance.new("TextButton", MainFrame)
    OptionsBtn.Size = UDim2.new(0, 30, 0, 24)
    OptionsBtn.Position = UDim2.new(1, -36, 0, 8)
    OptionsBtn.BackgroundColor3 = Theme.Lavender
    OptionsBtn.Text = "▼"
    OptionsBtn.TextColor3 = Theme.MainBg
    OptionsBtn.Font = FontMain
    OptionsBtn.TextSize = 10
    Instance.new("UICorner", OptionsBtn).CornerRadius = UDim.new(0, 4)

    local DropList = Instance.new("Frame", MainFrame)
    DropList.Size = UDim2.new(1, -20, 0, 0)
    DropList.Position = UDim2.new(0, 10, 0, 40)
    DropList.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    DropList.BorderSizePixel = 0
    Instance.new("UICorner", DropList).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", DropList).Color = Color3.fromRGB(60, 60, 70)
    Instance.new("UIListLayout", DropList).Padding = UDim.new(0, 2)

    local isOpen = false
    local optionHeight = 22

    local function UpdatePlayerList()
        for _, child in ipairs(DropList:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        local options = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then table.insert(options, p.Name) end
        end
        local totalListHeight = (#options * optionHeight) + ((#options - 1) * 2) + 4
        for _, opt in ipairs(options) do
            local OptBtn = Instance.new("TextButton", DropList)
            OptBtn.Size = UDim2.new(1, 0, 0, optionHeight)
            OptBtn.BackgroundTransparency = 1
            OptBtn.Text = opt
            OptBtn.TextColor3 = Theme.TextDark
            OptBtn.Font = FontMain
            OptBtn.TextSize = 12
            Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 4)
            OptBtn.MouseEnter:Connect(function() OptBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70) end)
            OptBtn.MouseLeave:Connect(function() OptBtn.BackgroundTransparency = 1 end)
            OptBtn.MouseButton1Click:Connect(function()
                ValueLabel.Text = opt
                isOpen = false
                TweenService:Create(MainFrame, HoverInfo, {Size = UDim2.new(1, -6, 0, 40)}):Play()
                TweenService:Create(DropList, HoverInfo, {Size = UDim2.new(1, -20, 0, 0)}):Play()
                OptionsBtn.Text = "▼"
                if onSelectCallback then onSelectCallback(opt) end
            end)
        end
        if isOpen then
            TweenService:Create(MainFrame, HoverInfo, {Size = UDim2.new(1, -6, 0, 40 + totalListHeight)}):Play()
            TweenService:Create(DropList, HoverInfo, {Size = UDim2.new(1, -20, 0, totalListHeight)}):Play()
        end
    end

    OptionsBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        local count = 0
        for _, p in ipairs(Players:GetPlayers()) do if p ~= player then count = count + 1 end end
        local totalListHeight = (count * optionHeight) + ((count - 1) * 2) + 4
        if isOpen then
            TweenService:Create(MainFrame, HoverInfo, {Size = UDim2.new(1, -6, 0, 40 + totalListHeight)}):Play()
            TweenService:Create(DropList, HoverInfo, {Size = UDim2.new(1, -20, 0, totalListHeight)}):Play()
            OptionsBtn.Text = "▲"
        else
            TweenService:Create(MainFrame, HoverInfo, {Size = UDim2.new(1, -6, 0, 40)}):Play()
            TweenService:Create(DropList, HoverInfo, {Size = UDim2.new(1, -20, 0, 0)}):Play()
            OptionsBtn.Text = "▼"
        end
    end)

    UpdatePlayerList()
    Players.PlayerAdded:Connect(UpdatePlayerList)
    Players.PlayerRemoving:Connect(UpdatePlayerList)
    return MainFrame
end

local function CreateTextBox(page, text, placeholder, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -6, 0, 40)
    Frame.BackgroundColor3 = Theme.ElementBg
    Frame.Parent = page
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.5, -10, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.TextDark
    Label.Font = FontMain
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local TextBox = Instance.new("TextBox", Frame)
    TextBox.Size = UDim2.new(0.45, -10, 0, 26)
    TextBox.Position = UDim2.new(0.55, 0, 0.5, -13)
    TextBox.BackgroundColor3 = Theme.MainBg
    TextBox.TextColor3 = Theme.Text
    TextBox.PlaceholderText = placeholder
    TextBox.PlaceholderColor3 = Theme.TextDark
    TextBox.Font = FontMain
    TextBox.TextSize = 13
    TextBox.Text = default or ""
    TextBox.ClearTextOnFocus = false
    TextBox.TextStrokeTransparency = 1
    TextBox.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 4)

    local boxStroke = Instance.new("UIStroke", TextBox)
    boxStroke.Color = Theme.Lavender
    boxStroke.Thickness = 1
    boxStroke.Transparency = 0.6
    boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    TextBox.Focused:Connect(function()
        TweenService:Create(boxStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0, Thickness = 1.5}):Play()
    end)
    TextBox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(boxStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0.6, Thickness = 1}):Play()
        if enterPressed then pcall(callback, TextBox.Text) end
    end)
    return Frame
end

Ctx.UI = {
    CreateTab = CreateTab,
    CreateSpecialTab = CreateSpecialTab,
    CreateButton = CreateButton,
    CreateToggle = CreateToggle,
    CreateSlider = CreateSlider,
    CreateDropdown = CreateDropdown,
    CreatePlayerListDropdown = CreatePlayerListDropdown,
    CreateTextBox = CreateTextBox,
}

Ctx.Pages = {
    Combat = CreateTab("Combat"),
    Movement = CreateTab("Movement"),
    Player = CreateTab("Player"),
    Visuals = CreateTab("Visuals"),
    World = CreateTab("World"),
    Misc = CreateTab("Misc"),
    Settings = CreateSpecialTab("Settings", SettingsBtn),
}

Ctx.Gui = {
    ScreenGui = ScreenGui,
    MainFrame = MainFrame,
    MainCorner = MainCorner,
    Sidebar = Sidebar,
    Container = Container,
    OpenBtn = OpenBtn,
}

-- Вкладка Info
do
    local InfoPage = Instance.new("ScrollingFrame")
    InfoPage.Size = UDim2.new(1, 0, 1, 0)
    InfoPage.BackgroundTransparency = 1
    InfoPage.BorderSizePixel = 0
    InfoPage.ScrollBarThickness = 3
    InfoPage.ScrollBarImageColor3 = Theme.Lavender
    InfoPage.Visible = false
    InfoPage.Parent = Container
    Ctx.Tabs["Info"] = {Name = "Info", Button = InfoBtn, Page = InfoPage}
    InfoBtn.MouseButton1Click:Connect(function() SwitchToTab("Info") end)

    local CategoriesData = {
        Combat = {
            name = "Combat", icon = "⚔️", description = "Функции для боя и PvP",
            functions = {
                {name = "Aimbot (Lock-on)", desc = "Автоматически наводится на головы врагов"},
                {name = "Hitbox Expander", desc = "Увеличивает хитбоксы других игроков"},
                {name = "Show Aimbot FOV Circle", desc = "Показывает круг видимости аимбота"},
                {name = "Distance ESP", desc = "Показывает расстояние до игроков"}
            }
        },
        Movement = {
            name = "Movement", icon = "🏃", description = "Функции для перемещения",
            functions = {
                {name = "Speed Hack", desc = "Увеличивает скорость передвижения"},
                {name = "Jump Hack", desc = "Увеличивает силу прыжка"},
                {name = "Infinite Jump", desc = "Бесконечные прыжки без отрыва от земли"},
                {name = "Noclip", desc = "Прохождение сквозь стены"},
                {name = "Spinbot", desc = "Автоматическое вращение персонажа"},
                {name = "Open Fly Panel", desc = "Открывает панель полёта"},
                {name = "Auto Jump", desc = "Автоматические прыжки при беге"},
                {name = "Wall Hop", desc = "Прыжки от стен"},
                {name = "Teleport to Player", desc = "Телепорт к игроку по нику"},
                {name = "Teleport to Mouse", desc = "Телепорт по клику мыши"},
                {name = "Невидимая платформа", desc = "Создает невидимую платформу под ногами, чтобы не упасть в бездну"}
            }
        },
        Player = {
            name = "Player", icon = "👤", description = "Настройки персонажа",
            functions = {
                {name = "Freeze My Character", desc = "Замораживает персонажа на месте"},
                {name = "Rainbow Character", desc = "Радужная окраска персонажа (Видно только тебе)"}
            }
        },
        Visuals = {
            name = "Visuals", icon = "👁️", description = "Визуальные улучшения",
            functions = {
                {name = "ESP (Player Names)", desc = "Показывает имена игроков над головами"},
                {name = "Tracers", desc = "Линии от центра экрана до игроков"},
                {name = "Chams", desc = "Подсветка игроков через стены (Skeleton/Box)"},
                {name = "Health Bars ESP", desc = "Полоски здоровья над игроками"},
                {name = "Remove Particles & Trails", desc = "Убирает частицы и следы"},
                {name = "Show FPS & Ping Overlay", desc = "Отображение FPS и пинга"},
                {name = "XRay (Follow Camera)", desc = "Режим рентген камеры"},
                {name = "Freecam", desc = "Свободная камера с управлением"},
                {name = "Crosshair", desc = "Прицел в центре экрана"},
                {name = "Fullbright", desc = "Делает мир максимально ярким и убирает тени"},
                {name = "Disable Fog", desc = "Убирает туман, при выключении возвращает оригинальные настройки карты"},
            }
        },
        World = {
            name = "World", icon = "🌍", description = "Настройки мира",
            functions = {
                {name = "Infinite Zoom", desc = "Бесконечное приближение камеры"},
                {name = "Night Vision", desc = "Ночное зрение (яркое освещение)"},
                {name = "Custom Time (Lock)", desc = "Фиксация времени суток"},
                {name = "No Gravity", desc = "Отключение гравитации"},
                {name = "Custom Gravity", desc = "Настройка гравитации"},
                {name = "Fast Day/Night Cycle", desc = "Красивая сменя дня и ночи"}
            }
        },
        Misc = {
            name = "Misc", icon = "⚙️", description = "Разное",
            functions = {
                {name = "Anti-AFK", desc = "Предотвращение AFK режима"},
                {name = "Rejoin", desc = "Быстрое переподключение к серверу"},
                {name = "Server Hop", desc = "Переход на другой сервер с меньшим онлайном"},
                {name = "Uncap FPS", desc = "Снятие ограничения FPS"},
                {name = "Copy My Username", desc = "Копировать имя пользователя"},
                {name = "Copy My UserId", desc = "Копировать ID пользователя"},
                {name = "Copy Server ID", desc = "Копировать ID сервера"},
                {name = "Copy My Coordinates", desc = "Копировать свои координаты"}
            }
        }
    }

    local Translations = {
        Combat = {
            description = "Combat functions and PvP",
            ["Aimbot (Lock-on)"] = "Automatically aims at enemy heads",
            ["Hitbox Expander"] = "Increases other players' hitboxes",
            ["Show Aimbot FOV Circle"] = "Shows the aimbot's field of view circle",
            ["Distance ESP"] = "Shows distance to players"
        },
        Movement = {
            description = "Movement functions",
            ["Speed Hack"] = "Increases movement speed",
            ["Jump Hack"] = "Increases jump power",
            ["Infinite Jump"] = "Infinite jumps without leaving the ground",
            ["Noclip"] = "Walk through walls",
            ["Spinbot"] = "Automatic character rotation",
            ["Open Fly Panel"] = "Opens the fly control panel",
            ["Auto Jump"] = "Automatic jumps while running",
            ["Wall Hop"] = "Jump off walls",
            ["Teleport to Player"] = "Teleport to a player by name",
            ["Teleport to Mouse"] = "Teleport to mouse click location",
            ["Invisible platform"] = "Creates an invisible platform under your feet to prevent falling into the void"
        },
        Player = {
            description = "Character settings",
            ["Freeze My Character"] = "Freezes the character in place",
            ["Rainbow Character"] = "Rainbow coloring of the character (Client-side only)"
        },
        Visuals = {
            description = "Visual improvements",
            ["ESP (Player Names)"] = "Shows player names above their heads",
            ["Tracers"] = "Lines from screen center to players",
            ["Chams"] = "Player highlighting through walls (Skeleton/Box)",
            ["Health Bars ESP"] = "Health bars above players",
            ["Remove Particles & Trails"] = "Removes particles and trails",
            ["Show FPS & Ping Overlay"] = "Displays FPS and ping",
            ["XRay (Follow Camera)"] = "X-ray camera mode",
            ["Freecam"] = "Free camera with controls",
            ["Crosshair"] = "Crosshair in the center of the screen",
            ["Fullbright"] = "Makes the world fully bright and removes shadows",
            ["Disable Fog"] = "Removes fog, restores original map settings when turned off",
        },
        World = {
            description = "World settings",
            ["Infinite Zoom"] = "Infinite camera zoom",
            ["Night Vision"] = "Night vision (bright lighting)",
            ["Custom Time (Lock)"] = "Locks the time of day",
            ["No Gravity"] = "Disables gravity",
            ["Custom Gravity"] = "Custom gravity setting",
            ["Fast Day/Night Cycle"] = "A beautiful transition from day to night"
        },
        Misc = {
            description = "Miscellaneous",
            ["Anti-AFK"] = "Prevents AFK mode",
            ["Rejoin"] = "Quick reconnection to the server",
            ["Server Hop"] = "Switch to a server with fewer players",
            ["Uncap FPS"] = "Removes FPS limit",
            ["Copy My Username"] = "Copy username to clipboard",
            ["Copy My UserId"] = "Copy user ID to clipboard",
            ["Copy Server ID"] = "Copy server ID to clipboard",
            ["Copy My Coordinates"] = "Copy your coordinates to clipboard"
        }
    }

    local FoldersView = Instance.new("Frame", InfoPage)
    FoldersView.Size = UDim2.new(1, 0, 1, 0)
    FoldersView.BackgroundTransparency = 1

    local CategoryView = Instance.new("Frame", InfoPage)
    CategoryView.Size = UDim2.new(1, 0, 1, 0)
    CategoryView.BackgroundTransparency = 1
    CategoryView.Visible = false

    local InfoTitle = Instance.new("TextLabel", FoldersView)
    InfoTitle.Size = UDim2.new(1, 0, 0, 40)
    InfoTitle.Position = UDim2.new(0, 0, 0, 10)
    InfoTitle.BackgroundTransparency = 1
    InfoTitle.Text = Ctx.UIStrings[Ctx.Language].InfoTitle
    InfoTitle.TextColor3 = Theme.Lavender
    InfoTitle.Font = FontMain
    InfoTitle.TextSize = 16
    InfoTitle.TextXAlignment = Enum.TextXAlignment.Center

    local FoldersContainer = Instance.new("Frame", FoldersView)
    FoldersContainer.Size = UDim2.new(1, -20, 1, -60)
    FoldersContainer.Position = UDim2.new(0, 10, 0, 60)
    FoldersContainer.BackgroundTransparency = 1

    local FoldersLayout = Instance.new("UIListLayout", FoldersContainer)
    FoldersLayout.Padding = UDim.new(0, 10)
    FoldersLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    FoldersLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local BackBtn = Instance.new("TextButton", CategoryView)
    BackBtn.Size = UDim2.new(0, 36, 0, 36)
    BackBtn.Position = UDim2.new(0, 10, 0, 10)
    BackBtn.BackgroundColor3 = Theme.SidebarBg
    BackBtn.Text = "‹"
    BackBtn.TextColor3 = Theme.Lavender
    BackBtn.Font = FontMain
    BackBtn.TextSize = 24
    Instance.new("UICorner", BackBtn).CornerRadius = UDim.new(0, 6)
    BackBtn.MouseButton1Click:Connect(function() CategoryView.Visible = false; FoldersView.Visible = true end)
    BackBtn.MouseEnter:Connect(function() TweenService:Create(BackBtn, HoverInfo, {BackgroundColor3 = Theme.TabActive}):Play() end)
    BackBtn.MouseLeave:Connect(function() TweenService:Create(BackBtn, HoverInfo, {BackgroundColor3 = Theme.SidebarBg}):Play() end)

    local CategoryTitle = Instance.new("TextLabel", CategoryView)
    CategoryTitle.Size = UDim2.new(1, -70, 0, 30)
    CategoryTitle.Position = UDim2.new(0, 60, 0, 13)
    CategoryTitle.BackgroundTransparency = 1
    CategoryTitle.TextColor3 = Theme.Lavender
    CategoryTitle.Font = FontMain
    CategoryTitle.TextSize = 16
    CategoryTitle.TextXAlignment = Enum.TextXAlignment.Left

    local CategoryDesc = Instance.new("TextLabel", CategoryView)
    CategoryDesc.Size = UDim2.new(1, -20, 0, 20)
    CategoryDesc.Position = UDim2.new(0, 10, 0, 45)
    CategoryDesc.BackgroundTransparency = 1
    CategoryDesc.TextColor3 = Theme.TextDark
    CategoryDesc.Font = FontDesc
    CategoryDesc.TextSize = 12
    CategoryDesc.TextXAlignment = Enum.TextXAlignment.Center

    local FunctionsContainer = Instance.new("ScrollingFrame", CategoryView)
    FunctionsContainer.Size = UDim2.new(1, -20, 1, -80)
    FunctionsContainer.Position = UDim2.new(0, 10, 0, 70)
    FunctionsContainer.BackgroundTransparency = 1
    FunctionsContainer.BorderSizePixel = 0
    FunctionsContainer.ScrollBarThickness = 4
    FunctionsContainer.ScrollBarImageColor3 = Theme.Lavender

    local FunctionsLayout = Instance.new("UIListLayout", FunctionsContainer)
    FunctionsLayout.Padding = UDim.new(0, 8)
    FunctionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    FunctionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", FunctionsContainer).PaddingBottom = UDim.new(0, 10)

    local function OpenCategory(categoryKey)
        local data = CategoriesData[categoryKey]
        if not data then return end
        FoldersView.Visible = false
        CategoryView.Visible = true
        CategoryTitle.Text = data.icon .. " " .. data.name:upper()

        local categoryDescription = data.description
        if Ctx.Language == "en" and Translations[categoryKey] and Translations[categoryKey].description then
            categoryDescription = Translations[categoryKey].description
        end
        CategoryDesc.Text = categoryDescription

        for _, child in ipairs(FunctionsContainer:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end

        for i, func in ipairs(data.functions) do
            local FuncFrame = Instance.new("Frame")
            FuncFrame.Size = UDim2.new(1, -20, 0, 0)
            FuncFrame.AutomaticSize = Enum.AutomaticSize.Y
            FuncFrame.BackgroundColor3 = Theme.ElementBg
            Instance.new("UICorner", FuncFrame).CornerRadius = UDim.new(0, 6)

            local FuncNum = Instance.new("TextLabel", FuncFrame)
            FuncNum.Size = UDim2.new(0, 30, 0, 30)
            FuncNum.Position = UDim2.new(0, 10, 0, 8)
            FuncNum.BackgroundTransparency = 1
            FuncNum.Text = tostring(i)
            FuncNum.TextColor3 = Theme.Lavender
            FuncNum.Font = FontMain
            FuncNum.TextSize = 16
            FuncNum.TextXAlignment = Enum.TextXAlignment.Center

            local FuncName = Instance.new("TextLabel", FuncFrame)
            FuncName.Size = UDim2.new(1, -50, 0, 20)
            FuncName.Position = UDim2.new(0, 50, 0, 8)
            FuncName.BackgroundTransparency = 1
            FuncName.Text = func.name
            FuncName.TextColor3 = Theme.Text
            FuncName.Font = FontMain
            FuncName.TextSize = 12
            FuncName.TextXAlignment = Enum.TextXAlignment.Left

            local description = func.desc
            if Ctx.Language == "en" and Translations[categoryKey] and Translations[categoryKey][func.name] then
                description = Translations[categoryKey][func.name]
            end

            local FuncDesc = Instance.new("TextLabel", FuncFrame)
            FuncDesc.Size = UDim2.new(1, -50, 0, 0)
            FuncDesc.Position = UDim2.new(0, 50, 0, 28)
            FuncDesc.AutomaticSize = Enum.AutomaticSize.Y
            FuncDesc.BackgroundTransparency = 1
            FuncDesc.Text = description
            FuncDesc.TextColor3 = Theme.TextDark
            FuncDesc.Font = FontDesc
            FuncDesc.TextSize = 11
            FuncDesc.TextWrapped = true
            FuncDesc.TextXAlignment = Enum.TextXAlignment.Left

            Instance.new("UIPadding", FuncFrame).PaddingBottom = UDim.new(0, 10)
            FuncFrame.Parent = FunctionsContainer
        end

        task.wait(0.05)
        FunctionsContainer.CanvasSize = UDim2.new(0, 0, 0, FunctionsLayout.AbsoluteContentSize.Y + 20)
        FunctionsContainer.CanvasPosition = Vector2.new(0, 0)
    end

    local function CreateFolder(categoryKey, categoryData)
        local FolderBtn = Instance.new("TextButton")
        FolderBtn.Size = UDim2.new(0, 200, 0, 50)
        FolderBtn.BackgroundColor3 = Theme.ElementBg
        FolderBtn.Text = ""
        Instance.new("UICorner", FolderBtn).CornerRadius = UDim.new(0, 8)

        local Icon = Instance.new("TextLabel", FolderBtn)
        Icon.Size = UDim2.new(0, 40, 0, 40)
        Icon.Position = UDim2.new(0, 15, 0.5, -20)
        Icon.BackgroundTransparency = 1
        Icon.Text = categoryData.icon
        Icon.TextColor3 = Theme.Lavender
        Icon.Font = FontMain
        Icon.TextSize = 24

        local FolderName = Instance.new("TextLabel", FolderBtn)
        FolderName.Size = UDim2.new(1, -70, 0, 20)
        FolderName.Position = UDim2.new(0, 65, 0, 15)
        FolderName.BackgroundTransparency = 1
        FolderName.Text = categoryData.name
        FolderName.TextColor3 = Theme.Text
        FolderName.Font = FontMain
        FolderName.TextSize = 14
        FolderName.TextXAlignment = Enum.TextXAlignment.Left

        local Arrow = Instance.new("TextLabel", FolderBtn)
        Arrow.Size = UDim2.new(0, 30, 0, 30)
        Arrow.Position = UDim2.new(1, -40, 0.5, -15)
        Arrow.BackgroundTransparency = 1
        Arrow.Text = "›"
        Arrow.TextColor3 = Theme.TextDark
        Arrow.Font = FontMain
        Arrow.TextSize = 24

        FolderBtn.MouseEnter:Connect(function() TweenService:Create(FolderBtn, HoverInfo, {BackgroundColor3 = Theme.SidebarBg}):Play() end)
        FolderBtn.MouseLeave:Connect(function() TweenService:Create(FolderBtn, HoverInfo, {BackgroundColor3 = Theme.ElementBg}):Play() end)
        FolderBtn.MouseButton1Click:Connect(function() OpenCategory(categoryKey) end)
        FolderBtn.Parent = FoldersContainer
    end

    for _, key in ipairs({"Combat", "Movement", "Player", "Visuals", "World", "Misc"}) do
        if CategoriesData[key] then CreateFolder(key, CategoriesData[key]) end
    end

    -- Кнопка языка
    local LanguageBtn = Instance.new("TextButton")
    LanguageBtn.Size = UDim2.new(0, 200, 0, 50)
    LanguageBtn.BackgroundColor3 = Theme.ElementBg
    LanguageBtn.Text = ""
    Instance.new("UICorner", LanguageBtn).CornerRadius = UDim.new(0, 8)

    local LangIcon = Instance.new("TextLabel", LanguageBtn)
    LangIcon.Size = UDim2.new(0, 40, 0, 40)
    LangIcon.Position = UDim2.new(0, 15, 0.5, -20)
    LangIcon.BackgroundTransparency = 1
    LangIcon.Text = "🌐"
    LangIcon.TextColor3 = Theme.Lavender
    LangIcon.Font = FontMain
    LangIcon.TextSize = 24

    local LangName = Instance.new("TextLabel", LanguageBtn)
    LangName.Size = UDim2.new(1, -70, 0, 20)
    LangName.Position = UDim2.new(0, 65, 0, 15)
    LangName.BackgroundTransparency = 1
    LangName.Text = "Language: Русский"
    LangName.TextColor3 = Theme.Text
    LangName.Font = FontMain
    LangName.TextSize = 14
    LangName.TextXAlignment = Enum.TextXAlignment.Left

    local LangArrow = Instance.new("TextLabel", LanguageBtn)
    LangArrow.Size = UDim2.new(0, 30, 0, 30)
    LangArrow.Position = UDim2.new(1, -40, 0.5, -15)
    LangArrow.BackgroundTransparency = 1
    LangArrow.Text = "›"
    LangArrow.TextColor3 = Theme.TextDark
    LangArrow.Font = FontMain
    LangArrow.TextSize = 24

    LanguageBtn.MouseEnter:Connect(function() TweenService:Create(LanguageBtn, HoverInfo, {BackgroundColor3 = Theme.SidebarBg}):Play() end)
    LanguageBtn.MouseLeave:Connect(function() TweenService:Create(LanguageBtn, HoverInfo, {BackgroundColor3 = Theme.ElementBg}):Play() end)
    LanguageBtn.MouseButton1Click:Connect(function()
        if Ctx.Language == "ru" then
            Ctx.Language = "en"
            LangName.Text = "Language: English"
            if Ctx.Notify then Ctx.Notify("Language", "Language changed to English", 2, "success") end
        else
            Ctx.Language = "ru"
            LangName.Text = "Language: Русский"
            if Ctx.Notify then Ctx.Notify("Language", "Язык изменён на Русский", 2, "success") end
        end
        InfoTitle.Text = Ctx.UIStrings[Ctx.Language].InfoTitle

        if CategoryView.Visible then
            local currentCategoryKey = nil
            for key, data in pairs(CategoriesData) do
                if CategoryTitle.Text:find(data.name:upper()) then
                    currentCategoryKey = key
                    break
                end
            end
            if currentCategoryKey then
                for i, funcFrame in ipairs(FunctionsContainer:GetChildren()) do
                    if funcFrame:IsA("Frame") then
                        local funcNameLabel = funcFrame:FindFirstChildOfClass("TextLabel")
                        local funcData = CategoriesData[currentCategoryKey].functions[i]
                        if funcNameLabel and funcData then
                            local description = funcData.desc
                            if Ctx.Language == "en" and Translations[currentCategoryKey] and Translations[currentCategoryKey][funcNameLabel.Text] then
                                description = Translations[currentCategoryKey][funcNameLabel.Text]
                            end
                            for _, child in ipairs(funcFrame:GetChildren()) do
                                if child:IsA("TextLabel") and child ~= funcNameLabel and child.Position.Y.Offset >= 28 then
                                    child.Text = description
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    LanguageBtn.Parent = FoldersContainer

    -- Кнопка контактов
    local ContactsBtn = Instance.new("TextButton")
    ContactsBtn.Size = UDim2.new(0, 200, 0, 50)
    ContactsBtn.BackgroundColor3 = Theme.Lavender
    ContactsBtn.Text = ""
    Instance.new("UICorner", ContactsBtn).CornerRadius = UDim.new(0, 8)

    local ContactsIcon = Instance.new("TextLabel", ContactsBtn)
    ContactsIcon.Size = UDim2.new(0, 40, 0, 40)
    ContactsIcon.Position = UDim2.new(0, 15, 0.5, -20)
    ContactsIcon.BackgroundTransparency = 1
    ContactsIcon.Text = "📞"
    ContactsIcon.TextColor3 = Theme.MainBg
    ContactsIcon.Font = FontMain
    ContactsIcon.TextSize = 24

    local ContactsName = Instance.new("TextLabel", ContactsBtn)
    ContactsName.Size = UDim2.new(1, -70, 0, 20)
    ContactsName.Position = UDim2.new(0, 65, 0, 15)
    ContactsName.BackgroundTransparency = 1
    ContactsName.Text = "Contacts"
    ContactsName.TextColor3 = Theme.MainBg
    ContactsName.Font = FontMain
    ContactsName.TextSize = 14
    ContactsName.TextXAlignment = Enum.TextXAlignment.Left

    local ContactsArrow = Instance.new("TextLabel", ContactsBtn)
    ContactsArrow.Size = UDim2.new(0, 30, 0, 30)
    ContactsArrow.Position = UDim2.new(1, -40, 0.5, -15)
    ContactsArrow.BackgroundTransparency = 1
    ContactsArrow.Text = "›"
    ContactsArrow.TextColor3 = Theme.MainBg
    ContactsArrow.Font = FontMain
    ContactsArrow.TextSize = 24

    ContactsBtn.MouseEnter:Connect(function() TweenService:Create(ContactsBtn, HoverInfo, {BackgroundColor3 = Theme.LavenderGlow}):Play() end)
    ContactsBtn.MouseLeave:Connect(function() TweenService:Create(ContactsBtn, HoverInfo, {BackgroundColor3 = Theme.Lavender}):Play() end)
    ContactsBtn.MouseButton1Click:Connect(function()
        if Ctx.Notify then Ctx.Notify("Contacts", "Discord: @Remurchik\nTelegram: @Remurch1k", 5, "info") end
    end)
    ContactsBtn.Parent = FoldersContainer
end

local PARTS = {
    { name = "part1_gameplay", url = "https://raw.githubusercontent.com/Remurka69/Rite-Menu-v1/refs/heads/main/part1_gameplay.lua" },
    { name = "part2_modules",  url = "https://raw.githubusercontent.com/Remurka69/Rite-Menu-v1/refs/heads/main/part2_modules.lua" },
    { name = "part3_settings", url = "https://raw.githubusercontent.com/Remurka69/Rite-Menu-v1/refs/heads/main/part3_settings.lua" },
}

local function getFreshCode(url)
    local sep = url:find("?", 1, true) and "&" or "?"
    return game:HttpGet(url .. sep .. "cb=" .. tostring(math.random(1, 1000000)) .. "_" .. tostring(os.clock()))
end

local function countElements()
    local n = 0
    for _, page in pairs(Ctx.Pages) do
        for _, ch in ipairs(page:GetChildren()) do
            if not ch:IsA("UIListLayout") and not ch:IsA("UIPadding") then
                n += 1
            end
        end
    end
    return n
end

for _, part in ipairs(PARTS) do
    local okHttp, srcOrErr = pcall(function()
        return getFreshCode(part.url)
    end)

    if not okHttp or type(srcOrErr) ~= "string" or #srcOrErr == 0 then
        warn("[Loader] Ошибка HttpGet для " .. part.name .. ": " .. tostring(srcOrErr))
        if Ctx.Notify then
            Ctx.Notify("Loader Error", "Не скачан " .. part.name .. " (см. F9)", 4, "error")
        end
    else
        local chunk, loadErr = loadstring(srcOrErr)
        if not chunk then
            warn("[Loader] Ошибка синтаксиса в " .. part.name .. ": " .. tostring(loadErr))
            if Ctx.Notify then
                Ctx.Notify("Syntax Error", part.name .. " (см. F9)", 4, "error")
            end
        else
            local before = countElements()
            local okRun, resOrErr = pcall(chunk, Ctx)
            local after = countElements()
            if not okRun then
                warn("[Loader] Ошибка выполнения " .. part.name .. ": " .. tostring(resOrErr))
                if Ctx.Notify then
                    Ctx.Notify("Runtime Error", part.name .. " (см. F9)", 4, "error")
                end
            else
                print(string.format("[Loader] %s -> добавлено элементов: %d (тип возврата: %s)", part.name, after - before, typeof(resOrErr)))
            end
        end
    end
end

task.delay(1, function()
    if Ctx.Notify then
        Ctx.Notify("Rite Cheat", "Меню успешно загружено! Приятной игры 🎮", 4, "success")
    end
end)
