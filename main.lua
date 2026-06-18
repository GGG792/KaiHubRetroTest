-- ============================================================
-- KaiHub RetroUI - 完整移植版
-- 早期 Roblox/WinXP 风格 + KaiHub 全部功能
-- ============================================================

if not game:IsLoaded() then
	game.Loaded:Wait();
end;

local cloneref = cloneref or clonereference or function(obj)
	return obj;
end;

if _G.KaiHubRetroLoaded then
	warn("[KaiHub Retro] 已经加载了！请不要重复执行。");
	return;
end;
if _G.KaiHubRetroLoading then
	warn("[KaiHub Retro] 脚本正在加载中，请勿频繁执行！");
	return;
else
	_G.KaiHubRetroLoading = true;
end;

local startTime = tick();
local loadingTimedOut = false;
task.spawn(function()
	task.wait(60);
	if not loadingTimedOut then
		_G.KaiHubRetroLoading = false;
		cloneref(game:GetService("StarterGui")):SetCore("SendNotification", {Title="KaiHub Retro",Text="加载超时，请重试",Duration=5});
	end;
end);

-- ========== 服务 ==========
local UserInputService = cloneref(game:GetService("UserInputService"));
local TweenService = cloneref(game:GetService("TweenService"));
local Players = cloneref(game:GetService("Players"));
local RunService = cloneref(game:GetService("RunService"));
local SoundService = cloneref(game:GetService("SoundService"));
local Lighting = cloneref(game:GetService("Lighting"));
local MarketplaceService = cloneref(game:GetService("MarketplaceService"));
local Workspace = cloneref(game:GetService("Workspace"));
local VirtualInputManager = cloneref(game:GetService("VirtualInputManager"));
local StarterGui = cloneref(game:GetService("StarterGui"));
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"));
local TeleportService = cloneref(game:GetService("TeleportService"));
local VirtualUser = cloneref(game:GetService("VirtualUser"));
local AvatarEditorService = cloneref(game:GetService("AvatarEditorService"));
local LogService = cloneref(game:GetService("LogService"));
local HttpService = cloneref(game:GetService("HttpService"));
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer.PlayerGui or LocalPlayer:FindFirstChild("PlayerGui");
local CoreGui = cloneref(game:GetService("CoreGui")) or PlayerGui;

-- ========== 加载远程模块 ==========
local AsyncFileFetcher = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/AsyncFileFetcher.lua"))();
local modulesToFetch = {
	ChronixUI="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/ChronixUI%20Lib.lua",
	tpWalk="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/SafeTPWalk.lua",
	StandRecovery="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/StandRecovery.lua",
	HighlightModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/HighlightModule.lua",
	PlayerLightModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/PlayerLightModule.lua",
	SpectatorModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/SpectatorModule.lua",
	FreecamModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/FreecamModule.lua",
	LandingEffect="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/LandingEffect.lua",
	NameTagModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/NameTagModule.lua",
	PlayerVisibleModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/PlayerVisibleModule.lua",
	movementModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/MovementModule.lua",
	MouseUnlockModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/MouseUnlockModule.lua",
	DeathballScripts="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/DeathBallScripts.lua",
	ZoomModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/ZoomModule.lua",
	FlingDetector="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/FlingDetector.lua",
	SystemNotification="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/SystemNotification.lua",
	PlayerESP="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/PlayerESP.lua",
	MovableHighlighter_NM="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/MovableHighlighter-NM.lua",
	GameTeleport="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/GameTeleport.lua",
	AntiVoidModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/AntiVoid.lua",
	ChatSpy="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/ChatSpy.lua",
	ChatControl="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/ChatControl.lua",
	AirWalk="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/AirWalk.lua",
	LockCameraModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/LockCameraModule.lua",
	OBOTeleportModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/OBOTeleportModule.lua",
	NPCHighLighter="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/NPC_Highlighter.lua",
	ChatTagModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/ChatTagModule.lua",
	FlyModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/FlyModule.lua",
	ScrollSwitch="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/ScrollSwitch.lua",
	Regretevator_AutoIceCream="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/Regretevator_AutoIceCream.lua",
	InstantInteraction="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/InstantInteraction.lua",
	UNCTestModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/uncAndwuncget.lua",
	ServerFinderModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/ServerFinderModule.lua",
	AimBotModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/AimBotModule.lua",
	DeleteTool="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/DeleteTool.lua",
	GuiDeleter="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/GuiDeleter.lua",
	AntiKickModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/AntiKick.lua",
	HandleKillModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/HandleKillModule.lua",
	FlingModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/FlingModule.lua",
	LoopOofModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/LoopOofModule.lua",
	SpinModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/SpinModule.lua",
	ConfigModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/ConfigModule.lua",
	FootstepHighlighter="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/FootstepHighlighter.lua",
	TeleportModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/TeleportModule.lua",
	WebSocketManager="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/WebSocketManager.lua"
};

for moduleName, content in pairs(AsyncFileFetcher.fetchMultiple(modulesToFetch)) do
	if (content and (type(content) == "string") and (content ~= "")) then
		local success, result = pcall(loadstring, content);
		if (success and result) then
			(_ENV or getfenv())[moduleName] = result();
		else
			warn("模块加载失败: " .. moduleName);
		end;
	end;
end;

local unloadKaiHubRetro;
ConfigModule.setmain("KaiHubRetroConfig");

