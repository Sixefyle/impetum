function GST_SNK.Utils:HUDPlaySound(panel, soundPath)
    if (panel:IsHovered() and LocalPlayer().lastHoveredButton ~= panel) then
        surface.PlaySound(soundPath)
        LocalPlayer().lastHoveredButton = panel
    elseif (LocalPlayer().lastHoveredButton == panel and not panel:IsHovered()) then
        LocalPlayer().lastHoveredButton = nil
    end
end

function GST_SNK.Utils:CreateGhost(model, attached_ent, max_range, correction)
    correction = correction or Vector(0,0,0)
    util.PrecacheModel(model)
    if (not attached_ent.IsPlaced) then
        if (IsValid(attached_ent.ghost)) then
            attached_ent.ghost:Remove()
        end

        local ghost = ents.CreateClientProp(model)
        ghost:SetMoveType( MOVETYPE_NONE )
        ghost:SetRenderMode( RENDERMODE_TRANSCOLOR )
        ghost:SetColor( Color( 6, 238, 255, 200) )
        ghost:Spawn()
        attached_ent.ghost = ghost

        timer.Create("ShowGhost", 0, 0, function()
            if (not IsValid(ghost)) then
                timer.Remove("ShowGhost")
                return
            end

            if (not IsValid(attached_ent) or LocalPlayer():GetActiveWeapon() ~= attached_ent) then
                ghost:Remove()
                timer.Remove("ShowGhost")
                return
            end

            local trace = LocalPlayer():GetEyeTrace()
            if (trace.Hit) then
                local ghostPos = LocalPlayer():GetEyeTrace().HitPos

                if (ghostPos:Distance(attached_ent:GetOwner():GetPos()) <= max_range) then
                    attached_ent.ghost:SetPos(ghostPos + correction)
                else
                    local pos = LocalPlayer():LocalToWorld(Vector(max_range,0,0))
                    attached_ent.ghost:SetPos(GST_SNK.Utils:GetWorldHeightPos(pos) + correction)
                end
                attached_ent.ghost:SetAngles(Angle(0, LocalPlayer():GetAngles()[2], 0))
            end
        end)
    end
end