hook.Add("PostDrawOpaqueRenderables", "DrawTeamMarker", function()
    local localPlayerTeam = LocalPlayer():GetTeam()
    for _, ply in pairs(player.GetAll()) do
        if (ply:IsEffectActive(EF_NODRAW)) then continue end
        if ply:GetPos():DistToSqr(LocalPlayer():GetPos()) >= 7200000 then continue end
        cam.Start3D2D(ply:EyePos() + ply:GetUp() * 15, Angle(0, LocalPlayer():EyeAngles().y - 90, 90), .1)

        if localPlayerTeam ~= GST_SNK.Teams.NoTeam and ply ~= LocalPlayer() and localPlayerTeam == ply:GetTeam() then
            --draw.DrawText(ply:GetName(), "gotham_24", 0, 0, LocalPlayer():GetTeam().color, TEXT_ALIGN_CENTER)
            draw.RoundedBox(100, -32.5, -32.5, 75, 75, localPlayerTeam.color)
        end

        cam.End3D2D()
    end
end)


hook.Add( "PreDrawHalos", "AddPropHalos", function()
    local plyToHaloedDraw = {}
    local localPlayerTeam = LocalPlayer():GetTeam()
    for _, ply in pairs(player.GetAll()) do
        if (localPlayerTeam ~= GST_SNK.Teams.NoTeam and localPlayerTeam == ply:GetTeam()) then
            table.insert(plyToHaloedDraw, ply)
        end
    end

    halo.Add(ents.FindByClass("class_selector_ent"), Color(30,255,218,200), 1, 1, 20 )

    if (not table.IsEmpty(plyToHaloedDraw) and localPlayerTeam) then
        halo.Add(plyToHaloedDraw, localPlayerTeam.color, 0, 0, 2 )
    end
end)