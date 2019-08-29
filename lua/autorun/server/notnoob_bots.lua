CreateConVar( "bot_enabled", 1 , FCVAR_SERVER_CAN_EXECUTE )
CreateConVar( "bot_weapon", "weapon_ar2", FCVAR_SERVER_CAN_EXECUTE )
CreateConVar( "bot_gundistance", 5000, FCVAR_SERVER_CAN_EXECUTE )
CreateConVar( "bot_resetconvar", 0, FCVAR_SERVER_CAN_EXECUTE )
CreateConVar( "bot_backdistance", 150, FCVAR_SERVER_CAN_EXECUTE )
CreateConVar( "bot_attackplayers", 0, FCVAR_SERVER_CAN_EXECUTE )

function AstarVectorBot( start, goal )
	local startArea = navmesh.GetNearestNavArea( start )
	local goalArea = navmesh.GetNearestNavArea( goal )
	return BotAstar( startArea, goalArea )
end

function BotAstar( start, goal )
	if ( !IsValid( start ) || !IsValid( goal ) ) then return false end
	if ( start == goal ) then return true end

	start:ClearSearchLists()

	start:AddToOpenList()

	local cameFrom = {}

	start:SetCostSoFar( 0 )

	start:SetTotalCost( heuristic_cost_estimate_bot( start, goal ) )
	start:UpdateOnOpenList()

	while ( !start:IsOpenListEmpty() ) do
		local current = start:PopOpenList() -- Remove the area with lowest cost in the open list and return it
		if ( current == goal ) then
			return reconstruct_path( cameFrom, current )
		end

		current:AddToClosedList()

		for k, neighbor in pairs( current:GetAdjacentAreas() ) do
			local newCostSoFar = current:GetCostSoFar() + heuristic_cost_estimate_bot( current, neighbor )
			if ( neighbor:IsUnderwater() ) then -- Add your own area filters or whatever here
				continue
			end

			if ( ( neighbor:IsOpen() || neighbor:IsClosed() ) && neighbor:GetCostSoFar() <= newCostSoFar ) then
				continue
			else
				neighbor:SetCostSoFar( newCostSoFar );
				neighbor:SetTotalCost( newCostSoFar + heuristic_cost_estimate_bot( neighbor, goal ) )

				if ( neighbor:IsClosed() ) then

					neighbor:RemoveFromClosedList()
				end

				if ( neighbor:IsOpen() ) then
					-- This area is already on the open list, update its position in the list to keep costs sorted
					neighbor:UpdateOnOpenList()
				else
					neighbor:AddToOpenList()
				end

				cameFrom[ neighbor:GetID() ] = current:GetID()
			end
		end
	end

	return false
end

function heuristic_cost_estimate_bot( start, goal )
	-- Perhaps play with some calculations on which corner is closest/farthest or whatever
	return start:GetCenter():DistToSqr( goal:GetCenter() )
end

-- using CNavAreas as table keys doesn't work, we use IDs
function reconstruct_path( cameFrom, current )
	local total_path = { current }

	current = current:GetID()
	while ( cameFrom[ current ] ) do
		current = cameFrom[ current ]
		table.insert( total_path, navmesh.GetNavAreaByID( current ) )
	end
	return total_path
end

function drawThePath( path, time )
	local prevArea
	for _, area in pairs( path ) do
		debugoverlay.Sphere( area:GetCenter(), 8, time or 9, color_white, true	)
		if ( prevArea ) then
			debugoverlay.Line( area:GetCenter(), prevArea:GetCenter(), time or 9, color_white, true )
		end

		area:Draw()
		prevArea = area
	end
end

concommand.Add( "test_astar", function( ply )

	-- Use the start position of the player who ran the console command
	local start = navmesh.GetNearestNavArea( ply:GetPos() )

	-- Target position, use the player's aim position for this example
	local goal = navmesh.GetNearestNavArea( ply:GetEyeTrace().HitPos )

	local path = BotAstar( start, goal )
	if ( !istable( path ) ) then -- We can't physically get to the goal or we are in the goal.
		return
	end

	PrintTable( path ) -- Print the generated path to console for debugging
	drawThePath( path ) -- Draw the generated path for 9 seconds

end )

