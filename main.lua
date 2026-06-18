-- ============================================================
-- KaiHub RetroUI - 修复版
-- 缩小UI + 修复内容显示 + 完整功能绑定
-- ============================================================

if not game:IsLoaded() then game.Loaded:Wait(); end;
local cloneref = cloneref or clonereference or function(o) return o; end;
if _G.KaiHubRetroLoaded then warn("[KaiHub] Already loaded!"); return; end;
if _G.KaiHubRetroLoading then warn("[KaiHub] Loading..."); return; end;
_G.KaiHubRetroLoading = true;

local startTime = tick();
local Services = {
	Players = cloneref(game:GetService("Players")),
	RunService = cloneref(game:GetService("RunService")),
	UserInputService = cloneref(game:GetService("UserInputService")),
	TweenService = cloneref(game:GetService("TweenService")),
	Lighting = cloneref(game:GetService("Lighting")),
	Workspace = cloneref(game:GetService("Workspace")),
	TeleportService = cloneref(game:GetService("TeleportService")),
	VirtualUser = cloneref(game:GetService("VirtualUser")),
	StarterGui = cloneref(game:GetService("StarterGui")),
	HttpService = cloneref(game:GetService("HttpService")),
};
local LP = Services.Players.LocalPlayer;
local Mouse = LP:GetMouse();

-- ========== 配色 ==========
local C = {
	WinBg = Color3.fromRGB(212, 208, 200);
	WinTitle = Color3.fromRGB(0, 16, 128);
	WinTitleText = Color3.fromRGB(255, 255, 255);
	BevelLight = Color3.fromRGB(255, 255, 255);
	BevelDark = Color3.fromRGB(128, 128, 128);
	BtnFace = Color3.fromRGB(212, 208, 200);
	BtnHighlight = Color3.fromRGB(240, 240, 240);
	BtnPressed = Color3.fromRGB(180, 180, 180);
	SidebarBg = Color3.fromRGB(236, 233, 228);
	SidebarActive = Color3.fromRGB(49, 106, 197);
	SidebarHover = Color3.fromRGB(220, 218, 214);
	SidebarText = Color3.fromRGB(0, 0, 0);
	SidebarTextActive = Color3.fromRGB(255, 255, 255);
	ContentBg = Color3.fromRGB(255, 255, 255);
	ContentText = Color3.fromRGB(0, 0, 0);
	ContentTextDim = Color3.fromRGB(100, 100, 100);
	InputBg = Color3.fromRGB(255, 255, 255);
	ToggleOn = Color3.fromRGB(49, 106, 197);
	CloseBtn = Color3.fromRGB(180, 60, 60);
	CloseHover = Color3.fromRGB(220, 80, 80);
	MinBtn = Color3.fromRGB(108, 108, 108);
	MinHover = Color3.fromRGB(140, 140, 140);
	SliderFill = Color3.fromRGB(49, 106, 197);
};

-- ========== 3D边框 ==========
local function bevel(parent, style, thick)
	thick = thick or 2;
	local light = style == "raised" and C.BevelLight or C.BevelDark;
	local dark = style == "raised" and C.BevelDark or C.BevelLight;
	local edges = {
		{UDim2.new(0, thick, 1, 0), UDim2.new(0, 0, 0, 0), light},
		{UDim2.new(1, 0, 0, thick), UDim2.new(0, 0, 0, 0), light},
		{UDim2.new(0, thick, 1, 0), UDim2.new(1, -thick, 0, 0), dark},
		{UDim2.new(1, 0, 0, thick), UDim2.new(0, 0, 1, -thick), dark},
	};
	for _, e in ipairs(edges) do
		local f = Instance.new("Frame");
		f.Size = e[1]; f.Position = e[2];
		f.BackgroundColor3 = e[3]; f.BorderSizePixel = 0;
		f.ZIndex = parent.ZIndex + 1; f.Parent = parent;
	end;
end;

-- ========== 核心数据 ==========
local DATA = {
	speed = 16, jump = 50, maxHealth = 100, health = 100, gravity = 196.2,
	lockSpeed = false, lockJump = false, lockHealth = false, lockMaxHealth = false, lockGravity = false,
	antiAfk = true, noclip = false, infJump = false, antiFall = false, antiDead = false,
	nightVision = false, superNightVision = false, xray = false, staffCheck = false,
	fly = false, clickTp = false, esp = false, tpWalk = false, mouseUnlock = false,
	lockCam = false, aimBot = false, scrollSwitch = false, zoom = false, invis = false,
	footstep = false, landing = false, lantern = false, superLight = false, noFog = false,
	freecam = false, airWalk = false, instant = false, chatResend = false,
	spin = false, spinSpeed = 20, fling = false, killAll = false, killAny = false,
	killName = "", killRange = 100,
	origBrightness = Services.Lighting.Brightness,
	origExposure = Services.Lighting.ExposureCompensation,
};

-- ========== 辅助函数 ==========
local function notify(title, text)
	pcall(function()
		Services.StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 3});
	end);
end;

local function getChar()
	return LP.Character;
end;

local function getHum()
	local char = getChar();
	return char and char:FindFirstChildOfClass("Humanoid");
end;

local function getRoot()
	local char = getChar();
	return char and char:FindFirstChild("HumanoidRootPart");
end;

-- ========== 功能实现 ==========
local funcs = {};

