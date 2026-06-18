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
local CombatTab = Window:Tab({Title="光环类",Icon="swords"});
Window:SelectTab(1);
local autoHarvestThread = nil;
local stopHarvesting = false;
CombatTab:Toggle({Title="收菜光环",Desc="靠近植物自动收获",Default=false,Callback=function(state)
	if state then
		if (autoHarvestThread and not stopHarvesting) then
			return;
		end
		stopHarvesting = false;
		autoHarvestThread = task.spawn(function()
			local Players = game:GetService("Players");
			local player = Players.LocalPlayer;
			local character = player.Character or player.CharacterAdded:Wait();
			local clientPlants = workspace:WaitForChild("ClientPlants");
			local function tryHarvest(prompt)
				if (not prompt or not prompt:IsA("ProximityPrompt")) then
					return;
				end
				if not prompt.Enabled then
					return;
				end
				prompt.MaxActivationDistance = 5000;
				prompt.RequiresLineOfSight = false;
				prompt:InputHoldBegin();
				task.wait(prompt.HoldDuration);
				prompt:InputHoldEnd();
			end
			local function findAllHarvestPrompts(parent)
				local prompts = {};
				for _, child in ipairs(parent:GetDescendants()) do
					if ((child.Name == "HarvestPrompt") and child:IsA("ProximityPrompt")) then
						table.insert(prompts, child);
					end
				end
				return prompts;
			end
			while not stopHarvesting do
				task.wait(0);
				if (not clientPlants or not clientPlants.Parent) then
					break;
				end
				for _, plant in ipairs(clientPlants:GetChildren()) do
					if plant:IsA("Model") then
						local harvestPrompts = findAllHarvestPrompts(plant);
						for _, prompt in ipairs(harvestPrompts) do
							if stopHarvesting then
								break;
							end
							tryHarvest(prompt);
						end
					end
				end
			end
			autoHarvestThread = nil;
		end);
	else
		stopHarvesting = true;
		autoHarvestThread = nil;
	end
end});
local autoSellEnabled = false;
CombatTab:Toggle({Title="售卖光环",Desc="靠近售卖处自动售卖果实",Default=false,Callback=function(state)
	autoSellEnabled = state;
	if state then
		while autoSellEnabled do
			local args = {[1]="SellAll"};
			game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("SellItems"):InvokeServer(unpack(args));
			task.wait(0.01);
		end
	end
end});
local selectedSeed = "Carrot Seed";
CombatTab:Dropdown({Title="选择要购买的物品",Values={"Carrot Seed","Corn Seed","Onion Seed","Strawberry Seed","Mushroom Seed","Beetroot Seed","Tomato Seed","Apple Seed","Rose Seed","Wheat Seed","Banana Seed","Plum Seed","Potato Seed","Cabbage Seed","Cherry Seed","Bamboo Seed","Mango Seed"},Value="Carrot Seed",Callback=function(Value)
	selectedSeed = Value;
	print("当前选择:", selectedSeed);
end});
local autoBuyThread = nil;
local stopAutoBuy = false;
CombatTab:Toggle({Title="购买光环",Desc="靠近商店自动购买选择的种子",Default=false,Callback=function(state)
	if state then
		if (autoBuyThread and not stopAutoBuy) then
			return;
		end
		stopAutoBuy = false;
		autoBuyThread = task.spawn(function()
			local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("PurchaseShopItem");
			while not stopAutoBuy do
				local args = {"SeedShop",selectedSeed};
				pcall(function()
					remote:InvokeServer(unpack(args));
				end);
				task.wait(0);
			end
			autoBuyThread = nil;
		end);
	else
		stopAutoBuy = true;
		autoBuyThread = nil;
	end
end});
local CombatTab = Window:Tab({Title="自动农场",Icon="swords"});
Window:SelectTab(2);
local stopAll = false;
local activeHarvestLoops = {};
local stopAll = false;
local harvestLocks = {};
local stopAll = false;
local activeHarvestLoops = {};
CombatTab:Toggle({Title="自动收菜",Desc="在田园范围内高效收菜，开启后掉帧，建议挂机时使用",Default=false,Callback=function(state)
	if state then
		stopAll = false;
		task.spawn(function()
			local remoteEvents = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents");
			local harvestEvent = remoteEvents:WaitForChild("HarvestFruit");
			while not stopAll do
				task.wait(0.2);
				local clientPlants = workspace:FindFirstChild("ClientPlants");
				if not clientPlants then
					continue;
				end
				for _, plantModel in ipairs(clientPlants:GetChildren()) do
					if not plantModel:IsA("Model") then
						continue;
					end
					local currentUuid = plantModel:GetAttribute("Uuid");
					if not currentUuid then
						continue;
					end
					if activeHarvestLoops[currentUuid] then
						continue;
					end
					activeHarvestLoops[currentUuid] = true;
					task.spawn(function()
						local myUuid = currentUuid;
						while not stopAll do
							if not plantModel.Parent then
								break;
							end
							local nowUuid = plantModel:GetAttribute("Uuid");
							if (nowUuid ~= myUuid) then
								break;
							end
							local hasNested = false;
							for _, child in ipairs(plantModel:GetDescendants()) do
								if (child:IsA("Model") and (child ~= plantModel)) then
									hasNested = true;
									break;
								end
							end
							if hasNested then
								for index = 1, 5 do
									if stopAll then
										break;
									end
									local args = {{{GrowthAnchorIndex=index,Uuid=myUuid}}};
									pcall(function()
										harvestEvent:FireServer(unpack(args));
									end);
									task.wait(0.01);
								end
							else
								local args = {{{Uuid=myUuid}}};
								pcall(function()
									harvestEvent:FireServer(unpack(args));
								end);
							end
							task.wait(0.5);
						end
						if activeHarvestLoops[myUuid] then
							activeHarvestLoops[myUuid] = nil;
						end
					end);
				end
			end
			activeHarvestLoops = {};
		end);
	else
		stopAll = true;
	end
end});
local selectedSeed = "Carrot Seed";
local isAutoBuying = false;
local function getSeedKey(seedName)
	return (seedName:gsub(" Seed", ""));
