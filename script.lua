local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Scissors222/hate/refs/heads/main/pepsilib.lua"))()
local Wait = library.subs.Wait

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = game:GetService("Workspace").CurrentCamera
local UserInputService = game:GetService("UserInputService")
local TestService = game:GetService("TestService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local fovocupation = 1
local fov = true
local gunselected = nil
local Skinselected = nil
local hitboxsize = 0
local hitboxeson = false
local hitboxesVisualon = false
local FireRate = 0
local espcolor = Color3.fromRGB(255,255,255)
local ammo = false
local infJump
local infJumpDebounce = false

local TeamCheck = false
local FromMouse = false
local FromCenter = false
local FromBottom = true
local TracersVisible = false
local TracerColor = Color3.fromRGB(255, 255, 255)
local TracerThickness = 1
local TracerTransparency = 0.7
local Typing = false

local workspace = game:GetService("Workspace");
local get_cframe = workspace.GetModelCFrame;
local wtvp = Camera.WorldToViewportPoint;
local viewport_size = Camera.ViewportSize;
local localplayer = Players.LocalPlayer;
local cache = {};
local new_drawing = Drawing.new;
local new_vector2 = Vector2.new;
local new_color3 = Color3.new;
local rad = math.rad;
local tan = math.tan;
local floor = math.floor;
local boxcolor = Color3.fromRGB(255,255,255)
local Holding = false

local AimbotEnabled = false
local TeamCheck = true
local AimPart = "Head"
local Sensitivity = 0

local CircleSides = 64
local CircleColor = Color3.fromRGB(255, 255, 255)
local CircleTransparency = 1
local CircleRadius = 80
local CircleFilled = false
local CircleVisible = true
local CircleThickness = 0

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

local function GetClosestPlayer()
	local MaximumDistance = CircleRadius
	local Target = nil

	for _, v in next, Players:GetPlayers() do
		if v.Name ~= LocalPlayer.Name then
			if TeamCheck == true then
				if v.Team ~= LocalPlayer.Team then
					if v.Character ~= nil then
						if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
							if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
								local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
								local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude

								if VectorDistance < MaximumDistance then
									Target = v
								end
							end
						end
					end
				end
			else
				if v.Character ~= nil then
					if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
						if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
							local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
							local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude

							if VectorDistance < MaximumDistance then
								Target = v
							end
						end
					end
				end
			end
		end
	end

	return Target
end


local function create_esp(player)
	local esp = {};

	esp.box = new_drawing("Square");
	esp.box.Color = new_color3(1,1,1);
	esp.box.Thickness = 1;
	esp.box.Filled = false;

	cache[player] = esp;
end

local function remove_esp(player)
	for _, drawing in next, cache[player] do
		drawing:Remove();
	end

	cache[player] = nil;
end

local function update_esp()
	for player, esp in next, cache do
		local character = player and player.Character;
		if character then
			local cframe = get_cframe(character);
			local position, visible = wtvp(Camera, cframe.Position);
			esp.box.Color = boxcolor
			esp.box.Visible = visible;

			if visible then
				local scale_factor = 1 / (position.Z * tan(rad(Camera.FieldOfView * 0.5)) * 2) * 100;
				local width, height = floor(35 * scale_factor), floor(50 * scale_factor);
				local x, y = floor(position.X), floor(position.Y);

				esp.box.Size = new_vector2(width, height);
				esp.box.Position = new_vector2(floor(x - width * 0.5), floor(y - height * 0.5));
			end
		else
			esp.box.Visible = false;
		end
	end
end

local function fovchangerfunction()
	print(fovocupation)
	while fov == true do
		game:GetService("Players").LocalPlayer.PlayerScripts.Vortex.Modifiers.FOV.Value = fovocupation
		print(fovocupation)
		Wait()
	end
end

Players.PlayerAdded:Connect(create_esp);
Players.PlayerRemoving:Connect(remove_esp);
RunService.RenderStepped:Connect(update_esp);

local function CreateTracers()
	if TracersVisible == true then
		for _, v in pairs(game.Workspace:GetChildren()) do
			if game.Players.LocalPlayer.Character.Name ~= v.Name then
				local TracerLine = Drawing.new("Line")

				RunService.RenderStepped:Connect(function()
					if workspace:FindFirstChild(v.Name) ~= nil and workspace[v.Name]:FindFirstChild("HumanoidRootPart") ~= nil and TracersVisible == true then
						local HumanoidRootPart_Position, HumanoidRootPart_Size = workspace[v.Name].HumanoidRootPart.CFrame, workspace[v.Name].HumanoidRootPart.Size * 1
						local Vector, OnScreen = Camera:WorldToViewportPoint(HumanoidRootPart_Position * CFrame.new(0, -HumanoidRootPart_Size.Y, 0).p)

						TracerLine.Thickness = TracerThickness
						TracerLine.Transparency = TracerTransparency
						TracerLine.Color = TracerColor

						if FromMouse == true and FromCenter == false and FromBottom == false then
							TracerLine.From = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
						elseif FromMouse == false and FromCenter == true and FromBottom == false then
							TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
						elseif FromMouse == false and FromCenter == false and FromBottom == true then
							TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
						end

						if OnScreen == true and TracersVisible == true then
							TracerLine.To = Vector2.new(Vector.X, Vector.Y)
							if TeamCheck == true then 
								if Players.LocalPlayer.Team ~= v.Team then
									TracerLine.Visible = TracersVisible
								else
									TracerLine.Visible = false
								end
							else
								TracerLine.Visible = TracersVisible
							end
						else
							TracerLine.Visible = false
						end
					else
						TracerLine.Visible = false
					end
				end)

				Players.PlayerRemoving:Connect(function()
					TracerLine.Visible = false
				end)
			end
		end
	end

	Players.PlayerAdded:Connect(function(Player)
		Player.CharacterAdded:Connect(function(v)
			if v.Name ~= game.Players.LocalPlayer.Name and TracersVisible == true then
				local TracerLine = Drawing.new("Line")

				RunService.RenderStepped:Connect(function()
					if workspace:FindFirstChild(v.Name) ~= nil and workspace[v.Name]:FindFirstChild("HumanoidRootPart") ~= nil then
						local HumanoidRootPart_Position, HumanoidRootPart_Size = workspace[v.Name].HumanoidRootPart.CFrame, workspace[v.Name].HumanoidRootPart.Size * 1
						local Vector, OnScreen = Camera:WorldToViewportPoint(HumanoidRootPart_Position * CFrame.new(0, -HumanoidRootPart_Size.Y, 0).p)

						TracerLine.Thickness = TracerThickness
						TracerLine.Transparency = TracerTransparency
						TracerLine.Color = TracerColor

						if FromMouse == true and FromCenter == false and FromBottom == false then
							TracerLine.From = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
						elseif FromMouse == false and FromCenter == true and FromBottom == false then
							TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
						elseif FromMouse == false and FromCenter == false and FromBottom == true then
							TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
						end

						if OnScreen == true  then
							TracerLine.To = Vector2.new(Vector.X, Vector.Y)
							if TeamCheck == true then 
								if Players.LocalPlayer.Team ~= Player.Team then
									TracerLine.Visible = TracersVisible
								else
									TracerLine.Visible = false
								end
							else
								TracerLine.Visible = TracersVisible
							end
						else
							TracerLine.Visible = false
						end
					else
						TracerLine.Visible = false
					end
				end)

				Players.PlayerRemoving:Connect(function()
					TracerLine.Visible = false
				end)
			end
		end)
	end)
end

UserInputService.TextBoxFocused:Connect(function()
	Typing = true
end)

UserInputService.TextBoxFocusReleased:Connect(function()
	Typing = false
end)

local function infjumpfunction()
	if infJump then
		infJumpDebounce = false
		infJump = game:GetService("UserInputService").JumpRequest:Connect(function()
			if not infJumpDebounce then
				infJumpDebounce = true
				game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
				wait()
				infJumpDebounce = false
			end
		end)
	end
end
local function FireRateChange()
	for _, weapons in pairs(game:GetService("ReplicatedStorage").Weapons:GetChildren()) do
		if weapons then
			for _, l in pairs(weapons:GetChildren()) do
				if l:IsA("Folder") then
					for _, t in pairs(l:GetChildren()) do
						if t.Name == "FireRate" then
							t.Value = FireRate
						end
					end
				end
			end
		end
	end
end
local function InfAmmo()
	if ammo then
		for _, weapons in pairs(game:GetService("ReplicatedStorage").Weapons:GetChildren()) do
			if weapons then
				for _, l in pairs(weapons:GetChildren()) do
					if l:IsA("Folder") then
						for _, t in pairs(l:GetChildren()) do
							if t.Name == "StoredAmmo" then
								t.Value = 999
							end
						end
					end
				end
			end
		end
	end
end
local function changegun()
	for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerScripts.Vortex.Inventory:GetChildren()) do
		if v:IsA("StringValue") then
			v.Name = gunselected
		end
	end
