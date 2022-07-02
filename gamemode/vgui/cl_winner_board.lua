net.Receive("ShowWinnerPanel", function()
    local winnerTeamId = net.ReadUInt(2)
    local bestPlayers = net.ReadTable()

    ShowWinnerBoard(GST_SNK:GetTeam(winnerTeamId), bestPlayers)
end)

function ShowWinnerBoard(winner, bestPlayers)
    if (LocalPlayer().winner_hud_base) then
        LocalPlayer().winner_hud_base:Remove()
    end

    if (LocalPlayer():GetTeam() == winner) then
        surface.PlaySound("music/sound_victory.mp3")
    else
        surface.PlaySound("music/sound_defeat.mp3")
    end

    LocalPlayer().winner_hud_base = vgui.Create("DPanel")
    LocalPlayer().winner_hud_base:SetSize(ScrW() - 400, ScrH())
    LocalPlayer().winner_hud_base:CenterHorizontal()
    LocalPlayer().winner_hud_base:SetBackgroundColor(Color(255,0,0, 0))
    LocalPlayer().winner_hud_base:SetAlpha(0)

    LocalPlayer().winner_hud_base.Paint = function(self, w, h)
        Derma_DrawBackgroundBlur( self, SysTime() - 100 )
    end

    local fraction = 0
    timer.Create("bestAlpha", 0, 100, function()
        LocalPlayer().winner_hud_base:SetAlpha(math.ease.InQuart(fraction) * 255)
        fraction = fraction + .1
    end)

    local time_before_next_game = vgui.Create("DLabel", LocalPlayer().winner_hud_base)
    time_before_next_game:SetPos(0, 20)
    time_before_next_game:CenterHorizontal()
    time_before_next_game:SetSize(200,100)
    time_before_next_game:SetFont("default_snk")
    time_before_next_game:SetTextColor(Color(255,255,255))

    local timeLeft = 15
    time_before_next_game:SetText(timeLeft)
    timer.Create("UpdateTimer", 1, 15, function()
        timeLeft = timeLeft - 1
        time_before_next_game:SetText(timeLeft)
    end)

    local teams_score = vgui.Create("DPanel", LocalPlayer().winner_hud_base)
    teams_score:SetPos(0, 150)
    teams_score:SetSize(300,100)
    teams_score:CenterHorizontal()

    teams_score.Paint = function(panel, w, h)
        draw.SimpleText(GAMEMODE.EldienPoints, "default_snk_xl", 115, h / 2, GAMEMODE.EldienPoints > GAMEMODE.PointsToWin and Color(36,241,28) or Color(197,58,58), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        draw.SimpleText(" - ", "default_snk_xl",  w / 2 - 15, h / 2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(GAMEMODE.MahrPoints, "default_snk_xl", 155, h / 2, GAMEMODE.MahrPoints > GAMEMODE.PointsToWin and Color(36,241,28) or Color(197,58,58), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local winner_image = vgui.Create("DImage", LocalPlayer().winner_hud_base)
    winner_image:Dock(FILL)
    winner_image:DockMargin(200, 40, 200, 500)
    winner_image:SetImage(GST_SNK.Images["WINNER_HUD_" .. string.upper(winner.name)])

    local best_player_title = vgui.Create("DPanel", LocalPlayer().winner_hud_base)
    best_player_title:SetPos(0, 550)
    best_player_title:SetSize(400, 200)
    best_player_title:CenterHorizontal()
    best_player_title:SetAlpha(0)

    best_player_title.Paint = function(self, w, h)
        draw.SimpleText(bestPlayers[1].name, "default_snk", w / 2, h / 2, Color(255,215,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(string.Comma(bestPlayers[1].points) .. " Points", "default_snk_large", w / 2, h / 2 + 60, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local second_player_title
    if (bestPlayers[2]) then
        second_player_title = vgui.Create("DPanel", LocalPlayer().winner_hud_base)
        second_player_title:SetPos(350, 750)
        second_player_title:SetSize(400, 200)
        second_player_title:SetAlpha(0)

        second_player_title.Paint = function(self, w, h)
            draw.SimpleText(bestPlayers[2].name, "default_snk", w / 2, h / 2, Color(201,201,201), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(string.Comma(bestPlayers[2].points) .. " Points", "default_snk_large", w / 2, h / 2 + 60, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local third_player_title
    if (bestPlayers[3]) then
        third_player_title = vgui.Create("DPanel", LocalPlayer().winner_hud_base)
        third_player_title:SetPos(750, 750)
        third_player_title:SetSize(400, 200)
        third_player_title:SetAlpha(0)

        third_player_title.Paint = function(self, w, h)
            draw.SimpleText(bestPlayers[3].name, "default_snk", w / 2, h / 2, Color(163,125,53), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(string.Comma(bestPlayers[3].points) .. " Points", "default_snk_large", w / 2, h / 2 + 60, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end


    timer.Simple(2, function()
        local fraction = 0
        timer.Create("bestAlpha", 0, 50, function()
            best_player_title:SetAlpha(math.ease.InQuart(fraction) * 255)
            fraction = fraction + .2
        end)

        if (second_player_title) then
            timer.Simple(2, function()
                fraction = 0
                timer.Create("bestAlpha", 0, 50, function()
                    second_player_title:SetAlpha(math.ease.InQuart(fraction) * 255)
                    fraction = fraction + .2
                end)

                if (third_player_title) then
                    timer.Simple(2, function()
                        fraction = 0
                        timer.Create("bestAlpha", 0, 50, function()
                            third_player_title:SetAlpha(math.ease.InQuart(fraction) * 255)
                            fraction = fraction + .2
                        end)
                    end)
                end
            end)
        end
    end)
end

concommand.Add("show_winner_hud", function()
    GAMEMODE.MahrPoints = 0
    GAMEMODE.EldienPoints = 450
    ShowWinnerBoard(GST_SNK.Teams.Mahr, {
        [1] = {["name"] = "Dave Leauper", ["points"] = 745152247412},
        [2] = {["name"] = "Green", ["points"] = 14574},
        [3] = {["name"] = "Kamiko", ["points"] = -7},
    })
end)