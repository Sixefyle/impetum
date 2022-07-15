AddCSLuaFile()
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

ENT.MaxProgression = 100
ENT.Progression = 100
ENT.Range = 1500
ENT.PlayersInRange = {}

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

    if SERVER then
        self:Fire("setanimation","Idle",.1)
    end

    -- for i = 1, self:GetBoneCount() do
    --     print(i, self:GetBoneName(i))
    -- end

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

function ENT:CanTakeCapturePoint()
    local canTakePoint = true
    local teamsInside = {}

    for _, ply in pairs(self.PlayersInRange) do
        if (not table.HasValue(teamsInside, ply:GetTeam())) then
            table.insert(teamsInside, ply:GetTeam())
            if (#teamsInside > 1) then
                return
            end
        end

        if ((self.OwnerTeam and ply:GetTeam() == self.OwnerTeam) or not table.HasValue({GST_SNK.Teams.Eldien, GST_SNK.Teams.Mahr}, ply:GetTeam())) then
            canTakePoint = false
        end
    end

    if self.PlayersInRange[1] == nil or not canTakePoint then
        self:SlowResetCapturePoint()

        return
    end

    local currentTeam
    for _, currentPlayer in pairs(self.PlayersInRange) do
        if currentTeam and currentTeam ~= currentPlayer:GetTeam() then
            return false
        else
            currentTeam = currentPlayer:GetTeam()
        end
    end

    return true
end

function ENT:SlowResetCapturePoint()
    self.Progression = math.Clamp(self.Progression + .6, 0, self.MaxProgression)

    if SERVER then
        self:ManipulateBonePosition(4, Vector(0, 0, 120 - (self.MaxProgression - self.Progression) * 2.4), true)
    end
end

function ENT:TakeCapturePoint()

    -- 22 ticks/sec
    -- 10 sec
    -- 100%
    -- 100 / (22 * 10) 
    self.Progression = math.Clamp(self.Progression - 0.6, 0, self.MaxProgression) -- 60sec pour remonter

    if SERVER then
        self:ManipulateBonePosition(4, Vector(0, 0, 120 + (self.MaxProgression - self.Progression) * -2.4), true)
    end

    if self.Progression <= 0 then
        local newTeam = self.PlayersInRange[1]:GetTeam()
        self.OwnerTeam = newTeam
        self:SetSkin(self.State[newTeam.name])

        if SERVER then
            for _, ply in pairs(self.PlayersInRange) do
                if (IsValid(ply) and ply:IsPlayer()) then
                    ply:AddPoints(GAMEMODE.Rewards.CaptureFlag)
                end
            end
        end

        if CLIENT then
            LocalPlayer().flagsColor[self:GetNWInt("captureFlagIndex")] = newTeam.color
        end
    end
end

hook.Add("PostDrawTranslucentRenderables", "ShowCapturePoint", function()
    render.SetColorMaterial()
    local wideSteps = 100
    local tallSteps = 100
    local capturesPoints = ents.FindByClass("capture_point")

    for _, point in pairs(capturesPoints) do
        render.DrawSphere(point:GetPos(), point.Range, wideSteps, tallSteps, Color(255, 255, 255, 10))
        render.DrawBeam(point:GetPos(), point:GetPos() + Vector(0, 0, 99999), 10, 0, 1, LocalPlayer().flagsColor[point:GetNWInt("captureFlagIndex")])
    end
end)