end
local function hitboxExpander()
	while wait() do
		if hitboxeson then
			for _, v in pairs(game.Workspace:GetChildren()) do
				if v and v.Name ~= game.Players.LocalPlayer.Name then
					for _, parts in pairs(v:GetChildren()) do
						if parts.Name == "HumanoidRootPart" then
							parts.Size = Vector3.new(hitboxsize,hitboxsize,hitboxsize)
						end
					end
				end
			end
		else
			for _, v in pairs(game.Workspace:GetChildren()) do
				if v and v.Name ~= game.Players.LocalPlayer.Name then
					for _, parts in pairs(v:GetChildren()) do
						if parts.Name == "HumanoidRootPart" then
							parts.Size = Vector3.new(2,2,1)
						end
					end
				end
			end
		end
	end
end
local function hitboxVisalizise()
	while wait() do
		if hitboxesVisualon then
			for _, v in pairs(game.Workspace:GetChildren()) do
				if v and v.Name ~= game.Players.LocalPlayer.Name then
					for _, parts in pairs(v:GetChildren()) do
						if parts.Name == "HumanoidRootPart" then
							parts.Transparency = 0.75
							parts.Color = Color3.fromRGB(255, 0, 0)
						end
					end
				end
			end
		else
			for _, v in pairs(game.Workspace:GetChildren()) do
				if v and v.Name ~= game.Players.LocalPlayer.Name then
					for _, parts in pairs(v:GetChildren()) do
						if parts.Name == "HumanoidRootPart" then
							parts.Transparency = 0
						end
					end
				end
			end
		end
	end
