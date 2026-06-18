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
local NinjaStates = {};
local Auto = Window:Tab({Title="自动功能",Icon="shell"});
local sale = Window:Tab({Title="出售",Icon="banknote-arrow-up"});
local shi = Window:Tab({Title="实用",Icon="laugh"});
local shou = Window:Tab({Title="收集",Icon="boxes"});
local chuan = Window:Tab({Title="传送",Icon="map-pinned"});
Window:SelectTab(1);
Auto:Toggle({Title="自动刷善良业报",Value=false,Callback=function(v)
	NinjaStates.GK = v;
end});
Auto:Toggle({Title="自动刷邪恶业报",Value=false,Callback=function(v)
	NinjaStates.BK = v;
end});
Auto:Toggle({Title="自动挥刀",Value=false,Callback=function(v)
	NinjaStates.Swing = v;
end});
Auto:Toggle({Title="自动出售",Value=false,Callback=function(v)
	NinjaStates.Sell = v;
end});
Auto:Toggle({Title="自动全部出售",Value=false,Callback=function(v)
	NinjaStates.FullSell = v;
end});
Auto:Toggle({Title="自动吸气",Value=false,Callback=function(v)
	NinjaStates.Chi = v;
end});
Auto:Toggle({Title="自动杀死机器人boss",Value=false,Callback=function(v)
	NinjaStates.Boss = v;
end});
Auto:Toggle({Title="自动杀死不朽boss",Value=false,Callback=function(v)
	NinjaStates.EBoss = v;
end});
Auto:Toggle({Title="自动杀死古代boss",Value=false,Callback=function(v)
	NinjaStates.ABoss = v;
end});
Auto:Toggle({Title="自动杀死圣诞老人boss",Value=false,Callback=function(v)
	NinjaStates.SBoss = v;
end});
Auto:Toggle({Title="自动杀死全部boss",Value=false,Callback=function(v)
	NinjaStates.AllBosses = v;
end});
Auto:Toggle({Title="自动给宠物升级",Value=false,Callback=function(v)
	NinjaStates.L = v;
end});
Auto:Toggle({Title="自动买等级",Value=false,Callback=function(v)
	NinjaStates.Rank = v;
end});
Auto:Toggle({Title="自动买剑",Value=false,Callback=function(v)
	NinjaStates.Sword = v;
end});
Auto:Toggle({Title="自己买腰带",Value=false,Callback=function(v)
	NinjaStates.Belt = v;
end});
Auto:Toggle({Title="自动买技能",Value=false,Callback=function(v)
	NinjaStates.Skill = v;
end});
Auto:Toggle({Title="自动买飞镖",Value=false,Callback=function(v)
	NinjaStates.Shurikens = v;
end});
local Crystals = {};
local mapCrystalsFolder = game.workspace:FindFirstChild("mapCrystalsFolder");
if mapCrystalsFolder then
	for _, v in next, mapCrystalsFolder:GetChildren() do
		if (v and v.Name) then
			table.insert(Crystals, v.Name);
		end
	end
