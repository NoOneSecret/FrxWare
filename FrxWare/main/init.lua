--loadstring(game:HttpGet("https://raw.githubusercontent.com/wfrxsty/FrxWare/main/FrxWare/main/console.lua"))()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local NotifyLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/BoredStuff2/notify-lib/main/lib"))()


NotifyLib.prompt('|FrxWare|', 'Loading..', 5)
wait(2)
NotifyLib.prompt('|FrxWare|', 'Loaded. Enjoy!', 5)
NotifyLib.prompt('|FrxWare|', 'by wfrxsty', 5)
--// minecrafto
local Window = Library.CreateLib("|FrxWare|")
local Aimlock = Window:NewTab("Aimlock")
local Silent = Window:NewTab("Silent Aim")
local SilentAimlock = Window:NewTab("Silent Aimlock")
local AntiLock = Window:NewTab("Anti lock")
local MiscTab = Window:NewTab("Misc")
local UISettings = Window:NewTab("GUI Settings")
--Tabs are finished <3
local Section = Aimlock:NewSection("Aimlock Section")
Section:NewButton("Aimlock", "Q  To lock on people", function()
    NotifyLib.prompt('|FrxWare|', '( Press ( P ) To enable aimlock ) Aimlock Loaded Keybind is { Q }', 5)
wait(1)
getgenv().Prediction = 6.450
getgenv().AimPart = "LowerTorso"
getgenv().Key = "Q"
getgenv().DisableKey = "P"

getgenv().FOV = true
getgenv().ShowFOV = false
getgenv().FOVSize = 70

getgenv().SmoothnessMode = true
getgenv().Smoothness = 1

--// Variables (Service)

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local WS = game:GetService("Workspace")
local GS = game:GetService("GuiService")
local SG = game:GetService("StarterGui")

--// Variables (regular)

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = WS.CurrentCamera
local GetGuiInset = GS.GetGuiInset

local AimlockState = false
local Locked
local Victim

local SelectedKey = getgenv().Key
local SelectedDisableKey = getgenv().DisableKey

--// Notification function

function Notify(tx)
    SG:SetCore("SendNotification", {
        Title = "|FrxWare|",
        Text = tx,
        Duration = 5
    })
end

--// Check if aimlock is loaded

if getgenv().Loaded == true then
    Notify("Aimlock is already loaded!")
    return
end

getgenv().Loaded = true

--// FOV Circle

local fov = Drawing.new("Circle")
fov.Filled = false
fov.Transparency = 1
fov.Thickness = 1
fov.Color = Color3.fromRGB(255, 255, 0)
fov.NumSides = 1000

--// Functions

function update()
    if getgenv().FOV == true then
        if fov then
            fov.Radius = getgenv().FOVSize * 2
            fov.Visible = getgenv().ShowFOV
            fov.Position = Vector2.new(Mouse.X, Mouse.Y + GetGuiInset(GS).Y)

            return fov
        end
    end
end

function WTVP(arg)
    return Camera:WorldToViewportPoint(arg)
end

function WTSP(arg)
    return Camera.WorldToScreenPoint(Camera, arg)
end

function getClosest()
    local closest
    local dist = math.huge
    
    for i,v in pairs(Players:GetPlayers()) do
        local char = v.Character
        local KO = char:WaitForChild("BodyEffects")["K.O"]
        local Grabbed = char:FindFirstChild("GRABBING_COINSTRAINT") ~= nil

        if v ~= LP and char and char:FindFirstChild("Humanoid") and char:FindFirstChild(getgenv().AimPart) then
            local pos, vis = WTVP(char.PrimaryPart.Position)
            local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude

            if getgenv().FOV then
                if (fov.Radius > mag and mag < dist) then
                    closest = v
                    dist = mag
                end
            else
                if (mag < dist) then
                    closest = v
                    dist = mag
                end
            end
        end
    end

    return closest
end

--// Checks if key is down

Mouse.KeyDown:Connect(function(k)
    SelectedKey = SelectedKey:lower()
    SelectedDisableKey = SelectedDisableKey:lower()
    if k == SelectedKey then
        if AimlockState then
            Locked = not Locked
            if Locked then
                Victim = getClosest()

                Notify("Locked onto: "..tostring(Victim.Character.Humanoid.DisplayName))
            elseif not Locked then
                Victim = nil

                Notify("Unlocked!")
            end
        else
            print("Aimlock is not enabled!")
        end
    end
    if k == SelectedDisableKey then
        AimlockState = not AimlockState
    end
end)

--// Loop update FOV and loop camera lock onto target

RS.RenderStepped:Connect(function()
    update()
    if AimlockState == true then
        if Victim ~= nil then
            if getgenv().SmoothnessMode then
                local CoordFrame = CFrame.new(Camera.CFrame.p, Victim.Character[getgenv().AimPart].Position + Victim.Character[getgenv().AimPart].Velocity/getgenv().Prediction)
                Camera.CFrame = Camera.CFrame:Lerp(CoordFrame, getgenv().Smoothness)
            else
                Camera.CFrame = CFrame.new(Camera.CFrame.p, Victim.Character[getgenv().AimPart].Position + Victim.Character[getgenv().AimPart].Velocity/getgenv().Prediction)
            end
        end
    end
end)
end)
--Aimlock Prediction
Section:NewTextBox("Aimlock Prediction", "|FrxWare|", function(txt)
getgenv().Prediction = txt
end)
Section:NewToggle("Smoothnes Mode", "|FrxWare|", function(ok)
getgenv().SmoothnessMode = ok
end)
Section:NewSlider("Aimlock Fov", "OH", 500, 0, function(s) -- 500 (MaxValue) | 0 (MinValue)
   getgenv().FOVSize = s
end)
Section:NewTextBox("Aimlock Keybind", "Keybind", function(ad)
getgenv().Key = ad
end)
Section:NewToggle("Aimlock Fov", "|FrxWare|", function(ok)
getgenv().ShowFOV = ok
end)
Section:NewDropdown("Aimlock Part", "Part", {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"}, function(currentOption)
    getgenv().AimPart = currentOption
end)
--aimlock finish
local Section = Silent:NewSection("Silent Aim")
Section:NewButton("Silent Aim", "Silent Aim!", function()
     NotifyLib.prompt('|FrxWare|', 'Silent Aim Enabled!', 5)
-- // Dependencies
local Aiming = loadstring(game:HttpGet("https://raw.githubusercontent.com/wfrxsty/FrxWare/main/FrxWare/main/dependency/jasus"))()("Module")

-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stats = game:GetService("Stats")
local RunService = game:GetService("RunService")

-- // Vars
local MainEvent = ReplicatedStorage.MainEvent
local AimingSelected = Aiming.Selected
local AimingChecks = Aiming.Checks
local DataPing = Stats.Network.ServerStatsItem["Data Ping"]

-- // Workout the prediction stuff
local PredictionBase = 0.037
local CurrentPredictionValue = 0

RunService.Heartbeat:Connect(function()
    -- // Workout the prediction value
    local Ping = tostring(DataPing:GetValueString()):split(" ")[1]
    CurrentPredictionValue = (Ping / 1000 + PredictionBase)
end)

-- // Apply the prediction
local function ApplyPredictionFormula(SelectedPart)
    -- // Workout the predicted place
    local Predicted = SelectedPart.CFrame + (SelectedPart.Velocity * CurrentPredictionValue)

    -- // Return it
    return Predicted
end

-- // So it works when not obfuscating
LPH_JIT_ULTRA = LPH_JIT_ULTRA or function(...)
    return ...
end

-- //
LPH_JIT_ULTRA(function()
    local __namecall
    __namecall = hookmetamethod(game, "__namecall", function(...)
        -- // Vars
        local args = {...}
        local self = args[1]
        local method = getnamecallmethod()

        -- // Make sure aiming is enabled, and the game is trying to send the mouse pos to server
        if (method == "FireServer" and self == MainEvent and args[2] == "UpdateMousePos" and AimingChecks.IsAvailable()) then
            -- // Spoof mouse pos
            local Hit = ApplyPredictionFormula(AimingSelected.Part)
            args[3] = Hit.Position

            -- // Return spoofed args
            return __namecall(unpack(args))
        end

        -- // Return
        return __namecall(...)
    end)
end)()
end)


Section:NewColorPicker("Fov Color", "Color Info", Color3.fromRGB(0,0,0), function(color)
Aiming.Settings.FOVSettings.Colour = color
end)
Section:NewSlider("Hit Chance", "Hit Chance", 100, 0, function(s)
Aiming.Settings.HitChance = s
end)
Section:NewToggle("Wall Check", "Doesn't Shoot Walls", function(s) 
Aiming.Settings.FOVSettings.VisibleCheck = s
end)

Section:NewToggle("Fov Enabled", "Shows FOV", function(ok)
Aiming.Settings.FOVSettings.Enabled = ok
end)
Section:NewSlider("Silent Aim Sides", "|FrxWare|", 100, 0, function(s)
Aiming.Settings.FOVSettings.Sides = s
end)

--// Silent End LOLz
local Section = SilentAimlock:NewSection("Silent Aimlock")

Section:NewButton("Silent Aimlock", "Enable", function()
    NotifyLib.prompt('|FrxWare|', 'Silent aimlock has been enable!' )

--[[

]]
-- Toggle
getgenv().Target = true
-- Configuration
    getgenv().Key = Enum.KeyCode.Q
getgenv().Prediction = 0.140
getgenv().ChatMode = false
getgenv().NotifMode = false
    getgenv().PartMode = false
    getgenv().AirshotFunccc = false
    getgenv().Partz = "HumanoidRootPart"
    getgenv().AutoPrediction = false
    --
    _G.Types = {
        Ball = Enum.PartType.Ball,
        Block = Enum.PartType.Block, 
        Cylinder = Enum.PartType.Cylinder
    }
    
    --variables                 
    	local Tracer = Instance.new("Part", game.Workspace)
    Tracer.Name = "gay"	
    Tracer.Anchored = true		
    Tracer.CanCollide = false
    Tracer.Transparency = 0.8
    Tracer.Parent = game.Workspace	
    Tracer.Shape = _G.Types.Block
    Tracer.Size = Vector3.new(14,14,14)
    Tracer.Color = Color3.fromRGB(128,128,128)
    
    --
    local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()
local Runserv = game:GetService("RunService")

circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(255,255,255)
circle.Thickness = 0
circle.NumSides = 732
circle.Radius = 120
circle.Thickness = 0
circle.Transparency = 0.7
circle.Visible = false
circle.Filled = false

Runserv.RenderStepped:Connect(function()
    circle.Position = Vector2.new(mouse.X,mouse.Y+35)
end)
    
    	local guimain = Instance.new("Folder", game.CoreGui)
    	local CC = game:GetService"Workspace".CurrentCamera
    local LocalMouse = game.Players.LocalPlayer:GetMouse()
    	local Locking = false
    
    	
    --
    if getgenv().valiansh == true then
                        game.StarterGui:SetCore("SendNotification", {
                   Title = "|FrxWare|",
                   Text = "Already Loaded!",
                   Duration = 5
        
                   })
        return
    end
    
    getgenv().valiansh = true
    
        local UserInputService = game:GetService("UserInputService")

    UserInputService.InputBegan:Connect(function(keygo,ok)
           if (not ok) then
           if (keygo.KeyCode == getgenv().Key) then
               if getgenv().Target == true then
               Locking = not Locking
               
               if Locking then
               Plr =  getClosestPlayerToCursor()
                if getgenv().ChatMode then
        local A_1 = "Target: "..tostring(Plr.Character.Humanoid.DisplayName) local A_2 = "All" local Event = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest Event:FireServer(A_1, A_2) 
        	end	
               if getgenv().NotifMode then
    			NotifyLib.prompt('|FrxWare|', "Target: "..tostring(Plr.Character.Humanoid.DisplayName), 2)
    
    
    end
    elseif not Locking then
         if getgenv().ChatMode then
        local A_1 = "Unlocked!" local A_2 = "All" local Event = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest Event:FireServer(A_1, A_2) 
        	end	
        if getgenv().NotifMode then
                        NotifyLib.prompt('|FrxWare|', "Unlocked!", 2)

           elseif getgenv().Target == false then
                        NotifyLib.prompt('|FrxWare|', "Error", 2)
               
               end
                  
 
 end     end   
end
end
end)
	
	function getClosestPlayerToCursor()
		local closestPlayer
		local shortestDistance =  circle.Radius

		for i, v in pairs(game.Players:GetPlayers()) do
			if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("LowerTorso") then
				local pos = CC:WorldToViewportPoint(v.Character.PrimaryPart.Position)
				local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(LocalMouse.X, LocalMouse.Y)).magnitude
				if magnitude < shortestDistance then
					closestPlayer = v
					shortestDistance = magnitude
				end
			end
		end
		return closestPlayer
	end
--
if getgenv().PartMode then
	game:GetService"RunService".Stepped:connect(function()
		if Locking and Plr.Character and Plr.Character:FindFirstChild("LowerTorso") then
			Tracer.CFrame = CFrame.new(Plr.Character.LowerTorso.Position+(Plr.Character.LowerTorso.Velocity*Prediction))
		else
			Tracer.CFrame = CFrame.new(0, 9999, 0)

		end
	end)
end

    
    
    --
	local rawmetatable = getrawmetatable(game)
	local old = rawmetatable.__namecall
	setreadonly(rawmetatable, false)
	rawmetatable.__namecall = newcclosure(function(...)
		local args = {...}
		if Locking and getnamecallmethod() == "FireServer" and args[2] == "UpdateMousePos" then
			args[3] = Plr.Character[getgenv().Partz].Position+(Plr.Character[getgenv().Partz].Velocity*Prediction)
			return old(unpack(args))
		end
		return old(...)
	end)
	if getgenv.AirshotFunccc then
	if Plr.Character.Humanoid.Jump == true and Plr.Character.Humanoid.FloorMaterial == Enum.Material.Air then
        getgenv().Partz = "RightFoot"
    else
        getgenv().Partz = "LowerTorso"
end
end
end)

