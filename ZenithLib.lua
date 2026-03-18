-- ZenithLib.lua
local ZenithLib = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Цвета
local Accent = Color3.fromRGB(0, 120, 255)
local DarkBg = Color3.fromRGB(20, 20, 22)
local DarkerBg = Color3.fromRGB(24, 24, 26)
local ElementBg = Color3.fromRGB(35, 35, 38)
local ToggleOff = Color3.fromRGB(60, 60, 65)
local BorderColor = Color3.fromRGB(45, 45, 48)
local LightText = Color3.fromRGB(255, 255, 255)
local GreyText = Color3.fromRGB(150, 150, 155)

function ZenithLib:CreateWindow(title, subtitle)
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        ToggleKey = Enum.KeyCode.RightControl,
        Elements = {},
        Gui = nil
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ZenithClient"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Enabled = true
    Window.Gui = ScreenGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 720, 0, 420)
    MainFrame.Position = UDim2.new(0.5, -360, 0.5, -210)
    MainFrame.BackgroundColor3 = DarkBg
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = BorderColor
    UIStroke.Thickness = 1.5
    UIStroke.Parent = MainFrame

    -- Сайдбар
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 180, 1, 0)
    Sidebar.BackgroundColor3 = DarkerBg
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 10)
    SidebarCorner.Parent = Sidebar

    -- Логотип
    local LogoFrame = Instance.new("Frame")
    LogoFrame.Size = UDim2.new(0, 45, 0, 45)
    LogoFrame.Position = UDim2.new(0, 15, 0, 18)
    LogoFrame.BackgroundColor3 = DarkerBg
    LogoFrame.BorderSizePixel = 0
    LogoFrame.Parent = Sidebar

    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 8)
    LogoCorner.Parent = LogoFrame

    local LogoImage = Instance.new("ImageLabel")
    LogoImage.Size = UDim2.new(1, -8, 1, -8)
    LogoImage.Position = UDim2.new(0, 4, 0, 4)
    LogoImage.BackgroundTransparency = 1
    LogoImage.Image = "rbxassetid://79064074944871"
    LogoImage.Parent = LogoFrame

    -- Заголовок в сайдбаре (увеличен отступ слева, чтобы не упиралось в край)
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -65, 0, 22)
    TitleLabel.Position = UDim2.new(0, 80, 0, 20)  -- было 75, стало 80
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = LightText
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Sidebar

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Size = UDim2.new(1, -65, 0, 18)
    SubLabel.Position = UDim2.new(0, 80, 0, 42)   -- было 75, стало 80
    SubLabel.BackgroundTransparency = 1
    SubLabel.Text = subtitle
    SubLabel.TextColor3 = GreyText
    SubLabel.TextSize = 12
    SubLabel.Font = Enum.Font.Gotham
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.Parent = Sidebar

    -- Категории
    local CategoryList = Instance.new("Frame")
    CategoryList.Size = UDim2.new(1, -20, 0, 0)
    CategoryList.Position = UDim2.new(0, 10, 0, 75)
    CategoryList.BackgroundTransparency = 1
    CategoryList.Parent = Sidebar

    local CategoryLayout = Instance.new("UIListLayout")
    CategoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
    CategoryLayout.Padding = UDim.new(0, 5)
    CategoryLayout.Parent = CategoryList

    -- Контент
    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -190, 1, -20)
    ContentArea.Position = UDim2.new(0, 190, 0, 15)  -- увеличено с 10 до 15 (отступ сверху)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame

    local ContentTitle = Instance.new("TextLabel")
    ContentTitle.Size = UDim2.new(1, -20, 0, 40)
    ContentTitle.Position = UDim2.new(0, 10, 0, 0)
    ContentTitle.BackgroundTransparency = 1
    ContentTitle.Text = ""
    ContentTitle.TextColor3 = LightText
    ContentTitle.TextSize = 28
    ContentTitle.Font = Enum.Font.GothamBold
    ContentTitle.TextXAlignment = Enum.TextXAlignment.Left
    ContentTitle.Parent = ContentArea

    local ContentHolder = Instance.new("Frame")
    ContentHolder.Size = UDim2.new(1, 0, 1, -50)
    ContentHolder.Position = UDim2.new(0, 0, 0, 50)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Parent = ContentArea

    -- Функции для работы с вкладками
    function Window:AddTab(name, icon)
        local tab = {
            Name = name,
            Sections = {},
            Elements = {},
            Container = Instance.new("Frame"),
            YPos = 10,
            LeftY = 10,
            RightY = 10
        }

        tab.Container.Size = UDim2.new(1, 0, 1, 0)
        tab.Container.BackgroundTransparency = 1
        tab.Container.Visible = false
        tab.Container.Parent = ContentHolder

        -- Кнопка в сайдбаре
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = CategoryList

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn

        local iconLabel = Instance.new("ImageLabel")
        iconLabel.Size = UDim2.new(0, 20, 0, 20)
        iconLabel.Position = UDim2.new(0, 8, 0.5, -10)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Image = icon
        iconLabel.ImageColor3 = GreyText
        iconLabel.Parent = btn

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -35, 1, 0)
        textLabel.Position = UDim2.new(0, 30, 0, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = name
        textLabel.TextColor3 = LightText
        textLabel.TextSize = 13
        textLabel.Font = Enum.Font.Gotham
        textLabel.TextYAlignment = Enum.TextYAlignment.Center
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.Parent = btn

        tab.Button = btn
        tab.Icon = iconLabel
        tab.Text = textLabel

        btn.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Container.Visible = false
                Window.CurrentTab.Icon.ImageColor3 = GreyText
                Window.CurrentTab.Text.TextColor3 = LightText
                Window.CurrentTab.Button.BackgroundTransparency = 1
            end
            Window.CurrentTab = tab
            tab.Container.Visible = true
            tab.Icon.ImageColor3 = Accent
            tab.Text.TextColor3 = LightText
            tab.Button.BackgroundColor3 = ElementBg
            tab.Button.BackgroundTransparency = 0
            ContentTitle.Text = name:upper()
        end)

        Window.Tabs[name] = tab
        return tab
    end

    -- Функции для создания левой/правой колонки (секций)
    function Window:CreateLeftColumn(tab)
        local col = Instance.new("Frame")
        col.Size = UDim2.new(0.5, -15, 1, 0)
        col.Position = UDim2.new(0, 10, 0, 50)  -- увеличено с 35 до 50 (отступ сверху)
        col.BackgroundTransparency = 1
        col.Parent = tab.Container

        -- Добавляем UIPadding для отступов внутри карточки
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 10)
        padding.PaddingBottom = UDim.new(0, 10)
        padding.PaddingLeft = UDim.new(0, 15)
        padding.PaddingRight = UDim.new(0, 15)
        padding.Parent = col

        tab.LeftColumn = col
        return col
    end

    function Window:CreateRightColumn(tab)
        local col = Instance.new("Frame")
        col.Size = UDim2.new(0.5, -15, 1, 0)
        col.Position = UDim2.new(0.5, 5, 0, 50)  -- увеличено с 35 до 50
        col.BackgroundTransparency = 1
        col.Parent = tab.Container

        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 10)
        padding.PaddingBottom = UDim.new(0, 10)
        padding.PaddingLeft = UDim.new(0, 15)
        padding.PaddingRight = UDim.new(0, 15)
        padding.Parent = col

        tab.RightColumn = col
        return col
    end

    -- Заголовок колонки
    function Window:AddColumnTitle(parent, text)
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 25)
        title.BackgroundTransparency = 1
        title.Text = text
        title.TextColor3 = GreyText
        title.TextSize = 14
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = parent
        return title
    end

    -- Элементы управления
    function Window:CreateToggle(parent, title, default, callback)
        local y = (#parent:GetChildren() - 1) * 35 + 10
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 28)
        frame.Position = UDim2.new(0, 5, 0, y)
        frame.BackgroundColor3 = ElementBg
        frame.Parent = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = frame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -60, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = title
        label.TextColor3 = LightText
        label.TextSize = 13
        label.Font = Enum.Font.GothamMedium
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        -- Тумблер
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 40, 0, 20)
        btn.Position = UDim2.new(1, -55, 0.5, -10)
        btn.BackgroundColor3 = default and Accent or ToggleOff
        btn.Text = ""
        btn.Parent = frame

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(1, 0)
        btnCorner.Parent = btn

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 18, 0, 18)
        knob.Position = UDim2.new(0, default and 20 or 2, 0.5, -9)
        knob.BackgroundColor3 = LightText
        knob.Parent = btn

        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = knob

        local state = default
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.BackgroundColor3 = state and Accent or ToggleOff
            TweenService:Create(knob, TweenInfo.new(0.15), {Position = UDim2.new(0, state and 20 or 2, 0.5, -9)}):Play()
            callback(state)
        end)
        return frame
    end

    function Window:CreateSlider(parent, title, default, min, max, callback)
        local y = (#parent:GetChildren() - 1) * 35 + 10
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 28)
        frame.Position = UDim2.new(0, 5, 0, y)
        frame.BackgroundColor3 = ElementBg
        frame.Parent = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = frame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.3, -10, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = title
        label.TextColor3 = LightText
        label.TextSize = 13
        label.Font = Enum.Font.GothamMedium
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        -- Контейнер для слайдера
        local sliderContainer = Instance.new("Frame")
        sliderContainer.Size = UDim2.new(0.7, 30, 0, 4)
        sliderContainer.Position = UDim2.new(0.3, 0, 0.5, -2)
        sliderContainer.BackgroundTransparency = 1
        sliderContainer.Parent = frame

        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, -30, 0, 4)
        sliderBg.Position = UDim2.new(0, 0, 0, 0)
        sliderBg.BackgroundColor3 = ToggleOff
        sliderBg.Parent = sliderContainer

        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = Accent
        sliderFill.Parent = sliderBg

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 30, 1, 0)
        valueLabel.Position = UDim2.new(1, -30, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(default)
        valueLabel.TextColor3 = GreyText
        valueLabel.TextSize = 11
        valueLabel.Font = Enum.Font.Gotham
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = sliderContainer

        local dragging = false
        local sliderButton = Instance.new("TextButton")
        sliderButton.Size = UDim2.new(1, -30, 1, 0)
        sliderButton.BackgroundTransparency = 1
        sliderButton.Text = ""
        sliderButton.Parent = sliderBg

        local function updateSlider(input)
            local pos = input.Position.X - sliderBg.AbsolutePosition.X
            local width = sliderBg.AbsoluteSize.X
            local percent = math.clamp(pos / width, 0, 1)
            local value = math.floor(min + (max - min) * percent)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            valueLabel.Text = tostring(value)
            callback(value)
        end

        sliderButton.MouseButton1Down:Connect(function(input)
            dragging = true
            updateSlider(input)
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        return frame
    end

    function Window:CreateKeybind(parent, title, default, callback)
        local y = (#parent:GetChildren() - 1) * 35 + 10
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 28)
        frame.Position = UDim2.new(0, 5, 0, y)
        frame.BackgroundColor3 = ElementBg
        frame.Parent = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = frame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, -10, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = title
        label.TextColor3 = LightText
        label.TextSize = 13
        label.Font = Enum.Font.GothamMedium
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.4, -10, 0, 22)
        btn.Position = UDim2.new(0.6, 0, 0.5, -11)
        btn.BackgroundColor3 = DarkerBg
        btn.Text = default
        btn.TextColor3 = LightText
        btn.TextSize = 12
        btn.Font = Enum.Font.Gotham
        btn.Parent = frame

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = btn

        local picking = false
        btn.MouseButton1Click:Connect(function()
            picking = true
            btn.Text = "..."
            local connection
            connection = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    picking = false
                    local keyName = input.KeyCode.Name
                    btn.Text = keyName
                    callback(keyName)
                    connection:Disconnect()
                elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                    picking = false
                    local keyName = input.UserInputType == Enum.UserInputType.MouseButton1 and "LeftClick" or "RightClick"
                    btn.Text = keyName
                    callback(keyName)
                    connection:Disconnect()
                end
            end)
            task.delay(5, function()
                if picking then
                    picking = false
                    btn.Text = default
                    if connection then connection:Disconnect() end
                end
            end)
        end)
        return frame
    end

    function Window:CreateButton(parent, title, callback)
        local y = (#parent:GetChildren() - 1) * 35 + 10
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 28)
        frame.Position = UDim2.new(0, 5, 0, y)
        frame.BackgroundColor3 = ElementBg
        frame.Parent = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = frame

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 1, 0)
        btn.Position = UDim2.new(0, 10, 0, 0)
        btn.BackgroundColor3 = DarkerBg
        btn.Text = title
        btn.TextColor3 = LightText
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamMedium
        btn.Parent = frame

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = btn

        btn.MouseButton1Click:Connect(callback)
        return frame
    end

    -- Перетаскивание окна
    local dragging = false
    local dragOffset
    Sidebar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragOffset = Vector2.new(input.Position.X - MainFrame.AbsolutePosition.X, input.Position.Y - MainFrame.AbsolutePosition.Y)
            local moveConn = UserInputService.InputChanged:Connect(function(moveInput)
                if dragging and moveInput.UserInputType == Enum.UserInputType.MouseMovement then
                    MainFrame.Position = UDim2.new(0, moveInput.Position.X - dragOffset.X, 0, moveInput.Position.Y - dragOffset.Y)
                end
            end)
            local endConn = UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    moveConn:Disconnect()
                    endConn:Disconnect()
                end
            end)
        end
    end)

    -- Глобальная клавиша
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Window.ToggleKey then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    return Window
end

return ZenithLib
