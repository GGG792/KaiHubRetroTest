local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local VirtualUser = game:GetService("VirtualUser");
local REMOTES_FOLDER = ReplicatedStorage:WaitForChild("Remotes");
local ADD_SPINS_EVENT = REMOTES_FOLDER:WaitForChild("AddWheelSpinValue");
local CLAIM_REWARD_EVENT = REMOTES_FOLDER:WaitForChild("ClaimReward");
local REBIRTH_EVENT = REMOTES_FOLDER:WaitForChild("Rebirth");
local FIREBALL_MAP = {["迷雾火球"]="Fog",["闪光火球"]="Lighting",["火焰火球"]="Fire",["冰霜火球"]="Ice",["雷电火球"]="Thunder",["恶魔火球"]="Devil",["龙卷火球"]="Tornado",["以太火球"]="Ethereal",["霜火火球"]="Frostfire",["银河火球"]="Galaxy",["流星火球"]="Meteor",["星云火球"]="Nebula",["幻影火球"]="Phantom",["水球"]="Water",["沙漠火球"]="Desert",["月球火球"]="Lunar",["普通火球"]="Red",["毒液火球"]="Venom",["水晶火球"]="Crystal",["剧毒火球"]="Poison",["像素火球"]="Pixel",["暗黑火球"]="Dark",["等离子火球"]="Plasma",["台风火球"]="Hurricane",["太阳火球"]="Sun",["海洋火球"]="Oceanic",["地狱火球"]="Hellfire",["漩涡火球"]="Vortex",["辐射火球"]="Toxic",["暗物质火球"]="Dark Matter",["诅咒火球"]="Cursed",["血液火球"]="Blood",["神圣火球"]="Holy"};
local FIREBALL_REVERSE_MAP = {};
for displayName, toolName in pairs(FIREBALL_MAP) do
	FIREBALL_REVERSE_MAP[toolName] = displayName;
end
local FIREBALL_DISPLAY_NAMES = {};
for name, _ in pairs(FIREBALL_MAP) do
	table.insert(FIREBALL_DISPLAY_NAMES, name);
end
table.sort(FIREBALL_DISPLAY_NAMES);
local TRAINING_ITEMS = {["普通训练"]="Train",["宇宙之剑"]="Cosmic Sword"};
local SAFE_WORLDS = {"Alien World","Sky World","Space World","Starter World","Under World"};
local selectedFireball = "迷雾火球";
local selectedTrainingItem = "普通训练";
local isAutoTrain, isAutoFireball, isSpeedBoost, isAutoRebirth, isAntiAFK, isLoopPower, isGodMode = false, false, false, false, false, false, false;
local detectionSuccess, isFireballHeld = false, false;
local detectLockEndTime = 0;
local trainConn, fireballConn, speedConn, detectConn, rebirthConn, antiAFKConn, equipTrainConn, loopPowerConn, godModeConn;
local function getCharacter()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
end
local function getHumanoid()
	local char = getCharacter();
	return char and char:FindFirstChildOfClass("Humanoid");
end
local function getRootPart()
	local char = getCharacter();
	return char and char:FindFirstChild("HumanoidRootPart");
end
local function equipTool(toolName)
	local backpack = LocalPlayer:FindFirstChild("Backpack");
	local char = getCharacter();
	if (not backpack or not char) then
		return false;
	end
	local tool = backpack:FindFirstChild(toolName);
	if tool then
		getHumanoid():EquipTool(tool);
		return true;
	end
	return char:FindFirstChild(toolName) ~= nil;
end
local function shootFireball()
	if not detectionSuccess then
		return;
	end
	local toolName = FIREBALL_MAP[selectedFireball];
	if not isFireballHeld then
		equipTool(toolName);
		isFireballHeld = true;
	end
	local tool = getCharacter():FindFirstChild(toolName);
	if (tool and tool:FindFirstChild("Event")) then
		for i = 0, 71 do
			local angle = math.rad(i * 5);
			local pos = Vector3.new(-1349 + (300 * math.cos(angle)), 1702, -199 + (300 * math.sin(angle)));
			tool.Event:FireServer(pos);
		end
	end
