local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robojini/Tuturial_UI_Library/main/UI_Template_1"))()

local Window = Library.CreateLib("arsenal script nexus", "RJTheme6")

local Tab = Window:NewTab("main")

local Section = Tab:NewSection("visuals")

Section:NewButton("TriggerBot", "ButtonInfo", function()
    local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
game:GetService("RunService").RenderStepped:Connect(function()
			if mouse.Target.Parent:FindFirstChild("Humanoid") and mouse.Target.Parent.Name ~= player.Name then
				mouse1press() wait() mouse1release()
			end
end)
end)

Section:NewSlider("aimassist", "SliderInfo", 500, 0, function(s) -- 500 (Макс. значение) | 0 (Мин. значение)
    local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local AimbotEnabled = false

local TeamCheck = true -- If set to true then the script would only lock your aim at enemy team members.
local AimParts = {"Torso", "UpperTorso", "LowerTorso", "Head"} -- Where the aimbot script would lock at (first item - highest priority).
local Sensitivity = 0.0 -- How many seconds it takes for the aimbot script to officially lock onto the target's aimpart.

local CircleSides = 64 -- How many sides the FOV circle would have.
local CircleColor = Color3.fromRGB(255, 255, 255) -- (RGB) Color that the FOV circle would appear as.
local CircleTransparency = 0.25 -- Transparency of the circle.
local CircleRadius = s -- The radius of the circle / FOV.
local CircleFilled = false -- Determines whether or not the circle is filled.
local CircleVisible = true -- Determines whether or not the circle is visible.
local CircleThickness = 0 -- The thickness of the circle.
local ToggleAimbotKey = Enum.KeyCode.F15 -- The key that turns aimbot on/off
local ToggleTeamCheckKey = Enum.KeyCode.F14 -- The key that toggles the team chech condition

local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Radius = CircleRadius
FOVCircle.Filled = CircleFilled
FOVCircle.Color = CircleColor
FOVCircle.Visible = CircleVisible
FOVCircle.Radius = CircleRadius
FOVCircle.Transparency = CircleTransparency
FOVCircle.NumSides = CircleSides
FOVCircle.Thickness = CircleThickness

local function CheckHealth(player)
    if player then
        if player.Character then
            if player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("Humanoid").Health then
                return player.Character:FindFirstChild("Humanoid").Health
            end
            if player.Character.Health then
                return player.Character.Health
            end
        end
    end

    return -1
end

local function FindAimPart(character)
    for _, v in ipairs(AimParts) do
        if character:FindFirstChild(v) ~= nil then
            return character[v]
        end
    end

    return nil
end

local function GetClosestPlayer()
    local MaximumDistance = CircleRadius
    local Target = nil
    local depth = math.huge

    for _, v in next, Players:GetPlayers() do
        if v.Name ~= LocalPlayer.Name then
            if TeamCheck == false or v.Team ~= LocalPlayer.Team then
                if v.Team ~= LocalPlayer.Team then
                    if v.Character ~= nil then
                        if CheckHealth(v) ~= 0 then
                            local aimPart = FindAimPart(v.Character)
                            if aimPart then
                                local vector3, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
                                if vector3.Z >= 0 then
                                    local MousePoint = UserInputService:GetMouseLocation()
                                    local VectorDistance = math.sqrt(math.pow(vector3.X - MousePoint.X, 2) + math.pow(vector3.Y - MousePoint.Y, 2))

                                    if VectorDistance < MaximumDistance then
                                        if vector3.Z < depth then
                                            Target = aimPart
                                            depth = vector3.Z
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return Target
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == ToggleAimbotKey then
        AimbotEnabled = not AimbotEnabled
    end
    if input.KeyCode == ToggleTeamCheckKey then
        TeamCheck = not TeamCheck
    end
end)

local mousemoverel = (mousemoverel or (Input and Input.MouseMove)) or nil

