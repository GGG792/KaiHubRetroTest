local HttpService = cloneref(game:GetService("HttpService"));
local Players = cloneref(game:GetService("Players"));
local LocalPlayer = cloneref(Players.LocalPlayer);
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"));
local isfunctionhooked = clonefunction(isfunctionhooked);
if (isfunctionhooked(game.HttpGet) or isfunctionhooked(getnamecallmethod) or isfunctionhooked(request)) then
	return;
end
pcall(function()
	hookfunction(require(ReplicatedStorage:FindFirstChild("Source"):FindFirstChild("Utility"):FindFirstChild("NPC"):FindFirstChild("PathUtility")).GetMovementTime, function(...)
		return 0.1;
	end);
end);
local Data = {["自动收集钱"]=false,["自动收集餐具"]=false,["自动烹饪"]=false,["自动给食物"]=false,["自动拿订单"]=false,["自动接订单"]=false,["自动选桌子"]=false,["自动拿零钱"]=false};
function GetFriend()
	for _, v in next, Players:GetPlayers() do
		if LocalPlayer:IsFriendsWith(v.UserId) then
			return v;
		end
	end
	return nil;
end
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
local MyTab = Window:Tab({Title="我的餐厅",Icon="home"});
local FriendTab = Window:Tab({Title="好友餐厅",Icon="users"});
Window:SelectTab(1);
MyTab:Toggle({Title="自动收集账单",Value=false,Callback=function(state)
	Data["自动收集钱"] = state;
	spawn(function()
		while Data["自动收集钱"] do
			pcall(function()
				for _, v in pairs(workspace.Tycoons:GetChildren()) do
					if (v.Player.Value == LocalPlayer) then
						for _, a in pairs(v.Items.Surface:GetChildren()) do
							if a:FindFirstChild("Bill") then
								ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer({Tycoon=v,Name="CollectBill",FurnitureModel=a});
							end
						end
					end
				end
			end);
			task.wait(0.1);
		end
	end);
end});
MyTab:Toggle({Title="自动收集餐具",Value=false,Callback=function(state)
	Data["自动收集餐具"] = state;
	spawn(function()
		while Data["自动收集餐具"] do
			pcall(function()
				for _, v in pairs(workspace.Tycoons:GetChildren()) do
					if (v.Player.Value == LocalPlayer) then
						for _, a in pairs(v.Items.Surface:GetChildren()) do
							if (a.Name:find("T") and a:FindFirstChild("Trash")) then
								ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer({Tycoon=v,Name="CollectDishes",FurnitureModel=a});
							end
						end
					end
				end
			end);
			task.wait(0.1);
		end
	end);
end});
MyTab:Toggle({Title="自动烹饪",Value=false,Callback=function(state)
	Data["自动烹饪"] = state;
	spawn(function()
		while Data["自动烹饪"] do
			pcall(function()
				for _, v in pairs(workspace.Tycoons:GetChildren()) do
					if (v:FindFirstChild("Player") and (v.Player.Value == LocalPlayer)) then
						for _, a in pairs(v.Items.Surface:GetDescendants()) do
							if a.Name:find("Oven") then
								ReplicatedStorage.Events.Cook.CookInputRequested:FireServer("Interact", a.Parent, "Oven");
							end
						end
					end
				end
			end);
			task.wait(0.1);
		end
	end);
end});
MyTab:Toggle({Title="自动送餐",Value=false,Callback=function(state)
	Data["自动给食物"] = state;
	spawn(function()
		while Data["自动给食物"] do
			pcall(function()
				for _, v in pairs(workspace.Tycoons:GetChildren()) do
					if (v:FindFirstChild("Player") and (v.Player.Value == LocalPlayer)) then
						for _, a in pairs(v.Objects.Food:GetChildren()) do
							if not a:GetAttribute("Taken") then
								ReplicatedStorage.Events.Restaurant.GrabFood:InvokeServer(a);
								for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
									if (gui:IsA("ImageLabel") and gui.Parent and (gui.Parent.Parent.Parent.Name == "CustomerSpeechUI")) then
										ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer({Name="Serve",GroupId=tostring(gui.Parent.Parent.Parent.Adornee.Parent.Parent.Name),Tycoon=v,FoodModel=a,CustomerId=tostring(gui.Parent.Parent.Parent.Adornee.Parent.Name)});
									end
								end
							end
						end
					end
				end
			end);
			task.wait(0.1);
		end
	end);
end});
MyTab:Toggle({Title="自动接单",Value=false,Callback=function(state)
	Data["自动接订单"] = state;
	spawn(function()
		while Data["自动接订单"] do
			pcall(function()
				for _, v in pairs(workspace.Tycoons:GetChildren()) do
					if (v:FindFirstChild("Player") and (v.Player.Value == LocalPlayer)) then
						for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
							if (gui:IsA("ImageLabel") and gui.Parent and (gui.Parent.Parent.Parent.Name == "CustomerSpeechUI")) then
								ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer({Name="TakeOrder",GroupId=tostring(gui.Parent.Parent.Parent.Adornee.Parent.Parent.Name),Tycoon=v,CustomerId=tostring(gui.Parent.Parent.Parent.Adornee.Parent.Name)});
							end
						end
					end
				end
			end);
			task.wait(0.1);
		end
	end);
end});
MyTab:Toggle({Title="自动安排座位",Value=false,Callback=function(state)
	Data["自动选桌子"] = state;
	spawn(function()
		while Data["自动选桌子"] do
			pcall(function()
				for _, v in pairs(workspace.Tycoons:GetChildren()) do
					if (v.Player.Value == LocalPlayer) then
						for _, a in pairs(v.Items.Surface:GetChildren()) do
							if (a.Name:find("T") and not a:GetAttribute("InUse")) then
								for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
									if (gui:IsA("ImageLabel") and gui.Parent and (gui.Parent.Parent.Parent.Name == "CustomerSpeechUI")) then
										ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer({FurnitureModel=a,Tycoon=v,Name="SendToTable",GroupId=tostring(gui.Parent.Parent.Parent.Adornee.Parent.Parent.Name)});
									end
								end
							end
						end
					end
				end
			end);
			task.wait(0.5);
		end
	end);
end});
MyTab:Toggle({Title="自动收取小费",Value=false,Callback=function(state)
	Data["自动拿零钱"] = state;
	spawn(function()
		while Data["自动拿零钱"] do
			pcall(function()
				for _, v in pairs(workspace.Tycoons:GetChildren()) do
					if (v:FindFirstChild("Player") and (v.Player.Value == LocalPlayer)) then
						ReplicatedStorage.Events.Restaurant.TipsCollected:FireServer(v);
					end
				end
			end);
			task.wait(1);
		end
	end);
end});
FriendTab:Paragraph({Title="说明",Desc="若服务器内有好友，下方功能将对好友大亨生效"});
FriendTab:Toggle({Title="帮好友收集账单",Callback=function(state)
	local fData = state;
	spawn(function()
		while fData do
			local fr = GetFriend();
			if fr then
				pcall(function()
					for _, v in pairs(workspace.Tycoons:GetChildren()) do
						if (v.Player.Value == fr) then
							for _, a in pairs(v.Items.Surface:GetChildren()) do
								if a:FindFirstChild("Bill") then
									ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer({Tycoon=v,Name="CollectBill",FurnitureModel=a});
								end
							end
						end
					end
				end);
			end
			task.wait(0.5);
		end
	end);
end});
