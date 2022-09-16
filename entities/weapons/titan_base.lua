SWEP.PrintName = "Titan"
SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = ""
SWEP.Base = "weapon_base"
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
SWEP.TitanModel = {
    "models/gst/titan_1.mdl",
    "models/gst/titan_2.mdl",
    "models/gst/titan_3.mdl",
    "models/gst/titan_4.mdl",
    "models/gst/titan_5.mdl",
    "models/gst/titan_6.mdl",
    "models/gst/titan_7.mdl",
}
SWEP.BaseHeight = 7
SWEP.HumanBaseHeight = 1.8
SWEP.AttackSpeed = 1
SWEP.SpeedIncrease = 1.4
SWEP.GrabDelay = 5

-- if CLIENT then
--     function SWEP:Think()
--         local angle = LocalPlayer():EyeAngles()
--         LocalPlayer():ManipulateBoneAngles(LocalPlayer():LookupBone("mixamorig:Spine"), Angle(0,0, math.Clamp(angle[1], -80, 100)))
--     end
-- end
hook.Add( "PlayerFootstep", "TitanFootStep", function( ply, pos, foot, sound, volume, rf )
	if (ply:GetTeam() and ply:GetTeam().name == "Titan") then
        ply:EmitSound( "gst/titan_footstep.wav" ) -- Play the footsteps hunter is using
        return true -- Don't allow default footsteps, or other addon footsteps
    end
end )

function SWEP:Initialize()
    local owner = self:GetOwner()
    owner.WalkAct = table.Random({ACT_MP_RUN, ACT_WALK_RELAXED})
    owner.RunAct = table.Random({ACT_MP_RUN, ACT_RUN_RELAXED})
end

function SWEP:Deploy()
    local owner = self:GetOwner()
    owner.WalkAct = table.Random({ACT_MP_RUN, ACT_WALK_RELAXED})
    owner.RunAct = table.Random({ACT_MP_RUN, ACT_RUN_RELAXED})

    local realSize = owner:GetCurrentClass().size and owner:GetCurrentClass().size or self.BaseHeight
    self:SetNWInt("Size", realSize / self.HumanBaseHeight)
    self:SetHoldType(self.HoldType)
    owner:SetModel(table.Random(self.TitanModel))
    timer.Simple(.1, function()
        owner:SetBodygroup(1, math.random(0, 13))
        owner:SetSkin(math.random(0, 5))
    end)
    owner:SetModelScale(self:GetNWInt("Size"), 1)
    owner:SetViewOffset(Vector(0, 0, 64 * self:GetNWInt("Size")))
    owner:Activate()

    if CLIENT then
        LocalPlayer():ShowWeaponCooldownBar(true)
        self.PrintName = "Titan " .. self:GetOwner():GetCurrentClass().size and self:GetOwner():GetCurrentClass().size or self.BaseHeight .. " mètres"
    else
        timer.Create("UpdateBonAngle" .. owner:EntIndex(), 0, .1, function()
            if IsValid(owner) then
                local angle = owner:EyeAngles()
                owner:ManipulateBoneAngles(owner:LookupBone("mixamorig:Spine"), Angle(0, 0, math.Clamp(angle[1], -80, 60)))
            end
        end)
    end

    self:GetOwner():SetNoTarget(true)
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
        GST_SNK.Utils:RunAnimation("grab_player_manger", self:GetOwner())
        local _, eatAnimTime = self:GetOwner():LookupSequence("grab_player_manger")
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
                local handPos = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("mixamorig:LeftHandThumb2"))

                -- Check nearby player from the hand and grab them
                for _, ply in pairs(ents.FindInSphere(handPos, 80)) do
                    if IsValid(ply) and ply:IsPlayer() and ply:Alive() and ply ~= self:GetOwner() and
                    table.HasValue({GST_SNK.Teams.Eldien, GST_SNK.Teams.Mahr}, ply:GetTeam()) then
                        self:GrabPlayer(ply)
                        timer.Remove("checkNearbyPlayer" .. self:EntIndex())
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
    if IsFirstTimePredicted() and self:CanSecondaryAttack() then
        local owner = self:GetOwner()
        local _, animTime = self:GetOwner():LookupSequence("falling")

        if SERVER then
            owner:ManipulateBoneAngles(owner:LookupBone("mixamorig:Spine"), Angle(0, 0, 0))
            GST_SNK.Utils:RunAnimation("falling", owner, true)
            timer.Simple(1, function()
                local hullMin = self:LocalToWorld(Vector(owner:GetModelScale() * 30, owner:GetModelScale() * 15, -10))
                local hullMax = self:LocalToWorld(Vector(owner:GetModelScale() * -30, owner:GetModelScale() * -15, 30))
                for _, ent in pairs(ents.FindInBox(hullMin, hullMax)) do
                    if (ent:IsValid() and ent:IsPlayer()) then
                        ent:TakeDamage(9999, owner, self)
                    end
                end
            end)
        else
            owner:WeaponCooldownBar(CurTime() + animTime)
        end

        self:SetNextSecondaryFire(CurTime() + animTime)
    end
