AddCSLuaFile()
ENT.Type = "anim"
ENT.ClassName = "gas_supplier_ent"

function ENT:Initialize()
    print("test")
    self:SetModel("models/props_c17/furnitureStove001a.mdl")

    if (SERVER) then
        local supplier = self
        timer.Create(self:EntIndex() .. "RegenGas", .1, 0, function()
            if (IsValid(self)) then 
                self:GiveGasToNearbyPlayers()
            else
                timer.Remove(supplier:EntIndex() .. "RegenGas")
            end
        end)
    end
end

function ENT:GiveGasToNearbyPlayers() -- TODO Show gas zone
    if SERVER then
        for _, ent in pairs(ents.FindInSphere(self:GetPos(), 300)) do
            if (ent:IsPlayer()) then
                local weap = ent:GetWeapon("gst_3dmg")
                weap:ChangeGas(weap:GetNWInt("MaxGas") / 100, 0, weap:GetNWInt("MaxGas"))
            end
        end
    end
end
