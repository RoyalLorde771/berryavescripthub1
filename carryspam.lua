local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- Get remotes
local carry = ReplicatedStorage.Packages._Index["sleitnick_knit@1.4.4"].knit.Services.ActionService.RF.PerformAction
local drop = ReplicatedStorage.Packages._Index["sleitnick_knit@1.4.4"].knit.Services.ActionService.RF.UnperformAction

local me = Players.LocalPlayer
local activePlayers = {}
local isRunning = false

-- Stats tracking
local stats = {
    totalRequests = 0,
    currentRPS = 0,
    peakRPS = 0,
    errors = 0,
    startTime = 0,
    threadCount = 4
}

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpamControlGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 280)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.BorderSizePixel = 0
Title.Text = "SPAM CONTROL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Stats display
local function createStatLabel(text, yPos)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 25)
    label.Position = UDim2.new(0, 10, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = MainFrame
    return label
end

local StatusLabel = createStatLabel("Status: STOPPED", 45)
local PlayersLabel = createStatLabel("Players: 0", 70)
local RPSLabel = createStatLabel("RPS: 0", 95)
local PeakRPSLabel = createStatLabel("Peak RPS: 0", 120)
local TotalLabel = createStatLabel("Total Requests: 0", 145)
local ThreadsLabel = createStatLabel("Threads: 4", 170)

-- Toggle button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -20, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 205)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "START"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 16
ToggleButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = ToggleButton

-- Close button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

-- Thread control
local ThreadControl = Instance.new("TextButton")
ThreadControl.Size = UDim2.new(1, -20, 0, 25)
ThreadControl.Position = UDim2.new(0, 10, 0, 250)
ThreadControl.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ThreadControl.BorderSizePixel = 0
ThreadControl.Text = "Threads: 4 [Click to change]"
ThreadControl.TextColor3 = Color3.fromRGB(200, 200, 200)
ThreadControl.Font = Enum.Font.Gotham
ThreadControl.TextSize = 11
ThreadControl.Parent = MainFrame

local ThreadCorner = Instance.new("UICorner")
ThreadCorner.CornerRadius = UDim.new(0, 4)
ThreadCorner.Parent = ThreadControl

-- Player tracking
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

-- Spam threads
local activeThreads = {}

local function spamThread()
    local lastCount = 0
    local countInterval = tick()
    
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
            
            -- Update RPS calculation
            if tick() - countInterval >= 1 then
                stats.currentRPS = lastCount
                if stats.currentRPS > stats.peakRPS then
                    stats.peakRPS = stats.currentRPS
                end
                lastCount = 0
                countInterval = tick()
            end
        end
    end
end

-- Start/Stop functions
local function startSpam()
    if isRunning then return end
    
    isRunning = true
    stats.startTime = tick()
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

-- GUI updates
task.spawn(function()
    while true do
        task.wait(0.1)
        
        PlayersLabel.Text = string.format("Players: %d", #activePlayers)
        RPSLabel.Text = string.format("RPS: %d", stats.currentRPS)
        PeakRPSLabel.Text = string.format("Peak RPS: %d", stats.peakRPS)
        TotalLabel.Text = string.format("Total Requests: %s", 
            stats.totalRequests >= 1000000 and string.format("%.2fM", stats.totalRequests/1000000) or
            stats.totalRequests >= 1000 and string.format("%.1fK", stats.totalRequests/1000) or
            tostring(stats.totalRequests))
        ThreadsLabel.Text = string.format("Threads: %d | Errors: %d", stats.threadCount, stats.errors)
    end
end)

-- Button events
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
    if newCount > 10 then newCount = 2 end
    
    stats.threadCount = newCount
    ThreadControl.Text = string.format("Threads: %d [Click to change]", newCount)
end)

CloseButton.MouseButton1Click:Connect(function()
    stopSpam()
    ScreenGui:Destroy()
end)

-- Keyboard shortcuts
local UIS = game:GetService("UserInputService")
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