function funcs.setSpeed(v)
	local hum = getHum();
	if hum then hum.WalkSpeed = v; DATA.speed = v; end;
end;

function funcs.setJump(v)
	local hum = getHum();
	if hum then hum.JumpPower = v; DATA.jump = v; end;
end;

function funcs.setMaxHealth(v)
	local hum = getHum();
	if hum then hum.MaxHealth = v; DATA.maxHealth = v; end;
end;

function funcs.setHealth(v)
	local hum = getHum();
	if hum then hum.Health = v; DATA.health = v; end;
end;

function funcs.setGravity(v)
	Services.Workspace.Gravity = v; DATA.gravity = v;
end;

function funcs.setFly(enabled)
	DATA.fly = enabled;
	local char = getChar();
	if not char then return; end;
	local hum = getHum();
	local root = getRoot();
	if not (hum and root) then return; end;
	if enabled then
		notify("飞行", "飞行已开启");
		local bv = Instance.new("BodyVelocity");
		bv.Name = "KaiFly"; bv.MaxForce = Vector3.new(1e9, 1e9, 1e9); bv.Velocity = Vector3.zero;
		bv.Parent = root;
		local bg = Instance.new("BodyGyro");
		bg.Name = "KaiFlyGyro"; bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9); bg.P = 1e4;
		bg.Parent = root;
	else
		notify("飞行", "飞行已关闭");
		local root = getRoot();
		if root then
			for _, c in ipairs(root:GetChildren()) do
				if c.Name == "KaiFly" or c.Name == "KaiFlyGyro" then c:Destroy(); end;
			end;
		end;
	end;
end;

function funcs.setNoclip(enabled)
	DATA.noclip = enabled;
	if enabled then notify("穿墙", "穿墙已开启");
	else notify("穿墙", "穿墙已关闭"); end;
end;

function funcs.setInfJump(enabled)
	DATA.infJump = enabled;
end;

function funcs.setAntiFall(enabled)
	DATA.antiFall = enabled;
	if enabled then notify("防击倒", "防击倒已开启"); end;
end;

function funcs.setAntiDead(enabled)
	DATA.antiDead = enabled;
	local hum = getHum();
	if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Dead, not enabled); end;
end;

function funcs.setNightVision(enabled)
	DATA.nightVision = enabled;
	Services.Lighting.Ambient = enabled and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
end;

function funcs.setSuperNightVision(enabled)
	DATA.superNightVision = enabled;
	if enabled then
		DATA.origBrightness = Services.Lighting.Brightness;
		DATA.origExposure = Services.Lighting.ExposureCompensation;
		Services.Lighting.Brightness = 2;
		Services.Lighting.ExposureCompensation = 2.5;
	else
		Services.Lighting.Brightness = DATA.origBrightness;
		Services.Lighting.ExposureCompensation = DATA.origExposure;
	end;
end;

function funcs.setXray(enabled)
	DATA.xray = enabled;
	for _, v in ipairs(Services.Workspace:GetDescendants()) do
		if v:IsA("BasePart") and not v.Parent:FindFirstChildWhichIsA("Humanoid") then
			v.LocalTransparencyModifier = enabled and 0.7 or 0;
		end;
	end;
end;

function funcs.setClickTp(enabled)
	DATA.clickTp = enabled;
	if enabled then notify("点击传送", "按住Ctrl+点击地面传送"); end;
end;

