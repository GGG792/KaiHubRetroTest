--[[
    Player Intel Scanner - 本地版 (仅供娱乐)
    纯本地获取，不依赖网络API
]]

if not game:IsLoaded() then game.Loaded:Wait() end

if _G.PlayerIntelLoaded then
    warn("[PlayerIntel] 已经加载了！")
    return
end
_G.PlayerIntelLoaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local C = {
    WinBg = Color3.fromRGB(30, 30, 46);
    WinTitle = Color3.fromRGB(24, 24, 37);
    TitleText = Color3.fromRGB(205, 214, 244);
    Accent = Color3.fromRGB(137, 180, 250);
    Surface0 = Color3.fromRGB(49, 50, 68);
    Surface1 = Color3.fromRGB(69, 71, 90);
    Surface2 = Color3.fromRGB(88, 91, 112);
    Text = Color3.fromRGB(205, 214, 244);
    TextDim = Color3.fromRGB(147, 153, 178);
    TextSub = Color3.fromRGB(186, 194, 222);
    Green = Color3.fromRGB(166, 227, 161);
    Yellow = Color3.fromRGB(249, 226, 175);
    Red = Color3.fromRGB(243, 139, 168);
    Blue = Color3.fromRGB(137, 180, 250);
    ScrollThumb = Color3.fromRGB(88, 91, 112);
    ScrollTrack = Color3.fromRGB(30, 30, 46);
    CloseBtn = Color3.fromRGB(243, 139, 168);
    CloseHover = Color3.fromRGB(250, 100, 130);
    MinBtn = Color3.fromRGB(69, 71, 90);
    MinHover = Color3.fromRGB(108, 112, 134);
    CardBg = Color3.fromRGB(49, 50, 68);
    CardBorder = Color3.fromRGB(69, 71, 90);
    InputBg = Color3.fromRGB(24, 24, 37);
}

local function notify(t, txt)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title=t, Text=txt, Duration=3})
    end)
end

-- ========== 数据 ==========
local playerCards = {}
local chatLogs = {}
local conns = {}

-- ========== UI ==========
local gui = Instance.new("ScreenGui")
gui.Name = "PlayerIntel"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LP:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 400, 0, 320)
main.Position = UDim2.new(0.5, -200, 0.5, -160)
main.BackgroundColor3 = C.WinBg
main.BorderSizePixel = 0
main.Active = true
main.Selectable = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", main).Color = C.Surface2
Instance.new("UIStroke", main).Thickness = 1

-- 标题栏（TextButton用于拖拽）
local titleBar = Instance.new("TextButton")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = C.WinTitle
titleBar.BorderSizePixel = 0
titleBar.Text = ""
titleBar.AutoButtonColor = false
titleBar.Active = true
titleBar.Selectable = true
titleBar.Parent = main
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

-- 修复标题栏底部圆角
local titleFill = Instance.new("Frame")
titleFill.Size = UDim2.new(1, 0, 0, 10)
titleFill.Position = UDim2.new(0, 0, 1, -10)
titleFill.BackgroundColor3 = C.WinTitle
titleFill.BorderSizePixel = 0
titleFill.ZIndex = 0
titleFill.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -100, 0, 16)
titleLabel.Position = UDim2.new(0, 12, 0, 2)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Player Intel Scanner"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 13
titleLabel.TextColor3 = C.TitleText
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 5
titleLabel.Parent = titleBar

local subLabel = Instance.new("TextLabel")
subLabel.Size = UDim2.new(1, -100, 0, 12)
subLabel.Position = UDim2.new(0, 12, 0, 18)
subLabel.BackgroundTransparency = 1
subLabel.Text = "仅供娱乐"
subLabel.Font = Enum.Font.Gotham
subLabel.TextSize = 9
subLabel.TextColor3 = C.TextDim
subLabel.TextXAlignment = Enum.TextXAlignment.Left
subLabel.ZIndex = 5
subLabel.Parent = titleBar

