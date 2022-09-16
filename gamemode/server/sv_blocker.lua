hook.Add( "CanProperty", "block_remover_property", function( ply, property, ent )
	if not ply:IsAdmin() then
        return false
    end
    return true
end )

function GM:PlayerNoClip( pl, on )
    if not pl:IsAdmin() then
        return false
    end
    return true
end

function GM:PlayerSpawnProp(ply, model)
    if not ply:IsAdmin() then
        return false
    end
    return true
end

function GM:PlayerSpawnedProp(ply, model, ent)
    if not ply:IsAdmin() then
        return false
    end
    return true
end

function GM:PlayerSpawnSENT(ply, class)
    if not ply:IsAdmin() then
        return false
    end
    return true
end

function GM:PlayerSpawnedSENT(ply, ent)
    if not ply:IsAdmin() then
        return false
    end
    return true
end

function GM:PlayerSpawnSWEP(ply, class, info)
    if not ply:IsAdmin() then
        return false
    end
    return true
end

function GM:PlayerGiveSWEP(ply, class, info)
    if not ply:IsAdmin() then
        return false
    end
    return true
end

function GM:PlayerSpawnEffect(ply, model)
    if not ply:IsAdmin() then
        return false
    end
    return true
end

function GM:PlayerSpawnVehicle(ply, model, class, info)
    if not ply:IsAdmin() then
        return false
    end
    return true
end

function GM:PlayerSpawnedVehicle(ply, ent)
    if not ply:IsAdmin() then
        return false
    end
    return true
end

function GM:PlayerSpawnNPC(ply, type, weapon)
    if not ply:IsAdmin() then
        return false
    end
    return true
end
function GM:PlayerSpawnedNPC(ply, ent)
    if not ply:IsAdmin() then
        return false
    end
    return true
end

function GM:PlayerSpawnRagdoll(ply, model)
    if not ply:IsAdmin() then
        return false
    end
    return true
end

function GM:PlayerSpawnedRagdoll(ply, model, ent)
    if not ply:IsAdmin() then
        return false
    end
    return true
end