repeat
	task.wait();
until game:IsLoaded() 
repeat
	task.wait();
until game:GetService("Players").LocalPlayer 
local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local Lighting = game:GetService("Lighting");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local FightClick = PlayerGui.FightUI.PrisonFight.BG.TapButton;
local u13 = require(Workspace.Src.WorkoutHandler);
local u7 = require(Workspace.Src.Modules.COOPFightHandler);
local u4 = LocalPlayer;
getgenv().AT_Config = getgenv().AT_Config or {TransparencyEnabled=false};
if (getgenv().TransparencyEnabled == nil) then
	getgenv().TransparencyEnabled = getgenv().AT_Config.TransparencyEnabled;
end
local Utils = {};
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
local Settings = {Clicking={Fight=true,Workout=true},InfiniteStamina=true};
local FarmTab = Window:Tab({Title="挂机",Icon="mouse-pointer-click"});
Window:SelectTab(1);
FarmTab:Section({Title="点击",Icon="mouse-pointer-click"});
FarmTab:Toggle({Title="自动战斗",Default=true,Callback=function(Value)
	Settings.Clicking.Fight = Value;
end});
FarmTab:Toggle({Title="自动锻炼",Default=true,Callback=function(Value)
	Settings.Clicking.Workout = Value;
end});
local MiscTab = Window:Tab({Title="玩家",Icon="settings"});
MiscTab:Section({Title="无限体力",Icon="battery-full"});
local function applyReachedZeroStaminaHook()
	pcall(function()
		hookfunction(u13.ReachedZeroStamina, function(...)
			return nil;
		end);
	end);
end
MiscTab:Toggle({Title="无限体力",Default=true,Callback=function(Value)
	Settings.InfiniteStamina = Value;
	if Value then
		applyReachedZeroStaminaHook();
	end
end});
if Settings.InfiniteStamina then
	applyReachedZeroStaminaHook();
end
task.spawn(function()
	while task.wait(0.1) do
		if Settings.Clicking.Workout then
			if u13.IsWorkingOut(u4) then
				u13.UseStamina(u4);
			end
		end
		if Settings.Clicking.Fight then
			if (FightClick and FightClick.Visible) then
				u7.PlayerClicked(u4);
			end
		end
		if Settings.InfiniteStamina then
			local max = u13.getMaxStamina(u4);
			u13.GetPlayerStamina = function()
				return max;
			end;
		end
	end
end);
task.spawn(function()
	local function disableEffect(v)
		if (v:IsA("ColorCorrectionEffect") or v:IsA("DepthOfFieldEffect")) then
			task.wait();
			v.Enabled = false;
		end
	end
	for _, v in ipairs(Lighting:GetChildren()) do
		disableEffect(v);
	end
	Lighting.ChildAdded:Connect(disableEffect);
end);