local countLabel = Instance.new("TextLabel")
countLabel.Size = UDim2.new(0, 50, 0, 16)
countLabel.Position = UDim2.new(1, -110, 0, 8)
countLabel.BackgroundTransparency = 1
countLabel.Text = "0"
countLabel.Font = Enum.Font.GothamBold
countLabel.TextSize = 11
countLabel.TextColor3 = C.Accent
countLabel.TextXAlignment = Enum.TextXAlignment.Right
countLabel.ZIndex = 5
countLabel.Parent = titleBar

-- 最小化按钮
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -56, 0, 4)
minBtn.BackgroundColor3 = C.MinBtn
minBtn.BorderSizePixel = 0
minBtn.Text = "_"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.TextColor3 = C.Text
minBtn.AutoButtonColor = false
minBtn.Active = true
minBtn.ZIndex = 10
minBtn.Parent = titleBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

-- 关闭按钮
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -28, 0, 4)
closeBtn.BackgroundColor3 = C.Surface1
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 11
closeBtn.TextColor3 = C.Text
closeBtn.AutoButtonColor = false
closeBtn.Active = true
closeBtn.ZIndex = 10
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- 搜索框
local searchFrame = Instance.new("Frame")
searchFrame.Size = UDim2.new(1, -16, 0, 26)
searchFrame.Position = UDim2.new(0, 8, 0, 38)
searchFrame.BackgroundColor3 = C.InputBg
searchFrame.BorderSizePixel = 0
searchFrame.Parent = main
Instance.new("UICorner", searchFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", searchFrame).Color = C.Surface2
Instance.new("UIStroke", searchFrame).Thickness = 1

local searchInput = Instance.new("TextBox")
searchInput.Size = UDim2.new(1, -10, 1, 0)
searchInput.Position = UDim2.new(0, 5, 0, 0)
searchInput.BackgroundTransparency = 1
searchInput.Text = ""
searchInput.PlaceholderText = "搜索玩家..."
searchInput.PlaceholderColor3 = C.TextDim
searchInput.Font = Enum.Font.Gotham
searchInput.TextSize = 11
searchInput.TextColor3 = C.Text
searchInput.TextXAlignment = Enum.TextXAlignment.Left
searchInput.ClearTextOnFocus = false
searchInput.Parent = searchFrame

-- 刷新按钮
local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0, 26, 0, 26)
refreshBtn.Position = UDim2.new(1, -42, 0, 38)
refreshBtn.BackgroundColor3 = C.Surface1
refreshBtn.BorderSizePixel = 0
refreshBtn.Text = "R"
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = 11
refreshBtn.TextColor3 = C.Accent
refreshBtn.AutoButtonColor = false
refreshBtn.Active = true
refreshBtn.Parent = main
Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 6)

-- 滚动区域
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -16, 1, -72)
scroll.Position = UDim2.new(0, 8, 0, 70)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = C.ScrollThumb
scroll.ScrollBarBackgroundColor3 = C.ScrollTrack
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = main

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = scroll