end
if (#Crystals == 0) then
	table.insert(Crystals, "None");
end
Auto:Dropdown({Title="Crystals",Values=Crystals,Callback=function(val)
	NinjaStates.Crystal = val;
end});
Auto:Toggle({Title="打开蛋",Value=false,Callback=function(v)
	NinjaStates.TEgg = v;
end});
Auto:Toggle({Title="自动进化",Value=false,Callback=function(v)
	NinjaStates.Evolve = v;
end});
Auto:Toggle({Title="自动永恒",Value=false,Callback=function(v)
	NinjaStates.Eternalise = v;
end});
Auto:Toggle({Title="自动永生",Value=false,Callback=function(v)
	NinjaStates.Immortalize = v;
end});
Auto:Toggle({Title="自动传奇",Value=false,Callback=function(v)
	NinjaStates.Legend = v;
end});
Auto:Toggle({Title="自动元素",Value=false,Callback=function(v)
	NinjaStates.Elemental = v;
end});
sale:Toggle({Title="出售全部基本宠物",Value=false,Callback=function(v)
	NinjaStates.SBasic = v;
end});
sale:Toggle({Title="出售全部高级宠物",Value=false,Callback=function(v)
	NinjaStates.SAdvanced = v;
end});
sale:Toggle({Title="出售全部稀有宠物",Value=false,Callback=function(v)
	NinjaStates.SRare = v;
end});
sale:Toggle({Title="出售全部史诗宠物",Value=false,Callback=function(v)
	NinjaStates.SEpic = v;
end});
sale:Toggle({Title="出售全部独一无二的宠物",Value=false,Callback=function(v)
	NinjaStates.SUnique = v;
end});
sale:Toggle({Title="出售全部欧米茄宠物",Value=false,Callback=function(v)
	NinjaStates.SOmega = v;
end});
sale:Toggle({Title="出售全部精英宠物",Value=false,Callback=function(v)
	NinjaStates.SElite = v;
end});
sale:Toggle({Title="出售全部无限宠物",Value=false,Callback=function(v)
	NinjaStates.SInfinity = v;
end});
sale:Toggle({Title="出售全部冬季小猫",Value=false,Callback=function(v)
	NinjaStates.S1 = v;
end});
sale:Toggle({Title="出售全部北极熊",Value=false,Callback=function(v)
	NinjaStates.S2 = v;
end});
sale:Toggle({Title="出售全部驯鹿唤醒",Value=false,Callback=function(v)
	NinjaStates.S3 = v;
end});
sale:Toggle({Title="自动出售全部黑企鹅",Value=false,Callback=function(v)
	NinjaStates.S4 = v;
end});
sale:Toggle({Title="出售全部雪橇高手",Value=false,Callback=function(v)
	NinjaStates.S5 = v;
end});
shi:Toggle({Title="快速手里剑",Value=false,Callback=function(v)
	NinjaStates.Fast = v;
end});
shi:Toggle({Title="慢速手里剑",Value=false,Callback=function(v)
	NinjaStates.Slow = v;
end});
shi:Toggle({Title="隐身",Value=false,Callback=function(v)
	NinjaStates.Invis = v;
end});
shi:Button({Title="解锁岛屿",Callback=function()
	for _, v in next, game.workspace.islandUnlockParts:GetChildren() do
		if v then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.islandSignPart.CFrame;
			wait(0.5);
		end
	end
end});
shi:Button({Title="最高跳",Callback=function()
	while wait(0.0001) do
		game.Players.LocalPlayer.multiJumpCount.Value = "50";
	end
end});
shi:Button({Title="隐藏名称",Callback=function()
	local plrname = game.Players.LocalPlayer.Name;
	workspace[plrname].Head.nameGui:Destroy();
end});
shi:Button({Title="经验ESP",Callback=function()
	function isnil(thing)
		return thing == nil;
	end
	local function round(n)
		return math.floor(tonumber(n) + 0.5);
	end
	function UpdatePlayerChams()
		for _, v in pairs(game:GetService("Players"):GetChildren()) do
			pcall(function()
				if not isnil(v.Character) then
					for _, k in pairs(v.Character:GetChildren()) do
						if (k:IsA("BasePart") and not k:FindFirstChild("Cham")) then
							local cham = Instance.new("BoxHandleAdornment", k);
							cham.ZIndex = 10;
							cham.Adornee = k;
							cham.AlwaysOnTop = true;
							cham.Size = k.Size;
							cham.Transparency = 0.8;
							cham.Color3 = Color3.new(0, 0, 1);
							cham.Name = "Cham";
						end
					end
					if (not isnil(v.Character.Head) and not v.Character.Head:FindFirstChild("NameEsp")) then
						local bill = Instance.new("BillboardGui", v.Character.Head);
						bill.Name = "NameEsp";
						bill.Size = UDim2.new(1, 200, 1, 30);
						bill.Adornee = v.Character.Head;
						bill.AlwaysOnTop = true;
						local name = Instance.new("TextLabel", bill);
						name.TextWrapped = true;
						name.Text = v.Name .. " " .. round((game:GetService("Players").LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude / 3) .. "m";
						name.Size = UDim2.new(1, 0, 1, 0);
						name.TextYAlignment = "Top";
						name.TextColor3 = Color3.new(1, 1, 1);
						name.BackgroundTransparency = 1;
					else
						v.Character.Head.NameEsp.TextLabel.Text = v.Name .. " " .. round((game:GetService("Players").LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude / 3) .. "m";
					end
				end
			end);
		end
	end
	while wait() do
		UpdatePlayerChams();
	end
end});
shou:Button({Title="收集所有宝箱",Callback=function()
	game:GetService("Workspace").mythicalChest['circleInner'].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
	wait(3.5);
	game:GetService("Workspace").goldenChest['circleInner'].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
	wait(3.5);
	game:GetService("Workspace").enchantedChest['circleInner'].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
	wait(3.5);
	game:GetService("Workspace").magmaChest['circleInner'].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
	wait(3.5);
	game:GetService("Workspace").legendsChest['circleInner'].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
	wait(3.5);
	game:GetService("Workspace").eternalChest['circleInner'].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
	wait(3.5);
	game:GetService("Workspace").saharaChest['circleInner'].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
	wait(3.5);
	game:GetService("Workspace").thunderChest['circleInner'].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
	wait(3.5);
	game:GetService("Workspace").ancientChest['circleInner'].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
	wait(3.5);
	game:GetService("Workspace").midnightShadowChest['circleInner'].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
	wait(3.5);
	game:GetService("Workspace").groupRewardsCircle['circleInner'].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
	wait(3.5);
	game:GetService("Workspace")["Daily Chest"].circleInner.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
	wait(3.5);
	game:GetService("Workspace")['wonderChest'].circleInner.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
	wait(3.5);
	game:GetService("Workspace").wonderChest['circleInner'].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
	game:GetService("Workspace").midnightShadowChest['circleInner'].CFrame = game.Workspace.Part.CFrame;
	game:GetService("Workspace").ancientChest['circleInner'].CFrame = game.Workspace.Part.CFrame;
	game:GetService("Workspace").midnightShadowChest['circleInner'].CFrame = game.Workspace.Part.CFrame;
	game:GetService("Workspace").thunderChest['circleInner'].CFrame = game.Workspace.Part.CFrame;
	game:GetService("Workspace").saharaChest['circleInner'].CFrame = game.Workspace.Part.CFrame;
	game:GetService("Workspace").eternalChest['circleInner'].CFrame = game.Workspace.Part.CFrame;
	game:GetService("Workspace").legendsChest['circleInner'].CFrame = game.Workspace.Part.CFrame;
	game:GetService("Workspace").magmaChest['circleInner'].CFrame = game.Workspace.Part.CFrame;
	game:GetService("Workspace").enchantedChest['circleInner'].CFrame = game.Workspace.Part.CFrame;
	game:GetService("Workspace").goldenChest['circleInner'].CFrame = game.Workspace.Part.CFrame;
	game:GetService("Workspace").mythicalChest['circleInner'].CFrame = game.Workspace.Part.CFrame;
	game:GetService("Workspace").groupRewardsCircle['circleInner'].CFrame = game.Workspace.Part.CFrame;
	game:GetService("Workspace")["Daily Chest"].circleInner.CFrame = game.Workspace.Part.CFrame;
end});
shou:Button({Title="收集光明宝箱",Callback=function()
	game:GetService("Workspace").lightKarmaChest['circleInner'].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
	wait(5);
	game:GetService("Workspace").lightKarmaChest['circleInner'].CFrame = game.Workspace.Part.CFrame;
end});
shou:Button({Title="收集黑暗宝箱",Callback=function()
	game:GetService("Workspace").evilKarmaChest['circleInner'].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
	wait(5);
	game:GetService("Workspace").evilKarmaChest['circleInner'].CFrame = game.Workspace.Part.CFrame;
end});
local Islands = {};
local islandUnlockPartsFolder = game.workspace:FindFirstChild("islandUnlockParts");
if islandUnlockPartsFolder then
	for _, v in next, islandUnlockPartsFolder:GetChildren() do
		if (v and v.Name) then
			table.insert(Islands, v.Name);
		end
	end
end
if (#Islands == 0) then
	table.insert(Islands, "None");
end
chuan:Dropdown({Title="岛屿传送",Values=Islands,Callback=function(a)
	if (a == "None") then
		return;
	end
	local islandFolder = game.Workspace:FindFirstChild("islandUnlockParts");
	if (islandFolder and islandFolder:FindFirstChild(a) and islandFolder[a]:FindFirstChild("islandSignPart")) then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = islandFolder[a].islandSignPart.CFrame;
	end
end});
chuan:Button({Title="Shop",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").shopAreaCircles['shopAreaCircle11'].circleInner.CFrame;
end});
chuan:Button({Title="Skills Shop",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").skillAreaCircles['skillsAreaCircle11'].circleInner.CFrame;
end});
chuan:Button({Title="Light Skills Shop",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-116.49514, 3.24800324, 0.0838552266);
end});
chuan:Button({Title="Dark Skills Shop",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-116.549767, 3.24800324, 58.087841);
end});
chuan:Button({Title="KOTH",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").kingOfTheHillPart.CFrame;
end});
chuan:Button({Title="Mystical Waters (Good)",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(347.74881, 8824.53809, 114.271019);
end});
chuan:Button({Title="Sword of Legends (Good)",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1834.15967, 38.704483, -141.375641);
end});
chuan:Button({Title="Elemental Tornado (Good)",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(299.758484, 30383.0957, -90.1542206);
end});
chuan:Button({Title="Lava Pit (Bad)",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-116.631485, 12952.5381, 271.14624);
end});
chuan:Button({Title="Tornado (Bad)",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(325.641174, 16872.0938, -9.9906435);
end});
chuan:Button({Title="Swords Of Ancients (Bad)",Callback=function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(648.365662, 38.704483, 2409.72266);
end});
spawn(function()
	while wait() do
		if SpeedStates.FarmOrbs then
			game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", "Magma City");
			game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", "City");
			game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", "Snow City");
		end
		if SpeedStates.FarmGems then
			game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Gem", "City");
		end
		if SpeedStates.Hoops then
			local children = workspace.Hoops:GetChildren();
			for _, child in ipairs(children) do
				if (child.Name == "Hoop") then
					child.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
				end
			end
		end
		if SpeedStates.Rebirth then
			game.ReplicatedStorage.rEvents.rebirthEvent:FireServer("rebirthRequest");
		end
		if SpeedStates.BestEgg then
			game.ReplicatedStorage.rEvents.openCrystalRemote:InvokeServer("openCrystal", "Electro Legends Crystal");
		end
		if SpeedStates.Evolve then
			game.ReplicatedStorage.rEvents.petEvolveEvent:FireServer("evolvePet", "all");
		end
		if GeneralStates.Invis then
			for _, v in pairs(Player.Character:GetChildren()) do
				if (v:IsA("BasePart") and (v.Name ~= "HumanoidRootPart")) then
					v.Transparency = 1;
				end
			end
		end
		if (GeneralStates.GodMode and Player.Character) then
			Player.Character.Humanoid.Health = 100;
		end
		if (GeneralStates.TouchKill and Player.Character) then
			Player.Character.Humanoid.Touched:Connect(function(hit)
				local hum = hit.Parent:FindFirstChild("Humanoid");
				if hum then
					hum.Health = 0;
				end
			end);
		end
		if GeneralStates.PullEnemies then
			for _, p in pairs(Players:GetPlayers()) do
				if ((p ~= Player) and p.Character and p.Character:FindFirstChild("HumanoidRootPart")) then
					p.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3);
				end
			end
		end
	end
