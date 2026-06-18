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
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local RunService = game:GetService("RunService");
local FLOWER_CONFIG = {TeleportHeight=2.5,MaxWaitTime=0.6,LoopInterval=0.3};
local AutoFlowerEnabled = false;
local function getRoot()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
	return char:WaitForChild("HumanoidRootPart", 5);
end
local function findMyPrompt(flower)
	local stem = flower:FindFirstChild("Stem");
	local prompt = nil;
	if stem then
		local attachment = stem:FindFirstChild("Attachment");
		if attachment then
			prompt = attachment:FindFirstChildOfClass("ProximityPrompt");
		end
	end
	if not prompt then
		prompt = flower:FindFirstChildWhichIsA("ProximityPrompt", true);
	end
	return prompt;
end
local function fastCollect()
	local root = getRoot();
	if not root then
		return;
	end
	local modelsFolder = workspace:FindFirstChild("Map") and workspace.Map.Flowers:FindFirstChild("Models");
	if not modelsFolder then
		return;
	end
	local flowers = modelsFolder:GetChildren();
	table.sort(flowers, function(a, b)
		local pA = a:FindFirstChild("Stem") or a.PrimaryPart or a:FindFirstChildWhichIsA("BasePart");
		local pB = b:FindFirstChild("Stem") or b.PrimaryPart or b:FindFirstChildWhichIsA("BasePart");
		if (pA and pB) then
			return (pA.Position - root.Position).Magnitude < (pB.Position - root.Position).Magnitude;
		end
		return false;
	end);
	for _, flower in ipairs(flowers) do
		if not AutoFlowerEnabled then
			break;
		end
		local prompt = findMyPrompt(flower);
		if (prompt and prompt.Enabled and prompt.Parent) then
			local targetPart = (prompt.Parent:IsA("BasePart") and prompt.Parent) or flower:FindFirstChild("Stem") or flower.PrimaryPart;
			if targetPart then
				root.CFrame = targetPart.CFrame + Vector3.new(0, FLOWER_CONFIG.TeleportHeight, 0);
				root.Velocity = Vector3.new(0, 0, 0);
				prompt.HoldDuration = 0;
				prompt.MaxActivationDistance = 20;
				task.wait(0.05);
				fireproximityprompt(prompt);
				local startTime = tick();
				while prompt.Parent and prompt.Enabled and ((tick() - startTime) < FLOWER_CONFIG.MaxWaitTime) do
					if not AutoFlowerEnabled then
						break;
					end
					if ((tick() - startTime) > 0.2) then
						fireproximityprompt(prompt);
					end
					RunService.Heartbeat:Wait();
				end
			end
		end
	end
end
task.spawn(function()
	while true do
		if AutoFlowerEnabled then
			pcall(fastCollect);
		end
		task.wait(FLOWER_CONFIG.LoopInterval);
	end
end);
local HitboxSection = CombatTab:Section({Title="采集花朵"});
HitboxSection:Toggle({Title="自动采花",Default=false,Callback=function(state)
	AutoFlowerEnabled = state;
	if state then
		print("自动采花已开启");
	else
		print("自动采花已关闭");
	end
end});
local lp = game:GetService("Players").LocalPlayer;
local ws = game:GetService("Workspace");
local vu = game:GetService("VirtualUser");
getgenv().settings = {auto_farm=false,farm_treasures=true,anti_afk=true};
if getgenv().settings.anti_afk then
	for i, v in pairs(getconnections(lp.Idled)) do
		v:Disable();
	end
	lp.Idled:Connect(function()
		vu:Button2Down(Vector2.new(0, 0), ws.CurrentCamera.CFrame);
		task.wait(1);
		vu:Button2Up(Vector2.new(0, 0), ws.CurrentCamera.CFrame);
	end);
end
local function getHRP()
	local char = lp.Character or lp.CharacterAdded:Wait();
	return char:WaitForChild("HumanoidRootPart", 5);
end
local function safeTP(cf)
	local hrp = getHRP();
	if hrp then
		hrp.CFrame = cf;
		hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
		hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
	end
end
task.spawn(function()
	while task.wait(0.5) do
		if getgenv().settings.auto_farm then
			pcall(function()
				local map = ws:FindFirstChild("Map");
				local treasures = map and map:FindFirstChild("Treasures");
				local obby_land = map and map:FindFirstChild("ObbyLand");
				if not obby_land then
					return;
				end
				local tele = obby_land:FindFirstChild("Teleporters");
				local finish = obby_land:FindFirstChild("Finish");
				if (not tele or not tele:FindFirstChild("11")) then
					safeTP(obby_land.Model:GetPivot());
					task.wait(2);
					return;
				end
				local t11 = tele["11"];
				local f11 = finish["11"];
				safeTP(t11.CFrame);
				task.wait(0.3);
				fireproximityprompt(t11:FindFirstChildOfClass("ProximityPrompt"));
				task.wait(4.8);
				safeTP(f11.CFrame);
				task.wait(0.3);
				fireproximityprompt(f11:FindFirstChildOfClass("ProximityPrompt"));
				if (getgenv().settings.farm_treasures and treasures and (#treasures:GetChildren() > 0)) then
					for _, v in pairs(treasures:GetChildren()) do
						if not getgenv().settings.auto_farm then
							break;
						end
						local prompt = v:FindFirstChildWhichIsA("ProximityPrompt");
						if (v:IsA("BasePart") and prompt) then
							safeTP(v.CFrame * CFrame.new(0, 12, 0));
							task.wait(0.2);
							fireproximityprompt(prompt);
							task.wait(0.2);
						end
					end
				end
			end);
		end
	end
end);
local HitboxSection = CombatTab:Section({Title="捡宝藏和自动完成obby"});
HitboxSection:Toggle({Title="自动刷钱",Callback=function(state)
	getgenv().settings.auto_farm = state;
end});
HitboxSection:Toggle({Title="同时收集宝藏",Default=true,Callback=function(state)
	getgenv().settings.farm_treasures = state;
end});
