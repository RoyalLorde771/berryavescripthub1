-- BERRY SNIFFER ULTRA v38 (FINAL - ALL FIXED)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Sidebar = Instance.new("Frame")
local PlayerList = Instance.new("ScrollingFrame")
local ItemList = Instance.new("ScrollingFrame")
local TopBar = Instance.new("Frame")
local StatusText = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local RefreshBtn = Instance.new("TextButton")

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

ScreenGui.Name = "UltraSniffer_v38"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = COLOR_BG
MainFrame.Size = UDim2.new(0, 800, 0, 550)
MainFrame.Position = UDim2.new(0.5, -400, 0.5, -275)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

Sidebar.Size = UDim2.new(0, 230, 1, 0)
Sidebar.BackgroundColor3 = COLOR_SIDE
Sidebar.Parent = MainFrame
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local SidebarTitle = Instance.new("TextLabel", Sidebar)
SidebarTitle.Size = UDim2.new(1, 0, 0, 40)
SidebarTitle.Position = UDim2.new(0, 0, 0, 5)
SidebarTitle.Text = "PLAYERS"
SidebarTitle.TextColor3 = COLOR_TEXT
SidebarTitle.Font = Enum.Font.GothamBold
SidebarTitle.TextSize = 14
SidebarTitle.BackgroundTransparency = 1

PlayerList.Size = UDim2.new(1, -10, 1, -55)
PlayerList.Position = UDim2.new(0, 5, 0, 50)
PlayerList.BackgroundTransparency = 1
PlayerList.ScrollBarThickness = 4
PlayerList.BorderSizePixel = 0
PlayerList.Parent = Sidebar
local PlayerListLayout = Instance.new("UIListLayout", PlayerList)
PlayerListLayout.Padding = UDim.new(0, 5)
PlayerListLayout.SortOrder = Enum.SortOrder.Name

ItemList.Size = UDim2.new(1, -250, 1, -80)
ItemList.Position = UDim2.new(0, 245, 0, 70)
ItemList.BackgroundTransparency = 1
ItemList.ScrollBarThickness = 6
ItemList.AutomaticCanvasSize = Enum.AutomaticSize.Y
ItemList.BorderSizePixel = 0
ItemList.Parent = MainFrame
local ItemListLayout = Instance.new("UIListLayout", ItemList)
ItemListLayout.Padding = UDim.new(0, 8)

TopBar.Size = UDim2.new(1, -230, 0, 60)
TopBar.Position = UDim2.new(0, 230, 0, 0)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

StatusText.Size = UDim2.new(0.6, 0, 1, 0)
StatusText.Position = UDim2.new(0, 20, 0, 0)
StatusText.Text = "READY TO SCAN"
StatusText.TextColor3 = Color3.fromRGB(150, 150, 160)
StatusText.Font = Enum.Font.GothamBold
StatusText.TextSize = 12
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.BackgroundTransparency = 1
StatusText.Parent = TopBar