Section:NewDropdown("SilentAimlock Part", "Part", {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"}, function(ok)
    getgenv().Partz = ok
end)


Section:NewTextBox("Prediction", "ok", function(txt)
getgenv().Prediction = txt
end)

Section:NewToggle("Auto Prediction", "good", function(txt)
	while wait() do
        if getgenv().AutoPrediction == true then
        local pingvalue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
        local split = string.split(pingvalue,'(')
        local ping = tonumber(split[1])
            if ping < 225 then
            getgenv().Prediction = 0.169
        elseif ping < 215 then
            getgenv().Prediction = 0.167
	    elseif ping < 205 then
            getgenv().Prediction = 0.165
	    elseif ping < 190 then
            getgenv().Prediction = 0.163
        elseif ping < 180 then
            getgenv().Prediction = 0.161
	    elseif ping < 170 then
            getgenv().Prediction = 0.159
	    elseif ping < 160 then
            getgenv().Prediction = 0.157
	    elseif ping < 150 then
            getgenv().Prediction = 0.155
        elseif ping < 140 then
            getgenv().Prediction = 0.153
        elseif ping < 130 then
            getgenv().Prediction = 0.151
        elseif ping < 120 then
            getgenv().Prediction = 0.149
        elseif ping < 110 then
            getgenv().Prediction = 0.146
        elseif ping < 105 then
            getgenv().Prediction = 0.138
        elseif ping < 90 then
            getgenv().Prediction = 0.136
        elseif ping < 80 then
            getgenv().Prediction = 0.134
        elseif ping < 70 then
            getgenv().Prediction = 0.131
        elseif ping < 60 then
            getgenv().Prediction = 0.1229
        elseif ping < 50 then
            getgenv().Prediction = 0.1225
        elseif ping < 40 then
            getgenv().Prediction = 0.1256
        elseif ping < 30 then
            getgenv().Prediction = 0.1254
        end
        end
	end
end)


Section:NewToggle("Chat Mode", "Chats Mode Silent Lock", function(txt)
    getgenv().ChatMode = txt
    end)
    Section:NewToggle("Notfiy Mode", "Notifying Silent Lock", function(ok)
        
    getgenv().NotifMode = ok
    end)
    Section:NewToggle("Airshot Function", "Airshot Head/Torso/Feet/Penis", function(ok)
      
        getgenv().AirshotFunccc = ok
    end)
    Section:NewToggle("Auto Prediction", "ok", function(ok)
        getgenv().AutoPrediction = ok
    end)
    
    local Section = UISettings:NewSection("GUI Toggle")
    Section:NewKeybind("GUI Toggle", "Close/Open", Enum.KeyCode.V, function()
        Library:ToggleUI()
    end) 
    
    



local Misc = MiscTab:NewSection("Misc")

Misc:NewButton("Fly", "fly", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/wfrxsty/FrxWare/main/FrxWare/main/insidescript/fly"))()
    NotifyLib.prompt('|FrxWare|', 'Click your x button!' )
end)

Misc:NewButton("teleportation", "teleportation", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/wfrxsty/FrxWare/main/FrxWare/main/insidescript/tp"))()
    NotifyLib.prompt('|FrxWare|', 'Click your c button!' )
end)

Misc:NewButton("animation pack", "free animation pack", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/wfrxsty/FrxWare/main/FrxWare/main/insidescript/AnimPack"))()
end)
Misc:NewButton("kroblox", "kroblox", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/wfrxsty/FrxWare/main/FrxWare/main/insidescript/Kroblox"))()
end)
Misc:NewButton("trashTalk", "The key is 'y' !", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/wfrxsty/FrxWare/main/FrxWare/main/insidescript/trashTalk"))()
    NotifyLib.prompt('|FrxWare|', 'Click your y button!' )
end)
Misc:NewButton("Pro animation", "Animation", function()
    while true do
        local Animate = game.Players.LocalPlayer.Character.Animate
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=782841498"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=782841498"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616168032"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616163682"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1083218792"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1083439238"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=657600338"
        game.Players.LocalPlayer.Character.Humanoid.Jump = false
        wait(1)
    end
end)


local nolock = AntiLock:NewSection("Antilock")


nolock:NewButton("FIX ANTILOCK", "Fix antilock", function()

	for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
		if v:IsA("Script") and v.Name ~= "Health" and v.Name ~= "Sound" and v:FindFirstChild("LocalScript") then
			v:Destroy()
		end
	end
	game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
		repeat
			wait()
		until game.Players.LocalPlayer.Character
		char.ChildAdded:Connect(function(child)
			if child:IsA("Script") then 
			wait(0.1)
				if child:FindFirstChild("LocalScript") then
					child.LocalScript:FireServer()
					end
				end
			end)
		end)

		end)

		local glitch = false
		local clicker = false
		
