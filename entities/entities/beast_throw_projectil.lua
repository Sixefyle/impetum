AddCSLuaFile()
ENT.Type = "anim"
ENT.Spawnable = false

function ENT:Initialize()
    self:SetHealth(3)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        --phys:Wake()
        phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
    end
    --self:SetCustomCollisionCheck(true)

    if SERVER then
        self:SetTrigger(true)
    end
end

function ENT:OnTakeDamage(damage)
    return
end

function ENT:StartTouch(ent)
    if IsValid(ent) and ent ~= self:GetOwner() then
        self:SetHealth(self:Health() - 1)
        ent:TakeDamage(40, self:GetOwner(), self)
    end
end

function GAMEMODE:ShouldCollide( ent1, ent2 )
    -- if (not IsValid(ent1) or not IsValid(ent2)) then return true end

    -- if (ent1:GetClass() == "beast_throw_projectil" and  ent1:GetClass() == ent2:GetClass()) then
    --     return false
    -- end
    -- return true
end
--ParticleEffect("generic_smoke", self:GetPos(), self:GetAngles())