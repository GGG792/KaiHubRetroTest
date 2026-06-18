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
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Debris = game:GetService("Debris");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local Event = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Actions"):WaitForChild("Fire");
local ActiveZombies = Workspace:WaitForChild("ActiveZombies");
local AwaitingBosses = Workspace:WaitForChild("AwaitingBosses");
local AutoKillEnabled = false;
local TRACER_COLOR = Color3.fromRGB(255, 255, 255);
local TRACER_THICKNESS = 0.05;
local TRACER_DURATION = 0.1;
local function CreateTracer(startPos, endPos)
	local distance = (endPos - startPos).Magnitude;
	if (distance > 2000) then
		distance = 2000;
	end
	local tracer = Instance.new("Part");
	tracer.Material = Enum.Material.Neon;
	tracer.Color = TRACER_COLOR;
	tracer.Transparency = 0.2;
	tracer.Anchored = true;
	tracer.CanCollide = false;
	tracer.CanQuery = false;
	tracer.Size = Vector3.new(TRACER_THICKNESS, TRACER_THICKNESS, distance);
	tracer.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -distance / 2);
	tracer.Parent = Workspace.CurrentCamera;
	Debris:AddItem(tracer, TRACER_DURATION);
end
local function GetTarget()
	local bossFolder = AwaitingBosses:FindFirstChild("Boss");
	if bossFolder then
		local bossModel = bossFolder:FindFirstChildWhichIsA("Model") or bossFolder:FindFirstChildWhichIsA("BasePart");
		if bossModel then
			local hitbox = bossModel:FindFirstChild("Head") or bossModel:FindFirstChild("HumanoidRootPart") or (bossModel:IsA("BasePart") and bossModel);
			if hitbox then
				return hitbox;
			end
		end
	end
	local zombies = ActiveZombies:GetChildren();
	if (#zombies > 0) then
		for _, zombie in ipairs(zombies) do
			local hitbox = zombie:FindFirstChild("Head") or zombie:FindFirstChild("HumanoidRootPart");
			if hitbox then
				return hitbox;
			end
		end
	end
	return nil;
end
local MainTab = Window:Tab({Title="战斗功能",Icon="swords"});
Window:SelectTab(1);
MainTab:Toggle({Title="自动秒杀",Value=false,Callback=function(state)
	AutoKillEnabled = state;
end});
task.spawn(function()
	while true do
		if AutoKillEnabled then
			local Character = LocalPlayer.Character;
			if Character then
				local currentTool = Character:FindFirstChildWhichIsA("Tool");
				if (currentTool and currentTool:FindFirstChild("Exit")) then
					local weaponName = currentTool.Name;
					local muzzle = currentTool.Exit;
					local targetPart = GetTarget();
					if targetPart then
						local originPos = muzzle.Position;
						local targetPos = targetPart.Position;
						local direction = (targetPos - originPos).Unit;
						CreateTracer(originPos, targetPos);
						Event:FireServer(weaponName, {{targetPart,targetPos,direction}}, {{weaponName,originPos,targetPos,targetPos,true,targetPart,false,false,"Default",muzzle}});
					end
				end
			end
		end
		task.wait(0.1);
	end
end);