end
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Yisan886/Aero/refs/heads/main/ui.lua.txt"))();
WindUI:AddTheme({Name="My Theme",Accent=Color3.fromHex("#18181b"),Background=Color3.fromHex("#101010"),Outline=Color3.fromHex("#FFFFFF"),Text=Color3.fromHex("#FFFFFF"),Placeholder=Color3.fromHex("#7a7a7a"),Button=Color3.fromHex("#52525b"),Icon=Color3.fromHex("#a1a1aa")});
local Window = WindUI:CreateWindow({Title="Aero      ",Folder="Aero",SideBarWidth=180,Background="https://chaton-images.s3.us-east-2.amazonaws.com/GHn9L9UJLf0XcVNyCpbG72D0rmNmBEWndPkh6CjJNya8GLnWzz1vImvt8wlJSBwv_2700x1519x1393696.jpeg",BackgroundImageTransparency=0.5,OpenButton={Title="打开脚本",CornerRadius=UDim.new(1, 0),StrokeThickness=3,Enabled=true,Draggable=true,OnlyMobile=false,Scale=0.9,Color=ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f"))},Topbar={Height=44,ButtonsType="Mac"}});
Window:Tag({Title="V1.03",Color=Color3.fromHex("00CED1"),Radius=2});
Window:Tag({Title="杨志卡",Icon="crown",Color=Color3.fromHex("FFD700"),Radius=2});
Window:Tag({Title="杨志卡",Icon="square-chevron-right",Color=Color3.fromHex("#30ff6a"),Radius=2});
local COLOR_SCHEMES = {["彩虹颜色"]={ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),ColorSequenceKeypoint.new(0.16, Color3.fromHex("FFA500")),ColorSequenceKeypoint.new(0.33, Color3.fromHex("FFFF00")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("00FF00")),ColorSequenceKeypoint.new(0.66, Color3.fromHex("0000FF")),ColorSequenceKeypoint.new(0.83, Color3.fromHex("4B0082")),ColorSequenceKeypoint.new(1, Color3.fromHex("EE82EE"))}),"palette"},["绿黄渐变"]={ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("30FF6A")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("a8ff00")),ColorSequenceKeypoint.new(1, Color3.fromHex("e7ff2f"))}),"waves"}};
local borderAnimation;
local animationSpeed = 5;
local function createRainbowBorder(window, colorScheme)
	local mainFrame = window.UIElements.Main;
	if not mainFrame then
		return nil;
	end
	local existingStroke = mainFrame:FindFirstChild("RainbowStroke");
	if existingStroke then
		existingStroke:Destroy();
	end
	if not mainFrame:FindFirstChildOfClass("UICorner") then
		local corner = Instance.new("UICorner");
		corner.CornerRadius = UDim.new(0, 16);
		corner.Parent = mainFrame;
	end
	local rainbowStroke = Instance.new("UIStroke");
	rainbowStroke.Name = "RainbowStroke";
	rainbowStroke.Thickness = 2;
	rainbowStroke.Color = Color3.new(1, 1, 1);
	rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
	rainbowStroke.LineJoinMode = Enum.LineJoinMode.Round;
	rainbowStroke.Parent = mainFrame;
	local glowEffect = Instance.new("UIGradient");
	glowEffect.Name = "GlowEffect";
	local schemeData = COLOR_SCHEMES[colorScheme or "彩虹颜色"];
	glowEffect.Color = (schemeData and schemeData[1]) or COLOR_SCHEMES["彩虹颜色"][1];
	glowEffect.Rotation = 0;
	glowEffect.Parent = rainbowStroke;
	return rainbowStroke;
end
local function startBorderAnimation(window, speed)
	local mainFrame = window.UIElements.Main;
	if not mainFrame then
		return nil;
	end
	local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke");
	if not rainbowStroke then
		return nil;
	end
	local glowEffect = rainbowStroke:FindFirstChild("GlowEffect");
	if not glowEffect then
		return nil;
	end
	return game:GetService("RunService").Heartbeat:Connect(function()
		if (not rainbowStroke or (rainbowStroke.Parent == nil)) then
			return;
		end
		glowEffect.Rotation = (tick() * speed * 10) % 360;
	end);
end
local rainbowStroke = createRainbowBorder(Window, "彩虹颜色");
if rainbowStroke then
	borderAnimation = startBorderAnimation(Window, animationSpeed);
end
local Lighting = game:GetService("Lighting");
local TweenServiceBlur = game:GetService("TweenService");
local blur = Lighting:FindFirstChildOfClass("BlurEffect");
if not blur then
	blur = Instance.new("BlurEffect");
	blur.Size = 0;
	blur.Parent = Lighting;