local function updateMouse(target)
    if not target then return end
    local Mouse = game.Players.LocalPlayer:GetMouse()

    local posVector3 = Camera:WorldToScreenPoint(target.Position)
    local x, y = posVector3.X - Mouse.X, posVector3.Y - Mouse.Y

    if math.abs(x) > 4 then
        x = math.sign(x) * math.max(math.sqrt(math.abs(x)), 4)
    end
    if math.abs(y) > 4 then
        y = math.sign(y) * math.max(math.sqrt(math.abs(y)), 4)
    end

    if KRNL_LOADED then
        if x < 0 then
            x = x + 1 + 0xFFFFFFFF
        end
        if y < 0 then
            y = y + 1 + 0xFFFFFFFF
        end
    end

    mousemoverel(x, y)
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    FOVCircle.Radius = CircleRadius
    FOVCircle.Filled = CircleFilled
    FOVCircle.Color = CircleColor
    FOVCircle.Visible = CircleVisible
    FOVCircle.Radius = CircleRadius
    FOVCircle.Transparency = CircleTransparency
    FOVCircle.NumSides = CircleSides
    FOVCircle.Thickness = CircleThickness

    if AimbotEnabled == true then
        target = GetClosestPlayer()
        if target ~= nil then
            if mousemoverel ~= nil then
                updateMouse(target)
            else
                TweenService:Create(Camera, TweenInfo.new(Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, target.Position)}):Play()
            end
        end
    end
end)
end)

Section:NewButton("hitbox", "ButtonInfo", function()
    function getplrsname()
	for i,v in pairs(game:GetChildren()) do
		if v.ClassName == "Players" then
			return v.Name
		end
	end
end
local players = getplrsname()
local plr = game[players].LocalPlayer
coroutine.resume(coroutine.create(function()
	while  wait(1) do
		coroutine.resume(coroutine.create(function()
			for _,v in pairs(game[players]:GetPlayers()) do
				if v.Name ~= plr.Name and v.Character then
					v.Character.RightUpperLeg.CanCollide = false
					v.Character.RightUpperLeg.Transparency = 10
					v.Character.RightUpperLeg.Size = Vector3.new(13,13,13)

					v.Character.LeftUpperLeg.CanCollide = false
					v.Character.LeftUpperLeg.Transparency = 10
					v.Character.LeftUpperLeg.Size = Vector3.new(13,13,13)

					v.Character.HeadHB.CanCollide = false
					v.Character.HeadHB.Transparency = 10
					v.Character.HeadHB.Size = Vector3.new(20,20,20)

					v.Character.HumanoidRootPart.CanCollide = false
					v.Character.HumanoidRootPart.Transparency = 0.5
					v.Character.HumanoidRootPart.Size = Vector3.new(13,13,13)

				end
			end
		end))
	end
end))
end)

