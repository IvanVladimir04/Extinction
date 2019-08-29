function HUD()

local client = LocalPlayer()

if !client:Alive() then
    return
	
	
	end

	draw.RoundedBox(0, 0, ScrH() - 100, 250, 100, Color(30, 30, 30, 230))
	draw.SimpleText("Health: "..client:Health(), "DermaDefaultBold", 10, ScrH() - 90, Color(255, 255, 255, 255), 0, 0)
	draw.SimpleText("Armor: "..client:Armor(), "DermaDefaultBold", 10, ScrH() - 55, Color(255, 255, 255, 255), 0, 0)
	draw.RoundedBox(0, 10, ScrH() - 75, math.Clamp(client:Health(), 0, 100) * 2.25, 15, Color(0, 153, 92))
	draw.RoundedBox(0, 10, ScrH() - 40, math.Clamp(client:Armor(), 0, 100) * 2.25, 15, Color(26, 117, 255))
	
    draw.RoundedBox(0, 1051, ScrH() - 70, 125, 70, Color(30, 30, 30, 230))
	
	if(client:GetActiveWeapon():IsValid()) then
	local curWeapon = client:GetActiveWeapon():GetClass()
	
	if (client:GetActiveWeapon():GetPrintName() != nil) then
	   draw.SimpleText(client:GetActiveWeapon():GetPrintName(), "DermaDefaultBold", 1060, ScrH() - 60, Color(255, 255, 255, 255), 0, 0)
	
	end
	
	    if(curWeapon != "weapon_physgun"&& curWeapon != "weapon_physcannon"&& curWeapon != "weapon_crowbar")then
	    if (client:GetActiveWeapon():Clip1() != -1) then
		draw.SimpleText("Ammo: ".. client:GetActiveWeapon():Clip1() .. "/" .. client:GetAmmoCount(client:GetActiveWeapon():GetPrimaryAmmoType()), "DermaDefaultBold", 1060, ScrH() - 40, Color(255, 255, 255, 255), 0, 0)

		else
		    draw.SimpleText("Ammo: ".. client:GetAmmoCount(client:GetActiveWeapon():GetPrimaryAmmoType()), "DermaDefaultBold", 1060, ScrH() - 40, Color(255, 255, 255, 255), 0, 0)
			
		
	end
	
	if (client:GetAmmoCount(client:GetActiveWeapon():GetSecondaryAmmoType()) > 0) then
	   draw.SimpleText("Secondary: ".. client:GetAmmoCount(client:GetActiveWeapon():GetSecondaryAmmoType()), "DermaDefaultBold", 1060, ScrH() - 25, Color(255, 255, 255, 255), 0, 0)
	
	        end
	    end
	end
	
	local expToLevel = (client:GetNWInt("playerLvl") * 100) * 2
	
	draw.RoundedBox(0, 0, ScrH() - 145, 250, 40, Color(30, 30, 30, 230))
	draw.SimpleText("Level " .. client:GetNWInt("playerLvl"), "DermaDefaultBold", 10, ScrH() - 140, Color(255, 255, 255, 255), 0)
	draw.SimpleText("EXP: " .. client:GetNWInt("playerExp") .. "/" .. expToLevel, "DermaDefaultBold", 10, ScrH() - 125, Color(255, 255, 255, 255), 0)
	
	draw.RoundedBox(0, 1051, ScrH() - 100, 125, 25, Color(30, 30, 30, 230))
	draw.SimpleText("$ " .. client:GetNWInt("playerMoney"), "DermaDefaultBold", 1060, ScrH() - 95, Color(255, 255, 255, 255), 0)
end
hook.Add("HUDPaint", "CustomHud", HUD)

function HideHud(name)

for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"}) do
         if name == v then
		      return false
		 end
    end

end
hook.Add("HUDShouldDraw", "HideDefaultHud", HideHud)
