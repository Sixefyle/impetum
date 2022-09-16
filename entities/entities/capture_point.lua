AddCSLuaFile()
--ENT.Base = "base_nextbot"
--ENT.Base = "base_nextbot"
ENT.Type = "anim"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.PrintName = "Point de capture"
ENT.Category = "GST"

ENT.State = {
    ["Neutral"] = 3,
    ["Eldien"] = 4,
    ["Mahr"] = 0
}

ENT.StateColor = {
    [0] = GST_SNK.Teams.Mahr.color,
    [4] = GST_SNK.Teams.Eldien.color,
    [3] = Color(148,148,148)
}

ENT.StateColor = {
    [0] = GST_SNK.Teams.Mahr.color,
    [4] = GST_SNK.Teams.Eldien.color,
    [3] = Color(148,148,148)
}

ENT.MaxProgression = 100
ENT.Progression = 100
ENT.Range = 1500
ENT.PlayersInRange = {}

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/gst/flag_aot.mdl")
        self:SetSkin(self.State.Neutral)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
    
        self:ManipulateBonePosition(4, Vector(0, 0, 200), true)
    
        local phys = self:GetPhysicsObject()
        if (IsValid(phys)) then
            phys:EnableMotion(false)
        end
    
    
        local players = {}
        timer.Create("getAllNearEnts" .. self:EntIndex(), 0, 0, function()
            if not IsValid(self) then return end
    
            if not table.IsEmpty(self.PlayersInRange) then
                table.Empty(self.PlayersInRange)
            end
    
            for _, ent in pairs(ents.FindInSphere(self:GetPos(), self.Range)) do
                if IsValid(ent) and ent:IsPlayer() and ent:Alive() then
                    table.insert(players, ent)
                end
            end
    
            self.PlayersInRange = players
    
            if self:CanTakeCapturePoint() then
                self:TakeCapturePoint()
            end
        end)
    end
end

function ENT:CanTakeCapturePoint()
    local canTakePoint = true
    local teamsInside = {}

    for _, ply in pairs(self.PlayersInRange) do
        if table.HasValue({GST_SNK.Teams.Primordial, GST_SNK.Teams.Titan}, ply:GetTeam()) then continue end

        if not table.HasValue(teamsInside, ply:GetTeam()) then
            table.insert(teamsInside, ply:GetTeam())
            if (#teamsInside > 1) then
                return
            end
        end

        if self.OwnerTeam and ply:GetTeam() == self.OwnerTeam then
            canTakePoint = false
        end
    end

    if table.IsEmpty(teamsInside) or table.IsEmpty(teamsInside) or self.PlayersInRange[1] == nil or not canTakePoint then
        self:SlowResetCapturePoint()

        return
    end

    if self.teamTakingPoint ~= teamsInside[1] then
        self.teamTakingPoint = teamsInside[1]
    end
    return true
end

function ENT:SlowResetCapturePoint()
    self.Progression = math.Clamp(self.Progression + .3, 0, self.MaxProgression)

    if SERVER then
        self:ManipulateBonePosition(4, Vector(0, 0, 120 - (self.MaxProgression - self.Progression) * 2.4), true)
    end
end

function ENT:TakeCapturePoint()
    self.Progression = math.Clamp(self.Progression - 0.2, 0, self.MaxProgression) -- 60sec pour remonter

    if SERVER then
        self:ManipulateBonePosition(4, Vector(0, 0, 120 + (self.MaxProgression - self.Progression) * -2.4), true)
    end

    if self.Progression <= 0 then
        local newTeam = self.teamTakingPoint
        self.OwnerTeam = newTeam
        self:SetSkin(self.State[newTeam.name] or 3 or 3)

        if SERVER then
            for _, ply in pairs(self.PlayersInRange) do
                if (IsValid(ply) and ply:IsPlayer()) then
                    ply:AddPoints(GAMEMODE.Rewards.CaptureFlag)
                    ply:AddPlayerStats(GST_SNK.AvailableStats.CapturedPoint)

                    ply:AddClassExperience(ply:GetTeam().indexName, ply:GetCurrentClassName(), 33)
                end
            end
            GST_SNK.Utils:PlaySoundToAllPlayer(GST_SNK.Sounds.CAPTURE_POINT)

            net.Start("AOTA:TC:ReceiveNewCapturedPoint")
                net.WriteUInt(self:GetNWInt("captureFlagIndex"),2)
                net.WriteColor(newTeam.color)
            net.Broadcast()
        end
    end
end



hook.Add("PostDrawTranslucentRenderables", "ShowCapturePoint", function()
    render.SetColorMaterial()
    local wideSteps = 100
    local tallSteps = 100
    local capturesPoints = ents.FindByClass("capture_point")

    for _, point in pairs(capturesPoints) do
        local color = point.StateColor and point.StateColor[point:GetSkin()] or LocalPlayer().flagsColor[point:GetNWInt("captureFlagIndex")]
        render.DrawBeam(point:GetPos(), point:GetPos() + Vector(0, 0, 99999), 15, 0, 1, color)
        color.a = 30
        render.DrawSphere(point:GetPos(), point.Range, wideSteps, tallSteps, color)
        color.a = 100
    end
end)