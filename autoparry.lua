local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local autoParryEnabled = false

-- Функция отправки уведомления
local function notify(message)
    StarterGui:SetCore("SendNotification", {
        Title = "Auto Parry",
        Text = message,
        Duration = 2
    })
end

-- Функция парирования
local function attemptParry()
    VirtualInput:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    task.wait(0.05)
    VirtualInput:SendKeyEvent(false, Enum.KeyCode.F, false, game)
end

-- Проверка расстояния до мяча
local function isBallClose(ball)
    local distance = (ball.Position - hrp.Position).Magnitude
    return distance < 15
end

-- Обработка нажатия NumPad5
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.KeypadFive then
        autoParryEnabled = not autoParryEnabled
        local stateText = autoParryEnabled and "ВКЛЮЧЕНО" or "ВЫКЛЮЧЕНО"
        notify("Авто парирование: " .. stateText)
    end
end)

-- Основной цикл
RunService.RenderStepped:Connect(function()
    if not autoParryEnabled then return end

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Name == "Ball" then
            if isBallClose(obj) then
                attemptParry()
                break
            end
        end
    end
end)
