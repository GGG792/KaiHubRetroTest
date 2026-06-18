local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Stats = game:GetService("Stats");
local VirtualInputManager = game:GetService("VirtualInputManager");
local VirtualUser = game:GetService("VirtualUser");
local CoreGui = game:GetService("CoreGui");
local Lighting = game:GetService("Lighting");
local LocalPlayer = Players.LocalPlayer;
local parryCount = 0;
local roundCount = 0;
local AutoParryEnabled = true;
local AntiAfkEnabled = true;
local Blur = Instance.new("BlurEffect");
Blur.Size = 20;
Blur.Name = "VicoMenuBlur";
Blur.Parent = Lighting;
if CoreGui:FindFirstChild("VicoImmersiveUI") then
	CoreGui.VicoImmersiveUI:Destroy();
end
local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "VicoImmersiveUI";
ScreenGui.Parent = CoreGui;
ScreenGui.DisplayOrder = 999;
local BackgroundDim = Instance.new("Frame");
BackgroundDim.Size = UDim2.new(1, 0, 1, 0);
BackgroundDim.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
BackgroundDim.BackgroundTransparency = 0.5;
BackgroundDim.BorderSizePixel = 0;
BackgroundDim.Parent = ScreenGui;
local MainFrame = Instance.new("Frame");
MainFrame.Name = "MainFrame";
MainFrame.Size = UDim2.new(0, 280, 0, 320);
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -160);
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
MainFrame.BorderSizePixel = 0;
MainFrame.Active = true;
MainFrame.Parent = ScreenGui;
local UICorner = Instance.new("UICorner");
UICorner.CornerRadius = UDim.new(0, 15);
UICorner.Parent = MainFrame;
local UIStroke = Instance.new("UIStroke");
UIStroke.Color = Color3.fromRGB(255, 255, 255);
UIStroke.Thickness = 2;
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
UIStroke.Parent = MainFrame;
local Title = Instance.new("TextLabel");
Title.Size = UDim2.new(1, 0, 0, 60);
Title.Text = "杨志卡挂机";
Title.TextColor3 = Color3.fromRGB(30, 30, 30);
Title.TextSize = 22;
Title.Font = Enum.Font.SourceSansBold;
Title.BackgroundTransparency = 1;
Title.Parent = MainFrame;
local StatsFrame = Instance.new("Frame");
StatsFrame.Size = UDim2.new(0, 240, 0, 90);
StatsFrame.Position = UDim2.new(0.5, -120, 0, 65);
StatsFrame.BackgroundColor3 = Color3.fromRGB(248, 248, 248);
StatsFrame.Parent = MainFrame;
local StatsCorner = Instance.new("UICorner");
StatsCorner.CornerRadius = UDim.new(0, 10);
StatsCorner.Parent = StatsFrame;
local ParriedLabel = Instance.new("TextLabel");
ParriedLabel.Size = UDim2.new(1, -20, 0, 45);
ParriedLabel.Position = UDim2.new(0, 15, 0, 0);
ParriedLabel.Text = "已成功格挡: 0";
ParriedLabel.TextColor3 = Color3.fromRGB(100, 100, 100);
ParriedLabel.TextSize = 17;
ParriedLabel.Font = Enum.Font.SourceSansSemibold;
ParriedLabel.TextXAlignment = Enum.TextXAlignment.Left;
ParriedLabel.BackgroundTransparency = 1;
ParriedLabel.Parent = StatsFrame;
local RoundsLabel = Instance.new("TextLabel");
RoundsLabel.Size = UDim2.new(1, -20, 0, 45);
RoundsLabel.Position = UDim2.new(0, 15, 0, 40);
RoundsLabel.Text = "当前游戏轮数: 0";
RoundsLabel.TextColor3 = Color3.fromRGB(100, 100, 100);
RoundsLabel.TextSize = 17;
RoundsLabel.Font = Enum.Font.SourceSansSemibold;
RoundsLabel.TextXAlignment = Enum.TextXAlignment.Left;
RoundsLabel.BackgroundTransparency = 1;
RoundsLabel.Parent = StatsFrame;
local function CreateButton(name, pos, defaultState, callback)
	local btn = Instance.new("TextButton");
	btn.Size = UDim2.new(0, 240, 0, 45);
	btn.Position = pos;
	btn.Font = Enum.Font.SourceSansBold;
	btn.TextSize = 16;
	btn.AutoButtonColor = true;
	btn.Parent = MainFrame;
	local corner = Instance.new("UICorner");
	corner.CornerRadius = UDim.new(0, 10);
	corner.Parent = btn;
	local function updateStyle(state)
		if state then
			btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50);
			btn.TextColor3 = Color3.fromRGB(255, 255, 255);
			btn.Text = "√ " .. name .. ": 已开启";
		else
			btn.BackgroundColor3 = Color3.fromRGB(220, 220, 220);
			btn.TextColor3 = Color3.fromRGB(100, 100, 100);
			btn.Text = "X " .. name .. ": 已禁用";
		end
	end
	updateStyle(defaultState);
	btn.MouseButton1Click:Connect(function()
		local newState = not _G[name .. "_State"];
		_G[name .. "_State"] = newState;
		updateStyle(newState);
		callback(newState);
	end);
	_G[name .. "_State"] = defaultState;
end
local function updateUI()
	ParriedLabel.Text = "已成功格挡: " .. parryCount;
	RoundsLabel.Text = "当前游戏轮数: " .. roundCount;
end
LocalPlayer.CharacterAdded:Connect(function()
	roundCount = roundCount + 1;
	updateUI();
end);
local function DoParry()
	pcall(function()
		ReplicatedStorage.Remotes.ParryButtonPress:Fire();
		VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0);
		VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0);
		parryCount = parryCount + 1;
		updateUI();
	end);
end
RunService.PreRender:Connect(function()
	if not AutoParryEnabled then
		return;
	end
	local char = LocalPlayer.Character;
	if (not char or not char:FindFirstChild("HumanoidRootPart")) then
		return;
	end
	local ball = nil;
	local ballsFolder = workspace:FindFirstChild("Balls");
	if ballsFolder then
		for _, v in pairs(ballsFolder:GetChildren()) do
			if (v:GetAttribute("realBall") == true) then
				ball = v;
				break;
			end
		end
	end
	if (ball and char:FindFirstChild("Highlight")) then
		local velocity = ball.AssemblyLinearVelocity.Magnitude;
		local distance = (ball.Position - char.HumanoidRootPart.Position).Magnitude;
		local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000;
		local range = (20 * ping) + ((velocity / math.pi) * 2.3);
		if ((velocity > 5) and (distance <= range)) then
			DoParry();
			task.wait(0.15);
		end
	end
end);
LocalPlayer.Idled:Connect(function()
	if AntiAfkEnabled then
		VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame);
		task.wait(0.5);
		VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame);
	end
end);
CreateButton("自动格挡", UDim2.new(0.5, -120, 0, 170), true, function(state)
	AutoParryEnabled = state;
end);
CreateButton("抗挂机防踢", UDim2.new(0.5, -120, 0, 225), true, function(state)
	AntiAfkEnabled = state;
end);
