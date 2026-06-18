local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local TweenService = game:GetService("TweenService");
local LocalPlayer = Players.LocalPlayer;
local Character = LocalPlayer.Character;
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid");
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart");
LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char;
	HumanoidRootPart = char:WaitForChild("HumanoidRootPart");
	Humanoid = char:WaitForChildOfClass("Humanoid");
end);
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
local KillTab = Window:Tab({Title="杀戮",Icon="crown"});
Window:SelectTab(1);
local runKillAura = false;
local targetMode = "最近";
local Speed = 1;
local sudu = nil;
KillTab:Toggle({Title="杀戮光环",Desc="愤怒机器人",Type="Checkbox",Default=false,Callback=function(state)
	runKillAura = state;
	WindUI:Notify({Title="杀戮光环",Content=((state and "已启用") or "已禁用"),Icon=((state and "check") or "x"),Duration=1});
end});
KillTab:Dropdown({Title="攻击方式",Desc="选择目标",Values={"最近","最远","随机"},Value="最近",Callback=function(opt)
	targetMode = opt;
	WindUI:Notify({Title="攻击方式",Content=("已选择: " .. opt),Duration=1});
end});
KillTab:Toggle({Title="移速修改",Default=false,Callback=function(v)
	if v then
		sudu = RunService.Heartbeat:Connect(function()
			local char = LocalPlayer.Character;
			if not char then
				return;
			end
			local hum = char:FindFirstChildOfClass("Humanoid");
			if (not hum or (hum.Health <= 0)) then
				return;
			end
			if (hum.MoveDirection.Magnitude > 0) then
				char:TranslateBy((hum.MoveDirection * Speed) / 10);
			end
		end);
	elseif sudu then
		sudu:Disconnect();
		sudu = nil;
	end
end});
KillTab:Slider({Title="速度设置",Value={Min=1,Max=100,Default=1},Callback=function(Value)
	Speed = Value;
end});
local rs = ReplicatedStorage;
local ps = Players;
local ws = Workspace;
local rns = RunService;
local ts = TweenService;
local lp = LocalPlayer;
local spk;
local ri = require(rs:WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local fwc = ri.import(script, rs, "TS", "modules", "weaponController", "weaponController").FindWeaponControllerFromInstance;
for _, v in getgc(true) do
	if (type(v) == "table") then
		local s, r = pcall(rawget, v, "SendHitRequestPacket");
		if (s and r and (type(r) == "table") and r.send) then
			spk = r;
			break;
		end
	end
end
assert(spk, "The game not right");
local function createBeam(orig, targ)
	local f = Instance.new("Folder");
	f.Name = "Beam";
	f.Parent = ws;
	local o = orig:FindFirstChild("HumanoidRootPart");
	local t = targ:FindFirstChild("Head");
	local h = targ:FindFirstChildOfClass("Humanoid");
	if (not o or not t or not h or (h.Health <= 0)) then
		f:Destroy();
		return;
	end
	local ti = TweenInfo.new(0.2, Enum.EasingStyle.Linear);
	local parts = {};
	local con = {};
	local function update()
		local op = o.Position;
		local tp = t.Position;
		local dir = (tp - op).Unit;
		local mp = (op + tp) / 2;
		local cp = mp + (Vector3.new(-dir.Z, dir.Y, dir.X) * 3) + Vector3.new(0, math.random(-2, 2), 0);
		local pts = {};
		for i = 0, 20 do
			local v = i / 20;
			local p = (((1 - v) ^ 2) * op) + (2 * (1 - v) * v * cp) + ((v ^ 2) * tp);
			table.insert(pts, p);
		end
		for i = 1, #pts - 1 do
			local p1 = pts[i];
			local p2 = pts[i + 1];
			local d = (p2 - p1).Magnitude;
			local part = parts[i];
			if not part then
				part = Instance.new("Part");
				part.Size = Vector3.new(0.15, 0.15, d);
				part.Anchored = true;
				part.CanCollide = false;
				part.Material = Enum.Material.Neon;
				part.Transparency = 0.3;
				part.Color = Color3.fromRGB(255, 255, 255);
				part.Parent = f;
				parts[i] = part;
			end
			part.Size = Vector3.new(0.15, 0.15, d);
			part.CFrame = CFrame.new(p1, p2) * CFrame.new(0, 0, -d / 2);
		end
	end
	update();
	table.insert(con, rns.RenderStepped:Connect(function()
		if (not o.Parent or not t.Parent or (h.Health <= 0)) then
			for _, c in ipairs(con) do
				c:Disconnect();
			end
			for _, p in ipairs(parts) do
				ts:Create(p, ti, {Transparency=1}):Play();
			end
			task.wait(0.2);
			f:Destroy();
			return;
		end
		update();
	end));
	task.delay(1.5, function()
		if (f and f.Parent) then
			for _, c in ipairs(con) do
				c:Disconnect();
			end
			for _, p in ipairs(parts) do
				ts:Create(p, ti, {Transparency=1}):Play();
			end
			task.wait(0.2);
			f:Destroy();
		end
	end);
end
local function getTarget()
	local me = lp.Character;
	if not me then
		return nil;
	end
	local root = me:FindFirstChild("HumanoidRootPart");
	if not root then
		return nil;
	end
	local list = {};
	for _, p in ipairs(ps:GetPlayers()) do
		if (p == lp) then
			continue;
		end
		local char = p.Character;
		if not char then
			continue;
		end
		local hum = char:FindFirstChildOfClass("Humanoid");
		local hrp = char:FindFirstChild("HumanoidRootPart");
		if (hum and (hum.Health > 0) and hrp) then
			local dist = (hrp.Position - root.Position).Magnitude;
			table.insert(list, {char=char,dist=dist});
		end
	end
	if (#list == 0) then
		return nil;
	end
	if (targetMode == "最近") then
		table.sort(list, function(a, b)
			return a.dist < b.dist;
		end);
	elseif (targetMode == "最远") then
		table.sort(list, function(a, b)
			return a.dist > b.dist;
		end);
	elseif (targetMode == "随机") then
		list = {list[math.random(#list)]};
	end
	return list[1].char;
end
local function attack(target)
	local me = lp.Character;
	if not me then
		return;
	end
	local wp = me:FindFirstChild("Weapon");
	if not wp then
		return;
	end
	local wc = fwc(wp);
	if not wc then
		return;
	end
	local head = target:FindFirstChild("Head");
	if not head then
		return;
	end
	wc:attackRequest();
	local ao = wc:getStateMachine():getStateObject("Attacking");
	local cm = ao._comboManager;
	local ci = cm:getComboIndex();
	local ai = cm:getAttackIndex();
	local hp = wp:FindFirstChild("HitParts");
	local mb = nil;
	for _, c in ipairs(hp:GetChildren()) do
		if c:IsA("BasePart") then
			mb = c;
			break;
		end
	end
	if not mb then
		return;
	end
	local rp = me:FindFirstChild("HumanoidRootPart");
	local dr = (head.Position - rp.Position).Unit;
	spk.send({packet={weaponModel=wp,relativeOffset=(head.CFrame:Inverse() * CFrame.new(head.Position)),identifier=math.floor(tick() * 100),hitDirection=dr,hitNormal=-dr,instance=head,hitPart=mb,timeStamp=ws:GetServerTimeNow(),tick=tick(),attackInfo={comboIndex=ci,attackIndex=ai}},parried=false});
	createBeam(me, target);
end
task.spawn(function()
	while true do
		task.wait(0.12);
		if not runKillAura then
			continue;
		end
		local tar = getTarget();
		if tar then
			attack(tar);
		end
	end
end);
