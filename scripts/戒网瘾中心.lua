local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Yisan886/Aero/refs/heads/main/ui.lua.txt"))();
WindUI:AddTheme({Name="My Theme",Accent=Color3.fromHex("#18181b"),Background=Color3.fromHex("#101010"),Outline=Color3.fromHex("#FFFFFF"),Text=Color3.fromHex("#FFFFFF"),Placeholder=Color3.fromHex("#7a7a7a"),Button=Color3.fromHex("#52525b"),Icon=Color3.fromHex("#a1a1aa")});
local Window = WindUI:CreateWindow({Title="Aero      ",Folder="Aero",SideBarWidth=180,Background="https://chaton-images.s3.us-east-2.amazonaws.com/GHn9L9UJLf0XcVNyCpbG72D0rmNmBEWndPkh6CjJNya8GLnWzz1vImvt8wlJSBwv_2700x1519x1393696.jpeg",BackgroundImageTransparency=0.5,OpenButton={Title="打开脚本",CornerRadius=UDim.new(1, 0),StrokeThickness=3,Enabled=true,Draggable=true,OnlyMobile=false,Scale=0.9,Color=ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f"))},Topbar={Height=44,ButtonsType="Mac"}});
Window:Tag({Title="V1.03",Color=Color3.fromHex("00CED1"),Radius=2});
Window:Tag({Title="杨志卡",Icon="crown",Color=Color3.fromHex("FFD700"),Radius=2});
Window:Tag({Title="杨志卡",Icon="square-chevron-right",Color=Color3.fromHex("#30ff6a"),Radius=2});
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Lighting = game:GetService("Lighting");
local TweenService = game:GetService("TweenService");
local LocalPlayer = Players.LocalPlayer;
local CombatEnabled = false;
local targetCount = 1;
local WalkSpeedValue = 16;
local RandomFollowEnabled = false;
local currentTarget = nil;
local followDistance = 4;
local orbitSpeed = 20;
local function getAllNilInstances(name, class)
	local found = {};
	if getnilinstances then
		for _, v in next, getnilinstances() do
			if ((v.Name == name) and (not class or (v.ClassName == class))) then
				table.insert(found, v);
			end
		end
	end
	return found;
end
local function getNearestPlayers(count)
	local targetList = {};
	local lChar = LocalPlayer.Character;
	local lRoot = lChar and lChar:FindFirstChild("HumanoidRootPart");
	if not lRoot then
		return targetList;
	end
	local playersWithDist = {};
	for _, player in pairs(Players:GetPlayers()) do
		if ((player ~= LocalPlayer) and player.Character) then
			local root = player.Character:FindFirstChild("HumanoidRootPart");
			if root then
				local distance = (lRoot.Position - root.Position).Magnitude;
				table.insert(playersWithDist, {player=player,dist=distance,root=root});
			end
		end
	end
	table.sort(playersWithDist, function(a, b)
		return a.dist < b.dist;
	end);
	for i = 1, math.min(count, #playersWithDist) do
		table.insert(targetList, playersWithDist[i]);
	end
	return targetList;
end
local function getRandomPlayer()
	local allPlayers = Players:GetPlayers();
	local eligiblePlayers = {};
	for _, p in pairs(allPlayers) do
		if ((p ~= LocalPlayer) and p.Character and p.Character:FindFirstChild("HumanoidRootPart")) then
			table.insert(eligiblePlayers, p);
		end
	end
	if (#eligiblePlayers > 0) then
		return eligiblePlayers[math.random(1, #eligiblePlayers)];
	else
		return nil;
	end
end
local Tab = Window:Tab({Title="主要功能",Icon="sparkles"});
Window:SelectTab(1);
Tab:Toggle({Title="杀戮光环",Value=false,Callback=function(state)
	CombatEnabled = state;
end});
Tab:Toggle({Title="传送全部人",Value=false,Callback=function(state)
	RandomFollowEnabled = state;
	if not state then
		currentTarget = nil;
	end
end});
Tab:Button({Title="删除教学楼大门",Callback=function()
	local school = workspace:FindFirstChild("\229\173\166\230\160\161");
	local building = school and school:FindFirstChild("\230\149\153\229\173\166\230\165\188");
	local door = building and building:FindFirstChild("\230\149\153\229\173\166\230\165\188\229\164\167\233\151\168");
	if door then
		door:Destroy();
	end
end});
Tab:Button({Title="删除二号小门",Callback=function()
	local school = workspace:FindFirstChild("\229\173\166\230\160\161");
	local exitGate = school and school:FindFirstChild("\229\135\186\229\133\165\229\143\163\229\164\167\233\151\168");
	local smallGate = exitGate and exitGate:FindFirstChild("\228\186\140\229\143\183\229\176\143\233\151\168");
	if smallGate then
		smallGate:Destroy();
	end
end});
task.spawn(function()
	while true do
		task.wait(0.3);
		local char = LocalPlayer.Character;
		local hum = char and char:FindFirstChildOfClass("Humanoid");
		if (hum and (hum.WalkSpeed ~= WalkSpeedValue)) then
			hum.WalkSpeed = WalkSpeedValue;
		end
		if CombatEnabled then
			if hum then
				local equippedTool = char:FindFirstChildOfClass("Tool");
				if not equippedTool then
					local backpack = LocalPlayer:FindFirstChild("Backpack");
					local firstTool = backpack and backpack:FindFirstChildOfClass("Tool");
					if firstTool then
						hum:EquipTool(firstTool);
					end
				end
			end
			local targets = getNearestPlayers(targetCount);
			local nilParts = getAllNilInstances("Part", "Part");
			if (#targets > 0) then
				local character = LocalPlayer.Character;
				local fist = (character and character:FindFirstChild("\230\139\179\229\164\180")) or character:FindFirstChildOfClass("Tool");
				for i, part in ipairs(nilParts) do
					local targetData = targets[(i % #targets) + 1];
					if (targetData and targetData.root) then
						if part:IsA("BasePart") then
							part.CFrame = targetData.root.CFrame;
						elseif part:IsA("Model") then
							part:SetPrimaryPartCFrame(targetData.root.CFrame);
						end
					end
				end
				if (fist and fist:FindFirstChild("Attack")) then
					for _, targetData in ipairs(targets) do
						fist.Attack:FireServer(targetData.player);
					end
				end
			end
		end
	end
end);
RunService.Stepped:Connect(function()
	if (RandomFollowEnabled and LocalPlayer.Character) then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false;
			end
		end
	end
end);
task.spawn(function()
	while true do
		if RandomFollowEnabled then
			local nextPlayer = getRandomPlayer();
			if nextPlayer then
				currentTarget = nextPlayer;
			end
			task.wait(4);
		else
			task.wait(0.5);
		end
	end
end);
local gradient = nil;
RunService.Heartbeat:Connect(function()
	if (RandomFollowEnabled and currentTarget and currentTarget.Character) then
		local targetRoot = currentTarget.Character:FindFirstChild("HumanoidRootPart");
		local myCharacter = LocalPlayer.Character;
		local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart");
		if (targetRoot and myRoot) then
			local t = tick() * orbitSpeed;
			local offsetX = math.cos(t) * followDistance;
			local offsetZ = math.sin(t) * followDistance;
			local orbitPosition = targetRoot.Position + Vector3.new(offsetX, 0, offsetZ);
			myRoot.CFrame = CFrame.new(orbitPosition, targetRoot.Position);
		end
	end
	if gradient then
		gradient.Rotation = (tick() * 50) % 360;
	end
end);
local blur = Lighting:FindFirstChildOfClass("BlurEffect") or Instance.new("BlurEffect", Lighting);
task.spawn(function()
	local wasOpen = false;
	while true do
		task.wait(0.1);
		local mainFrame = Window.UIElements and Window.UIElements.Main;
		local isOpen = (mainFrame and mainFrame.Visible) or false;
		if (isOpen ~= wasOpen) then
			wasOpen = isOpen;
			TweenService:Create(blur, TweenInfo.new(0.3), {Size=((isOpen and 20) or 0)}):Play();
		end
	end
end);
local function createRainbowBorder(window)
	local mainFrame = window.UIElements.Main;
	if not mainFrame then
		return;
	end
	local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke") or Instance.new("UIStroke");
	rainbowStroke.Name = "RainbowStroke";
	rainbowStroke.Thickness = 2;
	rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
	rainbowStroke.Parent = mainFrame;
	local glowEffect = rainbowStroke:FindFirstChild("GlowEffect") or Instance.new("UIGradient");
	glowEffect.Name = "GlowEffect";
	glowEffect.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("00FF00")),ColorSequenceKeypoint.new(1, Color3.fromHex("0000FF"))});
	glowEffect.Parent = rainbowStroke;
	return glowEffect;
end
gradient = createRainbowBorder(Window);