end
task.spawn(function()
	local wasOpen = false;
	while true do
		task.wait(0.1);
		local mainFrame = Window.UIElements and Window.UIElements.Main;
		local isOpen = (mainFrame and mainFrame.Visible) or false;
		if (isOpen ~= wasOpen) then
			wasOpen = isOpen;
			TweenServiceBlur:Create(blur, TweenInfo.new(0.3), {Size=((isOpen and 20) or 0)}):Play();
		end
	end
end);
local TrainTab = Window:Tab({Title="功能",Icon="zap"});
local TeleportTab = Window:Tab({Title="传送",Icon="map-pin"});
local AdvancedTab = Window:Tab({Title="杂项",Icon="settings"});
Window:SelectTab(1);
TrainTab:Section({Title="训练设置"});
TrainTab:Dropdown({Title="训练物品",Values={"普通训练","宇宙之剑"},Callback=function(v)
	selectedTrainingItem = v;
end});
TrainTab:Toggle({Title="自动点击训练",Callback=function(state)
	isAutoTrain = state;
	if trainConn then
		trainConn:Disconnect();
	end
	if state then
		trainConn = RunService.Heartbeat:Connect(function()
			local tName = TRAINING_ITEMS[selectedTrainingItem];
			if equipTool(tName) then
				local tool = getCharacter():FindFirstChild(tName);
				if (tool and tool:FindFirstChild("Event")) then
					tool.Event:FireServer();
				end
			end
			task.wait(0.1);
		end);
	end
end});
TrainTab:Section({Title="火球设置"});
TrainTab:Dropdown({Title="选择火球类型",Values=FIREBALL_DISPLAY_NAMES,Callback=function(v)
	selectedFireball = v;
end});
TrainTab:Toggle({Title="自动发射火球",Callback=function(state)
	isAutoFireball = state;
	if fireballConn then
		fireballConn:Disconnect();
	end
	if state then
		detectionSuccess = true;
		fireballConn = RunService.Heartbeat:Connect(function()
			shootFireball();
			task.wait(0.2);
		end);
	end
end});
TeleportTab:Section({Title="区域传送"});
local locs = {{"VIP区域",Vector3.new(-1610, 1692, -544)},{"1.5倍区域",Vector3.new(-1433, 1696, -683)},{"2.5倍区域",Vector3.new(-1588, 1700, -667)},{"5倍区域",Vector3.new(-1229, 1685, -689)},{"10倍区域",Vector3.new(-1207, 1704, -257)}};
for _, l in pairs(locs) do
	TeleportTab:Button({Title=l[1],Callback=function()
		getRootPart().CFrame = CFrame.new(l[2]);
	end});
end
AdvancedTab:Section({Title="其他"});
AdvancedTab:Toggle({Title="刷力量",Callback=function(state)
	isLoopPower = state;
	if loopPowerConn then
		loopPowerConn:Disconnect();
	end
	if state then
		loopPowerConn = RunService.Heartbeat:Connect(function()
			ADD_SPINS_EVENT:FireServer("Power", 99999999999);
			task.wait(0.1);
		end);
	end
end});
AdvancedTab:Button({Title="获取99次旋转",Callback=function()
	ADD_SPINS_EVENT:FireServer("Spins", 99);
end});
AdvancedTab:Section({Title="特殊功能"});
AdvancedTab:Toggle({Title="无敌模式",Callback=function(state)
	isGodMode = state;
	if godModeConn then
		godModeConn:Disconnect();
	end
	if state then
		godModeConn = RunService.Heartbeat:Connect(function()
			pcall(function()
				local hrp = getRootPart();
				local safe = workspace.IgnoreParts.SafeZones["Starter World"].Safe;
				safe.CFrame = hrp.CFrame;
			end);
		end);
	end
end});
AdvancedTab:Toggle({Title="人物加速",Callback=function(state)
	isSpeedBoost = state;
	if speedConn then
		speedConn:Disconnect();
	end
	if state then
		speedConn = RunService.Heartbeat:Connect(function()
			local hum = getHumanoid();
			if hum then
				hum.WalkSpeed = 80;
				hum.JumpPower = 150;
			end
		end);
	else
		local hum = getHumanoid();
		if hum then
			hum.WalkSpeed = 16;
			hum.JumpPower = 50;
		end
	end
end});
AdvancedTab:Toggle({Title="反挂机",Callback=function(state)
	isAntiAFK = state;
	if state then
		LocalPlayer.Idled:Connect(function()
			VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame);
			task.wait(1);
			VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame);
		end);
	end
end});
Window:OnClose(function()
	if trainConn then
		trainConn:Disconnect();
	end
	if fireballConn then
		fireballConn:Disconnect();
	end
	if speedConn then
		speedConn:Disconnect();
	end
	if loopPowerConn then
		loopPowerConn:Disconnect();
	end
	if godModeConn then
		godModeConn:Disconnect();
	end
end);
