--[[
    KaiHub Retro - WinXP风格 Roblox 脚本Hub
    完整搬运自 ChronixHub (zhengw.lua)
    UI风格: Windows XP 经典风格
    作者: KaiHub Team
    版本: 1.0.0
]]

-- ============================================================
-- 只能启动一次检测
-- ============================================================
if _G.KaiHubRetroLoaded then
    warn("[KaiHub Retro] 已经加载了！请先卸载旧版本再重新加载。")
    warn("[KaiHub Retro] 执行 _G.unloadKaiHubRetro() 卸载旧版本")
    return
end
if _G.KaiHubRetroLoading then
    warn("[KaiHub Retro] 脚本正在加载中，请勿频繁执行！")
    return
else
    _G.KaiHubRetroLoading = true
end

-- ============================================================
-- 服务引用
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local MarketplaceService = game:GetService("MarketplaceService")
local AvatarEditorService = game:GetService("AvatarEditorService")
local LogService = game:GetService("LogService")

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ============================================================
-- 配色方案 - WinXP 经典风格
-- ============================================================
local Colors = {
    WinBg = Color3.fromRGB(212, 208, 200),
    WinTitle = Color3.fromRGB(0, 16, 128),
    WinTitleText = Color3.fromRGB(255, 255, 255),
    BevelLight = Color3.fromRGB(255, 255, 255),
    BevelDark = Color3.fromRGB(128, 128, 128),
    BtnFace = Color3.fromRGB(212, 208, 200),
    BtnHighlight = Color3.fromRGB(240, 240, 240),
    BtnPressed = Color3.fromRGB(180, 180, 180),
    SidebarBg = Color3.fromRGB(236, 233, 228),
    SidebarActive = Color3.fromRGB(49, 106, 197),
    SidebarHover = Color3.fromRGB(220, 218, 214),
    ContentBg = Color3.fromRGB(255, 255, 255),
    ContentText = Color3.fromRGB(0, 0, 0),
    InputBg = Color3.fromRGB(255, 255, 255),
    ToggleOn = Color3.fromRGB(49, 106, 197),
    CloseBtn = Color3.fromRGB(180, 60, 60),
    MinBtn = Color3.fromRGB(108, 108, 108),
    StatusBarBg = Color3.fromRGB(212, 208, 200),
    MenuBarBg = Color3.fromRGB(212, 208, 200),
}

-- ============================================================
-- 启动次数统计
-- ============================================================
local statsFileName = "KaiHub_stats.json"
local launchCount = 0

pcall(function()
    local success, content = pcall(function()
        return readfile(statsFileName)
    end)
    if success and content then
        local decoded = HttpService:JSONDecode(content)
        launchCount = decoded.launchCount or 0
    end
end)

launchCount = launchCount + 1

pcall(function()
    writefile(statsFileName, HttpService:JSONEncode({launchCount = launchCount}))
end)

-- ============================================================
-- 远程模块加载系统
-- ============================================================
local MODULE_BASE_URL = "https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/"

-- 模块名到URL文件名的映射
local moduleUrlMap = {
    ChronixUI = "ChronixUI%20Lib.lua",
    tpWalk = "SafeTPWalk.lua",
    StandRecovery = "StandRecovery.lua",
    HighlightModule = "HighlightModule.lua",
    PlayerLightModule = "PlayerLightModule.lua",
    SpectatorModule = "SpectatorModule.lua",
    FreecamModule = "FreecamModule.lua",
    LandingEffect = "LandingEffect.lua",
    NameTagModule = "NameTagModule.lua",
    PlayerVisibleModule = "PlayerVisibleModule.lua",
    movementModule = "MovementModule.lua",
    MouseUnlockModule = "MouseUnlockModule.lua",
    DeathballScripts = "DeathBallScripts.lua",
    ZoomModule = "ZoomModule.lua",
    FlingDetector = "FlingDetector.lua",
    SystemNotification = "SystemNotification.lua",
    PlayerESP = "PlayerESP.lua",
    MovableHighlighter_NM = "MovableHighlighter-NM.lua",
    GameTeleport = "GameTeleport.lua",
    AntiVoidModule = "AntiVoid.lua",
    ChatSpy = "ChatSpy.lua",
    ChatControl = "ChatControl.lua",
    AirWalk = "AirWalk.lua",
    LockCameraModule = "LockCameraModule.lua",
    OBOTeleportModule = "OBOTeleportModule.lua",
    NPCHighLighter = "NPC_Highlighter.lua",
    ChatTagModule = "ChatTagModule.lua",
    FlyModule = "FlyModule.lua",
    ScrollSwitch = "ScrollSwitch.lua",
    Regretevator_AutoIceCream = "Regretevator_AutoIceCream.lua",
    InstantInteraction = "InstantInteraction.lua",
    UNCTestModule = "uncAndwuncget.lua",
    ServerFinderModule = "ServerFinderModule.lua",
    AimBotModule = "AimBotModule.lua",
    DeleteTool = "DeleteTool.lua",
    GuiDeleter = "GuiDeleter.lua",
    AntiKickModule = "AntiKick.lua",
    HandleKillModule = "HandleKillModule.lua",
    FlingModule = "FlingModule.lua",
    LoopOofModule = "LoopOofModule.lua",
    SpinModule = "SpinModule.lua",
    ConfigModule = "ConfigModule.lua",
    FootstepHighlighter = "FootstepHighlighter.lua",
    TeleportModule = "TeleportModule.lua",
    WebSocketManager = "WebSocketManager.lua",
}

-- 加载 AsyncFileFetcher
local AsyncFileFetcher
local fetcherLoadSuccess, fetcherLoadErr = pcall(function()
    AsyncFileFetcher = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/AsyncFileFetcher.lua"))()
end)

if not fetcherLoadSuccess then
    warn("[KaiHub] AsyncFileFetcher 加载失败: " .. tostring(fetcherLoadErr))
    -- 降级：直接用HttpGet加载
    AsyncFileFetcher = {
        fetch = function(url)
            return game:HttpGet(url)
        end
    }
end

-- 模块缓存
local loadedModules = {}

-- 加载单个模块
local function loadModule(name)
    if loadedModules[name] then
        return loadedModules[name]
    end

    local urlFileName = moduleUrlMap[name]
    if not urlFileName then
        warn("[KaiHub] 未知模块: " .. tostring(name))
        return nil
    end

    local fullUrl = MODULE_BASE_URL .. urlFileName

    local success, result = pcall(function()
        local code = AsyncFileFetcher.fetch(fullUrl)
        return loadstring(code)()
    end)

    if not success then
        warn("[KaiHub] 模块加载失败 [" .. name .. "]: " .. tostring(result))
        return nil
    end

    loadedModules[name] = result
    return result
end

-- 批量加载所有模块
local function loadAllModules()
    for name, _ in pairs(moduleUrlMap) do
        loadModule(name)
    end
end

-- ============================================================
-- 加载所有模块
-- ============================================================
loadAllModules()

-- 获取模块引用（兼容性）
local ChronixUI = loadedModules.ChronixUI
local tpWalk = loadedModules.tpWalk
local StandRecovery = loadedModules.StandRecovery
local HighlightModule = loadedModules.HighlightModule
local PlayerLightModule = loadedModules.PlayerLightModule
local SpectatorModule = loadedModules.SpectatorModule
local FreecamModule = loadedModules.FreecamModule
local LandingEffect = loadedModules.LandingEffect
local NameTagModule = loadedModules.NameTagModule
local PlayerVisibleModule = loadedModules.PlayerVisibleModule
local movementModule = loadedModules.movementModule
local MouseUnlockModule = loadedModules.MouseUnlockModule
local DeathballScripts = loadedModules.DeathballScripts
local ZoomModule = loadedModules.ZoomModule
local FlingDetector = loadedModules.FlingDetector
local SystemNotification = loadedModules.SystemNotification
local PlayerESP = loadedModules.PlayerESP
local MovableHighlighter_NM = loadedModules.MovableHighlighter_NM
local GameTeleport = loadedModules.GameTeleport
local AntiVoidModule = loadedModules.AntiVoidModule
local ChatSpy = loadedModules.ChatSpy
local ChatControl = loadedModules.ChatControl
local AirWalk = loadedModules.AirWalk
local LockCameraModule = loadedModules.LockCameraModule
local OBOTeleportModule = loadedModules.OBOTeleportModule
local NPCHighLighter = loadedModules.NPCHighLighter
local ChatTagModule = loadedModules.ChatTagModule
local FlyModule = loadedModules.FlyModule
local ScrollSwitch = loadedModules.ScrollSwitch
local Regretevator_AutoIceCream = loadedModules.Regretevator_AutoIceCream
local InstantInteraction = loadedModules.InstantInteraction
local UNCTestModule = loadedModules.UNCTestModule
local ServerFinderModule = loadedModules.ServerFinderModule
local AimBotModule = loadedModules.AimBotModule
local DeleteTool = loadedModules.DeleteTool
local GuiDeleter = loadedModules.GuiDeleter
local AntiKickModule = loadedModules.AntiKickModule
local HandleKillModule = loadedModules.HandleKillModule
local FlingModule = loadedModules.FlingModule
local LoopOofModule = loadedModules.LoopOofModule
local SpinModule = loadedModules.SpinModule
local ConfigModule = loadedModules.ConfigModule
local FootstepHighlighter = loadedModules.FootstepHighlighter
local TeleportModule = loadedModules.TeleportModule
local WebSocketManager = loadedModules.WebSocketManager

-- ============================================================
-- 数据结构（和原版zhengw.lua完全一样）
-- ============================================================
local data = {
    basicdata = {
        window = {windowSize = UDim2.new(0, 460, 0, 300)},
        player = {
            name = LP.Name, displayname = LP.DisplayName, userid = LP.UserId,
            speed = 16, islockspeed = false,
            jump = 50, islockjump = false,
            maxhealth = 100, islockmaxhealth = false,
            health = 100, islockhealth = false,
            gravity = Workspace.Gravity, islockgravity = false
        },
        releasetools = {
            antiafk = true,
            zoom = ZoomModule and ZoomModule.new() or nil,
            Lantern = PlayerLightModule and PlayerLightModule.new({Brightness=3,Range=20,Color=Color3.fromRGB(255,165,0),Shadows=true}) or nil,
            SuperLighter = PlayerLightModule and PlayerLightModule.new({Brightness=2,Range=1000}) or nil,
            noclip = false, infjump = false, antifall = false, antidead = false,
            nightvision = false, supernightvision = false,
            originalBrightness = Lighting.Brightness,
            originalExposureCompensation = Lighting.ExposureCompensation,
            keepchronixhub = false, networkpausedisable = false, exitgame = 0,
            staffcheck = false, xray = false,
            npc = NPCHighLighter and NPCHighLighter.new() or nil,
            chatresend = false, executecode = ""
        },
        otherdata = {
            playertitle = {
                tag = ChatTagModule and ChatTagModule.new({player=LP,text="[VIP]",color="#FFD700",size=18}) or nil,
                text = "[VIP]", color = "#FFD700", size = 18
            },
            musicbox = Instance.new("Sound"),
            testSound = Instance.new("Sound"),
            daySettings = {
                Ambient = Lighting.Ambient,
                Brightness = Lighting.Brightness,
                ColorShift_Bottom = Lighting.ColorShift_Bottom,
                ColorShift_Top = Lighting.ColorShift_Top,
                OutdoorAmbient = Lighting.OutdoorAmbient,
                GlobalShadows = Lighting.GlobalShadows
            },
            nightSettings = {
                Ambient = Color3.new(0.1, 0.1, 0.15),
                Brightness = 0.3,
                ColorShift_Bottom = Color3.new(0, 0, 0),
                ColorShift_Top = Color3.new(0, 0, 0),
                OutdoorAmbient = Color3.new(0.05, 0.05, 0.1),
                GlobalShadows = true
            },
            musicData = {
                musicIds = {"142376088", "1838618353", "1837879082", "1841647093", "1837879099"},
                currentId = "142376088", isPlay = false, isPause = false
            },
            savedAtmospheres = {}
        }
    },
    othergamedata = {
        delesions_office = {entitywarning = false, tipotherplayer = false, auto013 = false},
        grace = {autolever = false, deleteentity = false},
        AntarcticExpedition = {giftnumber = "1"}
    },
    basicdata_hankermodule = {
        spin = {speed = 20},
        hkill = {killname = "PlayerName", killrange = 100, killall = false, killany = false}
    },
    Supported_Games = {
        {name = "死亡球", gameid = 12776501474},
        {name = "小屋角色扮演", gameid = 12625580888},
        {name = "南极探险队", gameid = 11656036927},
        {name = "西部森林", gameid = 1324061305},
        {name = "警笛头:遗产", gameid = 1162065585},
        {name = "噩梦之行", gameid = 11649582918},
        {name = "兽化项目", gameid = 14036136131},
        {name = "妄想办公室", gameid = 15753132981},
        {name = "格蕾丝", gameid = 15049111150},
        {name = "后悔电梯", gameid = 12776501474}
    },
    scriptlist = {
        {name = "Infinite Yield", link = "https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source"},
        {name = "Dex Explorer", link = "https://raw.githubusercontent.com/Babyhamsta/RBLX_DEX/main/out/dex.lua"},
        {name = "Remote Spy", link = "https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"}
    }
}

-- 初始化音乐播放器
data.basicdata.otherdata.musicbox.Volume = 0.5
data.basicdata.otherdata.musicbox.Looped = false
data.basicdata.otherdata.musicbox.Parent = SoundService
data.basicdata.otherdata.testSound.Volume = 0.5
data.basicdata.otherdata.testSound.Parent = SoundService