end
CombatTab:Dropdown({Title="选择要购买的种子",Values={"Carrot Seed","Corn Seed","Onion Seed","Strawberry Seed","Mushroom Seed","Beetroot Seed","Tomato Seed","Apple Seed","Rose Seed","Wheat Seed","Banana Seed","Plum Seed","Potato Seed","Cabbage Seed","Cherry Seed","Bamboo Seed","Mango Seed"},Value="Carrot Seed",Callback=function(ZhongZi)
	selectedSeed = ZhongZi;
end});
CombatTab:Toggle({Title="自动抢购种子",Desc="选择的种子有货会秒传购买，没货会自动传送到自己的Plot",Default=false,Callback=function(state)
	isAutoBuying = state;
	if not state then
		return;
	end
	task.spawn(function()
		local player = game:GetService("Players").LocalPlayer;
		local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("PurchaseShopItem");
		local targetCFrame = CFrame.new(176.70369, 201.054993, 672);
		local plotLocations = {plot1=CFrame.new(164.290833, 185, 348.025513),plot2=CFrame.new(390.363647, 208, 377.339386),plot3=CFrame.new(382.556061, 214.5, 742.652771),plot4=CFrame.new(162.660553, 186.5, 934.095032),plot5=CFrame.new(-81.4711914, 196.5, 870.66095),plot6=CFrame.new(-64.4172974, 201.5, 375.661041)};
		local hasTeleportedToPlot = false;
		while isAutoBuying do
			local character = player.Character;
			local hrp = character and character:FindFirstChild("HumanoidRootPart");
			if hrp then
				local seedKey = getSeedKey(selectedSeed);
				local stockTextPath = player.PlayerGui.SeedShop.Frame.ScrollingFrame:FindFirstChild(seedKey);
				if stockTextPath then
					stockTextPath = stockTextPath.MainInfo.StockText;
				end
				if (stockTextPath and stockTextPath.Text and (stockTextPath.Text ~= "NO STOCK")) then
					hasTeleportedToPlot = false;
					hrp.CFrame = targetCFrame;
					task.wait(0.1);
					pcall(function()
						remote:InvokeServer("SeedShop", selectedSeed);
					end);
					task.wait(0.5);
				else
					if not hasTeleportedToPlot then
						pcall(function()
							local plotSelector = player.PlayerGui:FindFirstChild("PlotSelector");
							if plotSelector then
								local plotTextLabel = plotSelector.Frame.MiddleBit:FindFirstChild("PlotText");
								if (plotTextLabel and plotTextLabel.Text and (plotTextLabel.Text ~= "")) then
									local plotName = string.lower(string.gsub(plotTextLabel.Text, " ", ""));
									local targetPlotCFrame = plotLocations[plotName];
									if targetPlotCFrame then
										hrp.CFrame = targetPlotCFrame;
										hasTeleportedToPlot = true;
									end
								end
							end
						end);
					end
					task.wait(0.3);
				end
			else
				task.wait(0.3);
			end
		end
	end);
end});
local autoSellEnabled = false;
CombatTab:Toggle({Title="自动售卖",Desc="每5秒自动传送售卖一次",Default=false,Callback=function(state)
	autoSellEnabled = state;
	if not state then
		return;
	end
	task.spawn(function()
		local player = game:GetService("Players").LocalPlayer;
		local sellRemote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("SellItems");
		local shopCFrame = CFrame.new(149.3974, 201.054993, 671.999878);
		local plotLocations = {plot1=CFrame.new(164.290833, 185, 348.025513),plot2=CFrame.new(390.363647, 208, 377.339386),plot3=CFrame.new(382.556061, 214.5, 742.652771),plot4=CFrame.new(162.660553, 186.5, 934.095032),plot5=CFrame.new(-81.4711914, 196.5, 870.66095),plot6=CFrame.new(-64.4172974, 201.5, 375.661041)};
		while autoSellEnabled do
			local character = player.Character;
			local hrp = character and character:FindFirstChild("HumanoidRootPart");
			if hrp then
				hrp.CFrame = shopCFrame;
				task.wait(0.2);
				for i = 1, 5 do
					if not autoSellEnabled then
						break;
					end
					pcall(function()
						sellRemote:InvokeServer("SellAll");
					end);
					task.wait(0.1);
				end
				pcall(function()
					local plotSelector = player.PlayerGui:FindFirstChild("PlotSelector");
					if plotSelector then
						local plotTextLabel = plotSelector.Frame.MiddleBit:FindFirstChild("PlotText");
						if (plotTextLabel and plotTextLabel.Text and (plotTextLabel.Text ~= "")) then
							local plotName = string.lower(string.gsub(plotTextLabel.Text, " ", ""));
							local targetPlotCFrame = plotLocations[plotName];
							if targetPlotCFrame then
								hrp.CFrame = targetPlotCFrame;
							end
						end
					end
				end);
				task.wait(5);
			else
				task.wait(0.5);
			end
		end
	end);
end});
