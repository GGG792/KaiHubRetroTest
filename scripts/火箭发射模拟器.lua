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
local TeleportTab = Window:Tab({Title="岛屿传送",Icon="map"});
local ShopTab = Window:Tab({Title="远程商店",Icon="shopping-cart"});
Window:SelectTab(1);
local MainSection = MainTab:Section({Title="重生",Collapsible=false});
MainSection:Button({Title="一键重生",Desc="自动购买前20个重生等级",Callback=function()
	for i = 1, 20 do
		local args = {[1]=i};
		game:GetService("ReplicatedStorage").Promote:FireServer(unpack(args));
	end
	WindUI:Notify({Title="操作完成",Content="已尝试重生等级 1-20",Duration=3});
end});
getgenv().AutoScoop = false;
MainSection:Toggle({Title="自动收集燃料",Desc="自动使用手中的燃料铲",Callback=function(Value)
	getgenv().AutoScoop = Value;
	if Value then
		task.spawn(function()
			while getgenv().AutoScoop do
				local char = game.Players.LocalPlayer.Character;
				if char then
					for i, h in pairs(char:GetChildren()) do
						if (h:IsA("Tool") and (h.Name == "FuelScoop")) then
							h:Activate();
						end
					end
				end
				task.wait();
			end
		end);
	end
end});
local MiscSection = MainTab:Section({Title="玩家",Collapsible=false});
MiscSection:Button({Title="登上火箭",Callback=function()
	game:GetService("ReplicatedStorage"):WaitForChild("BoardRocket"):FireServer();
end});
MiscSection:Button({Title="移除所有者座位玩家",Callback=function()
	game:GetService("ReplicatedStorage"):WaitForChild("RemovePlayer"):FireServer();
end});
local TpSection = TeleportTab:Section({Title="选择目的地",Collapsible=false});
TpSection:Button({Title="发射台岛",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-123.15931701660156, 2.7371432781219482, 3.491959810256958);
end});
TpSection:Button({Title="白云岛",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-76.13252258300781, 170.55825805664062, -60.4516716003418);
end});
TpSection:Button({Title="浮漂岛",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-66.51714324951172, 720.4866333007812, -5.391753196716309);
end});
TpSection:Button({Title="卫星岛",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-34.2462043762207, 1429.4990234375, 1.3739361763000488);
end});
TpSection:Button({Title="蜜蜂迷宫岛",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(6.5361199378967285, 3131.249267578125, -29.759048461914062);
end});
TpSection:Button({Title="月球人救援",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-7.212917804718018, 5016.341796875, -19.815933227539062);
end});
TpSection:Button({Title="暗物质岛",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(68.43186950683594, 6851.94091796875, 7.890637397766113);
end});
TpSection:Button({Title="太空岩石岛",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(49.92888641357422, 8942.955078125, 8.674375534057617);
end});
TpSection:Button({Title="零号火星岛",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(54.44503402709961, 11270.0927734375, -1.273137092590332);
end});
TpSection:Button({Title="太空水晶小行星岛",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-11.579089164733887, 15295.6318359375, -27.54974365234375);
end});
TpSection:Button({Title="月球浆果岛",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-14.601255416870117, 18410.9609375, 0.9418511986732483);
end});
TpSection:Button({Title="铺路石岛",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3.272758960723877, 22539.494140625, 63.283935546875);
end});
TpSection:Button({Title="流星岛",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-45.515689849853516, 27961.560546875, -7.358333110809326);
end});
TpSection:Button({Title="升级岛",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2.7595248222351074, 33959.98828125, 53.93095397949219);
end});
local RocketSection = ShopTab:Section({Title="火箭",Collapsible=true});
local rockets = {{name="英勇",id=1},{name="加成英勇",id=2},{name="火刃",id=3},{name="加成火刃",id=4},{name="阿特拉斯",id=5},{name="普罗米修斯",id=6},{name="双重阿特拉斯",id=7},{name="寻星者",id=8},{name="天空龙",id=9},{name="强化天空龙",id=10}};
for _, r in ipairs(rockets) do
	RocketSection:Button({Title=r.name,Callback=function()
		game:GetService("ReplicatedStorage").BuyRocket:InvokeServer("Rocket", r.id);
	end});
end
local BackpackSection = ShopTab:Section({Title="背包",Collapsible=true});
local backpacks = {{name="双重",id=1},{name="压缩罐",id=2},{name="原子压缩罐",id=3},{name="大型压缩罐",id=3},{name="大型原子压缩罐",id=4},{name="燃料棒",id=5},{name="火箭背包",id=6},{name="双重火箭背包",id=7},{name="胖胖火箭背包",id=8},{name="双重胖胖火箭背包",id=9},{name="绿色水晶背包",id=10},{name="红色水晶背包",id=11},{name="蓝色水晶背包",id=12}};
for _, b in ipairs(backpacks) do
	BackpackSection:Button({Title=b.name,Callback=function()
		game:GetService("ReplicatedStorage").BuyItem:InvokeServer("Backpack", b.id);
	end});
end
local ScoopSection = ShopTab:Section({Title="燃料采集铲",Collapsible=true});
local scoops = {{name="标准燃料采集铲",id=1},{name="新燃料采集铲",id=2},{name="电动燃料采集铲",id=3},{name="数字燃料采集铲",id=4},{name="人工智能燃料采集器",id=5},{name="采矿激光",id=6},{name="红宝石采矿激光",id=7},{name="霓虹采矿激光",id=8},{name="太空水晶采矿激光",id=9},{name="绿色水晶激光",id=10},{name="红色水晶激光",id=11},{name="蓝色水晶激光",id=12}};
for _, s in ipairs(scoops) do
	ScoopSection:Button({Title=s.name,Callback=function()
		game:GetService("ReplicatedStorage").BuyFuelScoop:InvokeServer("FuelScoop", s.id);
	end});
end
