AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Canon"
ENT.Author = "Mouloud modifié par Sixefyle"
ENT.Category = "GST"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.NextAttack = CurTime()
ENT.MaxAngleDelta = 60
ENT.AttackSpeed = .5

if CLIENT then
    function ENT:Think()
        if (self:GetNWBool("IsUsed") and LocalPlayer() == self:GetOwner()) then
            local ang = LocalPlayer():GetAimVector():Angle()
            local yAngDiff = math.AngleDifference(self:GetParent():LocalToWorldAngles(Angle(0,0,0)).y, ang.y) -- droite/gauche

            if yAngDiff < self.MaxAngleDelta and yAngDiff > -self.MaxAngleDelta then
                self:SetAngles(ang)
                self.oldRotation = ang.y
            else
                ang.y = self.oldRotation
                self:SetAngles(ang)
            end
            net.Start("GetCanonRotation")
                net.WriteEntity(self)
                net.WriteAngle(ang)
            net.SendToServer()
        end
    end
end

if SERVER then
    util.AddNetworkString("SendCanon::Info")
    util.AddNetworkString("SendCanon::Info2")
    util.AddNetworkString("WeaponCooldownStart")
    util.AddNetworkString("GetCanonRotation")

    net.Receive("GetCanonRotation", function(len, ply)
        local ent = net.ReadEntity()
        local ang = net.ReadAngle()

        if (type(ent) == "Entity" and IsValid(ent) and type(ang) == "Angle") then
            ent:SetNWAngle("CanonAngle", ang)
        end
    end)

    function ENT:Initialize()
        self:SetModel("models/models/gst/canon.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)

        for _, value in pairs({0,1,2,3,4,5,7,8,12,13,14,15,16,17,18}) do
            self:ManipulateBoneScale(value, Vector(0.01, 0.01, 0.01))
        end

        self:SetUseType(SIMPLE_USE)
        self:SetSolid(SOLID_NONE)
        --self:SetNWAngle("DefaultAngle", self:GetAngles())
    end

    function ENT:Use(ply)
        if not IsValid(self.owner) then
            self:ActiveCanon(ply)
        end
    end

    function ENT:ActiveCanon(ply)
        if (self:GetNWBool("IsUsed")) then return end

        local weap = ply:GetActiveWeapon()
        weap:SetNextPrimaryFire(CurTime() + 9999)
        weap:SetNextSecondaryFire(CurTime() + 9999)

        self:SetOwner(ply)
        self:GetOwner():SetMoveType(MOVETYPE_NONE)
        net.Start("SendCanon::Info")
            net.WriteEntity(self)
        net.Send(ply)

        self:SetNWBool("IsUsed", true)
        --self:SetNWAngle("DefaultAngle", self:GetAngles())

        timer.Create("UpdateCanonAngle" .. self:EntIndex(), .1, 0, function()
            if (IsValid(self) and IsValid(self:GetOwner()) and self:GetOwner():IsPlayer()) then
                self:SetAngles(LerpAngle(FrameTime() * 10, self:GetAngles(), self:GetNWAngle("CanonAngle")))
            end
        end)
    end

    function ENT:DeactivateCanon()
        local owner = self:GetOwner()
        self:SetAngles(self:GetParent():LocalToWorldAngles(Angle(0,0,0)))

        if IsValid(owner) then
            owner:SetMoveType(MOVETYPE_WALK)

            local weap = owner:GetActiveWeapon()
            if (IsValid(weap)) then
                weap:SetNextPrimaryFire(CurTime())
                weap:SetNextSecondaryFire(CurTime()) 
            end


            net.Start("SendCanon::Info2")
            net.Send(self:GetOwner())

            self:SetOwner(self:GetParent())
            owner:SetParent()

            self:SetNWBool("IsUsed", false)
            timer.Remove("UpdateCanonAngle" .. self:EntIndex())
        end
    end

    function ENT:OnRemove()
        local owner = self:GetOwner()
        if (IsValid(owner) and owner:IsPlayer()) then
            self:DeactivateCanon()
        end
    end

    function ENT:Think()
        local owner = self:GetOwner()
        if (IsValid(owner) and owner:IsPlayer() and not owner:Alive()) then
            self:DeactivateCanon()
            return
        end

        if IsValid(owner) and owner:IsPlayer() and owner:Alive() then
            local ownerpos = owner:GetPos()
            local cannonpos = self:GetPos()

            if owner:KeyDown(IN_USE) then
                self:DeactivateCanon()
                return
            end

            if self.NextAttack < CurTime() and (self:WaterLevel() ~= 3) and owner:KeyDown(IN_ATTACK) then
                self:EmitShootEffects()
                self:EmitSound("weapons/fk96/FK96ShootInst.wav")

                local ball = ents.Create("canon_bouletball")
                ball:SetPos(self:GetPos() + self:GetForward() * 30 + self:GetUp() * 50)
                ball:SetAngles(self:GetAngles())
                ball:SetOwner(owner)
                ball:Spawn()
                ball:Activate()
                ball:GetPhysicsObject():SetVelocity(self:GetForward() * 8000)
                self.NextAttack = CurTime() + (1 / self.AttackSpeed)

                owner:AddPlayerStats(GST_SNK.AvailableStats.CanonBallFired)

                net.Start("WeaponCooldownStart")
                    net.WriteDouble(self.NextAttack)
                net.Send(owner)
            end
        end
    end
end

if CLIENT then
    net.Receive("SendCanon::Info", function()
        LocalPlayer():ShowWeaponCooldownBar(true)

        local ent = net.ReadEntity()

        hook.Add("CalcView", "CalcCanonInfo", function(ply, pos, angles, fov)
            if (not IsValid(ent)) then
                LocalPlayer():ShowWeaponCooldownBar(false)
                hook.Remove("CalcView", "CalcCanonInfo")
                return
            end

            local view = {
                origin = ent:GetPos() + ent:GetUp() * 100 + ent:GetForward() * -30,
                --angles = LocalPlayer():GetAngles(),
                fov = fov,
                drawviewer = false,
            }

            return view
        end)
    end)

    net.Receive("SendCanon::Info2", function()
        LocalPlayer():ShowWeaponCooldownBar(false)
        hook.Remove("CalcView", "CalcCanonInfo")
    end)
end

function ENT:EmitShootEffects()
    local Effect = EffectData()
    Effect:SetOrigin(self:LocalToWorld(Vector(100, -0, 0)))
    Effect:SetStart(self:GetForward() * 850 * 1.4)
    util.Effect("helicoptermegabomb", Effect, true, true)
    util.ScreenShake(self:GetPos(), 20, 4, math.Rand(0.5, 0.8), 320)
end