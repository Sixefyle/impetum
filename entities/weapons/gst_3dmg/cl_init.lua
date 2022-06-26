include('shared.lua')

-- local mat = Material( "models/shiny" )
-- mat:SetFloat( "$alpha", 0.1 )
-- hook.Add( "PostDrawOpaqueRenderables", "conetest", function()
-- 	local size = 200
-- 	local dir = LocalPlayer():GetAimVector()
-- 	local angle = math.cos( math.rad( 45 ) )
-- 	local startPos = LocalPlayer():EyePos()

-- 	local entities = ents.FindInCone( startPos, dir, size, angle )

-- 	-- draw the outer box
-- 	local mins = Vector( -size, -size, -size )
-- 	local maxs = Vector( size, size, size )

-- 	render.SetMaterial( mat )
-- 	render.DrawWireframeBox( startPos, Angle( 0, 0, 0 ), mins, maxs, color_white, true )
-- 	render.DrawBox( startPos, Angle( 0, 0, 0 ), -mins, -maxs, color_white )

-- 	-- draw the lines
-- 	for id, ent in ipairs( entities ) do
-- 		render.DrawLine( ent:WorldSpaceCenter() - dir * ( ent:WorldSpaceCenter()-startPos ):Length(), ent:WorldSpaceCenter(), Color( 255, 230, 0) )
-- 	end
-- end )