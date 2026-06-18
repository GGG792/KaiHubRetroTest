local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local lplr = Players.LocalPlayer;
getgenv().AutoLootTeleport = false;
getgenv().KillAll = false;
getgenv().AutoBreakFree = false;
getgenv().ESP_Enabled = false;
local function ApplyESP(plr)
	if (plr == lplr) then
		return;
	end
	local function update()
		local char = plr.Character;
		if not char then
			return;
		end
		local highlight = char:FindFirstChild("TaffyHighlight");
		if not highlight then
			highlight = Instance.new("Highlight");
			highlight.Name = "TaffyHighlight";
			highlight.Parent = char;
		end
		highlight.FillColor = Color3.fromRGB(255, 50, 50);
		highlight.FillTransparency = 0.6;
		highlight.OutlineTransparency = 0.2;
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
		highlight.Enabled = getgenv().ESP_Enabled;
		local nameTag = char:FindFirstChild("TaffyNameTag");
		if not nameTag then
			nameTag = Instance.new("BillboardGui");
			nameTag.Name = "TaffyNameTag";
			nameTag.Size = UDim2.new(0, 100, 0, 30);
			nameTag.AlwaysOnTop = true;
			nameTag.StudsOffset = Vector3.new(0, 2.2, 0);
			local textLabel = Instance.new("TextLabel");
			textLabel.Parent = nameTag;
			textLabel.BackgroundTransparency = 1;
			textLabel.Size = UDim2.new(1, 0, 1, 0);
			textLabel.Font = Enum.Font.GothamMedium;
			textLabel.TextColor3 = Color3.new(1, 1, 1);
			textLabel.TextSize = 10;
			textLabel.TextStrokeTransparency = 0.3;
			textLabel.TextStrokeColor3 = Color3.new(0, 0, 0);
			nameTag.Parent = char;
		end
		local label = nameTag:FindFirstChildOfClass("TextLabel");
		if label then
			local myRoot = lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart");
			local targetRoot = char:FindFirstChild("HumanoidRootPart");
			local dist = (myRoot and targetRoot and math.floor((targetRoot.Position - myRoot.Position).Magnitude)) or 0;
			label.Text = plr.Name .. " [" .. dist .. "m]";
			label.Visible = getgenv().ESP_Enabled;
		end
	end
	task.spawn(function()
		while plr and plr.Parent do
			pcall(update);
			task.wait(0.5);
		end
	end);
end
for _, player in pairs(Players:GetPlayers()) do
	ApplyESP(player);
end
Players.PlayerAdded:Connect(ApplyESP);
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
local function teleportToPosition(position)
	local char = lplr.Character;
	local hrp = char and char:FindFirstChild("HumanoidRootPart");
	if not hrp then
		return;
	end
	local tween = TweenService:Create(hrp, TweenInfo.new(0.3), {CFrame=CFrame.new(position)});
	tween:Play();
	tween.Completed:Wait();
end
local CombatTab = Window:Tab({Title="功能",Icon="swords"});
Window:SelectTab(1);
CombatTab:Toggle({Title="自动寻找物品",Value=false,Callback=function(state)
	getgenv().AutoLootTeleport = state;
	if state then
		WindUI:Notify({Title="自动传送",Content="开始传送物品",Duration=2});
		task.spawn(function()
			while getgenv().AutoLootTeleport do
				local foundAny = false;
				for _, child in ipairs(Workspace:GetChildren()) do
					if not getgenv().AutoLootTeleport then
						break;
					end
					if (child:IsA("Model") or child:IsA("Folder")) then
						local lootSpawns = child:FindFirstChild("LootSpawns");
						if lootSpawns then
							foundAny = true;
							for _, lootModel in ipairs(lootSpawns:GetChildren()) do
								if not getgenv().AutoLootTeleport then
									break;
								end
								local targetPos = (lootModel:IsA("Model") and ((lootModel.PrimaryPart and lootModel.PrimaryPart.Position) or lootModel:GetBoundingBox().Position)) or (lootModel:IsA("BasePart") and lootModel.Position);
								if targetPos then
									teleportToPosition(targetPos);
									task.wait(0.5);
								end
							end
						end
					end
				end
				task.wait((foundAny and 2) or 5);
			end
		end);
	end
end});
CombatTab:Toggle({Title="全图杀戮",Value=false,Callback=function(state)
	getgenv().KillAll = state;
	if state then
		WindUI:Notify({Title="杀戮开启",Content="正在自动锁定所有玩家",Duration=2});
		task.spawn(function()
			while getgenv().KillAll do
				local knife = lplr.Character and lplr.Character:FindFirstChild("Knife");
				local event = knife and knife:FindFirstChild("KnifeSlashEvent");
				if event then
					event:FireServer();
				end
				task.wait(0.1);
			end
		end);
		task.spawn(function()
			while getgenv().KillAll do
				for _, targetPlayer in ipairs(Players:GetPlayers()) do
					if not getgenv().KillAll then
						break;
					end
					if ((targetPlayer ~= lplr) and targetPlayer.Character) then
						local rootPart = lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart");
						local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart");
						if (rootPart and targetRoot) then
							rootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 2, 0);
							task.wait(0.5);
						end
					end
				end
				task.wait(0.1);
			end
		end);
	end
end});
CombatTab:Toggle({Title="自动解陷阱",Value=false,Callback=function(state)
	getgenv().AutoBreakFree = state;
	if state then
		task.spawn(function()
			local breakFreeEvent = ReplicatedStorage:FindFirstChild("BreakFree");
			while getgenv().AutoBreakFree do
				if breakFreeEvent then
					breakFreeEvent:FireServer();
				end
				task.wait(0.1);
			end
		end);
	end
end});
local VisualsTab = Window:Tab({Title="esp",Icon="eye"});
VisualsTab:Toggle({Title="透视",Value=false,Callback=function(state)
	getgenv().ESP_Enabled = state;
	if state then
		WindUI:Notify({Title="透视",Content="🉑看到所有玩家",Duration=2});
	end
end});
Window:SelectTab(1);
WindUI:Notify({Title="加载成功",Content="塔菲喵",Duration=3});
