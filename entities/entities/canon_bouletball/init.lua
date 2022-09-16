AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_phx/misc/smallcannonball.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    
    local phys = self:GetPhysicsObject()
    if (IsValid(phys)) then
        phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
    end
end

function ENT:PhysicsCollide(data, physobj)
    if data.HitEntity:IsPlayer() or data.HitEntity:IsNPC() then
        local effectdata = EffectData()
        effectdata:SetStart(data.HitPos)
        effectdata:SetOrigin(data.HitPos)
        effectdata:SetScale(1)
        util.Effect("BloodImpact", effectdata)
    elseif data.HitEntity:GetClass() == "func_breakable" then
        GST_SNK.Utils:BreakNextBuildState(data.HitEntity:GetName())
    end
    
    local effectdata = EffectData()
    effectdata:SetStart(data.HitPos)
    effectdata:SetOrigin(data.HitPos)
    self:Remove()
    util.Effect("Explosion", effectdata)

    for _, ent in pairs(ents.FindInSphere(data.HitPos, 200)) do
        if IsValid(ent) and (ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot()) then
            local isTitan = string.match(ent:GetModel(), "titan")
            local damage = 57

            if isTitan then
                damage = 750
            end

            ent:TakeDamage(damage, self:GetOwner(), self)
        end
    end
end