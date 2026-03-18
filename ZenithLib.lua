local ZenithLib = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

local THEME = {
	Bg = Color3.fromRGB(16, 16, 20),
	Bg2 = Color3.fromRGB(20, 20, 26),
	Sidebar = Color3.fromRGB(22, 22, 28),
	Topbar = Color3.fromRGB(20, 20, 26),
	Card = Color3.fromRGB(27, 27, 34),
	CardHover = Color3.fromRGB(32, 32, 41),
	Section = Color3.fromRGB(34, 34, 44),
	Stroke = Color3.fromRGB(62, 62, 76),
	SoftStroke = Color3.fromRGB(48, 48, 60),
	Text = Color3.fromRGB(245, 245, 252),
	SubText = Color3.fromRGB(165, 165, 180),
	Accent1 = Color3.fromRGB(132, 76, 255),
	Accent2 = Color3.fromRGB(255, 42, 166),
	White = Color3.fromRGB(255, 255, 255),
	Danger = Color3.fromRGB(255, 90, 110),
}

local function tween(obj, ti, props)
	local t = TweenService:Create(obj, ti, props)
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

local function corner(obj, radius)
	create("UICorner", {
		CornerRadius = UDim.new(0, radius or 12),
		Parent = obj
	})
end

local function stroke(obj, color, thickness, transparency)
	return create("UIStroke", {
		Color = color or THEME.Stroke,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = obj
	})
end

local function padding(obj, l, r, t, b)
	create("UIPadding", {
		PaddingLeft = UDim.new(0, l or 0),
		PaddingRight = UDim.new(0, r or 0),
		PaddingTop = UDim.new(0, t or 0),
		PaddingBottom = UDim.new(0, b or 0),
		Parent = obj
	})
end

local function gradient(obj, c1, c2, rot)
	return create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, c1 or THEME.Accent1),
			ColorSequenceKeypoint.new(1, c2 or THEME.Accent2),
		}),
		Rotation = rot or 0,
		Parent = obj
	})
end

local function blurEffect()
	local existing = Lighting:FindFirstChild("ZenithLib_Blur")
	if existing then
		return existing
	end

	local blur = Instance.new("BlurEffect")
	blur.Name = "ZenithLib_Blur"
	blur.Size = 0
	blur.Parent = Lighting
	return blur
end

local function hoverFade(button, normalBg, hoverBg, st, hoverStroke)
	button.MouseEnter:Connect(function()
		tween(button, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = hoverBg
		})
		if st then
			tween(st, TweenInfo.new(0.16), {
				Color = hoverStroke or THEME.Accent2
			})
		end
	end)

	button.MouseLeave:Connect(function()
		tween(button, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = normalBg
		})
		if st then
			tween(st, TweenInfo.new(0.16), {
				Color = THEME.Stroke
			})
		end
	end)
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

