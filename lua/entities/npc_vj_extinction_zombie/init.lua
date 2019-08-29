AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/Zombie/Classic.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 100
ENT.HullType = HULL_HUMAN
ENT.HasHull = true -- Set to false to disable HULL
ENT.HullSizeNormal = true -- set to false to cancel out the self:SetHullSizeNormal()
ENT.HasSetSolid = true -- set to false to disable SetSolid
ENT.SightDistance = 999999999 -- How far it can see
ENT.SightAngle = 180 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.TurningSpeed = 20 -- How fast it can turn
ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle, etc.)
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasBloodParticle = true -- Does it spawn a particle when damaged?
ENT.HasBloodDecal = true -- Does it spawn a decal when damaged?
ENT.HasBloodPool = true -- Does it have a blood pool?
ENT.BloodPoolSize = "Normal" -- What's the size of the blood pool?
ENT.FindEnemy_UseSphere = true -- Should the SNPC be able to see all around him? (360) | Objects and walls can still block its sight!
ENT.FindEnemy_CanSeeThroughWalls = true -- Should it be able to see through walls and objects? | Can be useful if you want to make it know where the enemy is at all times
ENT.HasDeathRagdoll = true -- If set to false, it will not spawn the regular ragdoll of the SNPC
ENT.VJ_NPC_Class = {"CLASS_EXTINCTIONGAMEMODE_ZOMBIES"} -- NPCs with the same class with be allied to each other
ENT.HasSounds = true -- Put to false to disable ALL sound
ENT.SoundTbl_CombatIdle = {"npc/zombie/zombie_voice_idle1.wav","npc/zombie/zombie_voice_idle2.wav","npc/zombie/zombie_voice_idle3.wav","npc/zombie/zombie_voice_idle4.wav","npc/zombie/zombie_voice_idle5.wav","npc/zombie/zombie_voice_idle6.wav","npc/zombie/zombie_voice_idle7.wav","npc/zombie/zombie_voice_idle8.wav","npc/zombie/zombie_voice_idle9.wav","npc/zombie/zombie_voice_idle10.wav","npc/zombie/zombie_voice_idle11.wav","npc/zombie/zombie_voice_idle12.wav","npc/zombie/zombie_voice_idle13.wav","npc/zombie/zombie_voice_idle14.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"npc/zombie/zo_attack1.wav","npc/zombie/zo_attack2.wav"}
ENT.SoundTbl_Pain = {"npc/zombie/zombie_pain1.wav","npc/zombie/zombie_pain2.wav","npc/zombie/zombie_pain3.wav","npc/zombie/zombie_pain4.wav","npc/zombie/zombie_pain5.wav","npc/zombie/zombie_pain6.wav"}
ENT.SoundTbl_Death = {"npc/zombie/zombie_die1.wav","npc/zombie/zombie_die2.wav","npc/zombie/zombie_die3.wav"}
ENT.SoundTbl_MeleeAttack = {"npc/zombie/claw_strike1.wav","npc/zombie/claw_strike2.wav","npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"npc/zombie/claw_miss1.wav","npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_Alert = {"npc/zombie/zombie_alert1.wav","npc/zombie/zombie_alert2.wav","npc/zombie/zombie_alert3.wav"}
ENT.SoundTbl_FootStep = {"npc/zombie/foot1.wav","npc/zombie/foot2.wav","npc/zombie/foot3.wav","npc/zombie/foot_slide1.wav","npc/zombie/foot_slide2.wav","npc/zombie/foot_slide3.wav"}
ENT.FadeCorpse = true -- Fades the ragdoll on death
ENT.FadeCorpseTime = 3 -- How much time until the ragdoll fades | Unit = Seconds
ENT.PushProps = false -- Should it push props when trying to move?
ENT.AttackProps = true -- Should it attack props when trying to move?
ENT.HasEntitiesToNoCollide = true -- If set to false, it won't run the EntitiesToNoCollide code
ENT.EntitiesToNoCollide = {"npc_vj_extinction_zombie","npc_vj_extinction_zombie_fast","npc_vj_extinction_zombie_poison","npc_vj_extinction_headcrab","npc_vj_extinction_headcrab_fast","npc_vj_extinction_headcrab_black","npc_vj_extinction_goliath"} -- Entities to not collide with when HasEntitiesToNoCollide is set to true
---------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetBodygroup(1,math.random(1,1))
end
---------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleMeleeAttacks()
local EnemyDistance = self:VJ_GetNearestPointToEntityDistance(self:GetEnemy(),self:GetPos():Distance(self:GetEnemy():GetPos()))
if EnemyDistance > 0 && EnemyDistance < 10000 then
    local anyattack = math.random(1,2,3,4)	
		if anyattack == 1 then
		self.MeleeAttackDistance = 15
		self.TimeUntilMeleeAttackDamage = 1
		self.NextAnyAttackTime_Melee = 3
		self.AnimTbl_MeleeAttack = {"AttackA"}
		self.MeleeAttackAngleRadius = 100
		self.MeleeAttackAnimationFaceEnemy = false
		self.MeleeAttackDamage = 15
		self.MeleeAttackDamageAngleRadius = 15
		self.MeleeAttackDamageDistance = 25
		self.MeleeAttackDamageType = DMG_SLASH
		self.MeleeAttackAnimationDecreaseLengthAmount = 0
		self.NextAnyAttackTime_Melee = 1.5
		
		
		
		
		elseif anyattack == 2 then
		self.MeleeAttackDistance = 15
		self.TimeUntilMeleeAttackDamage = 1
		self.NextAnyAttackTime_Melee = 3
		self.AnimTbl_MeleeAttack = {"AttackB"}
		self.MeleeAttackAngleRadius = 100
		self.MeleeAttackAnimationFaceEnemy = false
		self.MeleeAttackDamage = 15
		self.MeleeAttackDamageAngleRadius = 15
		self.MeleeAttackDamageDistance = 25
		self.MeleeAttackDamageType = DMG_SLASH
		self.MeleeAttackAnimationDecreaseLengthAmount = 0
		self.NextAnyAttackTime_Melee = 1.5
		
		
		
		
		elseif anyattack == 3 then
		self.MeleeAttackDistance = 15
		self.TimeUntilMeleeAttackDamage = 1
		self.NextAnyAttackTime_Melee = 3
		self.AnimTbl_MeleeAttack = {"AttackC"}
		self.MeleeAttackAngleRadius = 100
		self.MeleeAttackAnimationFaceEnemy = false
		self.MeleeAttackDamage = 15
		self.MeleeAttackDamageAngleRadius = 15
		self.MeleeAttackDamageDistance = 25
		self.MeleeAttackDamageType = DMG_SLASH
		self.MeleeAttackAnimationDecreaseLengthAmount = 0
		self.NextAnyAttackTime_Melee = 1.5
		
		
		
		
		
			elseif anyattack == 4 then
		self.MeleeAttackDistance = 15
		self.TimeUntilMeleeAttackDamage = 1
		self.NextAnyAttackTime_Melee = 3
		self.AnimTbl_MeleeAttack = {"AttackD"}
		self.MeleeAttackAngleRadius = 100
		self.MeleeAttackAnimationFaceEnemy = false
		self.MeleeAttackDamage = 15
		self.MeleeAttackDamageAngleRadius = 15
		self.MeleeAttackDamageDistance = 25
		self.MeleeAttackDamageType = DMG_SLASH
		self.MeleeAttackAnimationDecreaseLengthAmount = 0
		self.NextAnyAttackTime_Melee = 1.5
		
		
		
		
		
		
				elseif anyattack == 5 then
		self.MeleeAttackDistance = 15
		self.TimeUntilMeleeAttackDamage = 1
		self.NextAnyAttackTime_Melee = 3
		self.AnimTbl_MeleeAttack = {"AttackE"}
		self.MeleeAttackAngleRadius = 100
		self.MeleeAttackAnimationFaceEnemy = false
		self.MeleeAttackDamage = 20
		self.MeleeAttackDamageAngleRadius = 15
		self.MeleeAttackDamageDistance = 25
		self.MeleeAttackDamageType = DMG_SLASH
		self.MeleeAttackAnimationDecreaseLengthAmount = 0
		self.NextAnyAttackTime_Melee = 1.5
		
		
		
		
		
		
			
				elseif anyattack == 5 then
		self.MeleeAttackDistance = 15
		self.TimeUntilMeleeAttackDamage = 1
		self.NextAnyAttackTime_Melee = 3
		self.AnimTbl_MeleeAttack = {"AttackF"}
		self.MeleeAttackAngleRadius = 100
		self.MeleeAttackAnimationFaceEnemy = false
		self.MeleeAttackDamage = 20
		self.MeleeAttackDamageAngleRadius = 15
		self.MeleeAttackDamageDistance = 25
		self.MeleeAttackDamageType = DMG_SLASH
		self.MeleeAttackAnimationDecreaseLengthAmount = 0
		self.NextAnyAttackTime_Melee = 1.5
		
end
end
end
--------------------------------------------------------------------------------------------------------------------------------------------
-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/