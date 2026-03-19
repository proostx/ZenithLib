```md
# ZenithLib Classic

Minimal classic-style Roblox UI library with a strict utility look, compact layout and polished micro-animations.

## Loadstring
```lua
local ZenithClassic = loadstring(game:HttpGet("https://raw.githubusercontent.com/proostx/ZenithLib/refs/heads/main/ZenithLib.lua"))()
```

---

# Features

- Classic utility/box-style interface
- Tabs
- Left / right groupboxes
- Toggle
- Slider
- Dropdown
- Keybind
- Button
- Textbox
- Label
- Divider
- Smooth tab underline animation
- Compact classic visuals

---

# Basic Usage

```lua
local ZenithClassic = loadstring(game:HttpGet("https://raw.githubusercontent.com/proostx/ZenithLib/refs/heads/main/ZenithLib.lua"))()

local Window = ZenithClassic:CreateWindow({
	Title = "ZenithLib Classic",
	Name = "ZenithWindow"
})

local Main = Window:AddTab("Main")
local Left = Main:AddLeftGroupbox("Player")
local Right = Main:AddRightGroupbox("Misc")
```

---

# API

## `CreateWindow`

Creates the main window.

```lua
local Window = ZenithClassic:CreateWindow({
	Title = "My Window",
	Name = "MyWindow"
})
```

### Parameters
| Name | Type | Description |
|------|------|-------------|
| `Title` | `string` | Window title |
| `Name` | `string` | ScreenGui name |

---

## `Window:AddTab(name)`

Creates a top tab.

```lua
local Tab = Window:AddTab("Visuals")
```

### Parameters
| Name | Type | Description |
|------|------|-------------|
| `name` | `string` | Tab title |

---

## `Tab:AddLeftGroupbox(title)`

Creates a groupbox in the left column.

```lua
local LeftBox = Tab:AddLeftGroupbox("ESP")
```

---

## `Tab:AddRightGroupbox(title)`

Creates a groupbox in the right column.

```lua
local RightBox = Tab:AddRightGroupbox("Misc")
```

---

# Groupbox Elements

## `AddLabel(text)`

```lua
Group:AddLabel("Some text")
```

---

## `AddDivider(text)`

```lua
Group:AddDivider("Section")
```

---

## `AddToggle(name, options)`

```lua
Group:AddToggle("Enabled", {
	Default = false,
	Callback = function(value)
		print(value)
	end
})
```

### Options
| Name | Type | Description |
|------|------|-------------|
| `Default` | `boolean` | Default state |
| `Callback` | `function` | Called when value changes |

---

## `AddSlider(name, options)`

```lua
Group:AddSlider("FOV", {
	Min = 60,
	Max = 120,
	Default = 70,
	Callback = function(value)
		print(value)
	end
})
```

### Options
| Name | Type | Description |
|------|------|-------------|
| `Min` | `number` | Minimum value |
| `Max` | `number` | Maximum value |
| `Default` | `number` | Default value |
| `Callback` | `function` | Called when value changes |

---

## `AddDropdown(name, options)`

```lua
Group:AddDropdown("Target Part", {
	Items = {"Head", "Torso", "Closest"},
	Default = "Head",
	Callback = function(value)
		print(value)
	end
})
```

### Options
| Name | Type | Description |
|------|------|-------------|
| `Items` | `{string}` | Dropdown items |
| `Default` | `string` | Default selected item |
| `Callback` | `function` | Called when selection changes |

---

## `AddKeybind(name, options)`

```lua
Group:AddKeybind("Menu Key", {
	Default = Enum.KeyCode.RightControl,
	Callback = function(key)
		print(key)
	end
})
```

### Options
| Name | Type | Description |
|------|------|-------------|
| `Default` | `Enum.KeyCode` | Default key |
| `Callback` | `function` | Called when key changes |

### Important
`Default` must be an `Enum.KeyCode`, **not** a string.

### Correct
```lua
Default = Enum.KeyCode.RightControl
```

### Wrong
```lua
Default = "RightControl"
```

---

## `AddButton(name, options)`

```lua
Group:AddButton("Unload Script", {
	Callback = function()
		print("Clicked")
	end
})
```

### Options
| Name | Type | Description |
|------|------|-------------|
| `Callback` | `function` | Called on click |

### Important
`AddButton` expects a **table** as the second argument.

### Correct
```lua
Group:AddButton("Save", {
	Callback = function()
		print("saved")
	end
})
```

### Wrong
```lua
Group:AddButton("Save", function()
	print("saved")
end)
```

---

## `AddTextbox(name, options)`

```lua
Group:AddTextbox("Config Name", {
	Default = "",
	Placeholder = "Enter name...",
	Callback = function(text, enterPressed)
		print(text, enterPressed)
	end
})
```

### Options
| Name | Type | Description |
|------|------|-------------|
| `Default` | `string` | Default text |
| `Placeholder` | `string` | Placeholder text |
| `Callback` | `function` | Called when focus is lost |

---

# Full Example

```lua
local ZenithClassic = loadstring(game:HttpGet("https://raw.githubusercontent.com/proostx/ZenithLib/refs/heads/main/ZenithLib.lua"))()

