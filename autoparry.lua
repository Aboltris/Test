local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local function isBallClose(ball)
    local distance = (ball.Position - hrp.Position).Magnitude
    return distance < 15
end

local function attemptParry()
    local virtualInput = game:GetService("VirtualInputManager")
    virtualInput:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    wait(0.1)
    virtualInput:SendKeyEvent(false, Enum.KeyCode.F, false, game)
end

while task.wait(0.05) do
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Name == "Ball" then
            if isBallClose(obj) then
                attemptParry()
            end
        end
    end
end
