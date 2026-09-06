-- ==========================================
-- Pulse Executor In-Game UI v5 (Full-featured)
-- ==========================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Remove existing GUI if any
if CoreGui:FindFirstChild("PulseExecutorGUI") then
    CoreGui.PulseExecutorGUI:Destroy()
end
if CoreGui:FindFirstChild("PulseFloatingIcon") then
    CoreGui.PulseFloatingIcon:Destroy()
end

-- Default Settings
local settingsData = {
    theme = "Purple",
    size = "normal",
    opacity = 0.0
}

-- Load saved settings if exist
pcall(function()
    if readfile and isfile and isfile("PulseSettings.json") then
        local content = readfile("PulseSettings.json")
        if string.find(content, "Blue") then settingsData.theme = "Blue"
        elseif string.find(content, "Emerald") then settingsData.theme = "Emerald"
        elseif string.find(content, "Red") then settingsData.theme = "Red" end
    end
end)

local function saveSettings()
    pcall(function()
        if writefile then
            local data = "theme=" .. settingsData.theme .. ",size=" .. settingsData.size .. ",opacity=" .. tostring(settingsData.opacity)
            writefile("PulseSettings.json", data)
        end
    end)
end

local themeColors = {
    Purple = Color3.fromRGB(139, 92, 246),
    Blue = Color3.fromRGB(37, 99, 235),
    Emerald = Color3.fromRGB(16, 185, 129),
    Red = Color3.fromRGB(239, 68, 68)
}

local currentThemeColor = themeColors[settingsData.theme] or themeColors.Purple

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PulseExecutorGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Floating Toggle Icon
local FloatingIcon = Instance.new("TextButton")
FloatingIcon.Name = "PulseFloatingIcon"
FloatingIcon.Parent = ScreenGui
FloatingIcon.BackgroundColor3 = Color3.fromRGB(15, 17, 23)
FloatingIcon.Position = UDim2.new(0, 20, 0.5, -25)
FloatingIcon.Size = UDim2.new(0, 48, 0, 48)
FloatingIcon.Font = Enum.Font.GothamBold
FloatingIcon.Text = "</>"
FloatingIcon.TextColor3 = currentThemeColor
FloatingIcon.TextSize = 14
FloatingIcon.Active = true
FloatingIcon.Draggable = true
FloatingIcon.Visible = false

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = FloatingIcon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = currentThemeColor
IconStroke.Thickness = 2
IconStroke.Parent = FloatingIcon

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 17, 23)
MainFrame.BackgroundTransparency = settingsData.opacity
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
MainFrame.Size = settingsData.size == "small" and UDim2.new(0, 520, 0, 350) or (settingsData.size == "large" and UDim2.new(0, 720, 0, 500) or UDim2.new(0, 620, 0, 420))
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = currentThemeColor
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(18, 21, 28)
TopBar.Size = UDim2.new(1, 0, 0, 38)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local TopFix = Instance.new("Frame")
TopFix.Parent = TopBar
TopFix.BackgroundColor3 = Color3.fromRGB(18, 21, 28)
TopFix.Position = UDim2.new(0, 0, 0.7, 0)
TopFix.Size = UDim2.new(1, 0, 0.3, 0)
TopFix.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "</> PULSE // EXECUTOR"
Title.TextColor3 = currentThemeColor
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -9)
CloseBtn.Size = UDim2.new(0, 18, 0, 18)
CloseBtn.Text = ""
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatingIcon.Visible = true
end)

FloatingIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    FloatingIcon.Visible = false
end)

-- Sidebar Navigation (Tabs)
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 21, 28)
Sidebar.Position = UDim2.new(0, 0, 0, 38)
Sidebar.Size = UDim2.new(0, 55, 1, -38)

local function createNavButton(posY, iconText)
    local btn = Instance.new("TextButton")
    btn.Parent = Sidebar
    btn.BackgroundColor3 = Color3.fromRGB(25, 29, 38)
    btn.Position = UDim2.new(0, 8, 0, posY)
    btn.Size = UDim2.new(0, 38, 0, 38)
    btn.Font = Enum.Font.GothamBold
    btn.Text = iconText
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 14
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    return btn
end

