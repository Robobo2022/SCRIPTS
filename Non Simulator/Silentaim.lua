local plrs = game:GetService("Players")
local plr = plrs.LocalPlayer
local mouse = plr:GetMouse()
local camera = game:GetService("Workspace").CurrentCamera

function notBehindWall(target)
    local ray = Ray.new(plr.Character.Head.Position, (target.Position - plr.Character.Head.Position).Unit * 300)
    local part, position = game:GetService("Workspace"):FindPartOnRayWithIgnoreList(ray, {plr.Character}, false)
    if part then
        local humanoid = part.Parent:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            humanoid = part.Parent.Parent:FindFirstChildOfClass("Humanoid")
        end
        if humanoid and target and humanoid.Parent == target.Parent then
            local pos, visible = camera:WorldToScreenPoint(target.Position)
            if visible then
                return true
            end
        end
    end
end
 
function getPlayerClosestToMouse()
    local target = nil
    local maxDist = math.huge
    for _,v in pairs(plrs:GetPlayers()) do
        if v.Character then
            if v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") then
                local pos, vis = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).magnitude
                if dist < maxDist and vis then
                    local torsoPos = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                    local torsoDist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(torsoPos.X, torsoPos.Y)).magnitude
                    local headPos = camera:WorldToViewportPoint(v.Character.Head.Position)
                    local headDist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(headPos.X, headPos.Y)).magnitude
                    if torsoDist > headDist then
                        if notBehindWall(v.Character.Head) then
                            target = v.Character.Head
                        end
                    else
                        if notBehindWall(v.Character.HumanoidRootPart) then
                            target = v.Character.HumanoidRootPart
                        end
                    end
                    maxDist = dist
                end
            end
        end
    end
    return target
end

local old
local function getArgs(...)
    local args = {...}
    return args
end
local function checkArgs(args)
    return typeof(args[2][1]) == "Vector3"
end
local function fixArgs(args)
    args[2][1] = getPlayerClosestToMouse().CFrame
    return args
end
local function checkMethod(method)
    return tostring(self) == "fire" and method == "FireServer"
end
local function checkObject(object)
    return tostring(object) == "fire"
end
local function checkHook()
    return old == nil
end
local function hook()
    old = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = getArgs(...)
        if checkObject(self) then
            if checkMethod(method) then
                if checkArgs(args) then
                    args = fixArgs(args)
                end
            end
        end
        return old(self, unpack(args))
    end)
end
local function checkUnhook()
    return old ~= nil
end
local function unhook()
    old = unhookmetamethod(game, "__namecall", old)
end
hook()
if checkUnhook() then
    unhook()
end