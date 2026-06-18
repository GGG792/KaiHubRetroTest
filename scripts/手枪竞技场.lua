local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local Lighting = game:GetService("Lighting");
local TweenService = game:GetService("TweenService");
local LocalPlayer = Players.LocalPlayer;
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
local KillTab = Window:Tab({Title="战斗",Icon="sword"});
do
	local Camera = Workspace.CurrentCamera;
	local connection = nil;
	local HitLogEnabled = false;
	local cooldown = 1.5;
	local last_attack = 0;
	local function playShootSound()
		local sound = Instance.new("Sound");
		sound.SoundId = "rbxassetid://6534948092";
		sound.Volume = 1;
		sound.Parent = Camera;
		sound.PlayOnRemove = true;
		sound:Destroy();
	end
	local function createBeam(startPos, endPos)
		local part1 = Instance.new("Part");
		part1.Anchored = true;
		part1.CanCollide = false;
		part1.Transparency = 1;
		part1.Size = Vector3.new(0.1, 0.1, 0.1);
		part1.Position = startPos;
		part1.Parent = Workspace;
		local part2 = Instance.new("Part");
		part2.Anchored = true;
		part2.CanCollide = false;
		part2.Transparency = 1;
		part2.Size = Vector3.new(0.1, 0.1, 0.1);
		part2.Position = endPos;
		part2.Parent = Workspace;
		local attachment1 = Instance.new("Attachment", part1);
		local attachment2 = Instance.new("Attachment", part2);
		local beam1 = Instance.new("Beam", part1);
		beam1.Attachment0 = attachment1;
		beam1.Attachment1 = attachment2;
		beam1.Width0 = 0.25;
		beam1.Width1 = 0.25;
		beam1.Texture = "rbxassetid://7136858729";
		game:GetService("Debris"):AddItem(part1, 0.5);
		game:GetService("Debris"):AddItem(part2, 0.5);
	end
	local function get_target()
		local target, dist = nil, math.huge;
		for _, p in next, Players:GetPlayers() do
			if ((p ~= LocalPlayer) and p.Character) then
				local head = p.Character:FindFirstChild("Head");
				local hum = p.Character:FindFirstChildOfClass("Humanoid");
				if (head and hum and (hum.Health > 0)) then
					local mag = (LocalPlayer.Character.HumanoidRootPart.Position - head.Position).Magnitude;
					if (mag < dist) then
						dist = mag;
						target = p;
					end
				end
			end
		end
		return target;
	end
	KillTab:Toggle({Title="ragebot",Value=false,Callback=function(state)
		if state then
			connection = RunService.Heartbeat:Connect(function()
				if ((os.clock() - last_attack) < cooldown) then
					return;
				end
				local enemy = get_target();
				if (enemy and enemy.Character:FindFirstChild("Head")) then
					local head = enemy.Character.Head;
					local origin = Camera.CFrame.Position;
					local dir = (head.Position - origin).Unit;
					last_attack = os.clock();
					local remotes = ReplicatedStorage:WaitForChild("Events"):WaitForChild("RemoteEvents");
					local sync = ReplicatedStorage:WaitForChild("SystemResources"):WaitForChild("BufferCache"):WaitForChild("RequestActionSync");
					sync:FireServer({origin=origin,direction=dir,hitPosition=head.Position,hitInstance=head,hitHumanoid=enemy.Character.Humanoid,IsHeadshot=true});
					remotes:WaitForChild("CharacterMuzzleFlash"):FireServer();
					remotes:WaitForChild("ReplicateFakeBullet"):FireServer(CFrame.new(origin, head.Position), dir);
					createBeam(origin, head.Position);
					playShootSound();
				end
			end);
		elseif connection then
			connection:Disconnect();
			connection = nil;
		end
	end});
	KillTab:Input({Title="射击间隔(秒)",Default="1.5",Callback=function(value)
		cooldown = tonumber(value) or 1.5;
	end});
	KillTab:Toggle({Title="命中日志",Value=false,Callback=function(state)
		HitLogEnabled = state;
	end});
end