function funcs.setESP(enabled)
	DATA.esp = enabled;
	for _, plr in ipairs(Services.Players:GetPlayers()) do
		if plr ~= LP and plr.Character then
			for _, part in ipairs(plr.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					if enabled then
						local hl = Instance.new("BoxHandleAdornment");
						hl.Name = "KaiESP"; hl.Size = part.Size; hl.AlwaysOnTop = true;
						hl.ZIndex = 10; hl.Adornee = part; hl.Color3 = Color3.fromRGB(255, 0, 0);
						hl.Transparency = 0.5; hl.Parent = part;
					else
						for _, c in ipairs(part:GetChildren()) do
							if c.Name == "KaiESP" then c:Destroy(); end;
						end;
					end;
				end;
			end;
		end;
	end;
end;

function funcs.respawn()
	local char = getChar();
	if not char then return; end;
	local hum = getHum();
	if hum then hum.Health = 0; end;
end;

function funcs.rejoin()
	local placeId = game.PlaceId;
	local jobId = game.JobId;
	if jobId and jobId ~= "" then
		Services.TeleportService:TeleportToPlaceInstance(placeId, jobId, LP);
	else
		Services.TeleportService:Teleport(placeId, LP);
	end;
end;

function funcs.setSpin(enabled)
	DATA.spin = enabled;
end;

-- ========== UI框架 ==========
local KaiUI = {};
KaiUI.__index = KaiUI;

function KaiUI.new(cfg)
	cfg = cfg or {};
	local self = setmetatable({}, KaiUI);
	self.Name = cfg.Name or "KaiHub";
	self.Subtitle = cfg.Subtitle or "v6.0";
	self.Tabs = {};
	self.ActiveTab = nil;
	self.Minimized = false;
	self:_build();
	return self;
end;

function KaiUI:_build()
	-- ScreenGui
	self.Gui = Instance.new("ScreenGui");
	self.Gui.Name = "KaiHubRetro";
	self.Gui.Parent = LP:WaitForChild("PlayerGui");
	self.Gui.ResetOnSpawn = false;
	self.Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;

	-- 主窗口 (缩小: 480x320)
	self.Frame = Instance.new("Frame");
	self.Frame.Name = "MainFrame";
	self.Frame.Size = UDim2.new(0, 460, 0, 300);
	self.Frame.Position = UDim2.new(0.5, -230, 0.5, -150);
	self.Frame.BackgroundColor3 = C.WinBg;
	self.Frame.BorderSizePixel = 0;
	self.Frame.Active = true;
	self.Frame.Parent = self.Gui;
	bevel(self.Frame, "raised", 2);

	-- 标题栏
	self.TitleBar = Instance.new("Frame");
	self.TitleBar.Size = UDim2.new(1, -4, 0, 22);
	self.TitleBar.Position = UDim2.new(0, 2, 0, 2);
	self.TitleBar.BackgroundColor3 = C.WinTitle;
	self.TitleBar.BorderSizePixel = 0;
	self.TitleBar.ZIndex = 10;
	self.TitleBar.Parent = self.Frame;

	-- 标题渐变
	local grad = Instance.new("Frame");
	grad.Size = UDim2.new(1, 0, 0, 11);
	grad.BackgroundColor3 = Color3.fromRGB(60, 100, 220);
	grad.BackgroundTransparency = 0.4;
	grad.BorderSizePixel = 0;
	grad.ZIndex = 11;
	grad.Parent = self.TitleBar;

	-- 标题图标
	local icon = Instance.new("Frame");
	icon.Size = UDim2.new(0, 12, 0, 12);
	icon.Position = UDim2.new(0, 4, 0, 5);
	icon.BackgroundColor3 = Color3.fromRGB(100, 160, 255);
	icon.BorderSizePixel = 0;
	icon.ZIndex = 12;
	icon.Parent = self.TitleBar;
	bevel(icon, "raised", 1);

	-- 标题文字
	local title = Instance.new("TextLabel");
	title.Size = UDim2.new(0, 200, 1, 0);
	title.Position = UDim2.new(0, 20, 0, 0);
	title.BackgroundTransparency = 1;
	title.Text = self.Name;
	title.Font = Enum.Font.SourceSansBold;
	title.TextSize = 12;
	title.TextColor3 = C.WinTitleText;
	title.TextXAlignment = Enum.TextXAlignment.Left;
	title.ZIndex = 12;
	title.Parent = self.TitleBar;

	-- 最小化按钮
	local minBtn = Instance.new("TextButton");
	minBtn.Size = UDim2.new(0, 20, 0, 20);
	minBtn.Position = UDim2.new(1, -44, 0, 1);
	minBtn.BackgroundColor3 = C.MinBtn;
	minBtn.BorderSizePixel = 0;
	minBtn.Text = "_";
	minBtn.Font = Enum.Font.SourceSansBold;
	minBtn.TextSize = 12;
	minBtn.TextColor3 = C.WinTitleText;
	minBtn.ZIndex = 12;
	minBtn.Parent = self.TitleBar;
	bevel(minBtn, "raised", 1);
	minBtn.MouseEnter:Connect(function() minBtn.BackgroundColor3 = C.MinHover; end);
	minBtn.MouseLeave:Connect(function() minBtn.BackgroundColor3 = C.MinBtn; end);
	minBtn.MouseButton1Click:Connect(function() self:toggleMinimize(); end);

	-- 关闭按钮
	local closeBtn = Instance.new("TextButton");
	closeBtn.Size = UDim2.new(0, 20, 0, 20);
	closeBtn.Position = UDim2.new(1, -22, 0, 1);
	closeBtn.BackgroundColor3 = C.CloseBtn;
	closeBtn.BorderSizePixel = 0;
	closeBtn.Text = "X";
	closeBtn.Font = Enum.Font.SourceSansBold;
	closeBtn.TextSize = 10;
	closeBtn.TextColor3 = C.WinTitleText;
	closeBtn.ZIndex = 12;
	closeBtn.Parent = self.TitleBar;
	bevel(closeBtn, "raised", 1);
	closeBtn.MouseEnter:Connect(function() closeBtn.BackgroundColor3 = C.CloseHover; end);
	closeBtn.MouseLeave:Connect(function() closeBtn.BackgroundColor3 = C.CloseBtn; end);
	closeBtn.MouseButton1Click:Connect(function() self:destroy(); end);

	-- 菜单栏
	local menuBar = Instance.new("Frame");
	menuBar.Size = UDim2.new(1, -4, 0, 18);
	menuBar.Position = UDim2.new(0, 2, 0, 24);
	menuBar.BackgroundColor3 = C.WinBg;
	menuBar.BorderSizePixel = 0;
	menuBar.ZIndex = 10;
	menuBar.Parent = self.Frame;
	bevel(menuBar, "raised", 1);

	for i, item in ipairs({"文件", "编辑", "查看", "帮助"}) do
		local b = Instance.new("TextButton");
		b.Size = UDim2.new(0, 34, 0, 16);
		b.Position = UDim2.new(0, 2 + (i-1) * 36, 0, 1);
		b.BackgroundColor3 = C.WinBg;
		b.BorderSizePixel = 0;
		b.Text = item; b.Font = Enum.Font.SourceSans;
		b.TextSize = 10; b.TextColor3 = C.ContentText;
		b.ZIndex = 11; b.Parent = menuBar;
		b.MouseEnter:Connect(function() b.BackgroundColor3 = C.SidebarActive; b.TextColor3 = C.SidebarTextActive; end);
		b.MouseLeave:Connect(function() b.BackgroundColor3 = C.WinBg; b.TextColor3 = C.ContentText; end);
	end;

	-- 主体区域
	local body = Instance.new("Frame");
	body.Size = UDim2.new(1, -4, 1, -68);
	body.Position = UDim2.new(0, 2, 0, 42);
	body.BackgroundColor3 = C.WinBg;
	body.BorderSizePixel = 0;
	body.ZIndex = 5;
	body.Parent = self.Frame;

	-- 侧边栏
	self.Sidebar = Instance.new("Frame");
	self.Sidebar.Size = UDim2.new(0, 110, 1, 0);
	self.Sidebar.BackgroundColor3 = C.SidebarBg;
	self.Sidebar.BorderSizePixel = 0;
	self.Sidebar.ZIndex = 6;
	self.Sidebar.Parent = body;
	bevel(self.Sidebar, "sunken", 1);

	local sideTitle = Instance.new("TextLabel");
	sideTitle.Size = UDim2.new(1, 0, 0, 18);
	sideTitle.BackgroundColor3 = C.WinBg;
	sideTitle.BorderSizePixel = 0;
	sideTitle.Text = "  导航栏";
	sideTitle.Font = Enum.Font.SourceSansBold;
	sideTitle.TextSize = 10;
	sideTitle.TextColor3 = C.ContentText;
	sideTitle.TextXAlignment = Enum.TextXAlignment.Left;
	sideTitle.ZIndex = 7;
	sideTitle.Parent = self.Sidebar;

	-- 内容区域
	self.Content = Instance.new("Frame");
	self.Content.Size = UDim2.new(1, -110, 1, 0);
	self.Content.Position = UDim2.new(0, 110, 0, 0);
	self.Content.BackgroundColor3 = C.ContentBg;
	self.Content.BorderSizePixel = 0;
	self.Content.ClipsDescendants = true;
	self.Content.ZIndex = 6;
	self.Content.Parent = body;
	bevel(self.Content, "sunken", 2);

	-- 状态栏
	local status = Instance.new("Frame");
	status.Size = UDim2.new(1, -4, 0, 18);
	status.Position = UDim2.new(0, 2, 1, -20);
	status.BackgroundColor3 = Color3.fromRGB(180, 180, 180);
	status.BorderSizePixel = 0;
	status.ZIndex = 10;
	status.Parent = self.Frame;
	bevel(status, "sunken", 1);

	self.StatusLabel = Instance.new("TextLabel");
	self.StatusLabel.Size = UDim2.new(0.7, -4, 1, 0);
	self.StatusLabel.Position = UDim2.new(0, 4, 0, 0);
	self.StatusLabel.BackgroundTransparency = 1;
	self.StatusLabel.Text = "就绪";
	self.StatusLabel.Font = Enum.Font.SourceSans;
	self.StatusLabel.TextSize = 10;
	self.StatusLabel.TextColor3 = C.ContentText;
	self.StatusLabel.TextXAlignment = Enum.TextXAlignment.Left;
	self.StatusLabel.ZIndex = 11;
	self.StatusLabel.Parent = status;

	local timeLabel = Instance.new("TextLabel");
	timeLabel.Size = UDim2.new(0.3, -4, 1, 0);
	timeLabel.Position = UDim2.new(0.7, 0, 0, 0);
	timeLabel.BackgroundTransparency = 1;
	timeLabel.Text = os.date("%H:%M");
	timeLabel.Font = Enum.Font.SourceSans;
	timeLabel.TextSize = 10;
	timeLabel.TextColor3 = C.ContentText;
	timeLabel.TextXAlignment = Enum.TextXAlignment.Right;
	timeLabel.ZIndex = 11;
	timeLabel.Parent = status;

	task.spawn(function()
		while self.Gui and self.Gui.Parent do
			task.wait(30);
			pcall(function() timeLabel.Text = os.date("%H:%M"); end);
		end;
	end);

	-- 拖拽
	self:_makeDraggable();
end;

function KaiUI:toggleMinimize()
	self.Minimized = not self.Minimized;
	if self.Minimized then
		self.Frame.Visible = false;
		if not self.MinIcon then
			self.MinIcon = Instance.new("TextButton");
			self.MinIcon.Size = UDim2.new(0, 100, 0, 26);
			self.MinIcon.Position = UDim2.new(0, 10, 1, -36);
			self.MinIcon.BackgroundColor3 = C.WinBg;
			self.MinIcon.BorderSizePixel = 0;
			self.MinIcon.Text = "  KaiHub";
			self.MinIcon.Font = Enum.Font.SourceSansBold;
			self.MinIcon.TextSize = 11;
			self.MinIcon.TextColor3 = C.ContentText;
			self.MinIcon.TextXAlignment = Enum.TextXAlignment.Left;
			self.MinIcon.ZIndex = 100;
			self.MinIcon.Parent = self.Gui;
			bevel(self.MinIcon, "raised", 2);
			local ic = Instance.new("Frame");
			ic.Size = UDim2.new(0, 12, 0, 12);
			ic.Position = UDim2.new(0, 4, 0, 7);
			ic.BackgroundColor3 = Color3.fromRGB(100, 160, 255);
			ic.BorderSizePixel = 0;
			ic.ZIndex = 101;
			ic.Parent = self.MinIcon;
			bevel(ic, "raised", 1);
			self.MinIcon.MouseButton1Click:Connect(function() self:toggleMinimize(); end);
		end;
		self.MinIcon.Visible = true;
	else
		self.Frame.Visible = true;
		if self.MinIcon then self.MinIcon.Visible = false; end;
	end;
end;

function KaiUI:_makeDraggable()
	local drag = false;
	local startPos, startFrame;
	self.TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			drag = true;
			startPos = input.Position;
			startFrame = self.Frame.Position;
		end;
	end);
	Services.UserInputService.InputChanged:Connect(function(input)
		if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local d = input.Position - startPos;
			self.Frame.Position = UDim2.new(startFrame.X.Scale, startFrame.X.Offset + d.X, startFrame.Y.Scale, startFrame.Y.Offset + d.Y);
		end;
	end);
	Services.UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			drag = false;
		end;
	end);
