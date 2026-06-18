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
local player = Players.LocalPlayer;
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local AnimationController = {ActiveButtons={},DefaultAnimations={},Character=nil,Humanoid=nil,Animator=nil,IsInitialized=false,CannonHighlightEnabled=false,CannonHighlights={}};
AnimationController.MainButtonConfigs = {{Name="远古ZAPPER动画",IdleId="12333488814",WalkId="12333490576",Priority=Enum.AnimationPriority.Action2,Callback=function(state)
end},{Name="超人",IdleId="123279433658792",WalkId="123279433658792",Priority=Enum.AnimationPriority.Action3,Callback=function(state)
	if state then
		AnimationController.Humanoid.WalkSpeed = 50;
	else
		AnimationController.Humanoid.WalkSpeed = 16;
	end
end},{Name="ZAPPER动画",IdleId="14498563473",WalkId="14498289874",Priority=Enum.AnimationPriority.Action3,Callback=function(state)
end},{Name="ZAPPER特效",PlayOnceId="14499470197",Priority=Enum.AnimationPriority.Action4,Callback=function(state)
end},{Name="装死",PlayOnceId="89945348540089",Priority=Enum.AnimationPriority.Action4,Callback=function(state)
end},{Name="山伯乐吃播",PlayOnceId="18339432914",StopAfter=10,Priority=Enum.AnimationPriority.Action4,Callback=function(state)
end},{Name="是多绝望的人能跳出这个舞步",PlayOnceId="14860627011",StopAfter=20,Priority=Enum.AnimationPriority.Action4,Callback=function(state)
end},{Name="红眼",IdleId="12581784105",WalkId="12581785298",Priority=Enum.AnimationPriority.Action3,Callback=function(state)
	if state then
		AnimationController.Humanoid.WalkSpeed = 50;
	else
		AnimationController.Humanoid.WalkSpeed = 16;
	end
end},{Name="山伯乐动画",IdleId="12333488814",WalkId="14463730540",Priority=Enum.AnimationPriority.Action3,Callback=function(state)
end},{Name="提灯人",IdleId="14678879479",WalkId="14678880308",Priority=Enum.AnimationPriority.Action3,Callback=function(state)
end},{Name="无头士兵（美国）",IdleId="107080941320600",WalkId="74764025513892",Priority=Enum.AnimationPriority.Action3,Callback=function(state)
end},{Name="胸甲僵尸",IdleId="87579228279296",WalkId="102081698785465",Priority=Enum.AnimationPriority.Action3,Callback=function(state)
end},{Name="骑兵动画（刺）",Callback=function(state)
end},{Name="滑膛枪冲锋",IdleId="14292935158",WalkId="14292937831",Priority=Enum.AnimationPriority.Action3,Callback=function(state)
	if state then
		AnimationController.Humanoid.WalkSpeed = 24;
	else
		AnimationController.Humanoid.WalkSpeed = 16;
	end
end},{Name="重剑冲锋",IdleId="14284611111",WalkId="17406602570",Priority=Enum.AnimationPriority.Action3,Callback=function(state)
	if state then
		AnimationController.Humanoid.WalkSpeed = 24;
	else
		AnimationController.Humanoid.WalkSpeed = 16;
	end
end},{Name="自爆",IdleId="13211198049",WalkId="13211207597",Priority=Enum.AnimationPriority.Action3,Callback=function(state)
end},{Name="爬尸",IdleId="13726632691",WalkId="13726634549",SitId="130515356351734",Priority=Enum.AnimationPriority.Action3,Callback=function(state)
end}};
AnimationController.SideButtonConfigs = {{Name="拿破仑背手",IdleId="103557875332543",WalkId="103557875332543",Priority=Enum.AnimationPriority.Action4},{Name="寒冷",IdleId="16863977222",WalkId="16876434500",Priority=Enum.AnimationPriority.Action3,Callback=function(state)
end},{Name="胸甲僵尸动画2",IdleId="82800474630427",WalkId="118210337289087",Priority=Enum.AnimationPriority.Action3,Callback=function(state)
end},{Name="克劳福德",PlayOnceId="77859967130018",Priority=Enum.AnimationPriority.Action4,Callback=function(state)
end},{Name="十字架使用",PlayOnceId="15210536563",Priority=Enum.AnimationPriority.Action4,Callback=function(state)
end},{Name="雅各布",PlayOnceId="12404717502",Priority=Enum.AnimationPriority.Action4,Callback=function(state)
end},{Name="僵尸王",PlayOnceId="13408244121",Priority=Enum.AnimationPriority.Action4,Callback=function(state)
end},{Name="僵尸扒门",PlayOnceId="15593727441",Priority=Enum.AnimationPriority.Action4,Callback=function(state)
end}};
AnimationController.RestoreDefaults = function(self)
	if self.Humanoid then
		self.Humanoid.WalkSpeed = 16;
		if (self.DefaultAnimations.Walk and not self.DefaultAnimations.Walk.IsPlaying) then
			self.DefaultAnimations.Walk:Play();
		end
		if (self.DefaultAnimations.Idle and not self.DefaultAnimations.Idle.IsPlaying) then
			self.DefaultAnimations.Idle:Play();
		end
	end