end);
spawn(function()
	while wait(0.01) do
		if NinjaStates.TEgg then
			local oh1 = "openCrystal";
			local oh2 = NinjaStates.Crystal;
			game:GetService("ReplicatedStorage").rEvents.openCrystalRemote:InvokeServer(oh1, oh2);
		end
	end
end);
spawn(function()
	while wait() do
		if NinjaStates.Swing then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then
					game.Players.LocalPlayer.ninjaEvent:FireServer("swingKatana");
				else
					for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
						if ((v.ClassName == "Tool") and v:FindFirstChild("attackShurikenScript")) then
							game.Players.LocalPlayer.Character.Humanoid:EquipTool(v);
							wait();
							if ((v.ClassName == "Tool") and v:FindFirstChild("attackKatanaScript")) then
								game.Players.LocalPlayer.Character.Humanoid:EquipTool(v);
							end
						end
					end
				end
			end
		end
	end
end);
spawn(function()
	while wait(0.01) do
		if NinjaStates.Sell then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				game.workspace.sellAreaCircles['sellAreaCircle7'].circleInner.CFrame = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame;
				wait(0.1);
				game.workspace.sellAreaCircles['sellAreaCircle7'].circleInner.CFrame = game.Workspace.Part.CFrame;
			end
		end
	end
end);
spawn(function()
	while wait(0.01) do
		if NinjaStates.FullSell then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				if (player.PlayerGui.gameGui.maxNinjitsuMenu.Visible == true) then
					game.workspace.sellAreaCircles['sellAreaCircle7'].circleInner.CFrame = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame;
					wait(0.05);
					game.workspace.sellAreaCircles['sellAreaCircle7'].circleInner.CFrame = game.Workspace.Part.CFrame;
				end
			end
		end
	end
end);
spawn(function()
	while wait(0.001) do
		if NinjaStates.Invis then
			local A_1 = "goInvisible";
			local Event = game.Players.LocalPlayer.ninjaEvent;
			Event:FireServer(A_1);
		end
	end
end);
spawn(function()
	while wait(0.00011) do
		if NinjaStates.L then
			local plr = game.Players.LocalPlayer;
			for _, v in pairs(workspace.Hoops:GetDescendants()) do
				if (v.ClassName == "MeshPart") then
					v.touchPart.CFrame = plr.Character.HumanoidRootPart.CFrame;
				end
			end
		end
	end
end);
spawn(function()
	while wait(0.4) do
		if NinjaStates.GK then
			loadstring(game:HttpGet("https://pastebin.com/raw/AaqHqPyw", true))();
		end
	end
end);
spawn(function()
	while wait(0.4) do
		if NinjaStates.BK then
			loadstring(game:HttpGet("https://pastebin.com/raw/wEEB3nQt", true))();
		end
	end
end);
spawn(function()
	while wait(0.001) do
		if NinjaStates.Boss then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				if game:GetService("Workspace").bossFolder:WaitForChild("RobotBoss"):WaitForChild("HumanoidRootPart") then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.bossFolder.RobotBoss.HumanoidRootPart.CFrame;
					if player.Character:FindFirstChildOfClass("Tool") then
						player.Character:FindFirstChildOfClass("Tool"):Activate();
					else
						for _, v in pairs(player.Backpack:GetChildren()) do
							if ((v.ClassName == "Tool") and v:FindFirstChild("attackKatanaScript")) then
								v.attackTime.Value = 0.2;
								player.Character.Humanoid:EquipTool(v);
							end
						end
					end
				end
			end
		end
	end
end);
spawn(function()
	while wait(0.001) do
		if NinjaStates.EBoss then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				if game:GetService("Workspace").bossFolder:WaitForChild("EternalBoss"):WaitForChild("HumanoidRootPart") then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.bossFolder.EternalBoss.HumanoidRootPart.CFrame;
					if player.Character:FindFirstChildOfClass("Tool") then
						player.Character:FindFirstChildOfClass("Tool"):Activate();
					else
						for _, v in pairs(player.Backpack:GetChildren()) do
							if ((v.ClassName == "Tool") and v:FindFirstChild("attackKatanaScript")) then
								v.attackTime.Value = 0.2;
								player.Character.Humanoid:EquipTool(v);
							end
						end
					end
				end
			end
		end
	end
end);
spawn(function()
	while wait(0.001) do
		if NinjaStates.ABoss then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				if game:GetService("Workspace").bossFolder:WaitForChild("AncientMagmaBoss"):WaitForChild("HumanoidRootPart") then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.bossFolder.AncientMagmaBoss.HumanoidRootPart.CFrame;
					if player.Character:FindFirstChildOfClass("Tool") then
						player.Character:FindFirstChildOfClass("Tool"):Activate();
					else
						for _, v in pairs(player.Backpack:GetChildren()) do
							if ((v.ClassName == "Tool") and v:FindFirstChild("attackKatanaScript")) then
								v.attackTime.Value = 0.2;
								player.Character.Humanoid:EquipTool(v);
							end
						end
					end
				end
			end
		end
	end
end);
spawn(function()
	while wait(0.001) do
		if NinjaStates.SBoss then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				if game:GetService("Workspace").bossFolder:WaitForChild("Samurai Santa"):WaitForChild("HumanoidRootPart") then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.bossFolder["Samurai Santa"].HumanoidRootPart.CFrame;
					if player.Character:FindFirstChildOfClass("Tool") then
						player.Character:FindFirstChildOfClass("Tool"):Activate();
					else
						for _, v in pairs(player.Backpack:GetChildren()) do
							if ((v.ClassName == "Tool") and v:FindFirstChild("attackKatanaScript")) then
								v.attackTime.Value = 0.2;
								player.Character.Humanoid:EquipTool(v);
							end
						end
					end
				end
			end
		end
	end
end);
spawn(function()
	while wait(0.001) do
		if NinjaStates.AllBosses then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				if game.Workspace.bossFolder:FindFirstChild("Samurai Santa") then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.bossFolder["Samurai Santa"].HumanoidRootPart.CFrame;
				elseif game.Workspace.bossFolder:FindFirstChild("AncientMagmaBoss") then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.bossFolder.AncientMagmaBoss.HumanoidRootPart.CFrame;
				elseif game.Workspace.bossFolder:FindFirstChild("EternalBoss") then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.bossFolder.EternalBoss.HumanoidRootPart.CFrame;
				elseif game.Workspace.bossFolder:FindFirstChild("RobotBoss") then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.bossFolder.RobotBoss.HumanoidRootPart.CFrame;
				end
				if player.Character:FindFirstChildOfClass("Tool") then
					player.Character:FindFirstChildOfClass("Tool"):Activate();
				else
					for _, v in pairs(player.Backpack:GetChildren()) do
						if ((v.ClassName == "Tool") and v:FindFirstChild("attackKatanaScript")) then
							v.attackTime.Value = 0.2;
							player.Character.Humanoid:EquipTool(v);
						end
					end
				end
			end
		end
	end
end);
spawn(function()
	while wait(0.5) do
		if NinjaStates.Sword then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				local oh1 = "buyAllSwords";
				local oh2 = {"Ground","Astral Island","Space Island","Tundra Island","Eternal Island","Sandstorm","Thunderstorm","Ancient Inferno Island","Midnight Shadow Island","Mythical Souls Island","Winter Wonder Island"};
				for i = 1, #oh2 do
					game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(oh1, oh2[i]);
				end
			end
		end
	end
end);
spawn(function()
	while wait(0.5) do
		if NinjaStates.Belt then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				local oh1 = "buyAllBelts";
				local oh2 = {"Ground","Astral Island","Space Island","Tundra Island","Eternal Island","Sandstorm","Thunderstorm","Ancient Inferno Island","Midnight Shadow Island","Mythical Souls Island","Winter Wonder Island"};
				for i = 1, #oh2 do
					game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(oh1, oh2[i]);
				end
			end
		end
	end
end);
spawn(function()
	while wait(0.5) do
		if NinjaStates.Skill then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				local oh1 = "buyAllSkills";
				local oh2 = {"Ground","Astral Island","Space Island","Tundra Island","Eternal Island","Sandstorm","Thunderstorm","Ancient Inferno Island","Midnight Shadow Island","Mythical Souls Island","Winter Wonder Island"};
				for i = 1, #oh2 do
					game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(oh1, oh2[i]);
				end
			end
		end
	end
end);
spawn(function()
	while wait(0.5) do
		if NinjaStates.Rank then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				local oh1 = "buyRank";
				local oh2 = game:GetService("ReplicatedStorage").Ranks.Ground:GetChildren();
				for i = 1, #oh2 do
					game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(oh1, oh2[i].Name);
				end
			end
		end
	end
end);
spawn(function()
	while wait(0.5) do
		if NinjaStates.Shurikens then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				local oh1 = "buyAllShurikens";
				local oh2 = {"Ground","Astral Island","Space Island","Tundra Island","Eternal Island","Sandstorm","Thunderstorm","Ancient Inferno Island","Midnight Shadow Island","Mythical Souls Island","Winter Wonder Island"};
				for i = 1, #oh2 do
					game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(oh1, oh2[i]);
				end
			end
		end
	end
end);
spawn(function()
	while wait(0.033) do
		if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
			if NinjaStates.Chi then
				for _, v in pairs(game.Workspace.spawnedCoins.Valley:GetChildren()) do
					if (v.Name == "Blue Chi Crate") then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Position);
						wait(0.16);
					end
				end
			end
		end
	end