local EditorTabBtn = createNavButton(12, "</>")
local SavedTabBtn = createNavButton(60, "📁")
local SettingsTabBtn = createNavButton(108, "⚙️")

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 60, 0, 45)
ContentContainer.Size = UDim2.new(1, -70, 1, -55)

-- 1. EDITOR PANEL
local EditorPanel = Instance.new("Frame")
EditorPanel.Parent = ContentContainer
EditorPanel.BackgroundTransparency = 1
EditorPanel.Size = UDim2.new(1, 0, 1, 0)
EditorPanel.Visible = true

local EditorBox = Instance.new("TextBox")
EditorBox.Parent = EditorPanel
EditorBox.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
EditorBox.Size = UDim2.new(1, 0, 1, -50)
EditorBox.ClearTextOnFocus = false
EditorBox.MultiLine = true
EditorBox.Font = Enum.Font.Code
EditorBox.Text = "-- Welcome to Pulse Executor\nprint('Pulse loaded successfully!')\n\nlocal player = game.Players.LocalPlayer\nprint('Player: ' .. player.Name)"
EditorBox.TextColor3 = Color3.fromRGB(226, 232, 240)
EditorBox.TextSize = 13
EditorBox.TextXAlignment = Enum.TextXAlignment.Left
EditorBox.TextYAlignment = Enum.TextYAlignment.Top

local EditorCorner = Instance.new("UICorner")
EditorCorner.CornerRadius = UDim.new(0, 6)
EditorCorner.Parent = EditorBox

-- Save Modal
local SaveModal = Instance.new("Frame")
SaveModal.Parent = EditorPanel
SaveModal.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
SaveModal.BackgroundTransparency = 0.1
SaveModal.Size = UDim2.new(1, 0, 1, 0)
SaveModal.Visible = false
SaveModal.ZIndex = 10

local ModalBox = Instance.new("Frame")
ModalBox.Parent = SaveModal
ModalBox.BackgroundColor3 = Color3.fromRGB(20, 24, 33)
ModalBox.Position = UDim2.new(0.5, -150, 0.5, -75)
ModalBox.Size = UDim2.new(0, 300, 0, 130)
local mCorner = Instance.new("UICorner")
mCorner.CornerRadius = UDim.new(0, 8)
mCorner.Parent = ModalBox
local mStroke = Instance.new("UIStroke")
mStroke.Color = currentThemeColor
mStroke.Thickness = 1.5
mStroke.Parent = ModalBox

local mTitle = Instance.new("TextLabel")
mTitle.Parent = ModalBox
mTitle.BackgroundTransparency = 1
mTitle.Position = UDim2.new(0, 15, 0, 10)
mTitle.Size = UDim2.new(1, -30, 0, 25)
mTitle.Font = Enum.Font.GothamBold
mTitle.Text = "Save Script As..."
mTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
mTitle.TextSize = 13
mTitle.TextXAlignment = Enum.TextXAlignment.Left

local NameInput = Instance.new("TextBox")
NameInput.Parent = ModalBox
NameInput.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
NameInput.Position = UDim2.new(0, 15, 0, 45)
NameInput.Size = UDim2.new(1, -30, 0, 32)
NameInput.Font = Enum.Font.GothamMedium
NameInput.PlaceholderText = "Enter script name"
NameInput.Text = ""
NameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
NameInput.TextSize = 12
local nCorner = Instance.new("UICorner")
nCorner.CornerRadius = UDim.new(0, 6)
nCorner.Parent = NameInput

local ConfirmSaveBtn = Instance.new("TextButton")
ConfirmSaveBtn.Parent = ModalBox
ConfirmSaveBtn.BackgroundColor3 = currentThemeColor
ConfirmSaveBtn.Position = UDim2.new(0, 15, 0, 85)
ConfirmSaveBtn.Size = UDim2.new(0, 130, 0, 30)
ConfirmSaveBtn.Font = Enum.Font.GothamBold
ConfirmSaveBtn.Text = "Save"
ConfirmSaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmSaveBtn.TextSize = 12
local csCorner = Instance.new("UICorner")
csCorner.CornerRadius = UDim.new(0, 6)
csCorner.Parent = ConfirmSaveBtn