end;
AnimationController.ToggleAnimation = function(self, config, buttonData, state)
	buttonData.IsActive = state;
	if buttonData.IsActive then
		if not next(buttonData.Tracks) then
			if config.IdleId then
				local anim = Instance.new("Animation");
				anim.AnimationId = "rbxassetid://" .. config.IdleId;
				buttonData.Tracks.Idle = self.Animator:LoadAnimation(anim);
				buttonData.Tracks.Idle.Priority = config.Priority or Enum.AnimationPriority.Action4;
			end
			if config.WalkId then
				local anim = Instance.new("Animation");
				anim.AnimationId = "rbxassetid://" .. config.WalkId;
				buttonData.Tracks.Walk = self.Animator:LoadAnimation(anim);
				buttonData.Tracks.Walk.Priority = config.Priority or Enum.AnimationPriority.Action4;
			end
			if config.SitId then
				local anim = Instance.new("Animation");
				anim.AnimationId = "rbxassetid://" .. config.SitId;
				buttonData.Tracks.Sit = self.Animator:LoadAnimation(anim);
				buttonData.Tracks.Sit.Priority = Enum.AnimationPriority.Action2;
				buttonData.Tracks.Sit.Looped = true;
			end
			if config.PlayOnceId then
				local anim = Instance.new("Animation");
				anim.AnimationId = "rbxassetid://" .. config.PlayOnceId;
				buttonData.Tracks.PlayOnce = self.Animator:LoadAnimation(anim);
				buttonData.Tracks.PlayOnce.Priority = config.Priority or Enum.AnimationPriority.Action;
				buttonData.Tracks.PlayOnce.Looped = false;
			end
		end
		if config.PlayOnceId then
			if buttonData.Tracks.PlayOnce then
				buttonData.Tracks.PlayOnce:Play();
				if config.Callback then
					config.Callback(true);
				end
			end
		else
			if buttonData.Tracks.Sit then
				buttonData.Tracks.Sit:Play();
			end
			if (self.Humanoid.MoveDirection.Magnitude > 0) then
				if buttonData.Tracks.Walk then
					buttonData.Tracks.Walk:Play();
				end
			elseif buttonData.Tracks.Idle then
				buttonData.Tracks.Idle:Play();
			end
			buttonData.Connections.Movement = self.Humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
				if (self.Humanoid.MoveDirection.Magnitude > 0) then
					if (buttonData.Tracks.Walk and not buttonData.Tracks.Walk.IsPlaying) then
						buttonData.Tracks.Walk:Play();
					end
					if (buttonData.Tracks.Idle and buttonData.Tracks.Idle.IsPlaying) then
						buttonData.Tracks.Idle:Stop();
					end
				else
					if (buttonData.Tracks.Idle and not buttonData.Tracks.Idle.IsPlaying) then
						buttonData.Tracks.Idle:Play();
					end
					if (buttonData.Tracks.Walk and buttonData.Tracks.Walk.IsPlaying) then
						buttonData.Tracks.Walk:Stop();
					end
				end
			end);
		end
		if config.Callback then
			config.Callback(true);
		end
	else
		for _, track in pairs(buttonData.Tracks) do
			if track then
				track:Stop();
			end
		end
		for _, conn in pairs(buttonData.Connections) do
			conn:Disconnect();
		end
		buttonData.Connections = {};
		if config.Callback then
			config.Callback(false);
		end
		self:RestoreDefaults();
	end
