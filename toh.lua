local DiscordLib = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/discord%20lib.txt")()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local gearFolder = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Gear") -- Ждем загрузки папки Gear

local win = DiscordLib:Window("Tower Of Hell")
local serv = win:Server("Mainstance", "")
local btns = serv:Channel("Teleport")
local mainn = serv:Channel("Main")

local gearFolder = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Gear")

local function giveGearToPlayer(character)
    if not character then
        warn("Character not found!")
        return
    end

    if not gearFolder then
        warn("Folder Gear not found in ReplicatedStorage.Assets.")
        return
    end

    local backpack = Players.LocalPlayer.Backpack

    if not backpack then
        warn("Backpack not found!")
        return
    end

    local items = gearFolder:GetChildren()

    for _, item in ipairs(items) do
        if item:IsA("Tool") then
            local clonedItem = item:Clone()
            clonedItem.Parent = backpack
            print("Got item: " .. item.Name)
        end
    end
end

btns:Label("Teleports")

btns:Button("End", function()
    local character = LocalPlayer.Character
    if not character then
        DiscordLib:Notification("Error", "Character not found!", "Ок")
        return
    end

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local tower = workspace:FindFirstChild("tower")
    local sections = tower:FindFirstChild("sections")
    local finish = sections:FindFirstChild("finish")
    local exit = finish:FindFirstChild("exit")
    local carpet = exit:FindFirstChild("carpet")

    if HumanoidRootPart and carpet then
        HumanoidRootPart.CFrame = carpet.CFrame + Vector3.new(0, 5, 0)
    else
        DiscordLib:Notification("Error", "Cant teleport", "Ок")
    end
end)

btns:Button("Shop", function()
    local player = Players.LocalPlayer
    local character = player.Character
    if not character then
        DiscordLib:Notification("Error", "Character not found!", "Ок")
        return
    end

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local shopp = Vector3.new(-41.09400939941406, -4.249936580657959, -0.27630484104156494)

    if HumanoidRootPart then
        HumanoidRootPart.CFrame = CFrame.new(shopp)
    else
        DiscordLib:Notification("Error", "HumanoidRootPart not found!", "Ок")
    end
end)

local function getPlayerNames()
    local playerNames = {}
    for i, player in ipairs(game.Players:GetPlayers()) do
        table.insert(playerNames, player.Name)
    end
    return playerNames
end

local drop = btns:Dropdown("Choose Player", getPlayerNames(), function(targetPlayerName)
    if targetPlayerName then
        local targetPlayer = Players:FindFirstChild(targetPlayerName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetHumanoidRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")

            local character = LocalPlayer.Character
            if not character then
                DiscordLib:Notification("Error", "Character was not found!", "Ок")
                return
            end

            local localHumanoidRootPart = character:FindFirstChild("HumanoidRootPart")

            if localHumanoidRootPart then
                localHumanoidRootPart.CFrame = targetHumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                DiscordLib:Notification("Successfuly", "You've teleported to: " .. targetPlayerName .. "!", "Оk")
            else
                DiscordLib:Notification("Error", "HumanoidRootPart was not found!", "Оk")
            end
        else
            DiscordLib:Notification("Error", "Player " .. targetPlayerName .. " was not found no Character!", "Оk")
        end
    else
        DiscordLib:Notification("Error", "Player not Choosen!", "Оk")
    end
end)

mainn:Label("Gears")

mainn:Button("Give all Gears", function()
	if gearFolder then
    	local items = gearFolder:GetChildren()

    	for _, item in ipairs(items) do
    	    if item:IsA("Tool") then
    	        local clonedItem = item:Clone()
    	        clonedItem.Parent = game.Players.LocalPlayer.Backpack
    	        print("You've got: " .. item.Name)
    	    end
    	end
	else
    	warn("Folder Gear not found in ReplicatedStorage.Assets.")
	end
end)

mainn:Toggle("Force Gears",false, function(bool)
	Players.LocalPlayer.CharacterAdded:Connect(function(character)
    	giveGearToPlayer(character)
	end)
end)

mainn:Label("Character")

mainn:Slider("Speed", 0, 500, 16, function(t)
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = t
end)

mainn:Slider("JumpPower", 0, 500, 50, function(t)
	game.Players.LocalPlayer.Character.Humanoid.JumpPower = t
end)

game.Players.PlayerAdded:Connect(function(player)
    drop:ChangeOptions(getPlayerNames())
end)

game.Players.PlayerRemoving:Connect(function(player)
    drop:ChangeOptions(getPlayerNames())
end)
