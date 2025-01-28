local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Folder = Instance.new("Folder", Workspace)
local Part = Instance.new("Part", Folder)
local Attachment1 = Instance.new("Attachment", Part)
Part.Anchored = true
Part.CanCollide = false
Part.Transparency = 1

local BlackHole = Instance.new("Part", Folder)
BlackHole.Size = Vector3.new(5, 5, 5)
BlackHole.Shape = Enum.PartType.Ball
BlackHole.Color = Color3.new(0, 0, 0)
BlackHole.Anchored = true
BlackHole.CanCollide = false
BlackHole.Material = Enum.Material.Neon
local BillboardGui = Instance.new("BillboardGui", BlackHole)
BillboardGui.Size = UDim2.new(0, 100, 0, 50)
BillboardGui.AlwaysOnTop = true
local TextLabel = Instance.new("TextLabel", BillboardGui)
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Text = "!"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.BackgroundTransparency = 1
TextLabel.TextScaled = true

local Updated = Mouse.Hit + Vector3.new(0, 5, 0)

local function setupNetworkAccess()
    settings().Physics.AllowSleep = false
    while true do
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                player.MaximumSimulationRadius = 0
                sethiddenproperty(player, "SimulationRadius", 0)
            end
        end
        LocalPlayer.MaximumSimulationRadius = 90000
        setsimulationradius(90000)
        RunService.Heartbeat:Wait()
    end
end

local NetworkAccess = coroutine.create(setupNetworkAccess)
coroutine.resume(NetworkAccess)

local function ForcePart(v)
    if v:IsA("Part") and not v.Anchored and not v.Parent:FindFirstChild("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
        for _, child in ipairs(v:GetChildren()) do
            if child:IsA("BodyAngularVelocity") or child:IsA("BodyForce") or child:IsA("BodyGyro") or child:IsA("BodyPosition") or child:IsA("BodyThrust") or child:IsA("BodyVelocity") or child:IsA("RocketPropulsion") then
                child:Destroy()
            end
        end

        local existingAttachment = v:FindFirstChild("Attachment")
        if existingAttachment then existingAttachment:Destroy() end

        local existingAlignPosition = v:FindFirstChild("AlignPosition")
        if existingAlignPosition then existingAlignPosition:Destroy() end

        local existingTorque = v:FindFirstChild("Torque")
        if existingTorque then existingTorque:Destroy() end

        v.CanCollide = false

        local Attachment2 = Instance.new("Attachment", v)
        local Torque = Instance.new("Torque", v)
        Torque.Torque = Vector3.new(100000, 100000, 100000)
        Torque.Attachment0 = Attachment2

        local AlignPosition = Instance.new("AlignPosition", v)
        AlignPosition.MaxForce = 9999999999999999
        AlignPosition.MaxVelocity = math.huge
        AlignPosition.Responsiveness = 200
        AlignPosition.Attachment0 = Attachment2
        AlignPosition.Attachment1 = Attachment1
    end
end

for _, v in ipairs(Workspace:GetDescendants()) do
    ForcePart(v)
end

Workspace.DescendantAdded:Connect(function(v)
    ForcePart(v)
end)

UserInputService.InputBegan:Connect(function(Key, Chat)
    if Key.KeyCode == Enum.KeyCode.E and not Chat then
        Updated = Mouse.Hit + Vector3.new(0, 5, 0)
        BlackHole.Position = Updated.Position
    end
end)

spawn(function()
    while true do
        Attachment1.WorldCFrame = Updated
        RunService.Heartbeat:Wait()
    end
end)

StarterGui:SetCore("SendNotification", {
    Title = "Script Executed";
    Text = "MODIFIED by rrqrenfier on discord :)";
    Duration = 5;
})