end;
AnimationController.Initialize = function(self)
	self.Character = player.Character or player.CharacterAdded:Wait();
	self.Humanoid = self.Character:WaitForChild("Humanoid");
	self.Animator = self.Humanoid:WaitForChild("Animator");
	self.DefaultAnimations = {};
	for _, track in pairs(self.Humanoid:GetPlayingAnimationTracks()) do
		if (track.Name == "IdleAnimation") then
			self.DefaultAnimations.Idle = track;
		elseif (track.Name == "Walk") then
			self.DefaultAnimations.Walk = track;
		end
	end
	self.Humanoid.Died:Connect(function()
		self:RestoreDefaults();
	end);
	self.IsInitialized = true;
end;
player.CharacterAdded:Connect(function()
	task.wait(1);
	AnimationController:Initialize();
end);
if player.Character then
	AnimationController:Initialize();
end
local AnimTab = Window:Tab({Title="动画与动作",Icon="person-standing"});
local CombatTab = Window:Tab({Title="功能增强",Icon="swords"});
local EspTab = Window:Tab({Title="透视与辅助",Icon="eye"});
local MiscTab = Window:Tab({Title="杂项/传送",Icon="package"});
Window:SelectTab(1);
AnimTab:Section({Title="动画(会封)",TextSize=16});
for _, config in ipairs(AnimationController.MainButtonConfigs) do
	local buttonData = {Tracks={},Connections={}};
	AnimationController.ActiveButtons[config.Name] = buttonData;
	AnimTab:Toggle({Title=config.Name,Default=false,Callback=function(state)
		if ((config.Name == "骑兵动画（刺）") and state) then
		else
			AnimationController:ToggleAnimation(config, buttonData, state);
		end
	end});
end
AnimTab:Section({Title="侧边特别动画",TextSize=16});
for _, config in ipairs(AnimationController.SideButtonConfigs) do
	local buttonData = {Tracks={},Connections={}};
	AnimationController.ActiveButtons[config.Name] = buttonData;
	AnimTab:Toggle({Title=config.Name,Default=false,Callback=function(state)
		AnimationController:ToggleAnimation(config, buttonData, state);
	end});
