function buyEntity(ply, cmd, args)
	if(args[1] != nil) then
	local ent = ents.Create(args[1])
	local tr = ply:GetEyeTrace()
	local balance = ply:GetNWInt("playerMoney")

	if (ent:IsValid()) then
	local ClassName = ent:GetClass()

	if (!tr.Hit) then return end

	local entCount = ply:GetNWInt(ClassName .. "count")

	if (entCount < ent.Limit && balance >= ent.Cost) then
	local SpawnPos = ply:GetShootPos() + ply:GetForward() * 80

	ent.Owner = ply

	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()

	ply:SetNWInt("playerMoney", balance - ent.Cost)
	ply:SetNWInt(ClassName .. "count", entCount + 1)

	return ent
	end

	return
	end
	end
end
concommand.Add("buy_entity", buyEntity)

function buyGun(ply, cmd, args)
if (args[1] != nil && args[2] != nil) then
local balance = ply:GetNWInt("playerMoney")
local gunCost = tonumber(args[2])

if (balance >= gunCost) then
ply:SetNWInt("playerMoney", balance - gunCost)
ply:Give(args[1])
ply:GiveAmmo(20, ply:GetWeapon(args[1]):GetPrimaryAmmoType(), false)
    end
  end
end
concommand.Add("buy_gun", buyGun)

function buyGrenade(ply, cmd, args)
if (args[1] != nil && args[2] != nil) then
local balance = ply:GetNWInt("playerMoney")
local grenadeCost = tonumber(args[2])

if (balance >= grenadeCost) then
ply:SetNWInt("playerMoney", balance - grenadeCost)
ply:Give(args[1])
ply:GiveAmmo(3, ply:GetWeapon(args[1]):GetPrimaryAmmoType(), false)
    end
  end
end
concommand.Add("buy_grenade", buyGrenade)

function buyRPG(ply, cmd, args)
if (args[1] != nil && args[2] != nil) then
local balance = ply:GetNWInt("playerMoney")
local rpgCost = tonumber(args[2])

if (balance >= rpgCost) then
ply:SetNWInt("playerMoney", balance - rpgCost)
ply:Give(args[1])
ply:GiveAmmo(5, ply:GetWeapon(args[1]):GetPrimaryAmmoType(), false)
    end
  end
end
concommand.Add("buy_rpg", buyRPG)