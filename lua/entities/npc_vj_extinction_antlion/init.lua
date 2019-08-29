AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/antlion.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 50
ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle, etc.)
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasBloodParticle = true -- Does it spawn a particle when damaged?
ENT.HasBloodDecal = true -- Does it spawn a decal when damaged?
ENT.HasBloodPool = true -- Does it have a blood pool?
ENT.BloodPoolSize = "Tiny" -- What's the size of the blood pool?
ENT.SightDistance = 999999999 -- How far it can see
ENT.SightAngle = 180 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.TurningSpeed = 20 -- How fast it can turn
ENT.FindEnemy_UseSphere = true -- Should the SNPC be able to see all around him? (360) | Objects and walls can still block its sight!
ENT.FindEnemy_CanSeeThroughWalls = true -- Should it be able to see through walls and objects? | Can be useful if you want to make it know where the enemy is at all times
	-- Leap Attack ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasLeapAttack = true -- Should the SNPC have a leap attack?
ENT.AnimTbl_LeapAttack = {"Fly_In"} -- Melee Attack Animations
ENT.LeapAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.LeapAttackAnimationFaceEnemy = false -- Should it face the enemy while playing the leap attack animation?
ENT.LeapAttackAnimationDecreaseLengthAmount = 0 -- This will decrease the time until starts chasing again. Use it to fix animation pauses until it chases the enemy.
ENT.LeapDistance = 700 -- The distance of the leap, for example if it is set to 500, when the SNPC is 500 Unit away, it will jump
ENT.LeapToMeleeDistance = 300 -- How close does it have to be until it uses melee?
	-- To use event-based attacks, set this to false:
