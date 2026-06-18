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
TabSection = Window:Section({Title="砍伐树木",Opened=true});
local Tab = TabSection:Tab({Title="主要功能",Icon="check"});
Window:SelectTab(1);
local sbxp = false;
Tab:Toggle({Title="范围砍树(可能会卡)",Default=false,Image="check",Callback=function(state)
	sbxp = state;
	while sbxp and wait() do
		for o, s in next, workspace.TreesFolder:GetChildren() do
			game:GetService("ReplicatedStorage"):WaitForChild("Signal"):WaitForChild("Tree"):FireServer("damage", s.Name);
		end
	end
end});
local sbleng = false;
Tab:Toggle({Title="范围捡宝箱(延迟太大就不能用)",Default=false,Image="check",Callback=function(state)
	sbleng = state;
	while sbleng and wait() do
		for o, s in next, workspace.ChestFolder:GetChildren() do
			if s:FindFirstChild("Hitpart") then
				fireproximityprompt(s.Hitpart.ProximityPrompt);
			end
		end
	end
end});
Tabs.Tab:Button({Title="砍伐树木",Desc="砍伐树木",Callback=function()
	local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/454244513/WindUIFix/refs/heads/main/main.lua"))();
	local Window = WindUI:CreateWindow({Title="<font color='#FF0000'>杨志卡 </font>Hub",Author="杨志卡",Folder="CloudHub",Size=UDim2.fromOffset(200, 395),Transparent=true,Theme="Dark",User={Enabled=false,Callback=function()
		print("clicked");
	end,Anonymous=false},SideBarWidth=135,ScrollBarEnabled=true,Background="https://chaton-images.s3.us-east-2.amazonaws.com/c5PCPLQ8Y10qkl83HQp0cCiSqHDcdED2FZ8eDEAG0Ce6gv9paDuTKxxIr7KJCZak_2730x1535x3967957.png",BackgroundImageTransparency=0.5});
	Window:EditOpenButton({Title="<font color='#FF0000'>杨志卡 </font>Hub",CornerRadius=UDim.new(0, 10),StrokeThickness=2.5,Color=ColorSequence.new(Color3.fromHex("#874da2"), Color3.fromHex("#c43a30")),Draggable=true});
	TabSection = Window:Section({Title="砍伐树木",Opened=true});
	local Tab = TabSection:Tab({Title="主要功能",Icon="check"});
	local kan = false;
	Tab:Toggle({Title="范围砍树(可能会卡)",Default=false,Image="check",Callback=function(state)
		kan = state;
		while kan and wait() do
			for o, s in next, workspace.TreesFolder:GetChildren() do
				game:GetService("ReplicatedStorage"):WaitForChild("Signal"):WaitForChild("Tree"):FireServer("damage", s.Name);
			end
		end
	end});
	local bao = false;
	Tab:Toggle({Title="范围捡宝箱(延迟太大就不能用)",Default=false,Image="check",Callback=function(state)
		bao = state;
		while bao and wait() do
			for o, s in next, workspace.ChestFolder:GetChildren() do
				if s:FindFirstChild("Hitpart") then
					fireproximityprompt(s.Hitpart.ProximityPrompt);
				end
			end
		end
	end});
end});
