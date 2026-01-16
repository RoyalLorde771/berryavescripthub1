--[[
    BERRY AVE ULTIMATE HUB
    Premium Script Hub with Enhanced UI and Optimized Performance
    Version 2.0
]]

-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- Color scheme with improved palette
local COLORS = table.freeze({
    bg = Color3.fromRGB(12, 12, 15),
    card = Color3.fromRGB(20, 20, 25),
    cardHover = Color3.fromRGB(25, 25, 32),
    accent = Color3.fromRGB(138, 43, 226),
    accentLight = Color3.fromRGB(160, 60, 255),
    accentDark = Color3.fromRGB(100, 30, 180),
    text = Color3.fromRGB(250, 250, 250),
    textDim = Color3.fromRGB(160, 160, 170),
    success = Color3.fromRGB(0, 220, 110),
    danger = Color3.fromRGB(240, 60, 60),
    warning = Color3.fromRGB(255, 180, 0),
    border = Color3.fromRGB(40, 40, 50)
})

-- Utility Functions
local Utils = {}

function Utils.createTween(instance, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    return TweenService:Create(instance, tweenInfo, properties)
end

function Utils.createCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    return corner
end

function Utils.createStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or COLORS.border
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
end

function Utils.formatNumber(num)
    if num >= 1000000 then
        return string.format("%.2fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num / 1000)
    end
    return tostring(num)
end

function Utils.debounce(func, delay)
    local isRunning = false
    return function(...)
        if isRunning then return end
        isRunning = true
        local args = {...}
        task.spawn(function()
            func(table.unpack(args))
            task.wait(delay)
            isRunning = false
        end)
    end
end

-- Connection Manager
local ConnectionManager = {}
ConnectionManager.connections = {}

function ConnectionManager:add(connection)
    table.insert(self.connections, connection)
    return connection
end

function ConnectionManager:cleanup()
    for _, conn in ipairs(self.connections) do
        if conn and conn.Connected then
            conn:Disconnect()
        end
    end
    table.clear(self.connections)
end

-- Main Hub GUI Creation
local function createHubGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BerryAveHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui

    -- Main container with improved styling
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 480, 0, 560)
    MainFrame.Position = UDim2.new(0.5, -240, 0.5, -280)
    MainFrame.BackgroundColor3 = COLORS.bg
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    MainFrame.ClipsDescendants = true

    Utils.createCorner(14).Parent = MainFrame
    Utils.createStroke(MainFrame, COLORS.border, 1.5)

    -- Enhanced animated gradient background
    local Gradient = Instance.new("Frame")
    Gradient.Size = UDim2.new(1, 0, 1, 0)
    Gradient.BackgroundTransparency = 0.95
    Gradient.BorderSizePixel = 0
    Gradient.ZIndex = 0
    Gradient.Parent = MainFrame

    local GradientUI = Instance.new("UIGradient")
    GradientUI.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, COLORS.accent),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 80, 255)),
        ColorSequenceKeypoint.new(1, COLORS.accent)
    }
    GradientUI.Rotation = 45
    GradientUI.Parent = Gradient

    -- Smooth gradient animation
    task.spawn(function()
        local rotation = 0
        while Gradient.Parent do
            rotation = (rotation + 1.5) % 360
            GradientUI.Rotation = rotation
            task.wait(0.02)
        end
    end)

    -- Header with improved design
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 75)
    Header.BackgroundColor3 = COLORS.card
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    Utils.createCorner(14).Parent = Header
    local headerStroke = Utils.createStroke(Header, COLORS.border, 1)
    headerStroke.Transparency = 0.5

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -80, 0, 32)
    Title.Position = UDim2.new(0, 20, 0, 12)
    Title.BackgroundTransparency = 1
    Title.Text = "BERRY AVE ULTIMATE"
    Title.TextColor3 = COLORS.text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, -80, 0, 22)
    Subtitle.Position = UDim2.new(0, 20, 0, 44)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "Premium Script Hub • Enhanced Edition"
    Subtitle.TextColor3 = COLORS.textDim
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextSize = 11
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = Header

    -- Enhanced close button with hover effects
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 38, 0, 38)
    CloseBtn.Position = UDim2.new(1, -50, 0, 18)
    CloseBtn.BackgroundColor3 = COLORS.card
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = COLORS.text
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 26
    CloseBtn.Parent = Header

    Utils.createCorner(19).Parent = CloseBtn

    local closeHover = false
    CloseBtn.MouseEnter:Connect(function()
        closeHover = true
        Utils.createTween(CloseBtn, {BackgroundColor3 = COLORS.danger, Size = UDim2.new(0, 42, 0, 42)}):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        closeHover = false
        Utils.createTween(CloseBtn, {BackgroundColor3 = COLORS.card, Size = UDim2.new(0, 38, 0, 38)}):Play()
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        local tween = Utils.createTween(MainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        tween:Play()
        tween.Completed:Wait()
        ScreenGui:Destroy()
    end)

    -- Scripts container with improved scrolling
    local ScriptsContainer = Instance.new("ScrollingFrame")
    ScriptsContainer.Size = UDim2.new(1, -30, 1, -110)
    ScriptsContainer.Position = UDim2.new(0, 15, 0, 85)
    ScriptsContainer.BackgroundTransparency = 1
    ScriptsContainer.BorderSizePixel = 0
    ScriptsContainer.ScrollBarThickness = 5
    ScriptsContainer.ScrollBarImageColor3 = COLORS.accent
    ScriptsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScriptsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScriptsContainer.Parent = MainFrame

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 14)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = ScriptsContainer

    -- Enhanced script card creation
    local function createScriptCard(title, description, color, scriptFunc, icon)
        local Card = Instance.new("Frame")
        Card.Size = UDim2.new(1, -10, 0, 120)
        Card.BackgroundColor3 = COLORS.card
        Card.BorderSizePixel = 0
        Card.Parent = ScriptsContainer

        Utils.createCorner(12).Parent = Card
        Utils.createStroke(Card, COLORS.border, 1)

        -- Hover effect
        local originalSize = Card.Size
        Card.MouseEnter:Connect(function()
            Utils.createTween(Card, {BackgroundColor3 = COLORS.cardHover, Size = originalSize + UDim2.new(0, 4, 0, 4)}):Play()
        end)
        Card.MouseLeave:Connect(function()
            Utils.createTween(Card, {BackgroundColor3 = COLORS.card, Size = originalSize}):Play()
        end)

        -- Accent line with glow effect
        local AccentLine = Instance.new("Frame")
        AccentLine.Size = UDim2.new(0, 5, 1, -10)
        AccentLine.Position = UDim2.new(0, 5, 0, 5)
        AccentLine.BackgroundColor3 = color
        AccentLine.BorderSizePixel = 0
        AccentLine.Parent = Card

        Utils.createCorner(12).Parent = AccentLine

        -- Card title
        local CardTitle = Instance.new("TextLabel")
        CardTitle.Size = UDim2.new(1, -80, 0, 28)
        CardTitle.Position = UDim2.new(0, 20, 0, 12)
        CardTitle.BackgroundTransparency = 1
        CardTitle.Text = title
        CardTitle.TextColor3 = COLORS.text
        CardTitle.Font = Enum.Font.GothamBold
        CardTitle.TextSize = 16
        CardTitle.TextXAlignment = Enum.TextXAlignment.Left
        CardTitle.Parent = Card

        -- Description with better formatting
        local Desc = Instance.new("TextLabel")
        Desc.Size = UDim2.new(1, -80, 0, 50)
        Desc.Position = UDim2.new(0, 20, 0, 40)
        Desc.BackgroundTransparency = 1
        Desc.Text = description
        Desc.TextColor3 = COLORS.textDim
        Desc.Font = Enum.Font.Gotham
        Desc.TextSize = 11
        Desc.TextXAlignment = Enum.TextXAlignment.Left
        Desc.TextYAlignment = Enum.TextYAlignment.Top
        Desc.TextWrapped = true
        Desc.LineHeight = 1.2
        Desc.Parent = Card

        -- Enhanced execute button
        local ExecuteBtn = Instance.new("TextButton")
        ExecuteBtn.Size = UDim2.new(1, -30, 0, 32)
        ExecuteBtn.Position = UDim2.new(0, 15, 1, -40)
        ExecuteBtn.BackgroundColor3 = color
        ExecuteBtn.BorderSizePixel = 0
        ExecuteBtn.Text = "EXECUTE"
        ExecuteBtn.TextColor3 = COLORS.text
        ExecuteBtn.Font = Enum.Font.GothamBold
        ExecuteBtn.TextSize = 13
        ExecuteBtn.Parent = Card

        Utils.createCorner(8).Parent = ExecuteBtn

        local originalBtnColor = color
        ExecuteBtn.MouseEnter:Connect(function()
            local lightColor = Color3.fromRGB(
                math.min(color.R * 255 + 25, 255),
                math.min(color.G * 255 + 25, 255),
                math.min(color.B * 255 + 25, 255)
            )
            Utils.createTween(ExecuteBtn, {BackgroundColor3 = lightColor}):Play()
        end)
        ExecuteBtn.MouseLeave:Connect(function()
            Utils.createTween(ExecuteBtn, {BackgroundColor3 = originalBtnColor}):Play()
        end)

        ExecuteBtn.MouseButton1Click:Connect(function()
            ExecuteBtn.Text = "EXECUTING..."
            ExecuteBtn.BackgroundColor3 = COLORS.textDim
            ExecuteBtn.AutoButtonColor = false

            task.spawn(function()
                local success, err = pcall(scriptFunc)
                task.wait(0.6)

                if success then
                    ExecuteBtn.Text = "✓ EXECUTED"
                    ExecuteBtn.BackgroundColor3 = COLORS.success
                else
                    ExecuteBtn.Text = "✗ ERROR"
                    ExecuteBtn.BackgroundColor3 = COLORS.danger
                    warn("Script error:", err)
                end

                task.wait(2.5)
                ExecuteBtn.Text = "EXECUTE"
                ExecuteBtn.BackgroundColor3 = originalBtnColor
                ExecuteBtn.AutoButtonColor = true
            end)
        end)

        return Card
    end

    -- Status bar with improved design
    local StatusBar = Instance.new("Frame")
    StatusBar.Size = UDim2.new(1, -20, 0, 28)
    StatusBar.Position = UDim2.new(0, 10, 1, -30)
    StatusBar.BackgroundColor3 = COLORS.card
    StatusBar.BorderSizePixel = 0
    StatusBar.Parent = MainFrame

    Utils.createCorner(8).Parent = StatusBar
    Utils.createStroke(StatusBar, COLORS.border, 1)

    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(1, -20, 1, 0)
    StatusText.Position = UDim2.new(0, 10, 0, 0)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "Berry Ave Ultimate Hub v2.0 | Ready"
    StatusText.TextColor3 = COLORS.textDim
    StatusText.Font = Enum.Font.Gotham
    StatusText.TextSize = 10
    StatusText.TextXAlignment = Enum.TextXAlignment.Left
    StatusText.Parent = StatusBar

    -- Entrance animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    local entranceTween = Utils.createTween(MainFrame, {
        Size = UDim2.new(0, 480, 0, 560)
    }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    entranceTween:Play()

    return ScreenGui, createScriptCard
end

-- SCRIPT 1: Berry Sniffer Ultra (Enhanced)
local function executeBerrySnifferUltra()
    local EQUIP_DELAY = 0.1
    local BUTTON_FEEDBACK_DELAY = 1.5
    local REFRESH_DELAY = 1

    local COLOR_BG = Color3.fromRGB(12, 12, 14)
    local COLOR_SIDE = Color3.fromRGB(18, 18, 22)
    local COLOR_CARD = Color3.fromRGB(26, 26, 32)
    local COLOR_ACCENT = Color3.fromRGB(0, 190, 255)
    local COLOR_3D = Color3.fromRGB(255, 140, 0)
    local COLOR_ANIM = Color3.fromRGB(255, 60, 60)
    local COLOR_BODY = Color3.fromRGB(80, 255, 120)
    local COLOR_CLASSIC = Color3.fromRGB(150, 100, 255)
    local COLOR_SKINTONE = Color3.fromRGB(255, 180, 220)
    local COLOR_FACE = Color3.fromRGB(255, 50, 150)
    local COLOR_TEXT = Color3.fromRGB(245, 245, 245)

    local MarketplaceService = game:GetService("MarketplaceService")
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local connections = {}
    local function addConnection(conn)
        table.insert(connections, conn)
        return conn
    end

    local function cleanup()
        for _, conn in ipairs(connections) do
            if conn and conn.Connected then
                conn:Disconnect()
            end
        end
        table.clear(connections)
    end

    local setclipboard = (typeof(setclipboard) == "function" and setclipboard) or function(text)
        warn("setclipboard not available in this executor")
        return false
    end

    local ScriptState = {
        currentPlayerItems = nil
    }

    local TYPE_3D_MAP = table.freeze({
        Jacket = "JacketAccessory",
        Sweater = "SweaterAccessory",
        Pants = "PantsAccessory",
        Shorts = "ShortsAccessory",
        DressSkirt = "DressSkirtAccessory",
        TShirt = "TShirtAccessory",
        Shirt = "ShirtAccessory",
        LeftShoe = "ShoesAccessory",
        RightShoe = "ShoesAccessory"
    })

    local TYPE_STANDARD_MAP = table.freeze({
        Hat = "Hat",
        Hair = "HairAccessory",
        Face = "FaceAccessory",
        Neck = "NeckAccessory",
        Shoulder = "ShoulderAccessory",
        Front = "FrontAccessory",
        Back = "BackAccessory",
        Waist = "WaistAccessory"
    })

    local TYPE_3D_CHECK = table.freeze({
        Jacket = true, Sweater = true, Shorts = true, Pants = true,
        DressSkirt = true, TShirt = true, Shirt = true,
        LeftShoe = true, RightShoe = true
    })

    -- Create GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UltraSniffer_Enhanced"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = COLOR_BG
    MainFrame.Size = UDim2.new(0, 820, 0, 580)
    MainFrame.Position = UDim2.new(0.5, -410, 0.5, -290)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    Utils.createCorner(12).Parent = MainFrame
    Utils.createStroke(MainFrame, COLORS.border, 1.5)

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 240, 1, 0)
    Sidebar.BackgroundColor3 = COLOR_SIDE
    Sidebar.Parent = MainFrame
    Sidebar.BorderSizePixel = 0
    Utils.createCorner(12).Parent = Sidebar

    local SidebarTitle = Instance.new("TextLabel", Sidebar)
    SidebarTitle.Size = UDim2.new(1, 0, 0, 45)
    SidebarTitle.Position = UDim2.new(0, 0, 0, 8)
    SidebarTitle.Text = "PLAYERS"
    SidebarTitle.TextColor3 = COLOR_TEXT
    SidebarTitle.Font = Enum.Font.GothamBold
    SidebarTitle.TextSize = 15
    SidebarTitle.BackgroundTransparency = 1

    local PlayerList = Instance.new("ScrollingFrame")
    PlayerList.Size = UDim2.new(1, -10, 1, -60)
    PlayerList.Position = UDim2.new(0, 5, 0, 55)
    PlayerList.BackgroundTransparency = 1
    PlayerList.ScrollBarThickness = 5
    PlayerList.BorderSizePixel = 0
    PlayerList.Parent = Sidebar
    local PlayerListLayout = Instance.new("UIListLayout", PlayerList)
    PlayerListLayout.Padding = UDim.new(0, 6)
    PlayerListLayout.SortOrder = Enum.SortOrder.Name

    local ItemList = Instance.new("ScrollingFrame")
    ItemList.Size = UDim2.new(1, -260, 1, -90)
    ItemList.Position = UDim2.new(0, 255, 0, 75)
    ItemList.BackgroundTransparency = 1
    ItemList.ScrollBarThickness = 6
    ItemList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ItemList.BorderSizePixel = 0
    ItemList.Parent = MainFrame
    local ItemListLayout = Instance.new("UIListLayout", ItemList)
    ItemListLayout.Padding = UDim.new(0, 10)

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, -240, 0, 65)
    TopBar.Position = UDim2.new(0, 240, 0, 0)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = MainFrame

    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(0.6, 0, 1, 0)
    StatusText.Position = UDim2.new(0, 20, 0, 0)
    StatusText.Text = "READY TO SCAN"
    StatusText.TextColor3 = Color3.fromRGB(150, 150, 160)
    StatusText.Font = Enum.Font.GothamBold
    StatusText.TextSize = 13
    StatusText.TextXAlignment = Enum.TextXAlignment.Left
    StatusText.BackgroundTransparency = 1
    StatusText.Parent = TopBar

    local RefreshBtn = Instance.new("TextButton")
    RefreshBtn.Size = UDim2.new(0, 90, 0, 32)
    RefreshBtn.Position = UDim2.new(1, -140, 0.5, -16)
    RefreshBtn.Text = "REFRESH"
    RefreshBtn.TextColor3 = COLOR_TEXT
    RefreshBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    RefreshBtn.Font = Enum.Font.GothamBold
    RefreshBtn.TextSize = 11
    RefreshBtn.Parent = TopBar
    Utils.createCorner(6).Parent = RefreshBtn

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 32, 0, 32)
    CloseBtn.Position = UDim2.new(1, -50, 0.5, -16)
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = COLOR_TEXT
    CloseBtn.TextSize = 22
    CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TopBar
    Utils.createCorner(16).Parent = CloseBtn

    local EquipAllBtn = Instance.new("TextButton")
    EquipAllBtn.Size = UDim2.new(0, 100, 0, 32)
    EquipAllBtn.Position = UDim2.new(1, -240, 0.5, -16)
    EquipAllBtn.Text = "EQUIP ALL"
    EquipAllBtn.TextColor3 = COLOR_TEXT
    EquipAllBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
    EquipAllBtn.Font = Enum.Font.GothamBold
    EquipAllBtn.TextSize = 11
    EquipAllBtn.Parent = TopBar
    Utils.createCorner(6).Parent = EquipAllBtn

    local function getEditorCall()
        local success, result = pcall(function()
            return ReplicatedStorage.Packages._Index["sleitnick_knit@1.4.4"].knit.Services.CharacterService.RF.EditorCall
        end)
        if success then return result end
        success, result = pcall(function()
            return ReplicatedStorage:WaitForChild("Packages", 3):WaitForChild("_Index", 3):FindFirstChild("sleitnick_knit@1.4.4"):WaitForChild("knit", 3):WaitForChild("Services", 3):WaitForChild("CharacterService", 3):WaitForChild("RF", 3):WaitForChild("EditorCall", 3)
        end)
        return success and result or nil
    end

    local EditorCall = getEditorCall()

    local function parseAssetType(assetType)
        local typeStr = tostring(assetType)
        local splitResult = typeStr:split(".")
        return splitResult[3] or typeStr
    end

    local function get3DAccessoryType(accType)
        local t = parseAssetType(accType)
        return TYPE_3D_MAP[t]
    end

    local function getStandardAccessoryType(accType)
        local t = parseAssetType(accType)
        return TYPE_STANDARD_MAP[t] or "Hat"
    end

    local function isFaceAccessory(assetType)
        local t = parseAssetType(assetType)
        return t == "Face"
    end

    local function is3DClothing(assetType)
        local t = parseAssetType(assetType)
        return TYPE_3D_CHECK[t] or false
    end

    local function safeInvokeServer(remote, action, ...)
        if not remote then
            warn("Remote not available for action:", action)
            return false
        end
        local success, result = pcall(function(...)
            return remote:InvokeServer(action, ...)
        end, ...)
        if not success then
            warn(`Remote invocation failed for {action}:`, result)
            return false
        end
        return true
    end

    local function wearOnBerry(assetId, assetType)
        if not EditorCall or assetType == "Emote" then return false end
        local success, productInfo = pcall(function()
            return MarketplaceService:GetProductInfo(assetId, Enum.InfoType.Asset)
        end)
        if not success then
            warn("Failed to get product info for:", assetId)
            return false
        end

        local typeName = parseAssetType(assetType)
        local is3D = is3DClothing(assetType)
        local isBodyPart = (typeName == "Head" or typeName == "Torso" or typeName:find("Arm") or typeName:find("Leg") or typeName == "Face")

        local function buildAccessoryArgs(assetType)
            return {
                AssetType = assetType,
                BundledItems = {},
                CollectibleItemId = productInfo.CollectibleItemId or "",
                CreatorHasVerifiedBadge = productInfo.CreatorHasVerifiedBadge or false,
                CreatorName = productInfo.Creator and productInfo.Creator.Name or "Unknown",
                CreatorTargetId = productInfo.Creator and (productInfo.Creator.Id or productInfo.Creator.CreatorTargetId) or 1,
                CreatorType = productInfo.Creator and productInfo.Creator.CreatorType or "User",
                Description = productInfo.Description or "",
                FavoriteCount = productInfo.Sales or 0,
                HasResellers = false,
                Id = assetId,
                ItemRestrictions = {},
                ItemStatus = {},
                ItemType = "Asset",
                LowestPrice = productInfo.PriceInRobux or 0,
                LowestResalePrice = 0,
                Name = productInfo.Name or "Unknown",
                Price = productInfo.PriceInRobux or 0,
                PriceStatus = (not productInfo.PriceInRobux or productInfo.PriceInRobux == 0) and "Free" or "Robux",
                ProductId = productInfo.ProductId or 0,
                SaleLocationType = productInfo.IsForSale and "ShopAndAllExperiences" or "NotForSale",
                TotalQuantity = 0,
                UnitsAvailableForConsumption = 0
            }
        end

        task.wait(EQUIP_DELAY)

        if is3D then
            local accessoryType = get3DAccessoryType(assetType)
            if not accessoryType then
                warn("Unknown 3D type:", typeName)
                return false
            end
            return safeInvokeServer(EditorCall, "WearAccessory", buildAccessoryArgs(accessoryType))
        elseif isBodyPart then
            local args = {
                AssetType = typeName,
                BundledItems = {},
                CreatorHasVerifiedBadge = productInfo.CreatorHasVerifiedBadge or false,
                CreatorName = productInfo.Creator and productInfo.Creator.Name or "Unknown",
                CreatorTargetId = productInfo.Creator and (productInfo.Creator.Id or productInfo.Creator.CreatorTargetId) or 1,
                CreatorType = productInfo.Creator and productInfo.Creator.CreatorType or "User",
                Description = productInfo.Description or "",
                FavoriteCount = 0,
                Id = assetId,
                IsOffSale = not productInfo.IsForSale,
                ItemRestrictions = {},
                ItemStatus = {},
                ItemType = "Asset",
                Name = productInfo.Name or "Unknown",
                SaleLocationType = productInfo.IsForSale and "ShopAndAllExperiences" or "NotApplicable"
            }
            return safeInvokeServer(EditorCall, "WearBodyPart", args)
        else
            local accessoryType = getStandardAccessoryType(assetType)
            return safeInvokeServer(EditorCall, "WearAccessory", buildAccessoryArgs(accessoryType))
        end
    end

    local function applySkinTone(skinColor)
        if not EditorCall then return false end
        return safeInvokeServer(EditorCall, "ChangeSkinTone", skinColor)
    end

    local function debounce(func, delay)
        local isRunning = false
        return function(...)
            if isRunning then return end
            isRunning = true
            local args = {...}
            task.spawn(function()
                func(table.unpack(args))
                task.wait(delay)
                isRunning = false
            end)
        end
    end

    local function createCard(id, typeLabel, colorOverride, rawTypeEnum, extraData)
        if not id or (type(id) == "number" and id <= 0) then return end

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -10, 0, 90)
        card.BackgroundColor3 = COLOR_CARD
        card.BorderSizePixel = 0
        card.Parent = ItemList
        Utils.createCorner(8).Parent = card

        local img = Instance.new("ImageLabel", card)
        img.Size = UDim2.new(0, 70, 0, 70)
        img.Position = UDim2.new(0, 10, 0.5, -35)
        img.BackgroundColor3 = typeLabel == "SKIN TONE" and extraData or COLOR_BG
        img.Image = typeLabel == "SKIN TONE" and "" or `rbxthumb://type=Asset&id={id}&w=150&h=150`
        img.BorderSizePixel = 0
        Utils.createCorner(6).Parent = img

        local name = Instance.new("TextLabel", card)
        name.Size, name.Position = UDim2.new(0.5, -10, 0, 22), UDim2.new(0, 90, 0, 10)
        name.Text = typeLabel == "SKIN TONE" and "Skin Tone" or "Loading..."
        name.TextColor3, name.Font, name.TextSize = COLOR_TEXT, Enum.Font.GothamBold, 12
        name.TextXAlignment, name.TextTruncate = Enum.TextXAlignment.Left, Enum.TextTruncate.AtEnd
        name.BackgroundTransparency = 1
        name.Parent = card

        local details = Instance.new("TextLabel", card)
        details.Size, details.Position = UDim2.new(0.5, -10, 0, 20), UDim2.new(0, 90, 0, 32)
        details.Text = typeLabel == "SKIN TONE" and `RGB({math.floor(extraData.R * 255)},{math.floor(extraData.G * 255)},{math.floor(extraData.B * 255)})` or typeLabel
        details.TextColor3, details.Font, details.TextSize = colorOverride, Enum.Font.GothamSemibold, 10
        details.TextXAlignment, details.TextTruncate = Enum.TextXAlignment.Left, Enum.TextTruncate.AtEnd
        details.BackgroundTransparency = 1
        details.Parent = card

        local idLabel = Instance.new("TextLabel", card)
        idLabel.Size, idLabel.Position = UDim2.new(0.5, -10, 0, 18), UDim2.new(0, 90, 0, 52)
        idLabel.Text = typeLabel == "SKIN TONE" and `Color3.new({string.format("%.2f", extraData.R)},{string.format("%.2f", extraData.G)},{string.format("%.2f", extraData.B)})` or `ID: {id}`
        idLabel.TextColor3, idLabel.Font, idLabel.TextSize = Color3.fromRGB(120, 120, 130), Enum.Font.Gotham, 9
        idLabel.TextXAlignment = Enum.TextXAlignment.Left
        idLabel.BackgroundTransparency = 1
        idLabel.Parent = card

        local copyBtn = Instance.new("TextButton", card)
        copyBtn.Size = UDim2.new(0, 95, 0, 28)
        copyBtn.Position = UDim2.new(1, -105, 0.5, -14)
        copyBtn.BackgroundColor3 = COLOR_BG
        copyBtn.Text = "COPY AUTHOR"
        copyBtn.TextColor3, copyBtn.Font, copyBtn.TextSize = COLOR_TEXT, Enum.Font.GothamBold, 9
        copyBtn.BorderSizePixel = 0
        Utils.createCorner(5).Parent = copyBtn

        local wearBtn = Instance.new("TextButton", card)
        wearBtn.Size = UDim2.new(0, 70, 0, 28)
        wearBtn.Position = UDim2.new(1, -180, 0.5, -14)
        wearBtn.BackgroundColor3, wearBtn.Text = COLOR_BG, "EQUIP"
        wearBtn.TextColor3, wearBtn.Font, wearBtn.TextSize = colorOverride, Enum.Font.GothamBold, 10
        wearBtn.BorderSizePixel = 0
        Utils.createCorner(5).Parent = wearBtn

        if typeLabel:find("ANIM") or typeLabel:find("EMOTE") or typeLabel:find("CLASSIC") or typeLabel:find("FACE") then
            wearBtn.Visible = false
            copyBtn.Position = UDim2.new(1, -100, 0.5, -14)
        end

        if typeLabel == "SKIN TONE" then
            copyBtn.Text = "COPY COLOR"
            local debouncedCopy = debounce(function()
                local colorStr = `Color3.new({string.format("%.10f", extraData.R)},{string.format("%.10f", extraData.G)},{string.format("%.10f", extraData.B)})`
                if setclipboard(colorStr) ~= false then
                    copyBtn.Text = "COPIED!"
                    task.wait(BUTTON_FEEDBACK_DELAY)
                    copyBtn.Text = "COPY COLOR"
                else
                    copyBtn.Text = "FAILED"
                    task.wait(BUTTON_FEEDBACK_DELAY)
                    copyBtn.Text = "COPY COLOR"
                end
            end, BUTTON_FEEDBACK_DELAY)
            addConnection(copyBtn.MouseButton1Click:Connect(debouncedCopy))

            local debouncedWear = debounce(function()
                if not EditorCall then
                    wearBtn.Text, wearBtn.BackgroundColor3 = "ERROR", COLOR_ANIM
                    task.wait(BUTTON_FEEDBACK_DELAY)
                    wearBtn.Text, wearBtn.BackgroundColor3 = "EQUIP", COLOR_BG
                    return
                end
                wearBtn.Text = "..."
                local success = applySkinTone(extraData)
                wearBtn.Text, wearBtn.BackgroundColor3 = success and "APPLIED!" or "FAILED", success and COLOR_BODY or COLOR_ANIM
                task.wait(BUTTON_FEEDBACK_DELAY)
                wearBtn.Text, wearBtn.BackgroundColor3 = "EQUIP", COLOR_BG
            end, BUTTON_FEEDBACK_DELAY)
            addConnection(wearBtn.MouseButton1Click:Connect(debouncedWear))
            return
        end

        local debouncedWearItem = debounce(function()
            if not EditorCall then
                wearBtn.Text, wearBtn.BackgroundColor3 = "ERROR", COLOR_ANIM
                task.wait(BUTTON_FEEDBACK_DELAY)
                wearBtn.Text, wearBtn.BackgroundColor3 = "EQUIP", COLOR_BG
                return
            end
            wearBtn.Text = "..."
            local success = wearOnBerry(id, rawTypeEnum)
            wearBtn.Text, wearBtn.BackgroundColor3 = success and "SENT!" or "FAILED", success and COLOR_BODY or COLOR_ANIM
            task.wait(BUTTON_FEEDBACK_DELAY)
            wearBtn.Text, wearBtn.BackgroundColor3 = "EQUIP", COLOR_BG
        end, BUTTON_FEEDBACK_DELAY)

        addConnection(wearBtn.MouseButton1Click:Connect(debouncedWearItem))

        task.spawn(function()
            local success, data = pcall(function() return MarketplaceService:GetProductInfo(id, Enum.InfoType.Asset) end)
            if success and data then
                name.Text = data.Name
                details.Text = `{typeLabel} | {data.Creator.Name}`
                local debouncedCopyAuthor = debounce(function()
                    if setclipboard(data.Creator.Name) ~= false then
                        copyBtn.Text = "COPIED!"
                        task.wait(BUTTON_FEEDBACK_DELAY)
                        copyBtn.Text = "COPY AUTHOR"
                    else
                        copyBtn.Text = "FAILED"
                        task.wait(BUTTON_FEEDBACK_DELAY)
                        copyBtn.Text = "COPY AUTHOR"
                    end
                end, BUTTON_FEEDBACK_DELAY)
                addConnection(copyBtn.MouseButton1Click:Connect(debouncedCopyAuthor))
            else
                name.Text = `Asset {id}`
                details.Text = `{typeLabel} | Unknown`
                local debouncedCopyId = debounce(function()
                    if setclipboard(tostring(id)) ~= false then
                        copyBtn.Text = "COPIED!"
                        task.wait(BUTTON_FEEDBACK_DELAY)
                        copyBtn.Text = "COPY AUTHOR"
                    else
                        copyBtn.Text = "FAILED"
                        task.wait(BUTTON_FEEDBACK_DELAY)
                        copyBtn.Text = "COPY AUTHOR"
                    end
                end, BUTTON_FEEDBACK_DELAY)
                addConnection(copyBtn.MouseButton1Click:Connect(debouncedCopyId))
            end
        end)
    end

    local function sniff(player)
        if not player or not player.Character then
            StatusText.Text = "ERROR: Invalid player"
            return
        end

        for _, child in ipairs(ItemList:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        StatusText.Text = `SCANNING: {player.Name:upper()}`

        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            StatusText.Text = "ERROR: No humanoid"
            return
        end

        local success, description = pcall(function() return humanoid:GetAppliedDescription() end)
        if not success or not description then
            StatusText.Text = "ERROR: Cannot read"
            return
        end

        local itemCount = 0
        local standardAccessories, faceAccessories, clothing3D, classicClothes, bodyParts, animations, emotes, skinTone = {}, {}, {}, {}, {}, {}, {}, nil

        local accSuccess, accessories = pcall(function() return description:GetAccessories(true) end)
        if accSuccess and accessories then
            for _, item in ipairs(accessories) do
                local is3D = is3DClothing(item.AccessoryType)
                local isFace = isFaceAccessory(item.AccessoryType)
                local typeName = parseAssetType(item.AccessoryType)

                if isFace then
                    table.insert(faceAccessories, {item.AssetId, `FACE: {typeName:upper()}`, COLOR_FACE, item.AccessoryType})
                elseif is3D then
                    table.insert(clothing3D, {item.AssetId, `3D: {typeName:upper()}`, COLOR_3D, item.AccessoryType})
                else
                    table.insert(standardAccessories, {item.AssetId, `ACC: {typeName:upper()}`, COLOR_ACCENT, item.AccessoryType})
                end
            end
        end

        if description.Shirt and description.Shirt > 0 then
            table.insert(classicClothes, {description.Shirt, "CLASSIC: SHIRT", COLOR_CLASSIC, "Shirt"})
        end
        if description.Pants and description.Pants > 0 then
            table.insert(classicClothes, {description.Pants, "CLASSIC: PANTS", COLOR_CLASSIC, "Pants"})
        end
        if description.GraphicTShirt and description.GraphicTShirt > 0 then
            table.insert(classicClothes, {description.GraphicTShirt, "CLASSIC: T-SHIRT", COLOR_CLASSIC, "GraphicTShirt"})
        end

        local limbs = {
            {description.Head, "HEAD", "Head"},
            {description.Torso, "TORSO", "Torso"},
            {description.LeftArm, "L-ARM", "LeftArm"},
            {description.RightArm, "R-ARM", "RightArm"},
            {description.LeftLeg, "L-LEG", "LeftLeg"},
            {description.RightLeg, "R-LEG", "RightLeg"},
            {description.Face, "FACE", "Face"}
        }
        for _, limb in ipairs(limbs) do
            if limb[1] and limb[1] > 0 then
                table.insert(bodyParts, {limb[1], `BODY: {limb[2]}`, COLOR_BODY, limb[3]})
            end
        end

        local anims = {
            {description.IdleAnimation, "IDLE"},
            {description.WalkAnimation, "WALK"},
            {description.RunAnimation, "RUN"},
            {description.JumpAnimation, "JUMP"},
            {description.ClimbAnimation, "CLIMB"},
            {description.FallAnimation, "FALL"}
        }
        for _, anim in ipairs(anims) do
            if anim[1] and anim[1] > 0 then
                table.insert(animations, {anim[1], `ANIM: {anim[2]}`, COLOR_ANIM, "Anim"})
            end
        end

        local emoteSuccess, emotesList = pcall(function() return description:GetEmotes() end)
        if emoteSuccess and emotesList then
            for _, emote in ipairs(emotesList) do
                local emoteId = (type(emote) == "table" and (emote.AssetId or emote[1])) or emote
                if type(emoteId) == "number" and emoteId > 0 then
                    table.insert(emotes, {emoteId, "EMOTE", COLOR_ANIM, "Emote"})
                end
            end
        end

        if description.HeadColor then
            skinTone = {"SkinTone", "SKIN TONE", COLOR_SKINTONE, "SkinTone", description.HeadColor}
        end

        if skinTone then createCard(skinTone[1], skinTone[2], skinTone[3], skinTone[4], skinTone[5]) itemCount = itemCount + 1 end
        for _, item in ipairs(standardAccessories) do createCard(item[1], item[2], item[3], item[4]) itemCount = itemCount + 1 end
        for _, item in ipairs(faceAccessories) do createCard(item[1], item[2], item[3], item[4]) itemCount = itemCount + 1 end
        for _, item in ipairs(clothing3D) do createCard(item[1], item[2], item[3], item[4]) itemCount = itemCount + 1 end
        for _, item in ipairs(classicClothes) do createCard(item[1], item[2], item[3], item[4]) itemCount = itemCount + 1 end
        for _, item in ipairs(bodyParts) do createCard(item[1], item[2], item[3], item[4]) itemCount = itemCount + 1 end
        for _, item in ipairs(animations) do createCard(item[1], item[2], item[3], item[4]) itemCount = itemCount + 1 end
        for _, item in ipairs(emotes) do createCard(item[1], item[2], item[3], item[4]) itemCount = itemCount + 1 end

        StatusText.Text = `VIEWING: {player.Name:upper()} ({itemCount} items)`

        ScriptState.currentPlayerItems = {
            skinTone = skinTone,
            standardAccessories = standardAccessories,
            clothing3D = clothing3D,
            bodyParts = bodyParts
        }
    end

    local function refreshPlayerList()
        for _, child in ipairs(PlayerList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        local playerCount = 0
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(0.95, 0, 0, 40)
                btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                btn.Text = `  {player.Name}`
                btn.TextColor3, btn.Font, btn.TextSize = COLOR_TEXT, Enum.Font.GothamSemibold, 12
                btn.TextXAlignment, btn.TextTruncate = Enum.TextXAlignment.Left, Enum.TextTruncate.AtEnd
                btn.BorderSizePixel = 0
                btn.Parent = PlayerList
                Utils.createCorner(6).Parent = btn

                btn.MouseEnter:Connect(function()
                    Utils.createTween(btn, {BackgroundColor3 = Color3.fromRGB(40, 40, 48)}):Play()
                end)
                btn.MouseLeave:Connect(function()
                    Utils.createTween(btn, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
                end)

                addConnection(btn.MouseButton1Click:Connect(function()
                    sniff(player)
                end))
                playerCount = playerCount + 1
            end
        end

        if playerCount == 0 then
            local noPlayers = Instance.new("TextLabel", PlayerList)
            noPlayers.Size = UDim2.new(1, 0, 0, 50)
            noPlayers.Text, noPlayers.TextColor3 = "No other players", Color3.fromRGB(120, 120, 130)
            noPlayers.Font, noPlayers.TextSize = Enum.Font.Gotham, 11
            noPlayers.BackgroundTransparency = 1
        end
    end

    addConnection(CloseBtn.MouseButton1Click:Connect(function()
        cleanup()
        ScreenGui:Destroy()
    end))

    local debouncedRefresh = debounce(function()
        refreshPlayerList()
        RefreshBtn.Text = "UPDATED"
        task.wait(REFRESH_DELAY)
        RefreshBtn.Text = "REFRESH"
    end, REFRESH_DELAY)

    addConnection(RefreshBtn.MouseButton1Click:Connect(debouncedRefresh))

    local debouncedEquipAll = debounce(function()
        if not ScriptState.currentPlayerItems then
            EquipAllBtn.Text = "NO PLAYER"
            task.wait(BUTTON_FEEDBACK_DELAY)
            EquipAllBtn.Text = "EQUIP ALL"
            return
        end

        EquipAllBtn.Text = "EQUIPPING..."
        EquipAllBtn.BackgroundColor3 = COLOR_ANIM

        local totalItems = 0
        local successCount = 0

        if ScriptState.currentPlayerItems.skinTone then
            totalItems = totalItems + 1
            if applySkinTone(ScriptState.currentPlayerItems.skinTone[5]) then
                successCount = successCount + 1
            end
            task.wait(0.15)
        end

        for _, item in ipairs(ScriptState.currentPlayerItems.bodyParts) do
            totalItems = totalItems + 1
            if wearOnBerry(item[1], item[4]) then
                successCount = successCount + 1
            end
            task.wait(0.15)
        end

        for _, item in ipairs(ScriptState.currentPlayerItems.standardAccessories) do
            totalItems = totalItems + 1
            if wearOnBerry(item[1], item[4]) then
                successCount = successCount + 1
            end
            task.wait(0.15)
        end

        for _, item in ipairs(ScriptState.currentPlayerItems.clothing3D) do
            totalItems = totalItems + 1
            if wearOnBerry(item[1], item[4]) then
                successCount = successCount + 1
            end
            task.wait(0.15)
        end

        EquipAllBtn.Text = `{successCount}/{totalItems} OK`
        EquipAllBtn.BackgroundColor3 = COLOR_BODY
        task.wait(2)
        EquipAllBtn.Text = "EQUIP ALL"
        EquipAllBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
    end, 2)

    addConnection(EquipAllBtn.MouseButton1Click:Connect(debouncedEquipAll))

    addConnection(Players.PlayerAdded:Connect(refreshPlayerList))
    addConnection(Players.PlayerRemoving:Connect(refreshPlayerList))

    refreshPlayerList()
    if not EditorCall then
        StatusText.Text, StatusText.TextColor3 = "WARNING: EditorCall not found", COLOR_ANIM
    end
end

-- SCRIPT 2: Spam Control (Enhanced)
local function executeSpamControl()
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local CoreGui = game:GetService("CoreGui")
    local UIS = game:GetService("UserInputService")

    local carry = ReplicatedStorage.Packages._Index["sleitnick_knit@1.4.4"].knit.Services.ActionService.RF.PerformAction
    local drop = ReplicatedStorage.Packages._Index["sleitnick_knit@1.4.4"].knit.Services.ActionService.RF.UnperformAction

    local me = Players.LocalPlayer
    local activePlayers = {}
    local isRunning = false

    local stats = {
        totalRequests = 0,
        currentRPS = 0,
        peakRPS = 0,
        errors = 0,
        startTime = 0,
        threadCount = 4
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SpamControlGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 340, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -170, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    Utils.createCorner(10).Parent = MainFrame
    Utils.createStroke(MainFrame, COLORS.border, 1.5)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    Title.BorderSizePixel = 0
    Title.Text = "SPAM CONTROL"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 17
    Title.Parent = MainFrame

    Utils.createCorner(10).Parent = Title

    local function createStatLabel(text, yPos)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 0, 26)
        label.Position = UDim2.new(0, 10, 0, yPos)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(210, 210, 210)
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = MainFrame
        return label
    end

    local StatusLabel = createStatLabel("Status: STOPPED", 50)
    local PlayersLabel = createStatLabel("Players: 0", 76)
    local RPSLabel = createStatLabel("RPS: 0", 102)
    local PeakRPSLabel = createStatLabel("Peak RPS: 0", 128)
    local TotalLabel = createStatLabel("Total Requests: 0", 154)
    local ThreadsLabel = createStatLabel("Threads: 4", 180)

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(1, -20, 0, 42)
    ToggleButton.Position = UDim2.new(0, 10, 0, 215)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = "START"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextSize = 16
    ToggleButton.Parent = MainFrame

    Utils.createCorner(7).Parent = ToggleButton

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 28, 0, 28)
    CloseButton.Position = UDim2.new(1, -35, 0, 6)
    CloseButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 16
    CloseButton.Parent = MainFrame

    Utils.createCorner(14).Parent = CloseButton

    local ThreadControl = Instance.new("TextButton")
    ThreadControl.Size = UDim2.new(1, -20, 0, 28)
    ThreadControl.Position = UDim2.new(0, 10, 0, 262)
    ThreadControl.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    ThreadControl.BorderSizePixel = 0
    ThreadControl.Text = "Threads: 4 [Click to change]"
    ThreadControl.TextColor3 = Color3.fromRGB(200, 200, 200)
    ThreadControl.Font = Enum.Font.Gotham
    ThreadControl.TextSize = 11
    ThreadControl.Parent = MainFrame

    Utils.createCorner(5).Parent = ThreadControl

    local function rebuildPlayerList()
        table.clear(activePlayers)
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= me then
                table.insert(activePlayers, player)
            end
        end
    end

    rebuildPlayerList()

    Players.PlayerAdded:Connect(function(player)
        if player ~= me then
            task.wait(0.5)
            rebuildPlayerList()
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        rebuildPlayerList()
    end)

    local activeThreads = {}

    local function spamThread()
        local lastCount = 0
        local countInterval = os.clock()

        while isRunning do
            local targets = activePlayers
            for i = 1, #targets do
                if not isRunning then break end
                local player = targets[i]

                local s1 = pcall(function()
                    carry:InvokeServer("PickupPlayer", player)
                end)
                local s2 = pcall(function()
                    drop:InvokeServer("PickupPlayer", player)
                end)

                if s1 and s2 then
                    stats.totalRequests = stats.totalRequests + 2
                    lastCount = lastCount + 2
                else
                    stats.errors = stats.errors + 1
                end

                if os.clock() - countInterval >= 1 then
                    stats.currentRPS = lastCount
                    if stats.currentRPS > stats.peakRPS then
                        stats.peakRPS = stats.currentRPS
                    end
                    lastCount = 0
                    countInterval = os.clock()
                end
            end
        end
    end

    local function startSpam()
        if isRunning then return end

        isRunning = true
        stats.startTime = os.clock()
        stats.totalRequests = 0
        stats.currentRPS = 0

        for i = 1, stats.threadCount do
            table.insert(activeThreads, task.spawn(spamThread))
        end

        ToggleButton.Text = "STOP"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        StatusLabel.Text = "Status: RUNNING"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end

    local function stopSpam()
        isRunning = false

        for _, thread in ipairs(activeThreads) do
            task.cancel(thread)
        end
        table.clear(activeThreads)

        ToggleButton.Text = "START"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        StatusLabel.Text = "Status: STOPPED"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end

    task.spawn(function()
        while ScreenGui.Parent do
            task.wait(0.1)

            PlayersLabel.Text = `Players: {#activePlayers}`
            RPSLabel.Text = `RPS: {stats.currentRPS}`
            PeakRPSLabel.Text = `Peak RPS: {stats.peakRPS}`

            local totalText = Utils.formatNumber(stats.totalRequests)
            TotalLabel.Text = `Total Requests: {totalText}`
            ThreadsLabel.Text = `Threads: {stats.threadCount} | Errors: {stats.errors}`
        end
    end)

    ToggleButton.MouseButton1Click:Connect(function()
        if isRunning then
            stopSpam()
        else
            startSpam()
        end
    end)

    ThreadControl.MouseButton1Click:Connect(function()
        if isRunning then return end

        local newCount = stats.threadCount + 2
        if newCount > 16 then newCount = 2 end

        stats.threadCount = newCount
        ThreadControl.Text = `Threads: {newCount} [Click to change]`
    end)

    CloseButton.MouseButton1Click:Connect(function()
        stopSpam()
        ScreenGui:Destroy()
    end)

    UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end

        if input.KeyCode == Enum.KeyCode.F6 then
            if isRunning then
                stopSpam()
            else
                startSpam()
            end
        end
    end)

    print("Spam Control GUI loaded. Press F6 or use the GUI to toggle.")
end

-- Initialize Hub
local ScreenGui, createScriptCard = createHubGUI()

-- Add scripts to hub
createScriptCard(
    "Berry Sniffer Ultra",
    "View and copy other players' avatars, accessories, animations, and outfits. Includes equip functionality with enhanced UI.",
    Color3.fromRGB(0, 190, 255),
    executeBerrySnifferUltra
)

createScriptCard(
    "Spam Control",
    "Advanced spam control system with multi-threading support (2-16 threads), real-time statistics tracking, and optimized performance.",
    Color3.fromRGB(255, 60, 120),
    executeSpamControl
)

print("Berry Ave Ultimate Hub v2.0 loaded successfully!")
print("Hub contains 2 enhanced scripts ready to execute")