-- ============================================================
-- 连接表（用于卸载清理）
-- ============================================================
local connections = {}
local guiElements = {} -- 存储所有创建的GUI元素

-- ============================================================
-- RetroUI 框架 - WinXP 风格
-- ============================================================
local RetroUI = {}

-- 3D边框函数
function RetroUI.bevel(parent, style, thick)
    thick = thick or 1
    local lightColor = Colors.BevelLight
    local darkColor = Colors.BevelDark

    if style == "raised" then
        -- 左上亮色，右下暗色
        local top = Instance.new("Frame")
        top.Name = "BevelTop"
        top.Size = UDim2.new(1, 0, 0, thick)
        top.Position = UDim2.new(0, 0, 0, 0)
        top.BackgroundColor3 = lightColor
        top.BorderSizePixel = 0
        top.Parent = parent

        local left = Instance.new("Frame")
        left.Name = "BevelLeft"
        left.Size = UDim2.new(0, thick, 1, 0)
        left.Position = UDim2.new(0, 0, 0, 0)
        left.BackgroundColor3 = lightColor
        left.BorderSizePixel = 0
        left.Parent = parent

        local bottom = Instance.new("Frame")
        bottom.Name = "BevelBottom"
        bottom.Size = UDim2.new(1, 0, 0, thick)
        bottom.Position = UDim2.new(0, 0, 1, -thick)
        bottom.BackgroundColor3 = darkColor
        bottom.BorderSizePixel = 0
        bottom.Parent = parent

        local right = Instance.new("Frame")
        right.Name = "BevelRight"
        right.Size = UDim2.new(0, thick, 1, 0)
        right.Position = UDim2.new(1, -thick, 0, 0)
        right.BackgroundColor3 = darkColor
        right.BorderSizePixel = 0
        right.Parent = parent
    elseif style == "sunken" then
        -- 左上暗色，右下亮色
        local top = Instance.new("Frame")
        top.Name = "BevelTop"
        top.Size = UDim2.new(1, 0, 0, thick)
        top.Position = UDim2.new(0, 0, 0, 0)
        top.BackgroundColor3 = darkColor
        top.BorderSizePixel = 0
        top.Parent = parent

        local left = Instance.new("Frame")
        left.Name = "BevelLeft"
        left.Size = UDim2.new(0, thick, 1, 0)
        left.Position = UDim2.new(0, 0, 0, 0)
        left.BackgroundColor3 = darkColor
        left.BorderSizePixel = 0
        left.Parent = parent

        local bottom = Instance.new("Frame")
        bottom.Name = "BevelBottom"
        bottom.Size = UDim2.new(1, 0, 0, thick)
        bottom.Position = UDim2.new(0, 0, 1, -thick)
        bottom.BackgroundColor3 = lightColor
        bottom.BorderSizePixel = 0
        bottom.Parent = parent

        local right = Instance.new("Frame")
        right.Name = "BevelRight"
        right.Size = UDim2.new(0, thick, 1, 0)
        right.Position = UDim2.new(1, -thick, 0, 0)
        right.BackgroundColor3 = lightColor
        right.BorderSizePixel = 0
        right.Parent = parent
    end
end

-- 音效系统 - 机械键盘点击声
local SoundService = game:GetService("SoundService")
local keyClickSounds = {}

local function initKeySounds()
    -- 使用rbxassetid创建机械键盘音效（使用Roblox内置的UI点击音效作为替代）
    -- 由于无法保证外部音频ID可用，使用程序化生成的点击声
    local soundIds = {
        "rbxassetid://9113083740",  -- 机械键盘点击声1
        "rbxassetid://9113083913",  -- 机械键盘点击声2
        "rbxassetid://9113084088",  -- 机械键盘点击声3
    }
    
    for i, soundId in ipairs(soundIds) do
        local sound = Instance.new("Sound")
        sound.Name = "KeyClick_" .. i
        sound.SoundId = soundId
        sound.Volume = 0.3
        sound.Parent = SoundService
        table.insert(keyClickSounds, sound)
    end
end

