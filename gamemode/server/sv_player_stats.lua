GST_SNK.AvailableStats = {
    Kill = "Kill", --
    Death = "Death", --
    Win = "Win", --
    Lose = "Lose", --
    Draw = "Draw", --
    CapturedPoint = "CapturedPoint", --
    GasComsumed = "GasComsumed", --
    ShotFired = "ShotFired", --
    ShotHit = "ShotHit", --
    TimePlayed = "TimePlayed",
    KilledTitan = "KilledTitan", --
    CanonBallFired = "CanonBallFired" --
}

util.AddNetworkString("AOTA:TC:ReceivePlayersStats")

function GST_SNK:InitLeaderBoard()
    local oldStats = {}
    local newStats = {}
    local stat

    timer.Create("RefreshLeaderboard", 15, 0, function()
        oldStats = newStats
        newStats = {}
        while (#newStats < 6) do
            stat = table.Random(GST_SNK.AvailableStats)
            if not table.HasValue(oldStats, stat) and not table.HasValue(newStats, stat) then
                table.insert(newStats, stat)
            end
        end

        oldStats = {}
        self:SendTopStatsToPlayers(newStats)
    end)
end

function GST_SNK:SendTopStatsToPlayers(stats, amount)
    local index = 1
    for _, stat in pairs(stats) do
        GST_DB:GetTopStats(stat, amount, function(topTable)
            for _, ply in pairs(player.GetAll()) do
                if ply:GetTeam() == GST_SNK.Teams.NoTeam then
                    net.Start("AOTA:TC:ReceivePlayersStats")
                        net.WriteBool(index == 1)
                        net.WriteString(stat)
                        net.WriteTable(topTable)
                    net.Send(ply)
                end
            end
            index = index + 1
        end)
    end
end

local ply = FindMetaTable("Player")

function ply:AddPlayerStats(stat, amount)
    amount = amount or 1

    GST_DB:AddPlayerStats(self, stat, amount)
end

concommand.Add("refresh_leaderboard_timer", function()
    GST_SNK:InitLeaderBoard()
end)