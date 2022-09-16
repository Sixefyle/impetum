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
           and table.HasValue(GST_SNK.Maps[mapName].DestructibleBuild, string.match(ent:GetName(), "^[a-zA-Z]*"))) then
            return ent:GetName()
        end
    end
end

function GST_SNK.Utils:RunAnimation(animationName, ply, freezePlayer, time)
    ply:SetNWString("doAnimation", animationName)
    local _, animTime = ply:LookupSequence(animationName)

    net.Start("AOTA:TC:DoAnimation")
        net.WriteEntity(ply)
        net.WriteString(animationName)
        net.WriteUInt(time and time or 0, 8)
    net.Broadcast()

    if (freezePlayer) then
        ply:Freeze(true)
    end
    timer.Simple(time and time or animTime, function()
        if (ply:GetNWString("doAnimation") == animationName) then
            ply:SetNWString("doAnimation", "")
            if (freezePlayer) then
                ply:Freeze(false)
            end
        end
    end)

    return animTime
end

function GST_SNK.Utils:SpawnCaptureFlag(position, index)
    local flag = ents.Create("capture_point")
    flag:Spawn()
    flag:SetPos(position)
    flag:SetNWInt("captureFlagIndex", index)
    return flag
end

function GST_SNK.Utils:PlaySoundToPlayer(soundName, ply)
    if (not soundName or soundName == "") then return end

    net.Start("AOTA:TC:PlaySound")
        net.WriteString(soundName)
    net.Send(ply)
end

function GST_SNK.Utils:PlaySoundToAllPlayer(soundName)
    if (not soundName or soundName == "") then return end

    net.Start("AOTA:TC:PlaySound")
        net.WriteString(soundName)
    net.Broadcast()
end

function GST_SNK.Utils:PlayLoopingSoundToPlayer(soundName, ply)
    if (not soundName or soundName == "" or not IsValid(ply)) then return end

    net.Start("AOTA:TC:PlayLoopSound")
        net.WriteString(soundName)
    net.Send(ply)
end

function GST_SNK.Utils:PlaySound(soundName, ply, shouldLoop)
    if (not soundName  or soundName == "" or not IsValid(ply)) then return end
    if (shouldLoop) then
        if (ply.loopingSound) then
            ply:StopLoopingSound(ply.loopingSound)
        end

        ply.loopingSound = ply:StartLoopingSound(soundName)
        GST_SNK.Utils:PlayLoopingSoundToPlayer(soundName, ply)
    else
        ply:EmitSound(soundName)
        GST_SNK.Utils:PlaySoundToPlayer(soundName, ply)
    end
end

function GST_SNK.Utils:StopLoopingSound(ply)
    if (not IsValid(ply)) then return end
    if (ply.loopingSound) then
        ply:StopLoopingSound(ply.loopingSound)
        net.Start("AOTA:TC:StopLoopSound")
        net.Send(ply)
    end
end

function GST_SNK.Utils:GetNearEntsAmount(pos, range, exclude)
    local entTable = {}
    for _, ent in pairs(ents.FindInSphere(pos, range)) do
        if (not table.HasValue(exclude, ent:GetName())) then
            table.insert(entTable, ent)
        end
    end
    return #entTable
end
