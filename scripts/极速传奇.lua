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
local infoTab = Window:Tab({Title="通知",Icon="layout-grid",Locked=false});
local infoSection = infoTab:Section({Title="详情",Opened=true});
infoSection:Paragraph({Title="关于",Desc="国内第一极速传奇",ThumbnailSize=190});
Window:SelectTab(1);
local MainSection = Window:Section({Title="主功能",Opened=true});
local function AddTab(section, title, icon)
	return section:Tab({Title=title,Icon=icon});
end
local A = AddTab(MainSection, "主要", "rbxassetid://7734068321");
local B = AddTab(MainSection, "卡宠", "rbxassetid://7734068321");
local C = AddTab(MainSection, "宝石", "rbxassetid://7734068321");
local D = AddTab(MainSection, "比赛", "rbxassetid://7734068321");
local E = AddTab(MainSection, "传送", "rbxassetid://7734068321");
local F = AddTab(MainSection, "重生", "rbxassetid://7734068321");
local G = AddTab(MainSection, "修改", "rbxassetid://7734068321");
local H = AddTab(MainSection, "宠物蛋", "rbxassetid://7734068321");
local I = AddTab(MainSection, "卡宠说明", "rbxassetid://7734068321");
local J = AddTab(MainSection, "画质+通用", "rbxassetid://7734068321");
local extraSection = A:Section({Title="额外",Opened=true});
extraSection:Button({Title="收集全部宝箱",Callback=function()
	for _, v in pairs(game.ReplicatedStorage.chestRewards:GetChildren()) do
		game.ReplicatedStorage.rEvents.checkChestRemote:InvokeServer(v.Name);
	end
end});
extraSection:Button({Title="解锁全部通行证",Callback=function()
	for i, v in ipairs(game:GetService("ReplicatedStorage").gamepassIds:GetChildren()) do
		v.Parent = game.Players.LocalPlayer.ownedGamepasses;
	end
end});
extraSection:Toggle({Title="吸全部环",Default=false,Callback=function(state)
	getgenv().HoopEnabled = state;
	if state then
		spawn(function()
			while getgenv().HoopEnabled and task.wait() do
				pcall(function()
					local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart;
					for _, hoop in ipairs(workspace.Hoops:GetChildren()) do
						if (hoop.Name == "Hoop") then
							hoop.CFrame = hrp.CFrame;
						end
					end
				end);
			end
		end);
	end
end});
local Interstellar = {area="City",getorb=false};
local areaOptions = {"City","Snow City","Magma City","Desert","Space","Legends Highway","Speed Jungle"};
local areaDisplayNames = {"城市","雪城","熔岩城","沙漠","太空","传奇公路","丛林"};
local cardPetSection1 = B:Section({Title="卡宠模式1",Opened=true});
cardPetSection1:Dropdown({Title="选择地区",Values=areaDisplayNames,Value="城市",Callback=function(Value)
	Interstellar.area = areaOptions[table.find(areaDisplayNames, Value)];
end});
local function orbFarm(type)
	spawn(function()
		while Interstellar.getorb do
			for i = 1, 50 do
				game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", type, Interstellar.area);
			end
			wait(0.05);
		end
	end);
end
cardPetSection1:Toggle({Title="紫球",Callback=function(s)
	Interstellar.getorb = s;
	if s then
		orbFarm("Ethereal Orb");
	end
end});
cardPetSection1:Toggle({Title="红球",Callback=function(s)
	Interstellar.getorb = s;
	if s then
		orbFarm("Red Orb");
	end
end});
cardPetSection1:Toggle({Title="蓝球",Callback=function(s)
	Interstellar.getorb = s;
	if s then
		orbFarm("Blue Orb");
	end
end});
cardPetSection1:Toggle({Title="橙球",Callback=function(s)
	Interstellar.getorb = s;
	if s then
		orbFarm("Orange Orb");
	end
end});
cardPetSection1:Toggle({Title="经验球",Callback=function(s)
	Interstellar.getorb = s;
	if s then
		orbFarm("Yellow Orb");
	end
end});
local Interstellar2 = {area="City",orbType="Yellow Orb",multiplier=1,rateEnabled=false};
local cardPetSection2 = B:Section({Title="自定义-卡宠模式2",Opened=true});
cardPetSection2:Input({Title="输入倍率",Callback=function(v)
	Interstellar2.multiplier = math.clamp(tonumber(v) or 1, 1, 10000);
end});
cardPetSection2:Toggle({Title="卡宠速度总开关",Callback=function(state)
	Interstellar2.rateEnabled = state;
	if state then
		spawn(function()
			while Interstellar2.rateEnabled do
				for i = 1, Interstellar2.multiplier do
					game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", Interstellar2.orbType, Interstellar2.area);
				end
				task.wait();
			end
		end);
	end
end});
local gemSection = C:Section({Title="宝石模式",Opened=true});
local function gemFarm(area, flag)
	spawn(function()
		while getgenv()[flag] do
			for i = 1, 10 do
				game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", area);
			end
			wait();
		end
	end);
end
gemSection:Toggle({Title="城市宝石",Callback=function(s)
	getgenv().sbsA = s;
	gemFarm("City", "sbsA");
end});
gemSection:Toggle({Title="雪城宝石",Callback=function(s)
	getgenv().sbsB = s;
	gemFarm("Snow City", "sbsB");
end});
local raceSection = D:Section({Title="比赛",Opened=true});
raceSection:Toggle({Title="自动比赛",Callback=function(s)
	autoRace = s;
	if s then
		spawn(function()
			while autoRace do
				game:GetService("ReplicatedStorage").rEvents.raceEvent:FireServer("joinRace");
				wait();
			end
		end);
	end
end});
local teleportSection = E:Section({Title="传送点",Opened=true});
teleportSection:Button({Title="城市",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2002, 1, 985);
end});
teleportSection:Button({Title="雪城",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-9675, 60, 3783);
end});
local rebirthSection1 = F:Section({Title="自动重生",Opened=true});
rebirthSection1:Toggle({Title="自动重生",Callback=function(state)
	Interstellar.mainexe = state;
	if state then
		spawn(function()
			while Interstellar.mainexe do
				pcall(function()
					game:GetService("ReplicatedStorage").rEvents.rebirthEvent:FireServer("rebirthRequest");
				end);
				wait();
			end
		end);
	end
end});
local modifySection = G:Section({Title="数值美化",Opened=true});
modifySection:Input({Title="修改等级",Callback=function(v)
	if tonumber(v) then
		game.Players.LocalPlayer.level.Value = tonumber(v);
	end
end});
modifySection:Input({Title="修改宝石",Callback=function(v)
	if tonumber(v) then
		game.Players.LocalPlayer.Gems.Value = tonumber(v);
	end
end});
local otherSection = J:Section({Title="常用功能",Opened=true});
otherSection:Toggle({Title="穿墙",Callback=function(state)
	if state then
		getgenv().noclip = game:GetService("RunService").Stepped:Connect(function()
			for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false;
				end
			end
		end);
	elseif getgenv().noclip then
		getgenv().noclip:Disconnect();
	end
end});
WindUI:Notify({Title="状态",Content="脚本加载成功 - 反挂机已开启",Duration=3});
game:GetService("Players").LocalPlayer.Idled:Connect(function()
	game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame);
	wait(1);
	game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame);
end);