RefreshBtn.Size = UDim2.new(0, 80, 0, 30)
RefreshBtn.Position = UDim2.new(1, -130, 0.5, -15)
RefreshBtn.Text = "REFRESH"
RefreshBtn.TextColor3 = COLOR_TEXT
RefreshBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.TextSize = 10
RefreshBtn.Parent = TopBar
Instance.new("UICorner", RefreshBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = COLOR_TEXT
CloseBtn.TextSize = 20
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

local EquipAllBtn = Instance.new("TextButton")
EquipAllBtn.Size = UDim2.new(0, 90, 0, 30)
EquipAllBtn.Position = UDim2.new(1, -230, 0.5, -15)
EquipAllBtn.Text = "EQUIP ALL"
EquipAllBtn.TextColor3 = COLOR_TEXT
EquipAllBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
EquipAllBtn.Font = Enum.Font.GothamBold
EquipAllBtn.TextSize = 10
EquipAllBtn.Parent = TopBar
Instance.new("UICorner", EquipAllBtn).CornerRadius = UDim.new(0, 6)

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

local function get3DAccessoryType(accType)
    local t = tostring(accType):split(".")[3] or tostring(accType)
    return ({Jacket="JacketAccessory",Sweater="SweaterAccessory",Pants="PantsAccessory",Shorts="ShortsAccessory",DressSkirt="DressSkirtAccessory",TShirt="TShirtAccessory",Shirt="ShirtAccessory",LeftShoe="ShoesAccessory",RightShoe="ShoesAccessory"})[t]
end

local function getStandardAccessoryType(accType)
    local t = tostring(accType):split(".")[3] or tostring(accType)
    return ({Hat="Hat",Hair="HairAccessory",Face="FaceAccessory",Neck="NeckAccessory",Shoulder="ShoulderAccessory",Front="FrontAccessory",Back="BackAccessory",Waist="WaistAccessory"})[t] or "Hat"
end

local function isFaceAccessory(assetType)
    local t = tostring(assetType):split(".")[3] or tostring(assetType)
    return t == "Face"
end

local function is3DClothing(assetType)
    local t = tostring(assetType):split(".")[3] or tostring(assetType)
    return ({Jacket=true,Sweater=true,Shorts=true,Pants=true,DressSkirt=true,TShirt=true,Shirt=true,LeftShoe=true,RightShoe=true})[t] or false
end

local function wearOnBerry(assetId, assetType)
    if not EditorCall or assetType == "Emote" then return false end
    
    local success, productInfo = pcall(function() return MarketplaceService:GetProductInfo(assetId, Enum.InfoType.Asset) end)
    if not success then 
        warn("Failed to get product info for:", assetId)
        return false 
    end

    local typeName = tostring(assetType):split(".")[3] or tostring(assetType)
    local is3D = is3DClothing(assetType)
    local isBodyPart = (typeName=="Head" or typeName=="Torso" or typeName:find("Arm") or typeName:find("Leg") or typeName=="Face")
    
    -- Full accessory structure matching the remote log
    local function getAccessoryArgs(assetType)
        return {
            AssetType=assetType,
            BundledItems={},
            CollectibleItemId=productInfo.CollectibleItemId or "",
            CreatorHasVerifiedBadge=productInfo.CreatorHasVerifiedBadge or false,
            CreatorName=productInfo.Creator and productInfo.Creator.Name or "Unknown",
            CreatorTargetId=productInfo.Creator and (productInfo.Creator.Id or productInfo.Creator.CreatorTargetId) or 1,
            CreatorType=productInfo.Creator and productInfo.Creator.CreatorType or "User",
            Description=productInfo.Description or "",
            FavoriteCount=productInfo.Sales or 0,
            HasResellers=false,
            Id=assetId,
            ItemRestrictions={},
            ItemStatus={},
            ItemType="Asset",
            LowestPrice=productInfo.PriceInRobux or 0,
            LowestResalePrice=0,
            Name=productInfo.Name or "Unknown",
            Price=productInfo.PriceInRobux or 0,
            PriceStatus=(not productInfo.PriceInRobux or productInfo.PriceInRobux==0) and "Free" or "Robux",
            ProductId=productInfo.ProductId or 0,
            SaleLocationType=productInfo.IsForSale and "ShopAndAllExperiences" or "NotForSale",
            TotalQuantity=0,
            UnitsAvailableForConsumption=0
        }
    end
    
    -- Add small delay to avoid rate limiting
    task.wait(0.1)
    
    if is3D then
        local accessoryType = get3DAccessoryType(assetType)
        if not accessoryType then 
            warn("Unknown 3D type:", typeName)
            return false 
        end
        local equipSuccess, result = pcall(function() return EditorCall:InvokeServer("WearAccessory", getAccessoryArgs(accessoryType)) end)
        if not equipSuccess then warn("3D Equip failed:", result) end
        return equipSuccess
    elseif isBodyPart then
        local equipSuccess, result = pcall(function()
            return EditorCall:InvokeServer("WearBodyPart", {
                AssetType=typeName,BundledItems={},CreatorHasVerifiedBadge=productInfo.CreatorHasVerifiedBadge or false,CreatorName=productInfo.Creator and productInfo.Creator.Name or "Unknown",CreatorTargetId=productInfo.Creator and (productInfo.Creator.Id or productInfo.Creator.CreatorTargetId) or 1,CreatorType=productInfo.Creator and productInfo.Creator.CreatorType or "User",Description=productInfo.Description or "",FavoriteCount=0,Id=assetId,IsOffSale=not productInfo.IsForSale,ItemRestrictions={},ItemStatus={},ItemType="Asset",Name=productInfo.Name or "Unknown",SaleLocationType=productInfo.IsForSale and "ShopAndAllExperiences" or "NotApplicable"
            })
        end)
        if not equipSuccess then warn("Body Part Equip failed:", result) end
        return equipSuccess
    else
        local accessoryType = getStandardAccessoryType(assetType)
        local args = getAccessoryArgs(accessoryType)
        warn("Attempting to equip:", accessoryType, "ID:", assetId)
        local equipSuccess, result = pcall(function() return EditorCall:InvokeServer("WearAccessory", args) end)
        if not equipSuccess then 
            warn("Standard Accessory Equip failed for", accessoryType, ":", result)
            warn("Args sent:", game:GetService("HttpService"):JSONEncode(args))
        end
        return equipSuccess
    end
end

local function applySkinTone(skinColor)
    if not EditorCall then return false end
    return pcall(function() return EditorCall:InvokeServer("ChangeSkinTone", skinColor) end)
end

local function createCard(id, typeLabel, colorOverride, rawTypeEnum, extraData)
    if not id or (type(id)=="number" and id<=0) then return end
    
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1,-10,0,85)
    card.BackgroundColor3 = COLOR_CARD
    card.BorderSizePixel = 0
    card.Parent = ItemList
    Instance.new("UICorner", card).CornerRadius = UDim.new(0,8)

    local img = Instance.new("ImageLabel", card)
    img.Size = UDim2.new(0,65,0,65)
    img.Position = UDim2.new(0,10,0.5,-32)
    img.BackgroundColor3 = typeLabel=="SKIN TONE" and extraData or COLOR_BG
    img.Image = typeLabel=="SKIN TONE" and "" or ("rbxthumb://type=Asset&id="..id.."&w=150&h=150")
    img.BorderSizePixel = 0
    Instance.new("UICorner", img).CornerRadius = UDim.new(0,6)

    local name = Instance.new("TextLabel", card)
    name.Size,name.Position = UDim2.new(0.5,-10,0,20),UDim2.new(0,85,0,12)
    name.Text = typeLabel=="SKIN TONE" and "Skin Tone" or "Loading..."
    name.TextColor3,name.Font,name.TextSize = COLOR_TEXT,Enum.Font.GothamBold,11
    name.TextXAlignment,name.TextTruncate = Enum.TextXAlignment.Left,Enum.TextTruncate.AtEnd
    name.BackgroundTransparency = 1
    name.Parent = card

    local details = Instance.new("TextLabel", card)
    details.Size,details.Position = UDim2.new(0.5,-10,0,18),UDim2.new(0,85,0,34)
    details.Text = typeLabel=="SKIN TONE" and string.format("RGB(%d,%d,%d)",math.floor(extraData.R*255),math.floor(extraData.G*255),math.floor(extraData.B*255)) or typeLabel
    details.TextColor3,details.Font,details.TextSize = colorOverride,Enum.Font.GothamSemibold,10
    details.TextXAlignment,details.TextTruncate = Enum.TextXAlignment.Left,Enum.TextTruncate.AtEnd
    details.BackgroundTransparency = 1
    details.Parent = card

    local idLabel = Instance.new("TextLabel", card)
    idLabel.Size,idLabel.Position = UDim2.new(0.5,-10,0,16),UDim2.new(0,85,0,54)
    idLabel.Text = typeLabel=="SKIN TONE" and string.format("Color3.new(%.2f,%.2f,%.2f)",extraData.R,extraData.G,extraData.B) or ("ID: "..id)
    idLabel.TextColor3,idLabel.Font,idLabel.TextSize = Color3.fromRGB(120,120,130),Enum.Font.Gotham,9
    idLabel.TextXAlignment = Enum.TextXAlignment.Left
    idLabel.BackgroundTransparency = 1
    idLabel.Parent = card

    local copyBtn = Instance.new("TextButton", card)
    copyBtn.Size = UDim2.new(0,90,0,25)
    copyBtn.Position = UDim2.new(1,-100,0.5,-12)
    copyBtn.BackgroundColor3 = COLOR_BG
    copyBtn.Text = "COPY AUTHOR"
    copyBtn.TextColor3,copyBtn.Font,copyBtn.TextSize = COLOR_TEXT,Enum.Font.GothamBold,8
    copyBtn.BorderSizePixel = 0
    Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0,4)

    local wearBtn = Instance.new("TextButton", card)
    wearBtn.Size = UDim2.new(0,65,0,25)
    wearBtn.Position = UDim2.new(1,-175,0.5,-12)
    wearBtn.BackgroundColor3,wearBtn.Text = COLOR_BG,"EQUIP"
    wearBtn.TextColor3,wearBtn.Font,wearBtn.TextSize = colorOverride,Enum.Font.GothamBold,9
    wearBtn.BorderSizePixel = 0
    Instance.new("UICorner", wearBtn).CornerRadius = UDim.new(0,4)

    if typeLabel:find("ANIM") or typeLabel:find("EMOTE") or typeLabel:find("CLASSIC") or typeLabel:find("FACE") then
        wearBtn.Visible = false
        copyBtn.Position = UDim2.new(1,-95,0.5,-12)
    end
    
    if typeLabel=="SKIN TONE" then
        copyBtn.Text = "COPY COLOR"
        copyBtn.MouseButton1Click:Connect(function()
            setclipboard(string.format("Color3.new(%.10f,%.10f,%.10f)",extraData.R,extraData.G,extraData.B))
            copyBtn.Text = "COPIED!"
            task.wait(1)
            copyBtn.Text = "COPY COLOR"
        end)
        
        wearBtn.MouseButton1Click:Connect(function()
            if not EditorCall then
                wearBtn.Text,wearBtn.BackgroundColor3 = "ERROR",COLOR_ANIM
                task.wait(1.5)
                wearBtn.Text,wearBtn.BackgroundColor3 = "EQUIP",COLOR_BG
                return
            end
            wearBtn.Text = "..."
            local success = applySkinTone(extraData)
            wearBtn.Text,wearBtn.BackgroundColor3 = success and "APPLIED!" or "FAILED",success and COLOR_BODY or COLOR_ANIM
            task.wait(1.5)
            wearBtn.Text,wearBtn.BackgroundColor3 = "EQUIP",COLOR_BG
        end)
        return
    end

    wearBtn.MouseButton1Click:Connect(function()
        if not EditorCall then
            wearBtn.Text,wearBtn.BackgroundColor3 = "ERROR",COLOR_ANIM
            task.wait(1.5)
            wearBtn.Text,wearBtn.BackgroundColor3 = "EQUIP",COLOR_BG
            return
        end
        wearBtn.Text = "..."
        local success = wearOnBerry(id, rawTypeEnum)
        wearBtn.Text,wearBtn.BackgroundColor3 = success and "SENT!" or "FAILED",success and COLOR_BODY or COLOR_ANIM
        task.wait(1.5)
        wearBtn.Text,wearBtn.BackgroundColor3 = "EQUIP",COLOR_BG
    end)

    task.spawn(function()
        local success, data = pcall(function() return MarketplaceService:GetProductInfo(id, Enum.InfoType.Asset) end)
        if success and data then
            name.Text,details.Text = data.Name,typeLabel.." | "..data.Creator.Name
            copyBtn.MouseButton1Click:Connect(function()
                setclipboard(data.Creator.Name)
                copyBtn.Text = "COPIED!"
                task.wait(1)
                copyBtn.Text = "COPY AUTHOR"
            end)
        else
            name.Text,details.Text = "Asset "..id,typeLabel.." | Unknown"
            copyBtn.MouseButton1Click:Connect(function()
                setclipboard(tostring(id))
                copyBtn.Text = "COPIED!"
                task.wait(1)
                copyBtn.Text = "COPY AUTHOR"
            end)
        end
    end)
