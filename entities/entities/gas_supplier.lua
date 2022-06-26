AddCSLuaFile()
ENT.Type = "anim"
ENT.ClassName = "gas_supplier_ent"

function ENT:Initialize()
    self:SetModel("models/props_c17/furnitureStove001a.mdl")

    local supplier = self
    timer.Create(self:EntIndex() .. "RegenGas", .3, 0, function()
        if (IsValid(self)) then
            self:GiveGasToNearbyPlayers()
        else
            timer.Remove(supplier:EntIndex() .. "RegenGas")
        end
    end)
end

function ENT:GiveGasToNearbyPlayers() -- TODO Show gas zone
    for _, ply in pairs(ents.FindInSphere(self:GetPos(), 300)) do
        local weap = ply:GetWeapon("gst_3dmg")
        weap.Gas = math.Clamp(weap.Gas + weap.MaxGasRegen, 0, weap.MaxGas)
    end
end