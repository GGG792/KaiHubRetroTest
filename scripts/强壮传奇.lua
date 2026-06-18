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
local MainTab = Window:Tab({Title="主要功能",Icon="home"});
Window:SelectTab(1);
local TeleportTab = Window:Tab({Title="区域传送",Icon="map-pin"});
local function TPTo(cframe)
	local char = LocalPlayer.Character;
	if (char and char:FindFirstChild("HumanoidRootPart")) then
		char.HumanoidRootPart.CFrame = cframe;
	end
end
getgenv().autoEat = false;
getgenv().autoPunch = false;
MainTab:Section({Title="物品使用"});
MainTab:Toggle({Title="自动吃食物",Desc="mua",Value=false,Callback=function(Value)
	getgenv().autoEat = Value;
	if Value then
		WindUI:Notify({Title="已开启",Content="开始循环吃食物",Duration=1.5,Icon="utensils"});
		task.spawn(function()
			while getgenv().autoEat do
				local args = {"Food"};
				local remoteFolder = ReplicatedStorage:FindFirstChild("Remotes");
				local useToolRemote = remoteFolder and remoteFolder:FindFirstChild("UseTool");
				if useToolRemote then
					useToolRemote:FireServer(unpack(args));
				end
				task.wait(0.1);
			end
		end);
	else
		WindUI:Notify({Title="已关闭",Content="停止吃食物",Duration=1.5,Icon="ban"});
	end
end});
MainTab:Toggle({Title="自动出拳",Desc="(*╯3╰)",Value=false,Callback=function(Value)
	getgenv().autoPunch = Value;
	if Value then
		WindUI:Notify({Title="已开启",Content="开始自动出拳",Duration=1.5,Icon="swords"});
		task.spawn(function()
			while getgenv().autoPunch do
				local args = {"Punch"};
				local remoteFolder = ReplicatedStorage:FindFirstChild("Remotes");
				local useToolRemote = remoteFolder and remoteFolder:FindFirstChild("UseTool");
				if useToolRemote then
					useToolRemote:FireServer(unpack(args));
				end
				task.wait(0.05);
			end
		end);
	else
		WindUI:Notify({Title="已关闭",Content="停止自动出拳",Duration=1.5,Icon="ban"});
	end
end});
MainTab:Section({Title="卖卖卖"});
MainTab:Button({Title="一键出售",Desc="点一下四个姆",Callback=function()
	local remotes = ReplicatedStorage:FindFirstChild("Remotes");
	if remotes then
		local sellRemote = remotes:FindFirstChild("YieldSell");
		if sellRemote then
			sellRemote:InvokeServer();
			WindUI:Notify({Title="操作成功",Content="已发送出售请求",Duration=1.5,Icon="wallet"});
		else
			WindUI:Notify({Title="错误",Content="找不到 YieldSell 远程事件",Duration=2,Icon="alert-triangle"});
		end
	end
end});
TeleportTab:Section({Title="地图传送"});
TeleportTab:Button({Title="草地",Desc="传送至: 草地区域",Callback=function()
	TPTo(CFrame.new(669.74, 1663.37, 2057.84));
	WindUI:Notify({Title="已传送",Content="到达草地",Duration=1});
end});
TeleportTab:Button({Title="面包沙漠",Desc="传送至: 面包沙漠区域",Callback=function()
	TPTo(CFrame.new(752.24, 3245.06, 2065.55));
	WindUI:Notify({Title="已传送",Content="到达面包沙漠",Duration=1});
end});
TeleportTab:Button({Title="冰淇淋冻原",Desc="传送至: 冰淇淋冻原区域",Callback=function()
	TPTo(CFrame.new(670.38, 5908.3, 2053.08));
	WindUI:Notify({Title="已传送",Content="到达冰淇淋冻原",Duration=1});
end});
TeleportTab:Button({Title="披萨荒地",Desc="传送至: 披萨荒地区域",Callback=function()
	TPTo(CFrame.new(735.56, 9126.32, 2092.39));
	WindUI:Notify({Title="已传送",Content="到达披萨荒地",Duration=1});
end});
TeleportTab:Button({Title="水晶糖果乐园",Desc="传送至: 水晶糖果乐园区域",Callback=function()
	TPTo(CFrame.new(709.12, 16551.85, 2015.62));
	WindUI:Notify({Title="已传送",Content="到达水晶糖果乐园",Duration=1});
end});
TeleportTab:Button({Title="巧克力王国",Desc="传送至: 巧克力王国区域",Callback=function()
	TPTo(CFrame.new(725.8, 21874.14, 2081.2));
	WindUI:Notify({Title="已传送",Content="到达巧克力王国",Duration=1});
end});
TeleportTab:Button({Title="蘑菇绿洲",Desc="传送至: 蘑菇绿洲区域",Callback=function()
	TPTo(CFrame.new(677.88, 30255.02, 2047.93));
	WindUI:Notify({Title="已传送",Content="到达蘑菇绿洲",Duration=1});
end});