local function playKeyClick()
    if #keyClickSounds > 0 then
        local sound = keyClickSounds[math.random(1, #keyClickSounds)]
        pcall(function()
            sound:Play()
        end)
    end
end

-- 创建主窗口
function RetroUI:CreateWindow(options)
    options = options or {}
    local windowSize = options.size or data.basicdata.window.windowSize

    -- 初始化音效
    pcall(initKeySounds)

    -- 主窗口容器
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KaiHubRetro"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game:GetService("CoreGui")
    table.insert(guiElements, screenGui)

    -- 主窗口Frame
    local mainWindow = Instance.new("Frame")
    mainWindow.Name = "MainWindow"
    mainWindow.Size = windowSize
    mainWindow.Position = UDim2.new(0.5, -230, 0.5, -150)
    mainWindow.BackgroundColor3 = Colors.WinBg
    mainWindow.BorderSizePixel = 0
    mainWindow.ClipsDescendants = true
    mainWindow.Parent = screenGui
    table.insert(guiElements, mainWindow)

    -- 窗口外边框（3D凸起）
    local outerFrame = Instance.new("Frame")
    outerFrame.Name = "OuterBevel"
    outerFrame.Size = UDim2.new(1, 4, 1, 4)
    outerFrame.Position = UDim2.new(0, -2, 0, -2)
    outerFrame.BackgroundTransparency = 1
    outerFrame.BorderSizePixel = 0
    outerFrame.Parent = mainWindow
    RetroUI.bevel(outerFrame, "raised", 2)

    -- === 标题栏 (22px) ===
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 22)
    titleBar.BackgroundColor3 = Colors.WinTitle
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainWindow
    table.insert(guiElements, titleBar)

    -- 标题栏渐变效果（用多个细条模拟）
    local gradTop = Instance.new("Frame")
    gradTop.Size = UDim2.new(1, 0, 0, 6)
    gradTop.Position = UDim2.new(0, 0, 0, 0)
    gradTop.BackgroundColor3 = Color3.fromRGB(30, 60, 180)
    gradTop.BorderSizePixel = 0
    gradTop.Parent = titleBar

    local gradMid = Instance.new("Frame")
    gradMid.Size = UDim2.new(1, 0, 0, 10)
    gradMid.Position = UDim2.new(0, 0, 0, 6)
    gradMid.BackgroundColor3 = Colors.WinTitle
    gradMid.BorderSizePixel = 0
    gradMid.Parent = titleBar

    local gradBot = Instance.new("Frame")
    gradBot.Size = UDim2.new(1, 0, 0, 6)
    gradBot.Position = UDim2.new(0, 0, 0, 16)
    gradBot.BackgroundColor3 = Color3.fromRGB(0, 8, 80)
    gradBot.BorderSizePixel = 0
    gradBot.Parent = titleBar

    -- 标题图标
    local iconBtn = Instance.new("ImageButton")
    iconBtn.Size = UDim2.new(0, 16, 0, 16)
    iconBtn.Position = UDim2.new(0, 4, 0, 3)
    iconBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    iconBtn.BorderSizePixel = 0
    iconBtn.AutoButtonColor = false
    iconBtn.Parent = titleBar

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(1, 0, 1, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = "K"
    iconLabel.TextColor3 = Colors.WinTitleText
    iconLabel.TextSize = 11
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = iconBtn

    -- 标题文字
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleText"
    titleLabel.Size = UDim2.new(1, -80, 0, 22)
    titleLabel.Position = UDim2.new(0, 22, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "KaiHub"
    titleLabel.TextColor3 = Colors.WinTitleText
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    -- 最小化按钮 (WinXP风格 - 下划线图标)
    local minBtn = Instance.new("TextButton")
    minBtn.Name = "MinBtn"
    minBtn.Size = UDim2.new(0, 22, 0, 16)
    minBtn.Position = UDim2.new(1, -46, 0, 3)
    minBtn.BackgroundColor3 = Colors.BtnFace
    minBtn.BorderSizePixel = 0
    minBtn.Text = ""
    minBtn.AutoButtonColor = false
    minBtn.Parent = titleBar
    RetroUI.bevel(minBtn, "raised", 1)

    -- WinXP 最小化图标 (下划线)
    local minIcon = Instance.new("Frame")
    minIcon.Name = "MinIcon"
    minIcon.Size = UDim2.new(0, 8, 0, 2)
    minIcon.Position = UDim2.new(0.5, -4, 0.5, 3)
    minIcon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    minIcon.BorderSizePixel = 0
    minIcon.Parent = minBtn

    -- 点击音效
    minBtn.MouseButton1Click:Connect(function()
        playKeyClick()
    end)

    -- 关闭按钮 (WinXP风格 - X图标)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 22, 0, 16)
    closeBtn.Position = UDim2.new(1, -22, 0, 3)
    closeBtn.BackgroundColor3 = Colors.BtnFace
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    closeBtn.TextSize = 11
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = titleBar
    RetroUI.bevel(closeBtn, "raised", 1)

    -- 点击音效
    closeBtn.MouseButton1Click:Connect(function()
        playKeyClick()
    end)

    -- === 菜单栏 (18px) ===
    local menuBar = Instance.new("Frame")
    menuBar.Name = "MenuBar"
    menuBar.Size = UDim2.new(1, 0, 0, 18)
    menuBar.Position = UDim2.new(0, 0, 0, 22)
    menuBar.BackgroundColor3 = Colors.MenuBarBg
    menuBar.BorderSizePixel = 0
    menuBar.Parent = mainWindow
    RetroUI.bevel(menuBar, "sunken", 1)

    local menuItems = {"文件", "编辑", "查看", "帮助"}
    local menuBtns = {}
    local menuXOffset = 2
    for _, menuName in ipairs(menuItems) do
        local mBtn = Instance.new("TextButton")
        mBtn.Name = "Menu_" .. menuName
        mBtn.Size = UDim2.new(0, 40, 0, 16)
        mBtn.Position = UDim2.new(0, menuXOffset, 0, 1)
        mBtn.BackgroundColor3 = Colors.BtnFace
        mBtn.BorderSizePixel = 0
        mBtn.Text = menuName
        mBtn.TextColor3 = Colors.ContentText
        mBtn.TextSize = 11
        mBtn.Font = Enum.Font.Gotham
        mBtn.AutoButtonColor = false
        mBtn.Parent = menuBar
        table.insert(guiElements, mBtn)

        mBtn.MouseButton1Click:Connect(function()
            playKeyClick()
            -- 菜单点击效果
            mBtn.BackgroundColor3 = Colors.BtnPressed
            wait(0.1)
            mBtn.BackgroundColor3 = Colors.BtnFace
        end)

        menuBtns[menuName] = mBtn
        menuXOffset = menuXOffset + 42
    end

    -- === 主体区域 ===
    local bodyFrame = Instance.new("Frame")
    bodyFrame.Name = "Body"
    bodyFrame.Size = UDim2.new(1, 0, 1, -58)
    bodyFrame.Position = UDim2.new(0, 0, 0, 40)
    bodyFrame.BackgroundColor3 = Colors.WinBg
    bodyFrame.BorderSizePixel = 0
    bodyFrame.Parent = mainWindow

    -- 左侧侧边栏 (110px)
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 110, 1, 0)
    sidebar.BackgroundColor3 = Colors.SidebarBg
    sidebar.BorderSizePixel = 0
    sidebar.Parent = bodyFrame
    RetroUI.bevel(sidebar, "sunken", 1)

    -- 侧边栏ScrollingFrame
    local sidebarScroll = Instance.new("ScrollingFrame")
    sidebarScroll.Name = "SidebarScroll"
    sidebarScroll.Size = UDim2.new(1, -4, 1, -4)
    sidebarScroll.Position = UDim2.new(0, 2, 0, 2)
    sidebarScroll.BackgroundTransparency = 1
    sidebarScroll.BorderSizePixel = 0
    sidebarScroll.ScrollBarThickness = 6
    sidebarScroll.ScrollBarImageColor3 = Colors.BevelDark
    sidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 500)
    sidebarScroll.Active = true
    sidebarScroll.Parent = sidebar

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 1)
    sidebarLayout.Parent = sidebarScroll

    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingLeft = UDim.new(0, 2)
    sidebarPadding.PaddingRight = UDim.new(0, 2)
    sidebarPadding.PaddingTop = UDim.new(0, 2)
    sidebarPadding.PaddingBottom = UDim.new(0, 2)
    sidebarPadding.Parent = sidebarScroll
    
    -- 监听布局变化自动更新CanvasSize
    sidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sidebarScroll.CanvasSize = UDim2.new(0, 0, 0, sidebarLayout.AbsoluteContentSize.Y + 8)
    end)

    -- 右侧内容区
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -112, 1, 0)
    contentArea.Position = UDim2.new(0, 112, 0, 0)
    contentArea.BackgroundColor3 = Colors.ContentBg
    contentArea.BorderSizePixel = 0
    contentArea.Parent = bodyFrame
    RetroUI.bevel(contentArea, "sunken", 1)

    -- === 状态栏 (18px) ===
    local statusBar = Instance.new("Frame")
    statusBar.Name = "StatusBar"
    statusBar.Size = UDim2.new(1, 0, 0, 18)
    statusBar.Position = UDim2.new(0, 0, 1, -18)
    statusBar.BackgroundColor3 = Colors.StatusBarBg
    statusBar.BorderSizePixel = 0
    statusBar.Parent = mainWindow
    RetroUI.bevel(statusBar, "sunken", 1)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusText"
    statusLabel.Size = UDim2.new(0.7, 0, 1, 0)
    statusLabel.Position = UDim2.new(0, 4, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "就绪"
    statusLabel.TextColor3 = Colors.ContentText
    statusLabel.TextSize = 10
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = statusBar

    local clockLabel = Instance.new("TextLabel")
    clockLabel.Name = "ClockText"
    clockLabel.Size = UDim2.new(0.3, 0, 1, 0)
    clockLabel.Position = UDim2.new(0.7, 0, 0, 0)
    clockLabel.BackgroundTransparency = 1
    clockLabel.Text = ""
    clockLabel.TextColor3 = Colors.ContentText
    clockLabel.TextSize = 10
    clockLabel.Font = Enum.Font.Gotham
    clockLabel.TextXAlignment = Enum.TextXAlignment.Right
    clockLabel.Parent = statusBar

    -- 时钟更新
    local clockConn
    clockConn = RunService.Heartbeat:Connect(function()
        local t = os.date("*t")
        clockLabel.Text = string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
    end)
    table.insert(connections, clockConn)

    -- === 标签页系统 ===
    local tabs = {}
    local tabOrder = 0

    function self:AddTab(name)
        tabOrder = tabOrder + 1

        -- 侧边栏标签按钮
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = "Tab_" .. name
        tabBtn.Size = UDim2.new(1, -4, 0, 26)
        tabBtn.BackgroundColor3 = Colors.SidebarBg
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = "  " .. name
        tabBtn.TextColor3 = Colors.ContentText
        tabBtn.TextSize = 11
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.AutoButtonColor = false
        tabBtn.Active = true
        tabBtn.LayoutOrder = tabOrder
        tabBtn.Parent = sidebarScroll
        table.insert(guiElements, tabBtn)

        -- 左侧指示条
        local indicator = Instance.new("Frame")
        indicator.Name = "Indicator"
        indicator.Size = UDim2.new(0, 3, 0.6, 0)
        indicator.Position = UDim2.new(0, 0, 0.2, 0)
        indicator.BackgroundColor3 = Colors.SidebarActive
        indicator.BorderSizePixel = 0
        indicator.BackgroundTransparency = 1
        indicator.Parent = tabBtn

        -- 内容区ScrollingFrame
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = "Content_" .. name
        tabContent.Size = UDim2.new(1, -4, 1, -4)
        tabContent.Position = UDim2.new(0, 2, 0, 2)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 6
        tabContent.ScrollBarImageColor3 = Colors.BevelDark
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 500)
        tabContent.Visible = false
        tabContent.Parent = contentArea

        local contentLayout = Instance.new("UIListLayout")
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 2)
        contentLayout.Parent = tabContent

        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingLeft = UDim.new(0, 4)
        contentPadding.PaddingRight = UDim.new(0, 4)
        contentPadding.PaddingTop = UDim.new(0, 4)
        contentPadding.PaddingBottom = UDim.new(0, 4)
        contentPadding.Parent = tabContent
        
        -- 监听布局变化自动更新CanvasSize
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 8)
        end)

        local tabInfo = {
            name = name,
            button = tabBtn,
            content = tabContent,
            layout = contentLayout,
            controlOrder = 0,
            indicator = indicator
        }

        -- 点击切换
        tabBtn.MouseButton1Click:Connect(function()
            playKeyClick()
            for _, t in pairs(tabs) do
                t.content.Visible = false
                t.button.BackgroundColor3 = Colors.SidebarBg
                t.button.TextColor3 = Colors.ContentText
                t.indicator.BackgroundTransparency = 1
            end
            tabContent.Visible = true
            tabBtn.BackgroundColor3 = Colors.SidebarActive
            tabBtn.TextColor3 = Colors.WinTitleText
            tabBtn.Text = "  " .. name
            indicator.BackgroundTransparency = 0
        end)

        tabs[name] = tabInfo
        return tabInfo
    end

    -- === 控件系统 ===

    -- 标签
    function self:AddLabel(tabName, text)
        local tab = tabs[tabName]
        if not tab then return nil end
        tab.controlOrder = tab.controlOrder + 1

        local labelFrame = Instance.new("Frame")
        labelFrame.Name = "Label_" .. text
        labelFrame.Size = UDim2.new(1, 0, 0, 20)
        labelFrame.BackgroundColor3 = Color3.fromRGB(200, 196, 188)
        labelFrame.BorderSizePixel = 0
        labelFrame.LayoutOrder = tab.controlOrder
        labelFrame.Parent = tab.content
        RetroUI.bevel(labelFrame, "sunken", 1)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -6, 1, -2)
        label.Position = UDim2.new(0, 3, 0, 1)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Colors.ContentText
        label.TextSize = 10
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = labelFrame

        return labelFrame
    end

    -- 按钮
    function self:AddButton(tabName, text, callback)
        local tab = tabs[tabName]
        if not tab then return nil end
        tab.controlOrder = tab.controlOrder + 1

        local btn = Instance.new("TextButton")
        btn.Name = "Btn_" .. text
        btn.Size = UDim2.new(1, 0, 0, 24)
        btn.BackgroundColor3 = Colors.BtnFace
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = Colors.ContentText
        btn.TextSize = 11
        btn.Font = Enum.Font.Gotham
        btn.AutoButtonColor = false
        btn.LayoutOrder = tab.controlOrder
        btn.Parent = tab.content
        RetroUI.bevel(btn, "raised", 1)
        table.insert(guiElements, btn)

        btn.MouseButton1Click:Connect(function()
            playKeyClick()
            -- 按下效果
            btn.BackgroundColor3 = Colors.BtnPressed
            wait(0.08)
            btn.BackgroundColor3 = Colors.BtnFace
            if callback then callback() end
        end)

        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Colors.BtnHighlight
        end)

        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Colors.BtnFace
        end)

        return btn
    end

    -- 开关（复选框）
    function self:AddToggle(tabName, text, default, callback)
        local tab = tabs[tabName]
        if not tab then return nil end
        tab.controlOrder = tab.controlOrder + 1

        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = "Toggle_" .. text
        toggleFrame.Size = UDim2.new(1, 0, 0, 22)
        toggleFrame.BackgroundColor3 = Colors.ContentBg
        toggleFrame.BorderSizePixel = 0
        toggleFrame.LayoutOrder = tab.controlOrder
        toggleFrame.Parent = tab.content

        -- 复选框
        local checkbox = Instance.new("TextButton")
        checkbox.Name = "Checkbox"
        checkbox.Size = UDim2.new(0, 14, 0, 14)
        checkbox.Position = UDim2.new(0, 2, 0.5, -7)
        checkbox.BackgroundColor3 = Colors.InputBg
        checkbox.BorderSizePixel = 0
        checkbox.Text = ""
        checkbox.AutoButtonColor = false
        checkbox.Parent = toggleFrame
        RetroUI.bevel(checkbox, "sunken", 1)

        -- 勾选标记
        local checkMark = Instance.new("TextLabel")
        checkMark.Size = UDim2.new(1, 0, 1, 0)
        checkMark.BackgroundTransparency = 1
        checkMark.Text = ""
        checkMark.TextColor3 = Colors.ContentText
        checkMark.TextSize = 10
        checkMark.Font = Enum.Font.GothamBold
        checkMark.Parent = checkbox

        -- 文字标签
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Size = UDim2.new(1, -22, 0, 22)
        toggleLabel.Position = UDim2.new(0, 20, 0, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = text
        toggleLabel.TextColor3 = Colors.ContentText
        toggleLabel.TextSize = 11
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggleFrame

        local toggled = default or false

        local function updateVisual()
            if toggled then
                checkMark.Text = "X"
                checkbox.BackgroundColor3 = Colors.ToggleOn
                checkMark.TextColor3 = Colors.WinTitleText
            else
                checkMark.Text = ""
                checkbox.BackgroundColor3 = Colors.InputBg
            end
        end

        updateVisual()

        checkbox.MouseButton1Click:Connect(function()
            playKeyClick()
            toggled = not toggled
            updateVisual()
            if callback then callback(toggled) end
        end)

        return {frame = toggleFrame, get = function() return toggled end, set = function(v) toggled = v; updateVisual() end}
    end

    -- 滑块（关键修复：同时支持鼠标和触摸）
    function self:AddSlider(tabName, text, min, max, default, callback)
        local tab = tabs[tabName]
        if not tab then return nil end
        tab.controlOrder = tab.controlOrder + 1

        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = "Slider_" .. text
        sliderFrame.Size = UDim2.new(1, 0, 0, 36)
        sliderFrame.BackgroundColor3 = Colors.ContentBg
        sliderFrame.BorderSizePixel = 0
        sliderFrame.LayoutOrder = tab.controlOrder
        sliderFrame.Parent = tab.content

        -- 标签
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Name = "Label"
        sliderLabel.Size = UDim2.new(1, 0, 0, 16)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = text .. ": " .. tostring(default)
        sliderLabel.TextColor3 = Colors.ContentText
        sliderLabel.TextSize = 10
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Parent = sliderFrame

        -- 轨道容器
        local trackContainer = Instance.new("Frame")
        trackContainer.Name = "TrackContainer"
        trackContainer.Size = UDim2.new(1, 0, 0, 14)
        trackContainer.Position = UDim2.new(0, 0, 0, 18)
        trackContainer.BackgroundTransparency = 1
        trackContainer.BorderSizePixel = 0
        trackContainer.Parent = sliderFrame

        -- 轨道背景
        local track = Instance.new("Frame")
        track.Name = "Track"
        track.Size = UDim2.new(1, -4, 0, 6)
        track.Position = UDim2.new(0, 2, 0, 4)
        track.BackgroundColor3 = Color3.fromRGB(180, 176, 168)
        track.BorderSizePixel = 0
        track.Parent = trackContainer
        RetroUI.bevel(track, "sunken", 1)

        -- 填充
        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        local fillRatio = (default - min) / (max - min)
        fill.Size = UDim2.new(fillRatio, 0, 1, -2)
        fill.Position = UDim2.new(0, 1, 0, 1)
        fill.BackgroundColor3 = Colors.ToggleOn
        fill.BorderSizePixel = 0
        fill.Parent = track

        -- 滑块按钮（thumb）
        local thumb = Instance.new("TextButton")
        thumb.Name = "Thumb"
        thumb.Size = UDim2.new(0, 12, 0, 14)
        thumb.Position = UDim2.new(fillRatio, -6, 0, -4)
        thumb.BackgroundColor3 = Colors.BtnFace
        thumb.BorderSizePixel = 0
        thumb.Text = ""
        thumb.AutoButtonColor = false
        thumb.Parent = trackContainer
        -- 关键：必须设置Active=true才能接收触摸输入
        thumb.Active = true
        RetroUI.bevel(thumb, "raised", 1)
        table.insert(guiElements, thumb)

        local isDragging = false
        local currentValue = default

        local function updateSlider(inputPos)
            -- 计算相对位置
            local ratio = math.clamp((inputPos.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            currentValue = min + (max - min) * ratio

            -- 更新填充和滑块位置
            fill.Size = UDim2.new(ratio, 0, 1, -2)
            thumb.Position = UDim2.new(ratio, -6, 0, -4)

            -- 更新标签
            sliderLabel.Text = text .. ": " .. string.format("%.1f", currentValue)

            if callback then
                callback(currentValue)
            end
        end

        -- thumb的InputBegan - 检测MouseButton1和Touch
        thumb.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                updateSlider(input.Position)
            end
        end)

        -- UserInputService.InputChanged - 检测MouseMovement和Touch移动
        local inputChangedConn
        inputChangedConn = UserInputService.InputChanged:Connect(function(input)
            if isDragging then
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    updateSlider(input.Position)
                end
            end
        end)
        table.insert(connections, inputChangedConn)

        -- UserInputService.InputEnded - 检测MouseButton1和Touch结束
        local inputEndedConn
        inputEndedConn = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = false
            end
        end)
        table.insert(connections, inputEndedConn)

        -- 点击轨道直接跳转
        local trackInputConn
        trackInputConn = track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                updateSlider(input.Position)
            end
        end)
        table.insert(connections, trackInputConn)

        return {
            frame = sliderFrame,
            get = function() return currentValue end,
            set = function(v)
                currentValue = math.clamp(v, min, max)
                local r = (currentValue - min) / (max - min)
                fill.Size = UDim2.new(r, 0, 1, -2)
                thumb.Position = UDim2.new(r, -6, 0, -4)
                sliderLabel.Text = text .. ": " .. string.format("%.1f", currentValue)
            end
        }
    end

    -- 文本框
    function self:AddTextBox(tabName, labelText, callback)
        local tab = tabs[tabName]
        if not tab then return nil end
        tab.controlOrder = tab.controlOrder + 1

        local textBoxFrame = Instance.new("Frame")
        textBoxFrame.Name = "TextBox_" .. labelText
        textBoxFrame.Size = UDim2.new(1, 0, 0, 36)
        textBoxFrame.BackgroundColor3 = Colors.ContentBg
        textBoxFrame.BorderSizePixel = 0
        textBoxFrame.LayoutOrder = tab.controlOrder
        textBoxFrame.Parent = tab.content

        -- 标签
        local tLabel = Instance.new("TextLabel")
        tLabel.Size = UDim2.new(1, 0, 0, 16)
        tLabel.BackgroundTransparency = 1
        tLabel.Text = labelText
        tLabel.TextColor3 = Colors.ContentText
        tLabel.TextSize = 10
        tLabel.Font = Enum.Font.Gotham
        tLabel.TextXAlignment = Enum.TextXAlignment.Left
        tLabel.Parent = textBoxFrame

        -- 输入框容器
        local inputContainer = Instance.new("Frame")
        inputContainer.Size = UDim2.new(1, 0, 0, 18)
        inputContainer.Position = UDim2.new(0, 0, 0, 18)
        inputContainer.BackgroundColor3 = Colors.InputBg
        inputContainer.BorderSizePixel = 0
        inputContainer.Parent = textBoxFrame
        RetroUI.bevel(inputContainer, "sunken", 1)

        -- 输入框
        local inputBox = Instance.new("TextBox")
        inputBox.Name = "Input"
        inputBox.Size = UDim2.new(1, -4, 1, -2)
        inputBox.Position = UDim2.new(0, 2, 0, 1)
        inputBox.BackgroundTransparency = 1
        inputBox.Text = ""
        inputBox.TextColor3 = Colors.ContentText
        inputBox.TextSize = 11
        inputBox.Font = Enum.Font.Gotham
        inputBox.PlaceholderText = "输入..."
        inputBox.PlaceholderColor3 = Color3.fromRGB(128, 128, 128)
        inputBox.TextXAlignment = Enum.TextXAlignment.Left
        inputBox.ClearTextOnFocus = false
        inputBox.Parent = inputContainer

        if callback then
            inputBox.FocusLost:Connect(function()
                callback(inputBox.Text)
            end)
        end

        return {frame = textBoxFrame, input = inputBox, get = function() return inputBox.Text end}
    end

    -- 分隔线
    function self:AddSeparator(tabName)
        local tab = tabs[tabName]
        if not tab then return nil end
        tab.controlOrder = tab.controlOrder + 1

        local sep = Instance.new("Frame")
        sep.Name = "Separator"
        sep.Size = UDim2.new(1, 0, 0, 2)
        sep.BackgroundColor3 = Colors.BevelDark
        sep.BorderSizePixel = 0
        sep.LayoutOrder = tab.controlOrder
        sep.Parent = tab.content
        return sep
    end

    -- === 拖拽功能（同时支持鼠标和触摸） ===
    local isDraggingWindow = false
    local dragStart, startPos

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDraggingWindow = true
            dragStart = input.Position
            startPos = mainWindow.Position
        end
    end)

    local dragConn
    dragConn = UserInputService.InputChanged:Connect(function(input)
        if isDraggingWindow then
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                mainWindow.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end
    end)
    table.insert(connections, dragConn)

    local dragEndConn
    dragEndConn = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDraggingWindow = false
        end
    end)
    table.insert(connections, dragEndConn)

    -- === 最小化功能 ===
    local taskbarBtn = Instance.new("TextButton")
    taskbarBtn.Name = "TaskbarButton"
    taskbarBtn.Size = UDim2.new(0, 100, 0, 28)
    taskbarBtn.Position = UDim2.new(0, 4, 1, -32)
    taskbarBtn.BackgroundColor3 = Colors.BtnFace
    taskbarBtn.BorderSizePixel = 0
    taskbarBtn.Text = ""
    taskbarBtn.AutoButtonColor = false
    taskbarBtn.Visible = false
    taskbarBtn.Parent = screenGui
    RetroUI.bevel(taskbarBtn, "raised", 2)
    table.insert(guiElements, taskbarBtn)

    -- 任务栏图标 (WinXP风格 Windows旗帜)
    local tbIcon = Instance.new("Frame")
    tbIcon.Size = UDim2.new(0, 16, 0, 16)
    tbIcon.Position = UDim2.new(0, 4, 0.5, -8)
    tbIcon.BackgroundTransparency = 1
    tbIcon.BorderSizePixel = 0
    tbIcon.Parent = taskbarBtn

    -- Windows旗帜 - 四个彩色方块
    local winColors = {
        Color3.fromRGB(255, 0, 0),    -- 红
        Color3.fromRGB(0, 180, 0),    -- 绿
        Color3.fromRGB(0, 100, 255),  -- 蓝
        Color3.fromRGB(255, 200, 0),  -- 黄
    }
    for i = 1, 4 do
        local flagPart = Instance.new("Frame")
        flagPart.Size = UDim2.new(0, 7, 0, 7)
        flagPart.Position = UDim2.new(
            (i == 1 or i == 3) and 0 or 0.5, 
            (i == 1 or i == 3) and 0 or 1,
            (i == 1 or i == 2) and 0 or 0.5,
            (i == 1 or i == 2) and 0 or 1
        )
        flagPart.BackgroundColor3 = winColors[i]
        flagPart.BorderSizePixel = 0
        flagPart.Parent = tbIcon
    end

    local tbText = Instance.new("TextLabel")
    tbText.Size = UDim2.new(1, -26, 0, 16)
    tbText.Position = UDim2.new(0, 24, 0.5, -8)
    tbText.BackgroundTransparency = 1
    tbText.Text = "KaiHub"
    tbText.TextColor3 = Colors.ContentText
    tbText.TextSize = 10
    tbText.Font = Enum.Font.Gotham
    tbText.TextXAlignment = Enum.TextXAlignment.Left
    tbText.Parent = taskbarBtn

    -- 最小化
    minBtn.MouseButton1Click:Connect(function()
        mainWindow.Visible = false
        taskbarBtn.Visible = true
    end)

    -- 恢复
    taskbarBtn.MouseButton1Click:Connect(function()
        playKeyClick()
        mainWindow.Visible = true
        taskbarBtn.Visible = false
    end)

    -- 关闭按钮 - 卸载Hub
    closeBtn.MouseButton1Click:Connect(function()
        -- 断开所有连接
        for _, conn in ipairs(connections) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        connections = {}
        -- 清除XRay连接
        for _, conn in pairs(xrayConnections) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        xrayConnections = {}
        -- 恢复显示隐藏部件
        showpartsfunction(false)
        -- 恢复雾气
        if fogRemoved then RestoreFog() fogRemoved = false end
        -- 恢复夜视
        if data and data.basicdata and data.basicdata.releasetools then
            if data.basicdata.releasetools.nightvision or data.basicdata.releasetools.supernightvision then
                Lighting.Brightness = data.basicdata.releasetools.originalBrightness
                Lighting.ExposureCompensation = data.basicdata.releasetools.originalExposureCompensation
            end
        end
        -- 恢复白天设置
        pcall(setDay)
        -- 停止音乐
        if data and data.basicdata and data.basicdata.otherdata and data.basicdata.otherdata.musicbox then
            pcall(function() data.basicdata.otherdata.musicbox:Stop() end)
        end
        -- 禁用所有模块
        pcall(function() if FlyModule then FlyModule.disable() end end)
        pcall(function() if TeleportModule then TeleportModule.disable() end end)
        pcall(function() if PlayerESP then PlayerESP.disable() end end)
        pcall(function() if data and data.basicdata and data.basicdata.releasetools and data.basicdata.releasetools.npc then data.basicdata.releasetools.npc:disable() end end)
        pcall(function() if PlayerVisibleModule then PlayerVisibleModule.disable() end end)
        pcall(function() if LandingEffect then LandingEffect.disable() end end)
        pcall(function() if FootstepHighlighter then FootstepHighlighter.disable() end end)
        pcall(function() if AirWalk then AirWalk.disable() end end)
        pcall(function() if InstantInteraction then InstantInteraction.disable() end end)
        pcall(function() if MouseUnlockModule then MouseUnlockModule.Disable() end end)
        pcall(function() if LockCameraModule then LockCameraModule.disable() end end)
        pcall(function() if AimBotModule then AimBotModule.Disable() end end)
        pcall(function() if ScrollSwitch then ScrollSwitch:disable() end end)
        pcall(function() if data and data.basicdata and data.basicdata.releasetools and data.basicdata.releasetools.zoom then data.basicdata.releasetools.zoom:Disable() end end)
        pcall(function() if data and data.basicdata and data.basicdata.releasetools and data.basicdata.releasetools.Lantern then data.basicdata.releasetools.Lantern.disable = false end end)
        pcall(function() if data and data.basicdata and data.basicdata.releasetools and data.basicdata.releasetools.SuperLighter then data.basicdata.releasetools.SuperLighter.disable = false end end)
        pcall(function() if FreecamModule then FreecamModule.freecamenable = false end end)
        pcall(function() if movementModule then movementModule.Disable() end end)
        pcall(function() if SpectatorModule then SpectatorModule.close() end end)
        pcall(function() if StandRecovery then StandRecovery:disableDetection() end end)
        pcall(function() if FlingDetector then FlingDetector.disable() end end)
        pcall(function() if AntiVoidModule then AntiVoidModule.disable() end end)
        pcall(function() if AntiKickModule then AntiKickModule.disable() end end)
        pcall(function() if DeleteTool then DeleteTool.disable() end end)
        pcall(function() if GuiDeleter then GuiDeleter.disable() end end)
        pcall(function() if ChatSpy then ChatSpy.disable() end end)
        pcall(function() if LoopOofModule then LoopOofModule.disable() end end)
        pcall(function() if SpinModule then SpinModule.disable() end end)
        pcall(function() if tpWalk then tpWalk:Enabled(false) end end)
        -- 恢复重力
        Workspace.Gravity = 196.2
        -- 销毁GUI
        for _, elem in ipairs(guiElements) do
            if elem and elem.Parent then
                pcall(function() elem:Destroy() end)
            end
        end
        guiElements = {}
        -- 清除全局引用
        _G.KaiHubRetroLoaded = false
        _G.KaiHubRetroLoading = false
        _G.unloadKaiHubRetro = nil
        notify("KaiHub", "Hub已卸载")
    end)

    -- 关闭按钮悬停效果
    closeBtn.MouseEnter:Connect(function()
        closeBtn.BackgroundColor3 = Colors.CloseBtn
        closeBtn.TextColor3 = Color3.new(1, 1, 1)
    end)
    closeBtn.MouseLeave:Connect(function()
        closeBtn.BackgroundColor3 = Colors.BtnFace
        closeBtn.TextColor3 = Color3.new(0, 0, 0)
    end)

    -- 最小化按钮悬停效果
    minBtn.MouseEnter:Connect(function()
        minBtn.BackgroundColor3 = Colors.BtnHighlight
    end)
    minBtn.MouseLeave:Connect(function()
        minBtn.BackgroundColor3 = Colors.BtnFace
    end)

    -- 默认显示第一个标签
    local firstTab = true
    for _, t in pairs(tabs) do
        if firstTab then
            t.content.Visible = true
            t.button.BackgroundColor3 = Colors.SidebarActive
            t.button.TextColor3 = Colors.WinTitleText
            t.indicator.BackgroundTransparency = 0
            firstTab = false
        end
    end

    return {
        screenGui = screenGui,
        mainWindow = mainWindow,
        tabs = tabs,
        statusLabel = statusLabel,
        taskbarBtn = taskbarBtn
    }
