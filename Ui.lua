-- ============================================================
-- KaiHub 启动界面 - 炫酷版
-- ============================================================
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local MAIN_URL = "https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/zhengw.lua";

-- 作者检测
local VIP_OWNERS = {"noobnewfggg", "sbcnm229"};
local isOwner = false;
for _, name in ipairs(VIP_OWNERS) do
	if LocalPlayer.Name == name then isOwner = true; break; end;
end;

-- 主题色
local ACCENT = isOwner and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(119, 221, 255);
local ACCENT2 = isOwner and Color3.fromRGB(255, 170, 0) or Color3.fromRGB(100, 140, 255);
local ACCENT3 = isOwner and Color3.fromRGB(255, 255, 100) or Color3.fromRGB(180, 100, 255);

-- 清理
pcall(function()
	if LocalPlayer.PlayerGui:FindFirstChild("KaiHubLoader") then
		LocalPlayer.PlayerGui.KaiHubLoader:Destroy();
	end;
end);

-- ========== ScreenGui ==========
local Gui = Instance.new("ScreenGui");
Gui.Name = "KaiHubLoader";
Gui.Parent = LocalPlayer.PlayerGui;
Gui.ResetOnSpawn = false;
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
Gui.IgnoreGuiInset = true;

-- ========== 模糊 ==========
local Blur = Instance.new("BlurEffect");
Blur.Name = "KaiBlur";
Blur.Size = 0;
Blur.Parent = Lighting;

-- ========== 主背景（磨砂玻璃） ==========
local Bg = Instance.new("Frame");
Bg.Size = UDim2.new(1, 0, 1, 0);
Bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
Bg.BackgroundTransparency = 1;
Bg.BorderSizePixel = 0;
Bg.ClipsDescendants = true;
Bg.Parent = Gui;

-- 光晕层
local GlowFrame = Instance.new("Frame");
GlowFrame.Size = UDim2.new(2, 0, 2, 0);
GlowFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
GlowFrame.AnchorPoint = Vector2.new(0.5, 0.5);
GlowFrame.BackgroundTransparency = 1;
GlowFrame.BorderSizePixel = 0;
GlowFrame.Parent = Bg;

local Glow1 = Instance.new("Frame");
Glow1.Size = UDim2.new(0.6, 0, 0.6, 0);
Glow1.Position = UDim2.new(0.3, 0, 0.3, 0);
Glow1.BackgroundColor3 = ACCENT;
Glow1.BackgroundTransparency = 0.97;
Glow1.BorderSizePixel = 0;
Glow1.Parent = GlowFrame;

local Glow2 = Instance.new("Frame");
Glow2.Size = UDim2.new(0.5, 0, 0.5, 0);
Glow2.Position = UDim2.new(0.6, 0, 0.6, 0);
Glow2.BackgroundColor3 = ACCENT2;
Glow2.BackgroundTransparency = 0.97;
Glow2.BorderSizePixel = 0;
Glow2.Parent = GlowFrame;

local Glow3 = Instance.new("Frame");
Glow3.Size = UDim2.new(0.4, 0, 0.4, 0);
Glow3.Position = UDim2.new(0.5, 0, 0.4, 0);
Glow3.BackgroundColor3 = ACCENT3;
Glow3.BackgroundTransparency = 0.98;
Glow3.BorderSizePixel = 0;
Glow3.Parent = GlowFrame;

-- 光晕旋转动画
task.spawn(function()
	while Gui.Parent do
		task.wait(0.02);
		pcall(function()
			local t = tick();
			GlowFrame.Rotation = math.sin(t * 0.3) * 15;
			Glow1.Position = UDim2.new(0.3 + math.sin(t * 0.5) * 0.1, 0, 0.3 + math.cos(t * 0.4) * 0.1, 0);
			Glow2.Position = UDim2.new(0.6 + math.cos(t * 0.6) * 0.1, 0, 0.6 + math.sin(t * 0.3) * 0.1, 0);
			Glow3.Position = UDim2.new(0.5 + math.sin(t * 0.4) * 0.15, 0, 0.4 + math.cos(t * 0.5) * 0.1, 0);
			Glow1.BackgroundTransparency = 0.95 + math.sin(t * 2) * 0.02;
			Glow2.BackgroundTransparency = 0.95 + math.cos(t * 1.5) * 0.02;
		end);
	end;
end);

