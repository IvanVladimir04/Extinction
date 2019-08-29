AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("customhud.lua")
AddCSLuaFile("custom_menu.lua")
AddCSLuaFile("custom_scoreboard.lua")

include("shared.lua")
include("concommands.lua")

local open = false

local function DisableNoclip( ply )
	return ply:IsAdmin()
end
hook.Add( "PlayerNoClip", "DisableNoclip", DisableNoclip )

AddCSLuaFile("wave_spawner/round_controller/cl_round_controller.lua")
include("wave_spawner/round_controller/sv_round_controller.lua")

function GM:PlayerConnect(name , ip)
print("Player "..name.." connected with IP ("..ip..")")
end

function GM:PlayerInitialSpawn(ply)
print("Player "..ply:Name().." has spawned.")
if (ply:GetNWInt("playerLvl") <= 0) then
ply:SetNWInt("playerLvl", 1)
    end
end

function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)
	if ( hitgroup == HITGROUP_HEAD ) then
		dmginfo:ScaleDamage(0) 
 	else
		dmginfo:ScaleDamage(0)
	end
end

local pmtable = {
	["models/player/combine_soldier.mdl"] = true,
	["models/player/combine_super_soldier.mdl"] = true,
	["models/player/police.mdl"] = true,
	["models/player/combine_soldier_prisonguard.mdl"] = true
}

function GM:PlayerSetModel(ply)
	local pm = math.random(1,4)
	return ply:SetModel(pmtable[pm])
end

function GM:OnNPCKilled(npc, attacker, inflictor)

	attacker:SetNWInt("playerMoney", attacker:GetNWInt("playerMoney") + 100)

	attacker:SetNWInt("playerExp", attacker:GetNWInt("playerExp") + 101)

	checkForLevel(attacker)

end

function GM:PlayerDeath(victim, inflictor, attacker)

	attacker:SetNWInt("playerMoney", attacker:GetNWInt("playerMoney") + 100)

	attacker:SetNWInt("playerExp", attacker:GetNWInt("playerExp") + 101)

	checkForLevel(attacker)

end

function GM:PlayerLoadout(ply)
	ply:Give("weapon_crowbar")
	ply:Give("weapon_pistol")

	ply:GiveAmmo(30, "Pistol", true)

	return true

end

function checkForLevel(ply)
local expToLevel = (ply:GetNWInt("playerLvl") * 100) * 2
local curExp = ply:GetNWInt("playerExp")
local curLvl = ply:GetNWInt("playerLvl")

  if (curExp >= expToLevel) then
      curExp = curExp - expToLevel
	  
	  ply:SetNWInt("playerExp", curExp)
	  ply:SetNWInt("playerLvl", curLvl + 1)
   
    end
end

function GM:ShowSpare2(ply)
ply:ConCommand("open_game_menu")
end

function GM:GetFallDamage( ply, speed )
	return math.max( 0, math.ceil( 0.2418*speed - 141.75 ) )
end

hook.Add( "PlayerSay", "!unstuck", function( ply, text, public )
	if ( string.lower( text ) == "!unstuck" ) then
        PrintMessage(HUD_PRINTTALK, "A player used the unstuck command, but unfortunately died.")
		ply:Kill()
		return ""
	end
end)
-------------------------Entity Removal-------------------------
function RemoveEnemies()
	for k, v in pairs( ents.FindByClass( "npc_*" ) ) do
		v:Remove()
	end
end


local function CreateSomeTimers()
timer.Create( "RemoveEntities", 0.1, 0, RemoveEnemies() )
end

hook.Add( "PlayerSay", "!endwave", function( ply, text, public )
if ( string.lower( text ) == "!endwave" ) then
    PrintMessage(HUD_PRINTTALK, "The wave has ended!")
	RemoveEnemies()
    end
end)

   
    hook.Add( "PlayerSay", "!npcstuck", function( ply, text, public )
if ( string.lower( text ) == "!npcstuck" ) then
    PrintMessage(HUD_PRINTTALK, "NPC got stuck, removing...")
RemoveEnemies()
end
end)

CreateConVar( "extinction_startmesg", "The combine releases headcrabs...", FCVAR_ARCHIVE, "Put the phrase you want to show up when starting a round" )
CreateConVar( "extinction_starsnd", "npc/antlion_guard/angry1.wav", FCVAR_ARCHIVE, "Put the sound you want to play when starting a round" )

for i = 1, 7 do
	CreateConVar( "extinction_ent"..i.."", "npc_vj_extinction_zombie", FCVAR_ARCHIVE, "put the class of an entity" )
end

hook.Add( "PlayerSay", "!startwave", function( ply, text, public )
	if ( string.lower( text ) == "!startwave" ) then
	    PrintMessage(HUD_PRINTTALK, GetConVar("extinction_startmesg"):GetString())
		ply:IsAdmin()
		sound.Play(GetConVar("extinction_starsnd"):GetString(), Vector(-1873.488159, -1276.588623, -63.968750))
		beginRound()
		return ""
	end
end)