end

-- ============================================================
-- 辅助函数（从zhengw.lua搬运）
-- ============================================================

-- 显示/隐藏隐藏部件
local hiddenParts = {}
function showpartsfunction(enable)
    if enable then
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency == 1 and part.Name ~= "Camera" then
                hiddenParts[part] = part.LocalTransparencyModifier
                part.LocalTransparencyModifier = 0.5
            end
        end
    else
        for part, orig in pairs(hiddenParts) do
            if part and part.Parent then
                part.LocalTransparencyModifier = orig
            end
        end
        hiddenParts = {}
    end
end

-- X光效果
local xrayConnections = {}
function xray(enabled)
    if enabled then
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                local conn
                conn = part.Changed:Connect(function(prop)
                    if prop == "Transparency" then
                        part.Transparency = 0.5
                    end
                end)
                table.insert(xrayConnections, conn)
                part.Transparency = 0.5
            end
        end
    else
        for _, conn in pairs(xrayConnections) do
            if conn then conn:Disconnect() end
        end
        xrayConnections = {}
    end
end

-- 格式化用户名
function formatUsername(player)
    if not player then return "未知" end
    return player.DisplayName .. " (@" .. player.Name .. ")"
end

-- 原地重生
function respawn()
    local char = LP.Character
    if char then
        local pos = char:FindFirstChild("HumanoidRootPart")
        if pos then
            LP.Character = nil
            local newChar = LP.CharacterAdded:Wait()
            newChar:WaitForChild("HumanoidRootPart").CFrame = pos.CFrame
        end
    end
end

-- 刷新角色
function refresh()
    local char = LP.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local cf = hrp and hrp.CFrame
        local pos = cf and cf.Position
        LP.Character = nil
        if pos then
            local newChar = LP.CharacterAdded:Wait()
            newChar:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(pos)
        end
    end
end

-- 获取管理员角色
function getStaffRole(player)
    local role = ""
    if player:GetRankInGroup(1200769) > 0 then
        role = "Roblox Staff"
    elseif player:GetRoleInGroup(282) ~= "Guest" then
        role = "Roblox Staff"
    end
    return role
end

-- 随机字符串
function randomString(length)
    length = length or 10
    local str = ""
    for i = 1, length do
        local r = math.random(0, 2)
        if r == 0 then
            str = str .. string.char(math.random(48, 57))
        elseif r == 1 then
            str = str .. string.char(math.random(65, 90))
        else
            str = str .. string.char(math.random(97, 122))
        end
    end
    return str
end

-- 切换Rig类型
function promptNewRig(rig)
    local humanoidDesc = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if humanoidDesc then
        local desc = humanoidDesc:GetAppliedDescription()
        desc.HeightScale = nil
        desc.WidthScale = nil
        desc.DepthScale = nil
        desc.HeadScale = nil
        if rig == "R6" then
            desc.RigType = Enum.HumanoidRigType.R6
        elseif rig == "R15" then
            desc.RigType = Enum.HumanoidRigType.R15
        end
        humanoidDesc:ApplyDescription(desc)
    end
