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
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Remotes = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlayerCharacter"):WaitForChild("Request");
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local lightLoopEnabled = false;
local heavyLoopEnabled = false;
local sudu = nil;
local Speed = 1;
local hitboxEnabled = false;
local noCollisionEnabled = false;
local hitbox_original_properties = {};
local hitboxSize = 21;
local hitboxTransparency = 6;
local defaultBodyParts = {"UpperTorso","Head","HumanoidRootPart"};
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer.PlayerGui);
local WarningText = Instance.new("TextLabel", ScreenGui);
WarningText.Size = UDim2.new(0, 200, 0, 50);
WarningText.TextSize = 16;
WarningText.Position = UDim2.new(0.5, -150, 0, 0);
WarningText.Text = "";
WarningText.TextColor3 = Color3.new(1, 0, 0);
WarningText.BackgroundTransparency = 1;
WarningText.Visible = false;
local Tabs = {};
local CombatTab = Window:Tab({Title="杀戮",Icon="sword"});
local PlayerTab = Window:Tab({Title="格挡",Icon="crown"});
local HitboxTab = Window:Tab({Title="暴力",Icon="shield"});
Window:SelectTab(1);
do
	CombatTab:Button({Title="轻击",Desc="执行轻攻击",Callback=function()
		local remote = Remotes:FindFirstChild("QueueBasicAttack");
		if remote then
			remote:FireServer("26", "Katana", "Light01");
		end
	end});
	CombatTab:Button({Title="重击",Desc="执行重攻击",Callback=function()
		local remote = Remotes:FindFirstChild("QueueBasicAttack");
		if remote then
			remote:FireServer("26", "Katana", "Heavy01");
		end
	end});
