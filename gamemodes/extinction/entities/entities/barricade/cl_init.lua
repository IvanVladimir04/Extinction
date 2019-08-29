include("shared.lua")

function ENT:Draw()
self:DrawModel()
end

net.Receive("OpenBarricadeMenu", function()
local ent = net.ReadEntity()
local player = net.ReadEntity()
local entName = ent:GetClass()
local entHealth = net.ReadInt(11)

local playerBalance = player:GetNWInt("playerMoney")
local upgradePrice = ent.BaseHealth * 2

local UpgradeMenu = vgui.Create("DFrame")
UpgradeMenu:SetPos(0, 0)
UpgradeMenu:SetSize(500, 375)
UpgradeMenu:Center()
UpgradeMenu:SetTitle("Barricade Upgrade Menu")
UpgradeMenu:SetDraggable(false)
UpgradeMenu:ShowCloseButton(true)
UpgradeMenu:SetVisible(true)
UpgradeMenu:MakePopup()
UpgradeMenu.Paint = function()
       draw.RoundedBox(3, 0, 0, UpgradeMenu:GetWide(), UpgradeMenu:GetTall(), Color(60, 60, 60))
	   draw.RoundedBox(0, 0, 24, UpgradeMenu:GetWide(), 1, Color(255, 255, 255))
	   
	    draw.DrawText(entName:gsub("^%l", string.upper), "DermaLarge", 10, 35, Color(255, 255, 255), TEXT_ALIGN_LEFT)
        draw.DrawText("Health: "..entHealth.."/"..ent.BaseHealth, "Trebuchet24", 10, 65, Color(255, 255, 255), TEXT_ALIGN_LEFT)
       
   if (ent.CurHealthLevel != ent.MaxHealthLevel) then
        draw.DrawText("Upgrade Max Health | "..ent.CurHealthLevel.."/"..ent.MaxHealthLevel.." | $"..upgradePrice, "Trebuchet24", 10, 125, Color(255, 255, 255))
	 else
	    draw.DrawText("Upgrade Max Health | Max Level Reached", "Trebuchet24", 10, 125, Color(255, 255, 255))
	  end
   end
   
   local UpgradeButton = vgui.Create("DButton", UpgradeMenu)
   UpgradeButton:SetPos(10, 155)
   UpgradeButton:SetText("Upgrade Max Health")
   UpgradeButton:SetSize(120, 50)
   UpgradeButton.DoClick = function()
       playerBalance = player:GetNWInt("playerMoney")
   
   
      if (playerBalance >= upgradePrice && ent.CurHealthLevel < ent.MaxHealthLevel) then
          ent.BaseHealth = ent.BaseHealth * 2
	      ent.CurHealthLevel = ent.CurHealthLevel + 1
	      entHealth = ent.BaseHealth
		  
		  net.Start("UpgradeEntityHealth")
		      net.WriteEntity(ent)
			  net.WriteInt(upgradePrice, 11)
			  net.WriteInt(ent.BaseHealth, 11)
		  net.SendToServer()
		  
		  upgradePrice = ent.BaseHealth * 2
	   elseif (ent.CurHealthLevel == ent.MaxHealthLevel) then
	       player:PrintMessage(HUD_PRINTTALK, "The max level has been reached!")
	   else
	       player:PrintMessage(HUD_PRINTTALK, "You do not have enough money to upgrade!")
	   end
    end
 end)