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
local MainTab = Window:Tab({Title="主要功能",Icon="star"});
Window:SelectTab(1);
MainTab:Section({Title="恶搞功能",Icon="coins"});
MainTab:Toggle({Title="让对手看不见球",Default=false,Callback=function(state)
	getgenv().HI = state;
	local ev;
	for _, v in pairs(getnilinstances()) do
		if (v.Name == "EventHandlerClient") then
			ev = v;
			break;
		end
	end
	if (getgenv().HI and ev) then
		getgenv()._InvisibleBallsConn = coroutine.create(function()
			while getgenv().HI do
				wait(0.2);
				for i = 1, 15 do
					pcall(function()
						require(ev):FireRemoteEvent("UpdateBalls", {[i .. "Ball"]=CFrame.new(1, 1, 1)});
					end);
				end
			end
		end);
		coroutine.resume(getgenv()._InvisibleBallsConn);
	elseif (state and not ev) then
		WindUI:Notify({Title="错误",Content="无法找到 EventHandlerClient，可能执行器不支持或游戏已更新",Duration=3});
	end
end});
local extendedLineConn;
local trajectoryParts = {};
MainTab:Toggle({Title="延长线",Default=false,Callback=function(state)
	local activeTable = workspace:FindFirstChild("Tables") and (workspace.Tables:FindFirstChild("Table1") or workspace.Tables:FindFirstChild("Table2") or workspace.Tables:FindFirstChild("Table3"));
	if not activeTable then
		WindUI:Notify({Title="错误",Content="未找到球桌 (Table)，请进入对局后再试",Duration=3});
		return;
	end
	local Guides = activeTable:FindFirstChild("Guides");
	local HitTrajectory = Guides and Guides:FindFirstChild("HitTrajectory");
	if not HitTrajectory then
		WindUI:Notify({Title="错误",Content="未找到预测线 (HitTrajectory)",Duration=3});
		return;
	end
	local maxSegments = 5;
	local segmentLength = 10;
	local function clearTrajectory()
		for _, part in pairs(trajectoryParts) do
			if (part and part.Parent) then
				part:Destroy();
			end
		end
		trajectoryParts = {};
	end
	if extendedLineConn then
		extendedLineConn:Disconnect();
		extendedLineConn = nil;
	end
	clearTrajectory();
	if state then
		local function updateTrajectory()
			clearTrajectory();
			local startPos = HitTrajectory.Position;
			local direction = HitTrajectory.CFrame.LookVector.Unit;
			local currentPos = startPos;
			for i = 1, maxSegments do
				local nextPos = currentPos + (direction * segmentLength);
				local line = Instance.new("Part");
				line.Size = Vector3.new(0.2, 0.2, segmentLength);
				line.CFrame = CFrame.lookAt(currentPos, nextPos) * CFrame.new(0, 0, -segmentLength / 2);
				line.BrickColor = BrickColor.Green();
				line.Anchored = true;
				line.CanCollide = false;
				line.Material = Enum.Material.Neon;
				line.Parent = workspace;
				table.insert(trajectoryParts, line);
				currentPos = nextPos;
			end
		end
		extendedLineConn = HitTrajectory:GetPropertyChangedSignal("CFrame"):Connect(updateTrajectory);
		updateTrajectory();
		if not getgenv()._ExtendedLines then
			getgenv()._ExtendedLines = {};
		end
		getgenv()._ExtendedLines.Clear = clearTrajectory;
	elseif (getgenv()._ExtendedLines and getgenv()._ExtendedLines.Clear) then
		getgenv()._ExtendedLines.Clear();
	end
end});