end

local function sniff(player)
    if not player or not player.Character then StatusText.Text = "ERROR: Invalid player" return end
    
    for _, child in pairs(ItemList:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    StatusText.Text = "SCANNING: "..player.Name:upper()
    
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then StatusText.Text = "ERROR: No humanoid" return end
    
    local success, description = pcall(function() return humanoid:GetAppliedDescription() end)
    if not success or not description then StatusText.Text = "ERROR: Cannot read" return end

    local itemCount = 0
    local standardAccessories,faceAccessories,clothing3D,classicClothes,bodyParts,animations,emotes,skinTone = {},{},{},{},{},{},{},nil

    local accSuccess, accessories = pcall(function() return description:GetAccessories(true) end)
    if accSuccess and accessories then
        for _, item in pairs(accessories) do
            local typeName = tostring(item.AccessoryType):split(".")[3] or "Unknown"
            local is3D = is3DClothing(item.AccessoryType)
            local isFace = isFaceAccessory(item.AccessoryType)
            
            if isFace then
                table.insert(faceAccessories, {item.AssetId,"FACE: "..typeName:upper(),COLOR_FACE,item.AccessoryType})
            elseif is3D then
                table.insert(clothing3D, {item.AssetId,"3D: "..typeName:upper(),COLOR_3D,item.AccessoryType})
            else
                table.insert(standardAccessories, {item.AssetId,"ACC: "..typeName:upper(),COLOR_ACCENT,item.AccessoryType})
            end
        end
    end

    if description.Shirt and description.Shirt>0 then table.insert(classicClothes, {description.Shirt,"CLASSIC: SHIRT",COLOR_CLASSIC,"Shirt"}) end
    if description.Pants and description.Pants>0 then table.insert(classicClothes, {description.Pants,"CLASSIC: PANTS",COLOR_CLASSIC,"Pants"}) end
    if description.GraphicTShirt and description.GraphicTShirt>0 then table.insert(classicClothes, {description.GraphicTShirt,"CLASSIC: T-SHIRT",COLOR_CLASSIC,"GraphicTShirt"}) end

    local limbs = {{description.Head,"HEAD","Head"},{description.Torso,"TORSO","Torso"},{description.LeftArm,"L-ARM","LeftArm"},{description.RightArm,"R-ARM","RightArm"},{description.LeftLeg,"L-LEG","LeftLeg"},{description.RightLeg,"R-LEG","RightLeg"},{description.Face,"FACE","Face"}}
    for _, limb in pairs(limbs) do if limb[1] and limb[1]>0 then table.insert(bodyParts, {limb[1],"BODY: "..limb[2],COLOR_BODY,limb[3]}) end end

    local anims = {{description.IdleAnimation,"IDLE"},{description.WalkAnimation,"WALK"},{description.RunAnimation,"RUN"},{description.JumpAnimation,"JUMP"},{description.ClimbAnimation,"CLIMB"},{description.FallAnimation,"FALL"}}
    for _, anim in pairs(anims) do if anim[1] and anim[1]>0 then table.insert(animations, {anim[1],"ANIM: "..anim[2],COLOR_ANIM,"Anim"}) end end
    
    local emoteSuccess, emotesList = pcall(function() return description:GetEmotes() end)
    if emoteSuccess and emotesList then
        for _, emote in pairs(emotesList) do
            local emoteId = (type(emote)=="table" and (emote.AssetId or emote[1])) or emote
            if type(emoteId)=="number" and emoteId>0 then table.insert(emotes, {emoteId,"EMOTE",COLOR_ANIM,"Emote"}) end
        end
    end
    
    if description.HeadColor then skinTone = {"SkinTone","SKIN TONE",COLOR_SKINTONE,"SkinTone",description.HeadColor} end

    if skinTone then createCard(skinTone[1],skinTone[2],skinTone[3],skinTone[4],skinTone[5]) itemCount=itemCount+1 end
    for _, item in pairs(standardAccessories) do createCard(item[1],item[2],item[3],item[4]) itemCount=itemCount+1 end
    for _, item in pairs(faceAccessories) do createCard(item[1],item[2],item[3],item[4]) itemCount=itemCount+1 end
    for _, item in pairs(clothing3D) do createCard(item[1],item[2],item[3],item[4]) itemCount=itemCount+1 end
    for _, item in pairs(classicClothes) do createCard(item[1],item[2],item[3],item[4]) itemCount=itemCount+1 end
    for _, item in pairs(bodyParts) do createCard(item[1],item[2],item[3],item[4]) itemCount=itemCount+1 end
    for _, item in pairs(animations) do createCard(item[1],item[2],item[3],item[4]) itemCount=itemCount+1 end
    for _, item in pairs(emotes) do createCard(item[1],item[2],item[3],item[4]) itemCount=itemCount+1 end

    StatusText.Text = string.format("VIEWING: %s (%d items)",player.Name:upper(),itemCount)
    
    -- Store items globally for Equip All button
    _G.CurrentPlayerItems = {
        skinTone = skinTone,
        standardAccessories = standardAccessories,
        clothing3D = clothing3D,
        bodyParts = bodyParts
    }
end

local function refreshPlayerList()
    for _, child in pairs(PlayerList:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    
    local playerCount = 0
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.95,0,0,38)
            btn.BackgroundColor3 = Color3.fromRGB(30,30,35)
            btn.Text = "  "..player.Name
            btn.TextColor3,btn.Font,btn.TextSize = COLOR_TEXT,Enum.Font.GothamSemibold,11
            btn.TextXAlignment,btn.TextTruncate = Enum.TextXAlignment.Left,Enum.TextTruncate.AtEnd
            btn.BorderSizePixel = 0
            btn.Parent = PlayerList
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
            btn.MouseButton1Click:Connect(function() sniff(player) end)
            playerCount = playerCount + 1
        end
    end
    
    if playerCount==0 then
        local noPlayers = Instance.new("TextLabel", PlayerList)
        noPlayers.Size = UDim2.new(1,0,0,50)
        noPlayers.Text,noPlayers.TextColor3 = "No other players",Color3.fromRGB(120,120,130)
        noPlayers.Font,noPlayers.TextSize = Enum.Font.Gotham,10
        noPlayers.BackgroundTransparency = 1
    end
end

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
RefreshBtn.MouseButton1Click:Connect(function() refreshPlayerList() RefreshBtn.Text="UPDATED" task.wait(1) RefreshBtn.Text="REFRESH" end)

EquipAllBtn.MouseButton1Click:Connect(function()
    if not _G.CurrentPlayerItems then
        EquipAllBtn.Text = "NO PLAYER"
        task.wait(1.5)
        EquipAllBtn.Text = "EQUIP ALL"
        return
    end
    
    EquipAllBtn.Text = "EQUIPPING..."
    EquipAllBtn.BackgroundColor3 = COLOR_ANIM
    
    local totalItems = 0
    local successCount = 0
    
    -- 1. Apply Skin Tone first
    if _G.CurrentPlayerItems.skinTone then
        totalItems = totalItems + 1
        if applySkinTone(_G.CurrentPlayerItems.skinTone[5]) then
            successCount = successCount + 1
        end
        task.wait(0.15)
    end
    
    -- 2. Equip Body Parts
    for _, item in pairs(_G.CurrentPlayerItems.bodyParts) do
        totalItems = totalItems + 1
        if wearOnBerry(item[1], item[4]) then
            successCount = successCount + 1
        end
        task.wait(0.15)
    end
    
    -- 3. Equip Standard Accessories (excluding face)
    for _, item in pairs(_G.CurrentPlayerItems.standardAccessories) do
        totalItems = totalItems + 1
        if wearOnBerry(item[1], item[4]) then
            successCount = successCount + 1
        end
        task.wait(0.15)
    end
    
    -- 4. Equip 3D Clothing
    for _, item in pairs(_G.CurrentPlayerItems.clothing3D) do
        totalItems = totalItems + 1
        if wearOnBerry(item[1], item[4]) then
            successCount = successCount + 1
        end
        task.wait(0.15)
    end
    
    EquipAllBtn.Text = string.format("%d/%d OK", successCount, totalItems)
    EquipAllBtn.BackgroundColor3 = COLOR_BODY
    task.wait(2)
    EquipAllBtn.Text = "EQUIP ALL"
    EquipAllBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
end)

Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

refreshPlayerList()
if not EditorCall then StatusText.Text,StatusText.TextColor3 = "WARNING: EditorCall not found",COLOR_ANIM end