end
local function changeSkin()
	while Wait() do
		for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerScripts.Vortex.Inventory:GetChildren()) do
			if v then
				if not v:FindFirstChild("Camo") then
					local camo = Instance.new("StringValue")
					camo.Parent = v
					camo.Value = Skinselected
					camo.Name = "Camo"
				else
					v:FindFirstChild("Camo").Value = Skinselected
				end
			end
		end
	end
end
local PepsisWorld = library:CreateWindow({
	Name = "Scissors.Hate",
	Themeable = {
		Info = "Discord Server:"
	}
})

local GeneralTab = PepsisWorld:CreateTab({
	Name = "General"
})
local CombatTab = PepsisWorld:CreateTab({
	Name = "Combat"
})
local GunModsTab = PepsisWorld:CreateTab({
	Name = "Gun Mods"
})
local VisualsTab = PepsisWorld:CreateTab({
	Name = "Visuals"
})
local GunsSection = GeneralTab:CreateSection({
	Name = "Guns"
})
local PlayerSection = GeneralTab:CreateSection({
	Name = "Player"
})
local HitboxSection = CombatTab:CreateSection({
	Name = "Hitbox Expander"
})
local GunmodsSection = GunModsTab:CreateSection({
	Name = "Gun Mods"
})
local GunsSkinSection = GunModsTab:CreateSection({
	Name = "Gun Skin"
})
local EspSection = VisualsTab:CreateSection({
	Name = "ESP"
})
local WorldSection = VisualsTab:CreateSection({
	Name = "World"
})
local AimbotSection = CombatTab:CreateSection({
	Name = "Aimbot"
})
GunsSection:AddDropdown({
	Name = "Guns",
	Value = nil,
	Flag = "GunsFlag",
	Nothing = "No Selection",
	List = {"AR18", "AR10", "M4", "MP40", "BAR", "Bren", "Type 99", "AK47", "Barret M82", "Trench", "DP27", "Double Barrel", "EM2", "G11", "TT30", "HK33", "HK54", "I37", "K50M", "KS23", "M1 Carbine", "M1 Garand", "M14E2", "M16A1", "M1911", "L96A1", "M1C", "M2 Carbine", "M21", "M3A1", "M40A1", "M60", "FAL", "M79 Thumper", "MAS-38", "MAT-49", "Mauser C96", "Stoner 63A", "Mk PM", "Model 1100", "Model 39", "Model 7188", "Mosin", "AS Val", "Owen Gun", "P08 Luger", "PPK", "SKS-XT", "Python", "RPD", "RPK", "SKS", "STG44", "SVD", "Sawnoff", "Minigun", "Scar H", "Galil", "MPL", "870 DM", "TKB11", "P90", "Laser Rifle", "AK12", "Vector", "MGL", "Honey Badger", "G40X", "Snowball Launcher", "Saiga 12", "Toy Gun", "Gingerbread Rifle", "Candy Launcher", "Akimbo G40", "Akimbo HS10", "Akimbo PM63", "Akimbo Skorpion", "Akimbo Deagle", "Rhino", "AUGA3", "Laser Carbine", "UMP45", "Laser SMG", "AK74U", "M93R", "TEC-9", "Spas-12", "Famas", "AA12", "MAC 10", "M1A1", "Intervention", "PSG-1", "MP7", "Deagle", "Akimbo Makarovs", "Easter Egger", "Marlin 1895", "Henry", "Big Iron", "Laser LMG", "XM415", "SGk 12X", "AKX 74", "RKM", "Stakeout", "SA58", "PPSH", "PPX41", "M16 Mod 2", "MP5SD", "Ultramatch", "VK2R", "Paintball Gun", "Slingshot", "Superball", "Bomb", "Rocket Launcher", "Bloxy LMG", "URX-45", "Combat Knife", "Fisticuffs", "G36C", "G37X", "MPX", "MX-K", "Bizon", "MBAK", "Vityaz", "Gepard", "Diamond Back", "Magnum", "G18C", "AN94", "HYPR 94", "MDR38", "MDXL", "Ballista", "KSG12", "DE50X", "EVO", "M249", "Lynx", "Mini 14", "Tanto", "Royalty Knife", "Credits Rifle", "Golden Scepter", "Big Coin", "Robux Launcher", "Karambit", "Akimbo AA12", "Tragedy 99", "Kalamity 23", "Careless Whisper", "EBR", "G21", "F790", "Akimbo Mausers", "SR11", "Korblox Deathcannon", "Police Baton", "Knights Legacy", "Laser Shotgun"},
	Callback = function(Value)
		gunselected = Value
	end,
})
GunsSection:AddButton({
	Name = "Give Gun",
	Callback = function()
		spawn(changegun)
	end,
})

