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
local Tab1 = Window:Tab({Title="基础功能",Icon="crown"});
local Tab2 = Window:Tab({Title="购买功能",Icon="crown"});
Window:SelectTab(1);
local AutoLift = false;
Tab1:Toggle({Title="自动锻炼",Value=false,Callback=function(state)
	AutoLift = state;
	if state then
		task.spawn(function()
			while AutoLift do
				local args = {[1]={[1]="GainMuscle"}};
				game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args));
				task.wait(0.1);
			end
		end);
	end
end});
local AutoSell = false;
Tab1:Toggle({Title="自动出售",Value=false,Callback=function(state)
	AutoSell = state;
	if state then
		task.spawn(function()
			while AutoSell do
				local args = {[1]={[1]="SellMuscle"}};
				game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args));
				task.wait(0.1);
			end
		end);
	end
end});
Tab1:Toggle({Title="打开商店",Value=false,Callback=function(state)
	local frame = game:GetService("Players").LocalPlayer.PlayerGui.Main_Gui.UpgradeMenu_Frame;
	if frame then
		frame.Visible = state;
	end
end});
local function parseCurrency(text)
	if (not text or (text == "")) then
		return nil;
	end
	local numberStr = text:match("^(.-)[KkMmBbTt]?$");
	local suffix = text:match("[KkMmBbTt]$");
	local number = tonumber(numberStr);
	if not number then
		return nil;
	end
	if suffix then
		local multipliers = {K=1000,k=1000,M=1000000,m=1000000,B=1000000000,b=1000000000,T=999999995904,t=999999995904};
		number = number * (multipliers[suffix] or 1);
	end
	return number;
end
getgenv().buyfarm = false;
Tab2:Toggle({Title="自动购买举重物品",Value=false,Callback=function(state)
	getgenv().buyfarm = state;
	if state then
		task.spawn(function()
			while getgenv().buyfarm do
				local player = game:GetService("Players").LocalPlayer;
				local page = player.PlayerGui.Main_Gui.UpgradeInfo_Frame.PageList.Page01;
				for _, v in pairs(page:GetChildren()) do
					if (v:IsA("ImageButton") and v:FindFirstChild("LockImage") and not v.LockImage.Visible and v:FindFirstChild("tlPrice") and (v.tlPrice.Text ~= "Owned") and (v.tlPrice.Text ~= "Equipped") and (v.tlPrice.Text ~= "") and (v.tlPrice.Text ~= " ") and not string.find(v.tlPrice.Text, "R")) then
						local price = parseCurrency(v.tlPrice.Text);
						local cashText = player.PlayerGui.Main_Gui.DataMenu_Frame.Cash.Status.Text;
						local cash = parseCurrency(cashText);
						if (price and cash and (price <= cash)) then
							for try = 1, 142 do
								if ((v:FindFirstChild("tlPrice").Text == "Equipped") or (v:FindFirstChild("tlPrice").Text == "Owned")) then
									break;
								end
								local args = {[1]={[1]="BuyItem",[2]="Income_Item",[3]=v.Name,[4]=try}};
								game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args));
								task.wait(0.05);
							end
						end
					end
				end
				task.wait(0.5);
			end
		end);
	end
end});
getgenv().buyfarma = false;
Tab2:Toggle({Title="自动购买背包容量",Value=false,Callback=function(state)
	getgenv().buyfarma = state;
	if state then
		task.spawn(function()
			while getgenv().buyfarma do
				local player = game:GetService("Players").LocalPlayer;
				local page = player.PlayerGui.Main_Gui.UpgradeInfo_Frame.PageList.Page02;
				for _, v in pairs(page:GetChildren()) do
					if (v:IsA("ImageButton") and v:FindFirstChild("LockImage") and not v.LockImage.Visible and v:FindFirstChild("tlPrice") and (v.tlPrice.Text ~= "Owned") and (v.tlPrice.Text ~= "Equipped") and (v.tlPrice.Text ~= "") and (v.tlPrice.Text ~= " ") and not string.find(v.tlPrice.Text, "R")) then
						local price = parseCurrency(v.tlPrice.Text);
						local cashText = player.PlayerGui.Main_Gui.DataMenu_Frame.Cash.Status.Text;
						local cash = parseCurrency(cashText);
						if (price and cash and (price <= cash)) then
							for try = 1, 78 do
								if ((v:FindFirstChild("tlPrice").Text == "Equipped") or (v:FindFirstChild("tlPrice").Text == "Owned")) then
									break;
								end
								local args = {[1]={[1]="BuyItem",[2]="Bag_Item",[3]=v.Name,[4]=try}};
								game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args));
								task.wait(0.05);
							end
						end
					end
				end
				task.wait(0.5);
			end
		end);
	end
end});
getgenv().buyfarmb = false;
Tab2:Toggle({Title="自动购买重生",Value=false,Callback=function(state)
	getgenv().buyfarmb = state;
	if state then
		task.spawn(function()
			while getgenv().buyfarmb do
				local player = game:GetService("Players").LocalPlayer;
				local page = player.PlayerGui.Main_Gui.UpgradeInfo_Frame.PageList.Page03;
				for _, v in pairs(page:GetChildren()) do
					if (v:IsA("ImageButton") and v:FindFirstChild("LockImage") and not v.LockImage.Visible and v:FindFirstChild("tlPrice") and (v.tlPrice.Text ~= "Owned") and (v.tlPrice.Text ~= "Equipped") and (v.tlPrice.Text ~= "") and (v.tlPrice.Text ~= " ") and not string.find(v.tlPrice.Text, "R")) then
						local price = parseCurrency(v.tlPrice.Text);
						local cashText = player.PlayerGui.Main_Gui.DataMenu_Frame.Cash.Status.Text;
						local cash = parseCurrency(cashText);
						if (price and cash and (price <= cash)) then
							for try = 1, 80 do
								if ((v:FindFirstChild("tlPrice").Text == "Equipped") or (v:FindFirstChild("tlPrice").Text == "Owned")) then
									break;
								end
								local args = {[1]={[1]="BuyItem",[2]="Rebirth_Item",[3]=v.Name,[4]=try}};
								game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args));
								task.wait(0.05);
							end
						end
					end
				end
				task.wait(0.5);
			end
		end);
	end
end});
