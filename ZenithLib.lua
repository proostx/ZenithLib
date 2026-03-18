local ZenithLib = {}
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [ НАСТРОЙКИ ТЕМЫ ]
local Theme = {
    Main = Color3.fromRGB(20, 20, 22),
    Sidebar = Color3.fromRGB(15, 15, 17),
    Section = Color3.fromRGB(28, 28, 30),
    Accent = Color3.fromRGB(0, 85, 255), -- Тот самый синий
    Stroke = Color3.fromRGB(45, 45, 48),
    Text = Color3.fromRGB(255, 255, 255),
    TextSec = Color3.fromRGB(150, 150, 155),
    Tween = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
}

function ZenithLib:CreateWindow()
    local UI = Instance.new("ScreenGui", game:GetService("CoreGui"))
    UI.Name = "ZenithClient"

    local Main = Instance.new("Frame", UI)
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 680, 0, 440)
    Main.Position = UDim2.new(0.5, -340, 0.5, -220)
    Main.BackgroundColor3 = Theme.Main
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Theme.Stroke; MainStroke.Thickness = 1.5

    -- SIDEBAR
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 175, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

    -- ЛОГОТИП (С выделенной областью)
    local LogoArea = Instance.new("Frame", Sidebar)
    LogoArea.Size = UDim2.new(1, 0, 0, 80); LogoArea.BackgroundTransparency = 1
    
    local IconBox = Instance.new("Frame", LogoArea)
    IconBox.Size = UDim2.new(0, 38, 0, 38); IconBox.Position = UDim2.new(0, 15, 0.5, -19)
    IconBox.BackgroundColor3 = Theme.Accent; Instance.new("UICorner", IconBox).CornerRadius = UDim.new(0, 8)
    
    local LogoIcon = Instance.new("ImageLabel", IconBox)
    LogoIcon.Size = UDim2.new(0.7, 0, 0.7, 0); LogoIcon.Position = UDim2.new(0.15, 0, 0.15, 0)
    LogoIcon.BackgroundTransparency = 1
    LogoIcon.Image = "rbxassetid://0" -- ВСТАВЬ СВОЙ ID ТУТ
    
    local Title = Instance.new("TextLabel", LogoArea)
    Title.Text = "ZenithClient"; Title.Font = "GothamBold"; Title.TextSize = 18; Title.TextColor3 = Theme.Text; Title.Position = UDim2.new(0, 65, 0.5, -12); Title.BackgroundTransparency = 1; Title.TextXAlignment = 0
    local Sub = Instance.new("TextLabel", Title)
    Sub.Text = "Armored Patrol"; Sub.Font = "Gotham"; Sub.TextSize = 11; Sub.TextColor3 = Theme.TextSec; Sub.Position = UDim2.new(0, 0, 1, -2); Sub.BackgroundTransparency = 1; Sub.TextXAlignment = 0

    -- ТАБЫ (Контейнер)
    local TabScroll = Instance.new("ScrollingFrame", Sidebar)
    TabScroll.Position = UDim2.new(0, 0, 0, 90); TabScroll.Size = UDim2.new(1, 0, 1, -160); TabScroll.BackgroundTransparency = 1; TabScroll.ScrollBarThickness = 0
    local TabList = Instance.new("UIListLayout", TabScroll); TabList.Padding = UDim.new(0, 5); TabList.HorizontalAlignment = "Center"

    -- ПРОФИЛЬ
    local Profile = Instance.new("Frame", Sidebar)
    Profile.Size = UDim2.new(1, 0, 0, 60); Profile.Position = UDim2.new(0, 0, 1, -65); Profile.BackgroundTransparency = 1
    local Av = Instance.new("ImageLabel", Profile); Av.Size = UDim2.new(0, 38, 0, 38); Av.Position = UDim2.new(0, 15, 0.5, -19); Av.Image = "rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=150&h=150"; Instance.new("UICorner", Av).CornerRadius = UDim.new(1, 0)
    local Nick = Instance.new("TextLabel", Profile); Nick.Text = LocalPlayer.Name; Nick.Font = "GothamBold"; Nick.TextSize = 13; Nick.TextColor3 = Theme.Text; Nick.Position = UDim2.new(0, 62, 0.5, -10); Nick.BackgroundTransparency = 1; Nick.TextXAlignment = 0

    -- КОНТЕНТ (Главная область)
    local PageTitle = Instance.new("TextLabel", Main)
    PageTitle.Text = "Dashboard"; PageTitle.Font = "GothamBold"; PageTitle.TextSize = 22; PageTitle.TextColor3 = Theme.Text; PageTitle.Position = UDim2.new(0, 195, 0, 25); PageTitle.BackgroundTransparency = 1; PageTitle.TextXAlignment = 0

    local Pages = Instance.new("Frame", Main)
    Pages.Name = "Pages"; Pages.Position = UDim2.new(0, 195, 0, 70); Pages.Size = UDim2.new(1, -215, 1, -85); Pages.BackgroundTransparency = 1

    local Library = {Tabs = {}}

    function Library:CreateTab(name, iconId)
        local TabBtn = Instance.new("TextButton", TabScroll)
        TabBtn.Size = UDim2.new(0.9, 0, 0, 36); TabBtn.BackgroundColor3 = Theme.Accent; TabBtn.BackgroundTransparency = 1; TabBtn.Text = ""; Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
        
        local Txt = Instance.new("TextLabel", TabBtn)
        Txt.Size = UDim2.new(1, -40, 1, 0); Txt.Position = UDim2.new(0, 40, 0, 0); Txt.Text = name; Txt.Font = "GothamBold"; Txt.TextSize = 14; Txt.TextColor3 = Theme.TextSec; Txt.BackgroundTransparency = 1; Txt.TextXAlignment = 0
        
        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
        local Grid = Instance.new("UIGridLayout", Page); Grid.CellSize = UDim2.new(0.48, 0, 0, 380); Grid.CellPadding = UDim2.new(0.04, 0, 0, 15)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Pages:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabScroll:GetChildren()) do if v:IsA("TextButton") then v.BackgroundTransparency = 1; v.TextLabel.TextColor3 = Theme.TextSec end end
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0.9; Txt.TextColor3 = Theme.Accent
            PageTitle.Text = name
        end)

        local Tab = {}

        function Tab:CreateSection(secName)
            local Sec = Instance.new("Frame", Page)
            Sec.BackgroundColor3 = Theme.Section; Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 8)
            local sTitle = Instance.new("TextLabel", Sec); sTitle.Size = UDim2.new(1, 0, 0, 35); sTitle.Position = UDim2.new(0, 12, 0, 5); sTitle.Text = secName:upper(); sTitle.Font = "GothamBold"; sTitle.TextSize = 12; sTitle.TextColor3 = Theme.TextSec; sTitle.BackgroundTransparency = 1; sTitle.TextXAlignment = 0
            local List = Instance.new("UIListLayout", Sec); List.Padding = UDim.new(0, 4); Instance.new("UIPadding", Sec).PaddingTop = UDim.new(0, 40); List.HorizontalAlignment = "Center"
            
            local Items = {}

            -- TOGGLE (Исправленный с кружком)
            function Items:AddToggle(text, default, callback)
                local Tgl = Instance.new("TextButton", Sec)
                Tgl.Size = UDim2.new(0.92, 0, 0, 32); Tgl.BackgroundTransparency = 1; Tgl.Text = ""
                local L = Instance.new("TextLabel", Tgl); L.Size = UDim2.new(1, -50, 1, 0); L.Position = UDim2.new(0, 5, 0, 0); L.Text = text; L.Font = "GothamMedium"; L.TextSize = 14; L.TextColor3 = Theme.TextSec; L.BackgroundTransparency = 1; L.TextXAlignment = 0
                
                local Sw = Instance.new("Frame", Tgl); Sw.Size = UDim2.new(0, 38, 0, 20); Sw.Position = UDim2.new(1, -40, 0.5, -10); Sw.BackgroundColor3 = default and Theme.Accent or Color3.fromRGB(50, 50, 52); Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)
                local Circ = Instance.new("Frame", Sw); Circ.Size = UDim2.new(0, 14, 0, 14); Circ.Position = default and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7); Circ.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", Circ).CornerRadius = UDim.new(1, 0)
                
                local state = default
                Tgl.MouseButton1Click:Connect(function()
                    state = not state
                    callback(state)
                    TS:Create(Sw, Theme.Tween, {BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(50, 50, 52)}):Play()
                    TS:Create(Circ, Theme.Tween, {Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}):Play()
                end)
            end

            -- SLIDER (С плотным заполнением)
            function Items:AddSlider(text, min, max, default, callback)
                local Sld = Instance.new("Frame", Sec); Sld.Size = UDim2.new(0.92, 0, 0, 45); Sld.BackgroundTransparency = 1
                local L = Instance.new("TextLabel", Sld); L.Size = UDim2.new(1, 0, 0, 20); L.Text = text..": "..default; L.Font = "GothamMedium"; L.TextSize = 13; L.TextColor3 = Theme.TextSec; L.BackgroundTransparency = 1; L.TextXAlignment = 0
                local Bar = Instance.new("TextButton", Sld); Bar.Size = UDim2.new(1, 0, 0, 5); Bar.Position = UDim2.new(0, 0, 0, 30); Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 52); Bar.Text = ""; Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)
                local Fill = Instance.new("Frame", Bar); Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); Fill.BackgroundColor3 = Theme.Accent; Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
                
                Bar.MouseButton1Down:Connect(function()
                    local move; move = UIS.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                            Fill.Size = UDim2.new(pos, 0, 1, 0)
                            local val = math.floor(min + (max - min) * pos)
                            L.Text = text..": "..val; callback(val)
                        end
                    end)
                    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end end)
                end)
            end

            return Items
        end
        return Tab
    end
    return Library
end

return ZenithLib
