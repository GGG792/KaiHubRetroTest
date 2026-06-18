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
local plrs = game:GetService("Players");
local rs = game:GetService("ReplicatedStorage");
local wrp = rs:WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable");
local gameplay = workspace:WaitForChild("Gameplay");
local plots = gameplay:WaitForChild("Plots");
local fallbackDiscardPos = Vector3.new(-1.9073486328125E-06, 1, -143.499969);
local IGNORE_RADIUS = 10;
local Y_OFFSET = 1.5;
local containerTypes = {"JunkContainer","OverpoweredContainer","MilitaryContainer","ScratchedContainer","SealedContainer","GroupContainer","MetalContainer","SparkleContainer","AlienContainer","FrozenContainer","CorruptedContainer","LavaContainer","StormedContainer","LightningContainer","InfernalContainer","TutorialContainer","MysticContainer","GlitchedContainer","AstralContainer","DreamContainer","CelestialContainer","FireContainer","BasicFlowerContainer","GoodFlowerContainer","GoldenContainer","DiamondContainer","EmeraldContainer","RubyContainer","SapphireContainer","SpaceContainer","DeepSpaceContainer","VortexContainer","BlackHoleContainer","CamoContainer","ObsidianContainer","GoldenAuraContainer","ChristmasContainer","MedievalContainer","ConstructionContainer","EggContainer","RareFlowerContainer"};
local selectedContainer = "JunkContainer";
local autoEnabled = false;
local autoCoroutine = nil;
local function notify(title, content, dur)
	WindUI:Notify({Title=title,Content=content,Duration=(dur or 2)});
end
local function getlp()
	return plrs.LocalPlayer;
end
local function getdiscardpos(plot)
	local basePos = fallbackDiscardPos;
	if plot then
		local housePart = plot:FindFirstChild("PlotDecor") and plot.PlotDecor:FindFirstChild("House") and plot.PlotDecor.House:FindFirstChild("Part");
		if (housePart and housePart:IsA("BasePart")) then
			basePos = housePart.Position;
		end
	end
	return basePos + Vector3.new(0, Y_OFFSET, 0);
end
local function getnearestplot()
	local lp = getlp();
	if not lp then
		return;
	end
	local char = lp.Character;
	if not char then
		return;
	end
	local hrp = char:FindFirstChild("HumanoidRootPart");
	if not hrp then
		return;
	end
	local minDist = math.huge;
	local nearPlot = nil;
	for _, plot in ipairs(plots:GetChildren()) do
		if (plot.Name and plot.Name:upper():find("FAKE")) then
			continue;
		end
		local pos;
		local part = plot:FindFirstChild("Plot");
		if (part and part:IsA("BasePart")) then
			pos = part.Position;
		elseif plot.PrimaryPart then
			pos = plot.PrimaryPart.Position;
		else
			pos = plot:GetPivot().Position;
		end
		if pos then
			local dist = (hrp.Position - pos).Magnitude;
			if (dist < minDist) then
				minDist = dist;
				nearPlot = plot;
			end
		end
	end
	return nearPlot;
end
local function buycrates(ctype, count)
	local body = buffer.fromstring("\254\001\000\006\r" .. ctype);
	local op = buffer.fromstring("I");
	for _ = 1, count do
		wrp:FireServer(op, body);
		task.wait(0.01);
	end
	notify("购买", string.format("已购买 %d 个 %s", count, ctype));
end
local function openallcrates(holder)
	local opened = 0;
	for _, cont in ipairs(holder:GetChildren()) do
		local contId = cont.Name;
		if (contId:sub(1, 10) == "CONTAINER_") then
			local body = buffer.fromstring("\254\001\000\006." .. contId);
			wrp:FireServer(buffer.fromstring("K"), body);
			opened = opened + 1;
			task.wait(0.1);
		end
	end
	if (opened > 0) then
		notify("开箱", string.format("已开启 %d 个箱子", opened));
	end
end
local function isignored(item, discardPosNow)
	local pos;
	if item:IsA("BasePart") then
		pos = item.Position;
	elseif item.PrimaryPart then
		pos = item.PrimaryPart.Position;
	else
		pos = item:GetPivot().Position;
	end
	local off = Vector3.new(pos.X, 0, pos.Z) - Vector3.new(discardPosNow.X, 0, discardPosNow.Z);
	return off.Magnitude <= IGNORE_RADIUS;
