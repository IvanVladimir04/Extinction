---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------Zombie Wave-------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------

local round_status = 0 --0 = end, 1 = active
local activeRound = 1

local t = 0
local interval = 2
local NPCCount = 2 
local isSpawning = false
--spawnPos gives what temp entity where to spawn and is USED FOR ALL WAVE TYPES!
local spawnPos = {
Vector(-2439.681885, -3044.040039, 344.018951),
Vector(1485.287598, -2051.187500, 172.250275),
Vector(-3500.153809, -709.550293, 414.735535),
Vector(1026.080566, 540.653931, 145.995529),
Vector(-5270.896484, -1102.268921, 400.155396),
Vector(5364.663086, -3035.368896, 140.610077),
Vector(3972.987305, 793.157593, 110.248764)
}

function getBestSpawn()
	local bestSpawn = Vector(0,0,0)
	local closestDistance = 0

	if table.Count(ents.FindByClass("npc_*")) == 0 then

	return spawnPos[math.random(1, table.Count(spawnPos))]

	end

	for k, v in pairs(spawnPos) do
		local closestEntityDistance = 3000

		for a, b in pairs(ents.FindByClass("npc_*")) do
			if b:GetPos():DistToSqr(v) < closestEntityDistance^2 then
				closestEntityDistance = b:GetPos():DistToSqr(v)
			end

		end

		if closestEntityDistance > closestDistance^2 then

			closestDistance = closestEntityDistance
			bestSpawn = v

		end

	end

	print(bestSpawn)
end

function Music()
	ply:EmitSound("sound/music/of2officaltheme(new).mp3", 500, 200)
end

util.AddNetworkString("UpdateRoundStatus") 

function beginRoundzw()
	Zombie = true
	round_status = 1
	updateClientRoundStatuszw()
	isSpawning = true
end

function endRoundzw()
	Zombie = false
	round_status = 0
	updateClientRoundStatuszw()
end

function getRoundStatuszw()
return round_status
end

function updateClientRoundStatuszw()
net.Start("UpdateRoundStatus")
net.WriteInt(round_status, 4)
net.Broadcast()
end

local nextWaveWaiting = false

hook.Add("Think", "WaveThink1", function ()

if round_status == 1 and isSpawning == true and Zombie == true then

         nextWaveWaiting = false

         if t < CurTime() then
		 
	          t = CurTime() + interval
			  
			  local temp = ents.Create("npc_vj_extinction_zombie")
			  local temp2 = ents.Create("npc_vj_extinction_zombie_fast")
			  local temp3 = ents.Create("npc_vj_extinction_zombie_poison")
			  local temp4 = ents.Create("npc_vj_extinction_headcrab")
			  local temp5 = ents.Create("npc_vj_extinction_headcrab_black")
			  local temp6 = ents.Create("npc_vj_extinction_headcrab_black")
			  temp:SetPos(spawnPos[math.random(1, table.Count(spawnPos))])
			  temp:Spawn()
			  temp:SetEnemy(table.Random(player.GetAll()))
			  temp:SetHealth(10 * activeRound)
			  temp2:SetPos(spawnPos[math.random(1, table.Count(spawnPos))])
			  temp2:Spawn()
			  temp2:SetEnemy(table.Random(player.GetAll()))
			  temp2:SetHealth(10 * activeRound)
			  temp3:SetPos(spawnPos[math.random(1, table.Count(spawnPos))])
			  temp3:Spawn()
			  temp3:SetEnemy(table.Random(player.GetAll()))
			  temp3:SetHealth(10 * activeRound)
			  temp4:SetPos(spawnPos[math.random(1, table.Count(spawnPos))])
			  temp4:Spawn()
			  temp4:SetEnemy(table.Random(player.GetAll()))
			  temp4:SetHealth(10 * activeRound)
			  temp5:SetPos(spawnPos[math.random(1, table.Count(spawnPos))])
			  temp5:Spawn()
			  temp5:SetEnemy(table.Random(player.GetAll()))
			  temp5:SetHealth(10 * activeRound)
			  temp6:SetPos(spawnPos[math.random(1, table.Count(spawnPos))])
			  temp6:Spawn()
			  temp6:SetEnemy(table.Random(player.GetAll()))
			  temp6:SetHealth(10 * activeRound)
			  
		
			 		  
              NPCCount =  NPCCount - 2
			  
			  if NPCCount <= 0 then
			  
			        isSpawning = false
					
					
							
		 end
     
       end

     end
   
   if round_status == 1 and isSpawning == false and table.Count(ents.FindByClass("npc_*")) == 0 and nextWaveWaiting == false then
   
      activeRound = activeRound + 1
	  
	  SetGlobalFloat( "Round", activeRound )
	 
	  nextWaveWaiting = true
	  
	  timer.Simple(10,function()
	  
	  NPCCount = 2 * activeRound 
	  getBestSpawn()
	  isSpawning = true
	  
	  end)
   
   end

end)

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------Antlion Wave------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------


