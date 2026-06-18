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
local FishingTab = Window:Tab({Title="功能",Icon="waves"});
FishingTab:Section({Title="自动挂机"});
FishingTab:Toggle({Title="自动抓捕",Callback=function(state)
	getgenv().AutoFish = state;
	task.spawn(function()
		while getgenv().AutoFish do
			game:GetService("ReplicatedStorage").CloudFrameShared.DataStreams.FishCaught:FireServer();
			task.wait(2.6);
		end
	end);
end});
FishingTab:Toggle({Title="自动售卖",Callback=function(state)
	getgenv().AutoSell = state;
	task.spawn(function()
		while getgenv().AutoSell do
			game:GetService("ReplicatedStorage").CloudFrameShared.DataStreams.processGameItemSold:InvokeServer("SellEverything");
			task.wait(2.6);
		end
	end);
end});
FishingTab:Section({Title="宝箱采集"});
FishingTab:Toggle({Title="自动每日宝箱",Callback=function(state)
	getgenv().DailyChest = state;
	task.spawn(function()
		while getgenv().DailyChest do
			for _, v in pairs(game.Workspace.Islands:GetDescendants()) do
				if (v:IsA("Model") and string.match(v.Name, "Chest") and v:FindFirstChild("HumanoidRootPart")) then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame;
					task.wait(0.5);
					fireproximityprompt(v.HumanoidRootPart.ProximityPrompt);
				end
			end
			task.wait(1);
		end
	end);
end});
FishingTab:Toggle({Title="自动随机宝箱",Callback=function(state)
	getgenv().RandomChest = state;
	task.spawn(function()
		while getgenv().RandomChest do
			for _, v in pairs(game.Workspace.RandomChests:GetDescendants()) do
				if (v:IsA("Model") and string.match(v.Name, "Chest") and v:FindFirstChild("HumanoidRootPart")) then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame;
					task.wait(0.5);
					fireproximityprompt(v.HumanoidRootPart.ProximityPrompt);
				end
			end
			task.wait(1);
		end
	end);
end});
local PlayerTab = Window:Tab({Title="玩家属性",Icon="user"});
PlayerTab:Section({Title="数值调节"});
PlayerTab:Slider({Title="步行速度",Min=16,Max=400,Default=16,Callback=function(v)
	task.spawn(function()
		while task.wait() do
			if (game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")) then
				game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v;
			end
		end
	end);
end});
PlayerTab:Slider({Title="跳跃高度",Min=50,Max=400,Default=50,Callback=function(v)
	task.spawn(function()
		while task.wait() do
			if (game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")) then
				game.Players.LocalPlayer.Character.Humanoid.JumpPower = v;
			end
		end
	end);
end});
PlayerTab:Slider({Title="修改重力",Min=0,Max=1000,Default=196.2,Callback=function(v)
	game.Workspace.Gravity = v;
end});
PlayerTab:Section({Title="动作开关"});
PlayerTab:Toggle({Title="无限跳",Callback=function(state)
	getgenv().InfJump = state;
	game:GetService("UserInputService").JumpRequest:Connect(function()
		if getgenv().InfJump then
			game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping");
		end
	end);
end});
PlayerTab:Button({Title="汉化穿墙",Callback=function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/TtmScripter/OtherScript/main/Noclip"))();
end});
PlayerTab:Button({Title="飞行模式",Callback=function()
	loadstring(game:HttpGet("https://pastefy.app/J9x7RnEZ/raw"))();
end});
PlayerTab:Button({Title="自杀",Callback=function()
	game.Players.LocalPlayer.Character.Humanoid.Health = 0;
end});
local ToolTab = Window:Tab({Title="其他功能",Icon="eye"});
ToolTab:Section({Title="透视功能"});
ToolTab:Button({Title="玩家高亮 ESP",Callback=function()
	local function ApplyESP(v)
		if (v.Character and not v.Character:FindFirstChild("Highlight")) then
			local hl = Instance.new("Highlight", v.Character);
			hl.FillTransparency = 0.5;
			hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
		end
	end
	for _, p in pairs(game.Players:GetPlayers()) do
		ApplyESP(p);
	end
	game.Players.PlayerAdded:Connect(ApplyESP);
end});
ToolTab:Toggle({Title="显示玩家名字",Callback=function(enabled)
	_G.ESPName = enabled;
	if enabled then
		task.spawn(function()
			while _G.ESPName do
				for _, player in ipairs(game.Players:GetPlayers()) do
					if (player.Character and player.Character:FindFirstChildOfClass("Humanoid")) then
						player.Character.Humanoid.NameDisplayDistance = 8999999488;
						player.Character.Humanoid.HealthDisplayDistance = 8999999488;
						player.Character.Humanoid.HealthDisplayType = "AlwaysOn";
					end
				end
				task.wait(1);
			end
		end);
	end
end});
ToolTab:Section({Title="场景"});
ToolTab:Toggle({Title="夜视模式",Callback=function(state)
	game.Lighting.Ambient = (state and Color3.new(1, 1, 1)) or Color3.new(0, 0, 0);
end});
ToolTab:Toggle({Title="自动互动",Callback=function(state)
	getgenv().AutoInteract = state;
	task.spawn(function()
		while getgenv().AutoInteract do
			for _, descendant in pairs(workspace:GetDescendants()) do
				if descendant:IsA("ProximityPrompt") then
					fireproximityprompt(descendant);
				end
			end
			task.wait(0.25);
		end
	end);
end});
ToolTab:Button({Title="反挂机",Callback=function()
	loadstring(game:HttpGet("https://pastebin.com/raw/9fFu43FF"))();
end});
ToolTab:Button({Title="玩家加入提示",Callback=function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua"))();
end});
WindUI:Notify({Title="杨志卡脚本",Content="脚本加载成功！杨志卡祝您游玩愉快。",Duration=5,Icon="info"});
Window:SelectTab(1);