-- 状态栏
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, 0, 0, 20)
statusBar.Position = UDim2.new(0, 0, 1, -20)
statusBar.BackgroundColor3 = C.Surface0
statusBar.BorderSizePixel = 0
statusBar.Parent = main

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -8, 1, 0)
statusLabel.Position = UDim2.new(0, 8, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "正在扫描..."
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.TextColor3 = C.TextDim
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = statusBar

-- ========== 创建玩家卡片（纯本地） ==========
local function makeCard(player)
    if playerCards[player.UserId] then return end

    local uid = player.UserId
    local card = Instance.new("Frame")
    card.Name = player.Name
    card.Size = UDim2.new(1, 0, 0, 0)
    card.BackgroundColor3 = C.CardBg
    card.BorderSizePixel = 0
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.Parent = scroll

    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    local cs = Instance.new("UIStroke", card)
    cs.Color = C.CardBorder
    cs.Thickness = 1

    local pad = Instance.new("UIPadding", card)
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)

    -- 头部
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 32)
    header.BackgroundTransparency = 1
    header.Parent = card

    -- 头像背景
    local avBg = Instance.new("Frame")
    avBg.Size = UDim2.new(0, 28, 0, 28)
    avBg.BackgroundColor3 = C.Surface2
    avBg.BorderSizePixel = 0
    avBg.Parent = header
    Instance.new("UICorner", avBg).CornerRadius = UDim.new(1, 0)

    -- 头像文字（首字母）
    local avLetter = Instance.new("TextLabel")
    avLetter.Size = UDim2.new(1, 0, 1, 0)
    avLetter.BackgroundTransparency = 1
    avLetter.Text = player.DisplayName:sub(1, 1):upper()
    avLetter.Font = Enum.Font.GothamBold
    avLetter.TextSize = 14
    avLetter.TextColor3 = C.Accent
    avLetter.Parent = avBg

    -- 显示名
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -38, 0, 15)
    nameLbl.Position = UDim2.new(0, 34, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = player.DisplayName
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 12
    nameLbl.TextColor3 = C.Text
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    nameLbl.Parent = header

    -- 用户名+标签
    local tags = "@" .. player.Name
    if player.MembershipType == Enum.MembershipType.Premium then tags = tags .. " [PREM]" end
    if player:IsFriendsWith(LP.UserId) then tags = tags .. " [好友]" end

    local userLbl = Instance.new("TextLabel")
    userLbl.Size = UDim2.new(1, -38, 0, 13)
    userLbl.Position = UDim2.new(0, 34, 0, 15)
    userLbl.BackgroundTransparency = 1
    userLbl.Text = tags
    userLbl.Font = Enum.Font.Gotham
    userLbl.TextSize = 9
    userLbl.TextColor3 = C.TextDim
    userLbl.TextXAlignment = Enum.TextXAlignment.Left
    userLbl.TextTruncate = Enum.TextTruncate.AtEnd
    userLbl.Parent = header

    -- 分隔线
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, 0, 0, 1)
    sep.BackgroundColor3 = C.Surface2
    sep.BorderSizePixel = 0
    sep.Parent = card

    -- 信息区域
    local info = Instance.new("Frame")
    info.Size = UDim2.new(1, 0, 0, 0)
    info.BackgroundTransparency = 1
    info.AutomaticSize = Enum.AutomaticSize.Y
    info.Parent = card

    local infoLayout = Instance.new("UIListLayout")
    infoLayout.SortOrder = Enum.SortOrder.LayoutOrder
    infoLayout.Padding = UDim.new(0, 1)
    infoLayout.Parent = info

    local function row(label, value, color)
        local r = Instance.new("Frame")
        r.Size = UDim2.new(1, 0, 0, 13)
        r.BackgroundTransparency = 1
        r.Parent = info

        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0, 65, 1, 0)
        l.BackgroundTransparency = 1
        l.Text = label
        l.Font = Enum.Font.Gotham
        l.TextSize = 9
        l.TextColor3 = C.TextDim
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = r

        local v = Instance.new("TextLabel")
        v.Size = UDim2.new(1, -70, 1, 0)
        v.Position = UDim2.new(0, 68, 0, 0)
        v.BackgroundTransparency = 1
        v.Text = value or ""
        v.Font = Enum.Font.GothamBold
        v.TextSize = 9
        v.TextColor3 = color or C.TextSub
        v.TextXAlignment = Enum.TextXAlignment.Left
        v.TextTruncate = Enum.TextTruncate.AtEnd
        v.Parent = r
        return v
    end

    local function section(title)
        local s = Instance.new("TextLabel")
        s.Size = UDim2.new(1, 0, 0, 14)
        s.BackgroundTransparency = 1
        s.Text = "> " .. title
        s.Font = Enum.Font.GothamBold
        s.TextSize = 10
        s.TextColor3 = C.Accent
        s.TextXAlignment = Enum.TextXAlignment.Left
        s.Parent = info
    end

    -- 基础信息
    section("基础信息")
    row("ID:", tostring(uid), C.TextDim)
    row("会员:", player.MembershipType == Enum.MembershipType.Premium and "Premium" or "免费", player.MembershipType == Enum.MembershipType.Premium and C.Yellow or C.TextDim)
    row("好友:", tostring(player:IsFriendsWith(LP.UserId) and "是" or "否"), player:IsFriendsWith(LP.UserId) and C.Green or C.TextDim)

    -- 游戏信息
    section("游戏信息")
    local joinTime = os.date("%H:%M:%S")
    row("加入时间:", joinTime)
    local playLbl = row("游玩时长:", "0秒")
    local chatLbl = row("消息:", "0条")
    local lastMsgLbl = row("最近:", "无")

    -- 角色信息（实时）
    section("角色(实时)")
    local healthLbl = row("血量:", "...")
    local speedLbl = row("移速:", "...")
    local jumpLbl = row("跳跃:", "...")
    local posLbl = row("坐标:", "...")

    -- 角色外观
    section("角色外观")
    local bodyParts = row("部件数:", "...")
    local accessories = row("配件数:", "...")
    local shirtColor = row("衬衫:", "...")
    local pantsColor = row("裤子:", "...")

    -- 缓存
    playerCards[uid] = {
        card = card,
        playLbl = playLbl,
        chatLbl = chatLbl,
        lastMsgLbl = lastMsgLbl,
        healthLbl = healthLbl,
        speedLbl = speedLbl,
        jumpLbl = jumpLbl,
        posLbl = posLbl,
        bodyParts = bodyParts,
        accessories = accessories,
        shirtColor = shirtColor,
        pantsColor = pantsColor,
        joinTick = tick()
    }

    -- 聊天监控
    chatLogs[uid] = {msgs = {}}
    local chatConn = LP.Chatted:Connect(function(msg, target)
        if target and target.UserId == uid then
            table.insert(chatLogs[uid].msgs, msg)
            if #chatLogs[uid].msgs > 50 then table.remove(chatLogs[uid].msgs, 1) end
        end
    end)
    table.insert(conns, chatConn)

    -- 实时更新
    task.spawn(function()
        while card and card.Parent and player.Parent do
            task.wait(1)
            pcall(function()
                local ch = player.Character
                if ch then
                    local hum = ch:FindFirstChildOfClass("Humanoid")
                    local root = ch:FindFirstChild("HumanoidRootPart")
                    if hum then
                        healthLbl.Text = string.format("%.0f / %.0f", hum.Health, hum.MaxHealth)
                        speedLbl.Text = tostring(hum.WalkSpeed)
                        jumpLbl.Text = tostring(hum.JumpPower)
                    end
                    if root then
                        local p = root.Position
                        posLbl.Text = string.format("(%.0f, %.0f, %.0f)", p.X, p.Y, p.Z)
                    end

                    -- 角色外观
                    local parts = 0
                    local accs = 0
                    local shirtC = "无"
                    local pantsC = "无"
                    for _, child in ipairs(ch:GetChildren()) do
                        if child:IsA("BasePart") or child:IsA("Humanoid") then
                            parts = parts + 1
                        elseif child:IsA("Accessory") then
                            accs = accs + 1
                        end
                    end
                    local shirt = ch:FindFirstChild("Shirt")
                    if shirt and shirt:IsA("Shirt") then
                        shirtC = "有"
                    end
                    local pants = ch:FindFirstChild("Pants")
                    if pants and pants:IsA("Pants") then
                        pantsC = "有"
                    end
                    bodyParts.Text = tostring(parts)
                    accessories.Text = tostring(accs)
                    shirtColor.Text = shirtC
                    pantsColor.Text = pantsC
                end

                -- 游玩时长
                local elapsed = tick() - playerCards[uid].joinTick
                local h = math.floor(elapsed / 3600)
                local m = math.floor((elapsed % 3600) / 60)
                local s = math.floor(elapsed % 60)
                playLbl.Text = string.format("%d时%d分%d秒", h, m, s)

                -- 聊天
                if chatLogs[uid] then
                    chatLbl.Text = #chatLogs[uid].msgs .. "条"
                    if #chatLogs[uid].msgs > 0 then
                        lastMsgLbl.Text = chatLogs[uid].msgs[#chatLogs[uid].msgs]:sub(1, 25)
                    end
                end
            end)
        end
    end)
end

-- ========== 扫描所有玩家 ==========
local function scanAll()
    local playerList = Players:GetPlayers()
    for _, plr in ipairs(playerList) do
        makeCard(plr)
    end
    countLabel.Text = tostring(#playerList)
    statusLabel.Text = "就绪 | " .. #playerList .. " 名玩家"
end

-- ========== 事件绑定 ==========

-- 最小化
local minimized = false
local minIcon

minBtn.MouseButton1Click:Connect(function()
    minimized = true
    main.Visible = false
    if not minIcon then
        minIcon = Instance.new("TextButton")
        minIcon.Size = UDim2.new(0, 110, 0, 30)
        minIcon.Position = UDim2.new(0, 10, 1, -40)
        minIcon.BackgroundColor3 = C.Surface0
        minIcon.BorderSizePixel = 0
        minIcon.Text = "  PlayerIntel"
        minIcon.Font = Enum.Font.GothamBold
        minIcon.TextSize = 11
        minIcon.TextColor3 = C.Accent
        minIcon.TextXAlignment = Enum.TextXAlignment.Left
        minIcon.AutoButtonColor = false
        minIcon.Active = true
        minIcon.Parent = gui
        Instance.new("UICorner", minIcon).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", minIcon).Color = C.Surface2

        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 8, 0, 8)
        dot.Position = UDim2.new(0, 8, 0.5, -4)
        dot.BackgroundColor3 = C.Green
        dot.BorderSizePixel = 0
        dot.Parent = minIcon
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        minIcon.MouseButton1Click:Connect(function()
            minimized = false
            main.Visible = true
            minIcon.Visible = false
        end)
    end
    minIcon.Visible = true
end)

-- 关闭
closeBtn.MouseButton1Click:Connect(function()
    for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    conns = {}
    playerCards = {}
    chatLogs = {}
    gui:Destroy()
    _G.PlayerIntelLoaded = false
    notify("PlayerIntel", "已关闭")
end)

-- 刷新
refreshBtn.MouseButton1Click:Connect(function()
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    playerCards = {}
    chatLogs = {}
    scanAll()
    notify("PlayerIntel", "刷新完成")
end)

-- 搜索
searchInput:GetPropertyChangedSignal("Text"):Connect(function()
    local q = string.lower(searchInput.Text)
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("Frame") then
            child.Visible = (q == "" or string.find(string.lower(child.Name), q))
        end
    end
end)

-- 悬停效果
minBtn.MouseEnter:Connect(function() minBtn.BackgroundColor3 = C.MinHover end)
minBtn.MouseLeave:Connect(function() minBtn.BackgroundColor3 = C.MinBtn end)
closeBtn.MouseEnter:Connect(function() closeBtn.BackgroundColor3 = C.CloseBtn end)
closeBtn.MouseLeave:Connect(function() closeBtn.BackgroundColor3 = C.Surface1 end)
refreshBtn.MouseEnter:Connect(function() refreshBtn.BackgroundColor3 = C.Surface2 end)
refreshBtn.MouseLeave:Connect(function() refreshBtn.BackgroundColor3 = C.Surface1 end)

-- 拖拽
local dragging = false
local dragStart, startPos
titleBar.MouseButton1Down:Connect(function(x, y)
    dragging = true
    dragStart = Vector2.new(x, y)
    startPos = main.Position
end)
titleBar.TouchPan:Connect(function(_, _, _, _, _, y, velocity)
    if not dragging then return end
    local delta = velocity * 0.5
    main.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ========== 初始扫描 ==========
scanAll()

-- 每10秒重复扫描
local scanConn = RunService.Heartbeat:Connect(function()
    if tick() % 10 < 0.1 then scanAll() end
end)
table.insert(conns, scanConn)

-- 玩家加入
table.insert(conns, Players.PlayerAdded:Connect(function(plr)
    task.wait(0.5)
    makeCard(plr)
    scanAll()
    notify("PlayerIntel", plr.DisplayName .. " 加入")
end))

-- 玩家离开
table.insert(conns, Players.PlayerRemoving:Connect(function(plr)
    if playerCards[plr.UserId] and playerCards[plr.UserId].card then
        playerCards[plr.UserId].card:Destroy()
    end
    playerCards[plr.UserId] = nil
    chatLogs[plr.UserId] = nil
    scanAll()
end))

notify("PlayerIntel Scanner", "仅供娱乐 - 开始扫描")