local CancelSaveBtn = Instance.new("TextButton")
CancelSaveBtn.Parent = ModalBox
CancelSaveBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
CancelSaveBtn.Position = UDim2.new(1, -145, 0, 85)
CancelSaveBtn.Size = UDim2.new(0, 130, 0, 30)
CancelSaveBtn.Font = Enum.Font.GothamBold
CancelSaveBtn.Text = "Cancel"
CancelSaveBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CancelSaveBtn.TextSize = 12
local canCorner = Instance.new("UICorner")
canCorner.CornerRadius = UDim.new(0, 6)
canCorner.Parent = CancelSaveBtn

CancelSaveBtn.MouseButton1Click:Connect(function()
    SaveModal.Visible = false
end)

ConfirmSaveBtn.MouseButton1Click:Connect(function()
    local name = NameInput.Text
    if name ~= "" then
        if not string.match(name, "%.lua$") then
            name = name .. ".lua"
        end
        pcall(function()
            if writefile then
                writefile(name, EditorBox.Text)
            end
        end)
    end
    SaveModal.Visible = false
end)

local EditorBottom = Instance.new("Frame")
EditorBottom.Parent = EditorPanel
EditorBottom.BackgroundTransparency = 1
EditorBottom.Position = UDim2.new(0, 0, 1, -40)
EditorBottom.Size = UDim2.new(1, 0, 0, 40)

local function createActionButton(name, posX, color)
    local btn = Instance.new("TextButton")
    btn.Parent = EditorBottom
    btn.BackgroundColor3 = color
    btn.Position = UDim2.new(0, posX, 0, 0)
    btn.Size = UDim2.new(0, 95, 0, 32)
    btn.Font = Enum.Font.GothamBold
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local ExecuteBtn = createActionButton("Execute", 0, currentThemeColor)
local ClearBtn = createActionButton("Clear", 105, Color3.fromRGB(35, 40, 50))
local SaveBtn = createActionButton("Save Script", 210, Color3.fromRGB(35, 40, 50))

ExecuteBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local func = loadstring(EditorBox.Text)
        if func then func() end
    end)
end)

ClearBtn.MouseButton1Click:Connect(function()
    EditorBox.Text = ""
end)

SaveBtn.MouseButton1Click:Connect(function()
    NameInput.Text = "MyScript.lua"
    SaveModal.Visible = true
    NameInput:CaptureFocus()
end)

-- 2. SAVED SCRIPTS PANEL
local SavedPanel = Instance.new("ScrollingFrame")
SavedPanel.Parent = ContentContainer
SavedPanel.BackgroundTransparency = 1
SavedPanel.Size = UDim2.new(1, 0, 1, 0)
SavedPanel.Visible = false
SavedPanel.CanvasSize = UDim2.new(0, 0, 0, 400)
SavedPanel.ScrollBarThickness = 3

local savedTitle = Instance.new("TextLabel")
savedTitle.Parent = SavedPanel
savedTitle.BackgroundTransparency = 1
savedTitle.Size = UDim2.new(1, 0, 0, 30)
savedTitle.Font = Enum.Font.GothamBold
savedTitle.Text = "Saved Scripts Manager"
savedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
savedTitle.TextSize = 14
savedTitle.TextXAlignment = Enum.TextXAlignment.Left

local ListContainer = Instance.new("ScrollingFrame")
ListContainer.Parent = SavedPanel
ListContainer.BackgroundTransparency = 1
ListContainer.Position = UDim2.new(0, 0, 0, 40)
ListContainer.Size = UDim2.new(1, 0, 1, -50)
ListContainer.CanvasSize = UDim2.new(0, 0, 0, 500)