local Window = ZenithClassic:CreateWindow({
	Title = "Demo",
	Name = "DemoUI"
})

local Main = Window:AddTab("Main")
local Left = Main:AddLeftGroupbox("Player")
local Right = Main:AddRightGroupbox("Misc")

Left:AddToggle("Enabled", {
	Default = true,
	Callback = function(v)
		print("Enabled:", v)
	end
})

Left:AddSlider("FOV", {
	Min = 60,
	Max = 120,
	Default = 70,
	Callback = function(v)
		print("FOV:", v)
	end
})

Left:AddDropdown("Mode", {
	Items = {"A", "B", "C"},
	Default = "A",
	Callback = function(v)
		print("Mode:", v)
	end
})

local MenuKey = Enum.KeyCode.RightControl

Left:AddKeybind("Menu Key", {
	Default = Enum.KeyCode.RightControl,
	Callback = function(key)
		MenuKey = key
	end
})

Right:AddTextbox("Config Name", {
	Placeholder = "Enter config...",
	Callback = function(text, enterPressed)
		print("Textbox:", text, enterPressed)
	end
})

Right:AddButton("Print Hello", {
	Callback = function()
		print("Hello")
	end
})
```

---

# Menu Toggle Example

If you want to toggle the GUI with a keybind:

```lua
local UserInputService = game:GetService("UserInputService")

local MenuKey = Enum.KeyCode.RightControl

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.KeyCode == MenuKey then
		Window._Gui.Enabled = not Window._Gui.Enabled
	end
end)
```

---

# Common Mistakes

## 1. Wrong `AddButton` usage

### Wrong
```lua
Group:AddButton("Text", function() end)
```

### Correct
```lua
Group:AddButton("Text", {
	Callback = function() end
})
```

---

## 2. Wrong `AddKeybind` default

### Wrong
```lua
Default = "RightControl"
```

### Correct
```lua
Default = Enum.KeyCode.RightControl
```

---

## 3. Storing keybind as string

### Wrong
```lua
local MenuKey = "RightControl"
```

### Correct
```lua
local MenuKey = Enum.KeyCode.RightControl
```

---

## 4. Comparing input incorrectly

### Wrong
```lua
if input.KeyCode.Name == MenuKey then
```

### Correct
```lua
if input.KeyCode == MenuKey then
```

---

# Notes

- This library uses a compact classic UI style.
- Button callbacks are table-based.
- Keybinds should always use `Enum.KeyCode`.
- The current API is intentionally simple and strict.

---

# Minimal Template For AI / Code Generators

Use these rules when generating scripts for `ZenithLib Classic`:

- Use `CreateWindow`, `AddTab`, `AddLeftGroupbox`, `AddRightGroupbox`
- `AddButton` must always be:
```lua
AddButton("Text", { Callback = function() end })
```
- `AddKeybind.Default` must be `Enum.KeyCode.*`
- Store keybind values as `Enum.KeyCode`
- `AddToggle`, `AddSlider`, `AddDropdown`, `AddTextbox` use option tables
- Do not invent unsupported fields unless the library explicitly supports them

---
```
