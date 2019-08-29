local round_status = 0 -- Zombie Wave

net.Receive("UpdateRoundStatus", function(len) -- Zombie Wave
round_status = net.ReadInt(4)
end)

hook.Add( "HUDPaint", "RoundStatus", function()
	surface.SetFont( "DermaLarge" )
	surface.SetTextColor( 255, 255, 255 )
	surface.SetTextPos( 128, 128 )
	surface.DrawText( GetGlobalFloat("Round") )
end )

function getRoundStatuszw() -- Zombie Wave
return round_status
end

//beginRound() -- Code to start the round.