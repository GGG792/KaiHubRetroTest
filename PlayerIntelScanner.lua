--[[
    Player Intel Scanner - 全功能玩家信息扫描器 (仅供娱乐)
    获取服务器内所有玩家的详细信息
]]

if not game:IsLoaded() then game.Loaded:Wait() end

if _G.PlayerIntelLoaded then
    warn("[PlayerIntel] 已经加载了！请不要重复执行。")
    return
end
_G.PlayerIntelLoaded = true

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- ========== 配色 ==========
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

local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 3})
    end)
end

-- ========== API ==========
local function apiGet(url)
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok and res then
        local ok2, data = pcall(function() return HttpService:JSONDecode(res) end)
        if ok2 then return data end
    end
    return nil
end

local function getAccountAge(userId)
    local data = apiGet("https://users.roblox.com/v1/users/" .. tostring(userId))
    if data and data.created then
        local y, m, d = data.created:match("(%d+)-(%d+)-(%d+)")
        if y then
            local ageDays = math.floor((os.time() - os.time({year=tonumber(y),month=tonumber(m),day=tonumber(d)})) / 86400)
            return string.format("%d年%d月%d日 (%d天)", tonumber(y), tonumber(m), tonumber(d), ageDays)
        end
    end
    return "未知"
end

local function getPlayerDesc(userId)
    local data = apiGet("https://users.roblox.com/v1/users/" .. tostring(userId))
    if data then return data.description or "无简介" end
    return "获取失败"
end

local function getPresence(userId)
    local ok, res = pcall(function()
        local body = HttpService:JSONEncode({userIds = {userId}})
        local r = game:HttpPost("https://presence.roblox.com/v1/presence/users", body, Enum.HttpContentType.ApplicationJson)
        local d = HttpService:JSONDecode(r)
        if d.userPresences and #d.userPresences > 0 then return d.userPresences[1] end
    end)
    if ok and res then
        local names = {["0"]="离线",["1"]="在线",["2"]="游戏中",["3"]="工作室",["4"]="隐形"}
        return names[tostring(res.userPresenceType)] or "未知"
    end
    return "在线"
end

local function getCount(url)
    local ok, res = pcall(function() return tonumber(game:HttpGet(url)) or 0 end)
    return ok and res or 0
end

local function getThumbnail(userId)
    local data = apiGet("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. tostring(userId) .. "&size=150x150&format=Png&isCircular=false")
    if data and data.data and #data.data > 0 then return data.data[1].imageUrl or "" end
    return ""
end

local function getWornAssets(userId)
    local data = apiGet("https://avatar.roblox.com/v1/users/" .. tostring(userId) .. "/currently-wearing")
    return data or {}
end

local function getAssetInfo(assetId)
    return apiGet("https://economy.roblox.com/v2/assets/" .. tostring(assetId) .. "/details")
end

local function getGroups(userId)
    local data = apiGet("https://groups.roblox.com/v2/users/" .. tostring(userId) .. "/groups/roles")
    local groups = {}
    if data and data.data then
        for _, g in ipairs(data.data) do
            table.insert(groups, g.group.name .. "(" .. g.role.name .. ")")
        end
    end
    return groups
end

-- ========== 数据缓存 ==========
local playerCache = {}
local chatLogs = {}
local conns = {}
local scannedPlayers = {}

-- ========== 聊天监控 ==========
local function monitorChat(player)
    if chatLogs[player.UserId] then return end
    chatLogs[player.UserId] = {msgs = {}, count = 0}
    local conn = LP.Chatted:Connect(function(msg, target)
        if target and target.UserId == player.UserId then
            table.insert(chatLogs[player.UserId].msgs, msg)
            if #chatLogs[player.UserId].msgs > 50 then
                table.remove(chatLogs[player.UserId].msgs, 1)
            end
        end
    end)
    table.insert(conns, conn)
end

-- ========== 创建UI ==========
local gui = Instance.new("ScreenGui")
gui.Name = "PlayerIntel"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LP:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 400, 0, 320)
main.Position = UDim2.new(0.5, -200, 0.5, -160)
main.BackgroundColor3 = C.WinBg
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = C.Surface2
mainStroke.Thickness = 1
mainStroke.Parent = main

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = C.WinTitle
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

-- 标题栏底部填充（修复圆角）
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
countLabel.Text = "0 人"
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
minBtn.ZIndex = 10
minBtn.Parent = titleBar

local minC = Instance.new("UICorner")
minC.CornerRadius = UDim.new(0, 6)
minC.Parent = minBtn