end

-- 去除雾气
function RemoveFog()
    data.basicdata.releasetools.originalFogStart = Lighting.FogStart
    data.basicdata.releasetools.originalFogEnd = Lighting.FogEnd
    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
end

-- 恢复雾气
function RestoreFog()
    if data.basicdata.releasetools.originalFogStart then
        Lighting.FogStart = data.basicdata.releasetools.originalFogStart
    end
    if data.basicdata.releasetools.originalFogEnd then
        Lighting.FogEnd = data.basicdata.releasetools.originalFogEnd
    end
end

-- 重新加入当前游戏
function rejoinCurrentGame()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
end

-- 设置白天
function setDay()
    local ds = data.basicdata.otherdata.daySettings
    Lighting.Ambient = ds.Ambient
    Lighting.Brightness = ds.Brightness
    Lighting.ColorShift_Bottom = ds.ColorShift_Bottom
    Lighting.ColorShift_Top = ds.ColorShift_Top
    Lighting.OutdoorAmbient = ds.OutdoorAmbient
    Lighting.GlobalShadows = ds.GlobalShadows
    Lighting.ClockTime = 14
end

-- 设置黑夜
function setNight()
    local ns = data.basicdata.otherdata.nightSettings
    Lighting.Ambient = ns.Ambient
    Lighting.Brightness = ns.Brightness
    Lighting.ColorShift_Bottom = ns.ColorShift_Bottom
    Lighting.ColorShift_Top = ns.ColorShift_Top
    Lighting.OutdoorAmbient = ns.OutdoorAmbient
    Lighting.GlobalShadows = ns.GlobalShadows
    Lighting.ClockTime = 0
end

-- 获取内存使用量
function getMemoryUsage(unit)
    unit = unit or "MB"
    local mem = collectgarbage("count") -- KB
    if unit == "KB" then
        return string.format("%.1f KB", mem)
    elseif unit == "MB" then
        return string.format("%.2f MB", mem / 1024)
    elseif unit == "GB" then
        return string.format("%.3f GB", mem / 1024 / 1024)
    end
    return string.format("%.1f KB", mem)
end

-- 通知函数
function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "KaiHub",
            Text = text or "",
            Duration = 3
        })
    end)
end

-- ============================================================
-- 创建UI
-- ============================================================
local ui = RetroUI:CreateWindow({
    size = data.basicdata.window.windowSize
})

-- ============================================================
-- 创建所有标签页
-- ============================================================

-- 1. 基础设置
local tabBasic = ui:AddTab("基础设置")

ui:AddSlider(tabBasic.name, "移速", 0, 300, data.basicdata.player.speed, function(val)
    data.basicdata.player.speed = val
    local humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if humanoid and not data.basicdata.player.islockspeed then
        humanoid.WalkSpeed = val
    end
end)

ui:AddToggle(tabBasic.name, "锁定移速", data.basicdata.player.islockspeed, function(val)
    data.basicdata.player.islockspeed = val
end)

ui:AddSlider(tabBasic.name, "跳跃力", 0, 300, data.basicdata.player.jump, function(val)
    data.basicdata.player.jump = val
    local humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if humanoid and not data.basicdata.player.islockjump then
        humanoid.JumpPower = val
    end
end)

ui:AddToggle(tabBasic.name, "锁定跳跃力", data.basicdata.player.islockjump, function(val)
    data.basicdata.player.islockjump = val
end)

ui:AddSlider(tabBasic.name, "最大血量", 0, 1000, data.basicdata.player.maxhealth, function(val)
    data.basicdata.player.maxhealth = val
    local humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if humanoid and not data.basicdata.player.islockmaxhealth then
        humanoid.MaxHealth = val
    end
end)

ui:AddToggle(tabBasic.name, "锁定最大血量", data.basicdata.player.islockmaxhealth, function(val)
    data.basicdata.player.islockmaxhealth = val
end)

ui:AddSlider(tabBasic.name, "当前血量", 0, 1000, data.basicdata.player.health, function(val)
    data.basicdata.player.health = val
    local humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if humanoid and not data.basicdata.player.islockhealth then
        humanoid.Health = val
    end
end)

ui:AddToggle(tabBasic.name, "锁定当前血量", data.basicdata.player.islockhealth, function(val)
    data.basicdata.player.islockhealth = val
end)

ui:AddSlider(tabBasic.name, "重力", 0, 500, data.basicdata.player.gravity, function(val)
    data.basicdata.player.gravity = val
    if not data.basicdata.player.islockgravity then
        Workspace.Gravity = val
    end
end)

ui:AddToggle(tabBasic.name, "锁定重力", data.basicdata.player.islockgravity, function(val)
    data.basicdata.player.islockgravity = val
end)

-- 2. 工具
local tabTools = ui:AddTab("工具")

-- 防挂机
ui:AddToggle(tabTools.name, "防挂机", data.basicdata.releasetools.antiafk, function(val)
    data.basicdata.releasetools.antiafk = val
end)

-- 保留Hub传送后执行
ui:AddToggle(tabTools.name, "保留Hub传送后执行", data.basicdata.releasetools.keepchronixhub, function(val)
    data.basicdata.releasetools.keepchronixhub = val
end)

ui:AddSeparator(tabTools.name)
ui:AddLabel(tabTools.name, "=== 移动工具 ===")

-- 飞行
local flyToggle = ui:AddToggle(tabTools.name, "飞行", false, function(val)
    if FlyModule then
        if val then FlyModule.enable() else FlyModule.disable() end
    end
end)

-- 点击传送
local tpToggle = ui:AddToggle(tabTools.name, "点击传送", false, function(val)
    if TeleportModule then
        if val then TeleportModule.enable() else TeleportModule.disable() end
    end
end)

-- TPWalk
local tpWalkToggle = ui:AddToggle(tabTools.name, "TPWalk", false, function(val)
    if tpWalk then
        if val then tpWalk:Enabled(true) else tpWalk:Enabled(false) end
    end
end)

-- 空中移动
local airWalkToggle = ui:AddToggle(tabTools.name, "空中移动", false, function(val)
    if AirWalk then
        if val then AirWalk.enable() else AirWalk.disable() end
    end
end)

-- 穿墙
ui:AddToggle(tabTools.name, "穿墙", data.basicdata.releasetools.noclip, function(val)
    data.basicdata.releasetools.noclip = val
end)

-- 连跳
ui:AddToggle(tabTools.name, "连跳", data.basicdata.releasetools.infjump, function(val)
    data.basicdata.releasetools.infjump = val
end)

ui:AddSeparator(tabTools.name)
ui:AddLabel(tabTools.name, "=== 视觉工具 ===")

-- 玩家透视
local espToggle = ui:AddToggle(tabTools.name, "玩家透视", false, function(val)
    if PlayerESP then
        if val then PlayerESP.enable() else PlayerESP.disable() end
    end
end)

-- NPC透视
local npcEspToggle = ui:AddToggle(tabTools.name, "NPC透视", false, function(val)
    if data.basicdata.releasetools.npc then
        if val then data.basicdata.releasetools.npc:enable() else data.basicdata.releasetools.npc:disable() end
    end
end)

-- 隐身
local invisToggle = ui:AddToggle(tabTools.name, "隐身", false, function(val)
    if PlayerVisibleModule then
        if val then PlayerVisibleModule.enable() else PlayerVisibleModule.disable() end
    end
end)

-- 落地特效
local landingToggle = ui:AddToggle(tabTools.name, "落地特效", false, function(val)
    if LandingEffect then
        if val then LandingEffect.enable() else LandingEffect.disable() end
    end
end)

-- 落脚点高亮
local footstepToggle = ui:AddToggle(tabTools.name, "查看落脚点", false, function(val)
    if FootstepHighlighter then
        if val then FootstepHighlighter.enable() else FootstepHighlighter.disable() end
    end
end)

-- 夜视
local nightVisionToggle = ui:AddToggle(tabTools.name, "夜视", data.basicdata.releasetools.nightvision, function(val)
    data.basicdata.releasetools.nightvision = val
    if val then
        Lighting.Brightness = 2
        Lighting.ExposureCompensation = 1
    else
        Lighting.Brightness = data.basicdata.releasetools.originalBrightness
        Lighting.ExposureCompensation = data.basicdata.releasetools.originalExposureCompensation
    end
end)

-- 超级夜视
local superNightToggle = ui:AddToggle(tabTools.name, "超级夜视", data.basicdata.releasetools.supernightvision, function(val)
    data.basicdata.releasetools.supernightvision = val
    if val then
        Lighting.Brightness = 10
        Lighting.ExposureCompensation = 5
    else
        Lighting.Brightness = data.basicdata.releasetools.originalBrightness
        Lighting.ExposureCompensation = data.basicdata.releasetools.originalExposureCompensation
    end
end)

-- 随身灯笼
local lanternToggle = ui:AddToggle(tabTools.name, "随身灯笼", false, function(val)
    if data.basicdata.releasetools.Lantern then
        if val then data.basicdata.releasetools.Lantern.enable() else data.basicdata.releasetools.Lantern.disable() end
    end
end)

-- 超级光明
local superLightToggle = ui:AddToggle(tabTools.name, "超级光明", false, function(val)
    if data.basicdata.releasetools.SuperLighter then
        if val then data.basicdata.releasetools.SuperLighter.enable() else data.basicdata.releasetools.SuperLighter.disable() end
    end
end)

-- 雾气去除
local fogRemoved = false
ui:AddButton(tabTools.name, "雾气去除", function()
    if not fogRemoved then
        RemoveFog()
        fogRemoved = true
        notify("KaiHub", "雾气已去除")
    end
end)

ui:AddButton(tabTools.name, "恢复雾气", function()
    if fogRemoved then
        RestoreFog()
        fogRemoved = false
        notify("KaiHub", "雾气已恢复")
    end
end)

-- X光
local xrayEnabled = false
ui:AddToggle(tabTools.name, "X光", false, function(val)
    xrayEnabled = val
    xray(val)
end)

-- 显示隐藏部件
local showPartsEnabled = false
ui:AddToggle(tabTools.name, "显示隐藏部件", false, function(val)
    showPartsEnabled = val
    showpartsfunction(val)
end)

ui:AddSeparator(tabTools.name)
ui:AddLabel(tabTools.name, "=== 镜头工具 ===")

-- 鼠标解锁
local mouseUnlockToggle = ui:AddToggle(tabTools.name, "鼠标解锁", false, function(val)
    if MouseUnlockModule then
        if val then MouseUnlockModule.Enable() else MouseUnlockModule.Disable() end
    end
end)

-- 锁定视角
local lockCamToggle = ui:AddToggle(tabTools.name, "锁定视角", false, function(val)
    if LockCameraModule then
        if val then LockCameraModule.enable() else LockCameraModule.disable() end
    end
end)

-- 自动瞄准
local aimbotToggle = ui:AddToggle(tabTools.name, "自动瞄准", false, function(val)
    if AimBotModule then
        if val then AimBotModule.Enable() else AimBotModule.Disable() end
    end
end)

-- 望远镜
local zoomToggle = ui:AddToggle(tabTools.name, "望远镜", false, function(val)
    if data.basicdata.releasetools.zoom then
        if val then data.basicdata.releasetools.zoom:Enable() else data.basicdata.releasetools.zoom:Disable() end
    end
end)

-- 物品滚轮切换
local scrollToggle = ui:AddToggle(tabTools.name, "物品滚轮切换", false, function(val)
    if ScrollSwitch then
        if val then ScrollSwitch:enable() else ScrollSwitch:disable() end
    end
end)

ui:AddSeparator(tabTools.name)
ui:AddLabel(tabTools.name, "=== 灵魂工具 ===")

-- 灵魂出窍
local freecamToggle = ui:AddToggle(tabTools.name, "灵魂出窍", false, function(val)
    if FreecamModule then
        if val then FreecamModule.freecamenable() else FreecamModule.freecamdisable() end
    end
end)

-- 平移
local movementToggle = ui:AddToggle(tabTools.name, "平移", false, function(val)
    if movementModule then
        if val then movementModule.Enable() else movementModule.Disable() end
    end
end)

-- 旁观模式
local spectatorToggle = ui:AddToggle(tabTools.name, "旁观模式", false, function(val)
    if SpectatorModule then
        if val then SpectatorModule.start() else SpectatorModule.close() end
    end
end)

ui:AddSeparator(tabTools.name)
ui:AddLabel(tabTools.name, "=== 保护工具 ===")

-- 防击倒
ui:AddToggle(tabTools.name, "防击倒", data.basicdata.releasetools.antifall, function(val)
    data.basicdata.releasetools.antifall = val
end)

-- 晕厥康复
local standRecToggle = ui:AddToggle(tabTools.name, "晕厥康复", false, function(val)
    if StandRecovery then
        if val then StandRecovery:enableDetection() else StandRecovery:disableDetection() end
    end
end)

-- 防甩飞
local flingDetToggle = ui:AddToggle(tabTools.name, "防甩飞", false, function(val)
    if FlingDetector then
        if val then FlingDetector.enable() else FlingDetector.disable() end
    end
end)

-- 反物理劫持
local antiVoidToggle = ui:AddToggle(tabTools.name, "反物理劫持", false, function(val)
    if AntiVoidModule then
        if val then AntiVoidModule.enable() else AntiVoidModule.disable() end
    end
end)

