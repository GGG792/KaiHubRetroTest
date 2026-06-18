local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Yisan886/Aero/refs/heads/main/ui.lua.txt"))();
WindUI:AddTheme({Name="My Theme",Accent=Color3.fromHex("#18181b"),Background=Color3.fromHex("#101010"),Outline=Color3.fromHex("#FFFFFF"),Text=Color3.fromHex("#FFFFFF"),Placeholder=Color3.fromHex("#7a7a7a"),Button=Color3.fromHex("#52525b"),Icon=Color3.fromHex("#a1a1aa")});
local Window = WindUI:CreateWindow({Title="Aero      ",Folder="Aero",SideBarWidth=180,Background="https://chaton-images.s3.us-east-2.amazonaws.com/GHn9L9UJLf0XcVNyCpbG72D0rmNmBEWndPkh6CjJNya8GLnWzz1vImvt8wlJSBwv_2700x1519x1393696.jpeg",BackgroundImageTransparency=0.5,OpenButton={Title="打开脚本",CornerRadius=UDim.new(1, 0),StrokeThickness=3,Enabled=true,Draggable=true,OnlyMobile=false,Scale=0.9,Color=ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f"))},Topbar={Height=44,ButtonsType="Mac"}});
Window:Tag({Title="V1.03",Color=Color3.fromHex("00CED1"),Radius=2});
Window:Tag({Title="杨志卡",Icon="crown",Color=Color3.fromHex("FFD700"),Radius=2});
Window:Tag({Title="杨志卡",Icon="square-chevron-right",Color=Color3.fromHex("#30ff6a"),Radius=2});
Window:Tag({Title="蛙蛙",Icon="square-chevron-right",Color=Color3.fromHex("#30ff6a"),Radius=2});
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
local plrs = game:GetService("Players");
local rep = game:GetService("ReplicatedStorage");
local lighting = game:GetService("Lighting");
local run = game:GetService("RunService");
local uis = game:GetService("UserInputService");
local tween = game:GetService("TweenService");
local LocalPlayer = plrs.LocalPlayer;
local AxeHit = rep:WaitForChild("AxeHit");
local carryablesFolder = workspace:FindFirstChild("_Carryables");
local debrisFolder = workspace:FindFirstChild("_Debris");
local npcsFolder = debrisFolder and debrisFolder:FindFirstChild("NPCs");
local islandsFolder = debrisFolder and debrisFolder:FindFirstChild("Islands");
local cratesFolder = workspace:FindFirstChild("_Crates");
local counter = 0;
if not carryablesFolder then
	WindUI:Notify({Title="错误",Content="请先进入游戏",Duration=4});
	return;
end
local GameplayEvents = rep:FindFirstChild("Events") and rep.Events:FindFirstChild("Gameplay");
local PickUpEvent = GameplayEvents and GameplayEvents:FindFirstChild("PickUpCarryable");
local DropEvent = GameplayEvents and GameplayEvents:FindFirstChild("DropCarryable");
local ClaimLootEvent = rep:WaitForChild("ClaimLootEvent");
local function getCampfirePosition()
	local raft = workspace:FindFirstChild("_Raft");
	if not raft then
		return nil;
	end
	local campfire = raft:FindFirstChild("Campfire");
	if not campfire then
		return nil;
	end
	if campfire:IsA("BasePart") then
		return campfire.Position;
	elseif campfire:IsA("Model") then
		local primary = campfire.PrimaryPart;
		if primary then
			return primary.Position;
		end
		for _, part in ipairs(campfire:GetDescendants()) do
			if part:IsA("BasePart") then
				return part.Position;
			end
		end
	end
	return nil;
end
local function teleportToPosition(pos)
	local char = LocalPlayer.Character;
	local hrp = char and char:FindFirstChild("HumanoidRootPart");
	if (hrp and pos) then
		hrp.CFrame = CFrame.new(pos);
		return true;
	end
	return false;
end
local function teleportToInstance(inst, yOffset)
	if not inst then
		return;
	end
	yOffset = yOffset or 3;
	local char = LocalPlayer.Character;
	local hrp = char and char:FindFirstChild("HumanoidRootPart");
	if not hrp then
		return;
	end
	if (inst:IsA("Model") and inst:GetPivot()) then
		hrp.CFrame = inst:GetPivot() * CFrame.new(0, yOffset, 0);
	elseif inst:IsA("BasePart") then
		hrp.CFrame = inst.CFrame * CFrame.new(0, yOffset, 0);
	end
end
local espHighlights = {Items={},NPCs={}};
local itemESPEnabled = false;
local npcESPEnabled = false;
local function createESP(obj, color, name)
	if (not obj or not obj:IsA("PVInstance")) then
		return nil, nil;
	end
	local highlight = Instance.new("Highlight");
	highlight.FillColor = color;
	highlight.OutlineColor = color;
	highlight.FillTransparency = 0.5;
	highlight.OutlineTransparency = 0.2;
	highlight.Adornee = obj;
	highlight.Parent = obj;
	local billboard = Instance.new("BillboardGui");
	billboard.Name = "ESP_Name";
	billboard.Adornee = obj;
	billboard.Size = UDim2.new(0, 100, 0, 20);
	billboard.StudsOffset = Vector3.new(0, 2, 0);
	billboard.AlwaysOnTop = true;
	billboard.Parent = obj;
	local textLabel = Instance.new("TextLabel");
	textLabel.Size = UDim2.new(1, 0, 1, 0);
	textLabel.BackgroundTransparency = 1;
	textLabel.Text = name;
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
	textLabel.TextStrokeTransparency = 0.5;
	textLabel.Font = Enum.Font.GothamBold;
	textLabel.TextSize = 12;
	textLabel.TextScaled = true;
	textLabel.Parent = billboard;
	return highlight, billboard;
end
local function clearItemESP()
	for _, data in ipairs(espHighlights.Items) do
		if (data.highlight and data.highlight.Parent) then
			data.highlight:Destroy();
		end
		if (data.billboard and data.billboard.Parent) then
			data.billboard:Destroy();
		end
	end
	espHighlights.Items = {};
end
local function clearNPCESP()
	for _, data in ipairs(espHighlights.NPCs) do
		if (data.highlight and data.highlight.Parent) then
			data.highlight:Destroy();
		end
		if (data.billboard and data.billboard.Parent) then
			data.billboard:Destroy();
		end
	end
	espHighlights.NPCs = {};
end
local function refreshItemESP()
	if not itemESPEnabled then
		return;
	end
	clearItemESP();
	for _, obj in ipairs(carryablesFolder:GetChildren()) do
		local highlight, billboard = createESP(obj, Color3.fromRGB(0, 255, 0), obj.Name);
		if highlight then
			table.insert(espHighlights.Items, {highlight=highlight,billboard=billboard});
		end
	end
end
local function refreshNPCESP()
	if (not npcESPEnabled or not npcsFolder) then
		return;
	end
	clearNPCESP();
	for _, obj in ipairs(npcsFolder:GetChildren()) do
		local animalType = obj:GetAttribute("AnimalType");
		local displayName = animalType or "未知生物";
		local highlight, billboard = createESP(obj, Color3.fromRGB(255, 0, 0), displayName);
		if highlight then
			table.insert(espHighlights.NPCs, {highlight=highlight,billboard=billboard});
		end
	end
end
carryablesFolder.ChildAdded:Connect(function()
	if itemESPEnabled then
		refreshItemESP();
	end
end);
carryablesFolder.ChildRemoved:Connect(function()
	if itemESPEnabled then
		refreshItemESP();
	end
end);
if npcsFolder then
	npcsFolder.ChildAdded:Connect(function()
		if npcESPEnabled then
			refreshNPCESP();
		end
	end);
	npcsFolder.ChildRemoved:Connect(function()
		if npcESPEnabled then
			refreshNPCESP();
		end
	end);
end
task.spawn(function()
	while true do
		if itemESPEnabled then
			refreshItemESP();
		end
		if npcESPEnabled then
			refreshNPCESP();
		end
		task.wait(1);
	end
end);
local autoPickupRunning, autoPickupThread = false, nil;
local tpDelay, maxPickWaitTime, maxTeleWaitTime, campfireIgnoreDistance = 0.1, 0.5, 0.3, 10;
local function stopAutoPickup()
	autoPickupRunning = false;
	if autoPickupThread then
		autoPickupThread = nil;
	end
	WindUI:Notify({Title="自动拾取关闭",Content="已停止物品拾取",Duration=2});
end
local function startAutoPickup()
	if autoPickupRunning then
		return;
	end
	if (not PickUpEvent or not DropEvent) then
		WindUI:Notify({Title="错误",Content="未找到拾取/放下远程事件",Duration=3});
		return;
	end
	autoPickupRunning = true;
	autoPickupThread = task.spawn(function()
		while autoPickupRunning do
			local items = carryablesFolder:GetChildren();
			local raft = workspace:FindFirstChild("_Raft");
			local campfirePos = getCampfirePosition();
			local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
			if ((#items > 0) and raft and hrp and campfirePos) then
				local targetItem = nil;
				for _, item in ipairs(items) do
					if not autoPickupRunning then
						break;
					end
					if (item:IsA("Model") or (item:IsA("BasePart") and item:IsDescendantOf(workspace))) then
						local itemPos = item:GetPivot().Position;
						local distToCampfire = (Vector3.new(itemPos.X, 0, itemPos.Z) - Vector3.new(campfirePos.X, 0, campfirePos.Z)).Magnitude;
						if (distToCampfire >= campfireIgnoreDistance) then
							targetItem = item;
							break;
						end
					end
				end
				if (targetItem and autoPickupRunning) then
					teleportToInstance(targetItem);
					task.wait(tpDelay);
					if not autoPickupRunning then
						break;
					end
					pcall(function()
						PickUpEvent:FireServer(targetItem);
					end);
					local pickSuccess = false;
					local waitStart = tick();
					while (tick() - waitStart) < maxPickWaitTime do
						if not autoPickupRunning then
							break;
						end
						if not targetItem:IsDescendantOf(workspace) then
							pickSuccess = true;
							break;
						end
						task.wait(0.02);
					end
					if not pickSuccess then
						task.wait(tpDelay);
						continue;
					end
					task.wait(tpDelay);
					if not autoPickupRunning then
						break;
					end
					teleportToInstance(raft);
					local teleSuccess = false;
					local teleStart = tick();
					local raftPos = raft:GetPivot().Position;
					while (tick() - teleStart) < maxTeleWaitTime do
						if not autoPickupRunning then
							break;
						end
						local currentPos = hrp.Position;
						local distance = (Vector3.new(currentPos.X, 0, currentPos.Z) - Vector3.new(raftPos.X, 0, raftPos.Z)).Magnitude;
						if (distance <= 2) then
							teleSuccess = true;
							break;
						end
						task.wait(0.02);
					end
					if not teleSuccess then
						task.wait(tpDelay);
						continue;
					end
					task.wait(tpDelay);
					if not autoPickupRunning then
						break;
					end
					pcall(function()
						DropEvent:FireServer();
					end);
					task.wait(tpDelay * 2);
				else
					task.wait(0.5);
				end
			else
				task.wait(0.5);
			end
		end
		autoPickupThread = nil;
	end);
	WindUI:Notify({Title="自动拾取开启",Content="已启动物品自动拾取（跳过篝火附近）",Duration=2});
end
local function equipAnyTool()
	pcall(function()
		local backpack = LocalPlayer.Backpack;
		if backpack then
			local tool = backpack:FindFirstChildOfClass("Tool");
			if (tool and LocalPlayer.Character) then
				LocalPlayer.Character.Humanoid:EquipTool(tool);
			end
		end
	end);
end
local charTab = Window:Tab({Title="角色",Icon="user",Locked=false});
local speedEnabled, speedValue, speedThread = false, 35, nil;
local function updateSpeed()
	while speedEnabled do
		local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid");
		if humanoid then
			humanoid.WalkSpeed = speedValue;
		end
		task.wait(0.5);
	end
end
charTab:Toggle({Title="加速",Desc="提升人物移动速度",Value=false,Callback=function(state)
	speedEnabled = state;
	if state then
		if speedThread then
			task.cancel(speedThread);
		end
		speedThread = task.spawn(updateSpeed);
	else
		if speedThread then
			task.cancel(speedThread);
			speedThread = nil;
		end
		local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid");
		if humanoid then
			humanoid.WalkSpeed = 16;
		end
	end
end});
charTab:Slider({Title="速度值",Desc="调整加速快慢",Step=1,Value={Min=20,Max=100,Default=35},Callback=function(value)
	speedValue = value;
end});
local flightEnabled, flightSpeed, flightConnection = false, 2, nil;
local function startFlight()
	if flightConnection then
		flightConnection:Disconnect();
		flightConnection = nil;
	end
	local char = LocalPlayer.Character;
	if not char then
		return;
	end
	local humanoid = char:FindFirstChildOfClass("Humanoid");
	local head = char:FindFirstChild("Head");
	if (not humanoid or not head) then
		return;
	end
	humanoid.PlatformStand = true;
	head.Anchored = true;
	local camera = workspace.CurrentCamera;
	flightConnection = run.Heartbeat:Connect(function(deltaTime)
		if (not flightEnabled or not LocalPlayer.Character) then
			stopFlight();
			return;
		end
		local c = LocalPlayer.Character;
		local hum = c and c:FindFirstChildOfClass("Humanoid");
		local hd = c and c:FindFirstChild("Head");
		if (not hum or not hd) then
			stopFlight();
			return;
		end
		local moveDir = hum.MoveDirection * flightSpeed * deltaTime * 50;
		local headCF = hd.CFrame;
		local camCF = camera.CFrame;
		local camOffset = headCF:ToObjectSpace(camCF).Position;
		local adjustedCamCF = camCF * CFrame.new(-camOffset.X, -camOffset.Y, -camOffset.Z + 1);
		local camPos = adjustedCamCF.Position;
		local headPos = headCF.Position;
		local objSpaceVelocity = CFrame.new(camPos, Vector3.new(headPos.X, camPos.Y, headPos.Z)):VectorToObjectSpace(moveDir);
		hd.CFrame = CFrame.new(headPos) * (adjustedCamCF - camPos) * CFrame.new(objSpaceVelocity);
	end);
end
local function stopFlight()
	if flightConnection then
		flightConnection:Disconnect();
		flightConnection = nil;
	end
	local char = LocalPlayer.Character;
	if char then
		local humanoid = char:FindFirstChildOfClass("Humanoid");
		local head = char:FindFirstChild("Head");
		if humanoid then
			humanoid.PlatformStand = false;
		end
		if head then
			head.Anchored = false;
		end
	end
end
charTab:Toggle({Title="飞行",Desc="控制角色自由飞行",Value=false,Callback=function(state)
	flightEnabled = state;
	if state then
		startFlight();
	else
		stopFlight();
	end
end});
charTab:Slider({Title="飞行速度",Desc="调整飞行移速",Step=1,Value={Min=1,Max=5,Default=2},Callback=function(value)
	flightSpeed = value;
end});
local invincibleEnabled, invincibleHeight, invincibleThread, anchorY = false, 1, nil, 0;
local function recalcAnchor()
	if not invincibleEnabled then
		return;
	end
	local char = LocalPlayer.Character;
	local hrp = char and char:FindFirstChild("HumanoidRootPart");
	if not hrp then
		return;
	end
	local raycastResult = workspace:Raycast(hrp.Position + Vector3.new(0, 5, 0), Vector3.new(0, -100, 0));
	anchorY = ((raycastResult and raycastResult.Position.Y) or hrp.Position.Y) + invincibleHeight;
end
local function startInvincible()
	if invincibleEnabled then
		return;
	end
	invincibleEnabled = true;
	recalcAnchor();
	local char = LocalPlayer.Character;
	if (char and char:FindFirstChildOfClass("Humanoid")) then
		char:FindFirstChildOfClass("Humanoid").PlatformStand = true;
	end
	invincibleThread = task.spawn(function()
		while invincibleEnabled do
			local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
			if h then
				h.CFrame = CFrame.new(h.Position.X, anchorY, h.Position.Z) * CFrame.Angles(0, math.atan2(h.CFrame.LookVector.X, h.CFrame.LookVector.Z), 0);
				h.Velocity = Vector3.new(h.Velocity.X, 0, h.Velocity.Z);
			end
			task.wait(0.03);
		end
		invincibleThread = nil;
	end);
end
local function stopInvincible()
	invincibleEnabled = false;
	if invincibleThread then
		invincibleThread = nil;
	end
	local char = LocalPlayer.Character;
	if (char and char:FindFirstChildOfClass("Humanoid")) then
		char:FindFirstChildOfClass("Humanoid").PlatformStand = false;
	end
end
charTab:Toggle({Title="无敌 (悬浮)",Desc="通过离地悬浮避免地面伤害",Value=false,Callback=function(state)
	if state then
		startInvincible();
	else
		stopInvincible();
	end
end});
charTab:Slider({Title="悬浮高度",Desc="调整无敌悬浮离地高度",Step=1,Value={Min=1,Max=3,Default=1},Callback=function(value)
	invincibleHeight = value;
	recalcAnchor();
end});
charTab:Button({Title="传送到火堆",Desc="将自己传送到木筏的火堆处",Callback=function()
	local firePos = getCampfirePosition();
	if firePos then
		teleportToPosition(firePos);
		WindUI:Notify({Title="传送成功",Content="已传送到火堆",Duration=2});
	else
		WindUI:Notify({Title="传送失败",Content="未找到火堆位置",Duration=2});
	end
end});
local featureTab = Window:Tab({Title="特色",Icon="star",Locked=false});
featureTab:Toggle({Title="自动拿取物品",Desc="自动搜集周围物资",Value=false,Callback=function(state)
	if state then
		startAutoPickup();
	else
		stopAutoPickup();
	end
end});
local autoCrateRunning, autoCrateThread = false, nil;
local function openCrate(crate)
	if (not crate or not crate.Parent) then
		return false;
	end
	local promptPart = crate:FindFirstChild("PromptPart");
	if not promptPart then
		return false;
	end
	local openCratePrompt = promptPart:FindFirstChild("OpenCrate");
	if (not openCratePrompt or not openCratePrompt:IsA("ProximityPrompt")) then
		for _, child in ipairs(promptPart:GetChildren()) do
			if child:IsA("ProximityPrompt") then
				openCratePrompt = child;
				break;
			end
		end
	end
	if not openCratePrompt then
		return false;
	end
	local originalHoldDuration = openCratePrompt.HoldDuration;
	openCratePrompt.HoldDuration = 0;
	teleportToInstance(crate, 3);
	task.wait(0.2);
	openCratePrompt:InputHoldBegin();
	task.wait(0.1);
	openCratePrompt:InputHoldEnd();
	openCratePrompt.HoldDuration = originalHoldDuration;
	return true;
end
local function stopAutoCrate()
	autoCrateRunning = false;
	if autoCrateThread then
		autoCrateThread = nil;
	end
	WindUI:Notify({Title="自动开箱关闭",Content="已停止自动开箱",Duration=2});
end
local function startAutoCrate()
	if autoCrateRunning then
		return;
	end
	if not cratesFolder then
		WindUI:Notify({Title="错误",Content="未找到箱子文件夹",Duration=3});
		return;
	end
	autoCrateRunning = true;
	autoCrateThread = task.spawn(function()
		while autoCrateRunning do
			local crates = cratesFolder:GetChildren();
			if (#crates > 0) then
				for _, crate in ipairs(crates) do
					if not autoCrateRunning then
						break;
					end
					if openCrate(crate) then
						WindUI:Notify({Title="自动开箱",Content=("已开启: " .. crate.Name),Duration=1.5});
						task.wait(0.5);
						ClaimLootEvent:InvokeServer(crate);
						task.wait(1);
					else
						task.wait(0.5);
					end
				end
			else
				task.wait(1);
			end
			task.wait(1);
		end
		autoCrateThread = nil;
	end);
	WindUI:Notify({Title="自动开箱开启",Content="已启动自动开箱",Duration=2});
end
featureTab:Toggle({Title="自动开箱",Desc="自动传送并打开地图上的箱子",Value=false,Callback=function(state)
	if state then
		startAutoCrate();
	else
		stopAutoCrate();
	end
end});
featureTab:Button({Title="拾取所有贝壳",Desc="自动找到所有岛屿上的贝壳并拾取",Callback=function()
	if not islandsFolder then
		WindUI:Notify({Title="错误",Content="未找到岛屿文件夹",Duration=3});
		return;
	end
	local total = 0;
	for _, island in ipairs(islandsFolder:GetChildren()) do
		if not island:IsA("Model") then
			continue;
		end
		local seashells = island:FindFirstChild("Objects") and island.Objects:FindFirstChild("Seashells");
		if not seashells then
			continue;
		end
		for _, shell in ipairs(seashells:GetChildren()) do
			local part = (shell:IsA("BasePart") and shell) or (shell:IsA("Model") and (shell:FindFirstChild("Base") or shell:FindFirstChildWhichIsA("BasePart")));
			if (part and part:FindFirstChildOfClass("ClickDetector")) then
				fireclickdetector(part:FindFirstChildOfClass("ClickDetector"));
				total = total + 1;
			end
		end
	end
	if (total == 0) then
		WindUI:Notify({Title="提示",Content="没有可拾取的贝壳",Duration=2});
	else
		WindUI:Notify({Title="拾取贝壳",Content=("已拾取 " .. total .. " 个贝壳"),Duration=2});
	end
end});
local attackTab = Window:Tab({Title="战斗&采集",Icon="swords",Locked=false});
local attackAuraRunning, attackAuraThread, attackRange = false, nil, 400;
local function getTargetType(model)
	if (model:GetAttribute("NPCHealth") ~= nil) then
		return "npc_attribute";
	elseif (model:FindFirstChildOfClass("Humanoid") and not plrs:GetPlayerFromCharacter(model)) then
		return "npc_humanoid";
	end
	if (npcsFolder and model:IsDescendantOf(npcsFolder)) then
		return "npc_humanoid";
	end
	return nil;
end
local function startAttackAura()
	if attackAuraRunning then
		return;
	end
	attackAuraRunning = true;
	attackAuraThread = task.spawn(function()
		while attackAuraRunning do
			if not LocalPlayer.Character:FindFirstChildOfClass("Tool") then
				equipAnyTool();
			end
			task.wait(0.1);
			if (attackAuraRunning and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then
				local myPos = LocalPlayer.Character.HumanoidRootPart.Position;
				local hitList = {};
				for _, obj in ipairs(workspace:GetDescendants()) do
					if not attackAuraRunning then
						break;
					end
					if obj:IsA("Model") then
						local root = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart;
						if (root and ((root.Position - myPos).Magnitude <= attackRange)) then
							local targetType = getTargetType(obj);
							if (targetType and not hitList[obj]) then
								hitList[obj] = true;
								counter = counter + 1;
								pcall(function()
									AxeHit:FireServer(obj, targetType, counter);
								end);
							end
						end
					end
				end
			end
		end
		attackAuraThread = nil;
	end);
	WindUI:Notify({Title="光环",Content="生物杀戮光环已开启",Duration=2});
end
local function stopAttackAura()
	attackAuraRunning = false;
	if attackAuraThread then
		attackAuraThread = nil;
	end
	WindUI:Notify({Title="光环",Content="生物杀戮光环已停止",Duration=2});
end
attackTab:Toggle({Title="生物杀戮光环",Desc="自动秒杀范围内的生物和敌人",Value=false,Callback=function(state)
	if state then
		startAttackAura();
	else
		stopAttackAura();
	end
end});
attackTab:Slider({Title="生物杀戮距离",Desc="调整杀戮范围",Step=10,Value={Min=50,Max=2000,Default=400},Callback=function(value)
	attackRange = value;
end});
local lumberAuraRunning, lumberAuraThread, lumberRange = false, nil, 400;
local function startLumberAura()
	if lumberAuraRunning then
		return;
	end
	lumberAuraRunning = true;
	lumberAuraThread = task.spawn(function()
		while lumberAuraRunning do
			if not LocalPlayer.Character:FindFirstChildOfClass("Tool") then
				equipAnyTool();
			end
			task.wait(0.1);
			if (lumberAuraRunning and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then
				local myPos = LocalPlayer.Character.HumanoidRootPart.Position;
				local hitTrees = {};
				for _, obj in ipairs(workspace:GetDescendants()) do
					if not lumberAuraRunning then
						break;
					end
					if (obj:IsA("Model") and (obj:GetAttribute("TreeHealth") ~= nil)) then
						local root = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart");
						if (root and ((root.Position - myPos).Magnitude <= lumberRange) and not hitTrees[obj]) then
							hitTrees[obj] = true;
							counter = counter + 1;
							pcall(function()
								AxeHit:FireServer(obj, "tree", counter);
							end);
						end
					end
				end
			end
		end
		lumberAuraThread = nil;
	end);
	WindUI:Notify({Title="光环",Content="伐木光环已开启",Duration=2});
end
local function stopLumberAura()
	lumberAuraRunning = false;
	if lumberAuraThread then
		lumberAuraThread = nil;
	end
	WindUI:Notify({Title="光环",Content="伐木光环已停止",Duration=2});
end
attackTab:Toggle({Title="伐木光环",Desc="自动砍伐范围内的树木",Value=false,Callback=function(state)
	if state then
		startLumberAura();
	else
		stopLumberAura();
	end
end});
attackTab:Slider({Title="伐木距离",Desc="调整伐木范围",Step=10,Value={Min=50,Max=2000,Default=400},Callback=function(value)
	lumberRange = value;
end});
local espTab = Window:Tab({Title="ESP透视",Icon="eye",Locked=false});
espTab:Toggle({Title="物品透视",Desc="显示地图上的掉落物",Value=false,Callback=function(state)
	itemESPEnabled = state;
	if state then
		refreshItemESP();
	else
		clearItemESP();
	end
end});
espTab:Toggle({Title="生物透视",Desc="显示动物和怪物位置",Value=false,Callback=function(state)
	npcESPEnabled = state;
	if state then
		refreshNPCESP();
	else
		clearNPCESP();
	end
end});
local envTab = Window:Tab({Title="环境与系统",Icon="settings",Locked=false});
envTab:Button({Title="除雾",Desc="移除大气层和天空雾气，提高视野",Callback=function()
	if lighting:FindFirstChild("Atmosphere") then
		lighting:FindFirstChild("Atmosphere"):Destroy();
	end
	if lighting:FindFirstChild("Sky") then
		lighting:FindFirstChild("Sky"):Destroy();
	end
	WindUI:Notify({Title="视觉",Content="已移除大气和天空效果",Duration=2});
end});
local origBrightness, origAmbient, origOutdoorAmbient, origFogEnd, origAtmoDensity = lighting.Brightness, lighting.Ambient, lighting.OutdoorAmbient, lighting.FogEnd, nil;
local atmosphere = lighting:FindFirstChild("Atmosphere");
if atmosphere then
	origAtmoDensity = atmosphere.Density;
end
envTab:Toggle({Title="夜视仪",Desc="黑暗环境下看清周围",Value=false,Callback=function(state)
	if state then
		origBrightness, origAmbient, origOutdoorAmbient, origFogEnd = lighting.Brightness, lighting.Ambient, lighting.OutdoorAmbient, lighting.FogEnd;
		if lighting:FindFirstChild("Atmosphere") then
			origAtmoDensity = lighting:FindFirstChild("Atmosphere").Density;
		end
		lighting.Brightness = 3;
		lighting.Ambient = Color3.new(1, 1, 1);
		lighting.OutdoorAmbient = Color3.new(1, 1, 1);
		lighting.FogEnd = 100000;
		if lighting:FindFirstChild("Atmosphere") then
			lighting:FindFirstChild("Atmosphere").Density = 0;
		end
	else
		lighting.Brightness, lighting.Ambient, lighting.OutdoorAmbient, lighting.FogEnd = origBrightness, origAmbient, origOutdoorAmbient, origFogEnd;
		if (lighting:FindFirstChild("Atmosphere") and origAtmoDensity) then
			lighting:FindFirstChild("Atmosphere").Density = origAtmoDensity;
		end
	end
end});
envTab:Button({Title="优化FPS",Desc="降低画质以大幅提升帧数",Callback=function()
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01;
	lighting.FogEnd = 8999999488;
	for _, v in ipairs(workspace:GetDescendants()) do
		if (v:IsA("Part") or v:IsA("MeshPart")) then
			v.Material = Enum.Material.SmoothPlastic;
			v.Reflectance = 0;
		elseif (v:IsA("Decal") or v:IsA("Texture")) then
			v.Transparency = 1;
		elseif (v:IsA("ParticleEmitter") or v:IsA("Trail")) then
			v.Enabled = false;
		end
	end
	WindUI:Notify({Title="优化",Content="已应用最低图形设置",Duration=2});
end});
local islandMonitorEnabled, latestIsland, islandMonitorConnection = false, nil, nil;
envTab:Toggle({Title="岛屿监测",Desc="当新岛屿刷新时发出提醒",Value=false,Callback=function(state)
	islandMonitorEnabled = state;
	if state then
		if not islandsFolder then
			WindUI:Notify({Title="错误",Content="未找到岛屿文件夹",Duration=3});
			return;
		end
		islandMonitorConnection = islandsFolder.ChildAdded:Connect(function(newIsland)
			latestIsland = newIsland;
			WindUI:Notify({Title="新岛屿刷新",Content=("发现新岛屿: " .. newIsland.Name),Duration=3});
		end);
		WindUI:Notify({Title="岛屿监测",Content="已启动监测",Duration=2});
	else
		if islandMonitorConnection then
			islandMonitorConnection:Disconnect();
			islandMonitorConnection = nil;
		end
		WindUI:Notify({Title="岛屿监测",Content="已关闭",Duration=2});
	end
end});
envTab:Button({Title="传送到最新岛屿",Desc="一键传送到刚刚刷新出的岛屿",Callback=function()
	if not islandMonitorEnabled then
		WindUI:Notify({Title="传送失败",Content="你还没有开启岛屿监测",Duration=2});
		return;
	end
	if (not latestIsland or not latestIsland.Parent) then
		WindUI:Notify({Title="传送失败",Content="尚未发现新岛屿",Duration=2});
		return;
	end
	teleportToInstance(latestIsland, 5);
	WindUI:Notify({Title="传送成功",Content=("已传送到 " .. latestIsland.Name),Duration=2});
end});
Window:SelectTab(1);
