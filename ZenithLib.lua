local ZenithLib = {}
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [ НАСТРОЙКИ ТЕМЫ ]
local Theme = {
    Main = Color3.fromRGB(20, 20, 22),
    Sidebar = Color3.fromRGB(15, 15, 17),
    Section = Color3.fromRGB(28, 28, 30),
    Accent = Color3.fromRGB(0, 85, 255), -- ТЕМНО-СИНИЙ
    Stroke = Color3.fromRGB(45, 45, 48),
    Text = Color3.fromRGB(255, 255, 255),
    TextSec = Color3.fromRGB(140, 140, 145),
    Tween = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
}

function ZenithLib:CreateWindow()
    local UI = Instance.new("ScreenGui", game:GetService("CoreGui"))
    UI.Name = "ZenithClient"

    local Main = Instance.new("Frame", UI)
    Main.Size = UDim2.new(0, 680, 0, 430)
    Main.Position = UDim2.new(0.5, -340, 0.5, -215)
    Main.BackgroundColor3 = Theme.Main
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", Main).Color = Theme.Stroke

    -- SIDEBAR
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 170, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

    -- LOGO AREA
    local LogoArea = Instance.new("Frame", Sidebar)
    LogoArea.Size = UDim2.new(1, 0, 0, 80); LogoArea.BackgroundTransparency = 1
    
    local IconBox = Instance.new("Frame", LogoArea)
    IconBox.Size = UDim2.new(0, 38, 0, 38); IconBox.Position = UDim2.new(0, 15, 0.5, -19)
    IconBox.BackgroundColor3 = Theme.Accent; Instance.new("UICorner", IconBox).CornerRadius = UDim.new(0, 8)
    
    local LogoIcon = Instance.new("ImageLabel", IconBox)
    LogoIcon.Size = UDim2.new(0.75, 0, 0.75, 0); LogoIcon.Position = UDim2.new(0.12, 0, 0.12, 0)
    LogoIcon.BackgroundTransparency = 1
    LogoIcon.Image = "rbxassetid://0" -- СЮДА СВОЙ ID ЛОГОТИПА
    
    local Title = Instance.new("TextLabel", LogoArea)
    Title.Text = "ZenithClient"; Title.Font = "GothamBold"; Title.TextSize = 18; Title.TextColor3 = Theme.Text; Title.Position = UDim2.new(0, 65, 0.5, -12); Title.BackgroundTransparency = 1; Title.TextXAlignment = 0
    local Sub = Instance.new("TextLabel", Title)
    Sub.Text = "Armored Patrol"; Sub.Font = "Gotham"; Sub.TextSize = 11; Sub.TextColor3 = Theme.TextSec; Sub.Position = UDim2.new(0, 0, 1, -2); Sub.BackgroundTransparency = 1; Sub.TextXAlignment = 0

    -- TAB CONTAINER
    local TabScroll = Instance.new("ScrollingFrame", Sidebar)
    TabScroll.Position = UDim2.new(0, 0, 0, 90); TabScroll.Size = UDim2.new(1, 0, 1, -160); TabScroll.BackgroundTransparency = 1; TabScroll.ScrollBarThickness = 0
    local TabList = Instance.new("UIListLayout", TabScroll); TabList.Padding = UDim.new(0, 5); TabList.HorizontalAlignment = "Center"

    -- PROFILE
    local Profile = Instance.new("Frame", Sidebar)
    Profile.Size = UDim2.new(1, 0, 0, 60); Profile.Position = UDim2.new(0, 0, 1, -65); Profile.BackgroundTransparency = 1
    local Av = Instance.new("ImageLabel", Profile); Av.Size = UDim2.new(0, 38, 0, 38); Av.Position = UDim2.new(0, 15, 0.5, -19); Av.Image = "rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=150&h=150"; Instance.new("UICorner", Av).CornerRadius = UDim.new(1, 0)
    local Nick = Instance.new("TextLabel", Profile); Nick.Text = LocalPlayer.Name; Nick.Font = "GothamBold"; Nick.TextSize = 13; Nick.TextColor3 = Theme.Text; Nick.Position = UDim2.new(0, 62, 0.5, -10); Nick.BackgroundTransparency = 1; Nick.TextXAlignment = 0

    -- CONTENT AREA
    local Pages = Instance.new("Frame", Main)
    Pages.Position = UDim2.new(0, 195, 0, 70); Pages.Size = UDim2.new(1, -215, 1, -85); Pages.BackgroundTransparency = 1

    local PageTitle = Instance.new("TextLabel", Main)
    PageTitle.Text = "Dashboard"; PageTitle.Font = "GothamBold"; PageTitle.TextSize = 22; PageTitle.TextColor3 = Theme.Text; PageTitle.Position = UDim2.new(0, 195, 0, 25); PageTitle.BackgroundTransparency = 1; PageTitle.TextXAlignment = 0

    local Lib = {}

    function Lib:CreateTab(name, iconId)
        local TabBtn = Instance.new("TextButton", TabScroll)
        TabBtn.Size = UDim2.new(0.9, 0, 0, 36); TabBtn.BackgroundTransparency = 1; TabBtn.Text = ""; Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
        
        local Ico = Instance.new("ImageLabel", TabBtn)
        Ico.Size = UDim2.new(0, 18, 0, 18); Ico.Position = UDim2.new(0, 12, 0.5, -9); Ico.BackgroundTransparency = 1; Ico.Image = iconId or ""; Ico.ImageColor3 = Theme.TextSec
        
        local Txt = Instance.new("TextLabel", TabBtn)
        Txt.Size = UDim2.new(1, -40, 1, 0); Txt.Position = UDim2.new(0, 40, 0, 0); Txt.Text = name; Txt.Font = "GothamBold"; Txt.TextSize = 14; Txt.TextColor3 = Theme.TextSec; Txt.BackgroundTransparency = 1; Txt.TextXAlignment = 0
        
        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
        local Grid = Instance.new("UIGridLayout", Page); Grid.CellSize = UDim2.new(0.48, 0, 0, 350); Grid.CellPadding = UDim2.new(0.04, 0, 0, 15)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Pages:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabScroll:GetChildren()) do if v:IsA("TextButton") then v.BackgroundTransparency = 1; v.TextLabel.TextColor3 = Theme.TextSec; v.ImageLabel.ImageColor3 = Theme.TextSec end end
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0.9; Txt.TextColor3 = Theme.Accent; Ico.ImageColor3 = Theme.Accent
            PageTitle.Text = name
        end)

        local Tab = {}

        function Tab:CreateSection(secName)
            local Sec = Instance.new("Frame", Page)
            Sec.BackgroundColor3 = Theme.Section; Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 8)
            local Title = Instance.new("TextLabel", Sec); Title.Size = UDim2.new(1, 0, 0, 35); Title.Position = UDim2.new(0, 12, 0, 5); Title.Text = secName:upper(); Title.Font = "GothamBold"; Title.TextSize = 12; Title.TextColor3 = Theme.TextSec; Title.BackgroundTransparency = 1; Title.TextXAlignment = 0
            local List = Instance.new("UIListLayout", Sec); List.Padding = UDim.new(0, 4); Instance.new("UIPadding", Sec).PaddingTop = UDim.new(0, 40); List.HorizontalAlignment = "Center"
            
            local Items = {}

            function Items:AddToggle(text, default, callback)
                local Tgl = Instance.new("TextButton", Sec)
                Tgl.Size = UDim2.new(0.92, 0, 0, 32); Tgl.BackgroundTransparency = 1; Tgl.Text = ""
                local L = Instance.new("TextLabel", Tgl); L.Size = UDim2.new(1, -50, 1, 0); L.Position = UDim2.new(0, 5, 0, 0); L.Text = text; L.Font = "GothamMedium"; L.TextSize = 13; L.TextColor3 = Theme.TextSec; L.BackgroundTransparency = 1; L.TextXAlignment = 0
                
                local Sw = Instance.new("Frame", Tgl); Sw.Size = UDim2.new(0, 36, 0, 18); Sw.Position = UDim2.new(1, -40, 0.5, -9); Sw.BackgroundColor3 = default and Theme.Accent or Color3.fromRGB(55, 55, 57); Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)
                local Circ = Instance.new("Frame", Sw); Circ.Size = UDim2.new(0, 14, 0, 14); Circ.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7); Circ.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", Circ).CornerRadius = UDim.new(1, 0)
                
                Tgl.MouseButton1Click:Connect(function()
                    default = not default; callback(default)
                    TS:Create(Sw, Theme.Tween, {BackgroundColor3 = default and Theme.Accent or Color3.fromRGB(55, 55, 57)}):Play()
                    TS:Create(Circ, Theme.Tween, {Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
                end)
            end

            function Items:AddSlider(text, min, max, default, callback)
                local Sld = Instance.new("Frame", Sec); Sld.Size = UDim2.new(0.92, 0, 0, 45); Sld.BackgroundTransparency = 1
                local L = Instance.new("TextLabel", Sld); L.Size = UDim2.new(1, 0, 0, 20); L.Text = text..": "..default; L.Font = "GothamMedium"; L.TextSize = 12; L.TextColor3 = Theme.TextSec; L.BackgroundTransparency = 1; L.TextXAlignment = 0
                local Bar = Instance.new("TextButton", Sld); Bar.Size = UDim2.new(1, 0, 0, 5); Bar.Position = UDim2.new(0, 0, 0, 30); Bar.BackgroundColor3 = Color3.fromRGB(55, 55, 57); Bar.Text = ""; Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)
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
    return Lib
end

return ZenithLib