function ZenithLib:CreateWindow(config)
	config = config or {}

	local blur = blurEffect()
	tween(blur, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = 18
	})

	local gui = create("ScreenGui", {
		Name = config.Name or "ZenithLib",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = LocalPlayer:WaitForChild("PlayerGui")
	})

	local root = create("Frame", {
		Name = "Root",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(1010, 640),
		BackgroundColor3 = THEME.Bg,
		BackgroundTransparency = 0.14,
		ClipsDescendants = true,
		Parent = gui
	})
	corner(root, 20)
	stroke(root, THEME.Stroke, 1, 0.12)
	gradient(root, Color3.fromRGB(24, 24, 30), Color3.fromRGB(15, 15, 20), 90)

	create("ImageLabel", {
		Name = "Shadow",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, 90, 1, 90),
		BackgroundTransparency = 1,
		Image = "rbxassetid://1316045217",
		ImageColor3 = Color3.new(0, 0, 0),
		ImageTransparency = 0.38,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 118, 118),
		ZIndex = 0,
		Parent = root
	})

	local sidebar = create("Frame", {
		Name = "Sidebar",
		Size = UDim2.fromOffset(220, 640),
		BackgroundColor3 = THEME.Sidebar,
		BackgroundTransparency = 0.08,
		Parent = root
	})
	corner(sidebar, 20)

	create("Frame", {
		Position = UDim2.new(1, -20, 0, 0),
		Size = UDim2.fromOffset(20, 640),
		BackgroundColor3 = THEME.Sidebar,
		BorderSizePixel = 0,
		Parent = sidebar
	})

	create("TextLabel", {
		Position = UDim2.fromOffset(18, 18),
		Size = UDim2.new(1, -36, 0, 24),
		BackgroundTransparency = 1,
		Text = config.Title or "ZenithLib",
		TextColor3 = THEME.Text,
		TextSize = 20,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = sidebar
	})

	create("TextLabel", {
		Position = UDim2.fromOffset(18, 42),
		Size = UDim2.new(1, -36, 0, 18),
		BackgroundTransparency = 1,
		Text = config.Subtitle or "Reference interface",
		TextColor3 = THEME.SubText,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = sidebar
	})

	create("TextLabel", {
		Position = UDim2.fromOffset(18, 80),
		Size = UDim2.new(1, -36, 0, 18),
		BackgroundTransparency = 1,
		Text = "CATEGORIES",
		TextColor3 = THEME.SubText,
		TextTransparency = 0.2,
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = sidebar
	})

	local catHolder = create("Frame", {
		Name = "CategoryHolder",
		Position = UDim2.fromOffset(14, 106),
		Size = UDim2.new(1, -28, 1, -210),
		BackgroundTransparency = 1,
		Parent = sidebar
	})

	create("UIListLayout", {
		Padding = UDim.new(0, 9),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = catHolder
	})

	local profile = create("Frame", {
		Name = "Profile",
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 14, 1, -14),
		Size = UDim2.new(1, -28, 0, 82),
		BackgroundColor3 = THEME.Bg2,
		Parent = sidebar
	})
	corner(profile, 15)
	stroke(profile, THEME.SoftStroke, 1, 0.15)
	padding(profile, 12, 12, 12, 12)

	local avatar = create("ImageLabel", {
		Name = "Avatar",
		Size = UDim2.fromOffset(48, 48),
		BackgroundColor3 = THEME.Card,
		Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=150&height=150&format=png", LocalPlayer.UserId),
		Parent = profile
	})
	corner(avatar, 999)
	local avatarStroke = stroke(avatar, THEME.Accent1, 1, 0.05)
	gradient(avatarStroke, THEME.Accent1, THEME.Accent2, 35)

	create("TextLabel", {
		Position = UDim2.fromOffset(60, 8),
		Size = UDim2.new(1, -68, 0, 18),
		BackgroundTransparency = 1,
		Text = LocalPlayer.Name,
		TextColor3 = THEME.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = profile
	})

	create("TextLabel", {
		Position = UDim2.fromOffset(60, 29),
		Size = UDim2.new(1, -68, 0, 16),
		BackgroundTransparency = 1,
		Text = "UID: " .. LocalPlayer.UserId,
		TextColor3 = THEME.SubText,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = profile
	})

	local content = create("Frame", {
		Name = "Content",
		Position = UDim2.fromOffset(232, 12),
		Size = UDim2.new(1, -244, 1, -24),
		BackgroundTransparency = 1,
		Parent = root
	})

	local topbar = create("Frame", {
		Name = "Topbar",
		Size = UDim2.new(1, 0, 0, 48),
		BackgroundColor3 = THEME.Topbar,
		BackgroundTransparency = 0.15,
		Parent = content
	})
	corner(topbar, 14)
	stroke(topbar, THEME.SoftStroke, 1, 0.15)

	local pageTitle = create("TextLabel", {
		Position = UDim2.fromOffset(16, 0),
		Size = UDim2.new(1, -140, 1, 0),
		BackgroundTransparency = 1,
		Text = "Dashboard",
		TextColor3 = THEME.Text,
		TextSize = 20,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = topbar
	})

	create("TextLabel", {
		Position = UDim2.fromOffset(150, 0),
		Size = UDim2.new(1, -280, 1, 0),
		BackgroundTransparency = 1,
		Text = config.TopbarHint or "Minimal animated reference layout",
		TextColor3 = THEME.SubText,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = topbar
	})

	local closeButton = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(28, 28),
		BackgroundColor3 = THEME.Card,
		Text = "×",
		TextColor3 = THEME.Text,
		TextSize = 18,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		Parent = topbar
	})
	corner(closeButton, 9)
	local closeStroke = stroke(closeButton, THEME.SoftStroke, 1, 0.15)
	hoverFade(closeButton, THEME.Card, Color3.fromRGB(48, 28, 36), closeStroke, THEME.Danger)

	local minimizeButton = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -48, 0.5, 0),
		Size = UDim2.fromOffset(28, 28),
		BackgroundColor3 = THEME.Card,
		Text = "—",
		TextColor3 = THEME.Text,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		Parent = topbar
	})
	corner(minimizeButton, 9)
	local minStroke = stroke(minimizeButton, THEME.SoftStroke, 1, 0.15)
	hoverFade(minimizeButton, THEME.Card, THEME.Section, minStroke, THEME.Accent1)

	local pageContainer = create("Frame", {
		Name = "PageContainer",
		Position = UDim2.fromOffset(0, 60),
		Size = UDim2.new(1, 0, 1, -60),
		BackgroundTransparency = 1,
		Parent = content
	})

	local pagesFolder = create("Folder", {
		Name = "Pages",
		Parent = pageContainer
	})

	local isOpen = true
	local isMinimized = false

	local api = {
		_Gui = gui,
		_Root = root,
		_Categories = {},
		_Pages = {},
		_Current = nil,
		_Blur = blur,
		_Open = true,
		_Minimized = false,
	}

	local function animateOpen(state)
		isOpen = state
		api._Open = state

		if state then
			gui.Enabled = true
			root.Visible = true
			tween(blur, TweenInfo.new(0.25), {Size = 18})
			root.Size = UDim2.fromOffset(960, 605)
			root.BackgroundTransparency = 1
			tween(root, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.fromOffset(1010, 640),
				BackgroundTransparency = 0.14
			})
		else
			tween(blur, TweenInfo.new(0.22), {Size = 0})
			local t = tween(root, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.fromOffset(960, 605),
				BackgroundTransparency = 1
			})
			t.Completed:Connect(function()
				root.Visible = false
				gui.Enabled = false
			end)
		end
	end

	local function setMinimized(state)
		isMinimized = state
		api._Minimized = state

		if state then
			pageContainer.Visible = false
			tween(root, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.fromOffset(1010, 72)
			})
		else
			pageContainer.Visible = true
			tween(root, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.fromOffset(1010, 640)
			})
		end
	end

	makeDraggable(topbar, root)

	closeButton.MouseButton1Click:Connect(function()
		animateOpen(false)
	end)

	minimizeButton.MouseButton1Click:Connect(function()
		setMinimized(not isMinimized)
	end)

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.KeyCode == Enum.KeyCode.RightShift then
			if not isOpen then
				animateOpen(true)
			else
				animateOpen(false)
			end
		end
	end)

	function api:Destroy()
		tween(blur, TweenInfo.new(0.18), {Size = 0})
		task.delay(0.2, function()
			if blur and blur.Parent then
				blur:Destroy()
			end
		end)
		gui:Destroy()
	end

	function api:SelectCategory(name)
		for catName, catData in pairs(self._Categories) do
			local selected = (catName == name)

			catData.Highlight.Visible = selected
			catData.Icon.ImageColor3 = selected and THEME.White or THEME.SubText
			catData.Text.TextColor3 = selected and THEME.Text or THEME.SubText
			tween(catData.Button, TweenInfo.new(0.18), {
				BackgroundTransparency = selected and 0.05 or 0.28
			})

			if self._Pages[catName] then
				self._Pages[catName].Visible = selected
			end
		end

		self._Current = name
		pageTitle.Text = name
	end

	function api:AddCategory(name, icon)
		local button = create("TextButton", {
			Name = name,
			Size = UDim2.new(1, 0, 0, 44),
			BackgroundColor3 = THEME.Bg2,
			BackgroundTransparency = 0.28,
			Text = "",
			AutoButtonColor = false,
			Parent = catHolder
		})
		corner(button, 12)
		local st = stroke(button, THEME.SoftStroke, 1, 0.16)

		local highlight = create("Frame", {
			Name = "Highlight",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = THEME.White,
			BackgroundTransparency = 0.1,
			Visible = false,
			ZIndex = 1,
			Parent = button
		})
		corner(highlight, 12)
		gradient(highlight, THEME.Accent1, THEME.Accent2, 0)

		create("UIGradient", {
			Color = ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1)),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.15),
				NumberSequenceKeypoint.new(1, 0.32),
			}),
			Parent = highlight
		})

		local iconLabel = create("ImageLabel", {
			Name = "Icon",
			Position = UDim2.fromOffset(12, 10),
			Size = UDim2.fromOffset(24, 24),
			BackgroundTransparency = 1,
			Image = icon or "",
			ImageColor3 = THEME.SubText,
			ZIndex = 2,
			Parent = button
		})

		local textLabel = create("TextLabel", {
			Name = "Text",
			Position = UDim2.fromOffset(46, 0),
			Size = UDim2.new(1, -56, 1, 0),
			BackgroundTransparency = 1,
			Text = name,
			TextColor3 = THEME.SubText,
			TextSize = 14,
			Font = Enum.Font.GothamMedium,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 2,
			Parent = button
		})

		hoverFade(button, THEME.Bg2, THEME.Section, st, THEME.Accent2)

		local page = create("ScrollingFrame", {
			Name = name .. "_Page",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			CanvasSize = UDim2.fromOffset(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			ScrollBarThickness = 4,
			ScrollBarImageColor3 = THEME.Accent2,
			Visible = false,
			Parent = pagesFolder
		})

		local columns = create("Frame", {
			Name = "Columns",
			Size = UDim2.new(1, -2, 1, 0),
			BackgroundTransparency = 1,
			Parent = page
		})

		local leftColumn = create("Frame", {
			Name = "Left",
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(0.5, -7, 1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent = columns
		})

		local rightColumn = create("Frame", {
			Name = "Right",
			Position = UDim2.new(0.5, 7, 0, 0),
			Size = UDim2.new(0.5, -7, 1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent = columns
		})

		local leftLayout = create("UIListLayout", {
			Padding = UDim.new(0, 14),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = leftColumn
		})

		local rightLayout = create("UIListLayout", {
			Padding = UDim.new(0, 14),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = rightColumn
		})

		local function refreshPageCanvas()
			local h = math.max(leftLayout.AbsoluteContentSize.Y, rightLayout.AbsoluteContentSize.Y)
			page.CanvasSize = UDim2.fromOffset(0, h + 6)
		end

		leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshPageCanvas)
		rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshPageCanvas)

		button.MouseButton1Click:Connect(function()
			api:SelectCategory(name)
		end)

		api._Categories[name] = {
			Button = button,
			Highlight = highlight,
			Icon = iconLabel,
			Text = textLabel,
		}

		api._Pages[name] = page

		if not api._Current then
			api:SelectCategory(name)
		end

		local catApi = {
			_LeftColumn = leftColumn,
			_RightColumn = rightColumn,
			_LeftHeight = 0,
			_RightHeight = 0,
		}

		local function getTargetColumn(cardHeight)
			if catApi._LeftHeight <= catApi._RightHeight then
				catApi._LeftHeight += cardHeight + 14
				return leftColumn
			else
				catApi._RightHeight += cardHeight + 14
				return rightColumn
			end
		end

		function catApi:AddModule(moduleConfig)
			moduleConfig = moduleConfig or {}

			local card = create("Frame", {
				Name = moduleConfig.Name or "Module",
				Size = UDim2.new(1, 0, 0, 170),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = THEME.Card,
				Parent = getTargetColumn(170)
			})
			corner(card, 15)
			local cardStroke = stroke(card, THEME.Stroke, 1, 0.12)

			local cardGlow = create("ImageLabel", {
				Name = "Glow",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(1, 70, 1, 70),
				BackgroundTransparency = 1,
				Image = "rbxassetid://5028857084",
				ImageColor3 = THEME.Accent2,
				ImageTransparency = 0.94,
				ZIndex = 0,
				Parent = card
			})

			local container = create("Frame", {
				Name = "Container",
				Size = UDim2.new(1, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Parent = card
			})
			padding(container, 14, 14, 14, 14)

			local list = create("UIListLayout", {
				Padding = UDim.new(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = container
			})

			local header = create("Frame", {
				Size = UDim2.new(1, 0, 0, 44),
				BackgroundTransparency = 1,
				Parent = container
			})

			create("TextLabel", {
				Size = UDim2.new(1, -58, 0, 20),
				BackgroundTransparency = 1,
				Text = moduleConfig.Name or "Module",
				TextColor3 = THEME.Text,
				TextSize = 16,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = header
			})

			create("TextLabel", {
				Position = UDim2.fromOffset(0, 22),
				Size = UDim2.new(1, -58, 0, 18),
				BackgroundTransparency = 1,
				Text = moduleConfig.Description or "Description",
				TextColor3 = THEME.SubText,
				TextSize = 12,
				Font = Enum.Font.Gotham,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = header
			})

			local mainToggle = create("TextButton", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.fromOffset(44, 24),
				BackgroundColor3 = Color3.fromRGB(40, 40, 48),
				Text = "",
				AutoButtonColor = false,
				Parent = header
			})
			corner(mainToggle, 999)
			stroke(mainToggle, THEME.SoftStroke, 1, 0.15)

			local mainKnob = create("Frame", {
				Position = UDim2.fromOffset(3, 3),
				Size = UDim2.fromOffset(18, 18),
				BackgroundColor3 = THEME.White,
				Parent = mainToggle
			})
			corner(mainKnob, 999)

			local mainKnobGlow = create("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(34, 34),
				BackgroundTransparency = 1,
				Image = "rbxassetid://5028857084",
				ImageColor3 = THEME.Accent2,
				ImageTransparency = 1,
				Parent = mainKnob
			})

			local moduleApi = {
				_Enabled = false,
				_Card = card,
				_Container = container,
				_List = list,
			}

			local function fit()
				card.Size = UDim2.new(1, 0, 0, math.max(170, list.AbsoluteContentSize.Y + 28))
				refreshPageCanvas()
			end

			list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fit)
			hoverFade(card, THEME.Card, THEME.CardHover, cardStroke, THEME.Accent2)

			local function setEnabled(state)
				moduleApi._Enabled = state

				if state then
					tween(mainToggle, TweenInfo.new(0.22), {BackgroundColor3 = THEME.Accent1})
					tween(mainKnob, TweenInfo.new(0.22), {Position = UDim2.fromOffset(23, 3)})
					tween(mainKnobGlow, TweenInfo.new(0.22), {ImageTransparency = 0.35})
					tween(cardGlow, TweenInfo.new(0.25), {ImageTransparency = 0.83})
					tween(cardStroke, TweenInfo.new(0.22), {Color = THEME.Accent2})
				else
					tween(mainToggle, TweenInfo.new(0.22), {BackgroundColor3 = Color3.fromRGB(40, 40, 48)})
					tween(mainKnob, TweenInfo.new(0.22), {Position = UDim2.fromOffset(3, 3)})
					tween(mainKnobGlow, TweenInfo.new(0.22), {ImageTransparency = 1})
					tween(cardGlow, TweenInfo.new(0.25), {ImageTransparency = 0.94})
					tween(cardStroke, TweenInfo.new(0.22), {Color = THEME.Stroke})
				end

				if moduleConfig.Callback then
					moduleConfig.Callback(state)
				end
			end

			mainToggle.MouseButton1Click:Connect(function()
				setEnabled(not moduleApi._Enabled)
			end)

			function moduleApi:Set(state)
				setEnabled(state)
			end

			function moduleApi:AddLabel(text)
				local lbl = create("TextLabel", {
					Size = UDim2.new(1, 0, 0, 16),
					BackgroundTransparency = 1,
					Text = text or "Label",
					TextColor3 = THEME.SubText,
					TextSize = 12,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = container
				})
				fit()
				return lbl
			end

			function moduleApi:AddToggle(opt)
				opt = opt or {}

				local holder = create("Frame", {
					Size = UDim2.new(1, 0, 0, 34),
					BackgroundTransparency = 1,
					Parent = container
				})

				create("TextLabel", {
					Size = UDim2.new(1, -58, 1, 0),
					BackgroundTransparency = 1,
					Text = opt.Name or "Toggle",
					TextColor3 = THEME.Text,
					TextSize = 13,
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = holder
				})

				local btn = create("TextButton", {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.fromOffset(40, 22),
					BackgroundColor3 = Color3.fromRGB(40, 40, 48),
					Text = "",
					AutoButtonColor = false,
					Parent = holder
				})
				corner(btn, 999)
				stroke(btn, THEME.SoftStroke, 1, 0.15)

				local dot = create("Frame", {
					Position = UDim2.fromOffset(3, 3),
					Size = UDim2.fromOffset(16, 16),
					BackgroundColor3 = THEME.White,
					Parent = btn
				})
				corner(dot, 999)

				local dotGlow = create("ImageLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(28, 28),
					BackgroundTransparency = 1,
					Image = "rbxassetid://5028857084",
					ImageColor3 = THEME.Accent2,
					ImageTransparency = 1,
					Parent = dot
				})

				local state = opt.Default or false

				local function render()
					if state then
						tween(btn, TweenInfo.new(0.2), {BackgroundColor3 = THEME.Accent1})
						tween(dot, TweenInfo.new(0.2), {Position = UDim2.fromOffset(21, 3)})
						tween(dotGlow, TweenInfo.new(0.2), {ImageTransparency = 0.35})
					else
						tween(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 48)})
						tween(dot, TweenInfo.new(0.2), {Position = UDim2.fromOffset(3, 3)})
						tween(dotGlow, TweenInfo.new(0.2), {ImageTransparency = 1})
					end
				end

				btn.MouseButton1Click:Connect(function()
					state = not state
					render()
					if opt.Callback then
						opt.Callback(state)
					end
				end)

				render()
				fit()
				return holder
			end

			function moduleApi:AddSlider(opt)
				opt = opt or {}

				local min = opt.Min or 0
				local max = opt.Max or 100
				local value = opt.Default or min
				local dragging = false

				local holder = create("Frame", {
					Size = UDim2.new(1, 0, 0, 52),
					BackgroundTransparency = 1,
					Parent = container
				})

				create("TextLabel", {
					Size = UDim2.new(1, -50, 0, 18),
					BackgroundTransparency = 1,
					Text = opt.Name or "Slider",
					TextColor3 = THEME.Text,
					TextSize = 13,
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = holder
				})

				local valueLabel = create("TextLabel", {
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, 0, 0, 0),
					Size = UDim2.fromOffset(50, 18),
					BackgroundTransparency = 1,
					Text = tostring(value),
					TextColor3 = THEME.SubText,
					TextSize = 12,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Right,
					Parent = holder
				})

				local bar = create("Frame", {
					Position = UDim2.fromOffset(0, 29),
					Size = UDim2.new(1, 0, 0, 8),
					BackgroundColor3 = Color3.fromRGB(42, 42, 52),
					Parent = holder
				})
				corner(bar, 999)

				local fill = create("Frame", {
					Size = UDim2.new((value - min) / math.max(max - min, 1), 0, 1, 0),
					BackgroundColor3 = THEME.Accent1,
					Parent = bar
				})
				corner(fill, 999)
				gradient(fill, THEME.Accent1, THEME.Accent2, 0)

				create("ImageLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.new(1, 14, 0, 18),
					BackgroundTransparency = 1,
					Image = "rbxassetid://5028857084",
					ImageColor3 = THEME.Accent2,
					ImageTransparency = 0.82,
					Parent = fill
				})

				local knob = create("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0),
					Size = UDim2.fromOffset(12, 12),
					BackgroundColor3 = THEME.White,
					Parent = bar
				})
				corner(knob, 999)

				create("ImageLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(28, 28),
					BackgroundTransparency = 1,
					Image = "rbxassetid://5028857084",
					ImageColor3 = THEME.Accent2,
					ImageTransparency = 0.45,
					Parent = knob
				})

				local function applyValueFromPercent(p)
					p = math.clamp(p, 0, 1)
					value = math.floor(min + (max - min) * p + 0.5)
					valueLabel.Text = tostring(value)

					tween(fill, TweenInfo.new(0.08, Enum.EasingStyle.Linear), {
						Size = UDim2.new(p, 0, 1, 0)
					})
					tween(knob, TweenInfo.new(0.08, Enum.EasingStyle.Linear), {
						Position = UDim2.new(p, 0, 0.5, 0)
					})

					if opt.Callback then
						opt.Callback(value)
					end
				end

				local function updateFromMouse(x)
					local p = (x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
					applyValueFromPercent(p)
				end

				bar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = true
						updateFromMouse(UserInputService:GetMouseLocation().X)
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						updateFromMouse(UserInputService:GetMouseLocation().X)
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
					end
				end)

				applyValueFromPercent((value - min) / math.max(max - min, 1))
				fit()
				return holder
			end

			function moduleApi:AddDropdown(opt)
				opt = opt or {}

				local items = opt.Items or {"Option 1", "Option 2"}
				local selected = opt.Default or items[1]
				local opened = false

				local holder = create("Frame", {
					Size = UDim2.new(1, 0, 0, 36),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Parent = container
				})

				local main = create("TextButton", {
					Size = UDim2.new(1, 0, 0, 36),
					BackgroundColor3 = THEME.Section,
					Text = "",
					AutoButtonColor = false,
					Parent = holder
				})
				corner(main, 10)
				local mainStroke = stroke(main, THEME.SoftStroke, 1, 0.16)
				padding(main, 12, 12, 0, 0)
				hoverFade(main, THEME.Section, THEME.CardHover, mainStroke, THEME.Accent2)

				local text = create("TextLabel", {
					Size = UDim2.new(1, -20, 1, 0),
					BackgroundTransparency = 1,
					Text = string.format("%s: %s", opt.Name or "Dropdown", tostring(selected)),
					TextColor3 = THEME.Text,
					TextSize = 13,
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = main
				})

				local arrow = create("TextLabel", {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -2, 0.5, 0),
					Size = UDim2.fromOffset(16, 16),
					BackgroundTransparency = 1,
					Text = "▾",
					TextColor3 = THEME.SubText,
					TextSize = 14,
					Font = Enum.Font.GothamBold,
					Parent = main
				})

				local drop = create("Frame", {
					Position = UDim2.fromOffset(0, 42),
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = THEME.Section,
					Visible = false,
					ClipsDescendants = true,
					Parent = holder
				})
				corner(drop, 10)
				stroke(drop, THEME.SoftStroke, 1, 0.16)
				padding(drop, 8, 8, 8, 8)

				create("UIListLayout", {
					Padding = UDim.new(0, 6),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = drop
				})

				for _, item in ipairs(items) do
					local option = create("TextButton", {
						Size = UDim2.new(1, 0, 0, 28),
						BackgroundColor3 = THEME.Card,
						Text = tostring(item),
						TextColor3 = THEME.Text,
						TextSize = 12,
						Font = Enum.Font.Gotham,
						AutoButtonColor = false,
						Parent = drop
					})
					corner(option, 8)
					local optStroke = stroke(option, THEME.SoftStroke, 1, 0.2)
					hoverFade(option, THEME.Card, THEME.CardHover, optStroke, THEME.Accent2)

					option.MouseButton1Click:Connect(function()
						selected = item
						text.Text = string.format("%s: %s", opt.Name or "Dropdown", tostring(selected))
						opened = false
						drop.Visible = false
						arrow.Text = "▾"
						fit()

						if opt.Callback then
							opt.Callback(selected)
						end
					end)
				end

				main.MouseButton1Click:Connect(function()
					opened = not opened
					drop.Visible = opened
					arrow.Text = opened and "▴" or "▾"
					fit()
				end)

				fit()
				return holder
			end

			function moduleApi:AddKeybind(opt)
				opt = opt or {}

				local currentKey = opt.Default
				local listening = false

				local holder = create("Frame", {
					Size = UDim2.new(1, 0, 0, 36),
					BackgroundTransparency = 1,
					Parent = container
				})

				create("TextLabel", {
					Size = UDim2.new(1, -110, 1, 0),
					BackgroundTransparency = 1,
					Text = opt.Name or "Keybind",
					TextColor3 = THEME.Text,
					TextSize = 13,
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = holder
				})

				local bindButton = create("TextButton", {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.fromOffset(96, 28),
					BackgroundColor3 = THEME.Section,
					Text = "",
					AutoButtonColor = false,
					Parent = holder
				})
				corner(bindButton, 9)
				local bindStroke = stroke(bindButton, THEME.SoftStroke, 1, 0.16)

				local bindText = create("TextLabel", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					TextColor3 = THEME.Text,
					TextSize = 12,
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Center,
					Parent = bindButton
				})

				local bindGlow = create("ImageLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.new(1, 24, 1, 24),
					BackgroundTransparency = 1,
					Image = "rbxassetid://5028857084",
					ImageColor3 = THEME.Accent2,
					ImageTransparency = 0.95,
					ZIndex = 0,
					Parent = bindButton
				})

				local function keyToText(key)
					if not key then
						return "None"
					end

					if typeof(key) == "EnumItem" then
						return key.Name
					end

					return tostring(key)
				end

				local function render()
					if listening then
						bindText.Text = "..."
						tween(bindButton, TweenInfo.new(0.18), {
							BackgroundColor3 = THEME.Accent1
						})
						tween(bindStroke, TweenInfo.new(0.18), {
							Color = THEME.Accent2
						})
						tween(bindGlow, TweenInfo.new(0.18), {
							ImageTransparency = 0.55
						})
					else
						bindText.Text = keyToText(currentKey)
						tween(bindButton, TweenInfo.new(0.18), {
							BackgroundColor3 = THEME.Section
						})
						tween(bindStroke, TweenInfo.new(0.18), {
							Color = THEME.SoftStroke
						})
						tween(bindGlow, TweenInfo.new(0.18), {
							ImageTransparency = 0.95
						})
					end
				end

				hoverFade(bindButton, THEME.Section, THEME.CardHover, bindStroke, THEME.Accent2)

				local inputConnection
				local function stopListening()
					listening = false
					if inputConnection then
						inputConnection:Disconnect()
						inputConnection = nil
					end
					render()
				end

				local function startListening()
					if listening then
						return
					end

					listening = true
					render()

					inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
						if gameProcessed then
							return
						end

						if input.UserInputType == Enum.UserInputType.Keyboard then
							local key = input.KeyCode

							if key == Enum.KeyCode.Escape or key == Enum.KeyCode.Backspace then
								currentKey = nil
							else
								currentKey = key
							end

							if opt.Callback then
								opt.Callback(currentKey)
							end

							stopListening()
						end
					end)
				end

				bindButton.MouseButton1Click:Connect(function()
					if listening then
						stopListening()
					else
						startListening()
					end
				end)

				render()
				fit()

				local keybindApi = {}

				function keybindApi:Set(key)
					currentKey = key
					render()
					if opt.Callback then
						opt.Callback(currentKey)
					end
				end

				function keybindApi:Get()
					return currentKey
				end

				return keybindApi
			end

			function moduleApi:AddButton(opt)
				opt = opt or {}

				local button = create("TextButton", {
					Size = UDim2.new(1, 0, 0, 34),
					BackgroundColor3 = THEME.Section,
					Text = opt.Name or "Button",
					TextColor3 = THEME.Text,
					TextSize = 13,
					Font = Enum.Font.GothamMedium,
					AutoButtonColor = false,
					Parent = container
				})
				corner(button, 10)
				local buttonStroke = stroke(button, THEME.SoftStroke, 1, 0.16)
				hoverFade(button, THEME.Section, THEME.CardHover, buttonStroke, THEME.Accent2)

				button.MouseButton1Click:Connect(function()
					tween(button, TweenInfo.new(0.08), {
						BackgroundColor3 = THEME.Accent1
					})
					task.delay(0.1, function()
						if button and button.Parent then
							tween(button, TweenInfo.new(0.14), {
								BackgroundColor3 = THEME.Section
							})
						end
					end)

					if opt.Callback then
						opt.Callback()
					end
				end)

				fit()
				return button
			end

			function moduleApi:AddTextbox(opt)
				opt = opt or {}

				local holder = create("Frame", {
					Size = UDim2.new(1, 0, 0, 58),
					BackgroundTransparency = 1,
					Parent = container
				})

				create("TextLabel", {
					Size = UDim2.new(1, 0, 0, 18),
					BackgroundTransparency = 1,
					Text = opt.Name or "Textbox",
					TextColor3 = THEME.Text,
					TextSize = 13,
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = holder
				})

				local boxHolder = create("Frame", {
					Position = UDim2.fromOffset(0, 24),
					Size = UDim2.new(1, 0, 0, 30),
					BackgroundColor3 = THEME.Section,
					Parent = holder
				})
				corner(boxHolder, 10)
				local boxStroke = stroke(boxHolder, THEME.SoftStroke, 1, 0.16)

				local textBox = create("TextBox", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text = opt.Default or "",
					PlaceholderText = opt.Placeholder or "Enter text...",
					TextColor3 = THEME.Text,
					PlaceholderColor3 = THEME.SubText,
					TextSize = 13,
					Font = Enum.Font.Gotham,
					ClearTextOnFocus = false,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = boxHolder
				})
				padding(textBox, 10, 10, 0, 0)

				textBox.Focused:Connect(function()
					tween(boxHolder, TweenInfo.new(0.16), {
						BackgroundColor3 = THEME.CardHover
					})
					tween(boxStroke, TweenInfo.new(0.16), {
						Color = THEME.Accent2
					})
				end)

				textBox.FocusLost:Connect(function(enterPressed)
					tween(boxHolder, TweenInfo.new(0.16), {
						BackgroundColor3 = THEME.Section
					})
					tween(boxStroke, TweenInfo.new(0.16), {
						Color = THEME.SoftStroke
					})

					if opt.Callback then
						opt.Callback(textBox.Text, enterPressed)
					end
				end)

				fit()
				return textBox
			end

			fit()
			return moduleApi
		end

		return catApi
	end

	root.Size = UDim2.fromOffset(960, 605)
	root.BackgroundTransparency = 1
	tween(root, TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Size = UDim2.fromOffset(1010, 640),
		BackgroundTransparency = 0.14
	})

	return api
end

return ZenithLib