-- ========== 粒子系统 ==========
local Particles = Instance.new("Frame");
Particles.Size = UDim2.new(1, 0, 1, 0);
Particles.BackgroundTransparency = 1;
Particles.ClipsDescendants = true;
Particles.Parent = Bg;

local particleList = {};
for i = 1, 30 do
	local p = Instance.new("Frame");
	p.Size = UDim2.new(0, math.random(2, 5), 0, math.random(2, 5));
	p.Position = UDim2.new(math.random() / 3, 0, math.random(), 0);
	p.BackgroundColor3 = Color3.fromRGB(
		math.random(150, 255),
		math.random(150, 255),
		math.random(200, 255)
	);
	p.BackgroundTransparency = math.random(3, 7) / 10;
	p.BorderSizePixel = 0;
	p.Parent = Particles;
	Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0);
	
	table.insert(particleList, {
		instance = p,
		speedX = (math.random() - 0.5) * 0.002,
		speedY = -math.random(1, 3) * 0.001,
		startX = math.random() / 3,
		startY = math.random(),
		offset = math.random() * 100
	});
end;

task.spawn(function()
	while Gui.Parent do
		task.wait(0.03);
		pcall(function()
			for _, pd in ipairs(particleList) do
				local t = tick() + pd.offset;
				pd.instance.Position = UDim2.new(
					pd.startX + math.sin(t * 0.5) * 0.1,
					0,
					(pd.startY + (t * pd.speedY * 50) % 1.2) - 0.1,
					0
				);
				pd.instance.BackgroundTransparency = 0.4 + math.sin(t * 2) * 0.3;
			end;
		end);
	end;
end);

-- ========== 中心容器 ==========
local Center = Instance.new("Frame");
Center.Size = UDim2.new(1, 0, 1, 0);
Center.BackgroundTransparency = 1;
Center.Parent = Bg;

-- ========== 辅助函数 ==========
local function makeLabel(props)
	local lbl = Instance.new("TextLabel");
	lbl.AnchorPoint = Vector2.new(0.5, 0.5);
	lbl.BackgroundTransparency = 1;
	lbl.TextXAlignment = Enum.TextXAlignment.Center;
	lbl.TextYAlignment = Enum.TextYAlignment.Center;
	lbl.Font = Enum.Font.SourceSansBold;
	lbl.TextTransparency = 1;
	for k, v in pairs(props) do lbl[k] = v; end;
	return lbl;
end;

-- 渐变文字生成（逐字 RichText 着色）
local function gradientText(text, c1, c2, c3)
	local result = "";
	for i = 1, #text do
		local t = (i - 1) / math.max(1, #text - 1);
		local r = c1.R*(1-t)^2 + c2.R*2*(1-t)*t + c3.R*t^2;
		local g = c1.G*(1-t)^2 + c2.G*2*(1-t)*t + c3.G*t^2;
		local b = c1.B*(1-t)^2 + c2.B*2*(1-t)*t + c3.B*t^2;
		result = result .. string.format('<font color="#%02X%02X%02X">%s</font>',
			math.floor(r*255), math.floor(g*255), math.floor(b*255), text:sub(i,i));
	end;
	return result;
end;

-- 动态模糊
local function dynBlur(dur, peak, cb)
	local b = Instance.new("BlurEffect");
	b.Size = 0; b.Parent = Lighting;
	TweenService:Create(b, TweenInfo.new(dur*0.35, Enum.EasingStyle.Quad), {Size=peak}):Play();
	task.delay(dur*0.45, function()
		TweenService:Create(b, TweenInfo.new(dur*0.55, Enum.EasingStyle.Quad), {Size=0}):Play();
		task.delay(dur*0.6, function() b:Destroy(); if cb then cb() end; end);
	end);
end;

-- 缩放动画（从0放大或缩小到0）
local function scaleIn(obj, size, dur, extra)
	local props = {Size = UDim2.new(0, size.X, 0, size.Y), TextTransparency = 0};
	if extra then for k,v in pairs(extra) do props[k] = v; end; end;
	return TweenService:Create(obj, TweenInfo.new(dur, Enum.EasingStyle.Back, Enum.EasingDirection.Out), props);
end;

local function scaleOut(obj, dur, extra)
	local props = {Size = UDim2.new(0, 0, 0, 0), TextTransparency = 1};
	if extra then for k,v in pairs(extra) do props[k] = v; end; end;
	return TweenService:Create(obj, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.In), props);