-- 防死亡
ui:AddToggle(tabTools.name, "防死亡", data.basicdata.releasetools.antidead, function(val)
    data.basicdata.releasetools.antidead = val
end)

-- 防踢出
local antiKickToggle = ui:AddToggle(tabTools.name, "防踢出", false, function(val)
    if AntiKickModule then
        if val then AntiKickModule.enable() else AntiKickModule.disable() end
    end
end)

ui:AddSeparator(tabTools.name)
ui:AddLabel(tabTools.name, "=== 聊天工具 ===")

-- 强制发言
local chatInput = ui:AddTextBox(tabTools.name, "强制发言内容", function(text)
    data.basicdata.releasetools.chattext = text
end)

ui:AddButton(tabTools.name, "强制发言", function()
    if ChatControl then
        ChatControl:chat(data.basicdata.releasetools.chattext or "")
    end
end)

-- 聊天偷听
local chatSpyToggle = ui:AddToggle(tabTools.name, "聊天偷听", false, function(val)
    if ChatSpy then
        if val then ChatSpy.enable() else ChatSpy.disable() end
    end
end)

-- 聊天重发
ui:AddToggle(tabTools.name, "聊天重发", data.basicdata.releasetools.chatresend, function(val)
    data.basicdata.releasetools.chatresend = val
end)

ui:AddSeparator(tabTools.name)
ui:AddLabel(tabTools.name, "=== 删除工具 ===")

-- 模型删除工具
local deleteToolToggle = ui:AddToggle(tabTools.name, "模型删除工具", false, function(val)
    if DeleteTool then
        if val then DeleteTool.enable() else DeleteTool.disable() end
    end
end)

-- GUI删除工具
local guiDelToggle = ui:AddToggle(tabTools.name, "GUI删除工具", false, function(val)
    if GuiDeleter then
        if val then GuiDeleter.enable() else GuiDeleter.disable() end
    end
end)

ui:AddSeparator(tabTools.name)
ui:AddLabel(tabTools.name, "=== 瞬间交互 ===")

-- 瞬间交互
local instantToggle = ui:AddToggle(tabTools.name, "瞬间交互", false, function(val)
    if InstantInteraction then
        if val then InstantInteraction.enable() else InstantInteraction.disable() end
    end
end)

ui:AddSeparator(tabTools.name)
ui:AddLabel(tabTools.name, "=== 其他工具 ===")

-- 管理员检测
ui:AddToggle(tabTools.name, "管理员检测", data.basicdata.releasetools.staffcheck, function(val)
    data.basicdata.releasetools.staffcheck = val
end)

-- 禁用购买提示框
ui:AddButton(tabTools.name, "禁用购买提示框", function()
    pcall(function()
        game:GetService("CoreGui").PurchasePrompt.Enabled = false
    end)
    notify("KaiHub", "购买提示框已禁用")
end)

-- 禁用游戏暂停
ui:AddToggle(tabTools.name, "禁用游戏暂停", data.basicdata.releasetools.networkpausedisable, function(val)
    data.basicdata.releasetools.networkpausedisable = val
end)

ui:AddSeparator(tabTools.name)
ui:AddLabel(tabTools.name, "=== 角色操作 ===")

-- 坐下
ui:AddButton(tabTools.name, "坐下", function()
    local humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Sit = true
    end
end)

-- 回满血
ui:AddButton(tabTools.name, "回满血", function()
    local humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = humanoid.MaxHealth
    end
    notify("KaiHub", "已回满血")
end)

-- 自杀
ui:AddButton(tabTools.name, "自杀", function()
    local humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = 0
    end
end)

-- 强制重生
ui:AddButton(tabTools.name, "强制重生", function()
    respawn()
    notify("KaiHub", "已强制重生")
end)

-- 原地重生
ui:AddButton(tabTools.name, "原地重生", function()
    refresh()
    notify("KaiHub", "已原地重生")
end)

-- 获得点击传送工具
ui:AddButton(tabTools.name, "获得点击传送工具", function()
    pcall(function()
        local tool = Instance.new("Tool")
        tool.Name = "ClickTeleport"
        tool.RequiresHandle = false
        tool.Parent = LP.Backpack

        tool.Activated:Connect(function()
            local mouse = LP:GetMouse()
            if mouse.Target then
                local rootPart = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
                end
            end
        end)
    end)
    notify("KaiHub", "已获得点击传送工具")
end)

-- 重新加入
ui:AddButton(tabTools.name, "重新加入", function()
    rejoinCurrentGame()
end)

-- 切换R6
ui:AddButton(tabTools.name, "切换R6", function()
    promptNewRig("R6")
    notify("KaiHub", "已切换为R6")
end)

-- 切换R15
ui:AddButton(tabTools.name, "切换R15", function()
    promptNewRig("R15")
    notify("KaiHub", "已切换为R15")
end)

ui:AddSeparator(tabTools.name)
ui:AddLabel(tabTools.name, "=== 环境操作 ===")

-- 切换白天
ui:AddButton(tabTools.name, "切换白天", function()
    setDay()
    notify("KaiHub", "已切换为白天")
end)

-- 切换黑夜
ui:AddButton(tabTools.name, "切换黑夜", function()
    setNight()
    notify("KaiHub", "已切换为黑夜")
end)

-- 优化光效
ui:AddButton(tabTools.name, "优化光效", function()
    Lighting.GlobalShadows = false
    Lighting.ForceQuality = Enum.QualityLevel.Low
    notify("KaiHub", "光效已优化")
end)