minBtn.MouseEnter:Connect(function() minBtn.BackgroundColor3 = C.MinHover end)
minBtn.MouseLeave:Connect(function() minBtn.BackgroundColor3 = C.MinBtn end)

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
closeBtn.ZIndex = 10
closeBtn.Parent = titleBar

local closeC = Instance.new("UICorner")
closeC.CornerRadius = UDim.new(0, 6)
closeC.Parent = closeBtn

closeBtn.MouseEnter:Connect(function() closeBtn.BackgroundColor3 = C.CloseBtn end)
closeBtn.MouseLeave:Connect(function() closeBtn.BackgroundColor3 = C.Surface1 end)

-- 搜索框
local searchFrame = Instance.new("Frame")
searchFrame.Size = UDim2.new(1, -16, 0, 26)
searchFrame.Position = UDim2.new(0, 8, 0, 38)
searchFrame.BackgroundColor3 = C.InputBg
searchFrame.BorderSizePixel = 0
searchFrame.Parent = main

local searchC = Instance.new("UICorner")
searchC.CornerRadius = UDim.new(0, 6)
searchC.Parent = searchFrame

local searchS = Instance.new("UIStroke")
searchS.Color = C.Surface2
searchS.Thickness = 1
searchS.Parent = searchFrame

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
refreshBtn.Parent = main

local refreshC = Instance.new("UICorner")
refreshC.CornerRadius = UDim.new(0, 6)
refreshC.Parent = refreshBtn

refreshBtn.MouseEnter:Connect(function() refreshBtn.BackgroundColor3 = C.Surface2 end)
refreshBtn.MouseLeave:Connect(function() refreshBtn.BackgroundColor3 = C.Surface1 end)

-- 滚动区域
local scroll = Instance.new("ScrollingFrame")
scroll.Name = "List"
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