end);
spawn(function()
	while wait(3) do
		if NinjaStates.Evolve then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				for _, v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetChildren()) do
					for _, x in pairs(v:GetChildren()) do
						local oh1 = "evolvePet";
						local oh2 = x.Name;
						game:GetService("ReplicatedStorage").rEvents.petEvolveEvent:FireServer(oh1, oh2);
					end
				end
			end
		end
	end
end);
spawn(function()
	while wait(3) do
		if NinjaStates.Eternalise then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				for _, v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetChildren()) do
					for _, x in pairs(v:GetChildren()) do
						local oh1 = "eternalizePet";
						local oh2 = x.Name;
						game:GetService("ReplicatedStorage").rEvents.petEternalizeEvent:FireServer(oh1, oh2);
					end
				end
			end
		end
	end
end);
spawn(function()
	while wait(3) do
		if NinjaStates.Immortalize then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				for _, v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetChildren()) do
					for _, x in pairs(v:GetChildren()) do
						local oh1 = "immortalizePet";
						local oh2 = x.Name;
						game:GetService("ReplicatedStorage").rEvents.petImmortalizeEvent:FireServer(oh1, oh2);
					end
				end
			end
		end
	end
end);
spawn(function()
	while wait(3) do
		if NinjaStates.Legend then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				for _, v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetChildren()) do
					for _, x in pairs(v:GetChildren()) do
						local oh1 = "legendizePet";
						local oh2 = x.Name;
						game:GetService("ReplicatedStorage").rEvents.petLegendEvent:FireServer(oh1, oh2);
					end
				end
			end
		end
	end