end
local function pickupall(cache, discardPosNow)
	local lp = getlp();
	if (not lp or not lp.Character) then
		return;
	end
	local hrp = lp.Character:FindFirstChild("HumanoidRootPart");
	if not hrp then
		return;
	end
	local homePos = hrp.Position;
	local op = buffer.fromstring("\v");
	local header = buffer.fromstring("\254\001\000\006)");
	local picked = 0;
	local skipped = 0;
	while true do
		local children = cache:GetChildren();
		local valid = {};
		for _, item in ipairs(children) do
			if not isignored(item, discardPosNow) then
				table.insert(valid, item);
			else
				skipped = skipped + 1;
			end
		end
		if (#valid == 0) then
			break;
		end
		for _, item in ipairs(valid) do
			hrp = lp.Character:FindFirstChild("HumanoidRootPart");
			if not hrp then
				return;
			end
			local idBuf = buffer.fromstring(item.Name);
			local body = buffer.create(buffer.len(header) + buffer.len(idBuf));
			buffer.copy(body, 0, header, 0, buffer.len(header));
			buffer.copy(body, buffer.len(header), idBuf, 0, buffer.len(idBuf));
			wrp:FireServer(op, body);
			picked = picked + 1;
			task.wait(0.05);
			if ((picked % 9) == 0) then
				local currentPos = hrp.Position;
				hrp.CFrame = CFrame.new(discardPosNow);
				task.wait(0.3);
				wrp:FireServer(buffer.fromstring("\t"), buffer.fromstring("\254\000\000"));
				notify("丢弃", string.format("已拾取 %d 件，前往丢弃", picked));
				task.wait(0.3);
				hrp.CFrame = CFrame.new(currentPos);
				task.wait(0.2);
			end
		end
		task.wait(0.5);
	end
	notify("拾取完成", string.format("拾取 %d 件，跳过 %d 件", picked, skipped));
end
local function discard(discardPosNow)
	if not discardPosNow then
		discardPosNow = getdiscardpos();
	end
	local lp = getlp();
	if (lp and lp.Character) then
		local hrp = lp.Character:FindFirstChild("HumanoidRootPart");
		if hrp then
			hrp.CFrame = CFrame.new(discardPosNow);
			task.wait(0.3);
		end
	end
	wrp:FireServer(buffer.fromstring("\t"), buffer.fromstring("\254\000\000"));
	notify("丢弃", "已传送并丢弃所有物品");
end
local function autoloop()
	while autoEnabled do
		local plot = getnearestplot();
		if not plot then
			task.wait(1);
			continue;
		end
		local holder = plot:FindFirstChild("PlotLogic") and plot.PlotLogic:FindFirstChild("ContainerHolder");
		local cache = plot:FindFirstChild("PlotLogic") and plot.PlotLogic:FindFirstChild("ItemCache");
		if (not holder or not cache) then
			task.wait(1);
			continue;
		end
		local currentDiscardPos = getdiscardpos(plot);
		if (#holder:GetChildren() == 0) then
			notify("状态", "无容器，开始购买");
			buycrates(selectedContainer, 8);
			notify("等待", "等待箱子落地 10.5 秒");
			task.wait(10.5);
		end
		openallcrates(holder);
		pickupall(cache, currentDiscardPos);
		discard(currentDiscardPos);
		task.wait(0.5);
	end
end
local function startauto()
	if autoCoroutine then
		return;
	end
	autoEnabled = true;
	autoCoroutine = task.spawn(autoloop);
	notify("自动循环", "已开启", 2);
end
local function stopauto()
	autoEnabled = false;
	if autoCoroutine then
		task.cancel(autoCoroutine);
		autoCoroutine = nil;
	end
	notify("自动循环", "已停止");
end
local tabAuto = Window:Tab({Title="自动循环",Icon="repeat"});
local tabManual = Window:Tab({Title="手动操作",Icon="hand"});
tabAuto:Dropdown({Title="容器类型",Desc="选择自动购买的箱子类型",Values=containerTypes,Value=selectedContainer,Callback=function(val)
	selectedContainer = val;
end});
tabAuto:Toggle({Title="开启自动循环",Desc="全自动购买、开箱、拾取、丢弃",Type="Checkbox",Value=false,Callback=function(state)
	if state then
		startauto();
	else
		stopauto();
	end
end});
tabManual:Dropdown({Title="容器类型",Desc="选择要手动操作的箱子类型",Values=containerTypes,Value=selectedContainer,Callback=function(val)
	selectedContainer = val;
end});
tabManual:Button({Title="购买指定箱子",Desc="手动购买8个选定的箱子",Callback=function()
	buycrates(selectedContainer, 8);
end});
tabManual:Button({Title="开启所有箱子",Desc="一键开启地块上的所有箱子",Callback=function()
	local plot = getnearestplot();
	if not plot then
		notify("错误", "未找到地块");
		return;
	end
	local holder = plot:FindFirstChild("PlotLogic") and plot.PlotLogic:FindFirstChild("ContainerHolder");
	if not holder then
		notify("错误", "无 ContainerHolder");
		return;
	end
	openallcrates(holder);
end});
tabManual:Button({Title="拾取所有物品",Desc="一键拾取掉落的物品",Callback=function()
	local plot = getnearestplot();
	if not plot then
		notify("错误", "未找到地块");
		return;
	end
	local cache = plot:FindFirstChild("PlotLogic") and plot.PlotLogic:FindFirstChild("ItemCache");
	if not cache then
		notify("错误", "无 ItemCache");
		return;
	end
	local currentDiscardPos = getdiscardpos(plot);
	pickupall(cache, currentDiscardPos);
end});
tabManual:Button({Title="丢弃所有物品",Desc="一键传送并丢弃背包物品",Callback=function()
	local plot = getnearestplot();
	local pos = getdiscardpos(plot);
	discard(pos);
end});
Window:SelectTab(1);