-- 打印坐标
ui:AddButton(tabTools.name, "打印坐标", function()
    local rootPart = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local pos = rootPart.Position
        print(string.format("坐标: X=%.2f Y=%.2f Z=%.2f", pos.X, pos.Y, pos.Z))
        notify("KaiHub", string.format("坐标: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z))
    end
end)

-- 开启控制台
ui:AddButton(tabTools.name, "开启控制台", function()
    pcall(function()
        game:GetService("StudioService"):OpenScriptEditor()
    end)
end)

-- 启用所有ROBLOXUI
ui:AddButton(tabTools.name, "启用所有ROBLOXUI", function()
    pcall(function()
        game:GetService("StarterGui"):SetCore("ChatVisible", true)
        game:GetService("StarterGui"):SetCore("ChatWindowSize", Enum.ChatWindowSize.Large)
    end)
    notify("KaiHub", "已启用所有ROBLOXUI")
end)

-- 获取建筑工具
ui:AddButton(tabTools.name, "获取建筑工具", function()
    pcall(function()
        Instance.new("SelectionBox").Parent = Workspace
    end)
    notify("KaiHub", "已获取建筑工具")
end)

-- 终止游戏
ui:AddButton(tabTools.name, "终止游戏", function()
    data.basicdata.releasetools.exitgame = 1
    pcall(function()
        game:Shutdown()
    end)
end)

-- 3. 脚本中心
local tabScripts = ui:AddTab("脚本中心")

for _, scriptInfo in ipairs(data.scriptlist) do
    ui:AddButton(tabScripts.name, scriptInfo.name, function()
        pcall(function()
            local code = game:HttpGet(scriptInfo.link)
            loadstring(code)()
            notify("KaiHub", scriptInfo.name .. " 已加载")
        end)
    end)
end

-- 4. 玩家传送
local tabPlayerTP = ui:AddTab("玩家传送")

local playerTPList = {}
local function refreshPlayerList()
    -- 清除旧按钮
    for _, elem in ipairs(playerTPList) do
        if elem and elem.Parent then elem:Destroy() end
    end
    playerTPList = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            ui:AddButton(tabPlayerTP.name, formatUsername(player), function()
                local rootPart = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                local targetRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if rootPart and targetRoot then
                    rootPart.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
                    notify("KaiHub", "已传送到 " .. player.Name)
                end
            end)
        end
    end
end

refreshPlayerList()

local playerAddedConn
playerAddedConn = Players.PlayerAdded:Connect(function()
    refreshPlayerList()
end)
table.insert(connections, playerAddedConn)

local playerRemovingConn
playerRemovingConn = Players.PlayerRemoving:Connect(function()
    refreshPlayerList()
end)
table.insert(connections, playerRemovingConn)

-- 5. 路径点传送
local tabWaypoints = ui:AddTab("路径点传送")

local waypoints = {}
-- 尝试从ConfigModule加载保存的路径点
if ConfigModule then
    pcall(function()
        local saved = ConfigModule.get("waypoints")
        if saved then
            waypoints = saved
        end
    end)
end

local function saveWaypoints()
    if ConfigModule then
        pcall(function()
            ConfigModule.set("waypoints", waypoints)
        end)
    end
end

local function refreshWaypointList()
    -- 重新构建路径点列表（简化实现）
end

ui:AddButton(tabWaypoints.name, "添加当前路径点", function()
    local rootPart = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local wpName = "路径点" .. tostring(#waypoints + 1)
        table.insert(waypoints, {
            name = wpName,
            position = {X = rootPart.Position.X, Y = rootPart.Position.Y, Z = rootPart.Position.Z}
        })
        saveWaypoints()
        notify("KaiHub", "已添加 " .. wpName)
        refreshWaypointList()
    end
end)

ui:AddButton(tabWaypoints.name, "删除最后一个路径点", function()
    if #waypoints > 0 then
        local removed = table.remove(waypoints)
        saveWaypoints()
        notify("KaiHub", "已删除 " .. (removed.name or "路径点"))
        refreshWaypointList()
    end
end)

-- 显示已保存的路径点
for i, wp in ipairs(waypoints) do
    ui:AddButton(tabWaypoints.name, wp.name .. " (传送)", function()
        local rootPart = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            rootPart.CFrame = CFrame.new(wp.position.X, wp.position.Y, wp.position.Z)
            notify("KaiHub", "已传送到 " .. wp.name)
        end
    end)
end

-- 6. 音乐播放器
local tabMusic = ui:AddTab("音乐播放器")

local musicData = data.basicdata.otherdata.musicData

-- 预设音乐列表
for i, musicId in ipairs(musicData.musicIds) do
    ui:AddButton(tabMusic.name, "音乐 " .. tostring(i) .. " (ID: " .. musicId .. ")", function()
        musicData.currentId = musicId
        data.basicdata.otherdata.musicbox.SoundId = "rbxassetid://" .. musicId
        notify("KaiHub", "已选择音乐 ID: " .. musicId)
    end)
end

-- 自定义音乐ID
local musicIdInput = ui:AddTextBox(tabMusic.name, "自定义音乐ID", function(text)
    musicData.currentId = text
    data.basicdata.otherdata.musicbox.SoundId = "rbxassetid://" .. text
end)

ui:AddSeparator(tabMusic.name)

-- 播放
ui:AddButton(tabMusic.name, "播放", function()
    if musicData.currentId then
        data.basicdata.otherdata.musicbox.SoundId = "rbxassetid://" .. musicData.currentId
        data.basicdata.otherdata.musicbox:Play()
        musicData.isPlay = true
        musicData.isPause = false
        notify("KaiHub", "正在播放")
    end
end)

-- 停止
ui:AddButton(tabMusic.name, "停止", function()
    data.basicdata.otherdata.musicbox:Stop()
    musicData.isPlay = false
    musicData.isPause = false
end)

-- 暂停/继续
ui:AddButton(tabMusic.name, "暂停/继续", function()
    if musicData.isPlay then
        data.basicdata.otherdata.musicbox:Pause()
        musicData.isPause = true
    elseif musicData.isPause then
        data.basicdata.otherdata.musicbox:Resume()
        musicData.isPause = false
    end
end)

-- 循环
ui:AddToggle(tabMusic.name, "循环播放", false, function(val)
    data.basicdata.otherdata.musicbox.Looped = val
end)

-- 音量
ui:AddSlider(tabMusic.name, "音量", 0, 1, 0.5, function(val)
    data.basicdata.otherdata.musicbox.Volume = val
end)

-- 音高
ui:AddSlider(tabMusic.name, "音高", 0.5, 2, 1, function(val)
    data.basicdata.otherdata.musicbox.PlaybackSpeed = val
end)

-- 7. 音频检查器
local tabAudio = ui:AddTab("音频检查器")

ui:AddButton(tabAudio.name, "扫描游戏内声音", function()
    local sounds = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Sound") then
            table.insert(sounds, {
                name = obj.Name,
                parentId = obj.Parent and obj.Parent.Name or "Unknown",
                soundId = obj.SoundId,
                isPlaying = obj.IsPlaying
            })
        end
    end

    notify("KaiHub", "找到 " .. tostring(#sounds) .. " 个声音")
    print("[KaiHub] 扫描结果 - 共 " .. tostring(#sounds) .. " 个声音:")
    for i, s in ipairs(sounds) do
        print(string.format("  [%d] %s (父: %s) ID: %s 播放中: %s",
            i, s.name, s.parentId, s.soundId, tostring(s.isPlaying)))
    end
end)

ui:AddButton(tabAudio.name, "停止所有声音", function()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Sound") then
            obj:Stop()
        end
    end
    notify("KaiHub", "已停止所有声音")
end)

ui:AddButton(tabAudio.name, "播放所有声音", function()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Sound") and not obj.IsPlaying then
            pcall(function() obj:Play() end)
        end
    end
    notify("KaiHub", "已播放所有声音")
end)

-- 8. 恶劣功能
local tabMalicious = ui:AddTab("恶劣功能")

ui:AddLabel(tabMalicious.name, "=== 循环OOF ===")
ui:AddToggle(tabMalicious.name, "循环OOF", false, function(val)
    if LoopOofModule then
        if val then LoopOofModule.enable() else LoopOofModule.disable() end
    end
end)

ui:AddSeparator(tabMalicious.name)
ui:AddLabel(tabMalicious.name, "=== 旋转 ===")

local spinSpeedSlider = ui:AddSlider(tabMalicious.name, "旋转速度", 1, 100, data.basicdata_hankermodule.spin.speed, function(val)
    data.basicdata_hankermodule.spin.speed = val
end)

ui:AddToggle(tabMalicious.name, "旋转", false, function(val)
    if SpinModule then
        if val then SpinModule.enable(data.basicdata_hankermodule.spin.speed) else SpinModule.disable() end
    end
end)

ui:AddSeparator(tabMalicious.name)
ui:AddLabel(tabMalicious.name, "=== 击飞 ===")

-- 击飞目标
local flingTargetInput = ui:AddTextBox(tabMalicious.name, "击飞目标玩家名", function(text)
    data.basicdata_hankermodule.hkill.killname = text
end)

ui:AddButton(tabMalicious.name, "击飞", function()
    if FlingModule then
        FlingModule.fling(data.basicdata_hankermodule.hkill.killname)
    end
end)

ui:AddButton(tabMalicious.name, "飞行击飞", function()
    if FlingModule then
        FlingModule.flyfling(data.basicdata_hankermodule.hkill.killname)
    end
end)

ui:AddButton(tabMalicious.name, "行走击飞", function()
    if FlingModule then
        FlingModule.walkfling(data.basicdata_hankermodule.hkill.killname)
    end
end)

ui:AddButton(tabMalicious.name, "隐形击飞", function()
    if FlingModule then
        FlingModule.invisfling(data.basicdata_hankermodule.hkill.killname)
    end
end)

ui:AddSlider(tabMalicious.name, "击飞范围", 1, 500, data.basicdata_hankermodule.hkill.killrange, function(val)
    data.basicdata_hankermodule.hkill.killrange = val
end)

ui:AddToggle(tabMalicious.name, "击飞所有人", false, function(val)
    data.basicdata_hankermodule.hkill.killall = val
end)

ui:AddToggle(tabMalicious.name, "击飞任意人", false, function(val)
    data.basicdata_hankermodule.hkill.killany = val
end)

ui:AddSeparator(tabMalicious.name)
ui:AddLabel(tabMalicious.name, "=== 击杀 ===")

ui:AddButton(tabMalicious.name, "击杀目标", function()
    if HandleKillModule then
        HandleKillModule.kill(data.basicdata_hankermodule.hkill.killname, data.basicdata_hankermodule.hkill.killrange)
    end
end)

-- 9. 聊天接收器
local tabChatReceiver = ui:AddTab("聊天接收器")

local chatMessages = {}

local function clearChatMessages()
    for _, element in ipairs(chatMessages) do
        if element and element.Parent then
            element:Destroy()
        end
    end
    chatMessages = {}
end

local function addChatMessage(sender, text)
    local msgFrame = Instance.new("Frame")
    msgFrame.Name = "ChatMsg"
    msgFrame.Size = UDim2.new(1, 0, 0, 32)
    msgFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
    msgFrame.BorderSizePixel = 0
    msgFrame.Parent = tabChatReceiver.content
    RetroUI.bevel(msgFrame, "sunken", 1)
    table.insert(chatMessages, msgFrame)

    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(0.7, -8, 1, -4)
    msgLabel.Position = UDim2.new(0, 4, 0, 2)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = sender .. ": " .. text
    msgLabel.TextColor3 = Color3.fromRGB(0, 0, 128)
    msgLabel.TextSize = 10
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextTruncate = Enum.TextTruncate.AtEnd
    msgLabel.Parent = msgFrame

    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0, 40, 0, 18)
    copyBtn.Position = UDim2.new(1, -46, 0.5, -9)
    copyBtn.BackgroundColor3 = Colors.BtnFace
    copyBtn.BorderSizePixel = 0
    copyBtn.Text = "复制"
    copyBtn.TextColor3 = Colors.ContentText
    copyBtn.TextSize = 9
    copyBtn.Font = Enum.Font.Gotham
    copyBtn.AutoButtonColor = false
    copyBtn.Parent = msgFrame
    RetroUI.bevel(copyBtn, "raised", 1)

    copyBtn.MouseButton1Click:Connect(function()
        pcall(function()
            setclipboard(sender .. ": " .. text)
        end)
        notify("KaiHub", "消息已复制到剪贴板")
    end)
end

ui:AddButton(tabChatReceiver.name, "清空所有消息", function()
    clearChatMessages()
    notify("KaiHub", "所有聊天消息已清除")
end)

ui:AddLabel(tabChatReceiver.name, "=== 聊天记录 ===")

-- 绑定聊天消息接收
if ChatControl then
    pcall(function()
        ChatControl:MessageReceiver(function(msgData)
            addChatMessage(msgData.sender, msgData.text)
        end)
    end)
end

-- 10. 执行器
local tabExecutor = ui:AddTab("执行器")

local execInput = ui:AddTextBox(tabExecutor.name, "请输入代码", function(text)
    data.basicdata.releasetools.executecode = text
end)

ui:AddButton(tabExecutor.name, "执行代码", function()
    local code = data.basicdata.releasetools.executecode
    if code and code ~= "" then
        local success, err = pcall(function()
            loadstring(code)()
        end)
        if success then
            notify("KaiHub", "脚本执行成功!")
        else
            notify("KaiHub", "执行失败: " .. tostring(err):sub(1, 50))
        end
    else
        notify("KaiHub", "请输入有效的脚本!")
    end
end)

ui:AddButton(tabExecutor.name, "清除代码", function()
    data.basicdata.releasetools.executecode = ""
    if execInput and execInput.input then
        execInput.input.Text = ""
    end
end)

ui:AddLabel(tabExecutor.name, "提示: 支持 loadstring 远程脚本")

-- 11. 滤镜控制器
local tabFilter = ui:AddTab("滤镜控制器")

local filterElements = {}
local colorBlindModes = {
    {name = "正常", config = {Saturation = 0, Brightness = 0, Contrast = 0, TintColor = Color3.new(1,1,1)}},
    {name = "红色弱", config = {Saturation = -0.3, Brightness = 0.1, Contrast = 0.2, TintColor = Color3.new(1, 0.7, 0.7)}},
    {name = "红色盲", config = {Saturation = -0.5, Brightness = 0.15, Contrast = 0.3, TintColor = Color3.new(1, 0.5, 0.5)}},
    {name = "绿色弱", config = {Saturation = -0.3, Brightness = 0.1, Contrast = 0.2, TintColor = Color3.new(0.7, 1, 0.7)}},
    {name = "绿色盲", config = {Saturation = -0.5, Brightness = 0.15, Contrast = 0.3, TintColor = Color3.new(0.5, 1, 0.5)}},
    {name = "蓝色弱", config = {Saturation = -0.3, Brightness = 0.1, Contrast = 0.2, TintColor = Color3.new(0.7, 0.7, 1)}},
    {name = "蓝色盲", config = {Saturation = -0.5, Brightness = 0.15, Contrast = 0.3, TintColor = Color3.new(0.5, 0.5, 1)}},
    {name = "全色弱", config = {Saturation = -0.8, Brightness = 0.2, Contrast = 0.4, TintColor = Color3.new(0.8, 0.8, 0.8)}},
    {name = "全色盲", config = {Saturation = -1, Brightness = 0.3, Contrast = 0.5, TintColor = Color3.new(0.5, 0.5, 0.5)}},
}

local function getAllPostEffects()
    local effects = {}
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("PostEffect") then
            table.insert(effects, obj)
        end
    end
    local cam = Workspace.CurrentCamera
    if cam then
        for _, obj in ipairs(cam:GetChildren()) do
            if obj:IsA("PostEffect") then
                table.insert(effects, obj)
            end
        end
    end
    return effects
end

local function getColorCorrection()
    for _, effect in ipairs(getAllPostEffects()) do
        if effect:IsA("ColorCorrectionEffect") then
            return effect
        end
    end
    return nil
end

local function applyColorBlindMode(config)
    local cc = getColorCorrection()
    if not cc then
        cc = Instance.new("ColorCorrectionEffect")
        cc.Parent = Lighting
    end
    cc.Saturation = config.Saturation
    cc.Brightness = config.Brightness
    cc.Contrast = config.Contrast
    cc.TintColor = config.TintColor
end

local function refreshFilterList()
    for _, elem in ipairs(filterElements) do
        if elem and elem.Parent then elem:Destroy() end
    end
    filterElements = {}

    ui:AddLabel(tabFilter.name, "=== 后处理特效 ===")

    local effects = getAllPostEffects()
    for _, effect in ipairs(effects) do
        local displayName = effect.Name ~= "" and effect.Name or effect.ClassName
        ui:AddToggle(tabFilter.name, displayName, effect.Enabled, function(val)
            effect.Enabled = val
            notify("KaiHub", displayName .. (val and " 已启用" or " 已禁用"))
        end)
    end

    ui:AddSeparator(tabFilter.name)
    ui:AddLabel(tabFilter.name, "=== 颜色微调 ===")

    local cc = getColorCorrection()
    if cc then
        ui:AddSlider(tabFilter.name, "饱和度", -1, 1, cc.Saturation, function(val)
            cc.Saturation = val
        end)
        ui:AddSlider(tabFilter.name, "亮度", -1, 1, cc.Brightness, function(val)
            cc.Brightness = val
        end)
        ui:AddSlider(tabFilter.name, "对比度", -1, 1, cc.Contrast, function(val)
            cc.Contrast = val
        end)
    else
        ui:AddLabel(tabFilter.name, "未检测到 ColorCorrectionEffect")
    end

    ui:AddSeparator(tabFilter.name)
    ui:AddLabel(tabFilter.name, "=== 色盲模拟器 ===")

    for _, mode in ipairs(colorBlindModes) do
        ui:AddButton(tabFilter.name, "色盲模式: " .. mode.name, function()
            applyColorBlindMode(mode.config)
            notify("KaiHub", "已切换到: " .. mode.name)
        end)
    end

    ui:AddSeparator(tabFilter.name)

    ui:AddButton(tabFilter.name, "重置所有滤镜", function()
        for _, effect in ipairs(getAllPostEffects()) do
            effect.Enabled = true
            if effect:IsA("ColorCorrectionEffect") then
                effect.Saturation = 0
                effect.Brightness = 0
                effect.Contrast = 0
                effect.TintColor = Color3.new(1, 1, 1)
            end
        end
        notify("KaiHub", "所有滤镜已重置")
    end)

    ui:AddButton(tabFilter.name, "刷新滤镜列表", function()
        refreshFilterList()
    end)
end

refreshFilterList()

-- 12. 自定义称号
local tabTitle = ui:AddTab("自定义称号")

local titleData = data.basicdata.otherdata.playertitle

ui:AddToggle(tabTitle.name, "功能开关", false, function(val)
    if titleData.tag then
        if val then
            pcall(function() titleData.tag:enable() end)
        else
            pcall(function() titleData.tag:disable() end)
        end
    end
end)

ui:AddTextBox(tabTitle.name, "称号文本", function(text)
    titleData.text = text
end)

ui:AddSlider(tabTitle.name, "字号", 1, 50, titleData.size or 18, function(val)
    titleData.size = val
end)

ui:AddToggle(tabTitle.name, "加粗", titleData.bold or false, function(val)
    titleData.bold = val
end)

ui:AddToggle(tabTitle.name, "倾斜", titleData.italic or false, function(val)
    titleData.italic = val
end)

ui:AddTextBox(tabTitle.name, "字体", function(text)
    titleData.font = text
end)

ui:AddSeparator(tabTitle.name)

ui:AddButton(tabTitle.name, "应用更改", function()
    if titleData.tag then
        pcall(function()
            titleData.tag:update({
                text = titleData.text,
                color = titleData.color,
                size = titleData.size,
                bold = titleData.bold,
                italic = titleData.italic,
                font = titleData.font
            })
        end)
        notify("KaiHub", "称号已更新: " .. (titleData.text or "[VIP]"))
    else
        notify("KaiHub", "称号模块未加载")
    end
end)

-- 13. 服务器查询
local tabServer = ui:AddTab("服务器查询")

local serverUIElements = {}
local isRefreshing = false

local function clearServerList()
    for _, elem in ipairs(serverUIElements) do
        if elem and elem.Parent then elem:Destroy() end
    end
    serverUIElements = {}
end

local function refreshServerList()
    if isRefreshing then
        notify("KaiHub", "正在刷新中，请稍候...")
        return
    end
    clearServerList()
    isRefreshing = true

    ui:AddLabel(tabServer.name, "正在获取服务器列表...")

    if ServerFinderModule then
        local serverQuery = ServerFinderModule.new()
        pcall(function()
            serverQuery:refreshAsync(function(servers)
                isRefreshing = false
                clearServerList()

                if #servers == 0 then
                    ui:AddLabel(tabServer.name, "没有找到公共服务器")
                    return
                end

                ui:AddLabel(tabServer.name, "找到 " .. tostring(#servers) .. " 个服务器")

                for i, serverData in ipairs(servers) do
                    local ping = serverData.ping or 0
                    local players = serverData.playing or 0
                    local maxPlayers = serverData.maxPlayers or 0
                    local quality = "好"
                    if ping > 250 then quality = "差"
                    elseif ping > 150 then quality = "中"
                    end

                    local serverLabel = ui:AddLabel(tabServer.name,
                        string.format("服务器%d: %d/%d人 | Ping:%dms | 质量:%s",
                            i, players, maxPlayers, ping, quality))

                    ui:AddButton(tabServer.name, "加入服务器 " .. tostring(i), function()
                        pcall(function()
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, serverData.id, LP)
                        end)
                        notify("KaiHub", "正在传送...")
                    end)
                end
            end)
        end)
    else
        isRefreshing = false
        ui:AddLabel(tabServer.name, "ServerFinderModule 未加载")
    end
end

ui:AddButton(tabServer.name, "刷新服务器列表", function()
    refreshServerList()
end)

-- 14. 执行器查询
local tabExecDetect = ui:AddTab("执行器查询")

local executorData = {robloxinfo = nil, exploits = nil}

pcall(function()
    executorData.robloxinfo = HttpService:JSONDecode(game:HttpGet("https://weao.xyz/api/versions/current"))
end)
pcall(function()
    executorData.exploits = HttpService:JSONDecode(game:HttpGet("https://weao.xyz/api/status/exploits"))
end)

ui:AddLabel(tabExecDetect.name, "=== Roblox 版本信息 ===")

if executorData.robloxinfo then
    local rbx = executorData.robloxinfo
    if rbx.version then
        ui:AddLabel(tabExecDetect.name, "版本: " .. tostring(rbx.version))
    end
    if rbx.updatedDate then
        ui:AddLabel(tabExecDetect.name, "更新: " .. tostring(rbx.updatedDate))
    end
else
    ui:AddLabel(tabExecDetect.name, "无法获取 Roblox 版本信息")
end

ui:AddSeparator(tabExecDetect.name)
ui:AddLabel(tabExecDetect.name, "=== 执行器状态 ===")

if executorData.exploits and type(executorData.exploits) == "table" then
    local count = 0
    for _, exec in ipairs(executorData.exploits) do
        if type(exec) == "table" and exec.title then
            count = count + 1
            local status = exec.detected and "已检测" or "未检测"
            local free = exec.free and "免费" or "付费"
            local platform = exec.platform or "未知"
            local version = exec.version or "未知"

            ui:AddLabel(tabExecDetect.name,
                string.format("[%s] %s (%s) | %s | %s",
                    platform, exec.title, version, status, free))

            if exec.website then
                ui:AddButton(tabExecDetect.name, "复制官网: " .. exec.title, function()
                    pcall(function() setclipboard(exec.website) end)
                    notify("KaiHub", "已复制到剪贴板")
                end)
            end
        end
        if count >= 20 then break end
    end
    if count == 0 then
        ui:AddLabel(tabExecDetect.name, "没有获取到执行器数据")
    end
else
    ui:AddLabel(tabExecDetect.name, "无法获取执行器信息")
end

ui:AddButton(tabExecDetect.name, "刷新执行器数据", function()
    pcall(function()
        executorData.robloxinfo = HttpService:JSONDecode(game:HttpGet("https://weao.xyz/api/versions/current"))
    end)
    pcall(function()
        executorData.exploits = HttpService:JSONDecode(game:HttpGet("https://weao.xyz/api/status/exploits"))
    end)
    notify("KaiHub", "执行器数据已刷新（需重新打开此标签页）")
end)

-- 15. 支持的游戏
local tabGames = ui:AddTab("支持的游戏")

for _, gameInfo in ipairs(data.Supported_Games) do
    ui:AddButton(tabGames.name, gameInfo.name .. " (ID: " .. tostring(gameInfo.gameid) .. ")", function()
        if GameTeleport then
            GameTeleport.teleportByGameId(gameInfo.gameid)
            notify("KaiHub", "正在传送至: " .. gameInfo.name)
        end
    end)
end

-- 16. 设置
local tabSettings = ui:AddTab("设置")

ui:AddLabel(tabSettings.name, "=== 飞行设置 ===")
ui:AddSlider(tabSettings.name, "飞行速度", 10, 500, 50, function(val)
    if FlyModule and FlyModule.setflyspeed then
        FlyModule.setflyspeed(val)
    end
end)

ui:AddSeparator(tabSettings.name)
ui:AddLabel(tabSettings.name, "=== TPWalk设置 ===")
ui:AddSlider(tabSettings.name, "TPWalk距离", 1, 100, 10, function(val)
    if tpWalk and tpWalk.SetSpeed then
        tpWalk:SetSpeed(val)
    end
end)

ui:AddSeparator(tabSettings.name)
ui:AddLabel(tabSettings.name, "=== 平移设置 ===")
ui:AddSlider(tabSettings.name, "平移距离", 1, 100, 10, function(val)
    if movementModule and movementModule.SetDistance then
        movementModule.SetDistance(val)
    end
end)

-- 17. 关于
local tabAbout = ui:AddTab("关于")

ui:AddLabel(tabAbout.name, "KaiHub Retro v1.0.0")
ui:AddLabel(tabAbout.name, "WinXP风格 Roblox 脚本Hub")
ui:AddSeparator(tabAbout.name)
ui:AddLabel(tabAbout.name, "启动次数: " .. tostring(launchCount))
ui:AddLabel(tabAbout.name, "玩家: " .. LP.Name)
ui:AddLabel(tabAbout.name, "显示名: " .. LP.DisplayName)
ui:AddLabel(tabAbout.name, "用户ID: " .. tostring(LP.UserId))
ui:AddLabel(tabAbout.name, "游戏ID: " .. tostring(game.GameId))
ui:AddSeparator(tabAbout.name)

-- 延迟和内存信息
local function updatePerformanceInfo()
    local stats = game:GetService("Stats")
    local fps = math.floor(1 / RunService.Heartbeat:Wait())
    -- 这些值在标签创建时设置
end

ui:AddLabel(tabAbout.name, "内存: " .. getMemoryUsage("MB"))

-- 定期更新延迟信息
local perfConn
perfConn = RunService.Heartbeat:Connect(function()
    -- 可以在这里更新延迟标签
end)
table.insert(connections, perfConn)

-- ============================================================
-- 后台连接系统（和原版一样）
-- ============================================================

-- Heartbeat: 属性锁定
local heartbeatConn
heartbeatConn = RunService.Heartbeat:Connect(function()
    local humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        -- 锁定移速
        if data.basicdata.player.islockspeed then
            humanoid.WalkSpeed = data.basicdata.player.speed
        end
        -- 锁定跳跃力
        if data.basicdata.player.islockjump then
            humanoid.JumpPower = data.basicdata.player.jump
        end
        -- 锁定最大血量
        if data.basicdata.player.islockmaxhealth then
            humanoid.MaxHealth = data.basicdata.player.maxhealth
        end
        -- 锁定当前血量
        if data.basicdata.player.islockhealth then
            humanoid.Health = data.basicdata.player.health
        end
    end
    -- 锁定重力
    if data.basicdata.player.islockgravity then
        Workspace.Gravity = data.basicdata.player.gravity
    end
end)
table.insert(connections, heartbeatConn)

-- Idled: 防挂机
local idledConn
idledConn = UserInputService.Idled:Connect(function()
    if data.basicdata.releasetools.antiafk then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)
table.insert(connections, idledConn)

-- Stepped: 穿墙 + 旋转
local steppedConn
steppedConn = RunService.Stepped:Connect(function()
    -- 穿墙
    if data.basicdata.releasetools.noclip then
        local char = LP.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)
table.insert(connections, steppedConn)

-- JumpRequest: 无限跳
local jumpConn
jumpConn = UserInputService.JumpRequest:Connect(function()
    if data.basicdata.releasetools.infjump then
        local humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
table.insert(connections, jumpConn)

-- CharacterAdded: 设置Humanoid监听
local function onCharacterAdded(char)
    -- 等待Humanoid加载
    local humanoid = char:WaitForChild("Humanoid", 10)
    if humanoid then
        -- 防击倒
        if data.basicdata.releasetools.antifall then
            humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
                if humanoid.PlatformStand then
                    humanoid.PlatformStand = false
                end
            end)
        end

        -- 防死亡
        if data.basicdata.releasetools.antidead then
            humanoid.Died:Connect(function()
                respawn()
            end)
        end
    end
end

local charAddedConn
charAddedConn = LP.CharacterAdded:Connect(onCharacterAdded)
table.insert(connections, charAddedConn)

-- 如果角色已存在
if LP.Character then
    onCharacterAdded(LP.Character)
end

-- OnTeleport: 保留Hub传送后重新加载
local teleportConn
teleportConn = game:GetService("TeleportService").OnTeleport:Connect(function(state)
    if data.basicdata.releasetools.keepchronixhub and state == Enum.TeleportState.Failed then
        -- 传送失败时重新加载Hub
        notify("KaiHub", "传送后重新加载Hub...")
    end
end)
table.insert(connections, teleportConn)

-- RobloxGui.ChildAdded: 禁用游戏暂停
local robloxGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")
if robloxGui then
    local pauseConn
    pauseConn = robloxGui.ChildAdded:Connect(function(child)
        if data.basicdata.releasetools.networkpausedisable then
            if child.Name == "PauseDialog" or child.Name == "NetworkLostDialog" then
                child:Destroy()
            end
        end
    end)
    table.insert(connections, pauseConn)
end

-- ============================================================
-- 卸载函数
-- ============================================================
function _G.unloadKaiHubRetro()
    -- 断开所有连接
    for _, conn in ipairs(connections) do
        if conn then
            pcall(function() conn:Disconnect() end)
        end
    end
    connections = {}

    -- 清除XRay连接
    for _, conn in pairs(xrayConnections) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    xrayConnections = {}

    -- 恢复显示隐藏部件
    showpartsfunction(false)

    -- 恢复雾气
    if fogRemoved then
        RestoreFog()
        fogRemoved = false
    end

    -- 恢复夜视
    if data.basicdata.releasetools.nightvision or data.basicdata.releasetools.supernightvision then
        Lighting.Brightness = data.basicdata.releasetools.originalBrightness
        Lighting.ExposureCompensation = data.basicdata.releasetools.originalExposureCompensation
    end

    -- 恢复白天设置
    setDay()

    -- 停止音乐
    data.basicdata.otherdata.musicbox:Stop()

    -- 禁用所有模块
    if FlyModule then pcall(function() FlyModule.disable() end) end
    if TeleportModule then pcall(function() TeleportModule.disable() end) end
    if PlayerESP then pcall(function() PlayerESP.disable() end) end
    if data.basicdata.releasetools.npc then pcall(function() data.basicdata.releasetools.npc:disable() end) end
    if PlayerVisibleModule then pcall(function() PlayerVisibleModule.disable() end) end
    if LandingEffect then pcall(function() LandingEffect.disable() end) end
    if FootstepHighlighter then pcall(function() FootstepHighlighter.disable() end) end
    if AirWalk then pcall(function() AirWalk.disable() end) end
    if InstantInteraction then pcall(function() InstantInteraction.disable() end) end
    if MouseUnlockModule then pcall(function() MouseUnlockModule.Disable() end) end
    if LockCameraModule then pcall(function() LockCameraModule.disable() end) end
    if AimBotModule then pcall(function() AimBotModule.Disable() end) end
    if ScrollSwitch then pcall(function() ScrollSwitch:disable() end) end
    if data.basicdata.releasetools.zoom then pcall(function() data.basicdata.releasetools.zoom:Disable() end) end
    if data.basicdata.releasetools.Lantern then pcall(function() data.basicdata.releasetools.Lantern.disable() end) end
    if data.basicdata.releasetools.SuperLighter then pcall(function() data.basicdata.releasetools.SuperLighter.disable() end) end
    if FreecamModule then pcall(function() FreecamModule.freecamdisable() end) end
    if movementModule then pcall(function() movementModule.Disable() end) end
    if SpectatorModule then pcall(function() SpectatorModule.close() end) end
    if StandRecovery then pcall(function() StandRecovery:disableDetection() end) end
    if FlingDetector then pcall(function() FlingDetector.disable() end) end
    if AntiVoidModule then pcall(function() AntiVoidModule.disable() end) end
    if AntiKickModule then pcall(function() AntiKickModule.disable() end) end
    if DeleteTool then pcall(function() DeleteTool.disable() end) end
    if GuiDeleter then pcall(function() GuiDeleter.disable() end) end
    if ChatSpy then pcall(function() ChatSpy.disable() end) end
    if LoopOofModule then pcall(function() LoopOofModule.disable() end) end
    if SpinModule then pcall(function() SpinModule.disable() end) end
    if tpWalk then pcall(function() tpWalk:Enabled(false) end) end

    -- 恢复重力
    Workspace.Gravity = 196.406

    -- 销毁所有GUI元素
    for _, elem in ipairs(guiElements) do
        if elem and elem.Parent then
            pcall(function() elem:Destroy() end)
        end
    end
    guiElements = {}

    -- 清除全局引用
    _G.KaiHubRetroLoaded = false
    _G.KaiHubRetroLoading = false
    _G.unloadKaiHubRetro = nil

    notify("KaiHub", "Hub已卸载")
end

-- ============================================================
-- 启动通知
-- ============================================================
_G.KaiHubRetroLoaded = true
_G.KaiHubRetroLoading = false

notify("KaiHub Retro", "已成功加载! 版本 1.0.0")
ui.statusLabel.Text = "就绪 | 玩家: " .. LP.Name

print("[KaiHub Retro] 已成功加载!")
print("[KaiHub Retro] 版本: 1.0.0")
print("[KaiHub Retro] 玩家: " .. LP.Name .. " (" .. LP.DisplayName .. ")")
print("[KaiHub Retro] 启动次数: " .. tostring(launchCount))
print("[KaiHub Retro] 已加载模块数: " .. tostring(#loadedModules) .. "/45")
print("[KaiHub Retro] 输入 _G.unloadKaiHubRetro() 卸载")