Section:NewButton("Esp", "ButtonInfo", function()
    local Settings = {
    Box_Color = Color3.fromRGB(255, 0, 0),
    Tracer_Color = Color3.fromRGB(255, 0, 0),
    Tracer_Thickness = 1,
    Box_Thickness = 1,
    Tracer_Origin = "Bottom", -- Middle or Bottom if FollowMouse is on this won't matter...
    Tracer_FollowMouse = false,
    Tracers = true
}
local Team_Check = {
    TeamCheck = false, -- if TeamColor is on this won't matter...
    Green = Color3.fromRGB(0, 255, 0),
    Red = Color3.fromRGB(255, 0, 0)
}
local TeamColor = true

--// SEPARATION
local player = game:GetService("Players").LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local mouse = player:GetMouse()

local function NewQuad(thickness, color)
    local quad = Drawing.new("Quad")
    quad.Visible = false
    quad.PointA = Vector2.new(0,0)
    quad.PointB = Vector2.new(0,0)
    quad.PointC = Vector2.new(0,0)
    quad.PointD = Vector2.new(0,0)
    quad.Color = color
    quad.Filled = false
    quad.Thickness = thickness
    quad.Transparency = 1
    return quad
end

local function NewLine(thickness, color)
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(0, 0)
    line.Color = color 
    line.Thickness = thickness
    line.Transparency = 1
    return line
end

local function Visibility(state, lib)
    for u, x in pairs(lib) do
        x.Visible = state
    end
end

local function ToColor3(col) --Function to convert, just cuz c;
    local r = col.r --Red value
    local g = col.g --Green value
    local b = col.b --Blue value
    return Color3.new(r,g,b); --Color3 datatype, made of the RGB inputs
end

local black = Color3.fromRGB(0, 0 ,0)
local function ESP(plr)
    local library = {
        --//Tracer and Black Tracer(black border)
        blacktracer = NewLine(Settings.Tracer_Thickness*2, black),
        tracer = NewLine(Settings.Tracer_Thickness, Settings.Tracer_Color),
        --//Box and Black Box(black border)
        black = NewQuad(Settings.Box_Thickness*2, black),
        box = NewQuad(Settings.Box_Thickness, Settings.Box_Color),
        --//Bar and Green Health Bar (part that moves up/down)
        healthbar = NewLine(3, black),
        greenhealth = NewLine(1.5, black)
    }

    local function Colorize(color)
        for u, x in pairs(library) do
            if x ~= library.healthbar and x ~= library.greenhealth and x ~= library.blacktracer and x ~= library.black then
                x.Color = color
            end
        end
    end

    local function Updater()
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            if plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Head") ~= nil then
                local HumPos, OnScreen = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                if OnScreen then
                    local head = camera:WorldToViewportPoint(plr.Character.Head.Position)
                    local DistanceY = math.clamp((Vector2.new(head.X, head.Y) - Vector2.new(HumPos.X, HumPos.Y)).magnitude, 2, math.huge)
                    
                    local function Size(item)
                        item.PointA = Vector2.new(HumPos.X + DistanceY, HumPos.Y - DistanceY*2)
                        item.PointB = Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY*2)
                        item.PointC = Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY*2)
                        item.PointD = Vector2.new(HumPos.X + DistanceY, HumPos.Y + DistanceY*2)
                    end
                    Size(library.box)
                    Size(library.black)

                    --//Tracer 
                    if Settings.Tracers then
                        if Settings.Tracer_Origin == "Middle" then
                            library.tracer.From = camera.ViewportSize*0.5
                            library.blacktracer.From = camera.ViewportSize*0.5
                        elseif Settings.Tracer_Origin == "Bottom" then
                            library.tracer.From = Vector2.new(camera.ViewportSize.X*0.5, camera.ViewportSize.Y) 
                            library.blacktracer.From = Vector2.new(camera.ViewportSize.X*0.5, camera.ViewportSize.Y)
                        end
                        if Settings.Tracer_FollowMouse then
                            library.tracer.From = Vector2.new(mouse.X, mouse.Y+36)
                            library.blacktracer.From = Vector2.new(mouse.X, mouse.Y+36)
                        end
                        library.tracer.To = Vector2.new(HumPos.X, HumPos.Y + DistanceY*2)
                        library.blacktracer.To = Vector2.new(HumPos.X, HumPos.Y + DistanceY*2)
                    else 
                        library.tracer.From = Vector2.new(0, 0)
                        library.blacktracer.From = Vector2.new(0, 0)
                        library.tracer.To = Vector2.new(0, 0)
                        library.blacktracer.To = Vector2.new(0, 02)
                    end

                    --// Health Bar
                    local d = (Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY*2) - Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY*2)).magnitude 
                    local healthoffset = plr.Character.Humanoid.Health/plr.Character.Humanoid.MaxHealth * d

                    library.greenhealth.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2)
                    library.greenhealth.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2 - healthoffset)

                    library.healthbar.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2)
                    library.healthbar.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y - DistanceY*2)

                    local green = Color3.fromRGB(0, 255, 0)
                    local red = Color3.fromRGB(255, 0, 0)

                    library.greenhealth.Color = red:lerp(green, plr.Character.Humanoid.Health/plr.Character.Humanoid.MaxHealth);

                    if Team_Check.TeamCheck then
                        if plr.TeamColor == player.TeamColor then
                            Colorize(Team_Check.Green)
                        else 
                            Colorize(Team_Check.Red)
                        end
                    else 
                        library.tracer.Color = Settings.Tracer_Color
                        library.box.Color = Settings.Box_Color
                    end
                    if TeamColor == true then
                        Colorize(plr.TeamColor.Color)
                    end
                    Visibility(true, library)
                else 
                    Visibility(false, library)
                end
            else 
                Visibility(false, library)
                if game.Players:FindFirstChild(plr.Name) == nil then
                    connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Updater)()
