-- 模块脚本 (放在ModuleScript中)
local cloneref = cloneref or clonereference or function(obj) return obj end
local Players = cloneref(game:GetService("Players"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))

local DeleteTool = {}
local enabled = false
local bindKey = Enum.KeyCode.Delete -- 默认按键改为Delete
local inputBeganConnection = nil
local localPlayer = nil

-- 获取本地玩家
local function getLocalPlayer()
	if localPlayer then
		return localPlayer
	end
	localPlayer = Players.LocalPlayer
	return localPlayer
end

-- 获取玩家角色
local function getCharacter()
	local player = getLocalPlayer()
	if player then
		return player.Character
	end
	return nil
end

-- 射线检测，获取面前的可删除部件
local function getTargetPart()
	local character = getCharacter()
	if not character then
		return nil
	end
	
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then
		return nil
	end
	
	-- 获取摄像机或角色朝向
	local camera = workspace.CurrentCamera
	local direction
	
	if camera then
		-- 使用摄像机方向
		direction = camera.CFrame.LookVector
	else
		-- 使用角色朝向
		direction = rootPart.CFrame.LookVector
	end
	
	-- 射线起始位置（从角色头部或根部件位置）
	local rayOrigin = rootPart.Position
	local rayDirection = direction * 50 -- 检测距离50格
	
	-- 创建射线参数，忽略玩家角色
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {character}
	
	-- 执行射线检测
	local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	
	if raycastResult then
		local instance = raycastResult.Instance
		
		-- 检查是否为玩家角色，如果是则返回nil
		local targetPlayer = Players:GetPlayerFromCharacter(instance.Parent)
		if targetPlayer then
			return nil
		end
		
		-- 检查父级是否为玩家角色
		if instance.Parent and instance.Parent:IsA("Model") then
			local parentPlayer = Players:GetPlayerFromCharacter(instance.Parent)
			if parentPlayer then
				return nil
			end
		end
		
		return instance
	end
	
	return nil
end

-- 按键处理函数
local function onInputBegan(input, gameProcessed)
	if gameProcessed then
		return -- 忽略已处理的输入（如聊天框输入）
	end
	
	if input.KeyCode == bindKey then
		local targetPart = getTargetPart()
		if targetPart then
			-- 检查是否可删除（防止删除重要部件）
			local success, err = pcall(function()
				-- 如果是BasePart的直接子级或本身
				if targetPart:IsA("BasePart") then
					-- 额外安全检查：不删除Workspace的直接子级（如地形等）
					if targetPart.Parent and targetPart.Parent ~= workspace then
						local parentModel = targetPart:FindFirstAncestorOfClass("Model")
						if parentModel then
							parentModel:Destroy()
						else
							targetPart:Destroy()
						end
					end
				elseif targetPart:IsA("Model") then
					targetPart:Destroy()
				end
			end)
			
			if not success then

			end
		end
	end
end

-- 启用工具
function DeleteTool.enable()
	if enabled then
		return -- 已经启用
	end
	
	enabled = true
	
	-- 确保获取本地玩家
	getLocalPlayer()
	
	-- 连接输入事件
	if not inputBeganConnection then
		inputBeganConnection = UserInputService.InputBegan:Connect(onInputBegan)
	end
end

-- 禁用工具
function DeleteTool.disable()
	if not enabled then
		return -- 已经禁用
	end
	
	enabled = false
	
	-- 断开输入连接
	if inputBeganConnection then
		inputBeganConnection:Disconnect()
		inputBeganConnection = nil
	end
end

-- 获取当前绑定按键
function DeleteTool.getbindkey()
	return bindKey
end

-- 设置绑定按键
function DeleteTool.setbindkey(newKey)
	if typeof(newKey) ~= "EnumItem" or newKey.EnumType ~= Enum.KeyCode then
		return
	end
	
	bindKey = newKey
end

-- 卸载模块（清理所有连接和状态）
function DeleteTool.unload()
	-- 禁用工具
	DeleteTool.disable()
	
	-- 清理引用
	localPlayer = nil
end

-- 模块卸载时自动清理
DeleteTool.__add = nil -- 防止被误用

return DeleteTool