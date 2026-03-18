local ZenithLib = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

local THEME = {
	Bg = Color3.fromRGB(16, 16, 20),
	Bg2 = Color3.fromRGB(20, 20, 26),
	Sidebar = Color3.fromRGB(21, 21, 27),
	Topbar = Color3.fromRGB(20, 20, 26),
	Card = Color3.fromRGB(27, 27, 34),
	CardHover = Color3.fromRGB(31, 31, 39),
	Section = Color3.fromRGB(33, 33, 42),
	Stroke = Color3.fromRGB(58, 58, 72),
	SoftStroke = Color3.fromRGB(46, 46, 58),
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
		CornerRadius = UDim.new(0, radius or 10),
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
		tween(button, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = hoverBg
		})
		if st then
			tween(st, TweenInfo.new(0.14), {
				Color = hoverStroke or THEME.Accent2
			})
		end
	end)

	button.MouseLeave:Connect(function()
		tween(button, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = normalBg
		})
		if st then
			tween(st, TweenInfo.new(0.14), {
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
	tween(blur, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = 14
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
		Size = UDim2.fromOffset(860, 540),
		BackgroundColor3 = THEME.Bg,
		BackgroundTransparency = 0.12,
		ClipsDescendants = true,
		Parent = gui
	})
	corner(root, 18)
	stroke(root, THEME.Stroke, 1, 0.14)
	gradient(root, Color3.fromRGB(22, 22, 28), Color3.fromRGB(15, 15, 20), 90)

	local sidebar = create("Frame", {
		Name = "Sidebar",
		Size = UDim2.fromOffset(190, 540),
		BackgroundColor3 = THEME.Sidebar,
		BackgroundTransparency = 0.05,
		Parent = root
	})
	corner(sidebar, 18)

	create("Frame", {
		Position = UDim2.new(1, -18, 0, 0),
		Size = UDim2.fromOffset(18, 540),
		BackgroundColor3 = THEME.Sidebar,
		BorderSizePixel = 0,
		Parent = sidebar
	})

	create("TextLabel", {
		Position = UDim2.fromOffset(16, 16),
		Size = UDim2.new(1, -32, 0, 22),
		BackgroundTransparency = 1,
		Text = config.Title or "ZenithLib",
		TextColor3 = THEME.Text,
		TextSize = 17,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = sidebar
	})

	create("TextLabel", {
		Position = UDim2.fromOffset(16, 37),
		Size = UDim2.new(1, -32, 0, 16),
		BackgroundTransparency = 1,
		Text = config.Subtitle or "Premium reference interface",
		TextColor3 = THEME.SubText,
		TextSize = 11,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = sidebar
	})

	create("TextLabel", {
		Position = UDim2.fromOffset(16, 78),
		Size = UDim2.new(1, -32, 0, 16),
		BackgroundTransparency = 1,
		Text = "CATEGORIES",
		TextColor3 = THEME.SubText,
		TextTransparency = 0.15,
		TextSize = 10,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = sidebar
	})

	local catHolder = create("Frame", {
		Name = "CategoryHolder",
		Position = UDim2.fromOffset(12, 98),
		Size = UDim2.new(1, -24, 1, -178),
		BackgroundTransparency = 1,
		Parent = sidebar
	})

	create("UIListLayout", {
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = catHolder
	})

	local profile = create("Frame", {
		Name = "Profile",
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 12, 1, -12),
		Size = UDim2.new(1, -24, 0, 70),
		BackgroundColor3 = THEME.Bg2,
		Parent = sidebar
	})
	corner(profile, 14)
	stroke(profile, THEME.SoftStroke, 1, 0.18)
	padding(profile, 10, 10, 10, 10)

	local avatar = create("ImageLabel", {
		Name = "Avatar",
		Size = UDim2.fromOffset(42, 42),
		BackgroundColor3 = THEME.Card,
		Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=150&height=150&format=png", LocalPlayer.UserId),
		Parent = profile
	})
	corner(avatar, 999)
	local avatarStroke = stroke(avatar, THEME.Accent1, 1, 0.08)
	gradient(avatarStroke, THEME.Accent1, THEME.Accent2, 35)

	create("TextLabel", {
		Position = UDim2.fromOffset(54, 6),
		Size = UDim2.new(1, -60, 0, 16),
		BackgroundTransparency = 1,
		Text = LocalPlayer.Name,
		TextColor3 = THEME.Text,
		TextSize = 13,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = profile
	})

	create("TextLabel", {
		Position = UDim2.fromOffset(54, 25),
		Size = UDim2.new(1, -60, 0, 15),
		BackgroundTransparency = 1,
		Text = "UID: " .. LocalPlayer.UserId,
		TextColor3 = THEME.SubText,
		TextSize = 11,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = profile
	})

	local content = create("Frame", {
		Name = "Content",
		Position = UDim2.fromOffset(202, 10),
		Size = UDim2.new(1, -212, 1, -20),
		BackgroundTransparency = 1,
		Parent = root
	})

	local topbar = create("Frame", {
		Name = "Topbar",
		Size = UDim2.new(1, 0, 0, 42),
		BackgroundColor3 = THEME.Topbar,
		BackgroundTransparency = 0.08,
		Parent = content
	})
	corner(topbar, 13)
	stroke(topbar, THEME.SoftStroke, 1, 0.18)

	local pageTitle = create("TextLabel", {
		Position = UDim2.fromOffset(14, 0),
		Size = UDim2.new(1, -120, 1, 0),
		BackgroundTransparency = 1,
		Text = "Dashboard",
		TextColor3 = THEME.Text,
		TextSize = 18,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = topbar
	})

	create("TextLabel", {
		Position = UDim2.fromOffset(118, 0),
		Size = UDim2.new(1, -220, 1, 0),
		BackgroundTransparency = 1,
		Text = config.TopbarHint or "Loaded with loadstring",
		TextColor3 = THEME.SubText,
		TextSize = 11,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = topbar
	})

	local closeButton = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.fromOffset(26, 26),
		BackgroundColor3 = THEME.Card,
		Text = "×",
		TextColor3 = THEME.Text,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		Parent = topbar
	})
	corner(closeButton, 8)
	local closeStroke = stroke(closeButton, THEME.SoftStroke, 1, 0.16)
	hoverFade(closeButton, THEME.Card, Color3.fromRGB(48, 28, 36), closeStroke, THEME.Danger)

	local minimizeButton = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -42, 0.5, 0),
		Size = UDim2.fromOffset(26, 26),
		BackgroundColor3 = THEME.Card,
		Text = "—",
		TextColor3 = THEME.Text,
		TextSize = 15,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		Parent = topbar
	})
	corner(minimizeButton, 8)
	local minStroke = stroke(minimizeButton, THEME.SoftStroke, 1, 0.16)
	hoverFade(minimizeButton, THEME.Card, THEME.Section, minStroke, THEME.Accent1)

	local pageContainer = create("Frame", {
		Name = "PageContainer",
		Position = UDim2.fromOffset(0, 52),
		Size = UDim2.new(1, 0, 1, -52),
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
			tween(blur, TweenInfo.new(0.22), {Size = 14})
			root.Size = UDim2.fromOffset(820, 510)
			root.BackgroundTransparency = 1
			tween(root, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.fromOffset(860, 540),
				BackgroundTransparency = 0.12
			})
		else
			tween(blur, TweenInfo.new(0.2), {Size = 0})
			local t = tween(root, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.fromOffset(820, 510),
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
			tween(root, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.fromOffset(860, 62)
			})
		else
			pageContainer.Visible = true
			tween(root, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.fromOffset(860, 540)
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
			tween(catData.Button, TweenInfo.new(0.16), {
				BackgroundTransparency = selected and 0.04 or 0.22
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
			Size = UDim2.new(1, 0, 0, 40),
			BackgroundColor3 = THEME.Bg2,
			BackgroundTransparency = 0.22,
			Text = "",
			AutoButtonColor = false,
			Parent = catHolder
		})
		corner(button, 11)
		local st = stroke(button, THEME.SoftStroke, 1, 0.18)

		local highlight = create("Frame", {
			Name = "Highlight",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = THEME.White,
			BackgroundTransparency = 0.08,
			Visible = false,
			ZIndex = 1,
			Parent = button
		})
		corner(highlight, 11)
		gradient(highlight, THEME.Accent1, THEME.Accent2, 0)

		create("UIGradient", {
			Color = ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1)),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.18),
				NumberSequenceKeypoint.new(1, 0.34),
			}),
			Parent = highlight
		})

		local iconLabel = create("ImageLabel", {
			Name = "Icon",
			Position = UDim2.fromOffset(11, 9),
			Size = UDim2.fromOffset(22, 22),
			BackgroundTransparency = 1,
			Image = icon or "",
			ImageColor3 = THEME.SubText,
			ZIndex = 2,
			Parent = button
		})

		local textLabel = create("TextLabel", {
			Name = "Text",
			Position = UDim2.fromOffset(42, 0),
			Size = UDim2.new(1, -50, 1, 0),
			BackgroundTransparency = 1,
			Text = name,
			TextColor3 = THEME.SubText,
			TextSize = 13,
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
			ScrollBarThickness = 3,
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
			Size = UDim2.new(0.5, -6, 1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent = columns
		})

		local rightColumn = create("Frame", {
			Name = "Right",
			Position = UDim2.new(0.5, 6, 0, 0),
			Size = UDim2.new(0.5, -6, 1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent = columns
		})

		local leftLayout = create("UIListLayout", {
			Padding = UDim.new(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = leftColumn
		})

		local rightLayout = create("UIListLayout", {
			Padding = UDim.new(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = rightColumn
		})

		local function refreshPageCanvas()
			local h = math.max(leftLayout.AbsoluteContentSize.Y, rightLayout.AbsoluteContentSize.Y)
			page.CanvasSize = UDim2.fromOffset(0, h + 4)
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
				catApi._LeftHeight += cardHeight + 12
				return leftColumn
			else
				catApi._RightHeight += cardHeight + 12
				return rightColumn
			end
		end

		function catApi:AddModule(moduleConfig)
			moduleConfig = moduleConfig or {}

			local card = create("Frame", {
				Name = moduleConfig.Name or "Module",
				Size = UDim2.new(1, 0, 0, 150),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = THEME.Card,
				ClipsDescendants = true,
				Parent = getTargetColumn(150)
			})
			corner(card, 14)
			local cardStroke = stroke(card, THEME.Stroke, 1, 0.14)

			local cardAccent = create("Frame", {
				Name = "Accent",
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.5, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, 2),
				BackgroundColor3 = THEME.Accent1,
				BackgroundTransparency = 0.35,
				Parent = card
			})
			gradient(cardAccent, THEME.Accent1, THEME.Accent2, 0)

			local container = create("Frame", {
				Name = "Container",
				Size = UDim2.new(1, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Parent = card
			})
			padding(container, 12, 12, 12, 12)

			local list = create("UIListLayout", {
				Padding = UDim.new(0, 9),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = container
			})

			local header = create("Frame", {
				Size = UDim2.new(1, 0, 0, 40),
				BackgroundTransparency = 1,
				Parent = container
			})

			create("TextLabel", {
				Size = UDim2.new(1, -52, 0, 18),
				BackgroundTransparency = 1,
				Text = moduleConfig.Name or "Module",
				TextColor3 = THEME.Text,
				TextSize = 15,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = header
			})

			create("TextLabel", {
				Position = UDim2.fromOffset(0, 20),
				Size = UDim2.new(1, -52, 0, 16),
				BackgroundTransparency = 1,
				Text = moduleConfig.Description or "Description",
				TextColor3 = THEME.SubText,
				TextSize = 11,
				Font = Enum.Font.Gotham,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = header
			})

			local mainToggle = create("TextButton", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -2, 0.5, 0),
				Size = UDim2.fromOffset(42, 22),
				BackgroundColor3 = Color3.fromRGB(40, 40, 48),
				Text = "",
				AutoButtonColor = false,
				Parent = header
			})
			corner(mainToggle, 999)
			stroke(mainToggle, THEME.SoftStroke, 1, 0.16)

			local mainKnob = create("Frame", {
				Position = UDim2.fromOffset(3, 3),
				Size = UDim2.fromOffset(16, 16),
				BackgroundColor3 = THEME.White,
				Parent = mainToggle
			})
			corner(mainKnob, 999)

			local moduleApi = {
				_Enabled = false,
				_Card = card,
				_Container = container,
				_List = list,
			}

			local function fit()
				card.Size = UDim2.new(1, 0, 0, math.max(150, list.AbsoluteContentSize.Y + 24))
				refreshPageCanvas()
			end

			list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fit)
			hoverFade(card, THEME.Card, THEME.CardHover, cardStroke, THEME.Accent2)

			local function setEnabled(state)
				moduleApi._Enabled = state

				if state then
					tween(mainToggle, TweenInfo.new(0.2), {BackgroundColor3 = THEME.Accent1})
					tween(mainKnob, TweenInfo.new(0.2), {Position = UDim2.fromOffset(23, 3)})
					tween(cardStroke, TweenInfo.new(0.2), {Color = THEME.Accent2})
					tween(cardAccent, TweenInfo.new(0.2), {BackgroundTransparency = 0.05})
				else
					tween(mainToggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 48)})
					tween(mainKnob, TweenInfo.new(0.2), {Position = UDim2.fromOffset(3, 3)})
					tween(cardStroke, TweenInfo.new(0.2), {Color = THEME.Stroke})
					tween(cardAccent, TweenInfo.new(0.2), {BackgroundTransparency = 0.35})
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
					Size = UDim2.new(1, 0, 0, 14),
					BackgroundTransparency = 1,
					Text = text or "Label",
					TextColor3 = THEME.SubText,
					TextSize = 11,
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
					Size = UDim2.new(1, 0, 0, 30),
					BackgroundTransparency = 1,
					Parent = container
				})

				create("TextLabel", {
					Size = UDim2.new(1, -52, 1, 0),
					BackgroundTransparency = 1,
					Text = opt.Name or "Toggle",
					TextColor3 = THEME.Text,
					TextSize = 12,
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = holder
				})

				local btn = create("TextButton", {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.fromOffset(38, 20),
					BackgroundColor3 = Color3.fromRGB(40, 40, 48),
					Text = "",
					AutoButtonColor = false,
					Parent = holder
				})
				corner(btn, 999)
				stroke(btn, THEME.SoftStroke, 1, 0.15)

				local dot = create("Frame", {
					Position = UDim2.fromOffset(3, 3),
					Size = UDim2.fromOffset(14, 14),
					BackgroundColor3 = THEME.White,
					Parent = btn
				})
				corner(dot, 999)

				local state = opt.Default or false

				local function render()
					if state then
						tween(btn, TweenInfo.new(0.18), {BackgroundColor3 = THEME.Accent1})
						tween(dot, TweenInfo.new(0.18), {Position = UDim2.fromOffset(21, 3)})
					else
						tween(btn, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(40, 40, 48)})
						tween(dot, TweenInfo.new(0.18), {Position = UDim2.fromOffset(3, 3)})
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
					Size = UDim2.new(1, 0, 0, 46),
					BackgroundTransparency = 1,
					Parent = container
				})

				create("TextLabel", {
					Size = UDim2.new(1, -46, 0, 16),
					BackgroundTransparency = 1,
					Text = opt.Name or "Slider",
					TextColor3 = THEME.Text,
					TextSize = 12,
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = holder
				})

				local valueLabel = create("TextLabel", {
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, 0, 0, 0),
					Size = UDim2.fromOffset(46, 16),
					BackgroundTransparency = 1,
					Text = tostring(value),
					TextColor3 = THEME.SubText,
					TextSize = 11,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Right,
					Parent = holder
				})

				local bar = create("Frame", {
					Position = UDim2.fromOffset(0, 25),
					Size = UDim2.new(1, 0, 0, 7),
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

				local knob = create("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0),
					Size = UDim2.fromOffset(11, 11),
					BackgroundColor3 = THEME.White,
					Parent = bar
				})
				corner(knob, 999)

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
					Size = UDim2.new(1, 0, 0, 34),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Parent = container
				})

				local main = create("TextButton", {
					Size = UDim2.new(1, 0, 0, 34),
					BackgroundColor3 = THEME.Section,
					Text = "",
					AutoButtonColor = false,
					Parent = holder
				})
				corner(main, 9)
				local mainStroke = stroke(main, THEME.SoftStroke, 1, 0.16)
				padding(main, 10, 10, 0, 0)
				hoverFade(main, THEME.Section, THEME.CardHover, mainStroke, THEME.Accent2)

				local text = create("TextLabel", {
					Size = UDim2.new(1, -20, 1, 0),
					BackgroundTransparency = 1,
					Text = string.format("%s: %s", opt.Name or "Dropdown", tostring(selected)),
					TextColor3 = THEME.Text,
					TextSize = 12,
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = main
				})

				local arrow = create("TextLabel", {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -2, 0.5, 0),
					Size = UDim2.fromOffset(14, 14),
					BackgroundTransparency = 1,
					Text = "▾",
					TextColor3 = THEME.SubText,
					TextSize = 13,
					Font = Enum.Font.GothamBold,
					Parent = main
				})

				local drop = create("Frame", {
					Position = UDim2.fromOffset(0, 39),
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = THEME.Section,
					Visible = false,
					ClipsDescendants = true,
					Parent = holder
				})
				corner(drop, 9)
				stroke(drop, THEME.SoftStroke, 1, 0.16)
				padding(drop, 7, 7, 7, 7)

				create("UIListLayout", {
					Padding = UDim.new(0, 5),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = drop
				})

				for _, item in ipairs(items) do
					local option = create("TextButton", {
						Size = UDim2.new(1, 0, 0, 26),
						BackgroundColor3 = THEME.Card,
						Text = tostring(item),
						TextColor3 = THEME.Text,
						TextSize = 11,
						Font = Enum.Font.Gotham,
						AutoButtonColor = false,
						Parent = drop
					})
					corner(option, 7)
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
					Size = UDim2.new(1, 0, 0, 30),
					BackgroundTransparency = 1,
					Parent = container
				})

				create("TextLabel", {
					Size = UDim2.new(1, -94, 1, 0),
					BackgroundTransparency = 1,
					Text = opt.Name or "Keybind",
					TextColor3 = THEME.Text,
					TextSize = 12,
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = holder
				})

				local bindButton = create("TextButton", {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.fromOffset(86, 28),
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
					TextSize = 11,
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Center,
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
						tween(bindButton, TweenInfo.new(0.16), {
							BackgroundColor3 = THEME.Accent1
						})
						tween(bindStroke, TweenInfo.new(0.16), {
							Color = THEME.Accent2
						})
					else
						bindText.Text = keyToText(currentKey)
						tween(bindButton, TweenInfo.new(0.16), {
							BackgroundColor3 = THEME.Section
						})
						tween(bindStroke, TweenInfo.new(0.16), {
							Color = THEME.SoftStroke
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
					Size = UDim2.new(1, 0, 0, 32),
					BackgroundColor3 = THEME.Section,
					Text = opt.Name or "Button",
					TextColor3 = THEME.Text,
					TextSize = 12,
					Font = Enum.Font.GothamMedium,
					AutoButtonColor = false,
					Parent = container
				})
				corner(button, 9)
				local buttonStroke = stroke(button, THEME.SoftStroke, 1, 0.16)
				hoverFade(button, THEME.Section, THEME.CardHover, buttonStroke, THEME.Accent2)

				button.MouseButton1Click:Connect(function()
					tween(button, TweenInfo.new(0.08), {
						BackgroundColor3 = THEME.Accent1
					})
					task.delay(0.1, function()
						if button and button.Parent then
							tween(button, TweenInfo.new(0.12), {
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
					Size = UDim2.new(1, 0, 0, 50),
					BackgroundTransparency = 1,
					Parent = container
				})

				create("TextLabel", {
					Size = UDim2.new(1, 0, 0, 16),
					BackgroundTransparency = 1,
					Text = opt.Name or "Textbox",
					TextColor3 = THEME.Text,
					TextSize = 12,
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = holder
				})

				local boxHolder = create("Frame", {
					Position = UDim2.fromOffset(0, 20),
					Size = UDim2.new(1, 0, 0, 28),
					BackgroundColor3 = THEME.Section,
					Parent = holder
				})
				corner(boxHolder, 9)
				local boxStroke = stroke(boxHolder, THEME.SoftStroke, 1, 0.16)

				local textBox = create("TextBox", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text = opt.Default or "",
					PlaceholderText = opt.Placeholder or "Enter text...",
					TextColor3 = THEME.Text,
					PlaceholderColor3 = THEME.SubText,
					TextSize = 12,
					Font = Enum.Font.Gotham,
					ClearTextOnFocus = false,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = boxHolder
				})
				padding(textBox, 10, 10, 0, 0)

				textBox.Focused:Connect(function()
					tween(boxHolder, TweenInfo.new(0.14), {
						BackgroundColor3 = THEME.CardHover
					})
					tween(boxStroke, TweenInfo.new(0.14), {
						Color = THEME.Accent2
					})
				end)

				textBox.FocusLost:Connect(function(enterPressed)
					tween(boxHolder, TweenInfo.new(0.14), {
						BackgroundColor3 = THEME.Section
					})
					tween(boxStroke, TweenInfo.new(0.14), {
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

	root.Size = UDim2.fromOffset(820, 510)
	root.BackgroundTransparency = 1
	tween(root, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Size = UDim2.fromOffset(860, 540),
		BackgroundTransparency = 0.12
	})

	return api
end

return ZenithLib