end

for i, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.Name ~= player.Name then
        coroutine.wrap(ESP)(v)
    end
end

game.Players.PlayerAdded:Connect(function(newplr)
    if newplr.Name ~= player.Name then
        coroutine.wrap(ESP)(newplr)
    end
end)
end)

Section:NewButton("glow", "ButtonInfo", function()
    for i,v in pairs(game.Players:GetPlayers()) do
    if v ~= game.Players.LocalPlayer then
        local function addEsp(character)
            local newHighlight = Instance.new("Highlight")
            
            newHighlight.Parent = character
        end
        
        addEsp(v.Character)
        
        v.CharacterAdded:Connect(function(char)
            addEsp(char)
        end)
    end
end

game.Players.PlayerAdded:Connect(function(v)
     local function addEsp(character)
        local newHighlight = Instance.new("Highlight")
        
        newHighlight.Parent = character
    end
    
    addEsp(v.Character)
    
    v.CharacterAdded:Connect(function(char)
        addEsp(char)
    end)
end)
end)

Section:NewButton("aim", "ButtonInfo", function()
    
--// Preventing Multiple Processes

pcall(function()
	getgenv().Aimbot.Functions:Exit()
end)

--// Environment

getgenv().Aimbot = {}
local Environment = getgenv().Aimbot

--// Services

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local Camera = game:GetService("Workspace").CurrentCamera

--// Variables

local LocalPlayer = Players.LocalPlayer
local Title = "nexus Developer"
local FileNames = {"Aimbot", "Configuration.json", "Drawing.json"}
local Typing, Running, Animation, RequiredDistance, ServiceConnections = false, false, nil, 2000, {}

--// Support Functions

local mousemoverel = mousemoverel or (Input and Input.MouseMove)
local queueonteleport = queue_on_teleport or syn.queue_on_teleport

--// Script Settings

Environment.Settings = {
	SendNotifications = true,
	SaveSettings = true, -- Re-execute upon changing
	ReloadOnTeleport = true,
	Enabled = true,
	TeamCheck = false,
	AliveCheck = true,
	WallCheck = false, -- Laggy
	Sensitivity = 0, -- Animation length (in seconds) before fully locking onto target
	ThirdPerson = false, -- Uses mousemoverel instead of CFrame to support locking in third person (could be choppy)
	ThirdPersonSensitivity = 3, -- Boundary: 0.1 - 5
	TriggerKey = "MouseButton2",
	Toggle = false,
	LockPart = "Head" -- Body part to lock on
}

Environment.FOVSettings = {
	Enabled = true,
	Visible = true,
	Amount = 90,
	Color = "255, 255, 255",
	LockedColor = "255, 70, 70",
	Transparency = 0.5,
	Sides = 60,
	Thickness = 1,
	Filled = false
}

Environment.FOVCircle = Drawing.new("Circle")
Environment.Locked = nil

--// Core Functions

local function Encode(Table)
	if Table and type(Table) == "table" then
		local EncodedTable = HttpService:JSONEncode(Table)

		return EncodedTable
	end
end

local function Decode(String)
	if String and type(String) == "string" then
		local DecodedTable = HttpService:JSONDecode(String)

		return DecodedTable
	end
end

local function GetColor(Color)
	local R = tonumber(string.match(Color, "([%d]+)[%s]*,[%s]*[%d]+[%s]*,[%s]*[%d]+"))
	local G = tonumber(string.match(Color, "[%d]+[%s]*,[%s]*([%d]+)[%s]*,[%s]*[%d]+"))
	local B = tonumber(string.match(Color, "[%d]+[%s]*,[%s]*[%d]+[%s]*,[%s]*([%d]+)"))

	return Color3.fromRGB(R, G, B)
end

local function SendNotification(TitleArg, DescriptionArg, DurationArg)
	if Environment.Settings.SendNotifications then
		StarterGui:SetCore("SendNotification", {
			Title = TitleArg,
			Text = DescriptionArg,
			Duration = DurationArg
		})
	end
end

--// Functions

local function SaveSettings()
	if Environment.Settings.SaveSettings then
		if isfile(Title.."/"..FileNames[1].."/"..FileNames[2]) then
			writefile(Title.."/"..FileNames[1].."/"..FileNames[2], Encode(Environment.Settings))
		end

		if isfile(Title.."/"..FileNames[1].."/"..FileNames[3]) then
			writefile(Title.."/"..FileNames[1].."/"..FileNames[3], Encode(Environment.FOVSettings))
		end
	end
end

local function GetClosestPlayer()
	if not Environment.Locked then
		if Environment.FOVSettings.Enabled then
			RequiredDistance = Environment.FOVSettings.Amount
		else
			RequiredDistance = 2000
		end

		for _, v in next, Players:GetPlayers() do
			if v ~= LocalPlayer then
				if v.Character and v.Character:FindFirstChild(Environment.Settings.LockPart) and v.Character:FindFirstChildOfClass("Humanoid") then
					if Environment.Settings.TeamCheck and v.Team == LocalPlayer.Team then continue end
					if Environment.Settings.AliveCheck and v.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then continue end
					if Environment.Settings.WallCheck and #(Camera:GetPartsObscuringTarget({v.Character[Environment.Settings.LockPart].Position}, v.Character:GetDescendants())) > 0 then continue end

					local Vector, OnScreen = Camera:WorldToViewportPoint(v.Character[Environment.Settings.LockPart].Position)
					local Distance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(Vector.X, Vector.Y)).Magnitude

					if Distance < RequiredDistance and OnScreen then
						RequiredDistance = Distance
						Environment.Locked = v
					end
				end
			end
		end
	elseif (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position).X, Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position).Y)).Magnitude > RequiredDistance then
		Environment.Locked = nil
		Animation:Cancel()
		Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
	end
