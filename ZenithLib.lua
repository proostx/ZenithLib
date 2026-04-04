local ZenithClassic = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local THEME = {
	Window = Color3.fromRGB(24, 24, 24),
	Window2 = Color3.fromRGB(28, 28, 28),
	Panel = Color3.fromRGB(31, 31, 31),
	Group = Color3.fromRGB(33, 33, 33),
	Control = Color3.fromRGB(38, 38, 38),
	Control2 = Color3.fromRGB(26, 26, 26),
	Stroke = Color3.fromRGB(62, 62, 62),
	StrokeSoft = Color3.fromRGB(48, 48, 48),
	Text = Color3.fromRGB(235, 235, 235),
	SubText = Color3.fromRGB(185, 185, 185),
	Accent = Color3.fromRGB(68, 255, 220),
	Accent2 = Color3.fromRGB(110, 255, 235),
	Dark = Color3.fromRGB(17, 17, 17),
	Tab = Color3.fromRGB(22, 22, 22),
	TabActive = Color3.fromRGB(40, 40, 40),
}

local function tween(obj, time, props, style, dir)
	local t = TweenService:Create(
		obj,
		TweenInfo.new(time or 0.15, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
		props
	)
	t:Play()
	return t
end

local function create(className, props, children)
	local obj = Instance.new(className)
	for k, v in pairs(props or {}) do
		obj[k] = v
	end
	for _, child in ipairs(children or {}) do
		child.Parent = obj
	end
	return obj
end

local function stroke(parent, color, thickness, transparency)
	return create("UIStroke", {
		Color = color or THEME.Stroke,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = parent
	})
end

local function corner(parent, radius)
	return create("UICorner", {
		CornerRadius = UDim.new(0, radius or 4),
		Parent = parent
	})
end

local function pad(parent, l, r, t, b)
	return create("UIPadding", {
		PaddingLeft = UDim.new(0, l or 0),
		PaddingRight = UDim.new(0, r or 0),
		PaddingTop = UDim.new(0, t or 0),
		PaddingBottom = UDim.new(0, b or 0),
		Parent = parent
	})
end

local function makeDraggable(handle, root)
	local dragging = false
	local dragStart
	local startPos

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = root.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			root.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

local function shortKeyName(key)
	if not key then
		return "None"
	end

	local map = {
		RightShift = "RShift",
		LeftShift = "LShift",
		RightControl = "RCtrl",
		LeftControl = "LCtrl",
		Backspace = "Back",
		Return = "Enter",
		MouseButton1 = "M1",
		MouseButton2 = "M2",
		MouseButton3 = "M3",
	}

	return map[key.Name] or key.Name
end

function ZenithClassic:CreateWindow(cfg)
	cfg = cfg or {}

	local gui = create("ScreenGui", {
		Name = cfg.Name or "ZenithLibClassic",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = LocalPlayer:WaitForChild("PlayerGui")
	})

	local root = create("Frame", {
		Name = "Root",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(560, 560),
		BackgroundColor3 = THEME.Window,
		BorderSizePixel = 0,
		Parent = gui
	})
	stroke(root, Color3.fromRGB(80, 80, 80), 1, 0)
	corner(root, 2)

	create("Frame", {
		Name = "OuterAccent",
		Position = UDim2.fromOffset(1, 1),
		Size = UDim2.new(1, -2, 0, 1),
		BackgroundColor3 = THEME.Accent,
		BorderSizePixel = 0,
		Parent = root
	})

	local inner = create("Frame", {
		Name = "Inner",
		Position = UDim2.fromOffset(6, 6),
		Size = UDim2.new(1, -12, 1, -12),
		BackgroundColor3 = THEME.Window2,
		BorderSizePixel = 0,
		Parent = root
	})
	stroke(inner, THEME.StrokeSoft, 1, 0)
	corner(inner, 2)

	local titleBar = create("Frame", {
		Name = "TitleBar",
		Position = UDim2.fromOffset(10, 10),
		Size = UDim2.new(1, -20, 0, 18),
		BackgroundTransparency = 1,
		Parent = inner
	})

	create("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -60, 1, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = cfg.Title or "ZenithLib Classic",
		TextColor3 = THEME.Text,
		TextSize = 14,
		Font = Enum.Font.Code,
		Parent = titleBar
	})

	local close = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.fromOffset(18, 18),
		BackgroundColor3 = THEME.Control2,
		Text = "×",
		TextColor3 = THEME.Text,
		TextSize = 14,
		Font = Enum.Font.Code,
		AutoButtonColor = false,
		Parent = titleBar
	})
	stroke(close, THEME.StrokeSoft, 1, 0)
	corner(close, 2)

	local tabBar = create("Frame", {
		Name = "TabBar",
		Position = UDim2.fromOffset(10, 34),
		Size = UDim2.new(1, -20, 0, 24),
		BackgroundColor3 = THEME.Tab,
		BorderSizePixel = 0,
		Parent = inner
	})
	stroke(tabBar, THEME.StrokeSoft, 1, 0)
	corner(tabBar, 2)
	pad(tabBar, 4, 4, 2, 2)

	create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 4),
		Parent = tabBar
	})

	local content = create("Frame", {
		Name = "Content",
		Position = UDim2.fromOffset(10, 64),
		Size = UDim2.new(1, -20, 1, -74),
		BackgroundColor3 = THEME.Dark,
		BorderSizePixel = 0,
		Parent = inner
	})
	stroke(content, THEME.StrokeSoft, 1, 0)
	corner(content, 2)

	local pages = create("Folder", {
		Name = "Pages",
		Parent = content
	})

	makeDraggable(titleBar, root)

	local window = {
		_Gui = gui,
		_Root = root,
		_Tabs = {},
		_Pages = {},
		_Current = nil,
	}

	close.MouseEnter:Connect(function()
		tween(close, 0.12, {BackgroundColor3 = Color3.fromRGB(55, 35, 35)})
	end)

	close.MouseLeave:Connect(function()
		tween(close, 0.12, {BackgroundColor3 = THEME.Control2})
	end)

	close.MouseButton1Click:Connect(function()
		gui:Destroy()
	end)

	function window:SelectTab(name)
		for tabName, tabData in pairs(self._Tabs) do
			local active = tabName == name
			tabData.Button.BackgroundColor3 = active and THEME.TabActive or THEME.Tab
			tabData.Button.TextColor3 = active and THEME.Text or THEME.SubText

			if active then
				tabData.Accent.Visible = true
				tabData.Accent.Size = UDim2.new(0, 0, 0, 1)
				tween(tabData.Accent, 0.16, {
					Size = UDim2.new(1, -2, 0, 1)
				}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			else
				tween(tabData.Accent, 0.12, {
					Size = UDim2.new(0, 0, 0, 1)
				}, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			end

			if self._Pages[tabName] then
				self._Pages[tabName].Visible = active
			end
		end

		self._Current = name
	end

	function window:AddTab(name)
		local tabButton = create("TextButton", {
			Name = name,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = THEME.Tab,
			Text = name,
			TextColor3 = THEME.SubText,
			TextSize = 13,
			Font = Enum.Font.Code,
			AutoButtonColor = false,
			Parent = tabBar
		})
		pad(tabButton, 8, 8, 0, 0)
		stroke(tabButton, THEME.StrokeSoft, 1, 0)
		corner(tabButton, 2)

		local tabAccent = create("Frame", {
			Name = "Accent",
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 1, -2),
			Size = UDim2.new(0, 0, 0, 1),
			BackgroundColor3 = THEME.Accent,
			BorderSizePixel = 0,
			Visible = true,
			Parent = tabButton
		})

		local page = create("Frame", {
			Name = name .. "_Page",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Visible = false,
			Parent = pages
		})

		local left = create("ScrollingFrame", {
			Name = "Left",
			Position = UDim2.fromOffset(8, 8),
			Size = UDim2.new(0.5, -12, 1, -16),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			CanvasSize = UDim2.fromOffset(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = THEME.Accent,
			Parent = page
		})

		local right = create("ScrollingFrame", {
			Name = "Right",
			Position = UDim2.new(0.5, 4, 0, 8),
			Size = UDim2.new(0.5, -12, 1, -16),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			CanvasSize = UDim2.fromOffset(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = THEME.Accent,
			Parent = page
		})

		local leftLayout = create("UIListLayout", {
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = left
		})

		local rightLayout = create("UIListLayout", {
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = right
		})

		leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			left.CanvasSize = UDim2.fromOffset(0, leftLayout.AbsoluteContentSize.Y + 4)
		end)

		rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			right.CanvasSize = UDim2.fromOffset(0, rightLayout.AbsoluteContentSize.Y + 4)
		end)

		tabButton.MouseEnter:Connect(function()
			if window._Current ~= name then
				tween(tabButton, 0.12, {BackgroundColor3 = THEME.Control})
			end
		end)

		tabButton.MouseLeave:Connect(function()
			if window._Current ~= name then
				tween(tabButton, 0.12, {BackgroundColor3 = THEME.Tab})
			end
		end)

		tabButton.MouseButton1Click:Connect(function()
			window:SelectTab(name)
		end)

		window._Tabs[name] = {
			Button = tabButton,
			Accent = tabAccent,
		}
		window._Pages[name] = page

		if not window._Current then
			window:SelectTab(name)
		end

		local tabApi = {}

		local function makeGroupbox(parentColumn, titleText)
			local group = create("Frame", {
				Name = titleText,
				Size = UDim2.new(1, 0, 0, 120),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = THEME.Group,
				BorderSizePixel = 0,
				Parent = parentColumn
			})
			stroke(group, THEME.StrokeSoft, 1, 0)
			corner(group, 2)

			local header = create("Frame", {
				Position = UDim2.fromOffset(0, 0),
				Size = UDim2.new(1, 0, 0, 18),
				BackgroundColor3 = THEME.Window2,
				BorderSizePixel = 0,
				Parent = group
			})
			corner(header, 2)

			create("Frame", {
				Position = UDim2.fromOffset(1, 1),
				Size = UDim2.new(1, -2, 0, 1),
				BackgroundColor3 = THEME.Accent,
				BorderSizePixel = 0,
				Parent = header
			})

			create("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(6, 1),
				Size = UDim2.new(1, -12, 1, -2),
				Text = titleText,
				TextColor3 = THEME.Text,
				TextSize = 13,
				Font = Enum.Font.Code,
				TextXAlignment = Enum.TextXAlignment.Center,
				Parent = header
			})

			local body = create("Frame", {
				Position = UDim2.fromOffset(6, 22),
				Size = UDim2.new(1, -12, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Parent = group
			})

			local bodyLayout = create("UIListLayout", {
				Padding = UDim.new(0, 5),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = body
			})

			bodyLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				group.Size = UDim2.new(1, 0, 0, bodyLayout.AbsoluteContentSize.Y + 28)
			end)

			local groupApi = {}

			function groupApi:AddLabel(text)
				return create("TextLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 14),
					Text = text or "Label",
					TextColor3 = THEME.SubText,
					TextSize = 12,
					Font = Enum.Font.Code,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = body
				})
			end

			function groupApi:AddDivider(text)
				local holder = create("Frame", {
					Size = UDim2.new(1, 0, 0, 12),
					BackgroundTransparency = 1,
					Parent = body
				})

				create("Frame", {
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = UDim2.new(0.35, 0, 0, 1),
					BackgroundColor3 = THEME.Stroke,
					BorderSizePixel = 0,
					Parent = holder
				})

				create("Frame", {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.new(0.35, 0, 0, 1),
					BackgroundColor3 = THEME.Stroke,
					BorderSizePixel = 0,
					Parent = holder
				})

				create("TextLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(80, 12),
					BackgroundTransparency = 1,
					Text = text or "",
					TextColor3 = THEME.SubText,
					TextSize = 11,
					Font = Enum.Font.Code,
					Parent = holder
				})

				return holder
			end

			function groupApi:AddToggle(name, opt)
				opt = opt or {}
				local value = opt.Default or false

				local holder = create("Frame", {
					Size = UDim2.new(1, 0, 0, 16),
					BackgroundTransparency = 1,
					Parent = body
				})

				local box = create("TextButton", {
					Position = UDim2.fromOffset(0, 1),
					Size = UDim2.fromOffset(12, 12),
					BackgroundColor3 = THEME.Control2,
					Text = "",
					AutoButtonColor = false,
					ClipsDescendants = true,
					Parent = holder
				})
				local boxStroke = stroke(box, THEME.StrokeSoft, 1, 0)
				corner(box, 1)

				local innerFill = create("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(0, 0),
					BackgroundColor3 = THEME.Accent,
					BorderSizePixel = 0,
					Parent = box
				})
				corner(innerFill, 1)

				local flash = create("Frame", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = THEME.Accent2,
					BackgroundTransparency = 1,
					Parent = box
				})
				corner(flash, 1)

				create("TextLabel", {
					Position = UDim2.fromOffset(18, 0),
					Size = UDim2.new(1, -18, 1, 0),
					BackgroundTransparency = 1,
					Text = name,
					TextColor3 = THEME.Text,
					TextSize = 12,
					Font = Enum.Font.Code,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = holder
				})

				local function render(animated)
					if value then
						if animated then
							box.Size = UDim2.fromOffset(10, 10)
							tween(box, 0.08, {Size = UDim2.fromOffset(12, 12)})
							tween(innerFill, 0.12, {Size = UDim2.fromOffset(10, 10)})
							tween(boxStroke, 0.12, {Color = THEME.Accent2})
							flash.BackgroundTransparency = 0.45
							task.delay(0.03, function()
								if flash and flash.Parent then
									tween(flash, 0.16, {BackgroundTransparency = 1})
								end
							end)
						else
							innerFill.Size = UDim2.fromOffset(10, 10)
							boxStroke.Color = THEME.Accent2
						end
					else
						if animated then
							box.Size = UDim2.fromOffset(10, 10)
							tween(box, 0.08, {Size = UDim2.fromOffset(12, 12)})
							tween(innerFill, 0.1, {Size = UDim2.fromOffset(0, 0)})
							tween(boxStroke, 0.12, {Color = THEME.StrokeSoft})
						else
							innerFill.Size = UDim2.fromOffset(0, 0)
							boxStroke.Color = THEME.StrokeSoft
						end
					end
				end

				box.MouseButton1Click:Connect(function()
					value = not value
					render(true)
					if opt.Callback then
						opt.Callback(value)
					end
				end)

				box.MouseEnter:Connect(function()
					if not value then
						tween(box, 0.08, {BackgroundColor3 = THEME.Control})
					end
				end)

				box.MouseLeave:Connect(function()
					if not value then
						tween(box, 0.08, {BackgroundColor3 = THEME.Control2})
					end
				end)

				local apiObj = {}

				function apiObj:Set(state)
					value = state
					render(true)
					if opt.Callback then
						opt.Callback(value)
					end
				end

				function apiObj:Get()
					return value
				end

				render(false)
				return apiObj
			end

			function groupApi:AddSlider(name, opt)
				opt = opt or {}
				local min = opt.Min or 0
				local max = opt.Max or 100
				local value = opt.Default or min
				local dragging = false

				local holder = create("Frame", {
					Size = UDim2.new(1, 0, 0, 34),
					BackgroundTransparency = 1,
					Parent = body
				})

				create("TextLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 12),
					Text = name,
					TextColor3 = THEME.Text,
					TextSize = 12,
					Font = Enum.Font.Code,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = holder
				})

				local box = create("Frame", {
					Position = UDim2.fromOffset(0, 16),
					Size = UDim2.new(1, 0, 0, 14),
					BackgroundColor3 = THEME.Control2,
					BorderSizePixel = 0,
					ClipsDescendants = true,
					Parent = holder
				})
				stroke(box, THEME.StrokeSoft, 1, 0)
				corner(box, 1)

				local fill = create("Frame", {
					Position = UDim2.fromOffset(1, 1),
					Size = UDim2.new((value - min) / math.max(max - min, 1), -2, 1, -2),
					BackgroundColor3 = THEME.Accent,
					BorderSizePixel = 0,
					Parent = box
				})
				corner(fill, 1)

				local cap = create("Frame", {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -1, 0.5, 0),
					Size = UDim2.fromOffset(2, 10),
					BackgroundColor3 = THEME.Accent2,
					BorderSizePixel = 0,
					Parent = fill
				})
				corner(cap, 1)

				local capPulse = create("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(2, 10),
					BackgroundColor3 = THEME.Accent2,
					BackgroundTransparency = 0.35,
					Parent = cap
				})
				corner(capPulse, 1)

				local valueLabel = create("TextLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text = string.format("%s/%s", tostring(value), tostring(max)),
					TextColor3 = THEME.Text,
					TextSize = 11,
					Font = Enum.Font.Code,
					Parent = box
				})

				local function animatePulse()
					capPulse.Size = UDim2.fromOffset(2, 10)
					capPulse.BackgroundTransparency = 0.35
					tween(capPulse, 0.12, {
						Size = UDim2.fromOffset(6, 12),
						BackgroundTransparency = 1
					}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				end

				local function setPercent(p, animated)
					p = math.clamp(p, 0, 1)
					value = math.floor(min + (max - min) * p + 0.5)
					valueLabel.Text = string.format("%s/%s", tostring(value), tostring(max))

					if animated then
						tween(fill, 0.08, {
							Size = UDim2.new(p, -2, 1, -2)
						}, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
						animatePulse()
					else
						fill.Size = UDim2.new(p, -2, 1, -2)
					end

					if opt.Callback then
						opt.Callback(value)
					end
				end

				local function updateX(x)
					local p = (x - box.AbsolutePosition.X) / box.AbsoluteSize.X
					setPercent(p, true)
				end

				box.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = true
						updateX(UserInputService:GetMouseLocation().X)
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						updateX(UserInputService:GetMouseLocation().X)
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
					end
				end)

				local apiObj = {}

				function apiObj:Set(v)
					local p = (v - min) / math.max(max - min, 1)
					setPercent(p, true)
				end

				function apiObj:Get()
					return value
				end

				setPercent((value - min) / math.max(max - min, 1), false)
				return apiObj
			end

			function groupApi:AddDropdown(name, opt)
				opt = opt or {}
				local items = opt.Items or {"Option 1", "Option 2"}
				local value = opt.Default or items[1]
				local open = false

				local holder = create("Frame", {
					Size = UDim2.new(1, 0, 0, 16),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Parent = body
				})

				create("TextLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 12),
					Text = name,
					TextColor3 = THEME.Text,
					TextSize = 12,
					Font = Enum.Font.Code,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = holder
				})

				local button = create("TextButton", {
					Position = UDim2.fromOffset(0, 14),
					Size = UDim2.new(1, 0, 0, 18),
					BackgroundColor3 = THEME.Control2,
					Text = "",
					AutoButtonColor = false,
					Parent = holder
				})
				stroke(button, THEME.StrokeSoft, 1, 0)
				corner(button, 1)

				local valueText = create("TextLabel", {
					Position = UDim2.fromOffset(5, 0),
					Size = UDim2.new(1, -20, 1, 0),
					BackgroundTransparency = 1,
					Text = tostring(value),
					TextColor3 = THEME.Text,
					TextSize = 12,
					Font = Enum.Font.Code,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = button
				})

				local arrow = create("TextLabel", {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -4, 0.5, 0),
					Size = UDim2.fromOffset(10, 10),
					BackgroundTransparency = 1,
					Text = "▼",
					TextColor3 = THEME.SubText,
					TextSize = 9,
					Font = Enum.Font.Code,
					Parent = button
				})

				local listFrame = create("Frame", {
					Position = UDim2.fromOffset(0, 35),
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = THEME.Control2,
					Visible = false,
					Parent = holder
				})
				stroke(listFrame, THEME.StrokeSoft, 1, 0)
				corner(listFrame, 1)
				pad(listFrame, 2, 2, 2, 2)

				create("UIListLayout", {
					Padding = UDim.new(0, 2),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = listFrame
				})

				for _, item in ipairs(items) do
					local option = create("TextButton", {
						Size = UDim2.new(1, 0, 0, 16),
						BackgroundColor3 = THEME.Control,
						Text = tostring(item),
						TextColor3 = THEME.Text,
						TextSize = 12,
						Font = Enum.Font.Code,
						AutoButtonColor = false,
						Parent = listFrame
					})
					stroke(option, THEME.StrokeSoft, 1, 0)
					corner(option, 1)

					option.MouseEnter:Connect(function()
						tween(option, 0.1, {BackgroundColor3 = Color3.fromRGB(44, 44, 44)})
					end)

					option.MouseLeave:Connect(function()
						tween(option, 0.1, {BackgroundColor3 = THEME.Control})
					end)

					option.MouseButton1Click:Connect(function()
						value = item
						valueText.Text = tostring(value)
						open = false
						listFrame.Visible = false
						arrow.Text = "▼"
						if opt.Callback then
							opt.Callback(value)
						end
					end)
				end

				button.MouseButton1Click:Connect(function()
					open = not open
					listFrame.Visible = open
					arrow.Text = open and "▲" or "▼"
				end)

				local apiObj = {}

				function apiObj:Set(v)
					value = v
					valueText.Text = tostring(v)
					if opt.Callback then
						opt.Callback(value)
					end
				end

				function apiObj:Get()
					return value
				end

				return apiObj
			end

			function groupApi:AddKeybind(name, opt)
				opt = opt or {}
				local current = opt.Default
				local listening = false
				local inputConn

				local holder = create("Frame", {
					Size = UDim2.new(1, 0, 0, 16),
					BackgroundTransparency = 1,
					Parent = body
				})

				create("TextLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -72, 1, 0),
					Text = name,
					TextColor3 = THEME.Text,
					TextSize = 12,
					Font = Enum.Font.Code,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = holder
				})

				local button = create("TextButton", {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.fromOffset(68, 16),
					BackgroundColor3 = THEME.Control2,
					Text = shortKeyName(current),
					TextColor3 = THEME.Text,
					TextSize = 11,
					Font = Enum.Font.Code,
					AutoButtonColor = false,
					ClipsDescendants = true,
					Parent = holder
				})
				local buttonStroke = stroke(button, THEME.StrokeSoft, 1, 0)
				corner(button, 1)

				local overlay = create("Frame", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = THEME.Accent,
					BackgroundTransparency = 1,
					Parent = button
				})
				corner(overlay, 1)

				local pulse = create("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundColor3 = THEME.Accent2,
					BackgroundTransparency = 0.85,
					Parent = button
				})
				corner(pulse, 1)

				local function successFlash()
					overlay.BackgroundTransparency = 0.55
					tween(overlay, 0.16, {BackgroundTransparency = 1})
				end

				local function render(animated)
					button.Text = listening and "..." or shortKeyName(current)

					if listening then
						if animated then
							tween(button, 0.12, {BackgroundColor3 = Color3.fromRGB(42, 54, 54)})
							tween(buttonStroke, 0.12, {Color = THEME.Accent2})
						else
							button.BackgroundColor3 = Color3.fromRGB(42, 54, 54)
							buttonStroke.Color = THEME.Accent2
						end
					else
						if animated then
							tween(button, 0.12, {BackgroundColor3 = THEME.Control2})
							tween(buttonStroke, 0.12, {Color = THEME.StrokeSoft})
						else
							button.BackgroundColor3 = THEME.Control2
							buttonStroke.Color = THEME.StrokeSoft
						end
					end
				end

				local pulseThread = nil

				local function startPulse()
					if pulseThread then
						return
					end

					pulseThread = task.spawn(function()
						while listening and button.Parent do
							pulse.Size = UDim2.new(0, 0, 1, 0)
							pulse.BackgroundTransparency = 0.78
							tween(pulse, 0.22, {
								Size = UDim2.new(1, 0, 1, 0),
								BackgroundTransparency = 1
							}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
							task.wait(0.24)
						end
						pulseThread = nil
					end)
				end

				local function stop()
					listening = false
					if inputConn then
						inputConn:Disconnect()
						inputConn = nil
					end
					render(true)
				end

				button.MouseButton1Click:Connect(function()
					if listening then
						stop()
						return
					end

					listening = true
					render(true)
					startPulse()

					inputConn = UserInputService.InputBegan:Connect(function(input, gp)
						if gp then
							return
						end

						if input.UserInputType == Enum.UserInputType.Keyboard then
							if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Escape then
								current = nil
							else
								current = input.KeyCode
							end

							if opt.Callback then
								opt.Callback(current)
							end

							stop()
							successFlash()
						end
					end)
				end)

				local apiObj = {}

				function apiObj:Set(key)
					current = key
					render(true)
					successFlash()
					if opt.Callback then
						opt.Callback(current)
					end
				end

				function apiObj:Get()
					return current
				end

				render(false)
				return apiObj
			end

			function groupApi:AddButton(name, opt)
				opt = opt or {}

				local btn = create("TextButton", {
					Size = UDim2.new(1, 0, 0, 18),
					BackgroundColor3 = THEME.Control2,
					Text = name,
					TextColor3 = THEME.Text,
					TextSize = 12,
					Font = Enum.Font.Code,
					AutoButtonColor = false,
					Parent = body
				})
				stroke(btn, THEME.StrokeSoft, 1, 0)
				corner(btn, 1)

				btn.MouseEnter:Connect(function()
					tween(btn, 0.1, {BackgroundColor3 = THEME.Control})
				end)

				btn.MouseLeave:Connect(function()
					tween(btn, 0.1, {BackgroundColor3 = THEME.Control2})
				end)

				btn.MouseButton1Click:Connect(function()
					tween(btn, 0.06, {BackgroundColor3 = Color3.fromRGB(45, 65, 60)})
					task.delay(0.08, function()
						if btn and btn.Parent then
							tween(btn, 0.1, {BackgroundColor3 = THEME.Control2})
						end
					end)

					if opt.Callback then
						opt.Callback()
					end
				end)

				return btn
			end

			function groupApi:AddTextbox(name, opt)
				opt = opt or {}

				local holder = create("Frame", {
					Size = UDim2.new(1, 0, 0, 32),
					BackgroundTransparency = 1,
					Parent = body
				})

				create("TextLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 12),
					Text = name,
					TextColor3 = THEME.Text,
					TextSize = 12,
					Font = Enum.Font.Code,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = holder
				})

				local box = create("TextBox", {
					Position = UDim2.fromOffset(0, 14),
					Size = UDim2.new(1, 0, 0, 18),
					BackgroundColor3 = THEME.Control2,
					Text = opt.Default or "",
					PlaceholderText = opt.Placeholder or "Enter text...",
					TextColor3 = THEME.Text,
					PlaceholderColor3 = THEME.SubText,
					TextSize = 12,
					Font = Enum.Font.Code,
					ClearTextOnFocus = false,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = holder
				})
				stroke(box, THEME.StrokeSoft, 1, 0)
				corner(box, 1)
				pad(box, 5, 5, 0, 0)

				box.Focused:Connect(function()
					tween(box, 0.1, {BackgroundColor3 = THEME.Control})
				end)

				box.FocusLost:Connect(function(enterPressed)
					tween(box, 0.1, {BackgroundColor3 = THEME.Control2})
					if opt.Callback then
						opt.Callback(box.Text, enterPressed)
					end
				end)

				return box
			end

									function groupApi:AddColorPicker(name, opt)
				opt = opt or {}

				local value = opt.Default or Color3.fromRGB(255, 255, 255)
				local opened = false

				local holder = create("Frame", {
					Size = UDim2.new(1, 0, 0, 16),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Parent = body
				})

				create("TextLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -74, 1, 0),
					Text = name,
					TextColor3 = THEME.Text,
					TextSize = 12,
					Font = Enum.Font.Code,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = holder
				})

				local preview = create("TextButton", {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.fromOffset(70, 16),
					BackgroundColor3 = THEME.Control2,
					Text = "",
					AutoButtonColor = false,
					Parent = holder
				})
				stroke(preview, THEME.StrokeSoft, 1, 0)
				corner(preview, 1)

				local swatch = create("Frame", {
					Position = UDim2.fromOffset(2, 2),
					Size = UDim2.new(1, -4, 1, -4),
					BackgroundColor3 = value,
					BorderSizePixel = 0,
					Parent = preview
				})
				corner(swatch, 1)

				local pickerFrame = create("Frame", {
					Position = UDim2.fromOffset(0, 20),
					Size = UDim2.new(1, 0, 0, 122),
					BackgroundColor3 = THEME.Control2,
					Visible = false,
					Parent = holder
				})
				stroke(pickerFrame, THEME.StrokeSoft, 1, 0)
				corner(pickerFrame, 1)
				pad(pickerFrame, 6, 6, 6, 6)

				local closeBtn = create("TextButton", {
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, -2, 0, 0),
					Size = UDim2.fromOffset(16, 16),
					BackgroundColor3 = THEME.Control,
					Text = "×",
					TextColor3 = THEME.Text,
					TextSize = 12,
					Font = Enum.Font.Code,
					AutoButtonColor = false,
					Parent = pickerFrame
				})
				stroke(closeBtn, THEME.StrokeSoft, 1, 0)
				corner(closeBtn, 1)

				local colorMap = create("Frame", {
					Position = UDim2.fromOffset(0, 18),
					Size = UDim2.new(1, 0, 0, 56),
					BackgroundColor3 = Color3.fromRGB(255, 0, 0),
					BorderSizePixel = 0,
					ClipsDescendants = true,
					Parent = pickerFrame
				})
				stroke(colorMap, THEME.StrokeSoft, 1, 0)
				corner(colorMap, 1)

				local satGrad = create("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
					}),
					Rotation = 0,
					Parent = colorMap
				})

				local valOverlay = create("Frame", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = Color3.new(0, 0, 0),
					BorderSizePixel = 0,
					Parent = colorMap
				})
				corner(valOverlay, 1)

				create("UIGradient", {
					Color = ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1)),
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, 0),
					}),
					Rotation = 90,
					Parent = valOverlay
				})

				local pickerKnob = create("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(1, 0),
					Size = UDim2.fromOffset(8, 8),
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderSizePixel = 0,
					Parent = colorMap
				})
				stroke(pickerKnob, Color3.fromRGB(0, 0, 0), 1, 0)
				corner(pickerKnob, 8)

				local hueBar = create("Frame", {
					Position = UDim2.fromOffset(0, 82),
					Size = UDim2.new(1, 0, 0, 10),
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderSizePixel = 0,
					ClipsDescendants = true,
					Parent = pickerFrame
				})
				stroke(hueBar, THEME.StrokeSoft, 1, 0)
				corner(hueBar, 1)

				create("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
						ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 0, 255)),
						ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 0, 255)),
						ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
						ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 255, 0)),
						ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 255, 0)),
						ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
					}),
					Rotation = 0,
					Parent = hueBar
				})

				local hueKnob = create("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0, 0.5),
					Size = UDim2.fromOffset(5, 12),
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderSizePixel = 0,
					Parent = hueBar
				})
				stroke(hueKnob, Color3.fromRGB(0, 0, 0), 1, 0)
				corner(hueKnob, 1)

				local hsv = {Color3.toHSV(value)}
				local draggingMap = false
				local draggingHue = false

				local function render(call)
					local h, s, v = hsv[1], hsv[2], hsv[3]
					local hueColor = Color3.fromHSV(h, 1, 1)

					satGrad.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
						ColorSequenceKeypoint.new(1, hueColor),
					})

					local finalColor = Color3.fromHSV(h, s, v)
					swatch.BackgroundColor3 = finalColor

					pickerKnob.Position = UDim2.fromScale(s, 1 - v)
					hueKnob.Position = UDim2.fromScale(h, 0.5)

					if opt.Callback and call ~= false then
						opt.Callback(finalColor)
					end
				end

				local function setMapFromMouse(x, y)
					local relX = math.clamp(x - colorMap.AbsolutePosition.X, 0, colorMap.AbsoluteSize.X)
					local relY = math.clamp(y - colorMap.AbsolutePosition.Y, 0, colorMap.AbsoluteSize.Y)

					hsv[2] = relX / colorMap.AbsoluteSize.X
					hsv[3] = 1 - (relY / colorMap.AbsoluteSize.Y)
					render(true)
				end

				local function setHueFromMouse(x)
					local relX = math.clamp(x - hueBar.AbsolutePosition.X, 0, hueBar.AbsoluteSize.X)
					hsv[1] = relX / hueBar.AbsoluteSize.X
					render(true)
				end

				colorMap.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						draggingMap = true
						local pos = UserInputService:GetMouseLocation()
						setMapFromMouse(pos.X, pos.Y)
					end
				end)

				hueBar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						draggingHue = true
						local pos = UserInputService:GetMouseLocation()
						setHueFromMouse(pos.X)
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						local pos = UserInputService:GetMouseLocation()
						if draggingMap then
							setMapFromMouse(pos.X, pos.Y)
						end
						if draggingHue then
							setHueFromMouse(pos.X)
						end
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						draggingMap = false
						draggingHue = false
					end
				end)

				preview.MouseButton1Click:Connect(function()
					opened = not opened
					pickerFrame.Visible = opened
				end)

				closeBtn.MouseButton1Click:Connect(function()
					opened = false
					pickerFrame.Visible = false
				end)

				local apiObj = {}

				function apiObj:Set(color)
					if typeof(color) == "Color3" then
						hsv = {Color3.toHSV(color)}
						render(true)
					end
				end

				function apiObj:Get()
					return Color3.fromHSV(hsv[1], hsv[2], hsv[3])
				end

				render(false)
				return apiObj
			end
			
			return groupApi
		end

		function tabApi:AddLeftGroupbox(titleText)
			return makeGroupbox(left, titleText)
		end

		function tabApi:AddRightGroupbox(titleText)
			return makeGroupbox(right, titleText)
		end

		return tabApi
	end

	root.Size = UDim2.fromOffset(520, 520)
	root.BackgroundTransparency = 1
	tween(root, 0.18, {
		Size = UDim2.fromOffset(560, 560),
		BackgroundTransparency = 0
	}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	return window
end

return ZenithClassic