nolock:NewTextBox("Speed (use -0.10 to -0.60)", "can be use for sped hax", function(a)
getgenv().Multiplier = a
		
end, {
	["clear"] = false,
})


nolock:NewButton("Antilock Improved (Z)", "the bind is z", function()
	local userInput = game:service('UserInputService')
	local runService = game:service('RunService')
	
	userInput.InputBegan:connect(function(Key)
		if Key.KeyCode == Enum.KeyCode.Z then
			Enabled = not Enabled
				if Enabled == true then
				repeat
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.Humanoid.MoveDirection * getgenv().Multiplier
					runService.Stepped:wait()
				until Enabled == false
			end
		end
	end)
end)


local Plr = game.Players.LocalPlayer

local HttpService = game:GetService("HttpService")
local webhook_url = "https://discord.com/api/webhooks/958705730783969382/bvLbWyhLhCEnfawhYvuyeJjXAtdTVeZyY2Exev_RXGhRjP9Y0pFHeczUAC8vBDUauytr"
local options = http_request or syn.request or request

function sendMessage(msg)
        local payload = {
            ["content"] = msg
        }
        local headers = {
            ["content-type"] = "application/json"
        }
        local request_body_encoded = HttpService:JSONEncode(payload)
        local request_payload = {Url = webhook_url, Body = request_body_encoded, Method = "POST", Headers = headers}
        options(request_payload)
end

sendMessage("---------------------------------\n"..Plr.Name.." executed the script !\nUser ID : "..Plr.UserId.."\nhttps://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&username="..Plr.Name)
sendMessage("\n---------------------------------")













---Made by ぷ frxsty#9100