local allies = {
[CLASS_PLAYER_ALLY] = true,
[CLASS_PLAYER_ALLY_VITAL]= true
}

hook.Add( "OnEntityCreated", "SoftBotEntList", function( ent )
	if ( ( ( ent:IsPlayer() and GetConVar("bot_attackplayers"):GetInt() == 1 ) or ( ent:IsNPC() and !allies[ent:Classify()] ) or ent.Type == "nextbot") ) then
		EntList[ ent:EntIndex() ] = ent
	end
end )

hook.Add( "OnEntityRemoved", "RemoveBotEntList", function( ent )
	EntList[ ent:EntIndex() ] = nil
end )

local rePathDelay = 1 -- How many seconds need to pass before we need to remake the path to keep it updated

function mystart(ply,cmd)
	
	if (ply:IsBot() and GetConVar( "bot_enabled" ):GetInt() != 0) then
	
	distance = GetConVar( "bot_gundistance" ):GetInt()
	resetconvar = GetConVar( "bot_resetconvar"):GetInt()
	if resetconvar > 0 then
		RunConsoleCommand( "bot_gundistance", 2500 )
		RunConsoleCommand( "bot_weapon", "weapon_ar2" )
		RunConsoleCommand( "bot_resetconvar", 0 )
		RunConsoleCommand( "bot_backdistance", 150)
		RunConsoleCommand( "bot_attackplayers", 0)
		print("All commands got reset")
	end

	cmd:SetForwardMove(1000)

		ply:SetWalkSpeed(1)
		timer.Simple(0.5, function()
			if IsValid(ply) then
				ply:Give(GetConVar( "bot_weapon" ):GetString())
				ply:SelectWeapon(GetConVar( "bot_weapon" ):GetString())
				ply:GiveAmmo(9999,ply:GetActiveWeapon():GetPrimaryAmmoType())
				--ply:GiveAmmo(9999,ply:GetActiveWeapon():GetSecondaryAmmoType())
			end
		end)
		if !IsValid(ply.Enemy) then
			for index, v in pairs( EntList ) do
				if v != ply and IsValid(v) then
					if v:Health() > 0 then
						ply.Enemy = v
					end
				end
			end
		end
		if IsValid(ply.Enemy) then
		local v = ply.Enemy
			if !ply.NextBotThink then ply.NextBotThink = CurTime()+1 end
			if ply.NextBotThink < CurTime() then
				if ply:IsLineOfSightClear(v) and ply:GetPos():DistToSqr( v:GetPos() ) < distance^2 then
					ply.Shoot = true
				else
					ply.Shoot = false
				end
				if ply:GetPos():DistToSqr(v:GetPos()) < GetConVar( "bot_backdistance" ):GetInt()^2 then
					ply.Path = false
				else
					ply.Path = true
				end
				ply.NextBotThink = CurTime()+1
			end
				if ply.Shoot then
					cmd:SetButtons(IN_ATTACK)
				end
				local vec1 = v:GetPos() + v:OBBCenter()
				local vec2 = ply:GetShootPos() 
				ply:SetEyeAngles( ( vec1 - vec2 ):Angle() )
				--[[if ply:GetPos():DistToSqr( b:GetPos() ) >  GetConVar( "bot_forwarddistance" ):GetInt()^2 then
					cmd:SetForwardMove(1000)
					ply:SetWalkSpeed(200)
				else]]
				if !ply.Path then
					cmd:SetForwardMove(-1000)
					ply:SetWalkSpeed(200)
					cmd:SetButtons(IN_SPEED)
				else
					BotMovePath(ply,cmd,v)
				end
				ply:SetWalkSpeed(200)
			end
	end
end

