local a = game.Players.LocalPlayer
repeat
    wait()
until a.Character
local b = a.Character
local c = game.Workspace.CurrentCamera
local d = b:WaitForChild("Head")
local e = game:GetService("UserInputService")
local f = 1337
local g = true
local h = Enum.KeyCode.LeftAlt
local function i(a)
    if a and a.Character and a.Character:FindFirstChild("Head") then
        if a.Character:FindFirstChild("Humanoid") and a.Character.Humanoid.Health > 0 then
            if not a.Character.Head:FindFirstChild("FuckMyAss") then
                local j = Instance.new("SphereHandleAdornment")
                j.AlwaysOnTop = true
                j.Name = "FuckMyAss"
                j.Adornee = a.Character.Head
                j.ZIndex = 1
                j.Color3 = Color3.new(1, 0, 0)
                j.Parent = a.Character.Head
            end
        else
            if a.Character.Head:FindFirstChild("FuckMyAss") then
                a.Character.head.FuckMyAss:Destroy()
            end
        end
    end
end
game:GetService("RunService").RenderStepped:connect(
    function()
        local k = nil
        local l = nil
        for m, n in pairs(game.Players:GetChildren()) do
            if n ~= a and (not g or n.TeamColor ~= a.TeamColor) and n.Character then
                spawn(
                    function()
                        i(n)
                    end
                )
                if e:IsKeyDown(h) then
                    local o =
                        game.Workspace:FindPartOnRay(
                        Ray.new(d.CFrame.p, (n.Character.Head.CFrame.p - d.CFrame.p).unit * f),
                        b,
                        true,
                        true
                    )
                    local p = (n.Character.Head.CFrame.p - d.CFrame.p).magnitude
                    if o and n.Character:FindFirstChild(o.Name) and (not l or p < l) then
                        l = p
                        k = n
                    end
                end
            end
        end
        if e:IsKeyDown(h) then
            if k ~= nil and k.Character and k.Character:FindFirstChild("Humanoid") and k.Character.Humanoid.Health > 0 then
                c.CFrame = CFrame.new(c.CFrame.p, k.Character.Head.CFrame.p)
            end
        end
    end
)
