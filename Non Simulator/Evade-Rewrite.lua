local plrs = game:GetService("Players")
local lplr = plrs.LocalPlayer
local camera =  workspace.CurrentCamera
local runservice = game:GetService("RunService")
local teleportservice = game:GetService("TeleportService")
local Id = nil
local WebhookSendinfo, WebhookUrl = false, nil

local function Downed(plr)
    if plr and plr.Character and plr.Character:GetAttribute("Downed") then return true end
    return false
end

local function isCarried(plr)
    local plr = workspace.Game.Players:FindFirstChild(plr.Name)
    if plr then
        return plr:FindFirstChild("CarriedBy") ~= nil
    end
    return false
end

local function revive(plr, status)
    return game:GetService("ReplicatedStorage").Events.Revive.RevivePlayer:FireServer(plr.Name, status)
end

function Respawn()
    game:GetService("ReplicatedStorage").Events.Respawn:FireServer()
end

for _,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
    if v.Name == "Menu" ~= nil then
        Respawn()
    elseif Downed(lplr) ~= nil then
        Respawn()
    else
        print("working")
    end
end

local Lib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Robobo2022/notify-lib/main/lib'),true))()
local Util = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robobo2022/Util/main/Load.lua"))()
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()

local Window = Rayfield:CreateWindow({
    Name = "Evade Premium",
    LoadingTitle = "Hydra Network",
    LoadingSubtitle = "by Hydra#8270",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil,
       FileName = "Big Hub"
    },
    Discord = {
       Enabled = false,
       Invite = "",
       RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
       Title = "Sirius Hub",
       Subtitle = "Key System",
       Note = "Join the discord (discord.gg/sirius)",
       FileName = "SiriusKey",
       SaveKey = true,
       GrabKeyFromSite = false,
       Key = "Hello"
    }
})

local Settings = {
    JumpPower = 20,
    WalkSpeed = 20,
    JumpEnabled = false,
    WalkEnabled = false,
    CameraShake = false,
    FearFov = false,
    AutoRespawn = false,
    WebhookOnImportant = false,
    ReviveFarm = false,
    LeverEsp = false
}

local T1 = Window:CreateTab("Main")
local T2 = Window:CreateTab("Misc")
local T4 = Window:CreateTab("Tp")
local T5 = Window:CreateTab("Fun")
local T6 = Window:CreateTab("Farms")
local T7 = Window:CreateTab("Bot ESP")
local T8 = Window:CreateTab("Settings")

local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    if (Settings.WalkEnabled or Settings.JumpPower) and self and self.Name == "Communicator" and args[1] == "update" then
        return (Settings.WalkEnabled and Settings.WalkSpeed*100 or 1500), (Settings.JumpEnabled and Settings.JumpPower or 3)
    end
    return old(self,...)
end)

task.spawn(function()
    while task.wait() do
        if Settings.CameraShake then
            lplr.PlayerScripts.CameraShake.Value = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1) * CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if Settings.FearFov then
            if lplr.PlayerScripts.FOVAdjusters.Fear.Value then
                lplr.PlayerScripts.FOVAdjusters.Fear.Value = 1
            else
                lplr.PlayerScripts.FOVAdjusters.Fear.Value = 1
            end
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if Settings.AutoRespawn then
            if lplr.Character:GetAttribute("Downed") then
                Respawn()
            end
        end
    end
end)





local Toggle = T1:CreateToggle({
    Name = "Enable WalkSpeed",
    Info = "Enable/Disable WalkSpeed",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        Settings.WalkEnabled = Value
    end,
})

local Slider = T1:CreateSlider({
    Name = "WalkSpeed slider",
    Info = "WalkSpeed slider",
    Range = {0, 100},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 20,
    Flag = "Slider1", 
    Callback = function(Value)
        Settings.WalkSpeed = Value
    end,
})

local Toggle = T1:CreateToggle({
    Name = "Enable JumpPower",
    Info = "Enable/Disable JumpPower",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        Settings.JumpEnabled = Value
    end,
})

local Slider = T1:CreateSlider({
    Name = "JumpPower slider",
    Info = "JumpPower slider",
    Range = {0, 100},
    Increment = 1,
    Suffix = "Power",
    CurrentValue = 20,
    Flag = "Slider1", 
    Callback = function(Value)
        Settings.JumpPower = Value
    end,
})