PlayerSection:AddToggle({
	Name = "Infinite Jump",
	Flag = "InfiniteJumpflag",
	Value = false,
	Callback = function(Value)
		infJump = Value
		spawn(infjumpfunction)
	end,
})
HitboxSection:AddSlider({
	Name = "Hitbox Size",
	Flag = "Sizeflag",
	Value = 0,
	Min = 0,
	Max = 15,
	Callback = function(Value)
		hitboxsize = Value
	end,
})
HitboxSection:AddToggle({
	Name = "Hitbox Visualizer",
	Flag = "Visualiziseflag",
	Value = false,
	Callback = function(Value)
		hitboxesVisualon = Value
		spawn(hitboxVisalizise)
	end,
})
HitboxSection:AddToggle({
	Name = "Hitbox Expander",
	Flag = "Expanderflag",
	Value = false,
	Callback = function(Value)
		hitboxeson = Value
		spawn(hitboxExpander)
	end,
})
GunmodsSection:AddToggle({
	Name = "Infinite Ammo",
	Flag = "InfAmmoFlag",
	Value = false,
	Callback = function(Value)
		ammo = Value
		spawn(InfAmmo)
	end,
})
GunmodsSection:AddSlider({
	Name = "FireRate",
	Flag = "FireRateflag",
	Value = 700,
	Min = 300,
	Max = 850,
	Callback = function(Value)
		FireRate = Value
		spawn(FireRateChange)
	end,
})
GunsSkinSection:AddDropdown({
	Name = "Skin",
	Value = nil,
	Flag = "Flag",
	Nothing = "No Selection",
	List = {"Beach Towel", "Pineapple", "Shells", "Eclipse", "Blue", "Red", "Yellow", "Green", "Purple", "FDE", "ODG", "UDE", "Woodland", "Navy", "Wildfire", "Chrome", "Ice", "Hearts", "Kryptek", "Freedom", "Glitter", "Blossom", "Warrior", "Spectrum", "Scales", "Miami Tiger", "Shards", "Blackout", "Volcanic", "Gold", "Haptic", "Damascus"},
	Callback = function(Value)
		Skinselected = Value
	end,
})
GunsSkinSection:AddButton({
	Name = "Change Skin",
	Callback = function()
		spawn(changeSkin)
	end,
})
WorldSection:AddColorpicker({
	Name = "Ambient",
	Flag = "AmbientColorFlag",
	Value = Color3.fromRGB(100, 100, 100),
	Callback = function(Value)
		game.Lighting.Ambient = Value
	end,
})
WorldSection:AddColorpicker({
	Name = "Outdoor Ambient",
	Flag = "OutdoorAmbientColorFlag",
	Value = Color3.fromRGB(100, 100, 100),
	Callback = function(Value)
		game.Lighting.OutdoorAmbient = Value
	end,
})
WorldSection:AddDropdown({
	Name = "Skybox",
	Value = nil,
	Flag = "skyFlag",
	Nothing = "No Selection",
	List = {"Purple Nebula", "Night Sky", "Pink Daylight", "Morning Glow", "Setting Sun", "Elegent Morning", "Neptune", "Redshift", "Aesthetic Night"},
	Callback = function(Value)
		if Value == "Purple Nebula" then
			game.Lighting:FindFirstChild("Sky").SkyboxBk = "rbxassetid://159454299"
			game.Lighting:FindFirstChild("Sky").SkyboxDn = "rbxassetid://159454296"
			game.Lighting:FindFirstChild("Sky").SkyboxFt = "rbxassetid://159454293"
			game.Lighting:FindFirstChild("Sky").SkyboxLf = "rbxassetid://159454286"
			game.Lighting:FindFirstChild("Sky").SkyboxRt = "rbxassetid://159454300"
			game.Lighting:FindFirstChild("Sky").SkyboxUp = "rbxassetid://159454288"
		elseif Value == "Night Sky" then
			game.Lighting:FindFirstChild("Sky").SkyboxBk = "rbxassetid://12064107"
			game.Lighting:FindFirstChild("Sky").SkyboxDn = "rbxassetid://12064152"
			game.Lighting:FindFirstChild("Sky").SkyboxFt = "rbxassetid://12064121"
			game.Lighting:FindFirstChild("Sky").SkyboxLf = "rbxassetid://12063984"
			game.Lighting:FindFirstChild("Sky").SkyboxRt = "rbxassetid://12064115"
			game.Lighting:FindFirstChild("Sky").SkyboxUp = "rbxassetid://12064131"
		elseif Value == "Pink Daylight" then
			game.Lighting:FindFirstChild("Sky").SkyboxBk = "rbxassetid://271042516"
			game.Lighting:FindFirstChild("Sky").SkyboxDn = "rbxassetid://271077243"
			game.Lighting:FindFirstChild("Sky").SkyboxFt = "rbxassetid://271042556"
			game.Lighting:FindFirstChild("Sky").SkyboxLf = "rbxassetid://271042310"
			game.Lighting:FindFirstChild("Sky").SkyboxRt = "rbxassetid://271042467"
			game.Lighting:FindFirstChild("Sky").SkyboxUp = "rbxassetid://271077958"
		elseif Value == "Morning Glow" then
			game.Lighting:FindFirstChild("Sky").SkyboxBk = "rbxassetid://1417494030"
			game.Lighting:FindFirstChild("Sky").SkyboxDn = "rbxassetid://1417494146"
			game.Lighting:FindFirstChild("Sky").SkyboxFt = "rbxassetid://1417494253"
			game.Lighting:FindFirstChild("Sky").SkyboxLf = "rbxassetid://1417494402"
			game.Lighting:FindFirstChild("Sky").SkyboxRt = "rbxassetid://1417494499"
			game.Lighting:FindFirstChild("Sky").SkyboxUp = "rbxassetid://1417494643"
		elseif Value == "Setting Sun" then
			game.Lighting:FindFirstChild("Sky").SkyboxBk = "rbxassetid://626460377"
			game.Lighting:FindFirstChild("Sky").SkyboxDn = "rbxassetid://626460216"
			game.Lighting:FindFirstChild("Sky").SkyboxFt = "rbxassetid://626460513"
			game.Lighting:FindFirstChild("Sky").SkyboxLf = "rbxassetid://626473032"
			game.Lighting:FindFirstChild("Sky").SkyboxRt = "rbxassetid://626458639"
			game.Lighting:FindFirstChild("Sky").SkyboxUp = "rbxassetid://626460625"
		elseif Value == "Elegent Morning" then
			game.Lighting:FindFirstChild("Sky").SkyboxBk = "rbxassetid://153767241"
			game.Lighting:FindFirstChild("Sky").SkyboxDn = "rbxassetid://153767216"
			game.Lighting:FindFirstChild("Sky").SkyboxFt = "rbxassetid://153767266"
			game.Lighting:FindFirstChild("Sky").SkyboxLf = "rbxassetid://153767200"
			game.Lighting:FindFirstChild("Sky").SkyboxRt = "rbxassetid://153767231"
			game.Lighting:FindFirstChild("Sky").SkyboxUp = "rbxassetid://153767288"
		elseif Value == "Neptune" then
			game.Lighting:FindFirstChild("Sky").SkyboxBk = "rbxassetid://218955819"
			game.Lighting:FindFirstChild("Sky").SkyboxDn = "rbxassetid://218953419"
			game.Lighting:FindFirstChild("Sky").SkyboxFt = "rbxassetid://218954524"
			game.Lighting:FindFirstChild("Sky").SkyboxLf = "rbxassetid://218958493"
			game.Lighting:FindFirstChild("Sky").SkyboxRt = "rbxassetid://218957134"
			game.Lighting:FindFirstChild("Sky").SkyboxUp = "rbxassetid://218950090"
		elseif Value == "Redshift" then
			game.Lighting:FindFirstChild("Sky").SkyboxBk = "rbxassetid://401664839"
			game.Lighting:FindFirstChild("Sky").SkyboxDn = "rbxassetid://401664862"
			game.Lighting:FindFirstChild("Sky").SkyboxFt = "rbxassetid://401664960"
			game.Lighting:FindFirstChild("Sky").SkyboxLf = "rbxassetid://401664881"
			game.Lighting:FindFirstChild("Sky").SkyboxRt = "rbxassetid://401664901"
			game.Lighting:FindFirstChild("Sky").SkyboxUp = "rbxassetid://401664936"
		elseif Value == "Aesthetic Night" then
			game.Lighting:FindFirstChild("Sky").SkyboxBk = "rbxassetid://1045964490"
			game.Lighting:FindFirstChild("Sky").SkyboxDn = "rbxassetid://1045964368"
			game.Lighting:FindFirstChild("Sky").SkyboxFt = "rbxassetid://1045964655"
			game.Lighting:FindFirstChild("Sky").SkyboxLf = "rbxassetid://1045964655"
			game.Lighting:FindFirstChild("Sky").SkyboxRt = "rbxassetid://1045964655"
			game.Lighting:FindFirstChild("Sky").SkyboxUp = "rbxassetid://1045962969"
		end
	end,
})
WorldSection:AddSlider({
	Name = "Time",
	Flag = "ClockSliderFlag",
	Value = 12,
	Min = 0,
	Max = 24,
	Callback = function(Value)
		game.Lighting.ClockTime = Value
	end,
})
EspSection:AddToggle({
	Name = "Box ESP",
	Flag = "BoxFlag",
	Value = false,
	Callback = function(Value)
		if Value == true then
			for _, player in next, Players:GetPlayers() do
				if player ~= localplayer then
					create_esp(player);
				end
			end
		else
			for _, player in next, Players:GetPlayers() do
				if player ~= localplayer then
					remove_esp(player);
				end
			end
		end
	end,
})
EspSection:AddColorpicker({
	Name = "Box Color",
	Flag = "BoxColorFlag",
	Value = Color3.fromRGB(255,255,255),
	Callback = function(Value)
		boxcolor = Value
	end,
})
EspSection:AddToggle({
	Name = "Tracers ESP",
	Flag = "TracersFlag",
	Value = false,
	Callback = function(Value)
		TracersVisible = Value
		spawn(CreateTracers)
	end,
})
EspSection:AddColorpicker({
	Name = "Tracers Color",
	Flag = "TracersColorFlag",
	Value = Color3.fromRGB(255,255,255),
	Callback = function(Value)
		TracerColor = Value
	end,
})

