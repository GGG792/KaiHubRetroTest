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
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- ========== 配色 ==========
local C = {
    WinBg = Color3.fromRGB(30, 30, 46);
    WinTitle = Color3.fromRGB(24, 24, 37);
    WinTitleText = Color3.fromRGB(205, 214, 244);
    Accent = Color3.fromRGB(137, 180, 250);
    AccentDark = Color3.fromRGB(116, 135, 200);
    Surface0 = Color3.fromRGB(49, 50, 68);
    Surface1 = Color3.fromRGB(69, 71, 90);
    Surface2 = Color3.fromRGB(88, 91, 112);
    Overlay0 = Color3.fromRGB(108, 112, 134);
    Text = Color3.fromRGB(205, 214, 244);
    TextDim = Color3.fromRGB(147, 153, 178);
    TextSub = Color3.fromRGB(186, 194, 222);
    Green = Color3.fromRGB(166, 227, 161);
    Yellow = Color3.fromRGB(249, 226, 175);
    Red = Color3.fromRGB(243, 139, 168);
    Blue = Color3.fromRGB(137, 180, 250);
    Mauve = Color3.fromRGB(203, 166, 247);
    Teal = Color3.fromRGB(148, 226, 213);
    Peach = Color3.fromRGB(250, 179, 135);
    Pink = Color3.fromRGB(245, 194, 231);
    Maroon = Color3.fromRGB(235, 160, 172);
    ScrollThumb = Color3.fromRGB(88, 91, 112);
    ScrollTrack = Color3.fromRGB(30, 30, 46);
    CloseBtn = Color3.fromRGB(243, 139, 168);
    CloseHover = Color3.fromRGB(250, 100, 130);
    MinBtn = Color3.fromRGB(69, 71, 90);
    MinHover = Color3.fromRGB(88, 91, 112);
    CardBg = Color3.fromRGB(49, 50, 68);
    CardBorder = Color3.fromRGB(69, 71, 90);
    InputBg = Color3.fromRGB(24, 24, 37);
    TagPremium = Color3.fromRGB(249, 226, 175);
    TagStaff = Color3.fromRGB(243, 139, 168);
    TagFriend = Color3.fromRGB(166, 227, 161);
    TagNormal = Color3.fromRGB(147, 153, 178);
}

-- ========== 通知 ==========
local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 3})
    end)
end

-- ========== API工具 ==========
local function getAccountAge(userId)
    local success, result = pcall(function()
        local url = "https://users.roblox.com/v1/users/" .. tostring(userId)
        local response = game:HttpGet(url)
        local data = HttpService:JSONDecode(response)
        return data.created
    end)
    if success and result then
        local createdDate = result:match("(%d+-%d+-%d+)T")
        if createdDate then
            local y, m, d = createdDate:match("(%d+)-(%d+)-(%d+)")
            local ageDays = math.floor((os.time() - os.time({year=tonumber(y), month=tonumber(m), day=tonumber(d)})) / 86400)
            return {
                raw = result,
                date = createdDate,
                ageDays = ageDays,
                ageYears = math.floor(ageDays / 365),
                formatted = string.format("%d年%d月%d日 (账号年龄: %d天)", tonumber(y), tonumber(m), tonumber(d), ageDays)
            }
        end
    end
    return {raw = nil, date = "未知", ageDays = 0, ageYears = 0, formatted = "未知"}
end

