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
local Tab = Window:Tab({Title="功能",Icon="sparkles",Locked=false});
Window:SelectTab(1);
local isFarming = false;
local AutoFarmToggle = Tab:Toggle({Title="自动按钮",Type="Checkbox",Value=false,Callback=function(state)
	isFarming = state;
	if isFarming then
		task.spawn(function()
			local Players = game:GetService("Players");
			local player = Players.LocalPlayer;
			while isFarming do
				local tycoonMain = workspace:FindFirstChild("TycoonMain");
				local tycoonsFolder = tycoonMain and tycoonMain:FindFirstChild("Tycoons");
				if tycoonsFolder then
					local myTycoon = nil;
					for _, tycoon in ipairs(tycoonsFolder:GetChildren()) do
						local ownerValue = tycoon:FindFirstChild("Owner");
						if (ownerValue and ((ownerValue.Value == player.Name) or (ownerValue.Value == player) or (tostring(ownerValue.Value) == player.Name))) then
							myTycoon = tycoon;
							break;
						end
					end
					if myTycoon then
						local buttonsFolder = myTycoon:FindFirstChild("Buttons");
						if buttonsFolder then
							local currentButtons = buttonsFolder:GetChildren();
							for _, button in ipairs(currentButtons) do
								if not isFarming then
									break;
								end
								local character = player.Character;
								if not character then
									continue;
								end
								local hrp = character:FindFirstChild("HumanoidRootPart");
								if hrp then
									local targetCFrame = nil;
									if button:IsA("BasePart") then
										targetCFrame = button.CFrame;
									elseif button:IsA("Model") then
										local part = button.PrimaryPart or button:FindFirstChild("Head") or button:FindFirstChildWhichIsA("BasePart", true);
										if part then
											targetCFrame = part.CFrame;
										end
									end
									if targetCFrame then
										hrp.CFrame = targetCFrame + Vector3.new(0, 1.5, 0);
										task.wait(0.5);
									end
								end
							end
						end
					end
				end
				task.wait(1);
			end
		end);
	end
end});
local autoRebirth = false;
local RebirthToggle = Tab:Toggle({Title="自动重生",Type="Checkbox",Value=false,Callback=function(state)
	autoRebirth = state;
	if autoRebirth then
		task.spawn(function()
			local ReplicatedStorage = game:GetService("ReplicatedStorage");
			while autoRebirth do
				local remotes = ReplicatedStorage:FindFirstChild("remotes");
				local rebirthEvent = remotes and remotes:FindFirstChild("Rebirth");
				if rebirthEvent then
					rebirthEvent:FireServer();
				end
				task.wait(0.5);
			end
		end);
	end
end});