end;

function KaiUI:addTab(name)
	local yPos = 20 + (#self.Tabs * 22);
	local btn = Instance.new("TextButton");
	btn.Name = "Tab_" .. name;
	btn.Size = UDim2.new(1, -4, 0, 20);
	btn.Position = UDim2.new(0, 2, 0, yPos);
	btn.BackgroundColor3 = C.SidebarBg;
	btn.BorderSizePixel = 0;
	btn.Text = "  " .. name;
	btn.Font = Enum.Font.SourceSans;
	btn.TextSize = 11;
	btn.TextColor3 = C.SidebarText;
	btn.TextXAlignment = Enum.TextXAlignment.Left;
	btn.ZIndex = 8;
	btn.Parent = self.Sidebar;

	local ind = Instance.new("Frame");
	ind.Size = UDim2.new(0, 3, 1, -2);
	ind.Position = UDim2.new(0, 0, 0, 1);
	ind.BackgroundColor3 = C.SidebarActive;
	ind.BorderSizePixel = 0;
	ind.Visible = false;
	ind.ZIndex = 9;
	ind.Parent = btn;

	local content = Instance.new("Frame");
	content.Name = "Content_" .. name;
	content.Size = UDim2.new(1, 0, 1, 0);
	content.BackgroundTransparency = 1;
	content.Visible = false;
	content.ZIndex = 7;
	content.Parent = self.Content;

	local scroll = Instance.new("ScrollingFrame");
	scroll.Size = UDim2.new(1, -4, 1, -4);
	scroll.Position = UDim2.new(0, 2, 0, 2);
	scroll.BackgroundTransparency = 1;
	scroll.BorderSizePixel = 0;
	scroll.ScrollBarThickness = 6;
	scroll.ScrollBarImageColor3 = Color3.fromRGB(140, 140, 140);
	scroll.ZIndex = 8;
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0);
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y;
	scroll.Parent = content;

	local layout = Instance.new("UIListLayout");
	layout.SortOrder = Enum.SortOrder.LayoutOrder;
	layout.Padding = UDim.new(0, 2);
	layout.Parent = scroll;

	local tab = {Name = name, Button = btn, Content = content, Scroll = scroll, Indicator = ind, Elements = {}};
	btn.MouseEnter:Connect(function() if self.ActiveTab ~= tab then btn.BackgroundColor3 = C.SidebarHover; end; end);
	btn.MouseLeave:Connect(function() if self.ActiveTab ~= tab then btn.BackgroundColor3 = C.SidebarBg; end; end);
	btn.MouseButton1Click:Connect(function() self:selectTab(tab); end);
	table.insert(self.Tabs, tab);
	if #self.Tabs == 1 then self:selectTab(tab); end;
	return tab;