end);
spawn(function()
	while wait(3) do
		if NinjaStates.Elemental then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				for _, v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetChildren()) do
					for _, x in pairs(v:GetChildren()) do
						local oh1 = "elementalizePet";
						local oh2 = x.Name;
						game:GetService("ReplicatedStorage").rEvents.petLegendEvent:FireServer(oh1, oh2);
					end
				end
			end
		end
	end
end);
spawn(function()
	while wait(1) do
		if NinjaStates.SBasic then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				for _, v in pairs(game.Players.LocalPlayer.petsFolder.Basic:GetChildren()) do
					game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v);
				end
			end
		end
	end
end);
spawn(function()
	while wait(1) do
		if NinjaStates.SAdvanced then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				for _, v in pairs(game.Players.LocalPlayer.petsFolder.Advanced:GetChildren()) do
					game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v);
				end
			end
		end
	end
end);
spawn(function()
	while wait(1) do
		if NinjaStates.SRare then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				for _, v in pairs(game.Players.LocalPlayer.petsFolder.Rare:GetChildren()) do
					game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v);
				end
			end
		end
	end
end);
spawn(function()
	while wait(1) do
		if NinjaStates.SEpic then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				for _, v in pairs(game.Players.LocalPlayer.petsFolder.Epic:GetChildren()) do
					game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v);
				end
			end
		end
	end