local function refreshSavedScripts()
    for _, child in ipairs(ListContainer:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    local files = {}
    pcall(function()
        if listfiles then
            for _, file in ipairs(listfiles("")) do
                if string.match(file, "%.lua$") and file ~= "PulseSettings.json" then
                    table.insert(files, file)
                end
            end
        end
    end)
    
    if #files == 0 then
        files = {"MyScript.lua", "FlyScript.lua", "AdminCommands.lua"}
    end
    
    local yPos = 0
    for _, fileName in ipairs(files) do
        local item = Instance.new("Frame")
        item.Parent = ListContainer
        item.BackgroundColor3 = Color3.fromRGB(20, 24, 33)
        item.Position = UDim2.new(0, 0, 0, yPos)
        item.Size = UDim2.new(1, -10, 0, 45)
        local iCorner = Instance.new("UICorner")
        iCorner.CornerRadius = UDim.new(0, 6)
        iCorner.Parent = item
        
        local nameLbl = Instance.new("TextLabel")
        nameLbl.Parent = item
        nameLbl.BackgroundTransparency = 1
        nameLbl.Position = UDim2.new(0, 12, 0, 0)
        nameLbl.Size = UDim2.new(0, 200, 1, 0)
        nameLbl.Font = Enum.Font.GothamMedium
        nameLbl.Text = fileName
        nameLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
        nameLbl.TextSize = 12
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        
        local execBtn = Instance.new("TextButton")
        execBtn.Parent = item
        execBtn.BackgroundColor3 = currentThemeColor
        execBtn.Position = UDim2.new(1, -170, 0.5, -14)
        execBtn.Size = UDim2.new(0, 75, 0, 28)
        execBtn.Font = Enum.Font.GothamBold
        execBtn.Text = "Execute"
        execBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        execBtn.TextSize = 11
        local eCorner = Instance.new("UICorner")
        eCorner.CornerRadius = UDim.new(0, 4)
        eCorner.Parent = execBtn
        
        execBtn.MouseButton1Click:Connect(function()
            pcall(function()
                local code = readfile and readfile(fileName) or "-- print('Executed')"
                loadstring(code)()
            end)
        end)
        
        local delBtn = Instance.new("TextButton")
        delBtn.Parent = item
        delBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
        delBtn.Position = UDim2.new(1, -85, 0.5, -14)
        delBtn.Size = UDim2.new(0, 75, 0, 28)
        delBtn.Font = Enum.Font.GothamBold
        delBtn.Text = "Delete"
        delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        delBtn.TextSize = 11
        local dCorner = Instance.new("UICorner")
        dCorner.CornerRadius = UDim.new(0, 4)
        dCorner.Parent = delBtn
        
        delBtn.MouseButton1Click:Connect(function()
            pcall(function()
                if delfile then delfile(fileName) end
            end)
            refreshSavedScripts()
        end)
        
        yPos = yPos + 52
    end
end

-- 3. ADVANCED SETTINGS PANEL
local SettingsPanel = Instance.new("ScrollingFrame")
SettingsPanel.Parent = ContentContainer
SettingsPanel.BackgroundTransparency = 1
SettingsPanel.Size = UDim2.new(1, 0, 1, 0)
SettingsPanel.Visible = false
SettingsPanel.CanvasSize = UDim2.new(0, 0, 0, 450)
SettingsPanel.ScrollBarThickness = 3

local stTitle = Instance.new("TextLabel")
stTitle.Parent = SettingsPanel
stTitle.BackgroundTransparency = 1
stTitle.Size = UDim2.new(1, 0, 0, 30)
stTitle.Font = Enum.Font.GothamBold
stTitle.Text = "Advanced Settings & Customization"
stTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
stTitle.TextSize = 14
stTitle.TextXAlignment = Enum.TextXAlignment.Left

local function createSettingLabel(text, yPos)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = SettingsPanel
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 0, 0, yPos)
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.Font = Enum.Font.GothamMedium
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
end