end;

-- ========== UI 元素 ==========

-- 杨志卡
local YangZhiKa = makeLabel({
	Position = UDim2.new(0.5, 0, 0.5, 0);
	Size = UDim2.new(0, 0, 0, 0);
	TextSize = 56;
	RichText = true;
	Visible = true;
	Parent = Center;
});

local YangAuthor = makeLabel({
	Position = UDim2.new(0.5, 0, 0.5, 38);
	Size = UDim2.new(0, 130, 0, 26);
	TextSize = 18;
	Font = Enum.Font.SourceSansBold;
	Text = "(Author)";
	TextColor3 = Color3.fromRGB(255, 255, 255);
	Parent = Center;
});

-- 杯子狗
local BeiZiGou = makeLabel({
	Position = UDim2.new(0.5, 0, 0.5, 0);
	Size = UDim2.new(0, 0, 0, 0);
	TextSize = 56;
	RichText = true;
	Visible = false;
	Parent = Center;
});

local BeiAuthor = makeLabel({
	Position = UDim2.new(0.5, 0, 0.5, 38);
	Size = UDim2.new(0, 130, 0, 26);
	TextSize = 18;
	Font = Enum.Font.SourceSansBold;
	Text = "(Author)";
	TextColor3 = Color3.fromRGB(255, 255, 255);
	Visible = false;
	Parent = Center;
});

-- 加载文字
local LoadTxt = makeLabel({
	Position = UDim2.new(0.5, 0, 0.73, 0);
	Size = UDim2.new(0, 300, 0, 28);
	TextSize = 15;
	Font = Enum.Font.SourceSans;
	Text = "";
	TextColor3 = ACCENT;
	Parent = Center;
});

-- 进度条
local ProgBg = Instance.new("Frame");
ProgBg.Size = UDim2.new(0, 260, 0, 3);
ProgBg.Position = UDim2.new(0.5, -130, 0.77, 0);
ProgBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60);
ProgBg.BackgroundTransparency = 1;
ProgBg.BorderSizePixel = 0;
ProgBg.Parent = Center;
Instance.new("UICorner", ProgBg).CornerRadius = UDim.new(0, 2);

local ProgFill = Instance.new("Frame");
ProgFill.Size = UDim2.new(0, 0, 1, 0);
ProgFill.BackgroundColor3 = ACCENT;
ProgFill.BorderSizePixel = 0;
ProgFill.Parent = ProgBg;
Instance.new("UICorner", ProgFill).CornerRadius = UDim.new(0, 2);

-- 进度条光晕
local ProgGlow = Instance.new("Frame");
ProgGlow.Size = UDim2.new(0, 0, 0, 8);
ProgGlow.Position = UDim2.new(0, 0, 0, -3);
ProgGlow.BackgroundColor3 = ACCENT;
ProgGlow.BackgroundTransparency = 0.6;
ProgGlow.BorderSizePixel = 0;
ProgGlow.Parent = ProgFill;
Instance.new("UICorner", ProgGlow).CornerRadius = UDim.new(0, 4);

-- ========== 淡出 ==========
local function fadeOut(cb)
	TweenService:Create(Bg, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {BackgroundTransparency=1}):Play();
	TweenService:Create(Blur, TweenInfo.new(0.8), {Size=0}):Play();
	for _, v in ipairs(Center:GetDescendants()) do
		pcall(function()
			if v:IsA("TextLabel") then
				TweenService:Create(v, TweenInfo.new(0.5), {TextTransparency=1}):Play();
			elseif v:IsA("Frame") then
				TweenService:Create(v, TweenInfo.new(0.5), {BackgroundTransparency=1}):Play();
			end;
		end);
	end;
	task.delay(0.9, function()
		pcall(function() Gui:Destroy() end);
		pcall(function() Blur:Destroy() end);
		if cb then cb() end;
	end);
end;

-- ========== 入场 ==========
TweenService:Create(Blur, TweenInfo.new(1.2, Enum.EasingStyle.Quad), {Size=18}):Play();
TweenService:Create(Bg, TweenInfo.new(1, Enum.EasingStyle.Quad), {BackgroundTransparency=0.35}):Play();