end
CombatTab:Toggle({Title="轻击杀戮",Value=false,Callback=function(state)
	lightLoopEnabled = state;
	if state then
		task.spawn(function()
			while lightLoopEnabled do
				if (LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then
					local myPos = LocalPlayer.Character.HumanoidRootPart.Position;
					for _, player in ipairs(Players:GetPlayers()) do
						if ((player ~= LocalPlayer) and player.Character and player.Character:FindFirstChild("HumanoidRootPart")) then
							if ((myPos - player.Character.HumanoidRootPart.Position).Magnitude <= 11) then
								local remote = Remotes:FindFirstChild("QueueBasicAttack");
								if remote then
									remote:FireServer("26", "Katana", "Light01");
								end
								break;
							end
						end
					end
				end
				task.wait(0.25);
			end
		end);
	end
end});
CombatTab:Toggle({Title="重击杀戮",Value=false,Callback=function(state)
	heavyLoopEnabled = state;
	if state then
		task.spawn(function()
			while heavyLoopEnabled do
				if (LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then
					local myPos = LocalPlayer.Character.HumanoidRootPart.Position;
					for _, player in ipairs(Players:GetPlayers()) do
						if ((player ~= LocalPlayer) and player.Character and player.Character:FindFirstChild("HumanoidRootPart")) then
							if ((myPos - player.Character.HumanoidRootPart.Position).Magnitude <= 11) then
								local remote = Remotes:FindFirstChild("QueueBasicAttack");
								if remote then
									remote:FireServer("26", "Katana", "Heavy01");
								end
								break;
							end
						end
					end
				end
				task.wait(0.36);
			end
		end);
	end
end});
local RunService = game:GetService("RunService");
local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes");
local lightConnection = nil;
local lastLightTime = 0;
local lightInterval = 0.5;
CombatTab:Toggle({Title="强制轻击杀戮[当普通无用时]",Value=false,Callback=function(state)
	if state then
		lightConnection = RunService.Heartbeat:Connect(function()
			if ((tick() - lastLightTime) >= lightInterval) then
				local remote = Remotes:FindFirstChild("QueueBasicAttack");
				if remote then
					remote:FireServer("26", "Katana", "Light01");
				end
				lastLightTime = tick();
			end
		end);
	elseif lightConnection then
		lightConnection:Disconnect();
		lightConnection = nil;
	end
end});
local RunService = game:GetService("RunService");
local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes");
local heavyConnection = nil;
local lastHeavyTime = 0;
local heavyInterval = 0.5;
CombatTab:Toggle({Title="强制重击杀戮[当普通无用时]",Value=false,Callback=function(state)
	if state then
		heavyConnection = RunService.Heartbeat:Connect(function()
			if ((tick() - lastHeavyTime) >= heavyInterval) then
				local remote = Remotes:FindFirstChild("QueueBasicAttack");
				if remote then
					remote:FireServer("26", "Katana", "Heavy01");
				end
				lastHeavyTime = tick();
			end
		end);
	elseif heavyConnection then
		heavyConnection:Disconnect();
		heavyConnection = nil;
	end
end});
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local localPlayer = Players.LocalPlayer;
local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlayerCharacter"):WaitForChild("Request"):WaitForChild("QueueJump");
local jumpConnection = nil;
local jumpCooldown = 0.5;
local lastJumpTime = 0;
local previousDistances = {};
PlayerTab:Toggle({Title="自动跳跃躲避攻击",Value=false,Callback=function(state)
	if state then
		jumpConnection = RunService.Heartbeat:Connect(function()
			local character = localPlayer.Character;
			if (not character or not character.PrimaryPart) then
				return;
			end
			local root = character.PrimaryPart;
			local currentPos = root.Position;
			for _, player in ipairs(Players:GetPlayers()) do
				if (player ~= localPlayer) then
					local char = player.Character;
					if (char and char.PrimaryPart) then
						local targetRoot = char.PrimaryPart;
						local dist = (targetRoot.Position - currentPos).Magnitude;
						local prevDist = previousDistances[player];
						if (prevDist and (dist < prevDist)) then
							if ((tick() - lastJumpTime) > jumpCooldown) then
								local args = {"34",Vector3.zero,1};
								remote:FireServer(unpack(args));
								lastJumpTime = tick();
							end
						end
						previousDistances[player] = dist;
					else
						previousDistances[player] = nil;
					end
				end
			end
		end);
	elseif jumpConnection then
		jumpConnection:Disconnect();
		jumpConnection = nil;
		previousDistances = {};
	end
end});
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local localPlayer = Players.LocalPlayer;
local teleportConnection = nil;
local teleportDistance = 2.5;
local teleportCooldown = 1;
local lastTeleportTime = 0;
local function findNearestPlayer()
	local character = localPlayer.Character;
	if (not character or not character.PrimaryPart) then
		return nil, math.huge;
	end
	local root = character.PrimaryPart;
	local currentPos = root.Position;
	local nearestPlayer = nil;
	local nearestDist = math.huge;
	for _, player in ipairs(Players:GetPlayers()) do
		if (player ~= localPlayer) then
			local char = player.Character;
			if (char and char.PrimaryPart) then
				local dist = (char.PrimaryPart.Position - currentPos).Magnitude;
				if (dist < nearestDist) then
					nearestDist = dist;
					nearestPlayer = player;
				end
			end
		end
	end
	return nearestPlayer, nearestDist;
end
local function teleportBehind(player)
	if not player then
		return;
	end
	local char = player.Character;
	if (not char or not char.PrimaryPart) then
		return;
	end
	local targetRoot = char.PrimaryPart;
	local targetCFrame = targetRoot.CFrame;
	local behindPos = targetCFrame.Position - (targetCFrame.LookVector * teleportDistance);
	local localChar = localPlayer.Character;
	if (localChar and localChar.PrimaryPart) then
		localChar.PrimaryPart.Position = behindPos;
	end
end
PlayerTab:Toggle({Title="自动传送躲避攻击",Value=false,Callback=function(state)
	if state then
		teleportConnection = RunService.Heartbeat:Connect(function()
			local nearestPlayer = findNearestPlayer();
			if (nearestPlayer and ((tick() - lastTeleportTime) > teleportCooldown)) then
				teleportBehind(nearestPlayer);
				lastTeleportTime = tick();
			end
		end);
	elseif teleportConnection then
		teleportConnection:Disconnect();
		teleportConnection = nil;
	end
end});
local function savedPart(player, part)
	if not hitbox_original_properties[player] then
		hitbox_original_properties[player] = {};
	end
	if not hitbox_original_properties[player][part.Name] then
		hitbox_original_properties[player][part.Name] = {CanCollide=part.CanCollide,Transparency=part.Transparency,Size=part.Size};
	end
end
local function restoredPart(player)
	if hitbox_original_properties[player] then
		for partName, properties in pairs(hitbox_original_properties[player]) do
			local part = player.Character and player.Character:FindFirstChild(partName);
			if (part and part:IsA("BasePart")) then
				part.CanCollide = properties.CanCollide;
				part.Transparency = properties.Transparency;
				part.Size = properties.Size;
			end
		end
	end
end
local function findClosestPart(player, partName)
	if not player.Character then
		return nil;
	end
	for _, part in ipairs(player.Character:GetChildren()) do
		if (part:IsA("BasePart") and part.Name:lower():match(partName:lower())) then
			return part;
		end
	end
	return nil;
end
local function extendHitbox(player)
	for _, partName in ipairs(defaultBodyParts) do
		local part = player.Character and (player.Character:FindFirstChild(partName) or findClosestPart(player, partName));
		if (part and part:IsA("BasePart")) then
			savedPart(player, part);
			part.CanCollide = not noCollisionEnabled;
			part.Transparency = hitboxTransparency / 10;
			part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize);
		end
	end
end
local function isEnemy(player)
	return true;
end
local function shouldExtendHitbox(player)
	return isEnemy(player);
end
local function updateHitboxes()
	for _, v in ipairs(Players:GetPlayers()) do
		if ((v ~= LocalPlayer) and v.Character and v.Character:FindFirstChild("HumanoidRootPart")) then
			if shouldExtendHitbox(v) then
				extendHitbox(v);
			else
				restoredPart(v);
			end
		end
	end
end
local function onCharacterAdded(character)
	task.wait(0.1);
	if hitboxEnabled then
		updateHitboxes();
	end
end
local function onPlayerAdded(player)
	player.CharacterAdded:Connect(onCharacterAdded);
	player.CharacterRemoving:Connect(function()
		restoredPart(player);
		hitbox_original_properties[player] = nil;
	end);
end
local function checkForDeadPlayers()
	for player, _ in pairs(hitbox_original_properties) do
		if (not player.Parent or not player.Character or not player.Character:IsDescendantOf(game)) then
			restoredPart(player);
			hitbox_original_properties[player] = nil;
		end
	end
end
Players.PlayerAdded:Connect(onPlayerAdded);
for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player);
end
HitboxTab:Button({Title="点击此处启动Hitbox功能",Callback=function()
	coroutine.wrap(function()
		while true do
			if hitboxEnabled then
				updateHitboxes();
				checkForDeadPlayers();
			end
			task.wait(0.1);
		end
	end)();
end});
HitboxTab:Toggle({Title="开启Hitbox",Value=false,Callback=function(state)
	hitboxEnabled = state;
	if not state then
		for _, player in ipairs(Players:GetPlayers()) do
			restoredPart(player);
		end
		hitbox_original_properties = {};
	else
		updateHitboxes();
	end
end});
HitboxTab:Slider({Title="Hitbox大小",Value={Min=1,Max=25,Default=21},Callback=function(value)
	hitboxSize = value;
	if hitboxEnabled then
		updateHitboxes();
	end
end});
HitboxTab:Slider({Title="Hitbox透明度",Value={Min=1,Max=10,Default=6},Callback=function(value)
	hitboxTransparency = value;
	if hitboxEnabled then
		updateHitboxes();
	end
end});
HitboxTab:Toggle({Title="无碰撞",Value=false,Callback=function(state)
	noCollisionEnabled = state;
	WarningText.Visible = state;
	coroutine.wrap(function()
		while noCollisionEnabled do
			if hitboxEnabled then
				updateHitboxes();
			end
			task.wait(0.01);
		end
		if hitboxEnabled then
			updateHitboxes();
		end
	end)();
end});