-- ========== 数据表 ==========
local data = {
	basicdata={
		window={
			windowSize=((UserInputService.TouchEnabled and not UserInputService.MouseEnabled and UDim2.new(0, 476, 0, 294)) or UDim2.new(0, 680, 0, 420))
		},
		player={
			name=LocalPlayer.Name,
			displayname=LocalPlayer.DisplayName,
			userid=LocalPlayer.UserId,
			isPremium=(LocalPlayer.MembershipType == Enum.MembershipType.Premium),
			speed=((LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")) or {WalkSpeed=16}).WalkSpeed,
			islockspeed=false,
			jump=((LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")) or {JumpPower=50}).JumpPower,
			islockjump=false,
			maxhealth=((LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")) or {JumpPower=100}).MaxHealth,
			islockmaxhealth=false,
			health=((LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")) or {JumpPower=100}).Health,
			islockhealth=false,
			gravity=Workspace.Gravity,
			islockgravity=false
		},
		releasetools={
			antiafk=true,
			zoom=ZoomModule.new(),
			Lantern=PlayerLightModule.new({Brightness=3,Range=20,Color=Color3.fromRGB(255, 165, 0),Shadows=true}),
			SuperLighter=PlayerLightModule.new({Brightness=2,Range=1000}),
			noclip=false,
			infjump=false,
			antifall=false,
			antidead=false,
			executecode="",
			nightvision=false,
			npc=NPCHighLighter.new(),
			chatresend=false,
			supernightvision=false,
			originalBrightness=Lighting.Brightness,
			originalExposureCompensation=Lighting.ExposureCompensation,
			keepchronixhub=false,
			networkpausedisable=false,
			exitgame=0,
			staffcheck=false,
			xray=false
		},
		otherdata={
			executordetecter={
				robloxinfo=HttpService:JSONDecode(AsyncFileFetcher.fetchSingle("https://weao.xyz/api/versions/current")),
				exploits=HttpService:JSONDecode(AsyncFileFetcher.fetchSingle("https://weao.xyz/api/status/exploits"))
			},
			playertitle={
				tag=ChatTagModule.new({player=LocalPlayer,text="[VIP]",color="#FFD700",size=18,bold=false,italic=false,font="GothamBlack"}),
				text="[VIP]",
				color="#FFD700",
				size=18,
				bold=false,
				italic=false,
				font="GothamBlack"
			},
			musicbox=Instance.new("Sound"),
			testSound=Instance.new("Sound"),
			daySettings={Ambient=Lighting.Ambient,Brightness=Lighting.Brightness,ColorShift_Bottom=Lighting.ColorShift_Bottom,ColorShift_Top=Lighting.ColorShift_Top,OutdoorAmbient=Lighting.OutdoorAmbient,GlobalShadows=Lighting.GlobalShadows},
			nightSettings={Ambient=Color3.new(0.1,0.1,0.15),Brightness=0.3,ColorShift_Bottom=Color3.new(0,0,0),ColorShift_Top=Color3.new(0,0,0),OutdoorAmbient=Color3.new(0.05,0.05,0.1),GlobalShadows=true},
			musicData={musicIds={"142376088","1838618353","1837879082","1841647093","1837879099","1838618353"},currentId="142376088",isPlay=false,isPause=false},
			audioData={threshold=30,enable=false,lastScanTime=0,currentSelectedId=nil,isTesting=false,audioListItems={},scanConnection=nil},
			savedAtmospheres={}
		}
	},
	othergamedata={
		delesions_office={entitywarning=false,tipotherplayer=false,auto013=false},
		grace={autolever=false,deleteentity=false},
		AntarcticExpedition={giftnumber="1"},
		west_wood={},
		sirenhead_legacy={},
		nightmare_run={},
		project_transfur={},
		backroomsurvival={},
		DarkestHours={},
		Regretevator={}
	},
	basicdata_hankermodule={
		spin={speed=20},
		hkill={killname="PlayerName",killrange=100,killall=false,killany=false}
	},
	Supported_Games={
		{name="死亡球",gameid=12776501474},
		{name="小屋角色扮演",gameid=12625580888},
		{name="南极探险队",gameid=11656036927},
		{name="西部森林",gameid=1324061305},
		{name="警笛头:遗产",gameid=1162065585},
		{name="噩梦之行",gameid=11649582918},
		{name="兽化项目",gameid=14036136131},
		{name="妄想办公室",gameid=15753132981},
		{name="格蕾丝",gameid=15049111150},
		{name="深渊",gameid=1162065585},
		{name="后院生存",gameid=1324061305},
		{name="最黑暗的时刻",gameid=14036136131},
		{name="后悔电梯",gameid=12776501474}
	},
	scriptlist={
		{name="Infinite Yield",link="https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source"},
		{name="Dex Explorer",link="https://raw.githubusercontent.com/Babyhamsta/RBLX_DEX/main/out/dex.lua"},
		{name="Remote Spy",link="https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"}
	}
};

data['basicdata']['otherdata']['musicbox']['Volume'] = 0.5;
data['basicdata']['otherdata']['musicbox']['Looped'] = false;
data['basicdata']['otherdata']['musicbox']['Parent'] = SoundService;
data['basicdata']['otherdata']['testSound']['Volume'] = 0.5;
data['basicdata']['otherdata']['testSound']['Parent'] = SoundService;

-- ========== 辅助函数 ==========
local function toChineseDate(dateStr, toBeijingTime)
	if (not dateStr or (type(dateStr) ~= "string")) then return ""; end;
	local m, d, y, h, min, s, ap = dateStr:match("(%d+)%D+(%d+)%D+(%d+)%D+(%d+)%D+(%d+)%D*(%d*)%D*([AP]M)");
	if not m then return dateStr; end;
	s = ((s ~= "") and s) or "0";
	local hour = tonumber(h);
	if ((ap == "PM") and (hour ~= 12)) then hour = hour + 12;
	elseif ((ap == "AM") and (hour == 12)) then hour = 0; end;
	if toBeijingTime then
		hour = hour + 8;
		if (hour >= 24) then hour = hour - 24; end;
	end;
	return string.format("%d年%d月%d日 %02d:%02d:%02d", tonumber(y), tonumber(m), tonumber(d), hour, tonumber(min), tonumber(s));
end;

local function parseExecutors(jsonString)
	local result = {};
	for _, item in ipairs(jsonString) do
		if (type(item) == "table") then
			local flat = {
				title=item.title,version=item.version,platform=item.platform,extType=item.extype,
				free=item.free,detected=item.detected,uncStatus=item.uncStatus,
				uncPercent=item.uncPercentage,suncPercent=item.suncPercentage,
				updatedDate=toChineseDate(item.updatedDate or "", true),
				updateStatus=item.updateStatus,decompiler=item.decompiler,
				multiInject=item.multiInject,keysystem=item.keysystem,
				website=item.websitelink,discord=item.discordlink
			};
			table.insert(result, flat);
		end;
	end;
	return result;
end;

local shownParts = {};
local function showpartsfunction(enable)
	if enable then
		for i, v in pairs(Workspace:GetDescendants()) do
			if (v:IsA("BasePart") and (v.Transparency == 1)) then
				if not table.find(shownParts, v) then table.insert(shownParts, v); end;
				v.Transparency = 0;
			end;
		end;
	else
		for i, v in pairs(shownParts) do v.Transparency = 1; end;
		shownParts = {};
	end;
end;

local function formatUsername(player)
	if (player.DisplayName ~= player.Name) then
		return string.format("%s (%s)", player.Name, player.DisplayName);
	end;
	return player.Name;
end;

local function xray(enabled)
	for _, v in pairs(Workspace:GetDescendants()) do
		if (v:IsA("BasePart") and not v.Parent:FindFirstChildWhichIsA("Humanoid") and not v.Parent.Parent:FindFirstChildWhichIsA("Humanoid")) then
			v.LocalTransparencyModifier = (enabled and 0.5) or 0;
		end;
	end;
end;

local function maskStringMiddle(str)
	if (not str or (type(str) ~= "string")) then return ""; end;
	local strLength = string.len(str);
	if (strLength <= 10) then return str;
	else
		return string.sub(str, 1, 5) .. string.rep("#", strLength - 10) .. string.sub(str, -5);
	end;
end;

function respawn()
	local char = LocalPlayer.Character;
	if not char then return; end;
	local hum = char:FindFirstChildWhichIsA("Humanoid");
	if hum then
		hum:ChangeState(Enum.HumanoidStateType.Dead);
		hum.Health = 0;
		hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true);
		task.wait(0.01);
		hum:Destroy();
	end;
	for _, v in pairs(char:GetChildren()) do
		if (v:IsA("BasePart") or v:IsA("Humanoid")) then v:Destroy(); end;
	end;
	task.wait(0.05);
	char:BreakJoints();
	char:Destroy();
end;

function refresh()
	local char = LocalPlayer.Character;
	if not char then char = LocalPlayer.CharacterAdded:Wait(); end;
	local humanoid = char:FindFirstChildOfClass("Humanoid");
	local root = humanoid and humanoid.RootPart;
	if not root then
		repeat
			task.wait();
			humanoid = char:FindFirstChildOfClass("Humanoid");
			root = humanoid and humanoid.RootPart;
		until root;
	end;
	local pos = root.CFrame;
	local pos1 = Workspace.CurrentCamera.CFrame;
	respawn();
	task.spawn(function()
		local newChar = LocalPlayer.CharacterAdded:Wait();
		local newHumanoid, newRoot;
		repeat
			task.wait();
			newHumanoid = newChar:FindFirstChildOfClass("Humanoid");
			newRoot = newHumanoid and newHumanoid.RootPart;
		until newRoot;
		newRoot.CFrame = pos;
		Workspace.CurrentCamera.CFrame = pos1;
	end);
end;

local staffRoles = {"mod","admin","staff","dev","founder","owner","supervis","manager","management","executive","president","chairman","chairwoman","chairperson","director"};
local function getStaffRole(player)
	local playerRole = player:GetRoleInGroup(game.CreatorId);
	local result = {Role=playerRole,Staff=false};
	if player:IsInGroup(1200769) then result.Role = "Roblox Employee"; result.Staff = true; end;
	for _, role in pairs(staffRoles) do
		if string.find(string.lower(playerRole), role) then result.Staff = true; end;
	end;
	return result;
end;

function randomString()
	local length = math.random(10, 20);
	local array = {};
	for i = 1, length do array[i] = string.char(math.random(32, 126)); end;
	return table.concat(array);
end;

local function promptNewRig(rig)
	local humanoid = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid");
	if humanoid then
		AvatarEditorService:PromptSaveAvatar(humanoid.HumanoidDescription, Enum.HumanoidRigType[rig]);
		local result = AvatarEditorService.PromptSaveAvatarCompleted:Wait();
		if (result == Enum.AvatarPromptResult.Success) then
			if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Dead);
			else LocalPlayer.Character:BreakJoints(); end;
		end;
	end;
end;

local function RemoveFog()
	data['basicdata']['otherdata']['savedAtmospheres'] = {};
	Lighting.FogEnd = 100000;
	for i, v in pairs(Lighting:GetDescendants()) do
		if v:IsA("Atmosphere") then
			local atmData = {Parent=v.Parent,Name=v.Name,Properties={}};
			for _, prop in ipairs({"Density","Offset","Color","Decay","Glare","Haze"}) do
				atmData.Properties[prop] = v[prop];
			end;
			table.insert(data['basicdata']['otherdata']['savedAtmospheres'], atmData);
			v:Destroy();
		end;
	end;
end;

local function RestoreFog()
	for _, atmData in ipairs(data['basicdata']['otherdata']['savedAtmospheres']) do
		local atmosphere = Instance.new("Atmosphere");
		atmosphere.Parent = atmData.Parent;
		atmosphere.Name = atmData.Name;
		for prop, value in pairs(atmData.Properties) do atmosphere[prop] = value; end;
	end;
	data['basicdata']['otherdata']['savedAtmospheres'] = {};
end;

local function convertToSmallCaps(text)
	local map = {a="ᴀ",b="ʙ",c="ᴄ",d="ᴅ",e="ᴇ",f="ғ",g="ɢ",h="ʜ",i="ɪ",j="ᴊ",k="ᴋ",l="ʟ",m="ᴍ",n="ɴ",o="ᴏ",p="ᴘ",q="ǫ",r="ʀ",s="s",t="ᴛ",u="ᴜ",v="ᴠ",w="ᴡ",x="x",y="ʏ",z="ᴢ"};
	return (text:gsub("[a-zA-Z]", map));
end;

function hasNoSmallCapsAndHasLetters(text)
	local smallCapsChars = "ᴀʙᴄᴅᴇғɢʜɪᴊᴋʟᴍɴᴏᴘǫʀsᴛᴜᴠᴡxʏᴢ";
	for i = 1, #smallCapsChars do
		if text:find(smallCapsChars:sub(i, i), 1, true) then return false; end;
	end;
	if not text:find("[a-zA-Z]") then return false; end;
	return true;
end;

local function rejoinCurrentGame()
	local placeId1 = game.PlaceId;
	local jobId1 = game.JobId;
	if (jobId1 and (jobId1 ~= "")) then
		TeleportService:TeleportToPlaceInstance(placeId1, jobId1, LocalPlayer);
	else
		TeleportService:Teleport(placeId1, LocalPlayer);
	end;
end;

local function setDay()
	for property, value in pairs(data['basicdata']['otherdata']['daySettings']) do
		local tween = TweenService:Create(Lighting, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {[property]=value});
		tween:Play();
	end;
end;

local function setNight()
	for property, value in pairs(data['basicdata']['otherdata']['nightSettings']) do
		local tween = TweenService:Create(Lighting, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {[property]=value});
		tween:Play();
	end;
end;

local function TeleportTo(x, y, z)
	if ((type(x) ~= "number") or (type(y) ~= "number") or (type(z) ~= "number")) then return false; end;
	local character = LocalPlayer.Character;
	if not character then character = LocalPlayer.CharacterAdded:Wait(); end;
	local rootPart = character:FindFirstChild("HumanoidRootPart");
	if not rootPart then return false; end;
	rootPart.CFrame = CFrame.new(Vector3.new(x, y, z));
	return true;
end;

local function getAllPostEffects()
	local effects = {};
	for _, obj in ipairs(Lighting:GetDescendants()) do if obj:IsA("PostEffect") then table.insert(effects, obj); end; end;
	local camera = Workspace.CurrentCamera;
	if camera then for _, obj in ipairs(camera:GetDescendants()) do if obj:IsA("PostEffect") then table.insert(effects, obj); end; end; end;
	return effects;
end;

local function getColorCorrectionEffect()
	for _, effect in ipairs(getAllPostEffects()) do if effect:IsA("ColorCorrectionEffect") then return effect; end; end;
	return nil;
end;

local function getMemoryUsage(unit)
	unit = unit or "MB";
	local success, result = pcall(function() return collectgarbage("count"); end);
	local memoryKB = success and result or gcinfo();
	if (unit == "KB") then return memoryKB;
	elseif (unit == "GB") then return memoryKB / (1024 * 1024);
	else return memoryKB / 1024; end;
end;

local function color3ToHex(color)
	return string.format("#%02X%02X%02X", math.floor((color.R * 255) + 0.5), math.floor((color.G * 255) + 0.5), math.floor((color.B * 255) + 0.5));
end;

local function hexToColor3(hex)
	hex = hex:gsub("#", "");
	return Color3.new(tonumber(hex:sub(1, 2), 16) / 255, tonumber(hex:sub(3, 4), 16) / 255, tonumber(hex:sub(5, 6), 16) / 255);
end;

local function detectEntity(instance)
	if instance:IsA("BasePart") then
		for entityName, entityInfo in pairs(data['othergamedata']['delesions_office']['entitys'] or {}) do
			if (instance.Name == entityName) then
				if data['othergamedata']['delesions_office']['entitywarning'] then
					ChronixUI:Notify({Title="！警告！",Content=("实体" .. entityInfo.name .. "已生成！\n" .. entityInfo.tip),Type="warning",Duration=5});
				end;
				break;
			end;
		end;
	end;
end;

-- ========== 启动次数统计 ==========
local launchCount = 0;
pcall(function()
	local saved = game:GetService("HttpService"):JSONDecode(readfile("KaiHub_stats.json"));
	launchCount = saved.count or 0;
end);
launchCount = launchCount + 1;
pcall(function()
	writefile("KaiHub_stats.json", game:GetService("HttpService"):JSONEncode({count=launchCount}));
end);

-- ============================================================
-- RetroUI 框架
-- ============================================================
local RetroUI = {};
RetroUI.__index = RetroUI;

-- 经典 Roblox/WinXP 配色
local C = {
	WinBg = Color3.fromRGB(212, 208, 200);
	WinTitle = Color3.fromRGB(0, 16, 128);
	WinTitleInactive = Color3.fromRGB(128, 128, 128);
	WinTitleText = Color3.fromRGB(255, 255, 255);
	BevelLight = Color3.fromRGB(255, 255, 255);
	BevelDark = Color3.fromRGB(128, 128, 128);
	BevelDarker = Color3.fromRGB(64, 64, 64);
	BevelMid = Color3.fromRGB(192, 192, 192);
	BtnFace = Color3.fromRGB(212, 208, 200);
	BtnHighlight = Color3.fromRGB(240, 240, 240);
	BtnShadow = Color3.fromRGB(128, 128, 128);
	BtnPressed = Color3.fromRGB(192, 192, 192);
	SidebarBg = Color3.fromRGB(245, 243, 240);
	SidebarActive = Color3.fromRGB(49, 106, 197);
	SidebarHover = Color3.fromRGB(220, 218, 214);
	SidebarText = Color3.fromRGB(0, 0, 0);
	SidebarTextActive = Color3.fromRGB(255, 255, 255);
	ContentBg = Color3.fromRGB(255, 255, 255);
	ContentText = Color3.fromRGB(0, 0, 0);
	ContentTextDim = Color3.fromRGB(100, 100, 100);
	ContentBorder = Color3.fromRGB(128, 128, 128);
	InputBg = Color3.fromRGB(255, 255, 255);
	InputBorder = Color3.fromRGB(128, 128, 128);
	InputText = Color3.fromRGB(0, 0, 0);
	ScrollThumb = Color3.fromRGB(160, 160, 160);
	ScrollTrack = Color3.fromRGB(212, 208, 200);
	StatusBg = Color3.fromRGB(176, 176, 176);
	StatusText = Color3.fromRGB(0, 0, 0);
	ToggleOn = Color3.fromRGB(49, 106, 197);
	ToggleOff = Color3.fromRGB(192, 192, 192);
	CloseBtn = Color3.fromRGB(108, 108, 108);
	CloseHover = Color3.fromRGB(200, 60, 60);
	MinimizeBtn = Color3.fromRGB(108, 108, 108);
	MinimizeHover = Color3.fromRGB(100, 140, 200);
	Separator = Color3.fromRGB(128, 128, 128);
	TabHeader = Color3.fromRGB(245, 243, 240);
	TabHeaderActive = Color3.fromRGB(255, 255, 255);
	TabHeaderBorder = Color3.fromRGB(128, 128, 128);
	DropdownBg = Color3.fromRGB(255, 255, 255);
	DropdownHover = Color3.fromRGB(49, 106, 197);
	DropdownHoverText = Color3.fromRGB(255, 255, 255);
	DropdownArrow = Color3.fromRGB(0, 0, 0);
	SliderTrack = Color3.fromRGB(192, 192, 192);
	SliderFill = Color3.fromRGB(49, 106, 197);
	SliderThumb = Color3.fromRGB(212, 208, 200);
	LabelBg = Color3.fromRGB(245, 243, 240);
};

-- 3D 凹凸边框
local function addBevel(parent, style, thickness)
	thickness = thickness or 2;
	local lightColor = style == "raised" and C.BevelLight or C.BevelDark;
	local darkColor = style == "raised" and C.BevelDark or C.BevelLight;
	local edges = {
		{Size=UDim2.new(0, thickness, 1, 0), Position=UDim2.new(0, 0, 0, 0), Color=lightColor},
		{Size=UDim2.new(1, 0, 0, thickness), Position=UDim2.new(0, 0, 0, 0), Color=lightColor},
		{Size=UDim2.new(0, thickness, 1, 0), Position=UDim2.new(1, -thickness, 0, 0), Color=darkColor},
		{Size=UDim2.new(1, 0, 0, thickness), Position=UDim2.new(0, 0, 1, -thickness), Color=darkColor},
	};
	for _, e in ipairs(edges) do
		local f = Instance.new("Frame");
		f.Size = e.Size; f.Position = e.Position;
		f.BackgroundColor3 = e.Color; f.BorderSizePixel = 0;
		f.ZIndex = parent.ZIndex + 1; f.Parent = parent;
	end;
	if thickness >= 2 then
		local inner = {
			{Size=UDim2.new(0, 1, 1, -2), Position=UDim2.new(0, thickness, 0, 1), Color=C.BevelMid},
			{Size=UDim2.new(1, -2, 0, 1), Position=UDim2.new(0, 1, 0, thickness), Color=C.BevelMid},
		};
		for _, e in ipairs(inner) do
			local f = Instance.new("Frame");
			f.Size = e.Size; f.Position = e.Position;
			f.BackgroundColor3 = e.Color; f.BorderSizePixel = 0;
			f.ZIndex = parent.ZIndex + 1; f.Parent = parent;
		end;
	end;
end;

-- ========== 创建窗口 ==========
function RetroUI.new(config)
	config = config or {};
	local self = setmetatable({}, RetroUI);
	self.Name = config.Name or "脚本中心";
	self.Subtitle = config.Subtitle or "v1.0";
	self.Tabs = {};
	self.ActiveTab = nil;
	self.Connections = {};
	self.StatusText = "就绪";
	self.IsMinimized = false;
	self.OriginalSize = nil;
	self.OriginalPosition = nil;
	self.MinimizeBtn = nil;
	self.MinimizedIcon = nil;

	self:_build();
	return self;
end;

function RetroUI:_build()
	self.Gui = Instance.new("ScreenGui");
	self.Gui.Name = "KaiHubRetroUI";
	self.Gui.Parent = LocalPlayer.PlayerGui;
	self.Gui.ResetOnSpawn = false;
	self.Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;

	-- 主窗口
	self.Frame = Instance.new("Frame");
	self.Frame.Name = "MainFrame";
	self.Frame.Size = UDim2.new(0, 680, 0, 460);
	self.Frame.Position = UDim2.new(0.5, -340, 0.5, -230);
	self.Frame.BackgroundColor3 = C.WinBg;
	self.Frame.BorderSizePixel = 0;
	self.Frame.Parent = self.Gui;
	addBevel(self.Frame, "raised", 2);

	-- 标题栏
	self.TitleBar = Instance.new("Frame");
	self.TitleBar.Size = UDim2.new(1, -4, 0, 24);
	self.TitleBar.Position = UDim2.new(0, 2, 0, 2);
	self.TitleBar.BackgroundColor3 = C.WinTitle;
	self.TitleBar.BorderSizePixel = 0;
	self.TitleBar.ZIndex = 10;
	self.TitleBar.Parent = self.Frame;

	local titleGradTop = Instance.new("Frame");
	titleGradTop.Size = UDim2.new(1, 0, 0, 12);
	titleGradTop.BackgroundColor3 = Color3.fromRGB(50, 80, 200);
	titleGradTop.BackgroundTransparency = 0.3;
	titleGradTop.BorderSizePixel = 0;
	titleGradTop.ZIndex = 11;
	titleGradTop.Parent = self.TitleBar;

	local titleLine = Instance.new("Frame");
	titleLine.Size = UDim2.new(1, 0, 0, 1);
	titleLine.Position = UDim2.new(0, 0, 1, -1);
	titleLine.BackgroundColor3 = C.BevelDark;
	titleLine.BorderSizePixel = 0;
	titleLine.ZIndex = 11;
	titleLine.Parent = self.TitleBar;

	-- 标题图标
	local icon = Instance.new("Frame");
	icon.Size = UDim2.new(0, 14, 0, 14);
	icon.Position = UDim2.new(0, 4, 0, 5);
	icon.BackgroundColor3 = Color3.fromRGB(100, 160, 255);
	icon.BorderSizePixel = 0;
	icon.ZIndex = 12;
	icon.Parent = self.TitleBar;
	addBevel(icon, "raised", 1);

	-- 标题文字
	local titleLabel = Instance.new("TextLabel");
	titleLabel.Size = UDim2.new(0, 300, 1, 0);
	titleLabel.Position = UDim2.new(0, 22, 0, 0);
	titleLabel.BackgroundTransparency = 1;
	titleLabel.Text = self.Name;
	titleLabel.Font = Enum.Font.SourceSansBold;
	titleLabel.TextSize = 12;
	titleLabel.TextColor3 = C.WinTitleText;
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left;
	titleLabel.ZIndex = 12;
	titleLabel.Parent = self.TitleBar;

	local verLabel = Instance.new("TextLabel");
	verLabel.Size = UDim2.new(0, 80, 1, 0);
	verLabel.Position = UDim2.new(0, 24 + 60, 0, 0);
	verLabel.BackgroundTransparency = 1;
	verLabel.Text = self.Subtitle;
	verLabel.Font = Enum.Font.SourceSans;
	verLabel.TextSize = 10;
	verLabel.TextColor3 = Color3.fromRGB(180, 200, 255);
	verLabel.TextXAlignment = Enum.TextXAlignment.Left;
	verLabel.ZIndex = 12;
	verLabel.Parent = self.TitleBar;

	-- 关闭按钮
	local closeBtn = Instance.new("TextButton");
	closeBtn.Size = UDim2.new(0, 21, 0, 21);
	closeBtn.Position = UDim2.new(1, -23, 0, 2);
	closeBtn.BackgroundColor3 = C.CloseBtn;
	closeBtn.BorderSizePixel = 0;
	closeBtn.Text = "X";
	closeBtn.Font = Enum.Font.SourceSansBold;
	closeBtn.TextSize = 10;
	closeBtn.TextColor3 = C.WinTitleText;
	closeBtn.ZIndex = 12;
	closeBtn.Parent = self.TitleBar;
	addBevel(closeBtn, "raised", 1);

	closeBtn.MouseEnter:Connect(function() closeBtn.BackgroundColor3 = C.CloseHover; end);
	closeBtn.MouseLeave:Connect(function() closeBtn.BackgroundColor3 = C.CloseBtn; end);
	closeBtn.MouseButton1Click:Connect(function() self:Destroy(); end);

	-- ===== 最小化按钮（WinXP风格） =====
	local minimizeBtn = Instance.new("TextButton");
	minimizeBtn.Size = UDim2.new(0, 21, 0, 21);
	minimizeBtn.Position = UDim2.new(1, -46, 0, 2);
	minimizeBtn.BackgroundColor3 = C.MinimizeBtn;
	minimizeBtn.BorderSizePixel = 0;
	minimizeBtn.Text = "_";
	minimizeBtn.Font = Enum.Font.SourceSansBold;
	minimizeBtn.TextSize = 12;
	minimizeBtn.TextColor3 = C.WinTitleText;
	minimizeBtn.ZIndex = 12;
	minimizeBtn.Parent = self.TitleBar;
	addBevel(minimizeBtn, "raised", 1);
	self.MinimizeBtn = minimizeBtn;

	minimizeBtn.MouseEnter:Connect(function() minimizeBtn.BackgroundColor3 = C.MinimizeHover; end);
	minimizeBtn.MouseLeave:Connect(function() minimizeBtn.BackgroundColor3 = C.MinimizeBtn; end);
	minimizeBtn.MouseButton1Click:Connect(function() self:ToggleMinimize(); end);

	-- 菜单栏
	local menuBar = Instance.new("Frame");
	menuBar.Size = UDim2.new(1, -4, 0, 20);
	menuBar.Position = UDim2.new(0, 2, 0, 26);
	menuBar.BackgroundColor3 = C.WinBg;
	menuBar.BorderSizePixel = 0;
	menuBar.ZIndex = 10;
	menuBar.Parent = self.Frame;
	addBevel(menuBar, "raised", 1);

	local menuItems = {"文件", "编辑", "查看", "帮助"};
	for i, item in ipairs(menuItems) do
		local menuBtn = Instance.new("TextButton");
		menuBtn.Size = UDim2.new(0, 36, 0, 18);
		menuBtn.Position = UDim2.new(0, 2 + (i-1) * 38, 0, 1);
		menuBtn.BackgroundColor3 = C.WinBg;
		menuBtn.BorderSizePixel = 0;
		menuBtn.Text = item;
		menuBtn.Font = Enum.Font.SourceSans;
		menuBtn.TextSize = 11;
		menuBtn.TextColor3 = C.ContentText;
		menuBtn.ZIndex = 11;
		menuBtn.Parent = menuBar;
		menuBtn.MouseEnter:Connect(function()
			menuBtn.BackgroundColor3 = C.SidebarActive;
			menuBtn.TextColor3 = C.SidebarTextActive;
		end);
		menuBtn.MouseLeave:Connect(function()
			menuBtn.BackgroundColor3 = C.WinBg;
			menuBtn.TextColor3 = C.ContentText;
		end);
	end;

	-- 工具栏
	local toolBar = Instance.new("Frame");
	toolBar.Size = UDim2.new(1, -4, 0, 26);
	toolBar.Position = UDim2.new(0, 2, 0, 46);
	toolBar.BackgroundColor3 = C.WinBg;
	toolBar.BorderSizePixel = 0;
	toolBar.ZIndex = 10;
	toolBar.Parent = self.Frame;
	addBevel(toolBar, "raised", 1);

	local toolSep = Instance.new("Frame");
	toolSep.Size = UDim2.new(1, 0, 0, 1);
	toolSep.Position = UDim2.new(0, 0, 1, -1);
	toolSep.BackgroundColor3 = C.BevelDark;
	toolSep.BorderSizePixel = 0;
	toolSep.ZIndex = 11;
	toolSep.Parent = toolBar;

	-- 工具栏按钮
	local toolIcons = {"||", ">>", "[]", "##", "@@"};
	for i, icon in ipairs(toolIcons) do
		local toolBtn = Instance.new("TextButton");
		toolBtn.Size = UDim2.new(0, 24, 0, 22);
		toolBtn.Position = UDim2.new(0, 2 + (i-1) * 26, 0, 2);
		toolBtn.BackgroundColor3 = C.WinBg;
		toolBtn.BorderSizePixel = 0;
		toolBtn.Text = icon;
		toolBtn.Font = Enum.Font.SourceSans;
		toolBtn.TextSize = 10;
		toolBtn.TextColor3 = C.ContentText;
		toolBtn.ZIndex = 11;
		toolBtn.Parent = toolBar;
		toolBtn.MouseEnter:Connect(function() toolBtn.BackgroundColor3 = C.BtnHighlight; end);
		toolBtn.MouseLeave:Connect(function() toolBtn.BackgroundColor3 = C.WinBg; end);
	end;

	-- 主体区域
	local bodyFrame = Instance.new("Frame");
	bodyFrame.Size = UDim2.new(1, -4, 1, -100);
	bodyFrame.Position = UDim2.new(0, 2, 0, 72);
	bodyFrame.BackgroundColor3 = C.WinBg;
	bodyFrame.BorderSizePixel = 0;
	bodyFrame.ZIndex = 5;
	bodyFrame.Parent = self.Frame;

	-- 侧边栏
	self.Sidebar = Instance.new("Frame");
	self.Sidebar.Size = UDim2.new(0, 130, 1, 0);
	self.Sidebar.BackgroundColor3 = C.SidebarBg;
	self.Sidebar.BorderSizePixel = 0;
	self.Sidebar.ZIndex = 6;
	self.Sidebar.Parent = bodyFrame;
	addBevel(self.Sidebar, "sunken", 1);

	local sideTitle = Instance.new("Frame");
	sideTitle.Size = UDim2.new(1, 0, 0, 20);
	sideTitle.BackgroundColor3 = C.WinBg;
	sideTitle.BorderSizePixel = 0;
	sideTitle.ZIndex = 7;
	sideTitle.Parent = self.Sidebar;

	local sideTitleLabel = Instance.new("TextLabel");
	sideTitleLabel.Size = UDim2.new(1, -4, 1, 0);
	sideTitleLabel.Position = UDim2.new(0, 4, 0, 0);
	sideTitleLabel.BackgroundTransparency = 1;
	sideTitleLabel.Text = "导航栏";
	sideTitleLabel.Font = Enum.Font.SourceSansBold;
	sideTitleLabel.TextSize = 10;
	sideTitleLabel.TextColor3 = C.ContentText;
	sideTitleLabel.TextXAlignment = Enum.TextXAlignment.Left;
	sideTitleLabel.ZIndex = 8;
	sideTitleLabel.Parent = sideTitle;

	-- 内容区域
	self.Content = Instance.new("Frame");
	self.Content.Size = UDim2.new(1, -130, 1, 0);
	self.Content.Position = UDim2.new(0, 130, 0, 0);
	self.Content.BackgroundColor3 = C.ContentBg;
	self.Content.BorderSizePixel = 0;
	self.Content.ClipsDescendants = true;
	self.Content.ZIndex = 6;
	self.Content.Parent = bodyFrame;
	addBevel(self.Content, "sunken", 2);

	-- 状态栏
	self.StatusBar = Instance.new("Frame");
	self.StatusBar.Size = UDim2.new(1, -4, 0, 20);
	self.StatusBar.Position = UDim2.new(0, 2, 1, -22);
	self.StatusBar.BackgroundColor3 = C.StatusBg;
	self.StatusBar.BorderSizePixel = 0;
	self.StatusBar.ZIndex = 10;
	self.StatusBar.Parent = self.Frame;
	addBevel(self.StatusBar, "sunken", 1);

	local statusSep = Instance.new("Frame");
	statusSep.Size = UDim2.new(0, 1, 1, -4);
	statusSep.Position = UDim2.new(0.7, 0, 0, 2);
	statusSep.BackgroundColor3 = C.BevelDark;
	statusSep.BorderSizePixel = 0;
	statusSep.ZIndex = 11;
	statusSep.Parent = self.StatusBar;

	local statusLabel = Instance.new("TextLabel");
	statusLabel.Name = "StatusLabel";
	statusLabel.Size = UDim2.new(0.7, -8, 1, 0);
	statusLabel.Position = UDim2.new(0, 4, 0, 0);
	statusLabel.BackgroundTransparency = 1;
	statusLabel.Text = self.StatusText;
	statusLabel.Font = Enum.Font.SourceSans;
	statusLabel.TextSize = 10;
	statusLabel.TextColor3 = C.StatusText;
	statusLabel.TextXAlignment = Enum.TextXAlignment.Left;
	statusLabel.ZIndex = 12;
	statusLabel.Parent = self.StatusBar;
	self.StatusLabel = statusLabel;

	local statusRight = Instance.new("TextLabel");
	statusRight.Size = UDim2.new(0.3, -8, 1, 0);
	statusRight.Position = UDim2.new(0.7, 4, 0, 0);
	statusRight.BackgroundTransparency = 1;
	statusRight.Text = os.date("%H:%M:%S");
	statusRight.Font = Enum.Font.SourceSans;
	statusRight.TextSize = 10;
	statusRight.TextColor3 = C.StatusText;
	statusRight.TextXAlignment = Enum.TextXAlignment.Right;
	statusRight.ZIndex = 12;
	statusRight.Parent = self.StatusBar;

	task.spawn(function()
		while self.Gui and self.Gui.Parent do
			task.wait(1);
			pcall(function() statusRight.Text = os.date("%H:%M:%S"); end);
		end;
	end);

	-- 拖拽
	self:_makeDraggable();
end;

-- ========== 最小化功能 ==========
function RetroUI:ToggleMinimize()
	if self.IsMinimized then
		-- 恢复窗口
		self.Frame.Visible = true;
		if self.MinimizedIcon then self.MinimizedIcon:Destroy(); self.MinimizedIcon = nil; end;
		self.IsMinimized = false;
		self:SetStatus("窗口已恢复");
	else
		-- 最小化窗口 - 创建任务栏图标
		self.Frame.Visible = false;
		self.IsMinimized = true;
		self:SetStatus("窗口已最小化");
		self:_createMinimizedIcon();
	end;
end;

function RetroUI:_createMinimizedIcon()
	local icon = Instance.new("TextButton");
	icon.Name = "KaiHubMinimizedIcon";
	icon.Size = UDim2.new(0, 120, 0, 28);
	icon.Position = UDim2.new(0, 10, 1, -38);
	icon.BackgroundColor3 = C.WinBg;
	icon.BorderSizePixel = 0;
	icon.Text = "  KaiHub Retro";
	icon.Font = Enum.Font.SourceSansBold;
	icon.TextSize = 11;
	icon.TextColor3 = C.ContentText;
	icon.TextXAlignment = Enum.TextXAlignment.Left;
	icon.ZIndex = 100;
	icon.Parent = self.Gui;
	addBevel(icon, "raised", 2);

	-- 图标小方块
	local smallIcon = Instance.new("Frame");
	smallIcon.Size = UDim2.new(0, 14, 0, 14);
	smallIcon.Position = UDim2.new(0, 4, 0, 7);
	smallIcon.BackgroundColor3 = Color3.fromRGB(100, 160, 255);
	smallIcon.BorderSizePixel = 0;
	smallIcon.ZIndex = 101;
	smallIcon.Parent = icon;
	addBevel(smallIcon, "raised", 1);

	icon.MouseButton1Click:Connect(function()
		self:ToggleMinimize();
	end);

	self.MinimizedIcon = icon;
end;

function RetroUI:_makeDraggable()
	local dragging = false;
	local dragStart, startPos;

	self.TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true;
			dragStart = input.Position;
			startPos = self.Frame.Position;
		end;
	end);

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart;
			self.Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y);
		end;
	end);

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false;
		end;
	end);
end;

-- ========== 标签页 ==========
function RetroUI:AddTab(name)
	local yPos = 22 + (#self.Tabs * 24);

	local btn = Instance.new("TextButton");
	btn.Name = "Tab_" .. name;
	btn.Size = UDim2.new(1, -4, 0, 22);
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

	local indicator = Instance.new("Frame");
	indicator.Size = UDim2.new(0, 3, 1, -2);
	indicator.Position = UDim2.new(0, 0, 0, 1);
	indicator.BackgroundColor3 = C.SidebarActive;
	indicator.BorderSizePixel = 0;
	indicator.Visible = false;
	indicator.ZIndex = 9;
	indicator.Parent = btn;

	local content = Instance.new("Frame");
	content.Name = "TabContent_" .. name;
	content.Size = UDim2.new(1, 0, 1, 0);
	content.BackgroundTransparency = 1;
	content.Visible = false;
	content.ZIndex = 7;
	content.Parent = self.Content;

	local scrollFrame = Instance.new("ScrollingFrame");
	scrollFrame.Size = UDim2.new(1, -8, 1, -8);
	scrollFrame.Position = UDim2.new(0, 4, 0, 4);
	scrollFrame.BackgroundTransparency = 1;
	scrollFrame.BorderSizePixel = 0;
	scrollFrame.ScrollBarThickness = 8;
	scrollFrame.ScrollBarImageColor3 = C.ScrollThumb;
	scrollFrame.ScrollBarBackgroundColor3 = C.ScrollTrack;
	scrollFrame.ZIndex = 8;
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0);
	scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
	scrollFrame.Parent = content;

	local listLayout = Instance.new("UIListLayout");
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder;
	listLayout.Padding = UDim.new(0, 3);
	listLayout.Parent = scrollFrame;

	local tab = {
		Name = name;
		Button = btn;
		Content = content;
		ScrollFrame = scrollFrame;
		ListLayout = listLayout;
		Indicator = indicator;
		Elements = {};
	};

	btn.MouseEnter:Connect(function()
		if self.ActiveTab ~= tab then btn.BackgroundColor3 = C.SidebarHover; end;
	end);
	btn.MouseLeave:Connect(function()
		if self.ActiveTab ~= tab then btn.BackgroundColor3 = C.SidebarBg; end;
	end);
	btn.MouseButton1Click:Connect(function() self:SelectTab(tab); end);

	table.insert(self.Tabs, tab);
	if #self.Tabs == 1 then self:SelectTab(tab); end;
	return tab;
end;

function RetroUI:SelectTab(tab)
	for _, t in ipairs(self.Tabs) do
		t.Content.Visible = false;
		t.Button.BackgroundColor3 = C.SidebarBg;
		t.Button.TextColor3 = C.SidebarText;
		t.Button.Font = Enum.Font.SourceSans;
		t.Indicator.Visible = false;
	end;
	tab.Content.Visible = true;
	tab.Button.BackgroundColor3 = C.SidebarActive;
	tab.Button.TextColor3 = C.SidebarTextActive;
	tab.Button.Font = Enum.Font.SourceSansBold;
	tab.Indicator.Visible = true;
	self.ActiveTab = tab;
	self:SetStatus("标签页: " .. tab.Name);
end;

function RetroUI:SetStatus(text)
	self.StatusText = text;
	if self.StatusLabel then self.StatusLabel.Text = text; end;
end;

-- ========== 控件 ==========
function RetroUI:AddLabel(tab, text)
	local container = Instance.new("Frame");
	container.Size = UDim2.new(1, 0, 0, 22);
	container.BackgroundColor3 = C.LabelBg;
	container.BorderSizePixel = 0;
	container.ZIndex = 8;
	container.Parent = tab.ScrollFrame;
	container.LayoutOrder = #tab.Elements;
	addBevel(container, "sunken", 1);

	local label = Instance.new("TextLabel");
	label.Size = UDim2.new(1, -6, 1, 0);
	label.Position = UDim2.new(0, 4, 0, 0);
	label.BackgroundTransparency = 1;
	label.Text = text;
	label.Font = Enum.Font.SourceSansBold;
	label.TextSize = 11;
	label.TextColor3 = C.ContentText;
	label.TextXAlignment = Enum.TextXAlignment.Left;
	label.ZIndex = 9;
	label.Parent = container;

	table.insert(tab.Elements, container);
	return label;
end;

function RetroUI:AddButton(tab, text, callback)
	local btn = Instance.new("TextButton");
	btn.Size = UDim2.new(1, 0, 0, 26);
	btn.BackgroundColor3 = C.BtnFace;
	btn.BorderSizePixel = 0;
	btn.Text = text;
	btn.Font = Enum.Font.SourceSansBold;
	btn.TextSize = 11;
	btn.TextColor3 = C.ContentText;
	btn.ZIndex = 8;
	btn.Parent = tab.ScrollFrame;
	btn.LayoutOrder = #tab.Elements;
	addBevel(btn, "raised", 2);

	local shadow = Instance.new("TextLabel");
	shadow.Size = UDim2.new(1, 0, 1, 0);
	shadow.Position = UDim2.new(0, 1, 0, 1);
	shadow.BackgroundTransparency = 1;
	shadow.Text = text;
	shadow.Font = Enum.Font.SourceSansBold;
	shadow.TextSize = 11;
	shadow.TextColor3 = C.BevelDark;
	shadow.TextTransparency = 0.6;
	shadow.ZIndex = 9;
	shadow.Parent = btn;

	btn.MouseEnter:Connect(function() btn.BackgroundColor3 = C.BtnHighlight; end);
	btn.MouseLeave:Connect(function() btn.BackgroundColor3 = C.BtnFace; end);
	btn.MouseButton1Click:Connect(function()
		btn.BackgroundColor3 = C.BtnPressed;
		shadow.TextTransparency = 1;
		task.delay(0.15, function()
			btn.BackgroundColor3 = C.BtnFace;
			shadow.TextTransparency = 0.6;
		end);
		if callback then callback(); end;
	end);

	table.insert(tab.Elements, btn);
	return btn;
end;

function RetroUI:AddToggle(tab, text, default, callback)
	default = default or false;
	local container = Instance.new("Frame");
	container.Size = UDim2.new(1, 0, 0, 22);
	container.BackgroundTransparency = 1;
	container.ZIndex = 8;
	container.Parent = tab.ScrollFrame;
	container.LayoutOrder = #tab.Elements;

	local checkbox = Instance.new("TextButton");
	checkbox.Size = UDim2.new(0, 16, 0, 16);
	checkbox.Position = UDim2.new(0, 2, 0, 3);
	checkbox.BackgroundColor3 = C.ContentBg;
	checkbox.BorderSizePixel = 0;
	checkbox.Text = default and "v" or "";
	checkbox.Font = Enum.Font.SourceSansBold;
	checkbox.TextSize = 11;
	checkbox.TextColor3 = C.ContentText;
	checkbox.ZIndex = 10;
	checkbox.Parent = container;
	addBevel(checkbox, "sunken", 1);

	local label = Instance.new("TextLabel");
	label.Size = UDim2.new(1, -28, 1, 0);
	label.Position = UDim2.new(0, 24, 0, 0);
	label.BackgroundTransparency = 1;
	label.Text = text;
	label.Font = Enum.Font.SourceSans;
	label.TextSize = 11;
	label.TextColor3 = C.ContentText;
	label.TextXAlignment = Enum.TextXAlignment.Left;
	label.ZIndex = 9;
	label.Parent = container;

	local state = default;
	checkbox.MouseButton1Click:Connect(function()
		state = not state;
		checkbox.Text = state and "v" or "";
		checkbox.BackgroundColor3 = state and C.ToggleOn or C.ContentBg;
		if callback then callback(state); end;
	end);

	table.insert(tab.Elements, container);
	return checkbox;
end;

function RetroUI:AddTextBox(tab, placeholder, callback)
	local container = Instance.new("Frame");
	container.Size = UDim2.new(1, 0, 0, 24);
	container.BackgroundTransparency = 1;
	container.ZIndex = 8;
	container.Parent = tab.ScrollFrame;
	container.LayoutOrder = #tab.Elements;

	local label = Instance.new("TextLabel");
	label.Size = UDim2.new(0, 70, 1, 0);
	label.Position = UDim2.new(0, 0, 0, 0);
	label.BackgroundTransparency = 1;
	label.Text = placeholder .. ":";
	label.Font = Enum.Font.SourceSans;
	label.TextSize = 11;
	label.TextColor3 = C.ContentText;
	label.TextXAlignment = Enum.TextXAlignment.Left;
	label.ZIndex = 9;
	label.Parent = container;

	local input = Instance.new("TextBox");
	input.Size = UDim2.new(1, -78, 0, 20);
	input.Position = UDim2.new(0, 74, 0, 2);
	input.BackgroundColor3 = C.InputBg;
	input.BorderSizePixel = 0;
	input.Text = "";
	input.PlaceholderText = placeholder;
	input.PlaceholderColor3 = C.ContentTextDim;
	input.Font = Enum.Font.SourceSans;
	input.TextSize = 11;
	input.TextColor3 = C.InputText;
	input.ZIndex = 10;
	input.Parent = container;
	addBevel(input, "sunken", 1);

	if callback then
		input.FocusLost:Connect(function() callback(input.Text); end);
	end;

	table.insert(tab.Elements, container);
	return input;
end;

function RetroUI:AddSlider(tab, text, min, max, default, callback)
	default = default or min;
	local container = Instance.new("Frame");
	container.Size = UDim2.new(1, 0, 0, 32);
	container.BackgroundTransparency = 1;
	container.ZIndex = 8;
	container.Parent = tab.ScrollFrame;
	container.LayoutOrder = #tab.Elements;

	local label = Instance.new("TextLabel");
	label.Size = UDim2.new(1, 0, 0, 14);
	label.BackgroundTransparency = 1;
	label.Text = text .. ": " .. tostring(default);
	label.Font = Enum.Font.SourceSans;
	label.TextSize = 11;
	label.TextColor3 = C.ContentText;
	label.TextXAlignment = Enum.TextXAlignment.Left;
	label.ZIndex = 9;
	label.Parent = container;

	local track = Instance.new("Frame");
	track.Size = UDim2.new(1, -4, 0, 10);
	track.Position = UDim2.new(0, 2, 0, 18);
	track.BackgroundColor3 = C.SliderTrack;
	track.BorderSizePixel = 0;
	track.ZIndex = 9;
	track.Parent = container;
	addBevel(track, "sunken", 1);

	local fill = Instance.new("Frame");
	fill.Size = UDim2.new((default - min) / (max - min), 0, 1, -4);
	fill.Position = UDim2.new(0, 2, 0, 2);
	fill.BackgroundColor3 = C.SliderFill;
	fill.BorderSizePixel = 0;
	fill.ZIndex = 10;
	fill.Parent = track;

	local thumb = Instance.new("TextButton");
	thumb.Size = UDim2.new(0, 10, 0, 18);
	thumb.Position = UDim2.new((default - min) / (max - min), -5, 0.5, -9);
	thumb.BackgroundColor3 = C.SliderThumb;
	thumb.BorderSizePixel = 0;
	thumb.Text = "";
	thumb.ZIndex = 11;
	thumb.Parent = track;
	addBevel(thumb, "raised", 1);

	local sliding = false;
	thumb.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			sliding = true;
		end;
	end);
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			sliding = false;
		end;
	end);
	UserInputService.InputChanged:Connect(function(input)
		if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local relX = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1);
			local value = min + (max - min) * relX;
			value = math.floor(value * 100 + 0.5) / 100;
			fill.Size = UDim2.new(relX, 0, 1, -4);
			thumb.Position = UDim2.new(relX, -5, 0.5, -9);
			label.Text = text .. ": " .. tostring(value);
			if callback then callback(value); end;
		end;
	end);

	table.insert(tab.Elements, container);
	return container;
