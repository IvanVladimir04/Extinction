---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------Wave-------------------------------------------------------------------
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

function beginRound()
	round_status = 1
	updateClientRoundStatus()
	isSpawning = true
end

function endRound()
	round_status = 0
	updateClientRoundStatus()
end

function getRoundStatus()
return round_status
end

function updateClientRoundStatus()
	net.Start("UpdateRoundStatus")
	net.WriteInt(round_status, 4)
	net.Broadcast()
end

local nextWaveWaiting = false

hook.Add("Think", "WaveThink", function ()

if round_status == 1 and isSpawning == true then

         nextWaveWaiting = false

         if t < CurTime() then
		 
	          t = CurTime() + interval
			  
			  for i = 1, 7 do
				local temp = ents.Create(GetConVar("extinction_ent"..i..""):GetString())
				temp:SetPos(spawnPos[math.random(1, table.Count(spawnPos))])
				temp:Spawn()
				temp:SetEnemy(table.Random(player.GetAll()))
				temp:SetHealth(10 * activeRound)
			  end
			 		  
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