end

--// Typing Check

ServiceConnections.TypingStartedConnection = UserInputService.TextBoxFocused:Connect(function()
	Typing = true
end)

ServiceConnections.TypingEndedConnection = UserInputService.TextBoxFocusReleased:Connect(function()
	Typing = false
end)

--// Create, Save & Load Settings

if Environment.Settings.SaveSettings then
	if not isfolder(Title) then
		makefolder(Title)
	end

	if not isfolder(Title.."/"..FileNames[1]) then
		makefolder(Title.."/"..FileNames[1])
	end

	if not isfile(Title.."/"..FileNames[1].."/"..FileNames[2]) then
		writefile(Title.."/"..FileNames[1].."/"..FileNames[2], Encode(Environment.Settings))
	else
		Environment.Settings = Decode(readfile(Title.."/"..FileNames[1].."/"..FileNames[2]))
	end

	if not isfile(Title.."/"..FileNames[1].."/"..FileNames[3]) then
		writefile(Title.."/"..FileNames[1].."/"..FileNames[3], Encode(Environment.FOVSettings))
	else
		Environment.Visuals = Decode(readfile(Title.."/"..FileNames[1].."/"..FileNames[3]))
	end

	coroutine.wrap(function()
		while wait(10) and Environment.Settings.SaveSettings do
			SaveSettings()
		end
	end)()
