local library = oadstring(game:HttpGet("https://raw.githubusercontent.com/Scissors222/hate/refs/heads/main/pepsilib.lua"))()
		local Wait = library.subs.Wait

		local RunService = game:GetService("RunService")
		local Players = game:GetService("Players")
		local Camera = game:GetService("Workspace").CurrentCamera
		local UserInputService = game:GetService("UserInputService")
		local TestService = game:GetService("TestService")


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
		Players.PlayerAdded:Connect(create_esp);
		Players.PlayerRemoving:Connect(remove_esp);
		RunService.RenderStepped:Connect(update_esp);

		local function CreateTracers()
			if TracersVisible == true then
				for _, v in next, Players:GetPlayers() do
					if v.Name ~= game.Players.LocalPlayer.Name then
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
