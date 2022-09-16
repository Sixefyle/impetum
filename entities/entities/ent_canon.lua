AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Canon"
ENT.Author = "Mouloud modifié par Sixefyle"
ENT.Category = "GST"
ENT.Spawnable = true
ENT.AdminSpawnable = true

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/models/gst/canon.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(MOVETYPE_VPHYSICS)

        local phys = self:GetPhysicsObject()
        if (IsValid(phys)) then
            phys:EnableMotion(false)
        end

        for _, value in pairs({6,9,10,11}) do
            self:ManipulateBoneScale(value, Vector(0.01, 0.01, 0.01))
        end

        local cannon = ents.Create("ent_canon_barrel")
        cannon:SetPos(self:GetPos() + Vector(0, 0, 2))
        local cannonangle = self:GetAngles() + Angle(0, 0, 0)
        cannon:SetAngles(cannonangle)
        cannon:Spawn()
        cannon:SetParent(self)
        self.canon = cannon
        self:SetPos(self:GetPos() + Vector(0, 0, 50))

        self:SetHealth(5)
    end

    -- function ENT:SpawnFunction(ply, tr, ClassName)
    --     if not tr.Hit then return end
    --     local SpawnPos = tr.HitPos + tr.HitNormal * 16
    --     local ent = ents.Create(ClassName)
    --     ent:SetPos(SpawnPos)
    --     ent:Spawn()
    --     ent:Activate()

    --     return ent
    -- end

    function ENT:OnTakeDamage(dmgInfo)
        self:SetHealth(self:Health() - 1)
	
        local num = (255 / 5) * self:Health()
        self:SetColor(Color(num, num, num))
        
        if(self:Health() <= 0) then
            self:Remove()
        end
    end

    function ENT:Use(ply)
        local canon = self.canon

        if not IsValid(canon.owner) and (self.ActivateDelay == nil or CurTime() > self.ActivateDelay) then
            canon:ActiveCanon(ply)
            self.ActivateDelay = CurTime() + .5
        end
    end

    -- function ENT:StartTouch(ent)
    --     if not self.canon:GetNWBool("loaded", false) and ent:GetClass() == "psw_bouletball" then
    --         self.canon:SetNWBool("loaded", true)
    --         self.canon.NextAttack = CurTime() + 4
    --         self.canon:EmitSound("weapons/fk96/FK96ReloadInst.wav")
    --         ent:Remove()
    --     end
    -- end
end

if CLIENT then
    function ENT:Initialize()
        self.Color = Color(255, 255, 255)
    end
end