-- ========== 动画序列 ==========
task.delay(0.8, function()

	-- ===== 阶段1: 杨志卡 放大出现 =====
	YangZhiKa.Text = gradientText("YZK",
		Color3.fromRGB(255, 50, 150),
		Color3.fromRGB(150, 50, 255),
		Color3.fromRGB(50, 150, 255)
	);
	
	-- 先来个冲击波模糊
	dynBlur(0.6, 25);
	
	scaleIn(YangZhiKa, {X=380, Y=65}, 0.9):Play();
	scaleIn(YangAuthor, {X=130, Y=26}, 0.7):Play();
	
	task.delay(2.2, function()
		-- ===== 阶段2: 动态模糊缩小消失 =====
		dynBlur(0.7, 40);
		scaleOut(YangZhiKa, 0.5):Play();
		TweenService:Create(YangAuthor, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {TextTransparency=1}):Play();
		
		task.delay(0.8, function()
			-- ===== 阶段3: 杯子狗 放大出现 =====
			BeiZiGou.Visible = true;
			BeiAuthor.Visible = true;
			BeiZiGou.Text = gradientText("BZG",
				Color3.fromRGB(50, 255, 150),
				Color3.fromRGB(255, 150, 50),
				Color3.fromRGB(255, 50, 150)
			);
			
			dynBlur(0.6, 25);
			scaleIn(BeiZiGou, {X=380, Y=65}, 0.9):Play();
			scaleIn(BeiAuthor, {X=130, Y=26}, 0.7):Play();
			
			task.delay(2.2, function()
				-- ===== 阶段4: 动态模糊缩小消失 =====
				dynBlur(0.7, 40);
				scaleOut(BeiZiGou, 0.5):Play();
				TweenService:Create(BeiAuthor, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {TextTransparency=1}):Play();
				
				task.delay(0.8, function()
					-- ===== 阶段5: 两个一起出现 =====
					-- 重置位置：杨志卡上，杯子狗下
					YangZhiKa.Position = UDim2.new(0.5, 0, 0.40, 0);
					YangAuthor.Position = UDim2.new(0.5, 0, 0.40, 36);
					BeiZiGou.Position = UDim2.new(0.5, 0, 0.56, 0);
					BeiAuthor.Position = UDim2.new(0.5, 0, 0.56, 36);
					
					-- 重置状态
					for _, v in ipairs({YangZhiKa, YangAuthor, BeiZiGou, BeiAuthor}) do
						v.Visible = true;
						v.Size = UDim2.new(0, 0, 0, 0);
						v.TextTransparency = 1;
					end;
					
					-- 冲击波模糊
					dynBlur(0.8, 30);
					
					-- 同时放大
					scaleIn(YangZhiKa, {X=320, Y=55}, 0.8):Play();
					scaleIn(YangAuthor, {X=130, Y=26}, 0.6):Play();
					scaleIn(BeiZiGou, {X=320, Y=55}, 0.8):Play();
					scaleIn(BeiAuthor, {X=130, Y=26}, 0.6):Play();
					
					task.delay(1.2, function()
						-- ===== 阶段6: 加载进度 =====
						TweenService:Create(LoadTxt, TweenInfo.new(0.4), {TextTransparency=0}):Play();
						TweenService:Create(ProgBg, TweenInfo.new(0.4), {BackgroundTransparency=0}):Play();
						
						local steps = {
							{p=0.12, d=0.6, t="Initializing..."},
										{p=0.28, d=0.5, t="Connecting..."},
										{p=0.45, d=0.6, t="Verifying..."},
										{p=0.62, d=0.7, t="Downloading..."},
										{p=0.80, d=0.5, t="Loading Modules..."},
										{p=0.92, d=0.4, t="Init UI..."},
										{p=1.0,  d=0.3, t="Ready"}
						};
						
						-- 逐步推进
						local elapsed = 0;
						for i, s in ipairs(steps) do
							task.delay(elapsed, function()
								LoadTxt.Text = s.t;
								TweenService:Create(ProgFill, TweenInfo.new(s.d, Enum.EasingStyle.Quad), {
									Size = UDim2.new(s.p, 0, 1, 0)
								}):Play();
								-- 进度条光晕跟随
								TweenService:Create(ProgGlow, TweenInfo.new(s.d, Enum.EasingStyle.Quad), {
									Size = UDim2.new(s.p, 0, 0, 8)
								}):Play();
							end);
							elapsed = elapsed + s.d + 0.05;
						end;
						
						-- 计算总时间
						local total = 0;
						for _, s in ipairs(steps) do total = total + s.d + 0.05; end;
						
						task.delay(total, function()
							LoadTxt.Text = "Launching...";
							
							-- ===== 作者金色提示 =====
							if isOwner then
								-- 金色弹窗
								local Box = Instance.new("Frame");
								Box.Size = UDim2.new(0, 400, 0, 100);
								Box.Position = UDim2.new(0.5, 0, 0.5, 0);
								Box.AnchorPoint = Vector2.new(0.5, 0.5);
								Box.BackgroundColor3 = Color3.fromRGB(20, 18, 0);
								Box.BackgroundTransparency = 1;
								Box.BorderSizePixel = 0;
								Box.ZIndex = 100;
								Box.Parent = Center;
								Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 16);
								
								-- 金色边框
								local Border = Instance.new("UIStroke");
								Border.Thickness = 2;
								Border.Color = Color3.fromRGB(255, 200, 0);
								Border.Transparency = 1;
								Border.Parent = Box;
								
								-- 内部光晕
								local InnerGlow = Instance.new("Frame");
								InnerGlow.Size = UDim2.new(1, 0, 1, 0);
								InnerGlow.BackgroundColor3 = Color3.fromRGB(255, 200, 0);
								InnerGlow.BackgroundTransparency = 0.95;
								InnerGlow.BorderSizePixel = 0;
								InnerGlow.ZIndex = 99;
								InnerGlow.Parent = Box;
								
								-- VIP 标题
								local VipTitle = makeLabel({
									Position = UDim2.new(0.5, 0, 0.3, 0);
									Size = UDim2.new(0.9, 0, 0, 20);
									TextSize = 13;
									Font = Enum.Font.SourceSansBold;
									Text = "VIP OWNER";
									TextColor3 = Color3.fromRGB(255, 200, 0),
									TextTransparency = 1,
									ZIndex = 101;
									Parent = Box;
								});
								
								-- 欢迎文字
								local WelcomeTxt = makeLabel({
									Position = UDim2.new(0.5, 0, 0.65, 0);
									Size = UDim2.new(0.9, 0, 0, 26);
									TextSize = 20;
									RichText = true;
									Text = gradientText("Welcome VIP Owner",
										Color3.fromRGB(255, 180, 0),
										Color3.fromRGB(255, 255, 100),
										Color3.fromRGB(255, 200, 0)
									),
									TextTransparency = 1,
									ZIndex = 101;
									Parent = Box;
								});
								
								-- 弹出动画
								Box.Size = UDim2.new(0, 0, 0, 0);
								TweenService:Create(Box, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
									Size = UDim2.new(0, 400, 0, 100),
									BackgroundTransparency = 0
								}):Play();
								TweenService:Create(Border, TweenInfo.new(0.4), {Transparency=0}):Play();
								TweenService:Create(VipTitle, TweenInfo.new(0.4), {TextTransparency=0}):Play();
								TweenService:Create(WelcomeTxt, TweenInfo.new(0.5), {TextTransparency=0}):Play();
								
								-- 边框闪烁
								task.spawn(function()
									while Box.Parent do
										task.wait(0.15);
										pcall(function()
											local t = tick();
											Border.Color = Color3.fromRGB(
												255,
												180 + math.sin(t * 4) * 75,
												math.sin(t * 3) * 50
											);
											InnerGlow.BackgroundTransparency = 0.92 + math.sin(t * 3) * 0.03;
										end);
									end;
								end);
								
								-- 3秒后消失并启动
								task.delay(3, function()
									TweenService:Create(Box, TweenInfo.new(0.5), {BackgroundTransparency=1, Size=UDim2.new(0,0,0,0)}):Play();
									TweenService:Create(Border, TweenInfo.new(0.4), {Transparency=1}):Play();
									TweenService:Create(VipTitle, TweenInfo.new(0.3), {TextTransparency=1}):Play();
									TweenService:Create(WelcomeTxt, TweenInfo.new(0.3), {TextTransparency=1}):Play();
									TweenService:Create(InnerGlow, TweenInfo.new(0.4), {BackgroundTransparency=1}):Play();
									task.delay(0.6, function()
										Box:Destroy();
										doLaunch();
									end);
								end);
							else
								task.delay(0.3, doLaunch);
							end;
						end);
					end);
				end);
			end);
		end);
	end);