else
	if isfolder(Title) then
		delfolder(Title)
	end
end

local function Load()
	ServiceConnections.RenderSteppedConnection = RunService.RenderStepped:Connect(function()
		if Environment.FOVSettings.Enabled and Environment.Settings.Enabled then
			Environment.FOVCircle.Radius = Environment.FOVSettings.Amount
			Environment.FOVCircle.Thickness = Environment.FOVSettings.Thickness
			Environment.FOVCircle.Filled = Environment.FOVSettings.Filled
			Environment.FOVCircle.NumSides = Environment.FOVSettings.Sides
			Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
			Environment.FOVCircle.Transparency = Environment.FOVSettings.Transparency
			Environment.FOVCircle.Visible = Environment.FOVSettings.Visible
			Environment.FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
		else
			Environment.FOVCircle.Visible = false
		end

		if Running and Environment.Settings.Enabled then
			GetClosestPlayer()

			if Environment.Settings.ThirdPerson then
				Environment.Settings.ThirdPersonSensitivity = math.clamp(Environment.Settings.ThirdPersonSensitivity, 0.1, 5)

				local Vector = Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position)
				mousemoverel((Vector.X - UserInputService:GetMouseLocation().X) * Environment.Settings.ThirdPersonSensitivity, (Vector.Y - UserInputService:GetMouseLocation().Y) * Environment.Settings.ThirdPersonSensitivity)
			else
				if Environment.Settings.Sensitivity > 0 then
					Animation = TweenService:Create(Camera, TweenInfo.new(Environment.Settings.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, Environment.Locked.Character[Environment.Settings.LockPart].Position)})
					Animation:Play()
				else
					Camera.CFrame = CFrame.new(Camera.CFrame.Position, Environment.Locked.Character[Environment.Settings.LockPart].Position)
				end
			end

			Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.LockedColor)
		end
	end)

	ServiceConnections.InputBeganConnection = UserInputService.InputBegan:Connect(function(Input)
		if not Typing then
			pcall(function()
				if Input.KeyCode == Enum.KeyCode[Environment.Settings.TriggerKey] then
					if Environment.Settings.Toggle then
						Running = not Running

						if not Running then
							Environment.Locked = nil
							Animation:Cancel()
							Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
						end
					else
						Running = true
					end
				end
			end)

			pcall(function()
				if Input.UserInputType == Enum.UserInputType[Environment.Settings.TriggerKey] then
					if Environment.Settings.Toggle then
						Running = not Running

						if not Running then
							Environment.Locked = nil
							Animation:Cancel()
							Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
						end
					else
						Running = true
					end
				end
			end)
		end
	end)

	ServiceConnections.InputEndedConnection = UserInputService.InputEnded:Connect(function(Input)
		if not Typing then
			pcall(function()
				if Input.KeyCode == Enum.KeyCode[Environment.Settings.TriggerKey] then
					if not Environment.Settings.Toggle then
						Running = false
						Environment.Locked = nil
						Animation:Cancel()
						Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
					end
				end
			end)

			pcall(function()
				if Input.UserInputType == Enum.UserInputType[Environment.Settings.TriggerKey] then
					if not Environment.Settings.Toggle then
						Running = false
						Environment.Locked = nil
						Animation:Cancel()
						Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
					end
				end
			end)
		end
	end)
end

--// Functions

Environment.Functions = {}

function Environment.Functions:Exit()
	SaveSettings()

	for _, v in next, ServiceConnections do
		v:Disconnect()
	end

	if Environment.FOVCircle.Remove then Environment.FOVCircle:Remove() end

	getgenv().Aimbot.Functions = nil
	getgenv().Aimbot = nil
end

function Environment.Functions:Restart()
	SaveSettings()

	for _, v in next, ServiceConnections do
		v:Disconnect()
	end

	Load()
end