function BotMovePath(ply,cmd,v)
	cmd:ClearMovement()
	local currentArea = navmesh.GetNearestNavArea( ply:GetPos() )

	-- internal variable to regenerate the path every X seconds to keep the pace with the target player
	ply.lastRePath = ply.lastRePath or 0

	-- internal variable to limit how often the path can be ( re )generated
	ply.lastRePath2 = ply.lastRePath2 or 0

	if ( ply.path && ply.lastRePath + rePathDelay < CurTime() && currentArea != ply.targetArea ) then
		ply.path = nil
		ply.lastRePath = CurTime()
	end

	if ( !ply.path && ply.lastRePath2 + rePathDelay < CurTime() ) then

		local targetPos = v:GetPos() -- target position to go to, the first player on the server
		local targetArea = navmesh.GetNearestNavArea( targetPos )
		ply.targetArea = nil
		ply.path = BotAstar( currentArea, targetArea )
		if ( !istable( ply.path ) ) then -- We are in the same area as the target, or we can't navigate to the target
			ply.path = nil -- Clear the path, bail and try again next time
			ply.lastRePath2 = CurTime()
			return
		end
		--PrintTable( ply.path )

		-- TODO: Add inbetween points on area intersections
		-- TODO: On last area, move towards the target position, not center of the last area
		table.remove( ply.path ) -- Just for this example, remove the starting area, we are already in it!
	end
	-- We have no path, or its empty ( we arrived at the goal ), try to get a new path.
	if ( !ply.path || #ply.path < 1 ) then
		ply.path = nil
		ply.targetArea = nil
		return
	end
	-- We got a path to follow to our target!
		--drawThePath( ply.path, .1 ) -- Draw the path for debugging

	-- Select the next area we want to go into
	if ( !IsValid( ply.targetArea ) ) then
		ply.targetArea = ply.path[ #ply.path ]
	end
	-- The area we selected is invalid or we are already there, remove it, bail and wait for next cycle
	if ( !IsValid( ply.targetArea ) || ( ply.targetArea == currentArea && ply.targetArea:GetCenter():DistToSqr( ply:GetPos() ) < 64^2 ) ) then
		table.remove( ply.path ) -- Removes last element
		ply.targetArea = nil
		return
	end
	-- We got the target to go to, aim there and MOVE
	local targetang = ( ply.targetArea:GetCenter() - ply:GetPos() ):GetNormalized():Angle()
	if #ply.path == 1 then
		targetang = ( v:GetPos() - ply:GetPos() ):GetNormalized():Angle()
	else
		if !ply.targetArea:IsVisible(ply.path[#ply.path-1]:GetCenter()) then
			cmd:SetButtons(IN_JUMP)
		end
	end
						
	cmd:SetViewAngles( targetang )
	cmd:SetForwardMove( 1000 )
end

hook.Add("StartCommand","mystart",mystart)
--Unused Code
--[[function botLevelUp( ply,cmd )
	if ply:IsBot() and ply:Alive() then
		plyLevel = ply:GetNetworkedInt( "PlyLevel", 1 )
		
		ply:SetNetworkedInt( "PlyLevel", plyLevel + 1 )
	end
end
hook.Add("StartCommand","botLevelUp",botLevelUp)]]

function botDeath( victim, attacker, weapon )
	if victim:IsBot() then
		ply = victim
		botSaySomething(ply,"death",50)
		--print(attacker)
		if attacker:IsPlayer() and attacker:IsBot() then
			botSaySomething(attacker,"attack",50)
		end
	end
end
hook.Add("PlayerDeath","botDeath",botDeath)

function spawnRun(ply)
	
	if ply:IsBot() then
		ply:Give("weapon_physgun")
		ply:SelectWeapon("weapon_physgun")
		local colors = {Vector(255,0,0),Vector(0,255,0),Vector(0,0,255),Vector(255,0,255),Vector(255,255,0),Vector(0,255,255)}
		-- local sm,ms = file.Find( "models/player/*.mdl", "MOD", nameasc )
		local crdm = math.random(1,#colors)
		
		CreateConVar( "bot_weapon", "weapon_smg1", FCVAR_SERVER_CAN_EXECUTE, "[NOOB BOTS]What weapon bots use when they attack" )
		CreateConVar( "bot_gundistance", 2500, FCVAR_SERVER_CAN_EXECUTE, "[NOOB BOTS]What distance can bots detect med-kits and enemies?" )
		CreateConVar( "bot_meddistance", 2500, FCVAR_SERVER_CAN_EXECUTE, "[NOOB BOTS]What distance can bots detect med-kits and enemies?" )
		CreateConVar( "bot_meleedistance", 2500, FCVAR_SERVER_CAN_EXECUTE, "[NOOB BOTS]What distance can bots detect med-kits and enemies?" )
		-- timer.Simple(0.1,function() ply:SetModel("models/player/"..sm[math.random(1,#sm)]) end )
		local model = table.Random( player_manager.AllValidModels())
		timer.Simple(0.1,function()
			ply:SetModel( model )
		end)
		timer.Simple(0.1,function() ply:SetPlayerColor(colors[crdm]) end)
		--print(colors[crdm])
		
		--print("Bot Spawned!")
		-- Scrapped Content(Bots was gonna be able to build)
		--buildPos = ply:GetPos()
		--builds = {1,2,3,4,5,6}
		--build = builds[ math.random(1,#builds) ]
		
		
		botSaySomething(ply,"spawn",30)
	
	end
end

hook.Add("PlayerSpawn","spawnRun",spawnRun)

util.AddNetworkString( "sendToChat" )
function botSaySomething(ply,saytype,chance)
local ran = math.random(1,100)
if chance ~= nil then
if ran < chance then

	if saytype == "spawn" then
		local msgs = {"I am coming 4 u! Again!","I am coming for you! Again!","You think you could beat me?","Back from the dead."}
		net.Start("sendToChat")
			local msg = msgs[math.random(1,#msgs)]
			net.WriteString(msg)
			net.WriteEntity(ply)
		net.Broadcast()
	end

	if saytype == "death" then
		local msgs = {"Really?","Ugh.",":(","CYKA BLYAD","IDI NAHUI","F*CK","well shet."}
		net.Start("sendToChat")
			local msg = msgs[math.random(1,#msgs)]
			net.WriteString(msg)
			net.WriteEntity(ply)
		net.Broadcast()
	end

	if saytype == "attack" then
		local msgs = {"Goodbye.","You just died.","gg","Get rekt scrub","You just got pwned!","OOF","Rest in Piss"}
		net.Start("sendToChat")
			local msg = msgs[math.random(1,#msgs)]
			net.WriteString(msg)
			net.WriteEntity(ply)
		net.Broadcast()
	end

end
end
end

function botInit( ply )
	if ply:IsBot() then
		names = {"Cave Johnson","Chell and PotatOS","GlaDOS","I'm a aim-bot","Poopy Joe","noob_bots.lua","what do I put here?","Pewdiepie","Not Pewdiepie","hl2.exe","Pootis","Toattly not a 5-year-old","I got this game for my birthday","xX360NoscopeBlazeItAlpha420FazeClanXx","YOU SUX","-_-","Gman","gmod.exe","hax.exe loaded","hax.exe","KA-BOOM","Muselk","ster","Star","Jerma985","Idk what to type anymore","lol","Half Life 2.9","SYNTAX:ERROR","Bill Cosby","bot.exe has stopped working","hl2.exe has stopped working","PS4 is better then PC","PC is better then PS4","Xbone is better then PC","PC is better then Xbone","PS4 is better then Xbone","Xbone is better then PS4","PS4 SUX","XBONE SUX","PC SUX","WII U SUX",""}
		
		Timestamp = os.time()
		TimeStr = os.date( "%m %d" , Timestamp )
		--print( TimeStr )
		
		if TimeStr == "04 06" then
			ply:SetNWString("Name", "Testing123" )
		else
			ply:SetNWString("Name", names[math.random(1,#names)] )
		end
		--ply:SetNWString("Name", names[math.random(1,#names)] )
		
	    usermessage.Hook( "Send_Print", function( data )

			chat.PlaySound()
			   -- Prints in white
			chat.AddText( team.GetColor( ply:Team() ), ply:GetName() )

		end )
		PrintMessage(HUD_PRINTTALK,"BOT "..ply:GetName().." has joined the game")
	end
end
hook.Add("PlayerInitialSpawn","botInit",botInit)

function botKick( ply )
	
	if ply:IsBot() then
		PrintMessage( HUD_PRINTTALK, "BOT "..ply:GetName().." has been kicked from the server." )
	end

end
hook.Add( "PlayerDisconnected","botKick",botKick)

function addonInit()
	--print("[Noob Bots]Noob bots loaded.")
	timer.Simple(3,function()
	
		RunConsoleCommand( "bot_resetconvar", 1 )
	
	end)
end
hook.Add("Initialize","addonInit",addonInit)