end;

function RetroUI:AddDropdown(tab, text, options, callback)
	local container = Instance.new("Frame");
	container.Size = UDim2.new(1, 0, 0, 22);
	container.BackgroundTransparency = 1;
	container.ZIndex = 8;
	container.Parent = tab.ScrollFrame;
	container.LayoutOrder = #tab.Elements;

	local btn = Instance.new("TextButton");
	btn.Size = UDim2.new(1, 0, 0, 20);
	btn.Position = UDim2.new(0, 0, 0, 1);
	btn.BackgroundColor3 = C.InputBg;
	btn.BorderSizePixel = 0;
	btn.Text = "  " .. text .. ": " .. (options[1] or "无") .. "  v";
	btn.Font = Enum.Font.SourceSans;
	btn.TextSize = 11;
	btn.TextColor3 = C.InputText;
	btn.TextXAlignment = Enum.TextXAlignment.Left;
	btn.ZIndex = 10;
	btn.Parent = container;
	addBevel(btn, "sunken", 1);

	local isOpen = false;
	local dropFrame = Instance.new("Frame");
	dropFrame.Size = UDim2.new(1, 0, 0, math.min(#options * 20, 200));
	dropFrame.Position = UDim2.new(0, 0, 0, 22);
	dropFrame.BackgroundColor3 = C.DropdownBg;
	dropFrame.BorderSizePixel = 0;
	dropFrame.Visible = false;
	dropFrame.ZIndex = 20;
	dropFrame.ClipsDescendants = true;
	dropFrame.Parent = container;
	addBevel(dropFrame, "raised", 2);

	for i, opt in ipairs(options) do
		local optBtn = Instance.new("TextButton");
		optBtn.Size = UDim2.new(1, -4, 0, 20);
		optBtn.Position = UDim2.new(0, 2, 0, (i-1) * 20);
		optBtn.BackgroundColor3 = C.DropdownBg;
		optBtn.BorderSizePixel = 0;
		optBtn.Text = "  " .. opt;
		optBtn.Font = Enum.Font.SourceSans;
		optBtn.TextSize = 11;
		optBtn.TextColor3 = C.ContentText;
		optBtn.TextXAlignment = Enum.TextXAlignment.Left;
		optBtn.ZIndex = 21;
		optBtn.Parent = dropFrame;
		optBtn.MouseEnter:Connect(function()
			optBtn.BackgroundColor3 = C.DropdownHover;
			optBtn.TextColor3 = C.DropdownHoverText;
		end);
		optBtn.MouseLeave:Connect(function()
			optBtn.BackgroundColor3 = C.DropdownBg;
			optBtn.TextColor3 = C.ContentText;
		end);
		optBtn.MouseButton1Click:Connect(function()
			btn.Text = "  " .. text .. ": " .. opt .. "  v";
			dropFrame.Visible = false;
			isOpen = false;
			if callback then callback(opt); end;
		end);
	end;

	btn.MouseButton1Click:Connect(function()
		isOpen = not isOpen;
		dropFrame.Visible = isOpen;
	end);

	table.insert(tab.Elements, container);
	return container;
end;

function RetroUI:AddSeparator(tab)
	local sep = Instance.new("Frame");
	sep.Size = UDim2.new(1, 0, 0, 2);
	sep.BackgroundColor3 = C.Separator;
	sep.BorderSizePixel = 0;
	sep.ZIndex = 8;
	sep.Parent = tab.ScrollFrame;
	sep.LayoutOrder = #tab.Elements;

	local sepLight = Instance.new("Frame");
	sepLight.Size = UDim2.new(1, 0, 0, 1);
	sepLight.BackgroundColor3 = C.BevelLight;
	sepLight.BorderSizePixel = 0;
	sepLight.ZIndex = 9;
	sepLight.Parent = sep;

	table.insert(tab.Elements, sep);
	return sep;
end;

function RetroUI:Destroy()
	for _, conn in ipairs(self.Connections) do conn:Disconnect(); end;
	if self.Gui then self.Gui:Destroy(); end;
end;

-- ============================================================
-- 创建 UI 实例
-- ============================================================
local ui = RetroUI.new({Name="KaiHub Retro", Subtitle="v6.0"});

-- ========== 基础设置标签页 ==========
local basicTab = ui:AddTab("基础设置");
ui:AddLabel(basicTab, "基础数据修改");
ui:AddSlider(basicTab, "玩家移速", 0, 1000, data['basicdata']['player']['speed'], function(v)
	LocalPlayer.Character.Humanoid.WalkSpeed = v;
	data['basicdata']['player']['speed'] = v;
end);
ui:AddToggle(basicTab, "锁定玩家移速", false, function(v)
	data['basicdata']['player']['islockspeed'] = v;
end);
ui:AddSlider(basicTab, "跳跃力量", 0, 1000, data['basicdata']['player']['jump'], function(v)
	LocalPlayer.Character.Humanoid.JumpPower = v;
	data['basicdata']['player']['jump'] = v;
end);
ui:AddToggle(basicTab, "锁定跳跃力量", false, function(v)
	data['basicdata']['player']['islockjump'] = v;
end);
ui:AddSlider(basicTab, "最大血量", 0, 1000, data['basicdata']['player']['maxhealth'], function(v)
	LocalPlayer.Character.Humanoid.MaxHealth = v;
	data['basicdata']['player']['maxhealth'] = v;
end);
ui:AddToggle(basicTab, "锁定最大血量", false, function(v)
	data['basicdata']['player']['islockmaxhealth'] = v;
end);
ui:AddSlider(basicTab, "当前血量", 0, 1000, data['basicdata']['player']['health'], function(v)
	LocalPlayer.Character.Humanoid.Health = v;
	data['basicdata']['player']['health'] = v;
end);
ui:AddToggle(basicTab, "锁定当前血量", false, function(v)
	data['basicdata']['player']['islockhealth'] = v;
end);
ui:AddSlider(basicTab, "世界重力", 0, 1000, data['basicdata']['player']['gravity'], function(v)
	Workspace.Gravity = v;
	data['basicdata']['player']['gravity'] = v;
end);
ui:AddToggle(basicTab, "锁定世界重力", false, function(v)
	data['basicdata']['player']['islockgravity'] = v;
end);

-- ========== 工具标签页 ==========
local toolsTab = ui:AddTab("工具");
ui:AddLabel(toolsTab, "各种实用工具");
ui:AddToggle(toolsTab, "防挂机", true, function(v)
	data['basicdata']['releasetools']['antiafk'] = v;
end);
ui:AddToggle(toolsTab, "保留Hub - 传送后自动执行", false, function(v)
	data['basicdata']['releasetools']['keepchronixhub'] = v;
end);
ui:AddToggle(toolsTab, "飞行", false, function(v)
	if v then FlyModule.enable(); else FlyModule.disable(); end;
end);
ui:AddToggle(toolsTab, "点击传送", false, function(v)
	if v then TeleportModule.enable(); else TeleportModule.disable(); end;
end);
ui:AddToggle(toolsTab, "玩家透视", false, function(v)
	if v then PlayerESP.enable(); else PlayerESP.disable(); end;
end);
ui:AddToggle(toolsTab, "NPC透视", false, function(v)
	if v then data['basicdata']['releasetools']['npc']:enable(); else data['basicdata']['releasetools']['npc']:disable(); end;
end);
ui:AddToggle(toolsTab, "TPWalk", false, function(v)
	tpWalk:Enabled(v);
end);
ui:AddToggle(toolsTab, "鼠标解锁", false, function(v)
	if v then MouseUnlockModule.Enable(); else MouseUnlockModule.Disable(); end;
end);
ui:AddToggle(toolsTab, "锁定视角", false, function(v)
	if v then LockCameraModule.enable(); else LockCameraModule.disable(); end;
end);
ui:AddToggle(toolsTab, "自动瞄准", false, function(v)
	if v then AimBotModule.Enable(); else AimBotModule.Disable(); end;
end);
ui:AddToggle(toolsTab, "物品滚轮切换", false, function(v)
	if v then ScrollSwitch:enable(); else ScrollSwitch:disable(); end;
end);
ui:AddToggle(toolsTab, "望远镜", false, function(v)
	if v then data['basicdata']['releasetools']['zoom']:Enable(); else data['basicdata']['releasetools']['zoom']:Disable(); end;
end);
ui:AddToggle(toolsTab, "隐身", false, function(v)
	if v then PlayerVisibleModule.enable(); else PlayerVisibleModule.disable(); end;
end);
ui:AddToggle(toolsTab, "查看落脚点", false, function(v)
	if v then FootstepHighlighter.enable(); else FootstepHighlighter.disable(); end;
end);
ui:AddToggle(toolsTab, "落地特效", false, function(v)
	if v then LandingEffect.enable(); else LandingEffect.disable(); end;
end);
ui:AddToggle(toolsTab, "夜视", false, function(v)
	data['basicdata']['releasetools']['nightvision'] = v;
	game.Lighting.Ambient = v and Color3.new(1, 1, 1) or Color3.new(0, 0, 0);
end);
ui:AddToggle(toolsTab, "超级夜视", false, function(v)
	data['basicdata']['releasetools']['supernightvision'] = v;
	if v then
		data['basicdata']['releasetools']['originalBrightness'] = Lighting.Brightness;
		data['basicdata']['releasetools']['originalExposureCompensation'] = Lighting.ExposureCompensation;
		Lighting.Brightness = 2;
		Lighting.ExposureCompensation = 2.5;
	else
		Lighting.Brightness = data['basicdata']['releasetools']['originalBrightness'];
		Lighting.ExposureCompensation = data['basicdata']['releasetools']['originalExposureCompensation'];
	end;
end);
ui:AddToggle(toolsTab, "随身灯笼", false, function(v)
	data['basicdata']['releasetools']['Lantern']['enable'] = v;
end);
ui:AddToggle(toolsTab, "超级光明", false, function(v)
	data['basicdata']['releasetools']['SuperLighter']['enable'] = v;
end);
ui:AddToggle(toolsTab, "雾气去除", false, function(v)
	if v then RemoveFog(); else RestoreFog(); end;
end);

local xrayLoop;
ui:AddToggle(toolsTab, "X光", false, function(v)
	data['basicdata']['releasetools']['xray'] = v;
	if v then
		pcall(function() xrayLoop:Disconnect(); end);
		xrayLoop = RunService.RenderStepped:Connect(function()
			xray(data['basicdata']['releasetools']['xray']);
			task.wait(1);
		end);
	else
		pcall(function() xrayLoop:Disconnect(); end);
		xray(false);
	end;
end);

ui:AddToggle(toolsTab, "显示隐藏部件", false, function(v)
	showpartsfunction(v);
end);
ui:AddToggle(toolsTab, "灵魂出窍", false, function(v)
	FreecamModule.freecamenable = v;
end);
ui:AddToggle(toolsTab, "平移", false, function(v)
	if v then movementModule.Enable(); else movementModule.Disable(); end;
end);
ui:AddToggle(toolsTab, "空中移动", false, function(v)
	if v then AirWalk.enable(); else AirWalk.disable(); end;
end);
ui:AddToggle(toolsTab, "瞬间交互", false, function(v)
	if v then InstantInteraction.enable(); else InstantInteraction.disable(); end;
end);

local Stepped;
ui:AddToggle(toolsTab, "穿墙", false, function(v)
	data['basicdata']['releasetools']['noclip'] = v;
	Stepped = RunService.Stepped:Connect(function()
		if data['basicdata']['releasetools']['noclip'] then
			for a, b in pairs(Workspace:GetChildren()) do
				if (b.Name == LocalPlayer.Name) then
					for i, v in pairs(Workspace[LocalPlayer.Name]:GetChildren()) do
						if v:IsA("BasePart") then v.CanCollide = false; end;
					end;
				end;
			end;
		else
			for a, b in pairs(Workspace:GetChildren()) do
				if (b.Name == LocalPlayer.Name) then
					for i, v in pairs(Workspace[LocalPlayer.Name]:GetChildren()) do
						if v:IsA("BasePart") then v.CanCollide = true; end;
					end;
				end;
			end;
			Stepped:Disconnect();
		end;
	end);
end);

local JR;
ui:AddToggle(toolsTab, "连跳", false, function(v)
	data['basicdata']['releasetools']['infjump'] = v;
	JR = UserInputService.JumpRequest:Connect(function()
		if not data['basicdata']['releasetools']['infjump'] then JR:Disconnect(); end;
		if data['basicdata']['releasetools']['infjump'] then
			local c = LocalPlayer.Character;
			if (c and c.Parent) then
				local hum = c:FindFirstChildOfClass("Humanoid");
				if hum then hum:ChangeState("Jumping"); end;
			end;
		end;
	end);
end);

ui:AddToggle(toolsTab, "旁观模式", false, function(v)
	if v then SpectatorModule.start(); else SpectatorModule.close(); end;
end);
ui:AddToggle(toolsTab, "防击倒", false, function(v)
	data['basicdata']['releasetools']['antifall'] = v;
end);
ui:AddToggle(toolsTab, "晕厥康复", false, function(v)
	if v then StandRecovery:enableDetection(); else StandRecovery:disableDetection(); end;
end);
ui:AddToggle(toolsTab, "防甩飞", false, function(v)
	if v then FlingDetector.enable(LocalPlayer); else FlingDetector.disable(); end;
end);
ui:AddToggle(toolsTab, "反物理劫持", false, function(v)
	if v then AntiVoidModule.enable(); else AntiVoidModule.disable(); end;
end);
ui:AddToggle(toolsTab, "管理员检测", false, function(v)
	data['basicdata']['releasetools']['staffcheck'] = v;
end);
ui:AddToggle(toolsTab, "防死亡", false, function(v)
	data['basicdata']['releasetools']['antidead'] = v;
	if not v then LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true); end;
end);
ui:AddToggle(toolsTab, "聊天重发", false, function(v)
	data['basicdata']['releasetools']['chatresend'] = v;
end);

ui:AddLabel(toolsTab, "强制发言");
local forceMsg = "";
ui:AddTextBox(toolsTab, "消息内容", function(value) forceMsg = value; end);
ui:AddButton(toolsTab, "发送消息", function()
	if (forceMsg and (#forceMsg > 0)) then
		pcall(function() ChatControl:chat(forceMsg); end);
	end;
end);
ui:AddToggle(toolsTab, "聊天偷听", false, function(v)
	if v then ChatSpy.enable(); else ChatSpy.disable(); end;
end);
ui:AddToggle(toolsTab, "坐下", false, function(v)
	LocalPlayer.Character:FindFirstChild("Humanoid").Sit = v;
end);
ui:AddToggle(toolsTab, "防踢出", false, function(v)
	if v then AntiKickModule.enable(); else AntiKickModule.disable(); end;
end);
ui:AddToggle(toolsTab, "模型删除工具", false, function(v)
	if v then DeleteTool.enable(); else DeleteTool.disable(); end;
end);
ui:AddToggle(toolsTab, "GUI删除工具", false, function(v)
	if v then GuiDeleter.enable(); else GuiDeleter.disable(); end;
end);
ui:AddToggle(toolsTab, "禁用购买提示框", false, function(v)
	CoreGui.PurchasePromptApp.Enabled = not v;
end);
ui:AddToggle(toolsTab, "禁用游戏暂停", false, function(v)
	data['basicdata']['releasetools']['networkpausedisable'] = v;
end);

ui:AddButton(toolsTab, "回满血", function()
	LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth;
end);
ui:AddButton(toolsTab, "自杀", function()
	LocalPlayer.Character.Humanoid.Health = 0;
end);
ui:AddButton(toolsTab, "强制自杀", function() respawn(); end);
ui:AddButton(toolsTab, "原地重生", function() refresh(); end);
ui:AddButton(toolsTab, "获得点击传送工具", function()
	local mouse = LocalPlayer:GetMouse();
	local tool = Instance.new("Tool");
	tool.RequiresHandle = false;
	tool.Name = "手持点击传送";
	tool.Activated:connect(function()
		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit + Vector3.new(0, 2.5, 0));
	end);
	tool.Parent = LocalPlayer.Backpack;
end);
ui:AddButton(toolsTab, "重新加入当前房间", function() rejoinCurrentGame(); end);
ui:AddButton(toolsTab, "切换角色为R6", function() promptNewRig("R6"); end);
ui:AddButton(toolsTab, "切换角色为R15", function() promptNewRig("R15"); end);
ui:AddButton(toolsTab, "切换时间为白天", function() setDay(); end);
ui:AddButton(toolsTab, "切换时间为黑夜", function() setNight(); end);
ui:AddButton(toolsTab, "优化世界光效", function()
	loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/ChronixHub/raw/main/modules/WorldShader.lua"))();
end);
ui:AddButton(toolsTab, "打印当前玩家坐标", function()
	local position1 = LocalPlayer.Character.HumanoidRootPart.Position;
	print(string.format("[KaiHub] 玩家坐标: (%.2f, %.2f, %.2f)", position1.X, position1.Y, position1.Z));
end);
ui:AddButton(toolsTab, "开启控制台界面", function()
	StarterGui:SetCore("DevConsoleVisible", true);
end);
ui:AddButton(toolsTab, "启用所有ROBLOXUI", function()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true);
end);
ui:AddButton(toolsTab, "获取建筑工具", function()
	for i = 1, 4 do
		local Tool = Instance.new("HopperBin");
		Tool.BinType = i;
		Tool.Name = randomString();
		Tool.Parent = LocalPlayer:FindFirstChildWhichIsA("Backpack");
	end;
end);
ui:AddButton(toolsTab, "终止当前游戏进程", function()
	game:Shutdown();
end);

-- ========== 玩家传送标签页 ==========
local playerTpTab = ui:AddTab("玩家传送");
ui:AddLabel(playerTpTab, "玩家列表");
local playerButtons = {};
local function updatePlayerList()
	for playerName, button in pairs(playerButtons) do
		if (button and button.Destroy) then button:Destroy(); end;
	end;
	playerButtons = {};
	for _, player in ipairs(Players:GetPlayers()) do
		if (player ~= LocalPlayer) then
			local btn = ui:AddButton(playerTpTab, player.DisplayName .. " (" .. player.Name .. ")", function()
				local character = LocalPlayer.Character;
				if (character and character:FindFirstChild("HumanoidRootPart")) then
					local targetCharacter = player.Character;
					if (targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")) then
						character:SetPrimaryPartCFrame(CFrame.new(targetCharacter.HumanoidRootPart.Position));
					end;
				end;
			end);
			playerButtons[player.Name] = btn;
		end;
	end;
end;
updatePlayerList();

-- ========== 脚本中心标签页 ==========
local scriptTab = ui:AddTab("脚本中心");
ui:AddLabel(scriptTab, "由作者推荐的脚本");
local scripts = {
	{name="Infinite Yield", url="https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source"},
	{name="Dex Explorer", url="https://raw.githubusercontent.com/Babyhamsta/RBLX_DEX/main/out/dex.lua"},
	{name="Remote Spy", url="https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"}
};
for _, scriptInfo in ipairs(scripts) do
	ui:AddButton(scriptTab, scriptInfo.name, function()
		pcall(function() loadstring(game:HttpGet(scriptInfo.url))(); end);
	end);
end;

-- ========== 音乐播放器标签页 ==========
local musicTab = ui:AddTab("音乐播放器");
ui:AddLabel(musicTab, "音乐播放器");
ui:AddDropdown(musicTab, "预设音乐ID", data['basicdata']['otherdata']['musicData']['musicIds'], function(selected)
	data['basicdata']['otherdata']['musicData']['currentId'] = selected;
end);
ui:AddTextBox(musicTab, "自定义音乐ID", function(text)
	if (text and (text ~= "")) then data['basicdata']['otherdata']['musicData']['currentId'] = text; end;
end);
ui:AddButton(musicTab, "播放/停止", function()
	if data['basicdata']['otherdata']['musicData']['isPlay'] then
		data['basicdata']['otherdata']['musicbox']:Stop();
		data['basicdata']['otherdata']['musicData']['isPlay'] = false;
	else
		data['basicdata']['otherdata']['musicbox']['SoundId'] = "rbxassetid://" .. data['basicdata']['otherdata']['musicData']['currentId'];
		data['basicdata']['otherdata']['musicbox']:Play();
		data['basicdata']['otherdata']['musicData']['isPlay'] = true;
	end;
end);
ui:AddButton(musicTab, "循环切换", function()
	data['basicdata']['otherdata']['musicbox']['Looped'] = not data['basicdata']['otherdata']['musicbox']['Looped'];
end);
ui:AddSlider(musicTab, "音量", 0, 1, data['basicdata']['otherdata']['musicbox']['Volume'], function(v)
	data['basicdata']['otherdata']['musicbox']['Volume'] = v;
end);

-- ========== 执行器标签页 ==========
local execTab = ui:AddTab("执行器");
ui:AddLabel(execTab, "执行器");
local execCode = "";
ui:AddTextBox(execTab, "请输入代码", function(text) execCode = text; end);
ui:AddButton(execTab, "执行", function()
	if (execCode and (execCode ~= "")) then
		local success, errorMessage = pcall(function() loadstring(execCode)(); end);
		if not success then warn("执行失败: " .. errorMessage); end;
	end;
end);

-- ========== 关于标签页 ==========
local infoTab = ui:AddTab("关于");
ui:AddLabel(infoTab, "关于 KaiHub Retro");
ui:AddLabel(infoTab, "KaiHub Retro - 基于早期Roblox风格UI");
ui:AddLabel(infoTab, "开发者: Furrycalin");
ui:AddLabel(infoTab, "版本: v6.0");
ui:AddSeparator(infoTab);
ui:AddLabel(infoTab, "启动次数: " .. launchCount);
local pingLabel = ui:AddLabel(infoTab, "网络延迟: " .. math.round(LocalPlayer:GetNetworkPing() * 1000) .. "ms");
local memLabel = ui:AddLabel(infoTab, string.format("内存占用: %.2f MB", getMemoryUsage("MB")));
ui:AddButton(infoTab, "强制垃圾回收", function()
	collectgarbage("collect");
end);

-- ========== 恶劣功能标签页 ==========
local hankerTab = ui:AddTab("恶劣功能");
ui:AddLabel(hankerTab, "使用此部分的功能会导致封号");
ui:AddToggle(hankerTab, "循环OOF", false, function(v)
	if v then LoopOofModule.enable(); else LoopOofModule.disable(); end;
end);
ui:AddTextBox(hankerTab, "旋转速度", function(text)
	data['basicdata_hankermodule']['spin']['speed'] = tonumber(text) or 20;
end);
ui:AddToggle(hankerTab, "开始旋转", false, function(v)
	if v then SpinModule.enable(data['basicdata_hankermodule']['spin']['speed']); else SpinModule.disable(); end;
end);
ui:AddToggle(hankerTab, "旋转击飞", false, function(v)
	if v then FlingModule.fling.enable(); else FlingModule.fling.disable(); end;
end);
ui:AddToggle(hankerTab, "飞行击飞", false, function(v)
	if v then FlingModule.flyfling.enable(2); else FlingModule.flyfling.disable(); end;
end);
ui:AddToggle(hankerTab, "走路击飞", false, function(v)
	if v then FlingModule.walkfling.enable(); else FlingModule.walkfling.disable(); end;
end);
ui:AddToggle(hankerTab, "隐身击飞", false, function(v)
	if v then FlingModule.invisfling.enable(); else FlingModule.invisfling.disable(); end;
end);
ui:AddTextBox(hankerTab, "要击杀的玩家名", function(text)
	data['basicdata_hankermodule']['hkill']['killname'] = text;
end);
ui:AddTextBox(hankerTab, "距离", function(text)
	data['basicdata_hankermodule']['hkill']['killrange'] = tonumber(text) or 100;
end);
ui:AddToggle(hankerTab, "全部玩家", false, function(v)
	data['basicdata_hankermodule']['hkill']['killall'] = v;
end);
ui:AddToggle(hankerTab, "全图", false, function(v)
	data['basicdata_hankermodule']['hkill']['killany'] = v;
end);
ui:AddButton(hankerTab, "开始击杀", function()
	HandleKillModule.kill(
		(data['basicdata_hankermodule']['hkill']['killall'] and "All") or data['basicdata_hankermodule']['hkill']['killname'],
		(data['basicdata_hankermodule']['hkill']['killany'] and "Infinity") or data['basicdata_hankermodule']['hkill']['killrange']
	);
end);

-- ========== 支持的游戏标签页 ==========
local gamesTab = ui:AddTab("支持的游戏");
ui:AddLabel(gamesTab, "支持的游戏");
for _, GetgameInfo in ipairs(data['Supported_Games']) do
	if GetgameInfo.gameid then
		ui:AddButton(gamesTab, GetgameInfo.name, function()
			if (game.GameId == GetgameInfo.gameid) then
				print("你已经在这个游戏里了。");
			else
				GameTeleport.teleportByGameId(GetgameInfo.gameid);
			end;
		end);
	end;
end;

-- ========== 设置标签页 ==========
local settingsTab = ui:AddTab("设置");
ui:AddLabel(settingsTab, "设置");
ui:AddTextBox(settingsTab, "飞行速度", function(text)
	local num = tonumber(text);
	if num then FlyModule.setflyspeed(num); end;
end);
ui:AddTextBox(settingsTab, "TPWalk距离", function(text)
	local num = tonumber(text);
	if num then tpWalk:SetSpeed(num); end;
end);
ui:AddTextBox(settingsTab, "平移距离", function(text)
	local num = tonumber(text);
	if num then movementModule.SetDistance(num); end;
end);

-- ============================================================
-- 后台连接和事件处理
-- ============================================================
local connections = {};
local humanoidConnections = {};

local function disconnectHumanoidConnections()
	for _, connection in pairs(humanoidConnections) do
		if (connection and connection.Connected) then connection:Disconnect(); end;
	end;
	humanoidConnections = {};
end;

local function setupHumanoidListeners(humanoid)
	disconnectHumanoidConnections();
	humanoidConnections.walkSpeed = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if data['basicdata']['player']['islockspeed'] then humanoid.WalkSpeed = data['basicdata']['player']['speed']; end;
	end);
	humanoidConnections.jumpPower = humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
		if data['basicdata']['player']['islockjump'] then humanoid.JumpPower = data['basicdata']['player']['jump']; end;
	end);
	humanoidConnections.health = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
		if data['basicdata']['player']['islockhealth'] then humanoid.Health = data['basicdata']['player']['health']; end;
	end);
	humanoidConnections.maxHealth = humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(function()
		if data['basicdata']['player']['islockmaxhealth'] then humanoid.MaxHealth = data['basicdata']['player']['maxhealth']; end;
	end);
	humanoidConnections.forceUpdates = RunService.Heartbeat:Connect(function()
		if data['basicdata']['player']['islockspeed'] and (humanoid.WalkSpeed ~= data['basicdata']['player']['speed']) then
			humanoid.WalkSpeed = data['basicdata']['player']['speed'];
		end;
		if data['basicdata']['player']['islockjump'] and (humanoid.JumpPower ~= data['basicdata']['player']['jump']) then
			humanoid.JumpPower = data['basicdata']['player']['jump'];
		end;
		if data['basicdata']['player']['islockhealth'] and (humanoid.Health ~= data['basicdata']['player']['health']) then
			humanoid.Health = data['basicdata']['player']['health'];
		end;
		if data['basicdata']['player']['islockmaxhealth'] and (humanoid.MaxHealth ~= data['basicdata']['player']['maxhealth']) then
			humanoid.MaxHealth = data['basicdata']['player']['maxhealth'];
		end;
	end);
	humanoidConnections.hscc = humanoid.StateChanged:Connect(function(oldState, newState)
		if data['basicdata']['releasetools']['antifall'] then
			if ((newState == Enum.HumanoidStateType.FallingDown) or (newState == Enum.HumanoidStateType.Ragdoll) or (newState == Enum.HumanoidStateType.Freefall)) then
				humanoid:ChangeState(Enum.HumanoidStateType.GettingUp);
			end;
		end;
	end);
