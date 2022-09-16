AddCSLuaFile()
ENT.Type = "anim"
ENT.ClassName = "gas_supplier_ent"

function ENT:Initialize()
    self:SetModel("models/gst/gaz2.mdl")

    if (SERVER) then
        local supplier = self
        timer.Create(self:EntIndex() .. "RegenGas", .5, 0, function()
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
            if (ent:IsPlayer() and ent:GetTeam() == self:GetOwner():GetTeam()) then
                local weap = ent:GetWeapon("gst_3dmg")
                if (IsValid(weap)) then
                    weap:ChangeGas((weap:GetNWInt("MaxGas") / 100) * 5, 0, weap:GetNWInt("MaxGas"))
                end
            end
        end
    end
end