local function getPlayerInfo(userId)
    local success, result = pcall(function()
        local url = "https://users.roblox.com/v1/users/" .. tostring(userId)
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    return success and result or nil
end

local function getAvatarInfo(userId)
    local success, result = pcall(function()
        local url = "https://avatar.roblox.com/v1/users/" .. tostring(userId) .. "/avatar"
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    return success and result or nil
end

local function getAvatarAssets(userId)
    local success, result = pcall(function()
        local url = "https://avatar.roblox.com/v1/users/" .. tostring(userId) .. "/currently-wearing"
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    return success and result or {}
end

local function getAssetInfo(assetId)
    local success, result = pcall(function()
        local url = "https://economy.roblox.com/v2/assets/" .. tostring(assetId) .. "/details"
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    return success and result or nil
end

local function getPresence(userId)
    local success, result = pcall(function()
        local url = "https://presence.roblox.com/v1/presence/users"
        local body = HttpService:JSONEncode({userIds = {userId}})
        local response = game:HttpPost(url, body, Enum.HttpContentType.ApplicationJson)
        local data = HttpService:JSONDecode(response)
        if data.userPresences and #data.userPresences > 0 then
            return data.userPresences[1]
        end
    end)
    return success and result or nil
end

local function getFriends(userId)
    local success, result = pcall(function()
        local url = "https://friends.roblox.com/v1/users/" .. tostring(userId) .. "/friends/count"
        return tonumber(game:HttpGet(url)) or 0
    end)
    return success and result or 0
end

local function getFollowerCount(userId)
    local success, result = pcall(function()
        local url = "https://friends.roblox.com/v1/users/" .. tostring(userId) .. "/followers/count"
        return tonumber(game:HttpGet(url)) or 0
    end)
    return success and result or 0
end

local function getFollowingCount(userId)
    local success, result = pcall(function()
        local url = "https://friends.roblox.com/v1/users/" .. tostring(userId) .. "/followings/count"
        return tonumber(game:HttpGet(url)) or 0
    end)
    return success and result or 0
end

local function getRobuxInfo(userId)
    local success, result = pcall(function()
        local url = "https://economy.roblox.com/v1/users/" .. tostring(userId) .. "/robux"
        return tonumber(game:HttpGet(url)) or 0
    end)
    return success and result or nil
end

local function getGamePasses(userId)
    local success, result = pcall(function()
        local url = "https://www.roblox.com/users/inventory/list-json?assetTypeId=34&cursor=&itemsPerPage=100&userId=" .. tostring(userId)
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    return success and result or nil
end

local function getBadges(userId)
    local success, result = pcall(function()
        local url = "https://badges.roblox.com/v1/users/" .. tostring(userId) .. "/badges?limit=100&sortOrder=Asc"
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    return success and result or nil
end

local function getGroupInfo(userId)
    local groups = {}
    local success, result = pcall(function()
        local url = "https://groups.roblox.com/v2/users/" .. tostring(userId) .. "/groups/roles"
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    if success and result and result.data then
        for _, group in ipairs(result.data) do
            table.insert(groups, {
                id = group.group.id,
                name = group.group.name,
                role = group.role.name,
                rank = group.role.rank
            })
        end
    end
    return groups
end

local function getThumbnail(userId)
    local success, result = pcall(function()
        local url = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. tostring(userId) .. "&size=150x150&format=Png&isCircular=false"
        local data = HttpService:JSONDecode(game:HttpGet(url))
        if data.data and #data.data > 0 then
            return data.data[1].imageUrl
        end
    end)
    return success and result or ""
end

local function getFullAvatarThumbnail(userId)
    local success, result = pcall(function()
        local url = "https://thumbnails.roblox.com/v1/users/avatar?userIds=" .. tostring(userId) .. "&size=420x420&format=Png&isCircular=false"
        local data = HttpService:JSONDecode(game:HttpGet(url))
        if data.data and #data.data > 0 then
            return data.data[1].imageUrl
        end
    end)
    return success and result or ""
end

-- ========== 玩家数据缓存 ==========
local playerDataCache = {}
local chatLogCache = {}
local scanConnections = {}

-- ========== 聊天监控 ==========
local function startChatMonitor(player)
    if chatLogCache[player.UserId] then return end
    chatLogCache[player.UserId] = {messages = {}, player = player}

    local function onMessage(message)
        if message.FromUserId == player.UserId then
            table.insert(chatLogCache[player.UserId].messages, {
                text = message.Text,
                time = os.date("%H:%M:%S"),
                tick = tick()
            })
            -- 只保留最近100条
            if #chatLogCache[player.UserId].messages > 100 then
                table.remove(chatLogCache[player.UserId].messages, 1)
            end
            -- 更新UI
            if playerDataCache[player.UserId] and playerDataCache[player.UserId].chatLabel then
                local count = #chatLogCache[player.UserId].messages
                playerDataCache[player.UserId].chatLabel.Text = "消息: " .. count .. "条"
                playerDataCache[player.UserId].lastMsgLabel.Text = "最近: " .. message.Text:sub(1, 30)
            end
        end
    end

    local conn
    conn = LP.Chatted:Connect(function(msg, target)
        if target and target == player then
            onMessage({FromUserId = player.UserId, Text = msg})
        end
    end)
    table.insert(scanConnections, conn)

    -- 也监听其他人聊天的间接方式
    local conn2
    conn2 = Players.PlayerAdded:Connect(function(newPlayer)
        if newPlayer.UserId == player.UserId then return end
    end)
    table.insert(scanConnections, conn2)
end

-- ========== 扫描玩家 ==========
local function scanPlayer(player, container)
    local userId = player.UserId

    -- 基础信息卡
    local card = Instance.new("Frame")
    card.Name = "Card_" .. player.Name
    card.Size = UDim2.new(1, -16, 0, 0)
    card.BackgroundColor3 = C.CardBg
    card.BorderSizePixel = 0
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.Parent = container

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 8)
    cardCorner.Parent = card

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = C.CardBorder
    cardStroke.Thickness = 1
    cardStroke.Parent = card

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = card

    -- 头部：头像 + 名字 + 标签
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundTransparency = 1
    header.Parent = card

    -- 头像
    local avatarFrame = Instance.new("Frame")
    avatarFrame.Size = UDim2.new(0, 40, 0, 40)
    avatarFrame.Position = UDim2.new(0, 0, 0, 5)
    avatarFrame.BackgroundColor3 = C.Surface2
    avatarFrame.BorderSizePixel = 0
    avatarFrame.Parent = header

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(1, 0)
    avatarCorner.Parent = avatarFrame

    local avatarImg = Instance.new("ImageLabel")
    avatarImg.Size = UDim2.new(1, 0, 1, 0)
    avatarImg.BackgroundTransparency = 1
    avatarImg.Parent = avatarFrame

    pcall(function()
        local thumbUrl = getThumbnail(userId)
        if thumbUrl and thumbUrl ~= "" then
            avatarImg.Image = thumbUrl
        end
    end)

    -- 名字
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -52, 0, 18)
    nameLabel.Position = UDim2.new(0, 48, 0, 2)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.DisplayName
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.TextColor3 = C.Text
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = header

    -- 用户名
    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Size = UDim2.new(1, -52, 0, 14)
    usernameLabel.Position = UDim2.new(0, 48, 0, 20)
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Text = "@" .. player.Name
    usernameLabel.Font = Enum.Font.Gotham
    usernameLabel.TextSize = 11
    usernameLabel.TextColor3 = C.TextDim
    usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    usernameLabel.Parent = header

    -- 标签
    local tagContainer = Instance.new("Frame")
    tagContainer.Size = UDim2.new(1, -52, 0, 16)
    tagContainer.Position = UDim2.new(0, 48, 0, 36)
    tagContainer.BackgroundTransparency = 1
    tagContainer.Parent = header

    local tagLayout = Instance.new("UIListLayout")
    tagLayout.FillDirection = Enum.FillDirection.Horizontal
    tagLayout.Padding = UDim.new(0, 4)
    tagLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tagLayout.Parent = tagContainer

    -- Premium标签
    local function addTag(text, color)
        local tag = Instance.new("Frame")
        tag.Size = UDim2.new(0, 0, 0, 14)
        tag.AutomaticSize = Enum.AutomaticSize.X
        tag.BackgroundColor3 = color
        tag.BackgroundTransparency = 0.7
        tag.BorderSizePixel = 0
        tag.Parent = tagContainer

        local tagCorner = Instance.new("UICorner")
        tagCorner.CornerRadius = UDim.new(0, 4)
        tagCorner.Parent = tag

        local tagLabel = Instance.new("TextLabel")
        tagLabel.Size = UDim2.new(1, -8, 1, 0)
        tagLabel.Position = UDim2.new(0, 4, 0, 0)
        tagLabel.BackgroundTransparency = 1
        tagLabel.Text = text
        tagLabel.Font = Enum.Font.GothamBold
        tagLabel.TextSize = 9
        tagLabel.TextColor3 = color
        tagLabel.TextXAlignment = Enum.TextXAlignment.Left
        tagLabel.Parent = tag
    end

    if player.MembershipType == Enum.MembershipType.Premium then
        addTag("PREMIUM", C.TagPremium)
    end
    if player:IsFriendsWith(LP.UserId) then
        addTag("好友", C.TagFriend)
    end

    -- 分隔线
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, 0, 0, 1)
    sep.Position = UDim2.new(0, 0, 0, 50)
    sep.BackgroundColor3 = C.Surface2
    sep.BorderSizePixel = 0
    sep.Parent = card

    -- 信息区域
    local infoFrame = Instance.new("Frame")
    infoFrame.Size = UDim2.new(1, 0, 0, 0)
    infoFrame.Position = UDim2.new(0, 0, 0, 54)
    infoFrame.BackgroundTransparency = 1
    infoFrame.AutomaticSize = Enum.AutomaticSize.Y
    infoFrame.Parent = card

    local infoLayout = Instance.new("UIListLayout")
    infoLayout.SortOrder = Enum.SortOrder.LayoutOrder
    infoLayout.Padding = UDim.new(0, 3)
    infoLayout.Parent = infoFrame

    local function addInfoRow(labelText, valueText, valueColor)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 16)
        row.BackgroundTransparency = 1
        row.Parent = infoFrame

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0, 80, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 10
        lbl.TextColor3 = C.TextDim
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextTruncate = Enum.TextTruncate.AtEnd
        lbl.Parent = row

        local val = Instance.new("TextLabel")
        val.Size = UDim2.new(1, -85, 1, 0)
        val.Position = UDim2.new(0, 82, 0, 0)
        val.BackgroundTransparency = 1
        val.Text = valueText or "加载中..."
        val.Font = Enum.Font.GothamBold
        val.TextSize = 10
        val.TextColor3 = valueColor or C.TextSub
        val.TextXAlignment = Enum.TextXAlignment.Left
        val.TextTruncate = Enum.TextTruncate.AtEnd
        val.Parent = row

        return val
    end

    local function addSection(title)
        local sectionFrame = Instance.new("Frame")
        sectionFrame.Size = UDim2.new(1, 0, 0, 20)
        sectionFrame.BackgroundTransparency = 1
        sectionFrame.Parent = infoFrame

        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(1, 0, 0, 16)
        titleLbl.Position = UDim2.new(0, 0, 0, 2)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = "▸ " .. title
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.TextSize = 11
        titleLbl.TextColor3 = C.Accent
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.Parent = sectionFrame
    end

    -- 基础信息
    addSection("基础信息")
    local idLabel = addInfoRow("用户ID:", tostring(userId), C.TextDim)
    local descLabel = addInfoRow("简介:", "加载中...", C.TextSub)
    local createdLabel = addInfoRow("注册时间:", "加载中...", C.TextSub)
    local accountAgeLabel = addInfoRow("账号年龄:", "加载中...", C.TextSub)
    local presenceLabel = addInfoRow("在线状态:", "加载中...", C.TextSub)
    local membershipLabel = addInfoRow("会员:", player.MembershipType == Enum.MembershipType.Premium and "Premium" or "免费", player.MembershipType == Enum.MembershipType.Premium and C.TagPremium or C.TextDim)

    -- 社交信息
    addSection("社交信息")
    local friendLabel = addInfoRow("好友数:", "加载中...", C.TextSub)
    local followerLabel = addInfoRow("粉丝数:", "加载中...", C.TextSub)
    local followingLabel = addInfoRow("关注数:", "加载中...", C.TextSub)

    -- 游戏信息
    addSection("游戏信息")
    local joinTimeLabel = addInfoRow("加入时间:", os.date("%H:%M:%S"), C.TextSub)
    local playTimeLabel = addInfoRow("游玩时长:", "0秒", C.TextSub)
    local chatLabel = addInfoRow("消息数:", "0条", C.TextSub)
    local lastMsgLabel = addInfoRow("最近消息:", "无", C.TextSub)

    -- 角色信息
    addSection("角色信息")
    local avatarTypeLabel = addInfoRow("角色类型:", "加载中...", C.TextSub)
    local healthLabel = addInfoRow("血量:", "加载中...", C.TextSub)
    local maxHealthLabel = addInfoRow("最大血量:", "加载中...", C.TextSub)
    local walkSpeedLabel = addInfoRow("移速:", "加载中...", C.TextSub)
    local jumpPowerLabel = addInfoRow("跳跃力:", "加载中...", C.TextSub)
    local positionLabel = addInfoRow("坐标:", "加载中...", C.TextDim)

    -- 装扮信息
    addSection("装扮信息")
    local assetCountLabel = addInfoRow("装扮数量:", "加载中...", C.TextSub)
    local assetListLabel = addInfoRow("装扮列表:", "加载中...", C.TextDim)
    assetListLabel.Size = UDim2.new(1, -85, 0, 40)
    assetListLabel.TextWrapped = true
    assetListLabel.TextYAlignment = Enum.TextYAlignment.Top

    -- Robux信息
    addSection("经济信息")
    local robuxLabel = addInfoRow("Robux:", "无法获取", C.Yellow)

    -- 群组信息
    addSection("群组信息")
    local groupLabel = addInfoRow("群组:", "加载中...", C.TextDim)
    groupLabel.Size = UDim2.new(1, -85, 0, 30)
    groupLabel.TextWrapped = true
    groupLabel.TextYAlignment = Enum.TextYAlignment.Top

    -- 缓存数据
    playerDataCache[userId] = {
        player = player,
        card = card,
        chatLabel = chatLabel,
        lastMsgLabel = lastMsgLabel,
        playTimeLabel = playTimeLabel,
        positionLabel = positionLabel,
        healthLabel = healthLabel,
        joinTick = tick()
    }

    -- 开始聊天监控
    startChatMonitor(player)

    -- 异步获取详细信息
    task.spawn(function()
        -- 账号信息
        local accountInfo = getAccountAge(userId)
        if accountInfo then
            createdLabel.Text = accountInfo.formatted
            accountAgeLabel.Text = accountInfo.ageYears .. "年" .. (accountInfo.ageDays % 365) .. "天"
        end

        -- 玩家详情
        local pInfo = getPlayerInfo(userId)
        if pInfo then
            descLabel.Text = (pInfo.description and pInfo.description ~= "") and pInfo.description:sub(1, 50) or "无简介"
        end

        -- 在线状态
        local presence = getPresence(userId)
        if presence then
            local statusMap = {
                [0] = "离线", [1] = "在线", [2] = "游戏中",
                [3] = "工作室", [4] = "隐形"
            }
            presenceLabel.Text = statusMap[presence.userPresenceType] or "未知"
            presenceLabel.TextColor3 = presence.userPresenceType == 1 and C.Green or (presence.userPresenceType == 2 and C.Blue or C.TextSub)
            if presence.lastLocation and presence.lastLocation ~= "" then
                presenceLabel.Text = presenceLabel.Text .. " | " .. tostring(presence.lastLocation):sub(1, 30)
            end
        else
            presenceLabel.Text = "在线 (本服务器)"
            presenceLabel.TextColor3 = C.Green
        end

        -- 社交
        friendLabel.Text = tostring(getFriends(userId))
        followerLabel.Text = tostring(getFollowerCount(userId))
        followingLabel.Text = tostring(getFollowingCount(userId))

        -- Robux
        local robux = getRobuxInfo(userId)
        if robux then
            robuxLabel.Text = tostring(robux) .. " R$"
            robuxLabel.TextColor3 = C.Yellow
        else
            robuxLabel.Text = "仅自己可见"
        end

        -- 群组
        local groups = getGroupInfo(userId)
        if #groups > 0 then
            local groupStr = ""
            for _, g in ipairs(groups) do
                groupStr = groupStr .. g.name .. "(" .. g.role .. ") "
                if #groupStr > 80 then break end
            end
            groupLabel.Text = groupStr:sub(1, 80)
        else
            groupLabel.Text = "无群组"
        end

        -- 装扮
        local assets = getAvatarAssets(userId)
        if assets and #assets > 0 then
            assetCountLabel.Text = tostring(#assets) .. "件"
            local assetNames = {}
            local totalCost = 0
            for i, assetId in ipairs(assets) do
                if i <= 10 then
                    local assetInfo = getAssetInfo(assetId)
                    if assetInfo then
                        table.insert(assetNames, assetInfo.Name)
                        if assetInfo.Price and assetInfo.Price > 0 then
                            totalCost = totalCost + assetInfo.Price
                        end
                    end
                end
            end
            assetListLabel.Text = table.concat(assetNames, ", "):sub(1, 120)
            if totalCost > 0 then
                assetListLabel.Text = assetListLabel.Text .. "\n总价值: " .. tostring(totalCost) .. " R$"
            end
        else
            assetCountLabel.Text = "0件"
            assetListLabel.Text = "无装扮数据"
        end

        -- 头像类型
        local avatarInfo = getAvatarInfo(userId)
        if avatarInfo then
            avatarTypeLabel.Text = avatarInfo.playerAvatarType or "R15"
        else
            avatarTypeLabel.Text = "R15"
        end
    end)

    -- 实时更新角色信息
    task.spawn(function()
        while player.Parent and card.Parent do
            task.wait(1)
            pcall(function()
                local char = player.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if hum then
                        healthLabel.Text = string.format("%.0f / %.0f", hum.Health, hum.MaxHealth)
                        maxHealthLabel.Text = tostring(hum.MaxHealth)
                        walkSpeedLabel.Text = tostring(hum.WalkSpeed)
                        jumpPowerLabel.Text = tostring(hum.JumpPower)
                    end
                    if root then
                        local pos = root.Position
                        positionLabel.Text = string.format("(%.1f, %.1f, %.1f)", pos.X, pos.Y, pos.Z)
                    end
                end
                -- 游玩时长
                local elapsed = tick() - playerDataCache[userId].joinTick
                local h = math.floor(elapsed / 3600)
                local m = math.floor((elapsed % 3600) / 60)
                local s = math.floor(elapsed % 60)
                playTimeLabel.Text = string.format("%d时%d分%d秒", h, m, s)
            end)
        end
    end)
end

-- ========== 创建UI ==========
local function createUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "PlayerIntelScanner"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = game:GetService("CoreGui")

    -- 主窗口
    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, 420, 0, 340)
    main.Position = UDim2.new(0.5, -210, 0.5, -170)
    main.BackgroundColor3 = C.WinBg
    main.BorderSizePixel = 0
    main.Active = true
    main.Parent = gui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = main

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = C.Surface2
    mainStroke.Thickness = 1
    mainStroke.Parent = main

    -- 标题栏
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 36)
    titleBar.BackgroundColor3 = C.WinTitle
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar

    -- 修复底部圆角
    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 12)
    titleFix.Position = UDim2.new(0, 0, 1, -12)
    titleFix.BackgroundColor3 = C.WinTitle
    titleFix.BorderSizePixel = 0
    titleFix.Parent = titleBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 14, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Player Intel Scanner"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = C.WinTitleText
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    local subLabel = Instance.new("TextLabel")
    subLabel.Size = UDim2.new(1, -80, 0, 12)
    subLabel.Position = UDim2.new(0, 14, 1, -14)
    subLabel.BackgroundTransparency = 1
    subLabel.Text = "仅供娱乐"
    subLabel.Font = Enum.Font.Gotham
    subLabel.TextSize = 9
    subLabel.TextColor3 = C.TextDim
    subLabel.TextXAlignment = Enum.TextXAlignment.Left
    subLabel.Parent = titleBar

    -- 玩家计数
    local countLabel = Instance.new("TextLabel")
    countLabel.Size = UDim2.new(0, 60, 0, 20)
    countLabel.Position = UDim2.new(1, -130, 0, 8)
    countLabel.BackgroundTransparency = 1
    countLabel.Text = "0 人"
    countLabel.Font = Enum.Font.GothamBold
    countLabel.TextSize = 12
    countLabel.TextColor3 = C.Accent
    countLabel.TextXAlignment = Enum.TextXAlignment.Right
    countLabel.Parent = titleBar

    -- 最小化按钮
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 28, 0, 28)
    minBtn.Position = UDim2.new(1, -62, 0, 4)
    minBtn.BackgroundColor3 = C.MinBtn
    minBtn.BorderSizePixel = 0
    minBtn.Text = "_"
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 14
    minBtn.TextColor3 = C.Text
    minBtn.Parent = titleBar

    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 6)
    minCorner.Parent = minBtn

    minBtn.MouseEnter:Connect(function() minBtn.BackgroundColor3 = C.MinHover end)
    minBtn.MouseLeave:Connect(function() minBtn.BackgroundColor3 = C.MinBtn end)

    -- 关闭按钮
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -30, 0, 4)
    closeBtn.BackgroundColor3 = C.Surface1
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    closeBtn.TextColor3 = C.Text
    closeBtn.Parent = titleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn

    closeBtn.MouseEnter:Connect(function() closeBtn.BackgroundColor3 = C.CloseBtn end)
    closeBtn.MouseLeave:Connect(function() closeBtn.BackgroundColor3 = C.Surface1 end)

    -- 搜索框
    local searchFrame = Instance.new("Frame")
    searchFrame.Size = UDim2.new(1, -16, 0, 30)
    searchFrame.Position = UDim2.new(0, 8, 0, 42)
    searchFrame.BackgroundColor3 = C.InputBg
    searchFrame.BorderSizePixel = 0
    searchFrame.Parent = main

    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 8)
    searchCorner.Parent = searchFrame

    local searchStroke = Instance.new("UIStroke")
    searchStroke.Color = C.Surface2
    searchStroke.Thickness = 1
    searchStroke.Parent = searchFrame

    local searchIcon = Instance.new("TextLabel")
    searchIcon.Size = UDim2.new(0, 30, 1, 0)
    searchIcon.Position = UDim2.new(0, 4, 0, 0)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Text = "Q"
    searchIcon.Font = Enum.Font.GothamBold
    searchIcon.TextSize = 12
    searchIcon.TextColor3 = C.TextDim
    searchIcon.Parent = searchFrame

    local searchInput = Instance.new("TextBox")
    searchInput.Size = UDim2.new(1, -40, 1, 0)
    searchInput.Position = UDim2.new(0, 32, 0, 0)
    searchInput.BackgroundTransparency = 1
    searchInput.Text = ""
    searchInput.PlaceholderText = "搜索玩家..."
    searchInput.PlaceholderColor3 = C.TextDim
    searchInput.Font = Enum.Font.Gotham
    searchInput.TextSize = 12
    searchInput.TextColor3 = C.Text
    searchInput.TextXAlignment = Enum.TextXAlignment.Left
    searchInput.ClearTextOnFocus = false
    searchInput.Parent = searchFrame

    -- 刷新按钮
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(0, 30, 0, 30)
    refreshBtn.Position = UDim2.new(1, -48, 0, 42)
    refreshBtn.BackgroundColor3 = C.Surface1
    refreshBtn.BorderSizePixel = 0
    refreshBtn.Text = "R"
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.TextSize = 12
    refreshBtn.TextColor3 = C.Accent
    refreshBtn.Parent = main

    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0, 8)
    refreshCorner.Parent = refreshBtn

    refreshBtn.MouseEnter:Connect(function() refreshBtn.BackgroundColor3 = C.Surface2 end)
    refreshBtn.MouseLeave:Connect(function() refreshBtn.BackgroundColor3 = C.Surface1 end)

    -- 滚动区域
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "PlayerList"
    scroll.Size = UDim2.new(1, -16, 1, -82)
    scroll.Position = UDim2.new(0, 8, 0, 78)
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
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = scroll

    -- 状态栏
    local statusBar = Instance.new("Frame")
    statusBar.Size = UDim2.new(1, 0, 0, 22)
    statusBar.Position = UDim2.new(0, 0, 1, -22)
    statusBar.BackgroundColor3 = C.Surface0
    statusBar.BorderSizePixel = 0
    statusBar.Parent = main

    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 0)
    statusCorner.Parent = statusBar

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -8, 1, 0)
    statusLabel.Position = UDim2.new(0, 8, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "就绪 | 正在扫描..."
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 10
    statusLabel.TextColor3 = C.TextDim
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = statusBar

    -- ========== 功能逻辑 ==========

    -- 最小化
    local minimized = false
    local minIcon
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            main.Visible = false
            if not minIcon then
                minIcon = Instance.new("TextButton")
                minIcon.Size = UDim2.new(0, 120, 0, 32)
                minIcon.Position = UDim2.new(0, 10, 1, -42)
                minIcon.BackgroundColor3 = C.Surface0
                minIcon.BorderSizePixel = 0
                minIcon.Text = "  PlayerIntel"
                minIcon.Font = Enum.Font.GothamBold
                minIcon.TextSize = 11
                minIcon.TextColor3 = C.Accent
                minIcon.TextXAlignment = Enum.TextXAlignment.Left
                minIcon.Parent = gui

                local minIconCorner = Instance.new("UICorner")
                minIconCorner.CornerRadius = UDim.new(0, 8)
                minIconCorner.Parent = minIcon

                local minIconStroke = Instance.new("UIStroke")
                minIconStroke.Color = C.Surface2
                minIconStroke.Thickness = 1
                minIconStroke.Parent = minIcon

                local dot = Instance.new("Frame")
                dot.Size = UDim2.new(0, 8, 0, 8)
                dot.Position = UDim2.new(0, 8, 0.5, -4)
                dot.BackgroundColor3 = C.Green
                dot.BorderSizePixel = 0
                dot.Parent = minIcon

                local dotCorner = Instance.new("UICorner")
                dotCorner.CornerRadius = UDim.new(1, 0)
                dotCorner.Parent = dot

                minIcon.MouseButton1Click:Connect(function()
                    minimized = false
                    main.Visible = true
                    minIcon.Visible = false
                end)
            end
            minIcon.Visible = true
        else
            main.Visible = true
            if minIcon then minIcon.Visible = false end
        end
    end)

    -- 关闭
    closeBtn.MouseButton1Click:Connect(function()
        for _, conn in ipairs(scanConnections) do
            pcall(function() conn:Disconnect() end)
        end
        scanConnections = {}
        playerDataCache = {}
        chatLogCache = {}
        gui:Destroy()
        _G.PlayerIntelLoaded = false
        notify("PlayerIntel", "已关闭")
    end)

    -- 刷新
    refreshBtn.MouseButton1Click:Connect(function()
        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        playerDataCache = {}
        chatLogCache = {}
        statusLabel.Text = "重新扫描中..."
        task.wait(0.5)
        for _, player in ipairs(Players:GetPlayers()) do
            scanPlayer(player, scroll)
            countLabel.Text = #Players:GetPlayers() .. " 人"
        end
        statusLabel.Text = "就绪 | 已扫描 " .. #Players:GetPlayers() .. " 名玩家"
        notify("PlayerIntel", "刷新完成")
    end)

    -- 搜索过滤
    searchInput:GetPropertyChangedSignal("Text"):Connect(function()
        local query = string.lower(searchInput.Text)
        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("Frame") then
                local name = string.lower(child.Name)
                if query == "" or string.find(name, query) then
                    child.Visible = true
                else
                    child.Visible = false
                end
            end
        end
    end)

    -- 拖拽
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
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- 初始扫描
    task.delay(0.5, function()
        for _, player in ipairs(Players:GetPlayers()) do
            scanPlayer(player, scroll)
        end
        countLabel.Text = #Players:GetPlayers() .. " 人"
        statusLabel.Text = "就绪 | 已扫描 " .. #Players:GetPlayers() .. " 名玩家"
    end)

    -- 玩家加入
    local joinConn = Players.PlayerAdded:Connect(function(player)
        task.wait(2)
        scanPlayer(player, scroll)
        countLabel.Text = #Players:GetPlayers() .. " 人"
        statusLabel.Text = "就绪 | 已扫描 " .. #Players:GetPlayers() .. " 名玩家"
        notify("PlayerIntel", player.DisplayName .. " 加入了服务器")
    end)
    table.insert(scanConnections, joinConn)

    -- 玩家离开
    local leaveConn = Players.PlayerRemoving:Connect(function(player)
        if playerDataCache[player.UserId] then
            if playerDataCache[player.UserId].card then
                playerDataCache[player.UserId].card:Destroy()
            end
            playerDataCache[player.UserId] = nil
            chatLogCache[player.UserId] = nil
        end
        countLabel.Text = #Players:GetPlayers() .. " 人"
        statusLabel.Text = "就绪 | 已扫描 " .. #Players:GetPlayers() .. " 名玩家"
    end)
    table.insert(scanConnections, leaveConn)
end

createUI()
notify("PlayerIntel Scanner", "仅供娱乐 - 已开始扫描服务器")