end;

function KaiUI:selectTab(tab)
	for _, t in ipairs(self.Tabs) do
		t.Content.Visible = false;
		t.Button.BackgroundColor3 = C.SidebarBg;
		t.Button.TextColor3 = C.SidebarText;
		t.Indicator.Visible = false;
	end;
	tab.Content.Visible = true;
	tab.Button.BackgroundColor3 = C.SidebarActive;
	tab.Button.TextColor3 = C.SidebarTextActive;
	tab.Indicator.Visible = true;
	self.ActiveTab = tab;
	self.StatusLabel.Text = tab.Name;
end;

-- ========== 控件 ==========
function KaiUI:addLabel(tab, text)
	local f = Instance.new("Frame");
	f.Size = UDim2.new(1, -4, 0, 20);
	f.BackgroundColor3 = C.SidebarBg;
	f.BorderSizePixel = 0;
	f.ZIndex = 8;
	f.LayoutOrder = #tab.Elements;
	f.Parent = tab.Scroll;
	bevel(f, "sunken", 1);
	local lbl = Instance.new("TextLabel");
	lbl.Size = UDim2.new(1, -6, 1, 0);
	lbl.Position = UDim2.new(0, 4, 0, 0);
	lbl.BackgroundTransparency = 1;
	lbl.Text = text;
	lbl.Font = Enum.Font.SourceSansBold;
	lbl.TextSize = 11;
	lbl.TextColor3 = C.ContentText;
	lbl.TextXAlignment = Enum.TextXAlignment.Left;
	lbl.ZIndex = 9;
	lbl.Parent = f;
	table.insert(tab.Elements, f);
	return lbl;
