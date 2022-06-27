GST_SNK.Utils = {}

function GST_SNK.Utils:GetWorldHeightPos(pos)
    local trace = util.TraceLine( {
        start = pos,
        endpos = pos + Angle(90,0,0):Forward() * 10000
    })

    return trace.HitPos
end

function GST_SNK.Utils:CreateGhost(model, attached_ent, max_range)
    util.PrecacheModel(model)
    if (not attached_ent.IsPlaced) then
        if (IsValid(attached_ent.ghost)) then
            attached_ent.ghost:Remove()
        end
        attached_ent.ghost = ents.CreateClientProp(model)
        attached_ent.ghost:SetMoveType( MOVETYPE_NONE )
        attached_ent.ghost:SetRenderMode( RENDERMODE_TRANSCOLOR )
        attached_ent.ghost:SetColor( Color( 6, 238, 255, 200) )
        attached_ent.ghost:Spawn()
        timer.Create("ShowGhost", 0, 0, function()
            if (not IsValid(attached_ent.ghost)) then
                timer.Remove("ShowGhost")
                return
            end
            if (LocalPlayer():GetActiveWeapon() ~= attached_ent) then
                attached_ent.ghost:Remove()
                timer.Remove("ShowGhost")
                return
            end

            local trace = LocalPlayer():GetEyeTrace()
            if (trace.Hit) then
                local ghostPos = LocalPlayer():GetEyeTrace().HitPos

                if (ghostPos:Distance(attached_ent:GetOwner():GetPos()) <= max_range) then
                    attached_ent.ghost:SetPos(ghostPos)
                else
                    local pos = LocalPlayer():LocalToWorld(Vector(max_range,0,0))
                    attached_ent.ghost:SetPos(GetClientWorldHeightPos(pos))
                end
                attached_ent.ghost:SetAngles(Angle(0, LocalPlayer():GetAngles()[2], 0))
            end
        end)
    end
end

function GST_SNK.Utils:GetDestructibleBuild(targetName)
    local mapName = game.GetMap()
    for _, buildName in pairs(GST_SNK.Maps[mapName].DestructibleBuild) do
        if (string.match(targetName, buildName)) then
            return ents.FindByName(buildName .. "_1")[1], ents.FindByName(buildName .. "_2")[1], ents.FindByName(buildName .. "_3")[1]
        end
    end
end

function GST_SNK.Utils:BreakNextBuildState(buildName)
    if (buildName == nil) then return end

    local build1, build2, build3 = GST_SNK.Utils:GetDestructibleBuild(buildName)
    if (build1) then
        build1:Fire("Break")
    elseif (build2) then
        build2:Fire("Break")
    elseif (build3) then
        build3:Fire("Break")
    end
end

function GST_SNK.Utils:GetNearestDestructibleBuild(pos, range)
    local range = range and range or 150
    local mapName = game.GetMap()

    for _, ent in pairs(ents.FindInSphere(pos, range)) do
        if (IsValid(ent) and not ent:IsPlayer()
           and table.HasValue(GST_SNK.Maps[mapName].DestructibleBuild, string.match(ent:GetName(), "^[a-z]*"))) then
            return ent:GetName()
        end
    end
end

function GST_SNK.Utils:RunAnimation(animationName, ply, netName)
    ply:SetNWString("doAnimation", animationName)
    local _, animTime = ply:LookupSequence(animationName)

    net.Start(netName)
        net.WriteEntity(ply)
    net.Broadcast()

    timer.Simple(animTime, function()
        if(ply:GetNWString("doAnimation") == animationName) then
            ply:SetNWString("doAnimation", "")
        end
    end)
end