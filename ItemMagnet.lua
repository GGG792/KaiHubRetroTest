--[[
    Item Magnet - 物品吸引器
    把服务器所有可移动物品吸到玩家脚下
]]

if not game:IsLoaded() then game.Loaded:Wait() end

if _G.ItemMagnetLoaded then
    warn("[ItemMagnet] 已经加载了！")
    return
end
_G.ItemMagnetLoaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer

local function notify(t, txt)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title=t, Text=txt, Duration=3})
    end)
end

-- ========== 状态 ==========
local magnetEnabled = false
local magnetSpeed = 50
local magnetRange = 200
local magnetConn = nil
local attractedParts = {}

-- ========== UI ==========
local gui = Instance.new("ScreenGui")
gui.Name = "ItemMagnet"
gui.ResetOnSpawn = false
gui.Parent = LP:WaitForChild("PlayerGui")

-- 主按钮
local mainBtn = Instance.new("TextButton")
mainBtn.Size = UDim2.new(0, 120, 0, 40)
mainBtn.Position = UDim2.new(0.5, -60, 0, 20)
mainBtn.BackgroundColor3 = Color3.fromRGB(49, 50, 68)
mainBtn.BorderSizePixel = 0
mainBtn.Text = "Item Magnet"
mainBtn.Font = Enum.Font.GothamBold
mainBtn.TextSize = 14
mainBtn.TextColor3 = Color3.fromRGB(205, 214, 244)
mainBtn.AutoButtonColor = false
mainBtn.Active = true
mainBtn.Parent = gui
Instance.new("UICorner", mainBtn).CornerRadius = UDim.new(0, 10)
local btnStroke = Instance.new("UIStroke", mainBtn)
btnStroke.Color = Color3.fromRGB(88, 91, 112)
btnStroke.Thickness = 2

-- 状态指示灯
local dot = Instance.new("Frame")
dot.Size = UDim2.new(0, 10, 0, 10)
dot.Position = UDim2.new(0, 8, 0.5, -5)
dot.BackgroundColor3 = Color3.fromRGB(243, 139, 168)
dot.BorderSizePixel = 0
dot.Parent = mainBtn
Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

-- 速度标签
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 120, 0, 16)
speedLabel.Position = UDim2.new(0.5, -60, 0, 64)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "速度: " .. magnetSpeed .. " | 范围: " .. magnetRange
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 10
speedLabel.TextColor3 = Color3.fromRGB(147, 153, 178)
speedLabel.TextXAlignment = Enum.TextXAlignment.Center
speedLabel.Parent = gui

-- 提示
local tipLabel = Instance.new("TextLabel")
tipLabel.Size = UDim2.new(0, 200, 0, 14)
tipLabel.Position = UDim2.new(0.5, -100, 0, 82)
tipLabel.BackgroundTransparency = 1
tipLabel.Text = "点击按钮开启/关闭 | 物品数: 0"
tipLabel.Font = Enum.Font.Gotham
tipLabel.TextSize = 9
tipLabel.TextColor3 = Color3.fromRGB(108, 112, 134)
tipLabel.TextXAlignment = Enum.TextXAlignment.Center
tipLabel.Parent = gui

-- ========== 物品吸引逻辑 ==========
local function getRoot()
    local char = LP.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

local function isPartOfCharacter(part)
    -- 检查部件是否属于任何玩家的角色
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            if part:IsDescendantOf(player.Character) then
                return true
            end
        end
    end
    return false
end

