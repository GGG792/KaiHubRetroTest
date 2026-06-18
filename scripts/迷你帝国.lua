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
local CombatTab = Window:Tab({Title="功能",Icon="swords"});
Window:SelectTab(1);
local itemDatabase = {["Poor Soldier Camp"]="Military",["Soldier Camp"]="Military",["Militia Camp"]="Military",Watchtower="Military",["Castle Warriors"]="Military",["Giant Cave"]="Military",Tent="Houses",Workshop="Houses",["Small House"]="Houses",Windmill="Houses",Blacksmith="Houses",Tavern="Houses",["Large House"]="Houses",Mansion="Houses",["Castle With Housing"]="Houses",["Wheat Farm"]="Farms",["Bush Farm"]="Farms",["Carrot Farm"]="Farms",["Tomato Farm"]="Farms",["Apple Farm"]="Farms",["Tree Farm"]="Farms",["Sheep Farm"]="Farms",["Flower Farm"]="Farms",["Copper Mine"]="Farms",["Silver Mine"]="Farms",["Gold Mine"]="Farms",["Diamond Mine"]="Farms",Bakery="Farms",Bank="Farms",Smithy="Farms",Market="Farms",["Fishing Pond"]="Farms"};
local nameTranslation = {["贫穷士兵营地 (Poor Soldier Camp)"]="Poor Soldier Camp",["士兵营地 (Soldier Camp)"]="Soldier Camp",["民兵营地 (Militia Camp)"]="Militia Camp",["了望塔 (Watchtower)"]="Watchtower",["城堡战士 (Castle Warriors)"]="Castle Warriors",["巨型洞穴 (Giant Cave)"]="Giant Cave",["帐篷 (Tent)"]="Tent",["车间 (Workshop)"]="Workshop",["小房子 (Small House)"]="Small House",["风车 (Windmill)"]="Windmill",["铁匠铺 (Blacksmith)"]="Blacksmith",["酒馆 (Tavern)"]="Tavern",["大房子 (Large House)"]="Large House",["豪宅 (Mansion)"]="Mansion",["带房子的城堡 (Castle With Housing)"]="Castle With Housing",["小麦农场 (Wheat Farm)"]="Wheat Farm",["灌木农场 (Bush Farm)"]="Bush Farm",["胡萝卜农场 (Carrot Farm)"]="Carrot Farm",["番茄农场 (Tomato Farm)"]="Tomato Farm",["苹果农场 (Apple Farm)"]="Apple Farm",["树木农场 (Tree Farm)"]="Tree Farm",["绵羊农场 (Sheep Farm)"]="Sheep Farm",["花卉农场 (Flower Farm)"]="Flower Farm",["铜矿 (Copper Mine)"]="Copper Mine",["银矿 (Silver Mine)"]="Silver Mine",["金矿 (Gold Mine)"]="Gold Mine",["钻石矿 (Diamond Mine)"]="Diamond Mine",["面包店 (Bakery)"]="Bakery",["银行 (Bank)"]="Bank",["锻造厂 (Smithy)"]="Smithy",["市场 (Market)"]="Market",["鱼塘 (Fishing Pond)"]="Fishing Pond"};
local dropDownOptionsCN = {};
for cnName, _ in pairs(nameTranslation) do
	table.insert(dropDownOptionsCN, cnName);
end
table.sort(dropDownOptionsCN);
local selectedEnglishName = "Wheat Farm";
local selectedCategory = "Farms";
local isAutoBuying = false;
local isAutoSelling = false;
getgenv().AntiAfkEnabled = true;
local function buyCurrentItem()
	if (selectedEnglishName and selectedCategory) then
		local args = {selectedEnglishName,selectedCategory};
		game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuyItem"):InvokeServer(unpack(args));
	end
end
CombatTab:Section({Title="物品购买"});
CombatTab:Dropdown({Title="选择要购买的物品",Values=dropDownOptionsCN,Value="小麦农场 (Wheat Farm)",Callback=function(selectedCN)
	local enName = nameTranslation[selectedCN];
	local category = itemDatabase[enName];
	if (enName and category) then
		selectedEnglishName = enName;
		selectedCategory = category;
		buyCurrentItem();
		WindUI:Notify({Title="已选择",Content=("目标: " .. selectedCN),Duration=1.5});
		print("当前选择: " .. enName .. " [" .. category .. "]");
	end
end});
CombatTab:Toggle({Title="循环购买",Desc="开启后将自动购买上方选中的物品",Value=false,Callback=function(state)
	isAutoBuying = state;
	if state then
		WindUI:Notify({Title="自动购买",Content="已开启循环购买",Duration=2,Icon="repeat"});
	else
		WindUI:Notify({Title="自动购买",Content="已停止",Duration=2,Icon="x-octagon"});
	end
end});
CombatTab:Section({Title="作物售卖"});
CombatTab:Button({Title="一键售卖所有作物",Desc="点击手动出售背包内所有作物",Callback=function()
	game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SellAllCrops"):InvokeServer();
	WindUI:Notify({Title="售卖成功",Content="已尝试出售所有作物",Duration=1.5,Icon="dollar-sign"});
end});
CombatTab:Toggle({Title="自动售卖 (5秒/次)",Desc="开启后每隔5秒自动出售一次",Value=false,Callback=function(state)
	isAutoSelling = state;
	if state then
		WindUI:Notify({Title="自动售卖",Content="已开启 (5秒间隔)",Duration=2});
	else
		WindUI:Notify({Title="自动售卖",Content="已停止",Duration=2});
	end
end});
CombatTab:Section({Title="通用设置"});
CombatTab:Toggle({Title="防挂机",Desc="屏蔽Roblox的超20分钟挂机踢出系统",Value=true,Callback=function(state)
	getgenv().AntiAfkEnabled = state;
	WindUI:Notify({Title="Aero",Content=((state and "防挂机已开启") or "防挂机已关闭"),Icon=((state and "check") or "x"),Duration=2});
end});
task.spawn(function()
	while true do
		task.wait(0.25);
		if isAutoBuying then
			buyCurrentItem();
		end
	end
end);
task.spawn(function()
	while true do
		if isAutoSelling then
			game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SellAllCrops"):InvokeServer();
			task.wait(5);
		else
			task.wait(1);
		end
	end
end);
LocalPlayer.Idled:Connect(function()
	if getgenv().AntiAfkEnabled then
		VirtualUser:CaptureController();
		VirtualUser:ClickButton2(Vector2.new());
	end
end);
