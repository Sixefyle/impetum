SWEP.PrintName = "Titan Crawler"
SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = ""
SWEP.Base = "titan_base"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 75
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = true
SWEP.DrawAmmo = false
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.HoldType = "normal"
SWEP.DrawCrosshair = true
SWEP.Weight = 0
SWEP.Category = "GST"
SWEP.FiresUnderwater = false
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.NextReload = 0

SWEP.BaseHeight = 4
SWEP.HumanBaseHeight = 1.8
SWEP.AttackSpeed = 1
SWEP.SpeedIncrease = 1.4
SWEP.GrabDelay = 5

-- hook.Add( "PlayerFootstep", "TitanFootStep", function( ply, pos, foot, sound, volume, rf )
-- 	if (ply:GetTeam() == GST_SNK.Teams.Titan) then
--         ply:EmitSound( "gst/titan_footstep.wav" ) -- Play the footsteps hunter is using
--         return true -- Don't allow default footsteps, or other addon footsteps
--     end
-- end)

function SWEP:Initialize()
    self.TitanModel = {
        "models/gst/titan_crawler_1.mdl",
        "models/gst/titan_crawler_2.mdl",
        "models/gst/titan_crawler_3.mdl",
        "models/gst/titan_crawler_4.mdl",
        "models/gst/titan_crawler_5.mdl",
        "models/gst/titan_crawler_6.mdl",
        "models/gst/titan_crawler_7.mdl",
    }

    self:GetOwner().WalkAct = ACT_MP_RUN
end

function SWEP:Deploy()
    local owner = self:GetOwner()
    owner.WalkAct = ACT_MP_RUN
    local realSize = owner:GetCurrentClass().size and owner:GetCurrentClass().size or self.BaseHeight
    self:SetNWInt("Size", realSize / self.HumanBaseHeight)
    self:SetHoldType(self.HoldType)
    owner:SetModel(table.Random(self.TitanModel))
    owner:SetModelScale(self:GetNWInt("Size"), 1)
    timer.Simple(.1, function()
        owner:SetBodygroup(1, math.random(0, 13))
        owner:SetSkin(math.random(0, 5))
    end)
    owner:SetViewOffset(Vector(0, 0, 64 * self:GetNWInt("Size")))
    owner:Activate()

    if CLIENT then
        LocalPlayer():ShowWeaponCooldownBar(true)
    else
        timer.Create("UpdateBonAngle" .. owner:EntIndex(), 0, .1, function()
            if IsValid(owner) then
                local angle = owner:EyeAngles()
                --owner:ManipulateBoneAngles(owner:LookupBone("mixamorig:Spine"), Angle(0, 0, math.Clamp(angle[1], -80, 60)))
            end
        end)

        owner:SetJumpPower(0)
    end
end

function SWEP:Holster()
    if CLIENT then
        LocalPlayer():ShowWeaponCooldownBar(false)
    end
end

function SWEP:SetNextReload(time)
    self.NextReload = time
end

function SWEP:CanReload()
    return CurTime() > self.NextReload
end

function SWEP:GrabPlayer(ply)
    if IsValid(ply) then
        ply:Freeze(true)
        GST_SNK.Utils:RunAnimation("grab_crawl_player_idle", self:GetOwner())
        local _, eatAnimTime = self:GetOwner():LookupSequence("grab_crawl_player_idle")
        self:SetNextPrimaryFire(CurTime() + eatAnimTime)
        self:SetNextSecondaryFire(CurTime() + eatAnimTime)

        timer.Create("grabPlayer" .. self:EntIndex(), 0, 0, function()
            if (IsValid(self) and IsValid(ply) and ply:Alive()) then
                local handPos = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("mixamorig:LeftHandThumb2"))
                handPos = LerpVector(FrameTime() * 0.01, self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("mixamorig:LeftHandThumb2")) + Vector(0,0, -50), handPos )
                ply:SetPos(handPos)
            else
                timer.Remove("grabPlayer" .. self:EntIndex())
            end
        end)

        timer.Simple(eatAnimTime - 1, function()
            timer.Remove("grabPlayer" .. self:EntIndex())
            ply:TakeDamage(9999, self:GetOwner(), self)
            self:GetOwner():Freeze(false)
            ply:Freeze(false)
        end)
    end
end

function SWEP:Reload()
    if IsFirstTimePredicted() and self:CanReload() then
        local _, animTime = self:GetOwner():LookupSequence("grab_player")

        if SERVER then
            GST_SNK.Utils:RunAnimation("grab_player", self:GetOwner(), true)

            timer.Create("checkNearbyPlayer" .. self:EntIndex(), .1, animTime * 10, function()
                if (IsValid(self) and IsValid(self:GetOwner())) then
                    local handPos = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("mixamorig:LeftHandThumb2"))

                    -- Check nearby player from the hand and grab them
                    for _, ply in pairs(ents.FindInSphere(handPos, 80)) do
                        if IsValid(ply) and ply:IsPlayer() and ply:Alive() and ply ~= self:GetOwner() and
                        table.HasValue({GST_SNK.Teams.Eldien, GST_SNK.Teams.Mahr}, ply:GetTeam()) then
                            self:GrabPlayer(ply)
                            timer.Remove("checkNearbyPlayer" .. self:EntIndex())
                        end
                    end
                end
            end)
        else
            self:GetOwner():WeaponCooldownBar(CurTime() + animTime + self.GrabDelay)
        end
        self:SetNextReload(CurTime() + animTime + self.GrabDelay)
    end
end


function SWEP:SecondaryAttack()

end

function SWEP:PrimaryAttack()

end