end;

local function checkAndSetupHumanoid(character)
	if not character then return; end;
	local humanoid = character:FindFirstChildOfClass("Humanoid");
	if humanoid then
		setupHumanoidListeners(humanoid);
	else
		local childAddedConnection;
		childAddedConnection = character.ChildAdded:Connect(function(child)
			if child:IsA("Humanoid") then
				task.wait(0.1);
				setupHumanoidListeners(child);
				if childAddedConnection then childAddedConnection:Disconnect(); end;
			end;
		end);
	end;
end;

connections.characterChildRemoved = LocalPlayer.CharacterRemoving:Connect(function(oldCharacter)
	disconnectHumanoidConnections();
end);
connections.characterAdded = LocalPlayer.CharacterAdded:Connect(function(newCharacter)
	newCharacter:WaitForChild("HumanoidRootPart");
	checkAndSetupHumanoid(newCharacter);
end);
if LocalPlayer.Character then
	LocalPlayer.Character:WaitForChild("HumanoidRootPart");
	checkAndSetupHumanoid(LocalPlayer.Character);
end;

-- 防挂机
local AntiAFK = LocalPlayer.Idled:connect(function()
	if data['basicdata']['releasetools']['antiafk'] then
		VirtualUser:CaptureController();
		VirtualUser:ClickButton2(Vector2.new());
	end;
end);

