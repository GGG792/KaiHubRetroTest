local VirtualUserService = game:GetService("VirtualUser");
game:GetService("Players").LocalPlayer.Idled:connect(function()
	VirtualUserService:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame);
	wait(1);
	VirtualUserService:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame);
end);
local GameMetatable = getrawmetatable(game);
setreadonly(GameMetatable, false);
local OriginalNamecall = GameMetatable.__namecall;
GameMetatable.__namecall = newcclosure(function(Self, ...)
	local Arguments = {...};
	if ((getnamecallmethod() == "FireServer") and (Self.Name == "JobRemoteHandler") and (rawget(..., "Action") == "StartDeliveryJob")) then
		print(Arguments);
		_G.remotetable = ...;
	end
	return OriginalNamecall(Self, ...);
end);
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
local CombatTab = Window:Tab({Title="功能",Icon="swords"});
Window:SelectTab(1);
CombatTab:Toggle({Title="自动收集活动部件",Default=false,Callback=function(ToggleValue)
	getfenv().test = ToggleValue;
	if ToggleValue then
		task.spawn(function()
			while getfenv().test do
				wait();
				local IteratorFunction, WorkspaceChildren, CurrentIndex = pairs(workspace:GetChildren());
				local function GetCollectedCount()
					local CountTextSplit = game:GetService("Players").LocalPlayer.PlayerGui.Menu.Event.Frame.PrizeFrame.ProgressBar.Count.Text:split("/");
					return tonumber(CountTextSplit[1]);
				end
				while true do
					local WorkspaceChild;
					CurrentIndex, WorkspaceChild = IteratorFunction(WorkspaceChildren, CurrentIndex);
					if (CurrentIndex == nil) then
						break;
					end
					if ((WorkspaceChild.ClassName == "Model") and not WorkspaceChild:FindFirstChild("Part") and WorkspaceChild:FindFirstChild("Owned") and (GetCollectedCount() ~= 12) and (getfenv().test == true)) then
						repeat
							wait();
							game.Players.LocalPlayer.Character:PivotTo(WorkspaceChild.WorldPivot);
						until WorkspaceChild:FindFirstChild("Part") or (getfenv().test == false) 
					end
				end
				local IteratorFunction2, WorkspaceChildren2, CurrentIndex2 = pairs(workspace:GetChildren());
				while true do
					local WorkspaceChild2;
					CurrentIndex2, WorkspaceChild2 = IteratorFunction2(WorkspaceChildren2, CurrentIndex2);
					if (CurrentIndex2 == nil) then
						break;
					end
					if ((WorkspaceChild2.ClassName == "Model") and WorkspaceChild2:FindFirstChild("Part") and WorkspaceChild2:FindFirstChild("Owned") and (GetCollectedCount() ~= 12) and (getfenv().test == true)) then
						game.Players.LocalPlayer.Character:PivotTo(WorkspaceChild2.WorldPivot);
						local PreviousCount = GetCollectedCount();
						local IteratorFunction3, ModelChildren, CurrentIndex3 = pairs(WorkspaceChild2:GetChildren());
						local VisibleMeshPart = nil;
						while true do
							local ModelChild;
							CurrentIndex3, ModelChild = IteratorFunction3(ModelChildren, CurrentIndex3);
							if (CurrentIndex3 == nil) then
								break;
							end
							if (ModelChild.ClassName == "MeshPart") then
								if (ModelChild.Transparency < 0.5) then
									VisibleMeshPart = ModelChild;
								end
							end
						end
						if (VisibleMeshPart ~= nil) then
							repeat
								task.wait();
								game.Players.LocalPlayer.Character:PivotTo(WorkspaceChild2.WorldPivot);
								game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game);
							until (VisibleMeshPart.Transparency > 0.5) or (getfenv().test == false) 
							repeat
								task.wait();
								game:GetService("ReplicatedStorage").Remotes.EventController.PerformAction:FireServer("AssembleCarPart", {});
							until PreviousCount ~= GetCollectedCount() 
						end
					end
				end
			end
		end);
	end
end});
CombatTab:Toggle({Title="自动送货",Default=false,Callback=function(ToggleValue)
	getfenv().deliver = ToggleValue;
	if ToggleValue then
		task.spawn(function()
			while getfenv().deliver do
				task.wait();
				pcall(function()
					if (game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit == false) then
						wait(5);
						getfenv().spawned = false;
					end
				end);
			end
		end);
		task.spawn(function()
			while getfenv().deliver do
				wait();
				pcall(function()
					if (game.Players.LocalPlayer.Character.Humanoid.Sit ~= true) then
						if ((game.Players.LocalPlayer.Character.Humanoid.Sit == false) and (getfenv().spawned ~= true)) then
							if _G.remotetable then
								game:GetService("ReplicatedStorage").Remotes.DealershipCustomerController.JobRemoteHandler:FireServer(_G.remotetable);
							end
							getfenv().spawned = true;
							wait(0.1);
						end
					else
						task.wait(0.1);
						local IteratorFunction, JobDescendants, CurrentIndex = pairs(workspace.ActionTasksGames.Jobs:GetDescendants());
						while true do
							local JobDescendant;
							CurrentIndex, JobDescendant = IteratorFunction(JobDescendants, CurrentIndex);
							if (CurrentIndex == nil) then
								break;
							end
							if ((JobDescendant.Name == "DeliveryPart") and (JobDescendant.Transparency ~= 1)) then
								getfenv().spawned = false;
								game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.Parent:PivotTo(JobDescendant.CFrame);
								game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.Parent:PivotTo(JobDescendant.CFrame * CFrame.new(-30, 20, -10));
								game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.Parent:PivotTo(JobDescendant.CFrame * CFrame.Angles(0, math.rad(90), 0));
								local IteratorFunction2, VehicleChildren, CurrentIndex2 = pairs(game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.Parent:GetChildren());
								while true do
									local VehicleChild;
									CurrentIndex2, VehicleChild = IteratorFunction2(VehicleChildren, CurrentIndex2);
									if (CurrentIndex2 == nil) then
										break;
									end
									if ((VehicleChild.ClassName == "Model") and VehicleChild:GetAttribute("StockTurbo")) then
										local IteratorFunction3, JobChildren, CurrentIndex3 = pairs(workspace.ActionTasksGames.Jobs:GetChildren());
										while true do
											local JobChild;
											CurrentIndex3, JobChild = IteratorFunction3(JobChildren, CurrentIndex3);
											if (CurrentIndex3 == nil) then
												break;
											end
											if ((JobChild.ClassName == "Model") and JobChild:GetAttribute("JobId")) then
												game:GetService("ReplicatedStorage").Remotes.DealershipCustomerController.JobRemoteHandler:FireServer({Action="TryToCompleteJob",JobId=JobChild:GetAttribute("JobId")});
												local JobRemoteHandler = game:GetService("ReplicatedStorage").Remotes.DealershipCustomerController.JobRemoteHandler;
												local FireServerFunction = JobRemoteHandler.FireServer;
												local CollectRewardData = {JobId=game:GetService("Players").LocalPlayer.PlayerGui.MissionRewardStars:GetAttribute("JobId"),Action="CollectReward"};
												FireServerFunction(JobRemoteHandler, CollectRewardData);
											end
										end
									end
								end
							end
						end
					end
				end);
			end
		end);
	end
end});
CombatTab:Toggle({Title="自动售卖汽车",Default=false,Callback=function(ToggleValue)
	getfenv().Customer = ToggleValue;
	if ToggleValue then
		task.spawn(function()
			while getfenv().Customer do
				task.wait();
				pcall(function()
					_G.rat = nil;
					local tycoon = nil;
					local IteratorFunction, DealershipChildren, CurrentIndex = pairs((function()
						local IteratorFunction2, TycoonDescendants, CurrentIndex2 = pairs(workspace.Tycoons:GetDescendants());
						while true do
							local TycoonDescendant;
							CurrentIndex2, TycoonDescendant = IteratorFunction2(TycoonDescendants, CurrentIndex2);
							if (CurrentIndex2 == nil) then
								break;
							end
							if (((TycoonDescendant.Name == "Owner") and (TycoonDescendant.ClassName == "StringValue") and string.find(TycoonDescendant.Parent.Name, "Plot") and (TycoonDescendant.Value == game.Players.LocalPlayer.Name)) or ((TycoonDescendant.Name == "Owner") and (TycoonDescendant.ClassName == "StringValue") and string.find(TycoonDescendant.Parent.Name, "Slot") and (TycoonDescendant.Value == game.Players.LocalPlayer.Name))) then
								tycoon = TycoonDescendant.Parent;
							end
						end
						return tycoon;
					end)().Dealership:GetChildren());
					local CustomerNPC = nil;
					while true do
						local DealershipChild;
						CurrentIndex, DealershipChild = IteratorFunction(DealershipChildren, CurrentIndex);
						if (CurrentIndex == nil) then
							break;
						end
						if ((DealershipChild.ClassName == "Model") and (DealershipChild.PrimaryPart ~= nil)) then
							if (DealershipChild.PrimaryPart.Name == "HumanoidRootPart") then
								CustomerNPC = DealershipChild;
							end
						end
					end
					local BudgetSplit = CustomerNPC:GetAttribute("OrderSpecBudget"):split(";");
					local MaxBudget = tonumber(BudgetSplit[2]);
					local PlayerGui = game.Players.LocalPlayer.PlayerGui;
					local MenuGui = PlayerGui.Menu;
					local CarSpecFrame = PlayerGui.Dialogue.CarSpec.Frame.Frame;
					local IteratorFunction2, ShopDescendants, CurrentIndex2 = pairs(MenuGui.Shop.Cars.Frame.Frame:GetDescendants());
					while true do
						local ShopDescendant;
						CurrentIndex2, ShopDescendant = IteratorFunction2(ShopDescendants, CurrentIndex2);
						if (CurrentIndex2 == nil) then
							break;
						end
						if ((ShopDescendant.Name == "PriceValue") and (tonumber(string.gsub(ShopDescendant.Value, ",", ""):split("$")[2]) > tonumber(BudgetSplit[1])) and (tonumber(string.gsub(ShopDescendant.Value, ",", ""):split("$")[2]) < tonumber(BudgetSplit[2]))) then
							local CarPrice = tonumber(string.gsub(ShopDescendant.Value, ",", ""):split("$")[2]);
							if (CarPrice < MaxBudget) then
								_G.rat = ShopDescendant;
								MaxBudget = CarPrice;
							end
						end
					end
					local textn = 1;
					local CharacterAtPosition = "";
					repeat
						wait();
						CharacterAtPosition = _G.rat.Parent.Name:split("")[textn];
						textn = textn + 1;
					until tonumber(CharacterAtPosition) == nil 
					game:GetService("ReplicatedStorage").Remotes.DealershipCustomerController.NPCHandler:FireServer({Action="AcceptOrder",OrderId=CustomerNPC:GetAttribute("OrderId")});
					wait();
					local NPCHandler = game:GetService("ReplicatedStorage").Remotes.DealershipCustomerController.NPCHandler;
					local FireServerFunction = NPCHandler.FireServer;
					local CompleteOrderData = {};
					local SpecsData = {Springs=CustomerNPC:GetAttribute("OrderSpecSprings"),Color=CustomerNPC:GetAttribute("OrderSpecColor"),Rims=CustomerNPC:GetAttribute("OrderSpecRims"),Car=(CharacterAtPosition .. _G.rat.Parent.Name:split(tostring(_G.rat.Parent.Name:split("")[textn - 1]))[2]),RimColor=CustomerNPC:GetAttribute("OrderSpecRimColor")};
					CompleteOrderData.Specs = SpecsData;
					CompleteOrderData.Action = "CompleteOrder";
					CompleteOrderData.OrderId = CustomerNPC:GetAttribute("OrderId");
					FireServerFunction(NPCHandler, CompleteOrderData);
					wait();
					game:GetService("ReplicatedStorage").Remotes.DealershipCustomerController.NPCHandler:FireServer({Action="CollectReward",OrderId=CustomerNPC:GetAttribute("OrderId")});
					repeat
						wait();
					until (CustomerNPC.Parent == nil) or (getfenv().Customer == false) 
				end);
			end
		end);
	end
end});
CombatTab:Toggle({Title="自动升级",Default=false,Callback=function(ToggleValue)
	getfenv().buyer = ToggleValue;
	if ToggleValue then
		task.spawn(function()
			while getfenv().buyer do
				task.wait();
				local function GetPlayerTycoon()
					local tycoon = nil;
					local IteratorFunction, TycoonDescendants, CurrentIndex = pairs(workspace.Tycoons:GetDescendants());
					while true do
						local TycoonDescendant;
						CurrentIndex, TycoonDescendant = IteratorFunction(TycoonDescendants, CurrentIndex);
						if (CurrentIndex == nil) then
							break;
						end
						if ((TycoonDescendant.Name == "Owner") and (TycoonDescendant.ClassName == "StringValue") and (TycoonDescendant.Value == game.Players.LocalPlayer.Name)) then
							tycoon = TycoonDescendant.Parent;
						end
					end
					return tycoon;
				end
				pcall(function()
					local IteratorFunction, PurchaseChildren, CurrentIndex = pairs(GetPlayerTycoon().Dealership.Purchases:GetChildren());
					while true do
						local PurchaseChild;
						CurrentIndex, PurchaseChild = IteratorFunction(PurchaseChildren, CurrentIndex);
						if (CurrentIndex == nil) then
							break;
						end
						if ((getfenv().buyer == true) and PurchaseChild:FindFirstChild("TycoonButton") and (PurchaseChild.TycoonButton.Button.Transparency == 0)) then
							game:GetService("ReplicatedStorage").Remotes.Build:FireServer("BuyItem", PurchaseChild.Name);
							wait(0.3);
						end
					end
				end);
			end
		end);
	end
end});
CombatTab:Toggle({Title="删除弹出窗口",Default=false,Callback=function(ToggleValue)
	getfenv().annoy = ToggleValue;
	if getfenv().annoy then
		getfenv().fun = game:GetService("Players").LocalPlayer.PlayerGui.ChildAdded:Connect(function(ChildAdded)
			if (ChildAdded.Name == "Popup2") then
				ChildAdded:Destroy();
			end
		end);
	elseif getfenv().fun then
		getfenv().fun:Disconnect();
	end
end});