end;

function KaiUI:addButton(tab, text, callback)
	local btn = Instance.new("TextButton");
	btn.Size = UDim2.new(1, -4, 0, 24);
	btn.BackgroundColor3 = C.BtnFace;
	btn.BorderSizePixel = 0;
	btn.Text = text;
	btn.Font = Enum.Font.SourceSansBold;
	btn.TextSize = 11;
	btn.TextColor3 = C.ContentText;
	btn.ZIndex = 8;
	btn.LayoutOrder = #tab.Elements;
	btn.Parent = tab.Scroll;
	bevel(btn, "raised", 2);
	btn.MouseEnter:Connect(function() btn.BackgroundColor3 = C.BtnHighlight; end);
	btn.MouseLeave:Connect(function() btn.BackgroundColor3 = C.BtnFace; end);
	btn.MouseButton1Click:Connect(function()
		btn.BackgroundColor3 = C.BtnPressed;
		task.delay(0.1, function() btn.BackgroundColor3 = C.BtnFace; end);
		if callback then callback(); end;
	end);
	table.insert(tab.Elements, btn);
	return btn;
end;

function KaiUI:addToggle(tab, text, default, callback)
	local container = Instance.new("Frame");
	container.Size = UDim2.new(1, -4, 0, 22);
	container.BackgroundTransparency = 1;
	container.ZIndex = 8;
	container.LayoutOrder = #tab.Elements;
	container.Parent = tab.Scroll;

	local box = Instance.new("TextButton");
	box.Size = UDim2.new(0, 14, 0, 14);
	box.Position = UDim2.new(0, 3, 0, 4);
	box.BackgroundColor3 = C.InputBg;
	box.BorderSizePixel = 0;
	box.Text = default and "v" or "";
	box.Font = Enum.Font.SourceSansBold;
	box.TextSize = 10;
	box.TextColor3 = C.ContentText;
	box.ZIndex = 10;
	box.Parent = container;
	bevel(box, "sunken", 1);

	local lbl = Instance.new("TextLabel");
	lbl.Size = UDim2.new(1, -24, 1, 0);
	lbl.Position = UDim2.new(0, 22, 0, 0);
	lbl.BackgroundTransparency = 1;
	lbl.Text = text;
	lbl.Font = Enum.Font.SourceSans;
	lbl.TextSize = 11;
	lbl.TextColor3 = C.ContentText;
	lbl.TextXAlignment = Enum.TextXAlignment.Left;
	lbl.ZIndex = 9;
	lbl.Parent = container;

	local state = default;
	box.MouseButton1Click:Connect(function()
		state = not state;
		box.Text = state and "v" or "";
		box.BackgroundColor3 = state and C.ToggleOn or C.InputBg;
		if callback then callback(state); end;
	end);
	table.insert(tab.Elements, container);
	return box;
end;

function KaiUI:addSlider(tab, text, min, max, default, callback)
	local container = Instance.new("Frame");
	container.Size = UDim2.new(1, -4, 0, 30);
	container.BackgroundTransparency = 1;
	container.ZIndex = 8;
	container.LayoutOrder = #tab.Elements;
	container.Parent = tab.Scroll;

	local lbl = Instance.new("TextLabel");
	lbl.Size = UDim2.new(1, 0, 0, 14);
	lbl.BackgroundTransparency = 1;
	lbl.Text = text .. ": " .. tostring(default);
	lbl.Font = Enum.Font.SourceSans;
	lbl.TextSize = 10;
	lbl.TextColor3 = C.ContentText;
	lbl.TextXAlignment = Enum.TextXAlignment.Left;
	lbl.ZIndex = 9;
	lbl.Parent = container;

	local track = Instance.new("Frame");
	track.Size = UDim2.new(1, -4, 0, 8);
	track.Position = UDim2.new(0, 2, 0, 16);
	track.BackgroundColor3 = Color3.fromRGB(192, 192, 192);
	track.BorderSizePixel = 0;
	track.ZIndex = 9;
	track.Parent = container;
	bevel(track, "sunken", 1);

	local fill = Instance.new("Frame");
	local pct = (default - min) / (max - min);
	fill.Size = UDim2.new(pct, 0, 1, -2);
	fill.Position = UDim2.new(0, 1, 0, 1);
	fill.BackgroundColor3 = C.SliderFill;
	fill.BorderSizePixel = 0;
	fill.ZIndex = 10;
	fill.Parent = track;

	local thumb = Instance.new("TextButton");
	thumb.Size = UDim2.new(0, 8, 0, 14);
	thumb.Position = UDim2.new(pct, -4, 0.5, -7);
	thumb.BackgroundColor3 = C.BtnFace;
	thumb.BorderSizePixel = 0;
	thumb.Text = "";
	thumb.ZIndex = 11;
	thumb.Parent = track;
	bevel(thumb, "raised", 1);

	local sliding = false;
	thumb.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true; end;
	end);
	Services.UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false; end;
	end);
	Services.UserInputService.InputChanged:Connect(function(input)
		if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
			local relX = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1);
			local val = min + (max - min) * relX;
			val = math.floor(val * 10 + 0.5) / 10;
			fill.Size = UDim2.new(relX, 0, 1, -2);
			thumb.Position = UDim2.new(relX, -4, 0.5, -7);
			lbl.Text = text .. ": " .. tostring(val);
			if callback then callback(val); end;
		end;
	end);
	table.insert(tab.Elements, container);
