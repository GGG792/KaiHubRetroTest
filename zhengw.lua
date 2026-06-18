if not game:IsLoaded() then
	game.Loaded:Wait();
end
local cloneref = cloneref or clonereference or function(obj)
	return obj;
end;
if _G.ChronixHubisLoaded then
	warn("[ChronixHub] ⛔ ChronixHub 已经加载了！请不要重复执行。");
	return;
end
if _G.ChronixHubLoading then
	warn("[ChronixHub] ⏳ 脚本正在加载中，请勿频繁执行！");
	return;
else
	_G.ChronixHubLoading = true;
end
local startTime = tick();
local loadingTimedOut = false;
task.spawn(function()
	task.wait(60);
	if not loadingTimedOut then
		_G.ChronixHubLoading = false;
		cloneref(game:GetService("StarterGui")):SetCore("SendNotification", {Title="ChronixHub",Text="加载超时，请重试",Duration=5});
		cloneref(game.LogService):Info("[ChronixHub] 加载超时，请重试。");
	end
end);
cloneref(game.LogService):Info("[ChronixHub] 已开启初始化进程。");
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
local AsyncFileFetcher = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/AsyncFileFetcher.lua"))();
local modulesToFetch = {ChronixUI="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/ChronixUI%20Lib.lua",tpWalk="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/SafeTPWalk.lua",StandRecovery="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/StandRecovery.lua",HighlightModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/HighlightModule.lua",PlayerLightModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/PlayerLightModule.lua",SpectatorModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/SpectatorModule.lua",FreecamModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/FreecamModule.lua",LandingEffect="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/LandingEffect.lua",NameTagModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/NameTagModule.lua",PlayerVisibleModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/PlayerVisibleModule.lua",movementModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/MovementModule.lua",MouseUnlockModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/MouseUnlockModule.lua",DeathballScripts="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/DeathBallScripts.lua",ZoomModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/ZoomModule.lua",FlingDetector="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/FlingDetector.lua",SystemNotification="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/SystemNotification.lua",PlayerESP="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/PlayerESP.lua",MovableHighlighter_NM="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/MovableHighlighter-NM.lua",GameTeleport="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/GameTeleport.lua",AntiVoidModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/AntiVoid.lua",ChatSpy="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/ChatSpy.lua",ChatControl="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/ChatControl.lua",AirWalk="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/AirWalk.lua",LockCameraModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/LockCameraModule.lua",OBOTeleportModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/OBOTeleportModule.lua",NPCHighLighter="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/NPC_Highlighter.lua",ChatTagModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/ChatTagModule.lua",FlyModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/FlyModule.lua",ScrollSwitch="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/ScrollSwitch.lua",Regretevator_AutoIceCream="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/Regretevator_AutoIceCream.lua",InstantInteraction="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/InstantInteraction.lua",UNCTestModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/uncAndwuncget.lua",ServerFinderModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/ServerFinderModule.lua",AimBotModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/AimBotModule.lua",DeleteTool="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/DeleteTool.lua",GuiDeleter="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/GuiDeleter.lua",AntiKickModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/AntiKick.lua",HandleKillModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/HandleKillModule.lua",FlingModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/FlingModule.lua",LoopOofModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/LoopOofModule.lua",SpinModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/SpinModule.lua",ConfigModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/ConfigModule.lua",FootstepHighlighter="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/FootstepHighlighter.lua",TeleportModule="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/TeleportModule.lua",WebSocketManager="https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/WebSocketManager.lua"};
for moduleName, content in pairs(AsyncFileFetcher.fetchMultiple(modulesToFetch)) do
	if (content and (type(content) == "string") and (content ~= "")) then
		local success, result = pcall(loadstring, content);
		if (success and result) then
			(_ENV or getfenv())[moduleName] = result();
		else
			warn("模块加载失败: " .. moduleName);
		end
	end
end
local unloadChronixHub;
ConfigModule.setmain("ChronixHubConfig");
local data = {basicdata={window={windowSize=((UserInputService.TouchEnabled and not UserInputService.MouseEnabled and UDim2.new(0, 476, 0, 294)) or UDim2.new(0, 680, 0, 420))},player={name=LocalPlayer.Name,displayname=LocalPlayer.DisplayName,userid=LocalPlayer.UserId,isPremium=(LocalPlayer.MembershipType == Enum.MembershipType.Premium),speed=((LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")) or {WalkSpeed=16}).WalkSpeed,islockspeed=false,jump=((LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")) or {JumpPower=50}).JumpPower,islockjump=false,maxhealth=((LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")) or {JumpPower=100}).MaxHealth,islockmaxhealth=false,health=((LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")) or {JumpPower=100}).Health,islockhealth=false,gravity=Workspace.Gravity,islockgravity=false},releasetools={antiafk=true,zoom=ZoomModule.new(),Lantern=PlayerLightModule.new({Brightness=3,Range=20,Color=Color3.fromRGB(255, 165, 0),Shadows=true}),SuperLighter=PlayerLightModule.new({Brightness=2,Range=1000}),noclip=false,infjump=false,antifall=false,antidead=false,executecode="",nightvision=false,npc=NPCHighLighter.new(),chatresend=false,supernightvision=false,originalBrightness=Lighting.Brightness,originalExposureCompensation=Lighting.ExposureCompensation,keepchronixhub=false,networkpausedisable=false,exitgame=0,staffcheck=false,xray=false},otherdata={executordetecter={robloxinfo=HttpService:JSONDecode(AsyncFileFetcher.fetchSingle("https://weao.xyz/api/versions/current")),exploits=HttpService:JSONDecode(AsyncFileFetcher.fetchSingle("https://weao.xyz/api/status/exploits"))},playertitle={tag=ChatTagModule.new({player=LocalPlayer,text="[VIP]",color="#FFD700",size=18,bold=false,italic=false,font="GothamBlack"}),text="[VIP]",color="#FFD700",size=18,bold=false,italic=false,font="GothamBlack"},musicbox=Instance.new("Sound"),testSound=Instance.new("Sound"),daySettings={ClockTime=14,GeographicLatitude=41.73},nightSettings={ClockTime=2,GeographicLatitude=41.73},musicData={isPlay=false,isPause=false,PlayLocation=0,currentId="142376088",musicIds={"142376088","1844108188","1846368080","5409360995","1848354536","1841647093","1837879082","1837768517","9041745502","9048375035","1840684208","118939739460633","1846999567","1840434670","9046863253","1848028342","1843404009","1845756489","1846862303","1841998846","122600689240179","1837101327","125793633964645","1846088038","1845554017","1838635121","16190757458","1846442964","1839703786","1839444520","1838028467","7028518546","121336636707861","87540733242308","1838667168","1838667680","1845179120","136598811626191","79451196298919","1837769001","103086632976213","120817494107898","5410084188","104483584177040","7024220835","1842976958","7023635858","1835782117","7029024726","7029017448","5410085694","1843471292","7029005367","131020134622685","7024340270","1836057733","9047104336","9047104411","1843324336","1845215540"}},audioData={enable=false,threshold=30,currentSelectedId=nil,isTesting=false,audioListItems={},lastScanTime=0,scanConnection=nil},savedAtmospheres={}},hankermodule={hkill={killname="",killrange=100,killall=false,killany=false},spin={speed=20}}},scriptlist={{name="高级聊天系统",link="https://raw.atomgit.com/Furrycalin/RobloxScripts/raw/main/customChatSystem.lua"},{name="飞行V4",link="https://raw.atomgit.com/Furrycalin/RobloxScripts/raw/main/FlyV4.lua"},{name="IY5.5.9(指令挂)",link="https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},{name="Dex",link="https://raw.atomgit.com/Furrycalin/ScriptStorage/raw/main/dex.lua"},{name="DexDark",link="https://raw.atomgit.com/Furrycalin/ScriptStorage/raw/main/DexDark.lua"},{name="SimpleSpy",link="https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"},{name="NPC自瞄",link="https://rawscripts.net/raw/Universal-Script-Npc-Aimbot-64954"},{name="SolaraHub",link="https://raw.githubusercontent.com/samuraa1/Solara-Hub/refs/heads/main/SH.lua"},{name="XAHub",link="https://raw.gitcode.com/XiaoYunUwU/XA/raw/main/Loader.lua"},{name="控制NPC",link="https://raw.githubusercontent.com/randomstring0/fe-source/refs/heads/main/NPC/source/main.Luau"},{name="控制东西",link="https://pastebin.com/raw/VVWcfs9t"},{name="OldMSPaint",link="https://raw.githubusercontent.com/notpoiu/mspaint/main/main.lua"},{name="Doors扫描器",link="https://raw.atomgit.com/Furrycalin/ScriptStorage/raw/main/DoorsNVC3000.lua"},{name="冬凌中心",link="https://raw.atomgit.com/Furrycalin/ScriptStorage/raw/main/DongLingLobby.lua"},{name="玩家控制",link="https://raw.atomgit.com/Furrycalin/ScriptStorage/raw/main/PlayerControl.lua"},{name="动画中心",link="https://raw.githubusercontent.com/GamingScripter/Animation-Hub/main/Animation%20Gui"},{name="阿尔宙斯",link="https://raw.githubusercontent.com/AZYsGithub/chillz-workshop/main/Arceus%20X%20V3"},{name="VChine V2",link="https://pastebin.com/raw/SuDKzFKD"}},Supported_Games={{gameid=2162087722,name="兽化项目"},{gameid=6508759464,name="格蕾丝"},{gameid=5166944221,name="死亡球"},{gameid=9161105297,name="小屋角色扮演"},{gameid=6352299542,name="妄想办公室"},{gameid=972475338,name="南极探险队"},{gameid=6996099240,name="噩梦之行"},{gameid=5265348926,name="西部森林"},{gameid=5429450445,name="警笛头:遗产"},{gameid=4981761600,name="深渊"},{gameid=8111911783,name="后院生存"},{gameid=5974510967,name="最黑暗的时刻"},{gameid=1709917610,name="后悔电梯"}},othergamedata={west_wood={monster=NameTagModule.new("WendigoAI", "fuzzy", 20, true, "怪物")},sirenhead_legacy={cratemodule=HighlightModule.new("crate", "fuzzy", "item"),cratenametagmodule=NameTagModule.new("crate", "fuzzy", 20, true, "盒子"),berrymodule=HighlightModule.new("berry", "fuzzy", "item"),berrynametagmodule=NameTagModule.new("berry", "fuzzy", 20, true, "浆果")},nightmare_run={monster=MovableHighlighter_NM.new(),HLCheese=HighlightModule.new("Cheese", "fuzzy", "item")},project_transfur={bot=HighlightModule.new("Bot", "fuzzy", "item"),botnt=NameTagModule.new("Bot", "fuzzy", 20, true, "Bot兽"),smallsafe=HighlightModule.new("__BasicSmallSafe", "fuzzy", "item"),smallsafent=NameTagModule.new("__BasicSmallSafe", "fuzzy", 20, true, "小保险箱"),largesafe=HighlightModule.new("__BasicLargeSafe", "fuzzy", "item"),largesafent=NameTagModule.new("__BasicLargeSafe", "fuzzy", 20, true, "大保险箱"),goldensafe=HighlightModule.new("__LargeGoldenSafe", "fuzzy", "item"),goldensafent=NameTagModule.new("__LargeGoldenSafe", "fuzzy", 20, true, "金保险箱"),crate=HighlightModule.new("Surplus Crate", "fuzzy", "item"),cratent=NameTagModule.new("Surplus Crate", "fuzzy", 20, true, "武器盒"),sd=HighlightModule.new("SupplyDrop", "fuzzy", "item"),sdnt=NameTagModule.new("SupplyDrop", "fuzzy", 20, true, "空投")},delesions_office={entitywarning=false,tipotherplayer=false,auto013=false,entitys={NormalEntity={name="EN-001",tip="立刻躲在柜子中！"},NormalEntityType2={name="EN-001-02",tip="立刻躲在柜子中！"},SnakeEntity={name="EN-002",tip="多待在柜子里一会！"},TrainEntity={name="EN-003",tip="不要犹豫，立刻躲起来！"},LateEntity={name="EN-004",tip="稍后躲在柜子中！"},ReboundingEntity={name="EN-005",tip="把握住进柜子的时间，他会来回冲！"},PeaceEntity={name="EN-006",tip="千万不要躲在柜子中！"},VisionEntity={name="EN-007",tip="不要躲在墙壁后！"},FocusEntity={name="EN-008",tip="躲在柜子中，记住钥匙的位置！"},ShadowEntity={name="EN-011",tip="他在黑暗中，不要看他！"},GhostEntity={name="EN-012",tip="注意他的规则！"},UnknownEntity={name="EN-013",tip="快点输入 'staycalmstayfocused'"},ChaserEntity={name="EN-015",tip="快跑！"},DelmonEntity={name="EN-0??",tip="暂未收录该数据"},DoorcamperEntity={name="EN-017",tip="多注意门后！"}}},grace={autolever=false,deleteentity=false},backroomsurvival={Shrieker=HighlightModule.new("Shrieker", "fuzzy", "hostileNpc"),Shriekernt=NameTagModule.new("Shrieker", "fuzzy", 20, true, "[敌对] 瞎子"),Wretch=HighlightModule.new("Wretch", "fuzzy", "hostileNpc"),Wretchnt=NameTagModule.new("Wretch", "fuzzy", 20, true, "[敌对] 悲尸"),Phantom=HighlightModule.new("Phantom", "fuzzy", "hostileNpc"),Phantomnt=NameTagModule.new("Phantom", "fuzzy", 20, true, "[敌对] 梦魇"),Bacteria=HighlightModule.new("Bacteria", "fuzzy", "hostileNpc"),Bacteriant=NameTagModule.new("Bacteria", "fuzzy", 20, true, "[敌对] 细菌"),SkinStealer=HighlightModule.new("Skin Stealer", "fuzzy", "hostileNpc"),SkinStealernt=NameTagModule.new("Skin Stealer", "fuzzy", 20, true, "[敌对] 窃皮者"),Recon=HighlightModule.new("Recon", "fuzzy", "neutralNpc"),Reconnt=NameTagModule.new("Recon", "fuzzy", 20, true, "[中立] 侦察兵"),Mechanic=HighlightModule.new("Mechanic", "fuzzy", "neutralNpc"),Mechanicnt=NameTagModule.new("Mechanic", "fuzzy", 20, true, "[中立] 修理工")},AntarcticExpedition={giftnumber=0},DarkestHours={Collectible=HighlightModule.new("Scrap", "fuzzy", "item"),Collectiblent=NameTagModule.new("Scrap", "fuzzy", 20, true, "[收集物]")},Regretevator={coins=HighlightModule.new("Coin", "pathFuzzy", "normal"),coinsnt=NameTagModule.new("Coin", "fuzzy", 20, false, "硬币"),bugbo_rocks=HighlightModule.new({"bugbo","Rocks"}, "pathFuzzy", "item"),bugbo_rocksnt=NameTagModule.new({"bugbo","Rocks"}, "pathFuzzy", 20, false, "[石头]"),firewood=HighlightModule.new("Firewood", "pathFuzzy", "item"),firewoodnt=NameTagModule.new("Firewood", "pathFuzzy", 20, false, "[木头]")}}};
data['basicdata']['otherdata']['musicbox']['Volume'] = 0.5;
data['basicdata']['otherdata']['musicbox']['Looped'] = false;
data['basicdata']['otherdata']['musicbox']['Parent'] = SoundService;
data['basicdata']['otherdata']['testSound']['Volume'] = 0.5;
data['basicdata']['otherdata']['testSound']['Parent'] = SoundService;
local function toChineseDate(dateStr, toBeijingTime)
	if (not dateStr or (type(dateStr) ~= "string")) then
		return "";
	end
	local m, d, y, h, min, s, ap = dateStr:match("(%d+)%D+(%d+)%D+(%d+)%D+(%d+)%D+(%d+)%D*(%d*)%D*([AP]M)");
	if not m then
		return dateStr;
	end
	s = ((s ~= "") and s) or "0";
	local hour = tonumber(h);
	if ((ap == "PM") and (hour ~= 12)) then
		hour = hour + 12;
	elseif ((ap == "AM") and (hour == 12)) then
		hour = 0;
	end
	if toBeijingTime then
		hour = hour + 8;
		if (hour >= 24) then
			hour = hour - 24;
		end
	end
	return string.format("%d年%d月%d日 %02d:%02d:%02d", tonumber(y), tonumber(m), tonumber(d), hour, tonumber(min), tonumber(s));
end
local function parseExecutors(jsonString)
	local result = {};
	for _, item in ipairs(jsonString) do
		if (type(item) == "table") then
			local flat = {title=item.title,version=item.version,platform=item.platform,extType=item.extype,free=item.free,detected=item.detected,uncStatus=item.uncStatus,uncPercent=item.uncPercentage,suncPercent=item.suncPercentage,updatedDate=toChineseDate(item.updatedDate or "", true),rbxversion=item.rbxversion,updateStatus=item.updateStatus,beta=item.beta,hidden=item.hidden,unlinked=item.unlinked,elementCertified=item.elementCertified,decompiler=item.decompiler,multiInject=item.multiInject,keysystem=item.keysystem,clientmods=item.clientmods,cost=item.cost,hasIssues=item.hasIssues,detectionReason=item.detectionReason,longestRunning=item.longestRunning,possibleBanwave=item.possibleBanwave,unknown=item.unknown,unknownDetection=item.unknownDetection,raknet=item.raknet,private=item.private,index=item.index,trackerId=item.trackerId,website=item.websitelink,discord=item.discordlink,purchase=item.purchaselink,roleId=item.roleId,suncScrap=(item.sunc and item.sunc.suncScrap),suncKey=(item.sunc and item.sunc.suncKey),slugHidden=(item.slug and item.slug.hidden),description=(item.slug and item.slug.fullDescription),logo=(item.slug and item.slug.logo),owner=(item.slug and item.slug.owner),screenshots=((item.slug and item.slug.screenshots) or {}),recommendedFeatures=((item.recommendedReason and item.recommendedReason.features) or {})};
			table.insert(result, flat);
		end
	end
	return result;
end
local shownParts = {};
local function showpartsfunction(enable)
	if enable then
		for i, v in pairs(Workspace:GetDescendants()) do
			if (v:IsA("BasePart") and (v.Transparency == 1)) then
				if not table.find(shownParts, v) then
					table.insert(shownParts, v);
				end
				v.Transparency = 0;
			end
		end
	else
		for i, v in pairs(shownParts) do
			v.Transparency = 1;
		end
		shownParts = {};
	end
end
local function formatUsername(player)
	if (player.DisplayName ~= player.Name) then
		return string.format("%s (%s)", player.Name, player.DisplayName);
	end
	return player.Name;
end
local function xray(enabled)
	for _, v in pairs(Workspace:GetDescendants()) do
		if (v:IsA("BasePart") and not v.Parent:FindFirstChildWhichIsA("Humanoid") and not v.Parent.Parent:FindFirstChildWhichIsA("Humanoid")) then
			v.LocalTransparencyModifier = (enabled and 0.5) or 0;
		end
	end
end
local function maskStringMiddle(str)
	if (not str or (type(str) ~= "string")) then
		return "";
	end
	local strLength = string.len(str);
	if (strLength <= 10) then
		return str;
	else
		local firstFive = string.sub(str, 1, 5);
		local lastFive = string.sub(str, -5);
		local middleCount = strLength - 10;
		local hashString = string.rep("#", middleCount);
		return firstFive .. hashString .. lastFive;
	end
end
function respawn()
	local char = LocalPlayer.Character;
	if not char then
		return;
	end
	local hum = char:FindFirstChildWhichIsA("Humanoid");
	if hum then
		hum:ChangeState(Enum.HumanoidStateType.Dead);
		hum.Health = 0;
		hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true);
		task.wait(0.01);
		hum:Destroy();
	end
	for _, v in pairs(char:GetChildren()) do
		if (v:IsA("BasePart") or v:IsA("Humanoid")) then
			v:Destroy();
		end
	end
	task.wait(0.05);
	char:BreakJoints();
	char:Destroy();
end
function refresh()
	local char = LocalPlayer.Character;
	if not char then
		char = LocalPlayer.CharacterAdded:Wait();
	end
	local humanoid = char:FindFirstChildOfClass("Humanoid");
	local root = humanoid and humanoid.RootPart;
	if not root then
		repeat
			task.wait();
			humanoid = char:FindFirstChildOfClass("Humanoid");
			root = humanoid and humanoid.RootPart;
		until root 
	end
	local pos = root.CFrame;
	local pos1 = Workspace.CurrentCamera.CFrame;
	respawn();
	task.spawn(function()
		local newChar = LocalPlayer.CharacterAdded:Wait();
		local newHumanoid;
		local newRoot;
		repeat
			task.wait();
			newHumanoid = newChar:FindFirstChildOfClass("Humanoid");
			newRoot = newHumanoid and newHumanoid.RootPart;
		until newRoot 
		newRoot.CFrame = pos;
		Workspace.CurrentCamera.CFrame = pos1;
	end);
end
local staffRoles = {"mod","admin","staff","dev","founder","owner","supervis","manager","management","executive","president","chairman","chairwoman","chairperson","director"};
local function getStaffRole(player)
	local playerRole = player:GetRoleInGroup(game.CreatorId);
	local result = {Role=playerRole,Staff=false};
	if player:IsInGroup(1200769) then
		result.Role = "Roblox Employee";
		result.Staff = true;
	end
	for _, role in pairs(staffRoles) do
		if string.find(string.lower(playerRole), role) then
			result.Staff = true;
		end
	end
	return result;
end
function randomString()
	local length = math.random(10, 20);
	local array = {};
	for i = 1, length do
		array[i] = string.char(math.random(32, 126));
	end
	return table.concat(array);
end
local function promptNewRig(rig)
	local humanoid = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid");
	if humanoid then
		AvatarEditorService:PromptSaveAvatar(humanoid.HumanoidDescription, Enum.HumanoidRigType[rig]);
		local result = AvatarEditorService.PromptSaveAvatarCompleted:Wait();
		if (result == Enum.AvatarPromptResult.Success) then
			if humanoid then
				humanoid:ChangeState(Enum.HumanoidStateType.Dead);
			else
				LocalPlayer.Character:BreakJoints();
			end
		end
	end
end
local function RemoveFog()
	data['basicdata']['otherdata']['savedAtmospheres'] = {};
	Lighting.FogEnd = 100000;
	for i, v in pairs(Lighting:GetDescendants()) do
		if v:IsA("Atmosphere") then
			local data = {Parent=v.Parent,Name=v.Name,Properties={}};
			for _, prop in ipairs({"Density","Offset","Color","Decay","Glare","Haze"}) do
				data.Properties[prop] = v[prop];
			end
			table.insert(data['basicdata']['otherdata']['savedAtmospheres'], data);
			v:Destroy();
		end
	end
end
local function RestoreFog()
	Lighting.FogEnd = Lighting.FogEnd;
	for _, data in ipairs(data['basicdata']['otherdata']['savedAtmospheres']) do
		local atmosphere = Instance.new("Atmosphere");
		atmosphere.Parent = data.Parent;
		atmosphere.Name = data.Name;
		for prop, value in pairs(data.Properties) do
			atmosphere[prop] = value;
		end
	end
	data['basicdata']['otherdata']['savedAtmospheres'] = {};
end
local function convertToSmallCaps(text)
	local map = {a="ᴀ",b="ʙ",c="ᴄ",d="ᴅ",e="ᴇ",f="ғ",g="ɢ",h="ʜ",i="ɪ",j="ᴊ",k="ᴋ",l="ʟ",m="ᴍ",n="ɴ",o="ᴏ",p="ᴘ",q="ǫ",r="ʀ",s="s",t="ᴛ",u="ᴜ",v="ᴠ",w="ᴡ",x="x",y="ʏ",z="ᴢ",A="ᴀ",B="ʙ",C="ᴄ",D="ᴅ",E="ᴇ",F="ғ",G="ɢ",H="ʜ",I="ɪ",J="ᴊ",K="ᴋ",L="ʟ",M="ᴍ",N="ɴ",O="ᴏ",P="ᴘ",Q="ǫ",R="ʀ",S="s",T="ᴛ",U="ᴜ",V="ᴠ",W="ᴡ",X="x",Y="ʏ",Z="ᴢ"};
	return (text:gsub("[a-zA-Z]", map));
end
function hasNoSmallCapsAndHasLetters(text)
	local smallCapsChars = "ᴀʙᴄᴅᴇғɢʜɪᴊᴋʟᴍɴᴏᴘǫʀsᴛᴜᴠᴡxʏᴢ";
	for i = 1, #smallCapsChars do
		local char = smallCapsChars:sub(i, i);
		if text:find(char, 1, true) then
			return false;
		end
	end
	if not text:find("[a-zA-Z]") then
		return false;
	end
	return true;
end
local function rejoinCurrentGame()
	local placeId1 = game.PlaceId;
	local jobId1 = game.JobId;
	if (jobId1 and (jobId1 ~= "")) then
		TeleportService:TeleportToPlaceInstance(placeId1, jobId1, LocalPlayer);
	else
		warn("[ChronixHub] 无法获取 JobId，将使用普通传送，可能不会回到同一个房间。");
		TeleportService:Teleport(placeId1, LocalPlayer);
	end
end
local function setDay()
	for property, value in pairs(data['basicdata']['otherdata']['daySettings']) do
		local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
		local tween = TweenService:Create(Lighting, tweenInfo, {[property]=value});
		tween:Play();
	end
end
local function setNight()
	for property, value in pairs(data['basicdata']['otherdata']['nightSettings']) do
		local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
		local tween = TweenService:Create(Lighting, tweenInfo, {[property]=value});
		tween:Play();
	end
end
local function TeleportTo(x, y, z)
	if ((type(x) ~= "number") or (type(y) ~= "number") or (type(z) ~= "number")) then
		warn("[ChronixHub] 请传入三个数字：TeleportTo(x, y, z)");
		return false;
	end
	local character = LocalPlayer.Character;
	if not character then
		character = LocalPlayer.CharacterAdded:Wait();
	end
	local rootPart = character:FindFirstChild("HumanoidRootPart");
	if not rootPart then
		warn("[Teleport] 未找到 HumanoidRootPart");
		return false;
	end
	rootPart.CFrame = CFrame.new(Vector3.new(x, y, z));
	ChronixUI:Notify({Title="提示",Content=string.format("✅ 已传送到 (%.1f, %.1f, %.1f)", x, y, z),Type="success",Duration=5});
	return true;
end
local function TeleportToPresent(presentNumber)
	if (type(presentNumber) ~= "number") then
		return false;
	end
	local mainModel = Workspace:FindFirstChild("XMas_PresentHunt%") or Workspace:FindFirstChild("XMas_PresentHunt");
	if not mainModel then
		return false;
	end
	local presents = mainModel:FindFirstChild("Presents");
	if not presents then
		return false;
	end
	local gift = presents:FindFirstChild(tostring(presentNumber));
	if (not gift or not gift:IsA("Model")) then
		return false;
	end
	local giftCFrame = gift:GetPivot();
	local character = LocalPlayer.Character;
	if not character then
		return false;
	end
	local rootPart = character:FindFirstChild("HumanoidRootPart");
	if not rootPart then
		return false;
	end
	local targetCFrame = CFrame.new(giftCFrame.Position + Vector3.new(0, 3, 0));
	rootPart.CFrame = targetCFrame;
	ChronixUI:Notify({Title="提示",Content=string.format("✅ 已传送到礼物 #%d！", presentNumber),Type="success",Duration=5});
	return true;
end
local function detectEntity(instance)
	if instance:IsA("BasePart") then
		for entityName, entityInfo in pairs(data['othergamedata']['delesions_office']['entitys']) do
			if (instance.Name == entityName) then
				if data['othergamedata']['delesions_office']['entitywarning'] then
					ChronixUI:Notify({Title="！警告！",Content=("实体" .. entityInfo.name .. "已生成！\n" .. entityInfo.tip),Type="warning",Duration=5});
					if data['othergamedata']['delesions_office']['tipotherplayer'] then
						ChatControl:chat("警告！实体" .. entityInfo.name .. "已生成！" .. entityInfo.tip);
					end
				end
				if data['othergamedata']['delesions_office']['auto013'] then
					if (instance.Name == "UnknownEntity") then
						ChronixUI:Notify({Title="自动EN-013",Content="正在自动键入'staycalmstayfocused'...",Type="warning",Duration=5});
						task.wait(2);
						local str = "staycalmstayfocused";
						for i = 1, #str do
							local char = string.sub(str, i, i);
							VirtualInputManager:SendKeyEvent(true, char, false, game);
							task.wait(0.2);
						end
					end
				end
				break;
			end
		end
	end
end
local function getAllPostEffects()
	local effects = {};
	for _, obj in ipairs(Lighting:GetDescendants()) do
		if obj:IsA("PostEffect") then
			table.insert(effects, obj);
		end
	end
	local camera = Workspace.CurrentCamera;
	if camera then
		for _, obj in ipairs(camera:GetDescendants()) do
			if obj:IsA("PostEffect") then
				table.insert(effects, obj);
			end
		end
	end
	return effects;
end
local function getColorCorrectionEffect()
	for _, effect in ipairs(getAllPostEffects()) do
		if effect:IsA("ColorCorrectionEffect") then
			return effect;
		end
	end
	return nil;
end
local function getMemoryUsage(unit)
	unit = unit or "MB";
	local success, result = pcall(function()
		return collectgarbage("count");
	end);
	local memoryKB;
	if success then
		memoryKB = result;
	else
		local current, total = gcinfo();
		memoryKB = current;
	end
	if (unit == "KB") then
		return memoryKB;
	elseif (unit == "MB") then
		return memoryKB / 1024;
	elseif (unit == "GB") then
		return memoryKB / (1024 * 1024);
	else
		return memoryKB / 1024;
	end
end
local function color3ToHex(color)
	local r = math.floor((color.R * 255) + 0.5);
	local g = math.floor((color.G * 255) + 0.5);
	local b = math.floor((color.B * 255) + 0.5);
	return string.format("#%02X%02X%02X", r, g, b);
end
local function hexToColor3(hex)
	hex = hex:gsub("#", "");
	local r = tonumber(hex:sub(1, 2), 16) / 255;
	local g = tonumber(hex:sub(3, 4), 16) / 255;
	local b = tonumber(hex:sub(5, 6), 16) / 255;
	return Color3.new(r, g, b);
end
-- 启动次数统计
local launchCount = 0;
pcall(function()
	local saved = game:GetService("HttpService"):JSONDecode(readfile("KaiHub_stats.json"));
	launchCount = saved.count or 0;
end);

local mainWindow = ChronixUI:CreateWindow({Name="KaiHub v6.0",Size=data['basicdata']['window']['windowSize'],ShowLoadingAnimation=true,CloseCallback=function()
	unloadChronixHub();
end});

-- 顶部状态栏：启动次数 + 使用时长
local statsBar = Instance.new("Frame");
statsBar.Size = UDim2.new(1, 0, 0, 20);
statsBar.BackgroundColor3 = Color3.fromRGB(25, 25, 40);
statsBar.BackgroundTransparency = 0.2;
statsBar.BorderSizePixel = 0;
statsBar.ZIndex = 100;

local statsStroke = Instance.new("UIStroke");
statsStroke.Thickness = 1;
statsStroke.Color = Color3.fromRGB(80, 80, 120);
statsStroke.Transparency = 0.6;
statsStroke.Parent = statsBar;

local leftLabel = Instance.new("TextLabel");
leftLabel.Size = UDim2.new(0.5, -8, 1, 0);
leftLabel.Position = UDim2.new(0, 8, 0, 0);
leftLabel.BackgroundTransparency = 1;
leftLabel.Text = "Launches: " .. launchCount;
leftLabel.Font = Enum.Font.SourceSansBold;
leftLabel.TextSize = 12;
leftLabel.TextColor3 = Color3.fromRGB(150, 200, 255);
leftLabel.TextXAlignment = Enum.TextXAlignment.Left;
leftLabel.TextYAlignment = Enum.TextYAlignment.Center;
leftLabel.ZIndex = 101;
leftLabel.Parent = statsBar;

local rightLabel = Instance.new("TextLabel");
rightLabel.Size = UDim2.new(0.5, -8, 1, 0);
rightLabel.Position = UDim2.new(0.5, 0, 0, 0);
rightLabel.BackgroundTransparency = 1;
rightLabel.Text = "Session: 00:00:00";
rightLabel.Font = Enum.Font.SourceSansBold;
rightLabel.TextSize = 12;
rightLabel.TextColor3 = Color3.fromRGB(150, 200, 255);
rightLabel.TextXAlignment = Enum.TextXAlignment.Right;
rightLabel.TextYAlignment = Enum.TextYAlignment.Center;
rightLabel.ZIndex = 101;
rightLabel.Parent = statsBar;

-- 计时器
task.spawn(function()
	while statsBar.Parent do
		task.wait(1);
		pcall(function()
			local elapsed = tick() - startTime;
			local h = math.floor(elapsed / 3600);
			local m = math.floor((elapsed % 3600) / 60);
			local s = math.floor(elapsed % 60);
			rightLabel.Text = string.format("Session: %02d:%02d:%02d", h, m, s);
		end);
	end;
end);

-- 把状态栏加到窗口里（延迟等待窗口创建完成）
task.delay(2, function()
	pcall(function()
		local gui = LocalPlayer.PlayerGui:FindFirstChild("ChronixUI") or LocalPlayer.PlayerGui:FindFirstChildWhichIsA("ScreenGui");
		if gui then
			for _, child in ipairs(gui:GetDescendants()) do
				if child:IsA("Frame") and child.Size.Y.Offset > 400 then
					statsBar.Parent = child;
					break;
				end;
			end;
		end;
	end);
end);
local basicTab = mainWindow:CreateTab({Name="基础设置",HasIcon=true,IconName="pencil-ruler"});
basicTab:AddTitle("基础数据修改");
basicTab:AddSlider({Label="玩家移速",Min=0,Max=1000,Default=data['basicdata']['player']['speed'],Callback=function(v)
	LocalPlayer.Character.Humanoid.WalkSpeed = v;
	data['basicdata']['player']['speed'] = v;
end});
basicTab:AddToggle({Label="锁定玩家移速",Default=false,Callback=function(v)
	data['basicdata']['player']['islockspeed'] = v;
end});
basicTab:AddSlider({Label="跳跃力量",Min=0,Max=1000,Default=data['basicdata']['player']['jump'],Callback=function(v)
	LocalPlayer.Character.Humanoid.JumpPower = v;
	data['basicdata']['player']['jump'] = v;
end});
basicTab:AddToggle({Label="锁定跳跃力量",Default=false,Callback=function(v)
	data['basicdata']['player']['islockjump'] = v;
end});
basicTab:AddSlider({Label="最大血量",Min=0,Max=1000,Default=data['basicdata']['player']['maxhealth'],Callback=function(v)
	LocalPlayer.Character.Humanoid.MaxHealth = v;
	data['basicdata']['player']['maxhealth'] = v;
end});
basicTab:AddToggle({Label="锁定最大血量",Default=false,Callback=function(v)
	data['basicdata']['player']['islockmaxhealth'] = v;
end});
basicTab:AddSlider({Label="当前血量",Min=0,Max=1000,Default=data['basicdata']['player']['health'],Callback=function(v)
	LocalPlayer.Character.Humanoid.Health = v;
	data['basicdata']['player']['health'] = v;
end});
basicTab:AddToggle({Label="锁定当前血量",Default=false,Callback=function(v)
	data['basicdata']['player']['islockhealth'] = v;
end});
basicTab:AddSlider({Label="世界重力",Min=0,Max=1000,Default=data['basicdata']['player']['gravity'],Callback=function(v)
	Workspace.Gravity = v;
	data['basicdata']['player']['gravity'] = v;
end});
basicTab:AddToggle({Label="锁定世界重力",Default=false,Callback=function(v)
	data['basicdata']['player']['islockgravity'] = v;
end});
local ToolsTab = mainWindow:CreateTab({Name="工具",HasIcon=true,IconName="wrench"});
ToolsTab:AddTitle("各种实用工具");
ToolsTab:AddToggle({Label="防挂机",Default=true,Callback=function(v)
	data['basicdata']['releasetools']['antiafk'] = v;
end});
ToolsTab:AddToggle({Label="保留ChronixHub - 传送后自动执行",Default=false,Callback=function(v)
	data['basicdata']['releasetools']['keepchronixhub'] = v;
end});
ToolsTab:AddToggle({Label="飞行",Default=false,Callback=function(v)
	if v then
		FlyModule.enable();
		ChronixUI:Notify({Title="提示",Content=("按住Ctrl+" .. FlyModule.getbindkey().Name .. "开关飞行状态"),Type="info",Duration=5});
	else
		FlyModule.disable();
	end
end});
ToolsTab:AddToggle({Label="点击传送",Default=false,Callback=function(v)
	if v then
		TeleportModule.enable();
		ChronixUI:Notify({Title="提示",Content="按住Ctrl并点击来传送",Type="info",Duration=5});
	else
		TeleportModule.disable();
	end
end});
ToolsTab:AddToggle({Label="玩家透视",Default=false,Callback=function(v)
	if v then
		PlayerESP.enable();
	else
		PlayerESP.disable();
	end
end});
ToolsTab:AddToggle({Label="NPC透视",Default=false,Callback=function(v)
	if v then
		data['basicdata']['releasetools']['npc']:enable();
	else
		data['basicdata']['releasetools']['npc']:disable();
	end
end});
ToolsTab:AddToggle({Label="TPWalk",Default=false,Callback=function(v)
	tpWalk:Enabled(v);
end});
ToolsTab:AddToggle({Label="鼠标解锁",Default=false,Callback=function(v)
	if v then
		MouseUnlockModule.Enable();
		ChronixUI:Notify({Title="提示",Content="按下K+L组合键开关解锁鼠标",Type="info",Duration=5});
	else
		MouseUnlockModule.Disable();
	end
end});
ToolsTab:AddToggle({Label="锁定视角",Default=false,Callback=function(v)
	if v then
		LockCameraModule.enable();
		ChronixUI:Notify({Title="提示",Content=("按住" .. LockCameraModule.getBindKey().Name .. "键来锁定视角"),Type="info",Duration=5});
	else
		LockCameraModule.disable();
	end
end});
ToolsTab:AddToggle({Label="自动瞄准",Default=false,Callback=function(v)
	if v then
		AimBotModule.Enable();
	else
		AimBotModule.Disable();
	end
end});
ToolsTab:AddToggle({Label="物品滚轮切换",Default=false,Callback=function(v)
	if v then
		ChronixUI:Notify({Title="提示",Content=("按住" .. ScrollSwitch:getbind().Name .. "键并滚动鼠标滚轮来切换物品"),Type="info",Duration=5});
		ScrollSwitch:enable();
	else
		ScrollSwitch:disable();
	end
end});
ToolsTab:AddToggle({Label="望远镜",Default=false,Callback=function(v)
	if v then
		data['basicdata']['releasetools']['zoom']:Enable();
		ChronixUI:Notify({Title="提示",Content=("按住" .. tostring(data['basicdata']['releasetools']['zoom']:GetBindKey()):gsub("^Enum%.%w+%.", "") .. "键放大"),Type="info",Duration=5});
	else
		data['basicdata']['releasetools']['zoom']:Disable();
	end
end});
ToolsTab:AddToggle({Label="隐身",Default=false,Callback=function(v)
	if v then
		PlayerVisibleModule.enable();
	else
		PlayerVisibleModule.disable();
	end
end});
ToolsTab:AddToggle({Label="查看落脚点",Default=false,Callback=function(v)
	if v then
		FootstepHighlighter.enable();
	else
		FootstepHighlighter.disable();
	end
end});
ToolsTab:AddToggle({Label="落地特效",Default=false,Callback=function(v)
	if v then
		LandingEffect.enable();
	else
		LandingEffect.disable();
	end
end});
ToolsTab:AddToggle({Label="夜视",Default=false,Callback=function(v)
	data['basicdata']['releasetools']['nightvision'] = v;
	if v then
		game.Lighting.Ambient = Color3.new(1, 1, 1);
	else
		game.Lighting.Ambient = Color3.new(0, 0, 0);
	end
end});
ToolsTab:AddToggle({Label="超级夜视",Default=false,Callback=function(v)
	data['basicdata']['releasetools']['supernightvision'] = v;
	if v then
		data['basicdata']['releasetools']['originalBrightness'] = Lighting.Brightness;
		data['basicdata']['releasetools']['originalExposureCompensation'] = Lighting.ExposureCompensation;
		Lighting.Brightness = 2;
		Lighting.ExposureCompensation = 2.5;
	else
		Lighting.Brightness = data['basicdata']['releasetools']['originalBrightness'];
		Lighting.ExposureCompensation = data['basicdata']['releasetools']['originalExposureCompensation'];
	end
end});
ToolsTab:AddToggle({Label="随身灯笼",Default=false,Callback=function(v)
	data['basicdata']['releasetools']['Lantern']['enable'] = v;
end});
ToolsTab:AddToggle({Label="超级光明",Default=false,Callback=function(v)
	data['basicdata']['releasetools']['SuperLighter']['enable'] = v;
end});
ToolsTab:AddToggle({Label="雾气去除",Default=false,Callback=function(v)
	if v then
		RemoveFog();
	else
		RestoreFog();
	end
end});
local xrayLoop;
ToolsTab:AddToggle({Label="X光",Default=false,Callback=function(v)
	data['basicdata']['releasetools']['xray'] = v;
	if v then
		pcall(function()
			xrayLoop:Disconnect();
		end);
		xrayLoop = RunService.RenderStepped:Connect(function()
			xray(data['basicdata']['releasetools']['xray']);
			task.wait(1);
		end);
	else
		pcall(function()
			xrayLoop:Disconnect();
		end);
		xray(data['basicdata']['releasetools']['xray']);
	end
end});
ToolsTab:AddToggle({Label="显示隐藏部件",Default=false,Callback=function(v)
	showpartsfunction(v);
end});
ToolsTab:AddToggle({Label="灵魂出窍",Default=false,Callback=function(v)
	FreecamModule.freecamenable = v;
end});
ToolsTab:AddToggle({Label="平移",Default=false,Callback=function(v)
	if v then
		movementModule.Enable();
		ChronixUI:Notify({Title="提示",Content="按下↑↓←→键进行平移",Type="info",Duration=5});
	else
		movementModule.Disable();
	end
end});
ToolsTab:AddToggle({Label="空中移动",Default=false,Callback=function(v)
	if v then
		AirWalk.enable();
	else
		AirWalk.disable();
	end
end});
ToolsTab:AddToggle({Label="瞬间交互",Default=false,Callback=function(v)
	if v then
		InstantInteraction.enable();
	else
		InstantInteraction.disable();
	end
end});
ToolsTab:AddToggle({Label="穿墙",Default=false,Callback=function(v)
	data['basicdata']['releasetools']['noclip'] = v;
	Stepped = RunService.Stepped:Connect(function()
		if data['basicdata']['releasetools']['noclip'] then
			for a, b in pairs(Workspace:GetChildren()) do
				if (b.Name == LocalPlayer.Name) then
					for i, v in pairs(Workspace[LocalPlayer.Name]:GetChildren()) do
						if v:IsA("BasePart") then
							v.CanCollide = false;
						end
					end
				end
			end
		else
			for a, b in pairs(Workspace:GetChildren()) do
				if (b.Name == LocalPlayer.Name) then
					for i, v in pairs(Workspace[LocalPlayer.Name]:GetChildren()) do
						if v:IsA("BasePart") then
							v.CanCollide = true;
						end
					end
				end
			end
			Stepped:Disconnect();
		end
	end);
end});
ToolsTab:AddToggle({Label="连跳",Default=false,Callback=function(v)
	data['basicdata']['releasetools']['infjump'] = v;
	JR = UserInputService.JumpRequest:Connect(function()
		if not data['basicdata']['releasetools']['infjump'] then
			JR:Disconnect();
		end
		if data['basicdata']['releasetools']['infjump'] then
			local c = LocalPlayer.Character;
			if (c and c.Parent) then
				local hum = c:FindFirstChildOfClass("Humanoid");
				if hum then
					hum:ChangeState("Jumping");
				end
			end
		end
	end);
end});
ToolsTab:AddToggle({Label="旁观模式",Default=false,Callback=function(v)
	if v then
		SpectatorModule.start();
	else
		SpectatorModule.close();
	end
end});
ToolsTab:AddToggle({Label="防击倒",Default=false,Callback=function(v)
	data['basicdata']['releasetools']['antifall'] = v;
end});
ToolsTab:AddToggle({Label="晕厥康复",Default=false,Callback=function(v)
	if v then
		StandRecovery:enableDetection();
	else
		StandRecovery:disableDetection();
	end
end});
ToolsTab:AddToggle({Label="防甩飞",Default=false,Callback=function(v)
	if v then
		FlingDetector.enable(LocalPlayer);
	else
		FlingDetector.disable();
	end
end});
ToolsTab:AddToggle({Label="反物理劫持",Default=false,Callback=function(v)
	if v then
		AntiVoidModule.enable();
	else
		AntiVoidModule.disable();
	end
end});
ToolsTab:AddToggle({Label="管理员检测",Default=false,Callback=function(v)
	data['basicdata']['releasetools']['staffcheck'] = v;
	if (v and (game.CreatorType == Enum.CreatorType.Group)) then
		local found = {};
		for _, player in pairs(Players:GetPlayers()) do
			local result = getStaffRole(player);
			if result.Staff then
				table.insert(found, formatUsername(player) .. " 是 " .. result.Role);
			end
		end
		if (#found > 0) then
			for index, value in ipairs(found) do
				ChronixUI:Notify({Title="警告",Content=value,Duration=10});
			end
		end
	else
		data['basicdata']['releasetools']['staffcheck'] = false;
	end
end});
ToolsTab:AddToggle({Label="防死亡",Default=false,Callback=function(v)
	data['basicdata']['releasetools']['antidead'] = v;
	if not v then
		LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true);
	end
end});
ToolsTab:AddToggle({Label="聊天重发",Default=false,Callback=function(v)
	data['basicdata']['releasetools']['chatresend'] = v;
end});
ToolsTab:AddTitle("强制发言");
ToolsTab:AddParagraph({Title="输入消息内容后点击发送",Content="可以发送任意文字到聊天栏，包括被游戏屏蔽的内容"});
local forceMsg = "";
ToolsTab:AddInput({Text="消息内容",Placeholder="输入要发送的消息...",Callback=function(value)
	forceMsg = value;
end});
ToolsTab:AddButton({Text="发送消息",Callback=function()
	if (forceMsg and (#forceMsg > 0)) then
		local ok, err = pcall(function()
			ChatControl:chat(forceMsg);
		end);
		if ok then
			ChronixUI:Notify({Title="强制发言",Content="消息已发送",Type="success",Duration=2});
		else
			ChronixUI:Notify({Title="发送失败",Content=tostring(err):sub(1, 50),Type="error",Duration=3});
		end
	else
		ChronixUI:Notify({Title="提示",Content="请先输入消息内容",Type="warning",Duration=2});
	end
end});
ToolsTab:AddToggle({Label="聊天偷听",Default=false,Callback=function(v)
	if v then
		ChatSpy.enable();
	else
		ChatSpy.disable();
	end
end});
ToolsTab:AddToggle({Label="坐下",Default=false,Callback=function(v)
	if v then
		LocalPlayer.Character:FindFirstChild("Humanoid").Sit = true;
	else
		LocalPlayer.Character:FindFirstChild("Humanoid").Sit = false;
	end
end});
ToolsTab:AddToggle({Label="防踢出",Default=false,Callback=function(v)
	if v then
		local success, message = AntiKickModule.enable();
		if (message == "Incompatible Exploit: missing hookmetamethod or LocalPlayer not accessible") then
			ChronixUI:Notify({Title="不支持的漏洞",Content=(((identifyexecutor and identifyexecutor()) or "UnKnown") .. "暂不支持此功能"),Type="error",Duration=5});
		end
	else
		AntiKickModule.disable();
	end
end});
ToolsTab:AddToggle({Label="模型删除工具",Default=false,Callback=function(v)
	if v then
		DeleteTool.enable();
		ChronixUI:Notify({Title="提示",Content=("按下" .. DeleteTool.getbindkey().Name .. "键来删除面前的模型"),Type="info",Duration=5});
	else
		DeleteTool.disable();
	end
end});
ToolsTab:AddToggle({Label="GUI删除工具",Default=false,Callback=function(v)
	if v then
		GuiDeleter.enable();
		ChronixUI:Notify({Title="提示",Content=("按下" .. GuiDeleter.getBindKey().Name .. "键来删除鼠标指向的UI"),Type="info",Duration=5});
	else
		GuiDeleter.disable();
	end
end});
ToolsTab:AddToggle({Label="禁用购买提示框",Default=false,Callback=function(v)
	if v then
		CoreGui.PurchasePromptApp.Enabled = false;
	else
		CoreGui.PurchasePromptApp.Enabled = true;
	end
end});
ToolsTab:AddToggle({Label="禁用游戏暂停",Default=false,Callback=function(v)
	data['basicdata']['releasetools']['networkpausedisable'] = v;
end});
ToolsTab:AddButton({Text="回满血",Callback=function()
	LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth;
end});
ToolsTab:AddButton({Text="自杀",Callback=function()
	LocalPlayer.Character.Humanoid.Health = 0;
end});
ToolsTab:AddButton({Text="强制自杀",Callback=function()
	respawn();
end});
ToolsTab:AddButton({Text="原地重生",Callback=function()
	refresh();
end});
ToolsTab:AddButton({Text="获得点击传送工具",Callback=function()
	mouse = LocalPlayer:GetMouse();
	tool = Instance.new("Tool");
	tool.RequiresHandle = false;
	tool.Name = "手持点击传送";
	tool.Activated:connect(function()
		local pos = mouse.Hit + Vector3.new(0, 2.5, 0);
		pos = CFrame.new(pos.X, pos.Y, pos.Z);
		LocalPlayer.Character.HumanoidRootPart.CFrame = pos;
	end);
	tool.Parent = LocalPlayer.Backpack;
end});
ToolsTab:AddButton({Text="重新加入当前房间(服务器)",Callback=function()
	rejoinCurrentGame();
end});
ToolsTab:AddButton({Text="切换角色为R6",Callback=function()
	promptNewRig("R6");
end});
ToolsTab:AddButton({Text="切换角色为R15",Callback=function()
	promptNewRig("R15");
end});
ToolsTab:AddButton({Text="切换时间为白天",Callback=function()
	setDay();
end});
ToolsTab:AddButton({Text="切换时间为黑夜",Callback=function()
	setNight();
end});
ToolsTab:AddButton({Text="优化世界光效",Callback=function()
	loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/ChronixHub/raw/main/modules/WorldShader.lua"))();
end});
ToolsTab:AddButton({Text="打印眼前实例名到控制台",Callback=function()
	local head = LocalPlayer.Character:WaitForChild("Head");
	local raycastParams = RaycastParams.new();
	raycastParams.FilterDescendantsInstances = {LocalPlayer.Character};
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist;
	local rayOrigin = head.Position;
	local rayDirection = head.CFrame.LookVector * 100;
	local raycastResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams);
	if raycastResult then
		local hitInstance = raycastResult.Instance;
		print("[ChronixHub] 面前实例名称：", hitInstance.Name);
		print("[ChronixHub] 完整路径：", hitInstance:GetFullName());
	else
		print("[ChronixHub] 面前没有检测到实例");
	end
end});
ToolsTab:AddButton({Text="打印当前玩家坐标到控制台",Callback=function()
	local position1 = LocalPlayer.Character.HumanoidRootPart.Position;
	print(string.format("[ChronixHub] 玩家坐标: (%.2f, %.2f, %.2f)", position1.X, position1.Y, position1.Z));
end});
ToolsTab:AddButton({Text="开启控制台界面",Callback=function()
	StarterGui:SetCore("DevConsoleVisible", true);
end});
ToolsTab:AddButton({Text="启用所有ROBLOXUI",Callback=function()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true);
end});
ToolsTab:AddButton({Text="获取建筑工具",Callback=function()
	for i = 1, 4 do
		local Tool = Instance.new("HopperBin");
		Tool.BinType = i;
		Tool.Name = randomString();
		Tool.Parent = LocalPlayer:FindFirstChildWhichIsA("Backpack");
	end
end});
ToolsTab:AddButton({Text="测试执行器UNC与WUNC",Callback=function()
	ChronixUI:Notify({Title="提示",Content="正在测试中，请耐心等待。",Type="info",Duration=5});
	local unc = UNCTestModule.getunc();
	local wunc = UNCTestModule.getwunc();
	ChronixUI:Notify({Title=("执行器 - " .. ((identifyexecutor and identifyexecutor()) or "UnKnown")),Content=string.format("UNC: %d%%, WUNC: %d%%", unc, wunc),Type="info",Duration=5});
end});
ToolsTab:AddButton({Text="终止当前游戏进程",Callback=function()
	if messagebox then
		local result = messagebox("Do you want to end the current game?\n\nIt may be used in situations where exit is not possible.", "Roblox", 4 + 32);
		if (result == 6) then
			game:Shutdown();
		end
	else
		data['basicdata']['releasetools']['exitgame'] = data['basicdata']['releasetools']['exitgame'] + 1;
		if (data['basicdata']['releasetools']['exitgame'] == 1) then
			ChronixUI:Notify({Title="警告",Content="你确定要终止游戏进程吗？",Type="warning",Duration=10});
		end
		if (data['basicdata']['releasetools']['exitgame'] == 2) then
			ChronixUI:Notify({Title="警告",Content="再次确定？",Type="warning",Duration=10});
		end
		if (data['basicdata']['releasetools']['exitgame'] == 3) then
			ChronixUI:Notify({Title="警告",Content="最终确定？",Type="warning",Duration=10});
		end
		if (data['basicdata']['releasetools']['exitgame'] == 4) then
			game:Shutdown();
		end
	end
end});
local scripthubTab = mainWindow:CreateTab({Name="脚本中心",HasIcon=true,IconName="computer"});
scripthubTab:AddTitle("由作者推荐的脚本 - 注意大部分脚本未经过验证，请谨慎使用。");
local function addscripts(name, link)
	scripthubTab:AddButton({Text=name,Callback=function()
		ChronixUI:Notify({Title="提示",Content=(name .. "正在启动，请耐心等待。"),Type="info",Duration=5});
		if link:find("githubusercontent") then
			ChronixUI:Notify({Title="提示",Content="该链接为github的原始链接，访问受限，如无法执行请排查网络问题。",Type="info",Duration=5});
		end
		local content, success = AsyncFileFetcher.fetchSingle(link);
		if success then
			loadstring(content)();
		else
			ChronixUI:Notify({Title="提示",Content=(name .. "启动失败。"),Type="warning",Duration=5});
		end
		ChronixUI:Notify({Title="提示",Content=(name .. "启动成功。"),Type="success",Duration=5});
	end});
end
for index, scriptInfo in ipairs(data['scriptlist']) do
	addscripts(scriptInfo.name, scriptInfo.link);
end
local playerteleporterTab = mainWindow:CreateTab({Name="玩家传送",HasIcon=true,IconName="contact-round"});
playerteleporterTab:AddTitle("玩家列表");
playerteleporterTab:AddDivider();
local playerButtons = {};
local function updatePlayerList()
	for playerName, button in pairs(playerButtons) do
		if (button and button.Destroy) then
			button:Destroy();
		end
	end
	playerButtons = {};
	for _, player in ipairs(Players:GetPlayers()) do
		if (player ~= LocalPlayer) then
			local button = playerteleporterTab:AddButton({Text=(player.DisplayName .. " (" .. player.Name .. ")"),Callback=function()
				local character = LocalPlayer.Character;
				if (character and character:FindFirstChild("HumanoidRootPart")) then
					local targetCharacter = player.Character;
					if (targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")) then
						character:SetPrimaryPartCFrame(CFrame.new(targetCharacter.HumanoidRootPart.Position));
						ChronixUI:Notify({Title="传送成功",Content=("已传送到 " .. player.DisplayName),Type="success",Duration=2});
					else
						ChronixUI:Notify({Title="传送失败",Content="目标玩家角色不存在",Type="error",Duration=2});
					end
				else
					ChronixUI:Notify({Title="传送失败",Content="无法获取你的角色",Type="error",Duration=2});
				end
			end});
			playerButtons[player.Name] = button;
		end
	end
end
updatePlayerList();
local waypointTab = mainWindow:CreateTab({Name="路径点传送",HasIcon=true,IconName="map-pinned"});
local waypointConfig = ConfigModule.createconfig("waypoint/data/" .. game.GameId);
local waypointsData = (waypointConfig.waypointsData and waypointConfig.waypointsData) or {};
local waypointUIElements = {};
local function clearWaypointList()
	for _, elements in ipairs(waypointUIElements) do
		for _, element in ipairs(elements) do
			if (element and element.Destroy) then
				element:Destroy();
			end
		end
	end
	waypointUIElements = {};
end
local function refreshWaypointList()
	clearWaypointList();
	for _, waypoint in ipairs(waypointsData) do
		local elements = {};
		if (waypoint.id > 1) then
			local divider = waypointTab:AddDivider();
			table.insert(elements, divider);
		end
		local idNum = tonumber(waypoint.id) or 0;
		local noteStr = ((type(waypoint.note) == "string") and waypoint.note) or tostring(waypoint.note);
		local titleText = string.format("📍 路径点 #%d", idNum);
		if (noteStr ~= "") then
			titleText = titleText .. " - " .. noteStr;
		end
		local title = waypointTab:AddTitle(titleText);
		table.insert(elements, title);
		local pos = waypoint.position;
		local x = (pos and pos.X) or 0;
		local y = (pos and pos.Y) or 0;
		local z = (pos and pos.Z) or 0;
		local coordText = string.format("坐标: X: %.1f, Y: %.1f, Z: %.1f", x, y, z);
		local coordLabel = waypointTab:AddLabel(coordText);
		table.insert(elements, coordLabel);
		local noteInput = waypointTab:AddInput({Label="备注",Placeholder="输入备注信息...",Default=noteStr,Callback=function(text)
			waypoint.note = text or "";
			refreshWaypointList();
		end});
		table.insert(elements, noteInput);
		local teleportBtn = waypointTab:AddButton({Text="🚀 传送到此路径点",Callback=function()
			local char = LocalPlayer.Character;
			if (char and char:FindFirstChild("HumanoidRootPart")) then
				char:SetPrimaryPartCFrame(CFrame.new(pos));
				ChronixUI:Notify({Title="传送成功",Content=string.format("已传送到 %s", ((noteStr ~= "") and noteStr) or "路径点"),Type="success",Duration=2});
			else
				ChronixUI:Notify({Title="传送失败",Content="无法获取你的角色",Type="error",Duration=2});
			end
		end});
		table.insert(elements, teleportBtn);
		local deleteBtn = waypointTab:AddButton({Text="🗑️ 删除此路径点",Callback=function()
			for i, data in ipairs(waypointsData) do
				if (data['id'] == waypoint.id) then
					table.remove(waypointsData, i);
					break;
				end
			end
			for i, data in ipairs(waypointsData) do
				data['id'] = i;
			end
			refreshWaypointList();
			ChronixUI:Notify({Title="已删除",Content="路径点已移除",Type="info",Duration=1});
		end});
		table.insert(elements, deleteBtn);
		table.insert(waypointUIElements, elements);
	end
	waypointConfig.waypointsData = waypointsData;
end
local function addWaypoint(pos, note)
	local posTable = {X=pos.X,Y=pos.Y,Z=pos.Z};
	local waypoint = {id=(#waypointsData + 1),position=posTable,note=(note or "")};
	table.insert(waypointsData, waypoint);
	refreshWaypointList();
end
waypointTab:AddTitle("路径点管理");
waypointTab:AddDivider();
waypointTab:AddLabel("点击下方按钮保存当前位置作为路径点");
waypointTab:AddButton({Text="➕ 添加当前路径点",Callback=function()
	if (LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart) then
		local position = LocalPlayer.Character.HumanoidRootPart.Position;
		addWaypoint(position);
		ChronixUI:Notify({Title="路径点已添加",Content=string.format("位置: (%.1f, %.1f, %.1f)", position.X, position.Y, position.Z),Type="success",Duration=2});
	else
		ChronixUI:Notify({Title="添加失败",Content="无法获取当前位置",Type="error",Duration=2});
	end
end});
waypointTab:AddDivider();
waypointTab:AddTitle("已保存的路径点");
waypointTab:AddDivider();
if (#waypointsData > 0) then
	refreshWaypointList();
end
local musicTab = mainWindow:CreateTab({Name="音乐播放器",HasIcon=true,IconName="music"});
musicTab:AddTitle("音乐播放器");
musicTab:AddDivider();
musicTab:AddLabel("选择预设音乐 (rbxassetid)");
local musicDropdown = musicTab:AddDropdown({Label="预设音乐ID",Options=data['basicdata']['otherdata']['musicData']['musicIds'],Default=data['basicdata']['otherdata']['musicData']['currentId'],Callback=function(selected)
	data['basicdata']['otherdata']['musicData']['currentId'] = selected;
	if customIdInput then
		local textBox = customIdInput:FindFirstChildOfClass("TextBox");
		if textBox then
			textBox.Text = selected;
		end
	end
end});
musicTab:AddDivider();
musicTab:AddLabel("或手动输入自定义ID");
local customIdInput = musicTab:AddInput({Label="自定义音乐ID",Default=data['basicdata']['otherdata']['musicData']['currentId'],Placeholder="输入 rbxassetid，例如: 142376088",Callback=function(text)
	if (text and (text ~= "")) then
		data['basicdata']['otherdata']['musicData']['currentId'] = text;
	end
end});
musicTab:AddDivider();
musicTab:AddLabel("播放控制");
local playStopButton = nil;
local pauseResumeButton = nil;
playStopButton = musicTab:AddButton({Text="▶️ 播放",Callback=function()
	if data['basicdata']['otherdata']['musicData']['isPlay'] then
		data['basicdata']['otherdata']['musicbox']:Stop();
		data['basicdata']['otherdata']['musicData']['isPlay'] = false;
		data['basicdata']['otherdata']['musicData']['isPause'] = false;
		playStopButton.Text = "▶️ 播放";
		if pauseResumeButton then
			pauseResumeButton.Text = "⏸️ 暂停";
		end
		ChronixUI:Notify({Title="已停止",Content="音乐播放已停止",Type="info",Duration=2});
	else
		local soundId = "rbxassetid://" .. data['basicdata']['otherdata']['musicData']['currentId'];
		data['basicdata']['otherdata']['musicbox']['SoundId'] = soundId;
		local success, productInfo = pcall(function()
			return MarketplaceService:GetProductInfo(tonumber(data['basicdata']['otherdata']['musicData']['currentId']));
		end);
		if (success and productInfo) then
			data['basicdata']['otherdata']['musicbox']:Play();
			data['basicdata']['otherdata']['musicData']['isPlay'] = true;
			data['basicdata']['otherdata']['musicData']['isPause'] = false;
			playStopButton.Text = "⏹️ 停止";
			if pauseResumeButton then
				pauseResumeButton.Text = "⏸️ 暂停";
			end
			ChronixUI:Notify({Title="正在播放",Content=(productInfo.Name .. "\n" .. (productInfo.Description or "")),Type="info",Duration=3});
		else
			ChronixUI:Notify({Title="播放失败",Content=(data['basicdata']['otherdata']['musicData']['currentId'] .. "\n不是一个有效的rbxassetid"),Type="error",Duration=3});
			data['basicdata']['otherdata']['musicData']['isPlay'] = false;
		end
	end
end});
pauseResumeButton = musicTab:AddButton({Text="⏸️ 暂停",Callback=function()
	if not data['basicdata']['otherdata']['musicData']['isPlay'] then
		ChronixUI:Notify({Title="无法操作",Content="请先播放音乐",Type="warning",Duration=2});
		return;
	end
	if data['basicdata']['otherdata']['musicData']['isPause'] then
		data['basicdata']['otherdata']['musicbox']['TimePosition'] = data['basicdata']['otherdata']['musicData']['PlayLocation'];
		data['basicdata']['otherdata']['musicbox']:Play();
		data['basicdata']['otherdata']['musicData']['isPause'] = false;
		pauseResumeButton.Text = "⏸️ 暂停";
		ChronixUI:Notify({Title="继续播放",Content="音乐已恢复",Type="info",Duration=1});
	else
		data['basicdata']['otherdata']['musicData']['PlayLocation'] = data['basicdata']['otherdata']['musicbox']['TimePosition'];
		data['basicdata']['otherdata']['musicbox']:Stop();
		data['basicdata']['otherdata']['musicData']['isPause'] = true;
		pauseResumeButton.Text = "▶️ 继续";
		ChronixUI:Notify({Title="已暂停",Content="音乐已暂停",Type="info",Duration=1});
	end
end});
loopButton = musicTab:AddButton({Text="🔄 循环播放",Callback=function()
	data['basicdata']['otherdata']['musicbox']['Looped'] = not data['basicdata']['otherdata']['musicbox']['Looped'];
	loopButton.Text = (data['basicdata']['otherdata']['musicbox']['Looped'] and "🔁 不循环播放") or "🔄 循环播放";
	ChronixUI:Notify({Title="设置已更改",Content=((data['basicdata']['otherdata']['musicbox']['Looped'] and "已开启循环播放") or "已关闭循环播放"),Type="info",Duration=1});
end});
musicTab:AddDivider();
musicTab:AddLabel("音量控制");
local volumeLabel = musicTab:AddLabel(string.format("当前音量: %.0f%%", data['basicdata']['otherdata']['musicbox']['Volume'] * 100));
musicTab:AddButton({Text="🔊 音量 +",Callback=function()
	if (data['basicdata']['otherdata']['musicbox']['Volume'] < 1) then
		data['basicdata']['otherdata']['musicbox']['Volume'] = math.min(1, data['basicdata']['otherdata']['musicbox']['Volume'] + 0.1);
		volumeLabel.Text = string.format("当前音量: %.0f%%", data['basicdata']['otherdata']['musicbox']['Volume'] * 100);
	end
end});
musicTab:AddButton({Text="🔉 音量 -",Callback=function()
	if (data['basicdata']['otherdata']['musicbox']['Volume'] > 0) then
		data['basicdata']['otherdata']['musicbox']['Volume'] = math.max(0, data['basicdata']['otherdata']['musicbox']['Volume'] - 0.1);
		volumeLabel.Text = string.format("当前音量: %.0f%%", data['basicdata']['otherdata']['musicbox']['Volume'] * 100);
	end
end});
musicTab:AddDivider();
musicTab:AddLabel("音高控制");
local pitchLabel = musicTab:AddLabel(string.format("当前音高: %.1f", data['basicdata']['otherdata']['musicbox']['Pitch']));
musicTab:AddButton({Text="🎵 音高 +",Callback=function()
	data['basicdata']['otherdata']['musicbox']['Pitch'] = data['basicdata']['otherdata']['musicbox']['Pitch'] + 0.1;
	pitchLabel.Text = string.format("当前音高: %.1f", data['basicdata']['otherdata']['musicbox']['Pitch']);
end});
musicTab:AddButton({Text="🎵 音高 -",Callback=function()
	if (data['basicdata']['otherdata']['musicbox']['Pitch'] > 0.1) then
		data['basicdata']['otherdata']['musicbox']['Pitch'] = data['basicdata']['otherdata']['musicbox']['Pitch'] - 0.1;
		pitchLabel.Text = string.format("当前音高: %.1f", data['basicdata']['otherdata']['musicbox']['Pitch']);
	end
end});
musicTab:AddButton({Text="🔄 重置音高",Callback=function()
	data['basicdata']['otherdata']['musicbox']['Pitch'] = 1;
	pitchLabel.Text = string.format("当前音高: %.1f", data['basicdata']['otherdata']['musicbox']['Pitch']);
end});
musicTab:AddDivider();
musicTab:AddLabel("💡 提示：可从下拉框选择预设音乐，或手动输入自定义ID");
musicTab:AddLabel("📝 自定义ID格式：纯数字，如 142376088");
local audioCheckerTab = mainWindow:CreateTab({Name="音频检查器",HasIcon=true,IconName="audio-waveform"});
local selectedIdLabel = nil;
local testIdLabel = nil;
local function getAllSounds(parent)
	local sounds = {};
	for _, child in ipairs(parent:GetDescendants()) do
		if child:IsA("Sound") then
			table.insert(sounds, child);
		end
	end
	return sounds;
end
local function extractSoundIdNumber(soundId)
	local number = string.match(soundId, "rbxassetid://(%d+)");
	return number or soundId;
end
local function getLoudSounds(threshold)
	local loudSounds = {};
	local allSounds = getAllSounds(game);
	for _, sound in ipairs(allSounds) do
		if (sound.IsPlaying and (sound.PlaybackLoudness > threshold)) then
			local cleanSoundId = extractSoundIdNumber(sound.SoundId);
			table.insert(loudSounds, {SoundId=sound.SoundId,CleanSoundId=cleanSoundId,Name=sound.Name,Volume=sound.Volume,Loudness=sound.PlaybackLoudness,VolumeDB=sound.PlaybackLoudness,Parent=((sound.Parent and sound.Parent.Name) or "Unknown"),FullPath=sound:GetFullName()});
		end
	end
	return loudSounds;
end
local function clearAudioList()
	for _, item in ipairs(data['basicdata']['otherdata']['audioData']['audioListItems']) do
		if (item and item.Destroy) then
			item:Destroy();
		end
	end
	data['basicdata']['otherdata']['audioData']['audioListItems'] = {};
end
local function refreshAudioList()
	if not data['basicdata']['otherdata']['audioData']['enable'] then
		return;
	end
	clearAudioList();
	local loudSounds = getLoudSounds(data['basicdata']['otherdata']['audioData']['threshold']);
	if (#loudSounds == 0) then
		local emptyLabel = audioCheckerTab:AddLabel("未检测到超过阈值的音频");
		table.insert(data['basicdata']['otherdata']['audioData']['audioListItems'], emptyLabel);
	else
		for _, soundInfo in ipairs(loudSounds) do
			local displayText = string.format("ID: %s | 响度: %.1f dB | 来源: %s", soundInfo.CleanSoundId or "未知", soundInfo.Loudness, soundInfo.Parent);
			local soundButton = audioCheckerTab:AddButton({Text=displayText,Callback=function()
				if soundInfo.CleanSoundId then
					data['basicdata']['otherdata']['audioData']['currentSelectedId'] = soundInfo.CleanSoundId;
					if selectedIdLabel then
						selectedIdLabel.Text = "当前选中: " .. soundInfo.CleanSoundId;
					end
					if testIdLabel then
						testIdLabel.Text = "测试ID: " .. soundInfo.CleanSoundId;
					end
					ChronixUI:Notify({Title="已选中",Content=("音频ID: " .. soundInfo.CleanSoundId .. "\n来源: " .. soundInfo.FullPath),Type="info",Duration=3});
				end
			end});
			table.insert(data['basicdata']['otherdata']['audioData']['audioListItems'], soundButton);
		end
	end
end
local function startAudioScanning()
	if data['basicdata']['otherdata']['audioData']['scanConnection'] then
		data['basicdata']['otherdata']['audioData']['scanConnection']:Disconnect();
		data['basicdata']['otherdata']['audioData']['scanConnection'] = nil;
	end
	if data['basicdata']['otherdata']['audioData']['enable'] then
		refreshAudioList();
		data['basicdata']['otherdata']['audioData']['scanConnection'] = RunService.Heartbeat:Connect(function()
			if not data['basicdata']['otherdata']['audioData']['enable'] then
				if data['basicdata']['otherdata']['audioData']['scanConnection'] then
					data['basicdata']['otherdata']['audioData']['scanConnection']:Disconnect();
					data['basicdata']['otherdata']['audioData']['scanConnection'] = nil;
				end
				return;
			end
			local currentTime = tick();
			if ((currentTime - data['basicdata']['otherdata']['audioData']['lastScanTime']) >= 1) then
				data['basicdata']['otherdata']['audioData']['lastScanTime'] = currentTime;
				refreshAudioList();
			end
		end);
	end
end
audioCheckerTab:AddTitle("音频检查器");
audioCheckerTab:AddLabel("筛选响度阈值 (建议10-50)");
local thresholdInput = audioCheckerTab:AddInput({Label="响度阈值",Default=tostring(data['basicdata']['otherdata']['audioData']['threshold']),Placeholder="输入阈值，例如: 30",Callback=function(text)
	local num = tonumber(text);
	if num then
		data['basicdata']['otherdata']['audioData']['threshold'] = math.clamp(num, 0, 1000);
		if data['basicdata']['otherdata']['audioData']['enable'] then
			refreshAudioList();
		end
	end
end});
audioCheckerTab:AddDivider();
audioCheckerTab:AddTitle("操作面板");
audioCheckerTab:AddToggle({Label="开始检测音频",Default=false,Callback=function(v)
	data['basicdata']['otherdata']['audioData']['enable'] = v;
	if v then
		data['basicdata']['otherdata']['audioData']['lastScanTime'] = tick();
		startAudioScanning();
		ChronixUI:Notify({Title="已开启",Content="开始检测游戏中播放的音频",Type="success",Duration=2});
	else
		if data['basicdata']['otherdata']['audioData']['scanConnection'] then
			data['basicdata']['otherdata']['audioData']['scanConnection']:Disconnect();
			data['basicdata']['otherdata']['audioData']['scanConnection'] = nil;
		end
		ChronixUI:Notify({Title="已关闭",Content="音频检测已停止",Type="info",Duration=2});
	end
end});
audioCheckerTab:AddDivider();
selectedIdLabel = audioCheckerTab:AddLabel("当前选中: 无");
audioCheckerTab:AddButton({Text="📋 复制选中ID到剪贴板",Callback=function()
	if data['basicdata']['otherdata']['audioData']['currentSelectedId'] then
		setclipboard(data['basicdata']['otherdata']['audioData']['currentSelectedId']);
		ChronixUI:Notify({Title="已复制",Content=(data['basicdata']['otherdata']['audioData']['currentSelectedId'] .. " 已复制到剪贴板"),Type="info",Duration=2});
	else
		ChronixUI:Notify({Title="未选中",Content="请先点击音频列表中的项目",Type="warning",Duration=2});
	end
end});
audioCheckerTab:AddDivider();
audioCheckerTab:AddTitle("测试播放");
testIdLabel = audioCheckerTab:AddLabel("测试ID: 未选择");
testPlayButton = audioCheckerTab:AddButton({Text="🎵 尝试播放",Callback=function()
	if not data['basicdata']['otherdata']['audioData']['currentSelectedId'] then
		ChronixUI:Notify({Title="无法播放",Content="请先选中一个音频ID",Type="warning",Duration=2});
		return;
	end
	if data['basicdata']['otherdata']['audioData']['isTesting'] then
		data['basicdata']['otherdata']['testSound']:Stop();
		data['basicdata']['otherdata']['audioData']['isTesting'] = false;
		testPlayButton.Text = "🎵 尝试播放";
		ChronixUI:Notify({Title="已停止",Content="测试播放已停止",Type="info",Duration=1});
	else
		local soundId = "rbxassetid://" .. data['basicdata']['otherdata']['audioData']['currentSelectedId'];
		data['basicdata']['otherdata']['testSound']['SoundId'] = soundId;
		local success, productInfo = pcall(function()
			return MarketplaceService:GetProductInfo(tonumber(data['basicdata']['otherdata']['audioData']['currentSelectedId']));
		end);
		if (success and productInfo) then
			data['basicdata']['otherdata']['testSound']:Play();
			data['basicdata']['otherdata']['audioData']['isTesting'] = true;
			testPlayButton.Text = "⏹️ 结束播放";
			testIdLabel.Text = "测试ID: " .. data['basicdata']['otherdata']['audioData']['currentSelectedId'];
			ChronixUI:Notify({Title="正在播放",Content=productInfo.Name,Type="info",Duration=2});
			data['basicdata']['otherdata']['testSound']['Ended']:Connect(function()
				if data['basicdata']['otherdata']['audioData']['isTesting'] then
					data['basicdata']['otherdata']['audioData']['isTesting'] = false;
					testPlayButton.Text = "🎵 尝试播放";
				end
			end);
		else
			ChronixUI:Notify({Title="播放失败",Content=(data['basicdata']['otherdata']['audioData']['currentSelectedId'] .. " 不是一个有效的音频ID"),Type="error",Duration=2});
		end
	end
end});
audioCheckerTab:AddDivider();
audioCheckerTab:AddTitle("检测到的音频");
audioCheckerTab:AddLabel("点击任意音频可选中并复制ID");
audioCheckerTab:AddDivider();
audioCheckerTab:AddLabel("💡 提示：阈值越低，检测到的音频越多");
audioCheckerTab:AddLabel("🎵 建议阈值设置在 10-30 之间获得最佳效果");
local chatReceiverTab = mainWindow:CreateTab({Name="聊天接收器",HasIcon=true,IconName="messages-square"});
local chatMessages = {};
local function clearChatMessages()
	for _, element in ipairs(chatMessages) do
		if (element and element.Destroy) then
			element:Destroy();
		end
	end
	chatMessages = {};
end
local function addChatMessage(sender, text)
	local messageText = sender .. ": " .. text;
	local messageLabel = chatReceiverTab:AddLabel(messageText);
	table.insert(chatMessages, messageLabel);
	local copyButton = chatReceiverTab:AddButton({Text="📋 复制这条消息",Callback=function()
		local fullText = sender .. ": " .. text;
		setclipboard(fullText);
		ChronixUI:Notify({Title="已复制",Content="消息已复制到剪贴板",Type="info",Duration=2});
	end});
	table.insert(chatMessages, copyButton);
	local divider = chatReceiverTab:AddDivider();
	table.insert(chatMessages, divider);
end
chatReceiverTab:AddTitle("📨 聊天接收器");
chatReceiverTab:AddDivider();
chatReceiverTab:AddLabel("实时接收游戏中所有玩家的聊天消息");
chatReceiverTab:AddDivider();
chatReceiverTab:AddTitle("消息列表");
chatReceiverTab:AddButton({Text="🗑️ 清空所有消息",Callback=function()
	clearChatMessages();
	ChronixUI:Notify({Title="已清空",Content="所有聊天消息已清除",Type="info",Duration=1});
end});
chatReceiverTab:AddDivider();
chatReceiverTab:AddLabel("💡 提示：点击消息下方的按钮可复制该条消息");
local executerTab = mainWindow:CreateTab({Name="执行器",HasIcon=true,IconName="braces"});
executerTab:AddTitle("执行器");
executerTab:AddInput({Label="请输入代码",Placeholder="",Callback=function(text)
	data['basicdata']['releasetools']['executecode'] = text;
end});
executerTab:AddButton({Text="执行",Callback=function()
	if (data['basicdata']['releasetools']['executecode'] and (data['basicdata']['releasetools']['executecode'] ~= "")) then
		local success, errorMessage = pcall(function()
			loadstring(data['basicdata']['releasetools']['executecode'])();
		end);
		if not success then
			ChronixUI:Notify({Title="错误",Content=("脚本执行失败: " .. errorMessage),Type="error",Duration=5});
		else
			ChronixUI:Notify({Title="提示",Content="脚本执行成功!",Type="success",Duration=5});
		end
	else
		ChronixUI:Notify({Title="错误",Content="请输入有效的脚本!",Type="error",Duration=5});
	end
end});
local filterTab = mainWindow:CreateTab({Name="滤镜控制器",HasIcon=true,IconName="sparkles"});
local dynamicControls = {};
local staticControls = {};
local function refreshFilterList(showNotification)
	for _, control in ipairs(dynamicControls) do
		if (control and control.Destroy) then
			pcall(function()
				control:Destroy();
			end);
		end
	end
	dynamicControls = {};
	local allEffects = getAllPostEffects();
	local colorCorrection = getColorCorrectionEffect();
	if (#allEffects == 0) then
		local noEffectLabel = filterTab:AddLabel("未检测到任何后处理特效");
		table.insert(dynamicControls, noEffectLabel);
		return;
	end
	local titleLabel = filterTab:AddTitle("后处理特效开关");
	table.insert(dynamicControls, titleLabel);
	for _, effect in ipairs(allEffects) do
		local displayName = string.format("%s (%s)", effect.Name, effect.ClassName);
		local toggle = filterTab:AddToggle({Label=displayName,Default=effect.Enabled,Callback=function(enabled)
			effect.Enabled = enabled;
			local status = (enabled and "启用") or "禁用";
			ChronixUI:Notify({Title="滤镜状态",Content=(effect.Name .. " 已" .. status),Type=((enabled and "success") or "info"),Duration=2});
		end});
		table.insert(dynamicControls, toggle);
	end
	if colorCorrection then
		local divider = filterTab:AddDivider();
		table.insert(dynamicControls, divider);
		local colorTitle = filterTab:AddTitle("颜色微调");
		table.insert(dynamicControls, colorTitle);
		local saturationSlider = filterTab:AddSlider({Label="饱和度 (Saturation)",Min=-1,Max=1,Default=colorCorrection.Saturation,Callback=function(value)
			colorCorrection.Saturation = value;
		end});
		table.insert(dynamicControls, saturationSlider);
		local brightnessSlider = filterTab:AddSlider({Label="亮度 (Brightness)",Min=-1,Max=1,Default=colorCorrection.Brightness,Callback=function(value)
			colorCorrection.Brightness = value;
		end});
		table.insert(dynamicControls, brightnessSlider);
		local contrastSlider = filterTab:AddSlider({Label="对比度 (Contrast)",Min=-1,Max=1,Default=colorCorrection.Contrast,Callback=function(value)
			colorCorrection.Contrast = value;
		end});
		table.insert(dynamicControls, contrastSlider);
		local tintColorPicker = filterTab:AddColorPicker({Label="色调颜色 (TintColor)",Default=colorCorrection.TintColor,Callback=function(color)
			colorCorrection.TintColor = color;
		end});
		table.insert(dynamicControls, tintColorPicker);
	end
	local resetDivider = filterTab:AddDivider();
	table.insert(dynamicControls, resetDivider);
	local resetButton = filterTab:AddButton({Text="重置所有滤镜为默认状态",Callback=function()
		for _, effect in ipairs(getAllPostEffects()) do
			effect.Enabled = true;
			if effect:IsA("ColorCorrectionEffect") then
				effect.Saturation = 0;
				effect.Brightness = 0;
				effect.Contrast = 0;
				effect.TintColor = Color3.new(1, 1, 1);
			end
		end
		ChronixUI:Notify({Title="滤镜控制器",Content="所有滤镜已重置为默认状态",Type="success",Duration=3});
		refreshFilterList(true);
	end});
	table.insert(dynamicControls, resetButton);
	local colorBlindDivider = filterTab:AddDivider();
	table.insert(dynamicControls, colorBlindDivider);
	local colorBlindTitle = filterTab:AddTitle("🎨 色盲模拟器");
	table.insert(dynamicControls, colorBlindTitle);
	local colorBlindModes = {{name="正常",config={Saturation=0,Brightness=0,Contrast=0,TintColor=Color3.new(1, 1, 1)}},{name="红色弱",config={Saturation=-0.3,Brightness=0,Contrast=0.1,TintColor=Color3.new(0.85, 1, 1)}},{name="红色盲",config={Saturation=-0.5,Brightness=0,Contrast=0.2,TintColor=Color3.new(0.7, 1, 1)}},{name="绿色弱",config={Saturation=-0.3,Brightness=0,Contrast=0.1,TintColor=Color3.new(1, 0.85, 1)}},{name="绿色盲",config={Saturation=-0.5,Brightness=0,Contrast=0.2,TintColor=Color3.new(1, 0.7, 1)}},{name="蓝色弱",config={Saturation=-0.3,Brightness=0.1,Contrast=0.1,TintColor=Color3.new(1, 1, 0.85)}},{name="蓝色盲",config={Saturation=-0.5,Brightness=0.1,Contrast=0.2,TintColor=Color3.new(1, 1, 0.7)}},{name="全色弱",config={Saturation=-0.8,Brightness=0,Contrast=0.3,TintColor=Color3.new(0.9, 0.9, 0.9)}},{name="全色盲",config={Saturation=-1,Brightness=0,Contrast=0.5,TintColor=Color3.new(0.8, 0.8, 0.8)}}};
	local currentColorBlindMode = "正常";
	local function applyColorBlindMode(modeConfig)
		local colorCorrection = getColorCorrectionEffect();
		if not colorCorrection then
			colorCorrection = Instance.new("ColorCorrectionEffect");
			colorCorrection.Name = "ChronixHub_ColorCorrection";
			colorCorrection.Parent = Lighting;
		end
		colorCorrection.Enabled = true;
		colorCorrection.Saturation = modeConfig.Saturation;
		colorCorrection.Brightness = modeConfig.Brightness;
		colorCorrection.Contrast = modeConfig.Contrast;
		colorCorrection.TintColor = modeConfig.TintColor;
	end
	local modeNames = {};
	for _, mode in ipairs(colorBlindModes) do
		table.insert(modeNames, mode.name);
	end
	local colorBlindDropdown = filterTab:AddDropdown({Label="选择色盲模式",Options=modeNames,Default="正常",Callback=function(selected)
		currentColorBlindMode = selected;
		for _, mode in ipairs(colorBlindModes) do
			if (mode.name == selected) then
				applyColorBlindMode(mode.config);
				ChronixUI:Notify({Title="色盲模拟器",Content=("已切换到: " .. selected),Type="info",Duration=2});
				break;
			end
		end
	end});
	table.insert(dynamicControls, colorBlindDropdown);
	local colorBlindNote = filterTab:AddLabel("💡 选择一种色盲模式来模拟对应的视觉体验");
	table.insert(dynamicControls, colorBlindNote);
	if mainWindow.RefreshContent then
		mainWindow:RefreshContent();
	end
	if (showNotification == true) then
		ChronixUI:Notify({Title="滤镜控制器",Content=("已刷新，找到 " .. #allEffects .. " 个特效"),Type="success",Duration=2});
	end
end
local refreshButton = filterTab:AddButton({Text="手动刷新滤镜列表",Callback=function()
	refreshFilterList(true);
end});
table.insert(staticControls, refreshButton);
local staticDivider = filterTab:AddDivider();
table.insert(staticControls, staticDivider);
refreshFilterList(false);
local playertitleTab = mainWindow:CreateTab({Name="自定义称号",HasIcon=true,IconName="tag"});
playertitleTab:AddTitle("自定义你的称号");
playertitleTab:AddToggle({Label="功能开关",Default=false,Callback=function(v)
	if v then
		data['basicdata']['otherdata']['playertitle']['tag']:enable();
	else
		data['basicdata']['otherdata']['playertitle']['tag']:disable();
	end
end});
playertitleTab:AddInput({Label="称号文本",Placeholder="",Default=data['basicdata']['otherdata']['playertitle']['text'],Callback=function(text)
	data['basicdata']['otherdata']['playertitle']['text'] = text;
end});
playertitleTab:AddColorPicker({Label="称号颜色",Default=hexToColor3(data['basicdata']['otherdata']['playertitle']['color']),Callback=function(color)
	data['basicdata']['otherdata']['playertitle']['color'] = color3ToHex(color);
end});
playertitleTab:AddSlider({Label="字号",Min=1,Max=50,Default=data['basicdata']['otherdata']['playertitle']['size'],Callback=function(v)
	data['basicdata']['otherdata']['playertitle']['size'] = v;
end});
playertitleTab:AddToggle({Label="加粗",Default=false,Callback=function(v)
	data['basicdata']['otherdata']['playertitle']['bold'] = v;
end});
playertitleTab:AddToggle({Label="倾斜",Default=false,Callback=function(v)
	data['basicdata']['otherdata']['playertitle']['italic'] = v;
end});
playertitleTab:AddInput({Label="字体",Placeholder="",Default=data['basicdata']['otherdata']['playertitle']['font'],Callback=function(text)
	data['basicdata']['otherdata']['playertitle']['font'] = text;
end});
playertitleTab:AddButton({Text="应用更改",Callback=function()
	data['basicdata']['otherdata']['playertitle']['tag']:update({text=data['basicdata']['otherdata']['playertitle']['text'],color=data['basicdata']['otherdata']['playertitle']['color'],size=data['basicdata']['otherdata']['playertitle']['size'],bold=data['basicdata']['otherdata']['playertitle']['bold'],italic=data['basicdata']['otherdata']['playertitle']['italic'],font=data['basicdata']['otherdata']['playertitle']['font']});
end});
local serverQuery = ServerFinderModule.new();
local serverTab = mainWindow:CreateTab({Name="服务器查询",HasIcon=true,IconName="server"});
serverTab:AddTitle("公共服务器列表");
local serverUIElements = {};
local function clearServerList()
	for _, elementList in ipairs(serverUIElements) do
		for _, element in ipairs(elementList) do
			if (element and element.Destroy) then
				element:Destroy();
			end
		end
	end
	table.clear(serverUIElements);
end
local isRefreshing = false;
local function refreshServerList()
	if isRefreshing then
		ChronixUI:Notify({Title="提示",Content="正在刷新中，请稍候...",Type="warning",Duration=2});
		return;
	end
	clearServerList();
	isRefreshing = true;
	local loadingLabel = serverTab:AddLabel("⏳ 正在获取服务器列表...");
	table.insert(serverUIElements, {loadingLabel});
	serverQuery:refreshAsync(function(servers)
		isRefreshing = false;
		if (loadingLabel and loadingLabel.Destroy) then
			loadingLabel:Destroy();
		end
		clearServerList();
		if (#servers == 0) then
			local emptyLabel = serverTab:AddLabel("⚠️ 没有找到公共服务器，或 API 出错。");
			table.insert(serverUIElements, {emptyLabel});
			return;
		end
		local infoLabel = serverTab:AddLabel("点击下方按钮可加入对应服务器");
		table.insert(serverUIElements, {infoLabel});
		local divider1 = serverTab:AddDivider();
		table.insert(serverUIElements, {divider1});
		for _, serverData in ipairs(servers) do
			local entryElements = {};
			local players = serverData.playing or 0;
			local maxPlayers = serverData.maxPlayers or 0;
			local ping = serverData.ping or 0;
			local fps = ((ping > 0) and math.floor(1000 / ping)) or 0;
			local quality = "普通";
			if (ping > 250) then
				quality = "差";
			elseif (ping < 100) then
				quality = "好";
			end
			local infoText = string.format("玩家: %d/%d | Ping: %dms | 质量: %s", players, maxPlayers, ping, quality);
			local sInfoLabel = serverTab:AddLabel(infoText);
			table.insert(entryElements, sInfoLabel);
			local idLabel = serverTab:AddLabel("ID: " .. tostring(serverData.id));
			table.insert(entryElements, idLabel);
			local joinBtn = serverTab:AddButton({Text="🚀 加入此服务器",Callback=function()
				local ok, err = pcall(function()
					TeleportService:TeleportToPlaceInstance(game.PlaceId, serverData.id, LocalPlayer);
				end);
				if not ok then
					ChronixUI:Notify({Title="传送失败",Content=("无法加入服务器: " .. tostring(err)),Type="error",Duration=3});
				end
			end});
			table.insert(entryElements, joinBtn);
			local sDivider = serverTab:AddDivider();
			table.insert(entryElements, sDivider);
			table.insert(serverUIElements, entryElements);
		end
		if mainWindow.RefreshContent then
			mainWindow:RefreshContent();
		end
	end);
end
serverTab:AddButton({Text="🔄 刷新服务器列表",Callback=function()
	refreshServerList();
end});
serverTab:AddDivider();
serverTab:AddLabel("💡 点击刷新按钮获取当前游戏的公共服务器");
serverTab:AddLabel("⚠️ 服务器数据来自 Roblox 官方 API，可能会有延迟");
refreshServerList();
local hankerTab = mainWindow:CreateTab({Name="恶劣功能",HasIcon=true,IconName="shield-alert"});
hankerTab:AddTitle("使用此部分的功能会导致封号");
hankerTab:AddDivider();
hankerTab:AddLabel("普通功能");
hankerTab:AddToggle({Label="循环OOF",Default=false,Callback=function(v)
	if v then
		LoopOofModule.enable();
	else
		LoopOofModule.disable();
	end
end});
hankerTab:AddDivider();
hankerTab:AddLabel("背起了行囊");
hankerTab:AddInput({Label="旋转速度",Placeholder="",Default=20,Callback=function(text)
	data['basicdata']['hankermodule']['spin']['speed'] = tonumber(text);
	if SpinModule.isEnabled() then
		SpinModule.setSpeed(data['basicdata']['hankermodule']['spin']['speed']);
	end
end});
hankerTab:AddToggle({Label="开始旋转",Default=false,Callback=function(v)
	if v then
		SpinModule.enable(data['basicdata']['hankermodule']['spin']['speed']);
	else
		SpinModule.disable();
	end
end});
hankerTab:AddDivider();
hankerTab:AddLabel("击飞功能");
hankerTab:AddToggle({Label="旋转击飞",Default=false,Callback=function(v)
	if v then
		FlingModule.fling.enable();
	else
		FlingModule.fling.disable();
	end
end});
hankerTab:AddToggle({Label="飞行击飞",Default=false,Callback=function(v)
	if v then
		FlingModule.flyfling.enable(2);
	else
		FlingModule.flyfling.disable();
	end
end});
hankerTab:AddToggle({Label="走路击飞",Default=false,Callback=function(v)
	if v then
		FlingModule.walkfling.enable();
	else
		FlingModule.walkfling.disable();
	end
end});
hankerTab:AddToggle({Label="隐身击飞",Default=false,Callback=function(v)
	if v then
		FlingModule.invisfling.enable();
	else
		FlingModule.invisfling.disable();
	end
end});
hankerTab:AddDivider();
hankerTab:AddLabel("击杀玩家");
hankerTab:AddInput({Label="要击杀的玩家名",Placeholder="",Default="PlayerName",Callback=function(text)
	data['basicdata']['hankermodule']['hkill']['killname'] = text;
end});
hankerTab:AddInput({Label="距离",Placeholder="",Default=100,Callback=function(text)
	data['basicdata']['hankermodule']['hkill']['killrange'] = tonumber(text) or 100;
end});
hankerTab:AddToggle({Label="全部玩家",Default=false,Callback=function(v)
	data['basicdata']['hankermodule']['hkill']['killall'] = v;
end});
hankerTab:AddToggle({Label="全图",Default=false,Callback=function(v)
	data['basicdata']['hankermodule']['hkill']['killany'] = v;
end});
hankerTab:AddButton({Text="开始击杀",Callback=function()
	HandleKillModule.kill((data['basicdata']['hankermodule']['hkill']['killall'] and "All") or data['basicdata']['hankermodule']['hkill']['killname'], (data['basicdata']['hankermodule']['hkill']['killany'] and "Infinity") or data['basicdata']['hankermodule']['hkill']['killrange']);
end});
hankerTab:AddDivider();
local supportedgamesTab = mainWindow:CreateTab({Name="支持的游戏",HasIcon=true,IconName="swords"});
supportedgamesTab:AddTitle("支持的游戏");
for _, GetgameInfo in ipairs(data['Supported_Games']) do
	if GetgameInfo.gameid then
		supportedgamesTab:AddButton({Text=(GetgameInfo.name .. "(点击进入)"),Callback=function()
			if (game.GameId == GetgameInfo.gameid) then
				ChronixUI:Notify({Title="提示",Content="你已经在这个游戏里了。",Type="warning",Duration=5});
			else
				GameTeleport.teleportByGameId(GetgameInfo.gameid);
			end
		end});
	end
end
local weaoapiTab = mainWindow:CreateTab({Name="执行器查询",HasIcon=true,IconName="section"});
weaoapiTab:AddTitle("Roblox版本");
weaoapiTab:AddLabel("Windows: " .. data['basicdata']['otherdata']['executordetecter']['robloxinfo'].Windows);
weaoapiTab:AddLabel("Windows更新日期: " .. toChineseDate(data['basicdata']['otherdata']['executordetecter']['robloxinfo'].WindowsDate, true));
weaoapiTab:AddLabel("Mac: " .. data['basicdata']['otherdata']['executordetecter']['robloxinfo'].Mac);
weaoapiTab:AddLabel("Mac更新日期: " .. toChineseDate(data['basicdata']['otherdata']['executordetecter']['robloxinfo'].MacDate, true));
weaoapiTab:AddLabel("Android: " .. data['basicdata']['otherdata']['executordetecter']['robloxinfo'].Android);
weaoapiTab:AddLabel("Android更新日期: " .. toChineseDate(data['basicdata']['otherdata']['executordetecter']['robloxinfo'].AndroidDate, true));
weaoapiTab:AddLabel("iOS: " .. data['basicdata']['otherdata']['executordetecter']['robloxinfo'].iOS);
weaoapiTab:AddLabel("iOS更新日期: " .. toChineseDate(data['basicdata']['otherdata']['executordetecter']['robloxinfo'].iOSDate, true));
weaoapiTab:AddDivider();
weaoapiTab:AddTitle("执行器状态");
local executors = parseExecutors(data['basicdata']['otherdata']['executordetecter']['exploits']);
for _, exec in ipairs(executors) do
	weaoapiTab:AddTitle(string.format("[%s] %s (%s) | %s", exec.platform, exec.title, exec.version, (exec.updateStatus and "已更新(有效)") or "未更新(失效)"));
	weaoapiTab:AddLabel("类型:" .. exec.extType .. " | " .. ((exec.free and "免费") or ("付费(" .. exec.cost:gsub("Lifetime", "永久"):gsub("Weekly", "每周"):gsub("Monthly", "每月"):gsub("Private", "私人") .. ")")) .. " | " .. ((exec.detected and "已被检测") or "未被检测"));
	weaoapiTab:AddLabel(((exec.uncStatus and ("UNC: " .. (exec.uncPercent or 0) .. "%")) or "") .. ", sUNC: " .. (exec.suncPercent or 0) .. "%");
	weaoapiTab:AddLabel("更新时间:" .. exec.updatedDate);
	weaoapiTab:AddLabel("密钥系统: " .. ((exec.keysystem and "有") or "无") .. " 测试版:" .. ((exec.beta and "是") or "否") .. " 反编译器: " .. ((exec.decompiler and "有") or "无") .. " 多开支持: " .. ((exec.multiInject and "支持") or "不支持"));
	weaoapiTab:AddButton({Text=("官网: " .. exec.website),Callback=function()
		setclipboard(exec.website);
		ChronixUI:Notify({Title="提示",Content="已复制到剪切板",Type="info",Duration=5});
	end});
	weaoapiTab:AddButton({Text=("Discord: " .. exec.discord),Callback=function()
		setclipboard(exec.discord);
		ChronixUI:Notify({Title="提示",Content="已复制到剪切板",Type="info",Duration=5});
	end});
	weaoapiTab:AddDivider();
end
local genv = getgenv().ChronixUI;
if not genv then
	genv = {};
	getgenv().ChronixUI = genv;
end
if (WebSocket and WebSocket.connect) then
	task.spawn(function()
		pcall(function()
			genv.wsManager:Disconnect();
		end);
	end);
	local chatmessage = "";
	genv.wsManager = WebSocketManager.new();
	local IRCTab = mainWindow:CreateTab({Name="IRC",HasIcon=true,IconName="messages-square"});
	IRCTab:AddTitle("Hub聊天室");
	local connsuccessinfo = IRCTab:AddLabel("");
	local onlineplayernumber = IRCTab:AddLabel("在线玩家: 0");
	IRCTab:AddDivider();
	IRCTab:AddInput({Label="输入框",Placeholder="请输入文本...",Default="",Callback=function(text)
		chatmessage = text;
	end});
	IRCTab:AddButton({Text="发送",Callback=function()
		if (chatmessage == "") then
			ChronixUI:Notify({Title="提示",Content="无法发送空白内容。",Type="warning",Duration=5});
		else
			genv.wsManager:SendChatMessage(chatmessage);
		end
	end});
	IRCTab:AddDivider();
	genv.wsManager.OnConnectionChanged.Event:Connect(function(connected)
		if connected then
			connsuccessinfo.Text = "已连接到ChronixHub聊天服务器";
		else
			connsuccessinfo.Text = "未连接到ChronixHub聊天服务器";
		end
	end);
	local selfJoined = false;
	genv.wsManager.OnUserOnline.Event:Connect(function(userInfo)
		if not (selfJoined and (data['basicdata']['player']['userid'] == tonumber(userInfo.userId))) then
			selfJoined = true;
			IRCTab:AddLabel("🟢 " .. userInfo.username .. "加入了服务器。");
		end
	end);
	genv.wsManager.OnUserOffline.Event:Connect(function(userInfo)
		IRCTab:AddLabel("🔴 " .. userInfo.username .. "离开了服务器。");
	end);
	genv.wsManager.OnUserListUpdate.Event:Connect(function(users)
		onlineplayernumber.Text = "在线玩家: " .. #users;
	end);
	genv.wsManager.OnMessageReceived.Event:Connect(function(message)
		IRCTab:AddLabel(message.username .. ": " .. message.content);
	end);
	task.spawn(function()
		pcall(function()
			genv.wsManager:Connect();
		end);
	end);
end
for _, GetgameInfo in ipairs(data['Supported_Games']) do
	if (GetgameInfo.gameid == game.GameId) then
		local OtherGameTab = mainWindow:CreateTab({Name=GetgameInfo.name,HasIcon=true,IconName="gamepad-2"});
		OtherGameTab:AddTitle(GetgameInfo.name);
		if (GetgameInfo.name == "死亡球") then
			OtherGameTab:AddToggle({Label="主功能和界面",Default=false,Callback=function(v)
				if v then
					_G.DeathBallScript:Enable();
				else
					_G.DeathBallScript:Disable();
				end
			end});
		elseif (GetgameInfo.name == "小屋角色扮演") then
			OtherGameTab:AddButton({Text="变正常",Callback=function()
				ChatControl:chat("/re");
			end});
			OtherGameTab:AddButton({Text="变小孩",Callback=function()
				ChatControl:chat("/kid");
			end});
			OtherGameTab:AddButton({Text="鲨鱼服装",Callback=function()
				ChatControl:chat("/shark");
			end});
			OtherGameTab:AddButton({Text="修狗服装",Callback=function()
				ChatControl:chat("/dog");
			end});
			OtherGameTab:AddButton({Text="修猫服装",Callback=function()
				ChatControl:chat("/cat");
			end});
		elseif (GetgameInfo.name == "南极探险队") then
			OtherGameTab:AddLabel("基础操作");
			OtherGameTab:AddButton({Text="传送到 大本营",Callback=function()
				TeleportTo(-6015, -158, -35);
			end});
			OtherGameTab:AddButton({Text="传送到 营地1",Callback=function()
				TeleportTo(-3719, 226, 235);
			end});
			OtherGameTab:AddButton({Text="传送到 营地2",Callback=function()
				TeleportTo(1790, 106, -138);
			end});
			OtherGameTab:AddButton({Text="传送到 营地3",Callback=function()
				TeleportTo(5892, 321, -18);
			end});
			OtherGameTab:AddButton({Text="传送到 营地4",Callback=function()
				TeleportTo(8992, 596, 102);
			end});
			OtherGameTab:AddButton({Text="传送到 营地5",Callback=function()
				TeleportTo(10990, 550, 104);
			end});
			OtherGameTab:AddLabel("圣诞活动");
			OtherGameTab:AddButton({Text="获取所有礼物",Callback=function()
				loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/SouthExpedition_Christmas_getallgifts.lua"))();
			end});
			OtherGameTab:AddInput({Label="礼物号",Placeholder="",Callback=function(text)
				data['othergamedata']['AntarcticExpedition']['giftnumber'] = text;
			end});
			OtherGameTab:AddButton({Text="传送到礼物",Callback=function()
				TeleportToPresent(tonumber(data['othergamedata']['AntarcticExpedition']['giftnumber']));
			end});
		elseif (GetgameInfo.name == "西部森林") then
			OtherGameTab:AddToggle({Label="怪物标签",Default=false,Callback=function(v)
				if v then
					data['othergamedata']['west_wood']['monster']:enable();
				else
					data['othergamedata']['west_wood']['monster']:disable();
				end
			end});
		elseif (GetgameInfo.name == "警笛头:遗产") then
			OtherGameTab:AddToggle({Label="透视盒子",Default=false,Callback=function(v)
				if v then
					data['othergamedata']['sirenhead_legacy']['cratemodule'].apply();
					data['othergamedata']['sirenhead_legacy']['cratenametagmodule']:enable();
				else
					data['othergamedata']['sirenhead_legacy']['cratemodule'].destroy();
					data['othergamedata']['sirenhead_legacy']['cratenametagmodule']:disable();
				end
			end});
			OtherGameTab:AddToggle({Label="透视浆果",Default=false,Callback=function(v)
				if v then
					data['othergamedata']['sirenhead_legacy']['berrymodule'].apply();
					data['othergamedata']['sirenhead_legacy']['berrynametagmodule']:enable();
				else
					data['othergamedata']['sirenhead_legacy']['berrymodule'].destroy();
					data['othergamedata']['sirenhead_legacy']['berrynametagmodule']:disable();
				end
			end});
			OtherGameTab:AddButton({Text="传送到树顶",Callback=function()
				TeleportTo(69, 206, -72);
			end});
		elseif (GetgameInfo.name == "噩梦之行") then
			OtherGameTab:AddToggle({Label="高亮怪物",Default=false,Callback=function(v)
				if v then
					data['othergamedata']['nightmare_run']['monster']:enable();
				else
					data['othergamedata']['nightmare_run']['monster']:disable();
				end
			end});
			OtherGameTab:AddButton({Text="高亮芝士",Callback=function()
				data['othergamedata']['nightmare_run']['HLCheese'].apply();
			end});
			OtherGameTab:AddButton({Text="无敌(怪物不追不杀)",Callback=function()
				local ClientScripts = PlayerGui.ClientScripts;
				local Events = ReplicatedStorage.Events;
				if ClientScripts:FindFirstChild("SafeSpaceHandler") then
					ClientScripts.SafeSpaceHandler:Destroy();
				end
				LocalPlayer:SetAttribute("Safe", true);
				Events.SetAttributeEvent:FireServer("Safe", true);
				ChronixUI:Notify({Title="提示",Content="已设置玩家安全状态\n死亡前生效",Type="info",Duration=5});
			end});
		elseif (GetgameInfo.name == "兽化项目") then
			OtherGameTab:AddLabel("基础操作");
			local function deleteModelsByName(modelName, displayName)
				local deletedCount = 0;
				for _, model in ipairs(Workspace:GetDescendants()) do
					if (model:IsA("Model") and (model.Name == modelName)) then
						model:Destroy();
						deletedCount = deletedCount + 1;
					end
				end
				ChronixUI:Notify({Title="提示",Content=("已删除" .. deletedCount .. "个" .. displayName),Type="info",Duration=10});
			end
			OtherGameTab:AddButton({Text="删除捕兽夹",Callback=function()
				deleteModelsByName("__SnarePhysical", "捕兽夹");
			end});
			OtherGameTab:AddButton({Text="删除地雷",Callback=function()
				deleteModelsByName("Landmine", "地雷");
			end});
			OtherGameTab:AddButton({Text="删除阔剑地雷",Callback=function()
				deleteModelsByName("__ClaymorePhysical", "阔剑地雷");
			end});
			OtherGameTab:AddLabel("透视功能");
			OtherGameTab:AddToggle({Label="Bot兽",Default=false,Callback=function(v)
				if v then
					data['othergamedata']['project_transfur']['bot'].apply();
					data['othergamedata']['project_transfur']['botnt']:enable();
				else
					data['othergamedata']['project_transfur']['bot'].destroy();
					data['othergamedata']['project_transfur']['botnt']:disable();
				end
			end});
			OtherGameTab:AddToggle({Label="小保险箱",Default=false,Callback=function(v)
				if v then
					data['othergamedata']['project_transfur']['smallsafe'].apply();
					data['othergamedata']['project_transfur']['smallsafent']:enable();
				else
					data['othergamedata']['project_transfur']['smallsafe'].destroy();
					data['othergamedata']['project_transfur']['smallsafent']:disable();
				end
			end});
			OtherGameTab:AddToggle({Label="大保险箱",Default=false,Callback=function(v)
				if v then
					data['othergamedata']['project_transfur']['largesafe'].apply();
					data['othergamedata']['project_transfur']['largesafent']:enable();
				else
					data['othergamedata']['project_transfur']['largesafe'].destroy();
					data['othergamedata']['project_transfur']['largesafent']:disable();
				end
			end});
			OtherGameTab:AddToggle({Label="金保险箱",Default=false,Callback=function(v)
				if v then
					data['othergamedata']['project_transfur']['goldensafe'].apply();
					data['othergamedata']['project_transfur']['goldensafent']:enable();
				else
					data['othergamedata']['project_transfur']['goldensafe'].destroy();
					data['othergamedata']['project_transfur']['goldensafent']:disable();
				end
			end});
			OtherGameTab:AddToggle({Label="武器盒",Default=false,Callback=function(v)
				if v then
					data['othergamedata']['project_transfur']['crate'].apply();
					data['othergamedata']['project_transfur']['cratent']:enable();
				else
					data['othergamedata']['project_transfur']['crate'].destroy();
					data['othergamedata']['project_transfur']['cratent']:disable();
				end
			end});
			OtherGameTab:AddToggle({Label="空投",Default=false,Callback=function(v)
				if v then
					data['othergamedata']['project_transfur']['sd'].apply();
					data['othergamedata']['project_transfur']['sdnt']:enable();
				else
					data['othergamedata']['project_transfur']['sd'].destroy();
					data['othergamedata']['project_transfur']['sdnt']:disable();
				end
			end});
		elseif (GetgameInfo.name == "妄想办公室") then
			OtherGameTab:AddToggle({Label="实体警告",Default=false,Callback=function(v)
				data['othergamedata']['delesions_office']['entitywarning'] = v;
			end});
			OtherGameTab:AddToggle({Label="提醒他人",Default=false,Callback=function(v)
				data['othergamedata']['delesions_office']['tipotherplayer'] = v;
			end});
			OtherGameTab:AddToggle({Label="自动EN-013",Default=false,Callback=function(v)
				data['othergamedata']['delesions_office']['auto013'] = v;
			end});
		elseif (GetgameInfo.name == "格蕾丝") then
			OtherGameTab:AddToggle({Label="自动拉杆",Default=false,Callback=function(v)
				data['othergamedata']['grace']['autolever'] = v;
			end});
			OtherGameTab:AddButton({Text="删除全部实体(无法关闭)",Callback=function()
				data['othergamedata']['grace']['deleteentity'] = true;
			end});
		elseif (GetgameInfo.name == "深渊") then
			OtherGameTab:AddButton({Text="一键获取全地图深渊能量和回音",Callback=function()
				OBOTeleportModule.TeleportToParts({"AbyssalEnergy","BigAbyssalEnergy","Echo"}, 0.01);
			end});
			OtherGameTab:AddButton({Text="一键解锁全地图路径点",Callback=function()
				OBOTeleportModule.TeleportToParts("SpawnLocation", 0.1);
			end});
			OtherGameTab:AddButton({Text="传送到 灯笼商店",Callback=function()
				TeleportTo(-375, -11932, -504);
			end});
		elseif (GetgameInfo.name == "后院生存") then
			OtherGameTab:AddLabel("透视功能");
			OtherGameTab:AddToggle({Label="窃皮者",Default=false,Callback=function(v)
				if v then
					data['othergamedata']['backroomsurvival']['SkinStealer'].apply();
					data['othergamedata']['backroomsurvival']['SkinStealernt']:enable();
				else
					data['othergamedata']['backroomsurvival']['SkinStealer'].destroy();
					data['othergamedata']['backroomsurvival']['SkinStealernt']:disable();
				end
			end});
			OtherGameTab:AddToggle({Label="瞎子",Default=false,Callback=function(v)
				if v then
					data['othergamedata']['backroomsurvival']['Shrieker'].apply();
					data['othergamedata']['backroomsurvival']['Shriekernt']:enable();
				else
					data['othergamedata']['backroomsurvival']['Shrieker'].destroy();
					data['othergamedata']['backroomsurvival']['Shriekernt']:disable();
				end
			end});
			OtherGameTab:AddToggle({Label="悲尸",Default=false,Callback=function(v)
				if v then
					data['othergamedata']['backroomsurvival']['Wretch'].apply();
					data['othergamedata']['backroomsurvival']['Wretchnt']:enable();
				else
					data['othergamedata']['backroomsurvival']['Wretch'].destroy();
					data['othergamedata']['backroomsurvival']['Wretchnt']:disable();
				end
			end});
			OtherGameTab:AddToggle({Label="梦魇",Default=false,Callback=function(v)
				if v then
					data['othergamedata']['backroomsurvival']['Phantom'].apply();
					data['othergamedata']['backroomsurvival']['Phantomnt']:enable();
				else
					data['othergamedata']['backroomsurvival']['Phantom'].destroy();
					data['othergamedata']['backroomsurvival']['Phantomnt']:disable();
				end
			end});
			OtherGameTab:AddToggle({Label="细菌",Default=false,Callback=function(v)
				if v then
					data['othergamedata']['backroomsurvival']['Bacteria'].apply();
					data['othergamedata']['backroomsurvival']['Bacteriant']:enable();
				else
					data['othergamedata']['backroomsurvival']['Bacteria'].destroy();
					data['othergamedata']['backroomsurvival']['Bacteriant']:disable();
				end
			end});
			OtherGameTab:AddToggle({Label="侦察兵",Default=false,Callback=function(v)
				if v then
					data['othergamedata']['backroomsurvival']['Recon'].apply();
					data['othergamedata']['backroomsurvival']['Reconnt']:enable();
				else
					data['othergamedata']['backroomsurvival']['Recon'].destroy();
					data['othergamedata']['backroomsurvival']['Reconnt']:disable();
				end
			end});
			OtherGameTab:AddToggle({Label="修理工",Default=false,Callback=function(v)
				if v then
					data['othergamedata']['backroomsurvival']['Mechanic'].apply();
					data['othergamedata']['backroomsurvival']['Mechanicnt']:enable();
				else
					data['othergamedata']['backroomsurvival']['Mechanic'].destroy();
					data['othergamedata']['backroomsurvival']['Mechanicnt']:disable();
				end
			end});
		elseif (GetgameInfo.name == "最黑暗的时刻") then
			OtherGameTab:AddLabel("透视功能");
			OtherGameTab:AddToggle({Label="收集物",Default=false,Callback=function(v)
				if v then
					data['othergamedata']['DarkestHours']['Collectible'].apply();
					data['othergamedata']['DarkestHours']['Collectiblent']:enable();
				else
					data['othergamedata']['DarkestHours']['Collectible'].destroy();
					data['othergamedata']['DarkestHours']['Collectiblent']:disable();
				end
			end});
		elseif (GetgameInfo.name == "后悔电梯") then
			OtherGameTab:AddLabel("通用");
			OtherGameTab:AddToggle({Label="自动舔冰淇凌（确保快捷栏中有冰淇凌）",Default=false,Callback=function(v)
				if v then
					Regretevator_AutoIceCream:enable();
				else
					Regretevator_AutoIceCream:disable();
				end
			end});
			OtherGameTab:AddToggle({Label="透视硬币",Default=false,Callback=function(v)
				if v then
					data['othergamedata']['Regretevator']['coins'].apply();
					data['othergamedata']['Regretevator']['coinsnt']:enable();
				else
					data['othergamedata']['Regretevator']['coins'].destroy();
					data['othergamedata']['Regretevator']['coinsnt']:disable();
				end
			end});
			OtherGameTab:AddLabel("Bugbo楼层");
			OtherGameTab:AddToggle({Label="透视石头",Default=false,Callback=function(v)
				if v then
					data['othergamedata']['Regretevator']['bugbo_rocks'].apply();
					data['othergamedata']['Regretevator']['bugbo_rocksnt']:enable();
				else
					data['othergamedata']['Regretevator']['bugbo_rocks'].destroy();
					data['othergamedata']['Regretevator']['bugbo_rocksnt']:disable();
				end
			end});
			OtherGameTab:AddLabel("森林营地楼层");
			OtherGameTab:AddToggle({Label="透视木头",Default=false,Callback=function(v)
				if v then
					data['othergamedata']['Regretevator']['firewood'].apply();
					data['othergamedata']['Regretevator']['firewoodnt']:enable();
				else
					data['othergamedata']['Regretevator']['firewood'].destroy();
					data['othergamedata']['Regretevator']['firewoodnt']:disable();
				end
			end});
		end
	end
end
local serverScriptsTab = mainWindow:CreateTab({Name="服务器脚本",HasIcon=true,IconName="server"});
serverScriptsTab:AddTitle("KaiHub - 服务器脚本库");
local fscripts = {{name="自然灾害",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/ziran.lua"},{name="8个球池经典",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/8个球池经典.lua"},{name="99夜",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/99夜.lua"},{name="GB",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/GB.lua"},{name="po大po",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/po大po.lua"},{name="举重模拟器",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/举重模拟器.lua"},{name="亡命速递",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/亡命速递.lua"},{name="保护房子不受怪物入侵",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/保护房子不受怪物入侵.lua"},{name="僵尸之塔",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/僵尸之塔.lua"},{name="僵尸生存竞技场",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/僵尸生存竞技场.lua"},{name="克隆王国大亨",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/克隆王国大亨.lua"},{name="决斗场",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/决斗场.lua"},{name="刀刃球",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/刀刃球.lua"},{name="划开大海",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/划开大海.lua"},{name="力量传奇",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/力量传奇.lua"},{name="南极洲探险",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/南极洲探险.lua"},{name="启示录",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/启示录.lua"},{name="奴才大亨",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/奴才大亨.lua"},{name="平滑切片",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/平滑切片.lua"},{name="强壮传奇",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/强壮传奇.lua"},{name="忍者传奇",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/忍者传奇.lua"},{name="戒网瘾中心",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/戒网瘾中心.lua"},{name="手枪竞技场",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/手枪竞技场.lua"},{name="最强战场",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/最强战场.lua"},{name="木筏101天生存",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/木筏101天生存.lua"},{name="极速传奇",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/极速传奇.lua"},{name="模仿者",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/模仿者.lua"},{name="每步+1智商",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/每步+1智商.lua"},{name="汽车经销商大亨",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/汽车经销商大亨.lua"},{name="沉默的刺客",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/沉默的刺客.lua"},{name="滑石头RNG",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/滑石头RNG.lua"},{name="火球训练",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/火球训练.lua"},{name="火箭发射模拟器",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/火箭发射模拟器.lua"},{name="犯罪",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/犯罪.lua"},{name="生存于杀手",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/生存于杀手.lua"},{name="画我",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/画我.lua"},{name="监狱泵",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/监狱泵.lua"},{name="矿井",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/矿井.lua"},{name="砍伐树木",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/砍伐树木.lua"},{name="破坏者谜团2",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/破坏者谜团2.lua"},{name="竞争对手",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/竞争对手.lua"},{name="花园地平线",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/花园地平线.lua"},{name="超真实csgo",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/超真实csgo.lua"},{name="超高速跑者",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/超高速跑者.lua"},{name="迷你帝国",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/迷你帝国.lua"},{name="造船寻宝",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/造船寻宝.lua"},{name="金币点击器",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/金币点击器.lua"},{name="钓鱼模拟器",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/钓鱼模拟器.lua"},{name="闪光",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/闪光.lua"},{name="防御",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/防御.lua"},{name="集装箱RNG",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/集装箱RNG.lua"},{name="餐厅大亨3",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/餐厅大亨3.lua"},{name="鲨鱼咬",url="https://raw.githubusercontent.com/GGG792/KaiHubjiaoben/refs/heads/main/scripts/鲨鱼咬.lua"}};
for _, scriptInfo in ipairs(fscripts) do
	serverScriptsTab:AddButton({Text=("加载 " .. scriptInfo.name),Callback=function()
		pcall(function()
			loadstring(game:HttpGet(scriptInfo.url))();
		end);
		ChronixUI:Notify({Title="加载脚本",Content=(scriptInfo.name .. " 已加载"),Type="success",Duration=3});
	end});
end
local infoTab = mainWindow:CreateTab({Name="关于",HasIcon=true,IconName="info"});
infoTab:AddParagraph({Title="关于 KaiHub",Content=("KaiHub - 基于 ChronixHub V3\n\n" .. "主要特性:\n" .. "• 完整的玩家属性修改系统 (移速、跳跃、血量等)\n" .. "• 多种实用工具 (穿墙、无限跳、飞行、透视等)\n" .. "• 支持多种热门游戏的专用功能\n" .. "• 内置音乐播放器和音频检查器\n" .. "• 脚本中心，集成多个第三方脚本\n" .. "• 玩家传送和路径点系统\n" .. "• 实用的执行器和聊天监控功能\n\n" .. "开发者: Furrycalin\n" .. "版本: V3\n" .. "框架: 基于自定义 ChronixUI 库构建\n\n" .. "注意事项:\n" .. "• 请合理使用各项功能\n" .. "• 部分功能可能在游戏中被检测\n" .. "• 使用前请了解游戏规则\n" .. "\n" .. "🙏 特别鸣谢\n" .. "感谢以下开发者对本项目的贡献与支持（排名不分先后）：\n" .. "Furrycalin/Chronix | 脚本的所有者、主要开发者以及贡献者\n" .. "AI-DeepSeek | 提供代码支持和技术提供以及 README 完善\n" .. "AI-Qwen | 提供代码支持\n" .. "AI-DouBao | 提供代码支持\n" .. "IY | 部分功能代码借鉴、参考以及功能灵感来源\n" .. "K6 | 提供隐身代码支持\n" .. "OrionLib | UI 排版灵感来源\n" .. "Wally's UI Library | UI 排版灵感来源\n" .. "WindUI | 使用了 Icon 库\n" .. "PoppyPlayTime4 | 模拟了通知样式")});
infoTab:AddDivider();
local hwidlabel;
if gethwid then
	hwidlabel = infoTab:AddLabel(string.format("设备唯一标识码(HWID): %s", maskStringMiddle(gethwid())));
end
local rbxactivelabel;
if isrbxactive then
	rbxactivelabel = infoTab:AddLabel(string.format("焦点检测: %s", (isrbxactive() and "True") or "False"));
end
local pingLabel = infoTab:AddLabel(string.format("网络延迟: %s", math.round(LocalPlayer:GetNetworkPing() * 1000) .. "ms"));
local memLabel = infoTab:AddLabel(string.format("客户端脚本占用内存: %.2f MB", getMemoryUsage("MB")));
infoTab:AddButton({Text="强制内存垃圾回收",Callback=function()
	collectgarbage("collect");
	ChronixUI:Notify({Title="提示",Content="已进行垃圾回收\n请不要频繁使用，可能会影响性能。",Type="info",Duration=5});
end});
infoTab:AddTitle(">广告位招租<");
infoTab:AddParagraph({Title="YangZhiKa 飞机号",Content="广告位招租\n\nYangZhiKa 飞机号\n要买加 QQ：2490035277\n\nContact to purchase advertising space!"});
infoTab:AddButton({Text="复制QQ号: 2490035277",Callback=function()
	pcall(function()
		setclipboard("2490035277");
	end);
	ChronixUI:Notify({Title="已复制",Content="QQ号已复制到剪贴板",Type="success",Duration=2});
end});
local settingsContent = mainWindow.SettingsElements;
if (getfpscap and setfpscap) then
	settingsContent:AddInput({Label="Roblox - 帧率上限",Placeholder="这里输入你的最大帧率",Default=getfpscap(),Callback=function(text)
		local num = tonumber(text);
		if num then
			setfpscap(num);
		end
	end});
end
local mouseLockController = LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("CameraModule"):WaitForChild("MouseLockController");
local boundKeys = mouseLockController:FindFirstChild("BoundKeys");
settingsContent:AddKeybind({Label="Roblox - 鼠标锁定键",Default=(boundKeys and boundKeys.Value),Callback=function(key)
	if boundKeys then
		boundKeys.Value = key;
	else
		boundKeys = Instance.new("StringValue");
		boundKeys.Name = "BoundKeys";
		boundKeys.Value = key;
		boundKeys.Parent = mouseLockController;
	end
end});
settingsContent:AddDivider();
settingsContent:AddKeybind({Label="灵魂出窍",Default=FreecamModule.getKeybind().Name,Callback=function(key)
	local newKey = Enum.KeyCode[key];
	if newKey then
		FreecamModule.setKeybind(newKey);
	end
end});
settingsContent:AddKeybind({Label="望远镜",Default=data['basicdata']['releasetools']['zoom']:GetBindKey().Name,Callback=function(key)
	local newKey = Enum.KeyCode[key];
	if newKey then
		data['basicdata']['releasetools']['zoom']:SetBindKey(newKey);
	end
end});
settingsContent:AddKeybind({Label="锁定视角",Default=LockCameraModule.getBindKey().Name,Callback=function(key)
	if key then
		LockCameraModule.setBindKey(key);
	end
end});
settingsContent:AddKeybind({Label="滚轮切换按键",Default=ScrollSwitch:getbind().Name,Callback=function(key)
	if key then
		local newKey = Enum.KeyCode[key];
		ScrollSwitch:setbind(newKey);
	end
end});
settingsContent:AddInput({Label="TPWalk距离",Placeholder="",Default=tpWalk:GetSpeed(),Callback=function(text)
	local num = tonumber(text);
	if num then
		tpWalk:SetSpeed(num);
	end
end});
settingsContent:AddInput({Label="平移距离",Placeholder="",Default=movementModule.GetDistance(),Callback=function(text)
	local num = tonumber(text);
	if num then
		movementModule.SetDistance(num);
	end
end});
settingsContent:AddKeybind({Label="模型删除工具",Default=DeleteTool.getbindkey().Name,Callback=function(key)
	local newKey = Enum.KeyCode[key];
	if newKey then
		DeleteTool.setbindkey(newKey);
	end
end});
settingsContent:AddKeybind({Label="GUI删除工具",Default=GuiDeleter.getBindKey().Name,Callback=function(key)
	local newKey = Enum.KeyCode[key];
	if newKey then
		GuiDeleter.setBindKey(newKey);
	end
end});
settingsContent:AddDivider();
settingsContent:AddKeybind({Label="飞行 (Ctrl+)",Default=FlyModule.getbindkey().Name,Callback=function(key)
	if key then
		local newKey = Enum.KeyCode[key];
		if newKey then
			FlyModule.setbindkey(newKey);
		end
	end
end});
settingsContent:AddInput({Label="飞行速度",Placeholder="",Default=FlyModule.getflyspeed(),Callback=function(text)
	local num = tonumber(text);
	if num then
		FlyModule.setflyspeed(num);
	end
end});
settingsContent:AddDivider();
settingsContent:AddKeybind({Label="自动瞄准-绑定按键",Default=AimBotModule.GetKey().Name,Callback=function(key)
	if key then
		local newKey = Enum.KeyCode[key];
		AimBotModule.SetKey(newKey);
	end
end});
settingsContent:AddToggle({Label="自动瞄准-队伍检查",Default=false,Callback=function(v)
	AimBotModule.SetTeamCheck(v);
end});
settingsContent:AddToggle({Label="自动瞄准-墙壁检查",Default=false,Callback=function(v)
	AimBotModule.SetWallCheck(v);
end});
settingsContent:AddDropdown({Label="自动瞄准-命中部位",Options={"Head","HumanoidRootPart","UpperTorso","LowerTorso"},Default=AimBotModule.GetHitScan(),Callback=function(selected)
	AimBotModule.SetHitScan(selected);
end});
settingsContent:AddToggle({Label="自动瞄准-使用鼠标控制",Default=AimBotModule.GetUseMouse(),Callback=function(v)
	AimBotModule.SetUseMouse(v);
end});
settingsContent:AddDropdown({Label="自动瞄准-鼠标模式",Options={"MouseButton2","MouseButton1"},Default="MouseButton2",Callback=function(selected)
	AimBotModule.SetMouseBind(selected);
end});
settingsContent:AddToggle({Label="自动瞄准-粘性瞄准",Default=false,Callback=function(v)
	AimBotModule.SetStickyAim(v);
end});
settingsContent:AddSlider({Label="自动瞄准-平滑度",Min=3,Max=50,Default=30,Callback=function(v)
	AimBotModule.SetSmoothing(v);
end});
settingsContent:AddToggle({Label="自动瞄准-移动预测",Default=false,Callback=function(v)
	AimBotModule.SetPrediction(v);
end});
settingsContent:AddSlider({Label="自动瞄准-预测值",Min=0,Max=1000,Default=100,Callback=function(v)
	AimBotModule.SetPredictionAmount(v);
end});
settingsContent:AddDivider();
mainWindow:RefreshContent();
local staffwatchjoin;
if (game.CreatorType == Enum.CreatorType.Group) then
	staffwatchjoin = Players.PlayerAdded:Connect(function(player)
		if data['basicdata']['releasetools']['staffcheck'] then
			local result = getStaffRole(player);
			if result.Staff then
				ChronixUI:Notify({Title="警告",Content=(formatUsername(player) .. " 是 " .. result.Role),Type="warning",Duration=10});
			end
		end
	end);
end
local networkPaused = CoreGui.RobloxGui.ChildAdded:Connect(function(obj)
	if ((obj.Name == "CoreScripts/NetworkPause") and data['basicdata']['releasetools']['networkpausedisable']) then
		obj:Destroy();
	end
end);
local TeleportCheck = false;
local keepchronixhubconnect = LocalPlayer.OnTeleport:Connect(function(State)
	if (data['basicdata']['releasetools']['keepchronixhub'] and not TeleportCheck) then
		TeleportCheck = true;
		local teleportCode = [[
            if not game:IsLoaded() then game.Loaded:Wait() end
            local cloneref = cloneref or clonereference or function(obj) return obj end
            cloneref(game:GetService("StarterGui")):SetCore("SendNotification", {Title = "ChronixHub", Text = "检测到游戏被跳转\n正在重新载入中...", Duration = 10})
            loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/mainv3.lua"))()
        ]];
		if queueteleport then
			queueteleport(teleportCode);
		elseif queueonteleport then
			queueonteleport(teleportCode);
		elseif queue_on_teleport then
			queue_on_teleport(teleportCode);
		end
	end
end);
local AntiAFK = LocalPlayer.Idled:connect(function()
	if data['basicdata']['releasetools']['antiafk'] then
		VirtualUser:CaptureController();
		VirtualUser:ClickButton2(Vector2.new());
	end
end);
local connections = {};
local humanoidConnections = {};
local function disconnectHumanoidConnections()
	for _, connection in pairs(humanoidConnections) do
		if (connection and connection.Connected) then
			connection:Disconnect();
		end
	end
	humanoidConnections = {};
end
local function setupHumanoidListeners(humanoid)
	disconnectHumanoidConnections();
	humanoidConnections.walkSpeed = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if data['basicdata']['player']['islockspeed'] then
			humanoid.WalkSpeed = data['basicdata']['player']['speed'];
		end
	end);
	humanoidConnections.jumpPower = humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
		if data['basicdata']['player']['islockjump'] then
			humanoid.JumpPower = data['basicdata']['player']['jump'];
		end
	end);
	humanoidConnections.health = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
		if data['basicdata']['player']['islockhealth'] then
			humanoid.Health = data['basicdata']['player']['health'];
		end
	end);
	humanoidConnections.maxHealth = humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(function()
		if data['basicdata']['player']['islockmaxhealth'] then
			humanoid.MaxHealth = data['basicdata']['player']['maxhealth'];
		end
	end);
	humanoidConnections.forceUpdates = RunService.Heartbeat:Connect(function()
		if data['basicdata']['player']['islockspeed'] then
			if (humanoid.WalkSpeed ~= data['basicdata']['player']['speed']) then
				humanoid.WalkSpeed = data['basicdata']['player']['speed'];
			end
		end
		if data['basicdata']['player']['islockjump'] then
			if (humanoid.JumpPower ~= data['basicdata']['player']['jump']) then
				humanoid.JumpPower = data['basicdata']['player']['jump'];
			end
		end
		if data['basicdata']['player']['islockhealth'] then
			if (humanoid.Health ~= data['basicdata']['player']['health']) then
				humanoid.Health = data['basicdata']['player']['health'];
			end
		end
		if data['basicdata']['player']['islockmaxhealth'] then
			if (humanoid.MaxHealth ~= data['basicdata']['player']['maxhealth']) then
				humanoid.MaxHealth = data['basicdata']['player']['maxhealth'];
			end
		end
	end);
	humanoidConnections.hscc = humanoid.StateChanged:Connect(function(oldState, newState)
		if data['basicdata']['releasetools']['antifall'] then
			if ((newState == Enum.HumanoidStateType.FallingDown) or (newState == Enum.HumanoidStateType.Ragdoll) or (newState == Enum.HumanoidStateType.Freefall)) then
				humanoid:ChangeState(Enum.HumanoidStateType.GettingUp);
				ChronixUI:Notify({Title="提示",Content="检测到被击倒，已恢复站立状态",Type="info",Duration=5});
			end
		end
	end);
end
local function checkAndSetupHumanoid(character)
	if not character then
		return;
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid");
	if humanoid then
		setupHumanoidListeners(humanoid);
	else
		local childAddedConnection;
		childAddedConnection = character.ChildAdded:Connect(function(child)
			if child:IsA("Humanoid") then
				task.wait(0.1);
				setupHumanoidListeners(child);
				if childAddedConnection then
					childAddedConnection:Disconnect();
				end
			end
		end);
		for _, child in pairs(character:GetChildren()) do
			if child:IsA("Humanoid") then
				setupHumanoidListeners(child);
				if childAddedConnection then
					childAddedConnection:Disconnect();
				end
				break;
			end
		end
	end
end
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
end
local function clearAllConnections()
	for _, connection in pairs(connections) do
		if (connection and connection.Connected) then
			connection:Disconnect();
		end
	end
	connections = {};
	disconnectHumanoidConnections();
end
local pac = Players.PlayerAdded:Connect(updatePlayerList);
local prc = Players.PlayerRemoving:Connect(updatePlayerList);
ChatControl:MessageReceiver(function(msgData)
	addChatMessage(msgData.sender, msgData.text);
	if (data['basicdata']['releasetools']['chatresend'] and (msgData.sender == data['basicdata']['player']['name']) and hasNoSmallCapsAndHasLetters(msgData.text)) then
		ChatControl:chat(convertToSmallCaps(msgData.text));
	end
end);
local GGcount = 0;
local WorkspaceDescendantAdded = Workspace.DescendantAdded:Connect(function(descendant)
	detectEntity(descendant);
	if ((descendant.Name == "base") and descendant:IsA("BasePart") and data['othergamedata']['grace']['autolever']) then
		if (LocalPlayer and LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart) then
			descendant.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame;
			GGcount = GGcount + 1;
			if (GGcount >= 3) then
				ChronixUI:Notify({Title="提示",Content="全部拉杆已被激活\n门已打开",Type="info",Duration=5});
				GGcount = 0;
			end
			task.wait(1);
			descendant.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame;
		end
	end
	if data['othergamedata']['grace']['deleteentity'] then
		if ((descendant.Name == "eye") or (descendant.Name == "elkman") or (descendant.Name == "Rush") or (descendant.Name == "Worm") or (descendant.Name == "eyePrime")) then
			descendant:Destroy();
		end
	end
end);
local lastTime = 0;
local RunStepped = RunService.Stepped:Connect(function()
	if data['basicdata']['releasetools']['nightvision'] then
		game.Lighting.Ambient = Color3.new(1, 1, 1);
	end
	if data['basicdata']['releasetools']['supernightvision'] then
		Lighting.Brightness = 2;
		Lighting.ExposureCompensation = 2.5;
	end
	if data['basicdata']['player']['islockgravity'] then
		Workspace.Gravity = data['basicdata']['player']['gravity'];
	end
	if data['basicdata']['releasetools']['antidead'] then
		LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false);
	end
	local now = tick();
	if ((now - lastTime) >= 1) then
		lastTime = now;
		memLabel.Text = string.format("客户端脚本占用内存: %.2f MB", getMemoryUsage("MB"));
		pingLabel.Text = string.format("网络延迟: %s", math.round(LocalPlayer:GetNetworkPing() * 1000) .. "ms");
		if isrbxactive then
			rbxactivelabel.Text = string.format("焦点检测: %s", (isrbxactive() and "True") or "False");
		end
	end
	if data['othergamedata']['grace']['deleteentity'] then
		ReplicatedStorage.eyegui:Destroy();
		ReplicatedStorage.smilegui:Destroy();
		ReplicatedStorage.SendRush:Destroy();
		ReplicatedStorage.SendWorm:Destroy();
		ReplicatedStorage.SendSorrow:Destroy();
		ReplicatedStorage.SendGoatman:Destroy();
		task.wait(0.1);
		ReplicatedStorage.Worm:Destroy();
		ReplicatedStorage.elkman:Destroy();
		task.wait(0.1);
		ReplicatedStorage.QuickNotes.Eye:Destroy();
		ReplicatedStorage.QuickNotes.Rush:Destroy();
		ReplicatedStorage.QuickNotes.Sorrow:Destroy();
		ReplicatedStorage.QuickNotes.elkman:Destroy();
		ReplicatedStorage.QuickNotes.EyePrime:Destroy();
		ReplicatedStorage.QuickNotes.SlugFish:Destroy();
		ReplicatedStorage.QuickNotes.FakeDoor:Destroy();
		ReplicatedStorage.QuickNotes.SleepyHead:Destroy();
		local SmileGui = PlayerGui:FindFirstChild("smilegui");
		if SmileGui then
			SmileGui:Destroy();
		end
	end
end);
function unloadChronixHub()
	task.spawn(function()
		pcall(function()
			if (WebSocket.connect and genv.wsManager) then
				genv.wsManager:Disconnect();
			end
		end);
	end);
	_G.ChronixHubisLoaded = false;
	_G.ChronixHubLoading = false;
	loadingTimedOut = true;
	data['basicdata']['releasetools']['noclip'] = false;
	data['basicdata']['releasetools']['infjump'] = false;
	if data['basicdata']['releasetools']['supernightvision'] then
		Lighting.Brightness = data['basicdata']['releasetools']['originalBrightness'];
		data['basicdata']['releasetools']['supernightvision'] = false;
	end
	if data['basicdata']['releasetools']['nightvision'] then
		game.Lighting.Ambient = Color3.new(0, 0, 0);
		data['basicdata']['releasetools']['nightvision'] = false;
	end
	data['basicdata']['otherdata']['musicbox']:Stop();
	data['basicdata']['otherdata']['testSound']:Stop();
	local colorCorrection = Lighting:FindFirstChild("ChronixHub_ColorCorrection");
	if colorCorrection then
		colorCorrection:Destroy();
	end
	pcall(function()
		if data['basicdata']['releasetools']['xray'] then
			xrayLoop:Disconnect();
			xray(false);
		end
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
	if _G.DeathBallScript then
		_G.DeathBallScript:Unload();
	end
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
	if data['basicdata']['otherdata']['audioData']['scanConnection'] then
		data['basicdata']['otherdata']['audioData']['scanConnection']:Disconnect();
	end
	if prc then
		prc:Disconnect();
	end
	if pac then
		pac:Disconnect();
	end
	if WorkspaceDescendantAdded then
		WorkspaceDescendantAdded:Disconnect();
	end
	if Stepped then
		Stepped:Disconnect();
	end
	if JR then
		JR:Disconnect();
	end
	if AntiAFK then
		AntiAFK:Disconnect();
	end
	if RunStepped then
		RunStepped:Disconnect();
	end
	if keepchronixhubconnect then
		keepchronixhubconnect:Disconnect();
	end
	if networkPaused then
		networkPaused:Disconnect();
	end
	if staffwatchjoin then
		staffwatchjoin:Disconnect();
	end
	clearAllConnections();
	pcall(function()
		SystemNotification.UnloadedGradient("KaiHub Already Unload!");
	end);
	LogService:Info("[ChronixHub] 已成功卸载。");
	for moduleName, _ in pairs(modulesToFetch) do
		(_ENV or getfenv())[moduleName] = nil;
	end
	AsyncFileFetcher = nil;
	data = nil;
end
local loadTime = string.format("%.2f", tick() - startTime);
ChronixUI:Notify({Title="提示",Content=("ChronixHub 启动成功。用时: " .. loadTime .. "s\n防挂机已自动开启。"),Type="info",Duration=10});
LogService:Info("[ChronixHub] 已成功加载。用时: " .. loadTime .. "s");
pcall(function()
	SystemNotification.Rainbow("KaiHub Already Success Loaded!\nWelcome " .. data['basicdata']['player']['displayname']);
end);
_G.ChronixHubisLoaded = true;
_G.ChronixHubLoading = false;
pcall(function()
	local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled;
	if not isMobile then
		return;
	end
	local VirtualKeysGui = Instance.new("ScreenGui");
	VirtualKeysGui.Name = "KaiHubVirtualKeys";
	VirtualKeysGui.Parent = (gethui and gethui()) or cloneref(game.CoreGui);
	VirtualKeysGui.ResetOnSpawn = false;
	VirtualKeysGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
	VirtualKeysGui.IgnoreGuiInset = true;
	local keyButtons = {};
	local keyConfigs = {{name="Ctrl",keyCode=Enum.KeyCode.LeftControl,color=Color3.fromRGB(255, 165, 0)},{name="Shift",keyCode=Enum.KeyCode.LeftShift,color=Color3.fromRGB(0, 200, 255)},{name="Alt",keyCode=Enum.KeyCode.LeftAlt,color=Color3.fromRGB(200, 100, 255)},{name="C",keyCode=Enum.KeyCode.C,color=Color3.fromRGB(255, 200, 0)},{name="E",keyCode=Enum.KeyCode.E,color=Color3.fromRGB(100, 255, 100)},{name="Q",keyCode=Enum.KeyCode.Q,color=Color3.fromRGB(255, 100, 100)},{name="F",keyCode=Enum.KeyCode.F,color=Color3.fromRGB(100, 200, 255)},{name="Z",keyCode=Enum.KeyCode.Z,color=Color3.fromRGB(255, 150, 200)},{name="X",keyCode=Enum.KeyCode.X,color=Color3.fromRGB(200, 200, 100)},{name="Space",keyCode=Enum.KeyCode.Space,color=Color3.fromRGB(0, 255, 150)}};
	local btnSize = 44;
	local padding = 6;
	local cols = 5;
	local totalWidth = (cols * (btnSize + padding)) - padding;
	local startX = 10;
	local startY = 10;
	for i, cfg in ipairs(keyConfigs) do
		local row = math.floor((i - 1) / cols);
		local col = (i - 1) % cols;
		local btn = Instance.new("TextButton");
		btn.Name = "VK_" .. cfg.name;
		btn.Size = UDim2.new(0, btnSize, 0, btnSize);
		btn.Position = UDim2.new(0, startX + (col * (btnSize + padding)), 0, startY + (row * (btnSize + padding)));
		btn.BackgroundColor3 = cfg.color;
		btn.BackgroundTransparency = 0.3;
		btn.Text = cfg.name;
		btn.TextColor3 = Color3.fromRGB(255, 255, 255);
		btn.TextSize = 14;
		btn.Font = Enum.Font.GothamBold;
		btn.BorderSizePixel = 0;
		btn.ZIndex = 100;
		btn.AutoButtonColor = false;
		btn.Parent = VirtualKeysGui;
		local corner = Instance.new("UICorner");
		corner.CornerRadius = UDim.new(0, 8);
		corner.Parent = btn;
		local stroke = Instance.new("UIStroke");
		stroke.Thickness = 1.5;
		stroke.Transparency = 0.3;
		stroke.Color = Color3.fromRGB(255, 255, 255);
		stroke.Parent = btn;
		keyButtons[cfg.keyCode] = btn;
		btn.MouseButton1Down:Connect(function()
			btn.BackgroundTransparency = 0;
			btn.Size = UDim2.new(0, btnSize - 4, 0, btnSize - 4);
			btn.Position = UDim2.new(0, startX + (col * (btnSize + padding)) + 2, 0, startY + (row * (btnSize + padding)) + 2);
			VirtualInputManager = game:GetService("VirtualInputManager");
			pcall(function()
				VirtualInputManager:SendKeyEvent(true, cfg.keyCode, false);
			end);
		end);
		btn.MouseButton1Up:Connect(function()
			btn.BackgroundTransparency = 0.3;
			btn.Size = UDim2.new(0, btnSize, 0, btnSize);
			btn.Position = UDim2.new(0, startX + (col * (btnSize + padding)), 0, startY + (row * (btnSize + padding)));
			pcall(function()
				game:GetService("VirtualInputManager"):SendKeyEvent(false, cfg.keyCode, false);
			end);
		end);
		btn.MouseLeave:Connect(function()
			btn.BackgroundTransparency = 0.3;
			btn.Size = UDim2.new(0, btnSize, 0, btnSize);
			btn.Position = UDim2.new(0, startX + (col * (btnSize + padding)), 0, startY + (row * (btnSize + padding)));
			pcall(function()
				game:GetService("VirtualInputManager"):SendKeyEvent(false, cfg.keyCode, false);
			end);
		end);
	end
	local toggleBtn = Instance.new("TextButton");
	toggleBtn.Name = "ToggleVK";
	toggleBtn.Size = UDim2.new(0, 36, 0, 36);
	toggleBtn.Position = UDim2.new(0, startX, 0, startY);
	toggleBtn.BackgroundColor3 = Color3.fromRGB(119, 221, 255);
	toggleBtn.BackgroundTransparency = 0.2;
	toggleBtn.Text = "⌨";
	toggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0);
	toggleBtn.TextSize = 18;
	toggleBtn.Font = Enum.Font.GothamBold;
	toggleBtn.BorderSizePixel = 0;
	toggleBtn.ZIndex = 101;
	toggleBtn.AutoButtonColor = false;
	toggleBtn.Parent = VirtualKeysGui;
	local toggleCorner = Instance.new("UICorner");
	toggleCorner.CornerRadius = UDim.new(0, 8);
	toggleCorner.Parent = toggleBtn;
	local vkVisible = true;
	toggleBtn.MouseButton1Click:Connect(function()
		vkVisible = not vkVisible;
		for _, btn in pairs(keyButtons) do
			btn.Visible = vkVisible;
		end
		toggleBtn.Text = (vkVisible and "⌨") or "⌨";
		toggleBtn.BackgroundTransparency = (vkVisible and 0.2) or 0.5;
	end);
end);
loadingTimedOut = true;