-- ========== 创建玩家卡片 ==========
local function makeCard(player)
    if scannedPlayers[player.UserId] then return end
    scannedPlayers[player.UserId] = true

    local uid = player.UserId
    local card = Instance.new("Frame")
    card.Name = player.Name
    card.Size = UDim2.new(1, 0, 0, 0)
    card.BackgroundColor3 = C.CardBg
    card.BorderSizePixel = 0
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.Parent = scroll

    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 8)
    cc.Parent = card

    local cs = Instance.new("UIStroke")
    cs.Color = C.CardBorder
    cs.Thickness = 1
    cs.Parent = card

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.Parent = card

    -- 头部行
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 36)
    header.BackgroundTransparency = 1
    header.Parent = card

    -- 头像
    local avFrame = Instance.new("Frame")
    avFrame.Size = UDim2.new(0, 32, 0, 32)
    avFrame.BackgroundColor3 = C.Surface2
    avFrame.BorderSizePixel = 0
    avFrame.Parent = header

    local avC = Instance.new("UICorner")
    avC.CornerRadius = UDim.new(1, 0)
    avC.Parent = avFrame

    local avImg = Instance.new("ImageLabel")
    avImg.Size = UDim2.new(1, 0, 1, 0)
    avImg.BackgroundTransparency = 1
    avImg.Parent = avFrame

    pcall(function()
        local url = getThumbnail(uid)
        if url ~= "" then avImg.Image = url end
    end)

    -- 名字
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -42, 0, 16)
    nameLbl.Position = UDim2.new(0, 38, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = player.DisplayName
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 12
    nameLbl.TextColor3 = C.Text
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = header

    -- 用户名+标签
    local tagStr = "@" .. player.Name
    if player.MembershipType == Enum.MembershipType.Premium then tagStr = tagStr .. " [PREMIUM]" end
    if player:IsFriendsWith(LP.UserId) then tagStr = tagStr .. " [好友]" end

    local userLbl = Instance.new("TextLabel")
    userLbl.Size = UDim2.new(1, -42, 0, 14)
    userLbl.Position = UDim2.new(0, 38, 0, 16)
    userLbl.BackgroundTransparency = 1
    userLbl.Text = tagStr
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

    -- 信息列表
    local infoList = Instance.new("Frame")
    infoList.Size = UDim2.new(1, 0, 0, 0)
    infoList.BackgroundTransparency = 1
    infoList.AutomaticSize = Enum.AutomaticSize.Y
    infoList.Parent = card

    local infoLayout = Instance.new("UIListLayout")
    infoLayout.SortOrder = Enum.SortOrder.LayoutOrder
    infoLayout.Padding = UDim.new(0, 2)
    infoLayout.Parent = infoList

    local function addRow(label, value, color)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 14)
        row.BackgroundTransparency = 1
        row.Parent = infoList

        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0, 70, 1, 0)
        l.BackgroundTransparency = 1
        l.Text = label
        l.Font = Enum.Font.Gotham
        l.TextSize = 9
        l.TextColor3 = C.TextDim
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.Parent = row

        local v = Instance.new("TextLabel")
        v.Size = UDim2.new(1, -75, 1, 0)
        v.Position = UDim2.new(0, 72, 0, 0)
        v.BackgroundTransparency = 1
        v.Text = value or "..."
        v.Font = Enum.Font.GothamBold
        v.TextSize = 9
        v.TextColor3 = color or C.TextSub
        v.TextXAlignment = Enum.TextXAlignment.Left
        v.TextTruncate = Enum.TextTruncate.AtEnd
        v.Parent = row
        return v
    end

    local function addSection(title)
        local s = Instance.new("TextLabel")
        s.Size = UDim2.new(1, 0, 0, 16)
        s.BackgroundTransparency = 1
        s.Text = "> " .. title
        s.Font = Enum.Font.GothamBold
        s.TextSize = 10
        s.TextColor3 = C.Accent
        s.TextXAlignment = Enum.TextXAlignment.Left
        s.Parent = infoList
    end

    -- 基础
    addSection("基础信息")
    addRow("ID:", tostring(uid), C.TextDim)
    local descLbl = addRow("简介:", "加载中...")
    local createdLbl = addRow("注册:", "加载中...")
    local presenceLbl = addRow("状态:", "加载中...", C.Green)
    local memberLbl = addRow("会员:", player.MembershipType == Enum.MembershipType.Premium and "Premium" or "免费", player.MembershipType == Enum.MembershipType.Premium and C.Yellow or C.TextDim)

    -- 社交
    addSection("社交")
    local friendLbl = addRow("好友:", "加载中...")
    local followerLbl = addRow("粉丝:", "加载中...")
    local followingLbl = addRow("关注:", "加载中...")

    -- 游戏
    addSection("游戏")
    local joinLbl = addRow("加入:", os.date("%H:%M:%S"))
    local playLbl = addRow("时长:", "0秒")
    local chatLbl = addRow("消息:", "0条")
    local lastMsgLbl = addRow("最近:", "无")

    -- 角色
    addSection("角色(实时)")
    local healthLbl = addRow("血量:", "...")
    local speedLbl = addRow("移速:", "...")
    local jumpLbl = addRow("跳跃:", "...")
    local posLbl = addRow("坐标:", "...")

    -- 装扮
    addSection("装扮")
    local assetLbl = addRow("装扮:", "加载中...")
    local costLbl = addRow("价值:", "加载中...", C.Yellow)

    -- 群组
    addSection("群组")
    local groupLbl = addRow("群组:", "加载中...")

    -- 缓存
    playerCache[uid] = {
        card = card,
        chatLbl = chatLbl,
        lastMsgLbl = lastMsgLbl,
        playLbl = playLbl,
        healthLbl = healthLbl,
        speedLbl = speedLbl,
        jumpLbl = jumpLbl,
        posLbl = posLbl,
        joinTick = tick()
    }

    -- 聊天监控
    monitorChat(player)

    -- 异步获取信息
    task.spawn(function()
        pcall(function() createdLbl.Text = getAccountAge(uid) end)
        pcall(function() descLbl.Text = getPlayerDesc(uid):sub(1, 40) end)
        pcall(function() presenceLbl.Text = getPresence(uid) end)
        pcall(function() friendLbl.Text = tostring(getCount("https://friends.roblox.com/v1/users/" .. uid .. "/friends/count")) end)
        pcall(function() followerLbl.Text = tostring(getCount("https://friends.roblox.com/v1/users/" .. uid .. "/followers/count")) end)
        pcall(function() followingLbl.Text = tostring(getCount("https://friends.roblox.com/v1/users/" .. uid .. "/followings/count")) end)

        -- 装扮
        pcall(function()
            local assets = getWornAssets(uid)
            assetLbl.Text = #assets .. "件"
            local names = {}
            local totalCost = 0
            for i, id in ipairs(assets) do
                if i > 8 then break end
                local info = getAssetInfo(id)
                if info then
                    table.insert(names, info.Name or "?")
                    if info.Price and info.Price > 0 then totalCost = totalCost + info.Price end
                end
            end
            assetLbl.Text = #assets .. "件 | " .. table.concat(names, ","):sub(1, 50)
            costLbl.Text = totalCost > 0 and (tostring(totalCost) .. " R$") or "无法计算"
        end)

        -- 群组
        pcall(function()
            local groups = getGroups(uid)
            groupLbl.Text = #groups > 0 and table.concat(groups, ", "):sub(1, 60) or "无"
        end)
    end)

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
                        healthLbl.Text = string.format("%.0f/%.0f", hum.Health, hum.MaxHealth)
                        speedLbl.Text = tostring(hum.WalkSpeed)
                        jumpLbl.Text = tostring(hum.JumpPower)
                    end
                    if root then
                        local p = root.Position
                        posLbl.Text = string.format("(%.0f, %.0f, %.0f)", p.X, p.Y, p.Z)
                    end
                end
                local elapsed = tick() - playerCache[uid].joinTick
                local h = math.floor(elapsed / 3600)
                local m = math.floor((elapsed % 3600) / 60)
                local s = math.floor(elapsed % 60)
                playLbl.Text = string.format("%d时%d分%d秒", h, m, s)
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

