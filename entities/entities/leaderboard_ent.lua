AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.PrintName = "Leaderboard"
ENT.Category = "GST"

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(MOVETYPE_VPHYSICS)
        local phys = self:GetPhysicsObject()

        if IsValid(phys) then
            phys:EnableMotion(false)
            phys:Wake()
        end

        self:DrawShadow(false)
    end
end

local scoreInfo = {
    Kill = {
        name = "Victimes",
        color = Color(255, 0, 0),
        colorBox = Color(194,75,75),
        suffix = " Kills"
    },
    Death = {
        name = "Morts",
        colorBox = Color(194,75,75),
    },
    Lose = {
        name = "Défaites",
        colorBox = Color(194,75,75),
    },
    KilledTitan = {
        name = "Titan tués",
        colorBox = Color(194,75,75),
    },
    Win = {
        name = "Victoires",
        colorBox = Color(75,194,101),
    },
    Draw = {
        name = "Egalités",
        colorBox = Color(128,128,128),
    },
    TimePlayed = {
        name = "Temps de jeu",
        colorBox = Color(128,128,128),
    },
    CapturedPoint = {
        name = "Points capturés",
        colorBox = Color(75,176,194),
    },
    GasComsumed = {
        name = "Gas utilisés",
        colorBox = Color(207,159,0),
    },
    ShotFired = {
        name = "Tirs tirés",
        colorBox = Color(207,159,0),
    },
    ShotHit = {
        name = "Tirs touchés",
        colorBox = Color(207,159,0),
    },
    CanonBallFired = {
        name = "Boulets tirés",
        colorBox = Color(207,159,0),
    },
}

local topColor = {
    [1] = Color(255,215,0, 200),
    [2] = Color(201,201,201, 200),
    [3] = Color(163,125,53, 200)
}

local function DrawScore(playerName, position, score, suffix, x, y)
    surface.SetFont("default_leaderboard_text")
    local w, h = surface.GetTextSize(score .. suffix)

    draw.RoundedBox(100, x + 280, y, w + 40, h, topColor[position] and topColor[position] or Color(0,0,0,0))
    draw.DrawText(playerName, "default_leaderboard_text", x + 200, y, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
    draw.DrawText(score .. suffix, "default_leaderboard_text", x + 300, y, Color(71, 68, 68), TEXT_ALIGN_LEFT)
end

local function DrawTop(stat, scores, x, y)
    surface.SetFont("default_leaderboard")
    local index = 0

    draw.RoundedBox(30, x - 720, y - 60, 1440, 250 + #scores * 160, scoreInfo[stat].colorBox)
    draw.DrawText(scoreInfo[stat].name, "default_leaderboard", x, y - 100, Color(255,255,255), TEXT_ALIGN_CENTER)
    if #scores <= 0 then
        draw.DrawText("Aucune donnée...", "default_leaderboard_text", x, y + 200, Color(194, 194, 194,100), TEXT_ALIGN_CENTER)
    end

    for _, score in pairs(scores) do
        DrawScore(score.last_seen_name, index + 1, score.count, "", x, y + 200 + (index * 150))
        index = index + 1
    end
end

function ENT:Draw()
    --self:DrawModel()
    --print(self:GetPos(), self:GetAngles())
    cam.Start3D2D(self:LocalToWorld(Vector(0,-80,40)), self:GetAngles() - Angle(0,-90,-90), 0.05)
    local index = 0
    
    if LocalPlayer().statsToShow then
        draw.DrawText("LEADERBOARD", "default_leaderboard", 1500, -500, Color(255,255,255), TEXT_ALIGN_CENTER)
        draw.RoundedBox(0, -600, -200, 4220, 20, Color(255,255,255))

        for statName, scores in pairs(LocalPlayer().statsToShow) do
            DrawTop(statName, scores, index % 3 * 1500, index >= 3 and 1200 or 0)
            index = index + 1
        end
    end
    cam.End3D2D()
end

net.Receive("AOTA:TC:ReceivePlayersStats", function()
    local newLeaderboard = net.ReadBool()
    local statName = net.ReadString()
    local scoreTops = net.ReadTable()

    if newLeaderboard then
        LocalPlayer().statsToShow = {}
    end

    if LocalPlayer().statsToShow then
        LocalPlayer().statsToShow[statName] = scoreTops
    end
end)