end

hook.Add( "PostDrawTranslucentRenderables", "test", function()
    -- render.SetColorMaterial()

    -- for _, ent in pairs(ents.FindByClass("vj_titan")) do
    --     render.DrawLine(LocalPlayer():GetPos(), ent:GetBonePosition(ent:LookupBone("mixamorig:Head")), Color(255,0,0), true)
    -- end

    -- local weap = LocalPlayer():GetActiveWeapon()
    -- local ang = LocalPlayer():EyeAngles()
    -- ang.x = 0

    -- for _, ent in pairs(ents.FindByClass("vj_titan")) do
    --     render.DrawWireframeBox(ent:GetPos(), ent:EyeAngles(),
    --     Vector(ent:GetModelScale() * 40, ent:GetModelScale() * 15,0), Vector(ent:GetModelScale() * -30, ent:GetModelScale() * -35, 60), Color(255,0,0), true)
    -- end

    -- render.DrawWireframeBox(LocalPlayer():GetPos(), ang,
    --     Vector(LocalPlayer():GetModelScale() * 30,LocalPlayer():GetModelScale() * 15,0), Vector(LocalPlayer():GetModelScale() * -30, LocalPlayer():GetModelScale() * -15,30), Color(255,0,0), true)
end)

if SERVER then
    function SWEP:Think()
        local owner = self:GetOwner()
        if (owner:GetVelocity():Length2DSqr() >= 100) then
            for _, ply in pairs(ents.FindInSphere(owner:GetPos(), 70)) do
                if (IsValid(ply) and ply:IsPlayer() and ply:Alive() and ply ~= owner and string.match(ply:GetModel(), "titan") ~= "titan") then
                    ply:TakeDamage(9999, owner, self)
                end
            end
        end
    end
end


function SWEP:PrimaryAttack()
    if IsFirstTimePredicted() and self:CanPrimaryAttack() then
        local animationName = "balayage"
        if self:GetOwner():EyeAngles()[1] >= 10 then
            animationName = "punch1"
        end
        _, animTime = self:GetOwner():LookupSequence(animationName)

        if SERVER then
            GST_SNK.Utils:RunAnimation(animationName, self:GetOwner(), true)
            local damagedPlayers = {}
            local buildDestroyed = false

            timer.Create("checkNearbyPlayer" .. self:EntIndex(), .1, animTime * 10, function()
                if timer.Exists("checkNearbyPlayer" .. self:EntIndex()) and timer.RepsLeft("checkNearbyPlayer" .. self:EntIndex()) <= animTime * 5 then
                    local handPos = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("mixamorig:RightHandPinky1"))

                    for _, ply in pairs(ents.FindInSphere(handPos, 80)) do
                        if IsValid(ply) and ply:IsPlayer() and not table.HasValue(damagedPlayers, ply) and ply ~= self:GetOwner() and ply:Alive() then
                            ply:TakeDamage(1000, self:GetOwner(), self)
                            table.insert(damagedPlayers, ply)
                        elseif not buildDestroyed then
                            local tr = util.TraceLine({
                                start = self:GetOwner():EyePos(),
                                endpos = self:GetOwner():GetPos() + self:GetOwner():GetAngles():Forward() * 250,
                                filter = function(ent) return ent ~= self:GetOwner() end
                            })

                            if IsValid(tr.Entity) then
                                GST_SNK.Utils:BreakNextBuildState(tr.Entity:GetName())
                                buildDestroyed = true
                            end
                        end
                    end
                end
            end)
        else
            self:GetOwner():WeaponCooldownBar(CurTime() + animTime)
        end

        self:SetNextPrimaryFire(CurTime() + animTime)
    end
end