WorldSection:AddToggle({
	Name = "FOV Changer",
	Flag = "FovFlag",
	Value = false,
	Callback = function(Value)
		fov = Value
		spawn(fovchangerfunction)
	end,
})
WorldSection:AddSlider({
	Name = "FOV",
	Flag = "FovSliderFlag",
	Value = 9,
	Min = 3,
	Max = 25,
	Callback = function(Value)
		fovocupation = Value / 10
	end,
})
AimbotSection:AddToggle({
	Name = "Aimbot",
	Flag = "AimFlag",
	Value = false,
	Callback = function(Value)
		AimbotEnabled = Value
	end,
})
AimbotSection:AddSlider({
	Name = "FOV Size",
	Flag = "FOVSIZEFlag",
	Value = 80,
	Min = 10,
	Max = 240,
	Callback = function(Value)
		CircleRadius = Value
	end,
})
AimbotSection:AddColorpicker({
	Name = "FOV Color",
	Flag = "FOVColorFlag",
	Value = Color3.fromRGB(255, 255, 255),
	Callback = function(Value)
		CircleColor = Value
	end,
})

UserInputService.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton2 then
		Holding = true
	end
end)

UserInputService.InputEnded:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton2 then
		Holding = false
	end
end)

RunService.RenderStepped:Connect(function()
	if AimbotEnabled == true then
		FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
		FOVCircle.Radius = CircleRadius
		FOVCircle.Filled = CircleFilled
		FOVCircle.Color = CircleColor
		FOVCircle.Visible = CircleVisible
		FOVCircle.Radius = CircleRadius
		FOVCircle.Transparency = CircleTransparency
		FOVCircle.NumSides = CircleSides
		FOVCircle.Thickness = CircleThickness
	else
		FOVCircle.Transparency = 0
	end

	if Holding == true and AimbotEnabled == true then
		TweenService:Create(Camera, TweenInfo.new(Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, GetClosestPlayer().Character[AimPart].Position)}):Play()
	end
end)
