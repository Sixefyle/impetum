AddCSLuaFile()
--ENT.Base = "base_nextbot"
ENT.Type = "anim"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.PrintName = "Selecteur de classe"
ENT.Category = "GST"

function ENT:Initialize()
    self:SetModel("models/hydralis/kaouet/soldat_masculin/garnison/soldat_masculin_garnison_2.mdl")

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:ResetSequence("lineidle0"..math.random(1,4))
    

    local phys = self:GetPhysicsObject()
    if (IsValid(phys)) then
        phys:EnableMotion(false)
    end

    
end

function ENT:Use(activator, caller)
    if (IsValid(activator)) then
        activator:ConCommand("team_menu")
    end
end

-- function ENT:RunBehaviour()
-- 	while (true) do
--         self:StartActivity(ACT_BUSY_QUEUE)
--         coroutine.wait(20)
--     end
-- end