-- 网络暂停禁用
local networkPaused = CoreGui.RobloxGui.ChildAdded:Connect(function(obj)
	if ((obj.Name == "CoreScripts/NetworkPause") and data['basicdata']['releasetools']['networkpausedisable']) then
		obj:Destroy();
	end;
end);

-- 传送保持
local TeleportCheck = false;
local keepchronixhubconnect = LocalPlayer.OnTeleport:Connect(function(State)
	if (data['basicdata']['releasetools']['keepchronixhub'] and not TeleportCheck) then
		TeleportCheck = true;
		local teleportCode = [[
            if not game:IsLoaded() then game.Loaded:Wait() end
            loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/mainv3.lua"))()
        ]];
		if queueteleport then queueteleport(teleportCode);
		elseif queueonteleport then queueonteleport(teleportCode);
		elseif queue_on_teleport then queue_on_teleport(teleportCode); end;
	end;
end);

-- 主循环
local lastTime = 0;
local RunStepped = RunService.Stepped:Connect(function()
	if data['basicdata']['releasetools']['nightvision'] then
		game.Lighting.Ambient = Color3.new(1, 1, 1);
	end;
	if data['basicdata']['releasetools']['supernightvision'] then
		Lighting.Brightness = 2;
		Lighting.ExposureCompensation = 2.5;
	end;
	if data['basicdata']['player']['islockgravity'] then
		Workspace.Gravity = data['basicdata']['player']['gravity'];
	end;
	if data['basicdata']['releasetools']['antidead'] then
		LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false);
	end;
	local now = tick();
	if ((now - lastTime) >= 1) then
		lastTime = now;
		pcall(function()
			memLabel.Text = string.format("内存占用: %.2f MB", getMemoryUsage("MB"));
			pingLabel.Text = "网络延迟: " .. math.round(LocalPlayer:GetNetworkPing() * 1000) .. "ms";
		end);
	end;