local Toggle = T1:CreateToggle({
    Name = "Disable Camera Shake",
    Info = "Disables your camera shake",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        Settings.CameraShake = Value
    end,
})

local Toggle = T1:CreateToggle({
    Name = "Disable Fear Fov Change",
    Info = "Disables the change in fov when you are scared",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        Settings.FearFov = Value
    end,
})

local Toggle = T1:CreateToggle({
    Name = "Auto Respawn",
    Info = "Auto Respawns",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        Settings.AutoRespawn = Value
    end,
})

local Toggle = T6:CreateToggle({
	Name = "Revive AutoFarm",
	CurrentValue = false,
	Flag = "Toggle1", 
	Callback = function(Value)
        Settings.ReviveFarm = Value
        if Value then
            coroutine.wrap(function()
                repeat
                    local suc,res = pcall(function()
                        for _,v in next, game.Players:GetPlayers() do
                            if v and v ~= lplr and Downed(v) and not isCarried(v) then
                                plrs = v
                                task.spawn(function()
                                    for _ = 1,30 do
                                        if Downed(lplr) then Respawn() end
                                        if plrs ~= v or not Downed(v) or isCarried(v) then return end
                                        if lplr and lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart") and v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                                            lplr.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                                        end
                                        task.wait(.0866666667)
                                    end
                                end)
                                task.wait(.2)
                                revive(v, false)
                                task.wait(2.2)
                                for _ = 1,2 do
                                    revive(v, true)
                                    task.wait(.1)
                                end
                                task.wait(.3)
                            end
                        end
                    end)
                    if not suc then Lib:prompt("[ReviveAutoFarm Error]: "..res, 5) end
                    task.wait()
                until Settings.ReviveFarm == false
            end)()
        end
	end,
})

local Toggle = T2:CreateToggle({
    Name = "Lever Esp",
    Info = "Puts a text esp on levers",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        Settings.LeverEsp = Value
    end,
})

local Dropdown = T4:CreateDropdown({
    Name = "Teleport Choose",
    Options = {"Main", "BigTeam", "SocialSpace", "TeamDeathmatch", "Casual", "VcOnly", "Infection", "Pro", "PlayerNextbot"},
    CurrentOption = "Choose a game",
    Flag = "Dropdown1",
    Callback = function(Option)
        if Option == "Main" then
            Id = 9872472334
        elseif Option == "BigTeam" then
            Id = 10324346056
        elseif Option == "SocialSpace" then
            Id = 10324347967
        elseif Option == "TeamDeathmatch" then
            Id = 10539706691
        elseif Option == "Casual" then
            Id = 10662542523
        elseif Option == "VcOnly" then
            Id = 10808838353
        elseif Option == "Infection" then
            Id = 11353532384
        elseif Option == "Pro" then
            Id = 11353528705
        elseif Option == "PlayerNextbot" then
            Id = 11987867148
        end
    end,
})

local Button = T4:CreateButton({
    Name = "Teleport To game",
    Info = "Teleport to chosen game",
    Interact = 'Teleport',
    Callback = function()
        teleportservice:Teleport(Id,lplr)
    end,
})

--settings

local Label2 = T8:CreateLabel("Sending no information for now ):")
local Label = T8:CreateLabel("Webhook not Set")

local Input = T8:CreateInput({
    Name = "Webhook",
    Info = "Webhook Input",
    PlaceholderText = "Webhook here",
    NumbersOnly = false, 
    CharacterLimit = 1000,
    OnEnter = true,
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text:match("https://discord.com/api/webhooks/%d+/%w+") then
            WebhookUrl = Text
            Label:Set("Webhook Set")
        else
            Lib:prompt("Invalid Webhook", "Please enter a valid webhook", 5)
        end
    end,
})

local Button = T8:CreateButton({
    Name = "Test Webhook",
    Info = "Will send a webhook Request",
    Interact = 'Press',
    Callback = function()
        Util.Webhook:Embed(WebhookUrl, "Testing", "Test", "Testing webhook")
    end,
})

local Toggle = T8:CreateToggle({
    Name = "Webhook Send info",
    Info = "Sends some info to the webhook",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        WebhookSendinfo = Value
    end,
})