end;

function KaiUI:addTextBox(tab, labelText, callback)
	local container = Instance.new("Frame");
	container.Size = UDim2.new(1, -4, 0, 22);
	container.BackgroundTransparency = 1;
	container.ZIndex = 8;
	container.LayoutOrder = #tab.Elements;
	container.Parent = tab.Scroll;

	local lbl = Instance.new("TextLabel");
	lbl.Size = UDim2.new(0, 60, 1, 0);
	lbl.BackgroundTransparency = 1;
	lbl.Text = labelText .. ":";
	lbl.Font = Enum.Font.SourceSans;
	lbl.TextSize = 10;
	lbl.TextColor3 = C.ContentText;
	lbl.TextXAlignment = Enum.TextXAlignment.Left;
	lbl.ZIndex = 9;
	lbl.Parent = container;

	local input = Instance.new("TextBox");
	input.Size = UDim2.new(1, -65, 0, 18);
	input.Position = UDim2.new(0, 62, 0, 2);
	input.BackgroundColor3 = C.InputBg;
	input.BorderSizePixel = 0;
	input.Text = "";
	input.PlaceholderText = labelText;
	input.PlaceholderColor3 = C.ContentTextDim;
	input.Font = Enum.Font.SourceSans;
	input.TextSize = 10;
	input.TextColor3 = C.ContentText;
	input.ZIndex = 10;
	input.Parent = container;
	bevel(input, "sunken", 1);

	if callback then input.FocusLost:Connect(function() callback(input.Text); end); end;
	table.insert(tab.Elements, container);
	return input;
end;

function KaiUI:addSeparator(tab)
	local sep = Instance.new("Frame");
	sep.Size = UDim2.new(1, -4, 0, 2);
	sep.BackgroundColor3 = C.BevelDark;
	sep.BorderSizePixel = 0;
	sep.ZIndex = 8;
	sep.LayoutOrder = #tab.Elements;
	sep.Parent = tab.Scroll;
	table.insert(tab.Elements, sep);
end;

function KaiUI:destroy()
	if self.Gui then self.Gui:Destroy(); end;
	_G.KaiHubRetroLoaded = false;
end;

-- ============================================================
-- 创建UI并添加功能
-- ============================================================
local ui = KaiUI.new({Name = "KaiHub", Subtitle = "Retro v6.0"});

-- ========== 基础设置 ==========
local basicTab = ui:addTab("基础设置");
ui:addLabel(basicTab, "基础数据修改");
ui:addSlider(basicTab, "玩家移速", 0, 500, DATA.speed, function(v) funcs.setSpeed(v); end);
ui:addToggle(basicTab, "锁定移速", false, function(v) DATA.lockSpeed = v; end);
ui:addSlider(basicTab, "跳跃力量", 0, 500, DATA.jump, function(v) funcs.setJump(v); end);
ui:addToggle(basicTab, "锁定跳跃", false, function(v) DATA.lockJump = v; end);
ui:addSlider(basicTab, "最大血量", 1, 1000, DATA.maxHealth, function(v) funcs.setMaxHealth(v); end);
ui:addToggle(basicTab, "锁定最大血量", false, function(v) DATA.lockMaxHealth = v; end);
ui:addSlider(basicTab, "当前血量", 1, 1000, DATA.health, function(v) funcs.setHealth(v); end);
ui:addToggle(basicTab, "锁定血量", false, function(v) DATA.lockHealth = v; end);
ui:addSlider(basicTab, "世界重力", 0, 500, DATA.gravity, function(v) funcs.setGravity(v); end);
ui:addToggle(basicTab, "锁定重力", false, function(v) DATA.lockGravity = v; end);

-- ========== 工具 ==========
local toolsTab = ui:addTab("工具");
ui:addLabel(toolsTab, "实用工具");
ui:addToggle(toolsTab, "防挂机", true, function(v) DATA.antiAfk = v; end);
ui:addToggle(toolsTab, "飞行", false, function(v) funcs.setFly(v); end);
ui:addToggle(toolsTab, "穿墙", false, function(v) funcs.setNoclip(v); end);
ui:addToggle(toolsTab, "无限跳", false, function(v) funcs.setInfJump(v); end);
ui:addToggle(toolsTab, "防击倒", false, function(v) funcs.setAntiFall(v); end);
ui:addToggle(toolsTab, "防死亡", false, function(v) funcs.setAntiDead(v); end);
ui:addToggle(toolsTab, "夜视", false, function(v) funcs.setNightVision(v); end);
ui:addToggle(toolsTab, "超级夜视", false, function(v) funcs.setSuperNightVision(v); end);
ui:addToggle(toolsTab, "X光", false, function(v) funcs.setXray(v); end);
ui:addToggle(toolsTab, "点击传送", false, function(v) funcs.setClickTp(v); end);
ui:addToggle(toolsTab, "玩家透视", false, function(v) funcs.setESP(v); end);
ui:addSeparator(toolsTab);
ui:addButton(toolsTab, "回满血", function() funcs.setHealth(DATA.maxHealth); end);
ui:addButton(toolsTab, "自杀", function() funcs.respawn(); end);
ui:addButton(toolsTab, "重新加入", function() funcs.rejoin(); end);