-- ========== 最小化 ==========
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
        minIcon.Parent = gui

        local ic = Instance.new("UICorner")
        ic.CornerRadius = UDim.new(0, 8)
        ic.Parent = minIcon

        local is = Instance.new("UIStroke")
        is.Color = C.Surface2
        is.Thickness = 1
        is.Parent = minIcon

        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 8, 0, 8)
        dot.Position = UDim2.new(0, 8, 0.5, -4)
        dot.BackgroundColor3 = C.Green
        dot.BorderSizePixel = 0
        dot.Parent = minIcon

        local dc = Instance.new("UICorner")
        dc.CornerRadius = UDim.new(1, 0)
        dc.Parent = dot

        minIcon.MouseButton1Click:Connect(function()
            minimized = false
            main.Visible = true
            minIcon.Visible = false
        end)
    end
    minIcon.Visible = true
end)

-- ========== 关闭 ==========
closeBtn.MouseButton1Click:Connect(function()
    for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    conns = {}
    playerCache = {}
    chatLogs = {}
    scannedPlayers = {}
    gui:Destroy()
    _G.PlayerIntelLoaded = false
    notify("PlayerIntel", "已关闭")
end)

-- ========== 刷新 ==========
refreshBtn.MouseButton1Click:Connect(function()
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    playerCache = {}
    chatLogs = {}
    scannedPlayers = {}
    statusLabel.Text = "重新扫描..."
    task.wait(0.5)
    for _, plr in ipairs(Players:GetPlayers()) do
        makeCard(plr)
    end
    countLabel.Text = #Players:GetPlayers() .. " 人"
    statusLabel.Text = "就绪 | " .. #Players:GetPlayers() .. " 名玩家"
    notify("PlayerIntel", "刷新完成")
end)

-- ========== 搜索 ==========
searchInput:GetPropertyChangedSignal("Text"):Connect(function()
    local q = string.lower(searchInput.Text)
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("Frame") then
            child.Visible = (q == "" or string.find(string.lower(child.Name), q))
        end
    end
end)

-- ========== 拖拽 ==========
local dragging = false
local dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ========== 重复扫描 ==========
local function scanAllPlayers()
    for _, plr in ipairs(Players:GetPlayers()) do
        if not scannedPlayers[plr.UserId] then
            makeCard(plr)
        end
    end
    countLabel.Text = #Players:GetPlayers() .. " 人"
    statusLabel.Text = "就绪 | " .. #Players:GetPlayers() .. " 名玩家"
end

-- 初始扫描
task.delay(0.5, scanAllPlayers)

-- 每5秒重复扫描一次（防止漏掉新玩家）
local repeatScanConn
repeatScanConn = game:GetService("RunService").Heartbeat:Connect(function()
    if tick() % 5 < 0.1 then
        scanAllPlayers()
    end
end)
table.insert(conns, repeatScanConn)

-- 玩家加入
local joinConn = Players.PlayerAdded:Connect(function(plr)
    task.wait(1)
    makeCard(plr)
    countLabel.Text = #Players:GetPlayers() .. " 人"
    statusLabel.Text = "就绪 | " .. #Players:GetPlayers() .. " 名玩家"
    notify("PlayerIntel", plr.DisplayName .. " 加入")
end)
table.insert(conns, joinConn)

-- 玩家离开
local leaveConn = Players.PlayerRemoving:Connect(function(plr)
    if playerCache[plr.UserId] and playerCache[plr.UserId].card then
        playerCache[plr.UserId].card:Destroy()
    end
    playerCache[plr.UserId] = nil
    chatLogs[plr.UserId] = nil
    scannedPlayers[plr.UserId] = nil
    countLabel.Text = #Players:GetPlayers() .. " 人"
    statusLabel.Text = "就绪 | " .. #Players:GetPlayers() .. " 名玩家"
end)
table.insert(conns, leaveConn)

notify("PlayerIntel Scanner", "仅供娱乐 - 开始扫描")