function beginRoundaw()
Antlion = true
round_status = 1
updateClientRoundStatusaw()
isSpawning = true
end

function endRoundaw()
Antlion = false
round_status = 0
updateClientRoundStatusaw()
end

function getRoundStatusaw()
return round_status
end


hook.Add("Think", "WaveThink2", function ()

	if round_status == 1 and isSpawning == true and Antlion == true then

         nextWaveWaiting = false

         if t < CurTime() then
		 
	          t = CurTime() + interval
			  
			  local temp = ents.Create("npc_vj_extinction_antlion")
			  local temp2 = ents.Create("npc_vj_extinction_antlion")
			  local temp3 = ents.Create("npc_vj_extinction_antlion")
			  local temp4 = ents.Create("npc_vj_extinction_antlion")
			  local temp5 = ents.Create("npc_vj_extinction_antlion")
			  local temp6 = ents.Create("npc_vj_extinction_antlion")
			  temp:SetPos(spawnPos[math.random(1, table.Count(spawnPos))])
			  temp:Spawn()
			  temp:SetEnemy(table.Random(player.GetAll()))
			  temp:SetHealth(10 * activeRound)
			  temp2:SetPos(spawnPos[math.random(1, table.Count(spawnPos))])
			  temp2:Spawn()
			  temp2:SetEnemy(table.Random(player.GetAll()))
			  temp2:SetHealth(10 * activeRound)
			  temp3:SetPos(spawnPos[math.random(1, table.Count(spawnPos))])
			  temp3:Spawn()
			  temp3:SetEnemy(table.Random(player.GetAll()))
			  temp3:SetHealth(10 * activeRound)
			  temp4:SetPos(spawnPos[math.random(1, table.Count(spawnPos))])
			  temp4:Spawn()
			  temp4:SetEnemy(table.Random(player.GetAll()))
			  temp4:SetHealth(10 * activeRound)
			  temp5:SetPos(spawnPos[math.random(1, table.Count(spawnPos))])
			  temp5:Spawn()
			  temp5:SetEnemy(table.Random(player.GetAll()))
			  temp5:SetHealth(10 * activeRound)
			  temp6:SetPos(spawnPos[math.random(1, table.Count(spawnPos))])
			  temp6:Spawn()
			  temp6:SetEnemy(table.Random(player.GetAll()))
			  temp6:SetHealth(10 * activeRound)
			 
			  
			 
			  NPCCount =  NPCCount - 2
			  
			  if NPCCount <= 0 then
			  
			        isSpawning = false
							
		 end
     
       end

     end
   
   if round_status == 1 and isSpawning == false and table.Count(ents.FindByClass("npc_*")) == 0 and nextWaveWaiting == false then
   
      activeRound = activeRound + 1
	  
	  SetGlobalFloat( "Round", activeRound )
	 
	  nextWaveWaiting = true
	  
	  timer.Simple(10,function()
	  
	  NPCCount = 2 * activeRound 
	  getBestSpawn()
	  isSpawning = true
	  
	  end)
   
   end

end)

function updateClientRoundStatusaw()
	net.Start("UpdateRoundStatus")
	net.WriteInt(round_status, 4)
	net.Broadcast()
end