-- ========== 恶劣功能 ==========
local hackTab = ui:addTab("恶劣功能");
ui:addLabel(hackTab, "警告：可能导致封号");
ui:addSlider(hackTab, "旋转速度", 1, 100, DATA.spinSpeed, function(v) DATA.spinSpeed = v; end);
ui:addToggle(hackTab, "旋转", false, function(v) DATA.spin = v; end);
ui:addToggle(hackTab, "击飞", false, function(v) DATA.fling = v; end);
ui:addTextBox(hackTab, "击杀目标", function(t) DATA.killName = t; end);
ui:addToggle(hackTab, "击杀全部", false, function(v) DATA.killAll = v; end);
ui:addButton(hackTab, "执行击杀", function()
	notify("击杀", DATA.killAll and "击杀全部玩家" or "击杀: " .. DATA.killName);
end);

-- ========== 设置 ==========
local settingsTab = ui:addTab("设置");
ui:addLabel(settingsTab, "脚本设置");
ui:addButton(settingsTab, "销毁UI", function() ui:destroy(); end);
ui:addButton(settingsTab, "重新加载", function()
	ui:destroy();
	loadstring(game:HttpGet("https://raw.githubusercontent.com/GGG792/KaiHubRetroTest/main/main.lua"))();
end);

-- ========== 关于 ==========
local aboutTab = ui:addTab("关于");
ui:addLabel(aboutTab, "KaiHub Retro v6.0");
ui:addLabel(aboutTab, "早期Roblox风格UI");
ui:addLabel(aboutTab, "所有功能已绑定");
ui:addSeparator(aboutTab);
ui:addLabel(aboutTab, "点击标签页查看内容");

-- ============================================================
-- 后台循环
-- ============================================================
local conns = {};

-- 属性锁定
conns.heartbeat = Services.RunService.Heartbeat:Connect(function()
	local hum = getHum();
	if hum then
		if DATA.lockSpeed and hum.WalkSpeed ~= DATA.speed then hum.WalkSpeed = DATA.speed; end;
		if DATA.lockJump and hum.JumpPower ~= DATA.jump then hum.JumpPower = DATA.jump; end;
		if DATA.lockHealth and hum.Health ~= DATA.health then hum.Health = DATA.health; end;
		if DATA.lockMaxHealth and hum.MaxHealth ~= DATA.maxHealth then hum.MaxHealth = DATA.maxHealth; end;
	end;
	if DATA.lockGravity and Services.Workspace.Gravity ~= DATA.gravity then Services.Workspace.Gravity = DATA.gravity; end;
end);

-- 防挂机
conns.idled = LP.Idled:Connect(function()
	if DATA.antiAfk then
		Services.VirtualUser:CaptureController();
		Services.VirtualUser:ClickButton2(Vector2.new());
	end;
end);

-- 穿墙
conns.stepped = Services.RunService.Stepped:Connect(function()
	if DATA.noclip then
		local char = getChar();
		if char then
			for _, p in ipairs(char:GetDescendants()) do
				if p:IsA("BasePart") then p.CanCollide = false; end;
			end;
		end;
	end;
	if DATA.spin then
		local root = getRoot();
		if root then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(DATA.spinSpeed), 0); end;
	end;
end);

-- 无限跳
conns.jump = Services.UserInputService.JumpRequest:Connect(function()
	if DATA.infJump then
		local hum = getHum();
		if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping); end;
	end;
end);

-- 点击传送
conns.clickTp = Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if DATA.clickTp and not gameProcessed then
		if input.UserInputType == Enum.UserInputType.MouseButton1 and Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
			local root = getRoot();
			if root then root.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0)); end;
		end;
	end;
end);

-- 防击倒
conns.state = nil;
local function setupHum(hum)
	if conns.state then conns.state:Disconnect(); end;
	conns.state = hum.StateChanged:Connect(function(_, new)
		if DATA.antiFall then
			if new == Enum.HumanoidStateType.FallingDown or new == Enum.HumanoidStateType.Ragdoll then
				hum:ChangeState(Enum.HumanoidStateType.GettingUp);
			end;
		end;
	end);
end;

local function onChar(char)
	local hum = char:WaitForChild("Humanoid", 5);
	if hum then setupHum(hum); end;
end;

if LP.Character then onChar(LP.Character); end;
conns.charAdded = LP.CharacterAdded:Connect(onChar);

-- 飞行控制
conns.fly = Services.RunService.RenderStepped:Connect(function()
	if DATA.fly then
		local root = getRoot();
		if root then
			local bv = root:FindFirstChild("KaiFly");
			local bg = root:FindFirstChild("KaiFlyGyro");
			if bv and bg then
				local cam = Services.Workspace.CurrentCamera;
				local dir = Vector3.zero;
				if Services.UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector; end;
				if Services.UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector; end;
				if Services.UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector; end;
				if Services.UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector; end;
				if Services.UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0); end;
				if Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0); end;
				bv.Velocity = dir * 50;
				bg.CFrame = cam.CFrame;
			end;
		end;
	end;
end);

_G.KaiHubRetroLoaded = true;
_G.KaiHubRetroLoading = false;
notify("KaiHub Retro", "加载完成！用时 " .. string.format("%.1f", tick() - startTime) .. "s");

return ui;
