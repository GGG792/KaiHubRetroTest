-- AntiFling.lua
local cloneref = cloneref or clonereference or function(obj) return obj end
local Players = cloneref(game:GetService("Players"))

local AntiFling = {}
local connections = {}
local isEnabled = false
local speaker

-- 处理单个角色
local function setupCharacter(character)
	if not character then return end

	for _, v in pairs(character:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = false
		end
	end

	local conn = character.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("BasePart") then
			descendant.CanCollide = false
		end
	end)
	table.insert(connections, conn)
end

-- 处理新玩家加入
local function onPlayerAdded(player)
	if not isEnabled or player == speaker then return end

	local charConn
	charConn = player.CharacterAdded:Connect(function(character)
		setupCharacter(character)
	end)
	table.insert(connections, charConn)

	if player.Character then
		setupCharacter(player.Character)
	end
end

-- 恢复所有碰撞
local function restoreAllCollisions()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= speaker and player.Character then
			for _, v in pairs(player.Character:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = true
				end
			end
		end
	end
end

function AntiFling.enable(speakerRef)
	if isEnabled then return end
	isEnabled = true
	speaker = speakerRef

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= speaker then
			onPlayerAdded(player)
		end
	end

	local playerAddedConn = Players.PlayerAdded:Connect(onPlayerAdded)
	table.insert(connections, playerAddedConn)
end

function AntiFling.disable()
	if not isEnabled then return end
	isEnabled = false

	for _, conn in ipairs(connections) do
		conn:Disconnect()
	end
	table.clear(connections)

	restoreAllCollisions()
	speaker = nil
end

function AntiFling.unload()
	AntiFling.disable()
end

return AntiFling