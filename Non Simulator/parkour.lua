for _,v in next, getconnections(game:GetService("ScriptContext").Error) do
    v:Disable()
end

for _,v in next, getconnections(game:GetService("LogService").MessageOut) do
    v:Disable()
end

local getupvalue = (getupvalue or debug.getupvalue);
local hookmetamethod = hookmetamethod or function(tbl, mt, func) return hookfunction(getrawmetatable(tbl)[mt], func) end;

repeat wait() until game:IsLoaded();
local players = game:GetService("Players");
local lplr = players.LocalPlayer;
local variables, mainEnv, encrypt;
local runservice = game:GetService("RunService");

do
    local banRemotes = {
        "FireToDieInstantly";
        "LoadString";
        "FlyRequest";
        "FinishTimeTrial";
        "UpdateDunceList";
        "FF";
        "okbye";
        "Fling";
        "ClientFling";
        "LCombo";
        "SubmitCombo";
        "GetCurrentCombo";
        "MaxCombo";
        "UpdateCombo";
    }

    local hook
    hook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        if (method == "FireServer" and table.find(banRemotes, self.Name)) then
            return
        end
        if (method == "InvokeServer" and table.find(banRemotes, self.Name)) then
            return
        end
        return hook(self, unpack(args))
    end))

    local old
    old = hookmetamethod(game, "__index", newcclosure(function(self, key)
        if (key == "PlaybackLoudness" and getfenv(2).script.Name == "RadioScript") then
            return 0;
        end

        return old(self, key);
    end))
    
    local function onCharacterAdded(char)
        if (not char)  then return end
        wait(1)
        local Main = lplr.Backpack:WaitForChild("Main")
        variables = getupvalue(getsenv(Main).charJump, 1)
        variables.adminLevel = 13
        getfenv().script = Main
        mainEnv = getsenv(Main)
        main = getupvalue(getsenv(game:GetService("Players").LocalPlayer.Backpack:WaitForChild("Main")).resetAmmo, 1)
        encrypt = function(string)
            local _, res = pcall(mainEnv.encrypt, string)
            return res
        end
    end
    onCharacterAdded(lplr.Character);
    lplr.CharacterAdded:Connect(onCharacterAdded);
end

local moves = {
    "dropdown";
    "longjump";
    "dropdown";
};

local Settings = {
    autofarm = false,
    autocombo = false,
    combolvl = 1,
    Nofall = false,
    Slidespeed = false,
    slidevalue = 1,
    chargecooldown = false,
    infwallboost = false,
    trickpass = false,
    reset = false,
    resetvalue = 10000,
    flow = false,
    stimeject = false,
}

task.spawn(function()
    while task.wait() do
        if Settings.flow then
            main.flowActive = true
            main.flowDelta = 100
            main.flowAlpha = 100
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if Settings.reset then
            if lplr.leaderstats.Points.Value >= Settings.resetvalue then
                game:GetService("ReplicatedStorage").Reset:InvokeServer()
            end
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if Settings.trickpass then
            main.hasTricksPass = Settings.trickpass
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if Settings.infwallboost then
            main.numWallclimb = math.huge
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if Settings.autocombo then
            main.comboLevel = Settings.combolvl    
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if Settings.Slidespeed then
            main.slidespeed = Settings.slidevalue
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if Settings.chargecooldown then
            main.chargeCooldown = 0
        end
    end
end)

local Nofall
Nofall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if (method == "TakeDamage" and self.ClassName == "Humanoid") and Settings.Nofall then
        return
    end
    return Nofall(self, unpack(args))
end))

local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'Parkour',
    Center = true, 
    AutoShow = true,
})