end);

-- 玩家列表更新
local pac = Players.PlayerAdded:Connect(updatePlayerList);
local prc = Players.PlayerRemoving:Connect(updatePlayerList);

-- ============================================================
-- 卸载函数
-- ============================================================
function unloadKaiHubRetro()
	_G.KaiHubRetroLoaded = false;
	_G.KaiHubRetroLoading = false;
	loadingTimedOut = true;
	data['basicdata']['releasetools']['noclip'] = false;
	data['basicdata']['releasetools']['infjump'] = false;
	if data['basicdata']['releasetools']['supernightvision'] then
		Lighting.Brightness = data['basicdata']['releasetools']['originalBrightness'];
	end;
	if data['basicdata']['releasetools']['nightvision'] then
		game.Lighting.Ambient = Color3.new(0, 0, 0);
	end;
	data['basicdata']['otherdata']['musicbox']:Stop();
	data['basicdata']['otherdata']['testSound']:Stop();
	pcall(function()
		if xrayLoop then xrayLoop:Disconnect(); xray(false); end;
	end);
	tpWalk:unload();
	StandRecovery:unload();
	HighlightModule.unload();
	PlayerLightModule:unloadAll();
	SpectatorModule.unload();
	FreecamModule.unload();
	LandingEffect.unload();
	NameTagModule.unload();
	PlayerVisibleModule.unload();
	movementModule.Unload();
	MouseUnlockModule.unload();
	data['basicdata']['releasetools']['zoom']:Unload();
	FlingDetector.unload();
	PlayerESP.unload();
	MovableHighlighter_NM.unloadAll();
	AntiVoidModule.unload();
	ChatSpy.unload();
	ChatControl:unload();
	AirWalk.unload();
	LockCameraModule.unload();
	data['basicdata']['releasetools']['npc']:unload();
	ChatTagModule.unload();
	FlyModule.unload();
	ScrollSwitch:unload();
	Regretevator_AutoIceCream:unload();
	InstantInteraction.unload();
	AimBotModule.Unload();
	DeleteTool.unload();
	GuiDeleter.unload();
	AntiKickModule.unload();
	HandleKillModule.unload();
	FlingModule.unload();
	LoopOofModule.unload();
	SpinModule.unload();
	FootstepHighlighter.unload();
	TeleportModule.unload();
	if prc then prc:Disconnect(); end;
	if pac then pac:Disconnect(); end;
	if RunStepped then RunStepped:Disconnect(); end;
	if JR then JR:Disconnect(); end;
	if AntiAFK then AntiAFK:Disconnect(); end;
	if keepchronixhubconnect then keepchronixhubconnect:Disconnect(); end;
	if networkPaused then networkPaused:Disconnect(); end;
	for _, connection in pairs(connections) do
		if (connection and connection.Connected) then connection:Disconnect(); end;
	end;
	disconnectHumanoidConnections();
	ui:Destroy();
	LogService:Info("[KaiHub Retro] 已成功卸载。");
end;

-- 设置关闭回调
-- 注意：关闭按钮直接调用 ui:Destroy()，这里我们重写关闭逻辑
-- 由于RetroUI的关闭按钮直接销毁，我们需要修改它

local loadTime = string.format("%.2f", tick() - startTime);
LogService:Info("[KaiHub Retro] 已成功加载。用时: " .. loadTime .. "s");
_G.KaiHubRetroLoaded = true;
_G.KaiHubRetroLoading = false;
loadingTimedOut = true;

return ui;