end);
spawn(function()
	while wait(1) do
		if NinjaStates.SUnique then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				for _, v in pairs(game.Players.LocalPlayer.petsFolder.Unique:GetChildren()) do
					game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v);
				end
			end
		end
	end
end);
spawn(function()
	while wait(1) do
		if NinjaStates.SOmega then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				for _, v in pairs(game.Players.LocalPlayer.petsFolder.Omega:GetChildren()) do
					game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v);
				end
			end
		end
	end
end);
spawn(function()
	while wait(1) do
		if NinjaStates.SElite then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				for _, v in pairs(game.Players.LocalPlayer.petsFolder.Elite:GetChildren()) do
					game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v);
				end
			end
		end
	end
end);
spawn(function()
	while wait(1) do
		if NinjaStates.SInfinity then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				for _, v in pairs(game.Players.LocalPlayer.petsFolder.Infinity:GetChildren()) do
					game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v);
				end
			end
		end
	end
end);
spawn(function()
	while wait(1) do
		if NinjaStates.S1 then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				for _, v in pairs(game.Players.LocalPlayer.petsFolder.Infinity:GetChildren()) do
					if (v.Name == "Winter Wonder Kitty") then
						game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v);
					end
				end
			end
		end
	end
end);
spawn(function()
	while wait(1) do
		if NinjaStates.S2 then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				for _, v in pairs(game.Players.LocalPlayer.petsFolder.Infinity:GetChildren()) do
					if (v.Name == "Winter Legends Polar Bear") then
						game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v);
					end
				end
			end
		end
	end
