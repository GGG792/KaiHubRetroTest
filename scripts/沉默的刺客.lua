local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Event = ReplicatedStorage:WaitForChild("Events"):WaitForChild("GameRemoteFunction");
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
local CombatTab = Window:Tab({Title="功能",Icon="swords"});
Window:SelectTab(1);
local KillAllEnabled = false;
CombatTab:Toggle({Title="全图杀戮",Desc="开启后自动攻击服务器内所有玩家",Value=false,Callback=function(state)
	KillAllEnabled = state;
	if KillAllEnabled then
		task.spawn(function()
			while KillAllEnabled do
				pcall(function()
					local char = LocalPlayer.Character;
					if not char then
						return;
					end
					local tool = char:FindFirstChildOfClass("Tool");
					if not tool then
						local backpackTool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool");
						if backpackTool then
							backpackTool.Parent = char;
							tool = backpackTool;
							task.wait(0.1);
						end
					end
					if not tool then
						return;
					end
					local hitList = {};
					for _, p in pairs(Players:GetPlayers()) do
						if ((p ~= LocalPlayer) and p.Character and p.Character:FindFirstChild("HumanoidRootPart")) then
							local hum = p.Character:FindFirstChildOfClass("Humanoid");
							if (hum and (hum.Health > 0)) then
								table.insert(hitList, {knockback=50,isClosestEnemy=true,origin=p.Character.HumanoidRootPart.Position,enemyModel=p.Character,distance=1,direction=Vector3.new(0, 1, 0)});
							end
						end
					end
					if (#hitList > 0) then
						Event:InvokeServer("AttemptWeaponHit", {attackCycleData={knockbackMul=1,slowMult=0.2,attackTime=0.65,lungeMul=1,slowTime=1.5},knockback=50,shouldLock=true,shouldLunge=true,hitboxOffset=Vector3.new(0, 0, 0),isCritical=true,shouldSlow=true,attackCooldown=0,damage=100,lungeKnockback=55,cycleIndex=1,slowMult=0.2,hitboxSize=Vector3.new(50, 50, 50),weaponDefinition={attackCycle={["1"]={knockbackMul=1,slowMult=0.2,attackTime=0.65,lungeMul=1,slowTime=1.5},["2"]={lungeMult=1,slowMult=0.2,attackTime=0.65,knockbackMul=1,slowTime=1.5},["3"]={lungeMult=0.75,slowMult=0.2,attackTime=0.71666666666667,knockbackMul=1.5,slowTime=1.5},["4"]={lungeMult=2.25,attackTime=0.98333333333333,slowMult=0.2,hitboxOffsetAdd=Vector3.new(0, 0, -1.5),hitboxSizeAdd=Vector3.new(0, 0, 3),knockbackMul=2.25,slowTime=1.5}},attackOrder={"1","2","3","4"}},tool=tool,slowTime=1.5}, hitList);
					end
				end);
				task.wait(0.2);
			end
		end);
	end
end});
CombatTab:Slider({Title="杀戮速度",Desc="数值越小攻击越快",Step=0.1,Value={Min=0.1,Max=2,Default=0.2},Callback=function(value)
end});
Window:SelectTab(CombatTab);