function Environment.Functions:ResetSettings()
	Environment.Settings = {
		SendNotifications = true,
		SaveSettings = true, -- Re-execute upon changing
		ReloadOnTeleport = true,
		Enabled = true,
		TeamCheck = false,
		AliveCheck = true,
		WallCheck = false,
		Sensitivity = 0, -- Animation length (in seconds) before fully locking onto target
		ThirdPerson = false,
		ThirdPersonSensitivity = 3,
		TriggerKey = "MouseButton2",
		Toggle = false,
		LockPart = "Head" -- Body part to lock on
	}

	Environment.FOVSettings = {
		Enabled = true,
		Visible = true,
		Amount = 90,
		Color = "255, 255, 255",
		LockedColor = "255, 70, 70",
		Transparency = 0.5,
		Sides = 60,
		Thickness = 1,
		Filled = false
	}
end

--// Support Check

if not Drawing or not getgenv then
	SendNotification(Title, "Your exploit does not support this script", 3); return
end

--// Reload On Teleport

if Environment.Settings.ReloadOnTeleport then
	if queueonteleport then
		queueonteleport(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V2/main/Resources/Scripts/Main.lua"))
	else
		SendNotification(Title, "Your exploit does not support \"syn.queue_on_teleport()\"")
	end
end

--// Load

Load(); SendNotification(Title, "Aimbot script successfully loaded.", 5)
end)

local Tab = Window:NewTab("local")

local Section = Tab:NewSection("speed")