end);
spawn(function()
	while wait(1) do
		if NinjaStates.S3 then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				for _, v in pairs(game.Players.LocalPlayer.petsFolder.Infinity:GetChildren()) do
					if (v.Name == "Christmas Sensei Reindeer") then
						game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v);
					end
				end
			end
		end
	end
end);
spawn(function()
	while wait(1) do
		if NinjaStates.S4 then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				for _, v in pairs(game.Players.LocalPlayer.petsFolder.Infinity:GetChildren()) do
					if (v.Name == "Dark Blizzard Master Penguin") then
						game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v);
					end
				end
			end
		end
	end
end);
spawn(function()
	while wait(1) do
		if NinjaStates.S5 then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				for _, v in pairs(game.Players.LocalPlayer.petsFolder.Infinity:GetChildren()) do
					if (v.Name == "Cybernetic Sleigh Rider") then
						game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v);
					end
				end
			end
		end
	end
end);
spawn(function()
	while wait(0.001) do
		if NinjaStates.Fast then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				local plr = game.Players.LocalPlayer;
				local Mouse = plr:GetMouse();
				local velocity = 1000;
				for _, p in pairs(game.Workspace.shurikensFolder:GetChildren()) do
					if (p.Name == "Handle") then
						if p:FindFirstChild("BodyVelocity") then
							local bv = p:FindFirstChildOfClass("BodyVelocity");
							bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge);
							bv.Velocity = Mouse.Hit.lookVector * velocity;
						end
					end
				end
			end
		end
	end
end);
spawn(function()
	while wait(0.001) do
		if NinjaStates.Slow then
			if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
				local plr = game.Players.LocalPlayer;
				local Mouse = plr:GetMouse();
				local velocity = 35;
				for _, p in pairs(game.Workspace.shurikensFolder:GetChildren()) do
					if (p.Name == "Handle") then
						if p:FindFirstChild("BodyVelocity") then
							local bv = p:FindFirstChildOfClass("BodyVelocity");
							bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge);
							bv.Velocity = Mouse.Hit.lookVector * velocity;
						end
					end
				end
			end
		end
	end
end);