ENT.TimeUntilLeapAttackDamage = 0.60 -- How much time until it runs the leap damage code?
ENT.NextLeapAttackTime = 4 -- How much time until it can use a leap attack?
ENT.NextLeapAttackTime_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.NextAnyAttackTime_Leap = 1 -- How much time until it can use any attack again? | Counted in Seconds
ENT.NextAnyAttackTime_Leap_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.LeapAttackReps = 1 -- How many times does it run the leap attack code?
ENT.StopLeapAttackAfterFirstHit = true -- Should it stop the leap attack from running rest of timers when it hits an enemy?
ENT.TimeUntilLeapAttackVelocity = 0.1 -- How much time until it runs the velocity code?
ENT.LeapAttackUseCustomVelocity = false -- Should it disable the default velocity system?
ENT.LeapAttackVelocityForward = 110 -- How much forward force should it apply?
ENT.LeapAttackVelocityUp = 500 -- How much upward force should it apply?
ENT.LeapAttackVelocityRight = 0 -- How much right force should it apply?
ENT.LeapAttackDamage = 0
ENT.LeapAttackDamageDistance = 0 -- How far does the damage go?
ENT.LeapAttackDamageType = DMG_SLASH -- Type of Damage
ENT.DisableLeapAttackAnimation = false -- if true, it will disable the animation code
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.RunAwayOnUnknownDamage = true -- Should run away on damage
ENT.VJ_NPC_Class = {"CLASS_ANTLION"} -- NPCs with the same class with be allied to each other
ENT.HasSounds = true -- Put to false to disable ALL sound
ENT.SoundTbl_LeapAttackJump = {"npc/antlion/distract1.wav","npc/antlion/digup1.wav"}
ENT.SoundTbl_CombatIdle = {"npc/antlion/idle1.wav","npc/antlion/idle2.wav","npc/antlion/idle3.wav","npc/antlion/idle4.wav","npc/antlion/idle5.wav"}
ENT.SoundTbl_Pain = {"npc/antlion/pain1.wav","npc/antlion/pain2.wav"}
ENT.SoundTbl_FootStep = {"npc/antlion/foot1.wav","npc/antlion/foot2.wav","npc/antlion/foot3.wav","npc/antlion/foot4.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"npc/antlion/attack_single1.wav","npc/antlion/attack_single2.wav","npc/antlion/attack_single3.wav"}
ENT.VJ_NPC_Class = {"CLASS_EXTINCTIONGAMEMODE_ANTLION"} -- NPCs with the same class with be allied to each other
ENT.FadeCorpse = true -- Fades the ragdoll on death
ENT.FadeCorpseTime = 3 -- How much time until the ragdoll fades | Unit = Seconds
ENT.PushProps = false -- Should it push props when trying to move?
ENT.AttackProps = true -- Should it attack props when trying to move?
ENT.HasEntitiesToNoCollide = true -- If set to false, it won't run the EntitiesToNoCollide code
ENT.EntitiesToNoCollide = {"npc_vj_extinction_antlion","npc_antlionguard"} -- Entities to not collide with when HasEntitiesToNoCollide is set to true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
self:SetCollisionBounds(Vector(40, 40, 40), Vector(-40, -40, 0))
self:SetSkin(math.random(1, 4))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleMeleeAttacks()
local EnemyDistance = self:VJ_GetNearestPointToEntityDistance(self:GetEnemy(),self:GetPos():Distance(self:GetEnemy():GetPos()))
if EnemyDistance > 0 && EnemyDistance < 10000 then
    local anyattack = math.random(1,2,3,4,5,6)	
		if anyattack == 1 then
		self.MeleeAttackDistance = 30
		self.TimeUntilMeleeAttackDamage = 1
		self.NextAnyAttackTime_Melee = 3
		self.AnimTbl_MeleeAttack = {"Attack1"}
		self.MeleeAttackAngleRadius = 100
		self.MeleeAttackAnimationFaceEnemy = false
		self.MeleeAttackDamage = 15
		self.MeleeAttackDamageAngleRadius = 15
		self.MeleeAttackDamageDistance = 70
		self.MeleeAttackDamageType = DMG_SLASH
		self.MeleeAttackAnimationDecreaseLengthAmount = 0
		self.NextAnyAttackTime_Melee = 1.5
		
		
		
		
		elseif anyattack == 2 then
		self.MeleeAttackDistance = 30
		self.TimeUntilMeleeAttackDamage = 1
		self.NextAnyAttackTime_Melee = 3
		self.AnimTbl_MeleeAttack = {"Attack2"}
		self.MeleeAttackAngleRadius = 100
		self.MeleeAttackAnimationFaceEnemy = false
		self.MeleeAttackDamage = 20
		self.MeleeAttackDamageAngleRadius = 15
		self.MeleeAttackDamageDistance = 70
		self.MeleeAttackDamageType = DMG_SLASH
		self.MeleeAttackAnimationDecreaseLengthAmount = 0
		self.NextAnyAttackTime_Melee = 1.5
		
		
		
		
		elseif anyattack == 3 then
		self.MeleeAttackDistance = 30
		self.TimeUntilMeleeAttackDamage = 1
		self.NextAnyAttackTime_Melee = 3
		self.AnimTbl_MeleeAttack = {"Attack3"}
		self.MeleeAttackAngleRadius = 100
		self.MeleeAttackAnimationFaceEnemy = false
		self.MeleeAttackDamage = 15
		self.MeleeAttackDamageAngleRadius = 15
		self.MeleeAttackDamageDistance = 70
		self.MeleeAttackDamageType = DMG_SLASH
		self.MeleeAttackAnimationDecreaseLengthAmount = 0
		self.NextAnyAttackTime_Melee = 1.5
		
		
		
		elseif anyattack == 4 then
		self.MeleeAttackDistance = 30
		self.TimeUntilMeleeAttackDamage = 1
		self.NextAnyAttackTime_Melee = 3
		self.AnimTbl_MeleeAttack = {"Attack4"}
		self.MeleeAttackAngleRadius = 100
		self.MeleeAttackAnimationFaceEnemy = false
		self.MeleeAttackDamage = 15
		self.MeleeAttackDamageAngleRadius = 15
		self.MeleeAttackDamageDistance = 70
		self.MeleeAttackDamageType = DMG_SLASH
		self.MeleeAttackAnimationDecreaseLengthAmount = 0
		self.NextAnyAttackTime_Melee = 1.5
		
		
		
		
		elseif anyattack == 5 then
		self.MeleeAttackDistance = 30
		self.TimeUntilMeleeAttackDamage = 1
		self.NextAnyAttackTime_Melee = 3
		self.AnimTbl_MeleeAttack = {"Attack5"}
		self.MeleeAttackAngleRadius = 100
		self.MeleeAttackAnimationFaceEnemy = false
		self.MeleeAttackDamage = 15
		self.MeleeAttackDamageAngleRadius = 15
		self.MeleeAttackDamageDistance = 70
		self.MeleeAttackDamageType = DMG_SLASH
		self.MeleeAttackAnimationDecreaseLengthAmount = 0
		self.NextAnyAttackTime_Melee = 1.5
		
		
		
		
		elseif anyattack == 6 then
		self.MeleeAttackDistance = 30
		self.TimeUntilMeleeAttackDamage = 1
		self.NextAnyAttackTime_Melee = 3
		self.AnimTbl_MeleeAttack = {"Attack6"}
		self.MeleeAttackAngleRadius = 100
		self.MeleeAttackAnimationFaceEnemy = false
		self.MeleeAttackDamage = 20
		self.MeleeAttackDamageAngleRadius = 15
		self.MeleeAttackDamageDistance = 70
		self.MeleeAttackDamageType = DMG_SLASH
		self.MeleeAttackAnimationDecreaseLengthAmount = 0
		self.NextAnyAttackTime_Melee = 1.5
		
end
end
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/