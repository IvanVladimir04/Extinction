AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/Zombie/Fast.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
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
ENT.HasLeapAttack = true -- Should the SNPC have a leap attack?
ENT.AnimTbl_LeapAttack = {"LeapStrike"} -- Melee Attack Animations
ENT.LeapAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.LeapAttackAnimationFaceEnemy = false -- Should it face the enemy while playing the leap attack animation?
ENT.LeapAttackAnimationDecreaseLengthAmount = 0 -- This will decrease the time until starts chasing again. Use it to fix animation pauses until it chases the enemy.
ENT.LeapDistance = 400 -- The distance of the leap, for example if it is set to 500, when the SNPC is 500 Unit away, it will jump
ENT.LeapToMeleeDistance = 50 -- How close does it have to be until it uses melee?
ENT.TimeUntilLeapAttackDamage = 0.2 -- How much time until it runs the leap damage code?
ENT.NextLeapAttackTime = 3 -- How much time until it can use a leap attack?
ENT.NextLeapAttackTime_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.NextAnyAttackTime_Leap = 1 -- How much time until it can use any attack again? | Counted in Seconds
ENT.NextAnyAttackTime_Leap_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.LeapAttackReps = 1 -- How many times does it run the leap attack code?
ENT.LeapAttackExtraTimers = {/* Ex: 1,1.4 */} -- Extra leap attack timers | it will run the damage code after the given amount of seconds
ENT.StopLeapAttackAfterFirstHit = true -- Should it stop the leap attack from running rest of timers when it hits an enemy?
ENT.TimeUntilLeapAttackVelocity = 0.1 -- How much time until it runs the velocity code?
ENT.LeapAttackUseCustomVelocity = false -- Should it disable the default velocity system?
ENT.LeapAttackVelocityForward = 500 -- How much forward force should it apply?
ENT.LeapAttackVelocityUp = 270 -- How much upward force should it apply?
ENT.LeapAttackVelocityRight = 0 -- How much right force should it apply?
ENT.LeapAttackDamage = 20
ENT.LeapAttackDamageDistance = 120 -- How far does the damage go?
ENT.LeapAttackDamageType = DMG_SLASH -- Type of Damage
ENT.DisableLeapAttackAnimation = false -- if true, it will disable the animation code
ENT.HasSounds = true -- Put to false to disable ALL sounds!
ENT.SoundTbl_CombatIdle = {"npc/fast_zombie/idle1.wav","npc/fast_zombie/idle2.wav","npc/fast_zombie/idle3.wav"}
ENT.SoundTbl_BeforeLeapAttack = {"npc/fast_zombie/leap1.wav"}
ENT.SoundTbl_MeleeAttack = {"npc/fast_zombie/claw_strike1.wav","npc/fast_zombie/claw_strike2.wav","npc/fast_zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"npc/fast_zombie/claw_miss1.wav","npc/fast_zombie/claw_miss2.wav"}
ENT.SoundTbl_Breath = {"npc/fast_zombie/breathe_loop1.wav"}
ENT.SoundTbl_Alert = {"npc/fast_zombie/fz_alert_close1.wav","npc/fast_zombie/fz_alert_far1.wav"}
ENT.SoundTbl_FootStep = {"npc/fast_zombie/foot1.wav","npc/fast_zombie/foot2.wav","npc/fast_zombie/foot3.wav","npc/fast_zombie/foot4.wav"}
ENT.SoundTbl_LeapAttackJump = {"npc/fast_zombie/fz_scream1.wav"}
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
    local anyattack = math.random(1)	
		if anyattack == 1 then
		self.MeleeAttackDistance = 15
		self.TimeUntilMeleeAttackDamage = 0.60
		self.NextAnyAttackTime_Melee = 1.5
		self.AnimTbl_MeleeAttack = {"BR2_Attack"}
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