end
CombatTab:Section({Title="自动化",TextSize=16});
local isAutoDigging = false;
local digConnection = nil;
CombatTab:Toggle({Title="自动挖雪",Callback=function(state)
	isAutoDigging = state;
	if state then
		digConnection = task.spawn(function()
			while isAutoDigging do
				local char = player.Character;
				if char then
					local tool = char:FindFirstChild("Shovel") or char:FindFirstChild("Spade") or player.Backpack:FindFirstChild("Shovel") or player.Backpack:FindFirstChild("Spade");
					if (tool and tool:FindFirstChild("RemoteEvent")) then
						if (tool.Parent ~= char) then
							tool.Parent = char;
							task.wait(0.2);
						end
						tool.RemoteEvent:FireServer("Dig", workspace, player.Character.PrimaryPart.Position);
					end
				end
				task.wait(0.1);
			end
		end);
	elseif digConnection then
		task.cancel(digConnection);
		digConnection = nil;
	end
end});
local isAutoRepairing = false;
local repairOthers = false;
local repairConnection = nil;
CombatTab:Toggle({Title="自动修复建筑",Callback=function(state)
	isAutoRepairing = state;
	if state then
		repairConnection = task.spawn(function()
			while isAutoRepairing do
				task.wait(0.5);
			end
		end);
	elseif repairConnection then
		task.cancel(repairConnection);
		repairConnection = nil;
	end
end});
CombatTab:Toggle({Title="修复他人建筑",Callback=function(state)
	repairOthers = state;
end});
local autoLogEnabled = false;
CombatTab:Toggle({Title="自动拿木头 (Berezina)",Callback=function(state)
	autoLogEnabled = state;
	task.spawn(function()
		while autoLogEnabled do
			pcall(function()
				local remote = workspace.Berezina.Modes.Holdout.Log.Log.Interact;
				if remote then
					remote:FireServer();
				end
			end);
			task.wait(0.1);
		end
	end);
end});
CombatTab:Section({Title="战斗与光环",TextSize=16});
local killAuraActive, attackBarrels, autoRotateEnabled, attackDraculaEnabled = false, false, false, false;
CombatTab:Toggle({Title="近战杀戮光环 (普通)",Callback=function(state)
	killAuraActive = state;
end});
CombatTab:Toggle({Title="刺刀杀戮光环",Callback=function(state)
end});
CombatTab:Toggle({Title="光环：攻击炸药桶",Callback=function(state)
	attackBarrels = state;
end});
CombatTab:Toggle({Title="光环：自动转向",Callback=function(state)
	autoRotateEnabled = state;
end});
CombatTab:Toggle({Title="光环：攻击德古拉",Callback=function(state)
	attackDraculaEnabled = state;
end});
local isAutoAttackingPlayers = false;
CombatTab:Toggle({Title="PVP 杀戮光环 (玩家)",Callback=function(state)
	isAutoAttackingPlayers = state;
end});
local noFallDamageActive = false;
CombatTab:Toggle({Title="移除摔伤",Callback=function(state)
	noFallDamageActive = state;
	task.spawn(function()
		while noFallDamageActive do
			pcall(function()
				local fsd = player.Character.Health.ForceSelfDamage;
				fsd:FireServer(0);
			end);
			task.wait(1);
		end
	end);
end});
local noSlowActive = false;
CombatTab:Toggle({Title="无减速",Callback=function(state)
	noSlowActive = state;
	if state then
		task.spawn(function()
			while noSlowActive do
				if (player.Character and player.Character:FindFirstChild("Humanoid")) then
					if (player.Character.Humanoid.WalkSpeed < 16) then
						player.Character.Humanoid.WalkSpeed = 16;
					end
				end
				task.wait(0.1);
			end
		end);
	end
end});
EspTab:Section({Title="视觉修改",TextSize=16});
EspTab:Toggle({Title="全图高亮",Callback=function(state)
	if state then
		game:GetService("Lighting").Brightness = 2;
		game:GetService("Lighting").ClockTime = 14;
		game:GetService("Lighting").FogEnd = 100000;
		game:GetService("Lighting").GlobalShadows = false;
	else
		game:GetService("Lighting").Brightness = 1;
		game:GetService("Lighting").FogEnd = 786543;
		game:GetService("Lighting").GlobalShadows = true;
	end
end});
EspTab:Toggle({Title="玩家透视",Callback=function(state)
	if state then
		for _, p in pairs(Players:GetPlayers()) do
			if ((p ~= player) and p.Character) then
				local hl = Instance.new("Highlight");
				hl.Name = "ESP";
				hl.FillTransparency = 0.5;
				hl.Parent = p.Character;
			end
		end
	else
		for _, p in pairs(Players:GetPlayers()) do
			if (p.Character and p.Character:FindFirstChild("ESP")) then
				p.Character.ESP:Destroy();
			end
		end
	end
end});
EspTab:Toggle({Title="透视僵尸 & Boss",Callback=function(state)
end});
EspTab:Toggle({Title="瓦尔多要塞火炮物资透视",Callback=function(state)
	if state then
		AnimationController:CreateCannonHighlights();
	else
		AnimationController:RemoveCannonHighlights();
	end
end});
EspTab:Toggle({Title=" 大头娃娃山伯乐",Callback=function(state)
end});
MiscTab:Section({Title="属性修改",TextSize=16});
local customSpeed = 16;
MiscTab:Input({Title="设置移动速度",Placeholder="例如: 50",Callback=function(val)
	customSpeed = tonumber(val) or 16;
end});
MiscTab:Toggle({Title="启用自定义速度",Callback=function(state)
	task.spawn(function()
		while state do
			if (player.Character and player.Character:FindFirstChild("Humanoid")) then
				player.Character.Humanoid.WalkSpeed = customSpeed;
			end
			task.wait(0.1);
		end
	end);
end});
MiscTab:Section({Title="传送与恶搞",TextSize=16});
MiscTab:Toggle({Title="无敌飞雷神 (瞬移背刺)",Callback=function(state)
end});
MiscTab:Button({Title="莱比锡绕过大门传送",Callback=function()
	if (player.Character and player.Character:FindFirstChild("HumanoidRootPart")) then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(-588.65, 10.91, -109.46);
	end
end});
MiscTab:Toggle({Title="黑皮体育生沉淀 (动作循环)",Callback=function(state)
end});