local function startMagnet()
    if magnetConn then return end

    magnetConn = RunService.Heartbeat:Connect(function()
        local root = getRoot()
        if not root then return end

        local playerPos = root.Position
        local count = 0

        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                -- 跳过锚定的、属于角色的、已经吸附的
                if not obj.Anchored and not isPartOfCharacter(obj) then
                    local distance = (obj.Position - playerPos).Magnitude

                    if distance <= magnetRange then
                        count = count + 1

                        -- 移动物品到玩家脚下
                        local direction = (playerPos - obj.Position).Unit
                        local moveDist = math.min(magnetSpeed * RunService.Heartbeat:Wait(), distance)

                        -- 使用AssemblyLinearVelocity来平滑移动
                        if obj:FindFirstChild("MagnetBV") then
                            obj.MagnetBV.Velocity = direction * magnetSpeed
                        else
                            local bv = Instance.new("BodyVelocity")
                            bv.Name = "MagnetBV"
                            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            bv.Velocity = direction * magnetSpeed
                            bv.Parent = obj

                            -- 添加标记
                            local highlight = Instance.new("SelectionBox")
                            highlight.Name = "MagnetMark"
                            highlight.Color3 = Color3.fromRGB(137, 180, 250)
                            highlight.LineThickness = 0.02
                            highlight.Adornee = obj
                            highlight.Parent = obj
                        end

                        -- 如果非常近了就停在下落
                        if distance < 3 then
                            local bv = obj:FindFirstChild("MagnetBV")
                            if bv then
                                bv.Velocity = Vector3.new(0, -5, 0)
                            end
                        end
                    else
                        -- 超出范围就移除效果
                        if obj:FindFirstChild("MagnetBV") then
                            obj.MagnetBV:Destroy()
                        end
                        if obj:FindFirstChild("MagnetMark") then
                            obj.MagnetMark:Destroy()
                        end
                    end
                end
            elseif obj:IsA("Model") then
                -- 也处理Model（如工具、掉落物等）
                local primaryPart = obj:FindFirstChildWhichIsA("BasePart")
                if primaryPart and not primaryPart.Anchored and not isPartOfCharacter(primaryPart) then
                    local distance = (primaryPart.Position - playerPos).Magnitude
                    if distance <= magnetRange then
                        count = count + 1
                        local direction = (playerPos - primaryPart.Position).Unit
                        if primaryPart:FindFirstChild("MagnetBV") then
                            primaryPart.MagnetBV.Velocity = direction * magnetSpeed
                        else
                            local bv = Instance.new("BodyVelocity")
                            bv.Name = "MagnetBV"
                            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            bv.Velocity = direction * magnetSpeed
                            bv.Parent = primaryPart

                            local highlight = Instance.new("SelectionBox")
                            highlight.Name = "MagnetMark"
                            highlight.Color3 = Color3.fromRGB(166, 227, 161)
                            highlight.LineThickness = 0.02
                            highlight.Adornee = primaryPart
                            highlight.Parent = primaryPart
                        end
                        if distance < 3 then
                            local bv = primaryPart:FindFirstChild("MagnetBV")
                            if bv then bv.Velocity = Vector3.new(0, -5, 0) end
                        end
                    else
                        if primaryPart:FindFirstChild("MagnetBV") then primaryPart.MagnetBV:Destroy() end
                        if primaryPart:FindFirstChild("MagnetMark") then primaryPart.MagnetMark:Destroy() end
                    end
                end
            end
        end

        tipLabel.Text = "点击按钮开启/关闭 | 物品数: " .. tostring(count)
    end)
end

local function stopMagnet()
    if magnetConn then
        magnetConn:Disconnect()
        magnetConn = nil
    end

    -- 清除所有MagnetBV和标记
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                local bv = part:FindFirstChild("MagnetBV")
                if bv then bv:Destroy() end
                local mark = part:FindFirstChild("MagnetMark")
                if mark then mark:Destroy() end
            end
        end
    end

    tipLabel.Text = "点击按钮开启/关闭 | 物品数: 0"
end

-- ========== 按钮事件 ==========
mainBtn.MouseButton1Click:Connect(function()
    magnetEnabled = not magnetEnabled

    if magnetEnabled then
        mainBtn.BackgroundColor3 = Color3.fromRGB(137, 180, 250)
        mainBtn.TextColor3 = Color3.fromRGB(30, 30, 46)
        mainBtn.Text = "Magnet ON"
        dot.BackgroundColor3 = Color3.fromRGB(166, 227, 161)
        btnStroke.Color = Color3.fromRGB(116, 135, 200)
        startMagnet()
        notify("Item Magnet", "物品吸引已开启")
    else
        mainBtn.BackgroundColor3 = Color3.fromRGB(49, 50, 68)
        mainBtn.TextColor3 = Color3.fromRGB(205, 214, 244)
        mainBtn.Text = "Item Magnet"
        dot.BackgroundColor3 = Color3.fromRGB(243, 139, 168)
        btnStroke.Color = Color3.fromRGB(88, 91, 112)
        stopMagnet()
        notify("Item Magnet", "物品吸引已关闭")
    end
end)

-- 悬停效果
mainBtn.MouseEnter:Connect(function()
    if not magnetEnabled then
        mainBtn.BackgroundColor3 = Color3.fromRGB(69, 71, 90)
    end
end)
mainBtn.MouseLeave:Connect(function()
    if not magnetEnabled then
        mainBtn.BackgroundColor3 = Color3.fromRGB(49, 50, 68)
    end
end)

-- ========== 拖拽 ==========
local dragging = false
local dragStart, startPos

mainBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        -- 只在标题区域拖拽，不在按钮中心拖拽
        dragging = true
        dragStart = input.Position
        startPos = mainBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
        mainBtn.Position = newPos
        speedLabel.Position = UDim2.new(newPos.X.Scale, newPos.X.Offset, 0, 64)
        tipLabel.Position = UDim2.new(newPos.X.Scale, newPos.X.Offset - 40, 0, 82)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ========== 关键快捷键 ==========
local keyConn = UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.M then
        mainBtn.MouseButton1Click:Fire()
    end
end)

notify("Item Magnet", "加载完成！点击按钮或按M键开关")