local Tabs = {
    Main = Window:AddTab('Main'),
    Misc = Window:AddTab('Misc'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Player')
local RightGroupBox = Tabs.Main:AddRightGroupbox('Exp')
local LeftGroupBox1 = Tabs.Misc:AddLeftGroupbox('Other')

RightGroupBox:AddToggle('ComboToggle', {
    Text = 'Combo',
    Default = false,
    Tooltip = 'Toggles the combo feature',
})

Toggles.ComboToggle:OnChanged(function()
    Settings.autocombo = Toggles.ComboToggle.Value
end)

RightGroupBox:AddSlider('Combo', {
    Text = 'Combo lvl',
    Default = 1,
    Min = 0,
    Max = 5,
    Rounding = 0,
    Compact = false,
})

Options.Combo:OnChanged(function()
    Settings.combolvl = Options.Combo.Value
end)

LeftGroupBox:AddToggle('Nofall', {
    Text = 'No fall',
    Default = false,
    Tooltip = 'Toggles the No fall feature',
})

Toggles.Nofall:OnChanged(function()
    Settings.Nofall = Toggles.Nofall.Value
end)

LeftGroupBox:AddToggle('slideToggle', {
    Text = 'Slide speed',
    Default = false,
    Tooltip = 'toggles slide speed feature',
})

Toggles.slideToggle:OnChanged(function()
    Settings.Slidespeed = Toggles.slideToggle.Value
end)

LeftGroupBox:AddSlider('slideValue', {
    Text = 'slide speed value',
    Default = 34,
    Min = 34,
    Max = 1000,
    Rounding = 0,
    Compact = false,
})

Options.slideValue:OnChanged(function()
    Settings.slidevalue = Options.slideValue.Value
end)

LeftGroupBox:AddToggle('Charge', {
    Text = 'no charge cooldown',
    Default = false,
    Tooltip = 'Toggles the no charge feature',
})

Toggles.Charge:OnChanged(function()
    Settings.chargecooldown = Toggles.Charge.Value
end)

LeftGroupBox:AddToggle('wallboost', {
    Text = 'inf wallboost',
    Default = false,
    Tooltip = 'Toggles the inf wallboost feature',
})

Toggles.wallboost:OnChanged(function()
    Settings.infwallboost = Toggles.wallboost.Value
end)

LeftGroupBox:AddToggle('tricking', {
    Text = 'freerunnning pass',
    Default = false,
    Tooltip = 'gives freerunning pass features',
})

Toggles.tricking:OnChanged(function()
    Settings.trickpass = Toggles.tricking.Value
end)

local MyButton = RightGroupBox:AddButton('Autofarm', function()
    runservice.RenderStepped:Connect(function()
        if (lplr.Backpack and lplr.Backpack:FindFirstChild("Main") and lplr.PlayerScripts:FindFirstChild("Points") and getsenv(lplr.Backpack.Main)) then
            local pointsEnv = getsenv(lplr.PlayerScripts.Points);
            pointsEnv.changeParkourRemoteParent(workspace);
          
            local scoreRemote = getupvalue(pointsEnv.changeParkourRemoteParent, 2);
          
            while wait() do
                scoreRemote:FireServer(encrypt("walljump"), {
                    [encrypt("walljumpDelta")] = encrypt(tostring(3.55));
                    [encrypt("combo")] = encrypt(tostring(5));
                });
    
                scoreRemote:FireServer(encrypt("longjump"), {
                    [encrypt("combo")] = encrypt(tostring(5));
                });
    
                scoreRemote:FireServer(encrypt("dropdown"), {
                    [encrypt("combo")] = encrypt(tostring(5));
                });

                scoreRemote:FireServer(encrypt("walljump"), {
                    [encrypt("walljumpDelta")] = encrypt(tostring(3.55));
                    [encrypt("combo")] = encrypt(tostring(5));
                });
    
                scoreRemote:FireServer(encrypt("longjump"), {
                    [encrypt("combo")] = encrypt(tostring(5));
                });
    
                scoreRemote:FireServer(encrypt("dropdown"), {
                    [encrypt("combo")] = encrypt(tostring(5));
                });

            end

          
            while wait() do
                scoreRemote:FireServer(encrypt(moves[#moves]), {
                    [encrypt("combo")] = encrypt(tostring(5));
                });
    
                scoreRemote:FireServer(encrypt(moves[#moves]), {
                    [encrypt("combo")] = encrypt(tostring(5));
                });
    
                scoreRemote:FireServer(encrypt(moves[#moves]), {
                    [encrypt("combo")] = encrypt(tostring(5));
                });
    
                scoreRemote:FireServer(encrypt(moves[#moves]), {
                    [encrypt("combo")] = encrypt(tostring(5));
                });
    
                scoreRemote:FireServer(encrypt(moves[#moves]), {
                    [encrypt("combo")] = encrypt(tostring(5));
                });
    
                scoreRemote:FireServer(encrypt(moves[#moves]), {
                    [encrypt("combo")] = encrypt(tostring(5));
                });
            end



          end;
    end)
end)

RightGroupBox:AddToggle('Reset', {
    Text = 'Auto turn in points',
    Default = false,
    Tooltip = 'it turns in your points automatic', 
})

Toggles.Reset:OnChanged(function()
    Settings.reset = Toggles.Reset.Value
end)

RightGroupBox:AddToggle('flow', {
    Text = 'flow',
    Default = false,
    Tooltip = 'toggles flow', 
})

Toggles.flow:OnChanged(function()
    Settings.flow = Toggles.flow.Value
end)

RightGroupBox:AddSlider('Resetvalue', {
    Text = 'Points value',
    Default = 10000,
    Min = 10000,
    Max = 10000000,
    Rounding = 0,
    Compact = false,
})

Options.Resetvalue:OnChanged(function()
    Settings.resetvalue = Options.Resetvalue.Value
end)

--Misc tab--

LeftGroupBox1:AddToggle('KeybindShow', {
    Text = 'Keybind Frame',
    Default = false,
    Tooltip = 'makes the keybind frame visible/invisible', 
})

Toggles.KeybindShow:OnChanged(function()
    Library.KeybindFrame.Visible = Toggles.KeybindShow.Value
end)

local MyButton = LeftGroupBox1:AddButton('Unlock all spawns', function()
    for _,v in pairs(game:GetService("Workspace"):GetDescendants()) do
        if v.ClassName == "SpawnLocation" then
            lplr.Character.HumanoidRootPart.CFrame = v.CFrame
            wait(1)
        end
    end
end)

--settings
Library:SetWatermark('Parkour By Hydra#8270')

Library:OnUnload(function()
    Library.Unloaded = true
end)


local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' }) 

Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings() 
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' }) 
ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')
SaveManager:BuildConfigSection(Tabs['UI Settings']) 
ThemeManager:ApplyToTab(Tabs['UI Settings'])