createSettingLabel("Theme Accent Color:", 40)
local function createColorBtn(posX, colorName, colorObj)
    local btn = Instance.new("TextButton")
    btn.Parent = SettingsPanel
    btn.BackgroundColor3 = colorObj
    btn.Position = UDim2.new(0, posX, 0, 65)
    btn.Size = UDim2.new(0, 75, 0, 30)
    btn.Font = Enum.Font.GothamBold
    btn.Text = colorName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        settingsData.theme = colorName
        currentThemeColor = colorObj
        MainStroke.Color = colorObj
        IconStroke.Color = colorObj
        FloatingIcon.TextColor3 = colorObj
        Title.TextColor3 = colorObj
        ExecuteBtn.BackgroundColor3 = colorObj
        ConfirmSaveBtn.BackgroundColor3 = colorObj
        mStroke.Color = colorObj
        saveSettings()
    end)
end

createColorBtn(0, "Purple", themeColors.Purple)
createColorBtn(85, "Blue", themeColors.Blue)
createColorBtn(170, "Emerald", themeColors.Emerald)
createColorBtn(255, "Red", themeColors.Red)

createSettingLabel("UI Window Size:", 115)
local function createScaleBtn(posX, sizeVal, name)
    local btn = Instance.new("TextButton")
    btn.Parent = SettingsPanel
    btn.BackgroundColor3 = Color3.fromRGB(25, 29, 38)
    btn.Position = UDim2.new(0, posX, 0, 140)
    btn.Size = UDim2.new(0, 75, 0, 30)
    btn.Font = Enum.Font.GothamBold
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 11
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        settingsData.size = sizeVal
        if sizeVal == "small" then
            MainFrame.Size = UDim2.new(0, 520, 0, 350)
        elseif sizeVal == "normal" then
            MainFrame.Size = UDim2.new(0, 620, 0, 420)
        elseif sizeVal == "large" then
            MainFrame.Size = UDim2.new(0, 720, 0, 500)
        end
        saveSettings()
    end)
end

createScaleBtn(0, "small", "Compact")
createScaleBtn(85, "normal", "Normal")
createScaleBtn(170, "large", "Large")

createSettingLabel("Background Opacity:", 190)
local function createOpacityBtn(posX, transVal, name)
    local btn = Instance.new("TextButton")
    btn.Parent = SettingsPanel
    btn.BackgroundColor3 = Color3.fromRGB(25, 29, 38)
    btn.Position = UDim2.new(0, posX, 0, 215)
    btn.Size = UDim2.new(0, 75, 0, 30)
    btn.Font = Enum.Font.GothamBold
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 11
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        settingsData.opacity = transVal
        MainFrame.BackgroundTransparency = transVal
        saveSettings()
    end)
end

createOpacityBtn(0, 0.0, "Solid")
createOpacityBtn(85, 0.15, "Medium")
createOpacityBtn(170, 0.35, "Glass")

createSettingLabel("System Controls:", 265)
local unloadBtn = Instance.new("TextButton")
unloadBtn.Parent = SettingsPanel
unloadBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
unloadBtn.Position = UDim2.new(0, 0, 0, 290)
unloadBtn.Size = UDim2.new(0, 160, 0, 32)
unloadBtn.Font = Enum.Font.GothamBold
unloadBtn.Text = "Unload Pulse GUI"
unloadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
unloadBtn.TextSize = 12
local uCorner = Instance.new("UICorner")
uCorner.CornerRadius = UDim.new(0, 6)
uCorner.Parent = unloadBtn

unloadBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    FloatingIcon:Destroy()
end)

-- Tab switching logic
EditorTabBtn.MouseButton1Click:Connect(function()
    EditorPanel.Visible = true
    SavedPanel.Visible = false
    SettingsPanel.Visible = false
end)

SavedTabBtn.MouseButton1Click:Connect(function()
    EditorPanel.Visible = false
    SavedPanel.Visible = true
    SettingsPanel.Visible = false
    refreshSavedScripts()
end)

SettingsTabBtn.MouseButton1Click:Connect(function()
    EditorPanel.Visible = false
    SavedPanel.Visible = false
    SettingsPanel.Visible = true
end)

print("Pulse Executor v5 loaded successfully!")