Section:NewSlider("speed", "SliderInfo", 500, 0, function(s) -- 500 (Макс. значение) | 0 (Мин. значение)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

Section:NewButton("fly", "ButtonInfo", function()
    local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local cam = workspace.CurrentCamera
local uis = game:GetService("UserInputService")

local wPressed = false
local sPressed = false
local aPressed = false
local dPressed = false

local flying = false
uis.InputBegan:Connect(function(key, chat)
 if chat then return end
 if key.KeyCode == Enum.KeyCode.Q then
  if flying then
   flying = false
  else
   flying = true
   local bv = Instance.new("BodyVelocity", char.PrimaryPart)
   bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
   bv.Velocity = Vector3.new(0,0,0)
   bv.Name = "FlightForce"
   
   repeat wait(0.1) until flying == false
   bv:Destroy()
  end
 end
 
 if key.KeyCode == Enum.KeyCode.W then
  wPressed = true
 elseif key.KeyCode == Enum.KeyCode.S then
  sPressed = true
 elseif key.KeyCode == Enum.KeyCode.A then
  aPressed = true
 elseif key.KeyCode == Enum.KeyCode.D then
  dPressed = true
 end
end)

uis.InputEnded:Connect(function(key)
 if key.KeyCode == Enum.KeyCode.W then
  wPressed = false
 elseif key.KeyCode == Enum.KeyCode.S then
  sPressed = false
 elseif key.KeyCode == Enum.KeyCode.A then
  aPressed = false
 elseif key.KeyCode == Enum.KeyCode.D then
  dPressed = false
 end 
end)

while wait() do
 if flying then
  char.PrimaryPart:FindFirstChild("FlightForce").Velocity = Vector3.new(0,0,0)
  
  if wPressed then
   char.PrimaryPart:FindFirstChild("FlightForce").Velocity = cam.CFrame.LookVector * 100
  end
  if sPressed then
   char.PrimaryPart:FindFirstChild("FlightForce").Velocity = cam.CFrame.LookVector * -100
  end
  if aPressed then
   char.PrimaryPart:FindFirstChild("FlightForce").Velocity = cam.CFrame.RightVector * -100
  end
  if dPressed then
   char.PrimaryPart:FindFirstChild("FlightForce").Velocity = cam.CFrame.RightVector * 100
  end
 else
  wait(1)
 end
end
end)

Section:NewButton("noclip", "ButtonInfo", function()
   wait()
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @CloneTrooper1019, 2015
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
local Tool = Instance.new("HopperBin")
Tool.Parent = game.Players.LocalPlayer.Backpack
Tool.Name = "NoClip"
 
wait(1)
local c = workspace.CurrentCamera
local player = game.Players.LocalPlayer
local userInput = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local starterPlayer = game:GetService("StarterPlayer")
 
local selected = false
local speed = 60
local lastUpdate = 0
 
function getNextMovement(deltaTime)
 local nextMove = Vector3.new()
 -- Left/Right
 if userInput:IsKeyDown("A") or userInput:IsKeyDown("Left") then
 nextMove = Vector3.new(-1,0,0)
 elseif userInput:IsKeyDown("D") or userInput:IsKeyDown("Right") then
 nextMove = Vector3.new(1,0,0)
 end
 -- Forward/Back
 if userInput:IsKeyDown("W") or userInput:IsKeyDown("Up") then
 nextMove = nextMove + Vector3.new(0,0,-1)
    elseif userInput:IsKeyDown("S") or userInput:IsKeyDown("Down") then
        nextMove = nextMove + Vector3.new(0,0,1)
    end
    -- Up/Down
    if userInput:IsKeyDown("Space") then
        nextMove = nextMove + Vector3.new(0,1,0)
    elseif userInput:IsKeyDown("LeftControl") then
        nextMove = nextMove + Vector3.new(0,-1,0)
    end
    return CFrame.new( nextMove * (speed * deltaTime) )
end
 
game.Players.LocalPlayer.Backpack.NoClip.Selected:connect()
    local char = player.Character
    if char then
        local humanoid = char:WaitForChild("Humanoid")
        local root = char:WaitForChild("HumanoidRootPart")
        currentPos = root.Position
        selected = true
        root.Anchored = true
        lastUpdate = tick()
        humanoid.PlatformStand = true
        while selected do
            wait()
            local delta = tick()-lastUpdate
            local look = (c.Focus.p-c.CoordinateFrame.p).unit
            local move = getNextMovement(delta)
            local pos = root.Position
            root.CFrame = CFrame.new(pos,pos+look) * move
            lastUpdate = tick()
        end
        root.Anchored = false
        root.Velocity = Vector3.new()
        humanoid.PlatformStand = false
    end
 
game.Players.LocalPlayer.Backpack.NoClip.Deselected:connect()
    selected = false
end)

local Tab = Window:NewTab("Game")

local Section = Tab:NewSection("Pl")

Section:NewButton("Bhop", "ButtonInfo", function()
  local plrs = game:GetService("Players")
	local plr = plrs.LocalPlayer
	local UserInputService = game:GetService("UserInputService")
	local space = UserInputService:IsKeyDown(Enum.KeyCode.Space)
	local Client = getsenv(game.Players.LocalPlayer.PlayerGui.Client)
	local backup = {}
	backup.speed = Client.speedupdate
	local j = 0

while wait() do
space = UserInputService:IsKeyDown(Enum.KeyCode.Space)
	if space==true then
	if workspace:FindFirstChild(plr.Name) then
	if plr.Character:FindFirstChild("Humanoid") then
	j = 1
	game.Players.LocalPlayer.Character.Humanoid.Jump = true
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 18
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = 22
	Client.speedupdate = function()
	end
	end
	end
	else
	if j == 1 then
	j = 0
	wait(0.5)
	Client.speedupdate = backup.speed
	wait()
	end
	end
	end
end)

Section:NewSlider("Fov", "SliderInfo", 500, 0, function(s) -- 500 (Макс. значение) | 0 (Мин. значение)
    game.Workspace.CurrentCamera.FieldOfView = s
end)

local Tab = Window:NewTab("credits")

local Section = Tab:NewSection("credits")

Section:NewButton("creator by nexus", "ButtonInfo", function()
    print("creator")
end)

Section:NewButton("discord nexus14869", "ButtonInfo", function()
    print("discord")
end)