end);

-- ========== 使用统计 ==========
local StatsGui = nil;
local startTime = tick();
local launchCount = 0;

pcall(function()
	local saved = game:GetService("HttpService"):JSONDecode(readfile("KaiHub_stats.json"));
	launchCount = (saved.count or 0) + 1;
end);

pcall(function()
	writefile("KaiHub_stats.json", game:GetService("HttpService"):JSONEncode({count=launchCount, last=os.time()}));
end);

local function showStatsBar()
	StatsGui = Instance.new("ScreenGui");
	StatsGui.Name = "KaiHubStats";
	StatsGui.Parent = LocalPlayer.PlayerGui;
	StatsGui.ResetOnSpawn = false;
	StatsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
	
	local bar = Instance.new("Frame");
	bar.Size = UDim2.new(1, 0, 0, 22);
	bar.Position = UDim2.new(0, 0, 0, 0);
	bar.BackgroundColor3 = Color3.fromRGB(20, 20, 30);
	bar.BackgroundTransparency = 0.15;
	bar.BorderSizePixel = 0;
	bar.Parent = StatsGui;
	
	local stroke = Instance.new("UIStroke");
	stroke.Thickness = 1;
	stroke.Color = isOwner and Color3.fromRGB(255, 180, 0) or Color3.fromRGB(80, 80, 120);
	stroke.Transparency = 0.5;
	stroke.Parent = bar;
	
	local left = Instance.new("TextLabel");
	left.Size = UDim2.new(0.5, -10, 1, 0);
	left.Position = UDim2.new(0, 10, 0, 0);
	left.BackgroundTransparency = 1;
	left.Text = " Launches: " .. launchCount;
	left.Font = Enum.Font.SourceSansBold;
	left.TextSize = 13;
	left.TextColor3 = isOwner and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(150, 200, 255);
	left.TextXAlignment = Enum.TextXAlignment.Left;
	left.TextYAlignment = Enum.TextYAlignment.Center;
	left.Parent = bar;
	
	local right = Instance.new("TextLabel");
	right.Size = UDim2.new(0.5, -10, 1, 0);
	right.Position = UDim2.new(0.5, 0, 0, 0);
	right.BackgroundTransparency = 1;
	right.Text = "Session: 00:00:00 ";
	right.Font = Enum.Font.SourceSansBold;
	right.TextSize = 13;
	right.TextColor3 = isOwner and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(150, 200, 255);
	right.TextXAlignment = Enum.TextXAlignment.Right;
	right.TextYAlignment = Enum.TextYAlignment.Center;
	right.Parent = bar;
	
	-- 计时器
	task.spawn(function()
		while StatsGui and StatsGui.Parent do
			task.wait(1);
			pcall(function()
				local elapsed = tick() - startTime;
				local h = math.floor(elapsed / 3600);
				local m = math.floor((elapsed % 3600) / 60);
				local s = math.floor(elapsed % 60);
				right.Text = string.format(" Session: %02d:%02d:%02d ", h, m, s);
			end);
		end;
	end);
	
	-- 入场动画
	bar.Position = UDim2.new(0, 0, 0, -22);
	TweenService:Create(bar, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position=UDim2.new(0,0,0,0)}):Play();
end;

-- ========== 启动脚本 ==========
function doLaunch()
	local ok, err = pcall(function()
		local code = game:HttpGet(MAIN_URL);
		if code and #code > 100 then
			loadstring(code)();
		else
			error("Script fetch failed");
		end;
	end);
	
	if not ok then
		LoadTxt.Text = "Launch Failed: " .. tostring(err):sub(1, 20);
		LoadTxt.TextColor3 = Color3.fromRGB(255, 71, 87);
		task.delay(4, fadeOut);
	else
		fadeOut(function()
			task.delay(0.5, showStatsBar);
		end);
	end;
end;
