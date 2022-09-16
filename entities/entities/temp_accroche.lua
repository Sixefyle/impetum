AddCSLuaFile()
ENT.Type = "anim"
ENT.Spawnable = true
ENT.ClassName = "temp_accroche"
ENT.PrintName = "accroche"

function ENT:Initialize()
	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
    self:SetModel("models/hunter/blocks/cube025x025x025.mdl")

    if SERVER then
        self:SetName("accroche")
    end
end

function ENT:Think()

    if (CLIENT) then
        if (LocalPlayer():IsAdmin()) then
            --self:SetSkin(0)
            self:SetNoDraw(false)
        else
            --self:SetSkin(1)
            self:SetNoDraw(true)
        end
    end
end

function ENT:OnTakeDamage(damage)
    return
end

function ENT:OnRemove()
end