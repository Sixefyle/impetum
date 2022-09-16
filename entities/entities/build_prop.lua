AddCSLuaFile()
ENT.Type = "anim"
ENT.Spawnable = false
ENT.ClassName = "build_prop"

function ENT:Initialize()
    self:SetHealth(3)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    -- local phys = self:GetPhysicsObject()
    -- if (phys:IsValid()) then
    -- 	phys:Wake()
    -- end
end

function ENT:OnTakeDamage(damage)
    self:SetHealth(self:Health() - 1)

    if self:Health() <= 0 then
        self:Remove()
    end
end

function ENT:OnRemove()
    ParticleEffect("generic_smoke", self:GetPos(), self:GetAngles())
end