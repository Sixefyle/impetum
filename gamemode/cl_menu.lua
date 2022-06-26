-- --End of Team Menu
-- -- Loadout Menu mahr
-- local iconVector = Vector(-21, -21, -38)
-- local iconAngle = Angle(0, 90, 0)
-- iconVector:Rotate(iconAngle)

-- function loadout_menu_corps(ply)
--     -- Checks if player is corps.
--     if ply:Team() == TEAM_CORP_N then
--         local loadout_menu_corps_frame = vgui.Create("DFrame")
--         loadout_menu_corps_frame:SetPos(ScrW() / 5, ScrH() / 5)
--         loadout_menu_corps_frame:SetSize(800, 400)
--         loadout_menu_corps_frame:Center()
--         loadout_menu_corps_frame:SetTitle("Choisis ta Classe !")
--         loadout_menu_corps_frame:SetVisible(true)
--         loadout_menu_corps_frame:SetDraggable(false)
--         loadout_menu_corps_frame:ShowCloseButton(true)
--         loadout_menu_corps_frame:MakePopup()
--         loadout_menu_corps_frame:SetDeleteOnClose(false)

--         -- Paint function
--         loadout_menu_corps_frame.Paint = function()
--             --Set our rect color below; we do this so you can see items added to this panel
--             surface.SetDrawColor(20, 20, 20, 230)
--             surface.DrawRect(0, 0, loadout_menu_corps_frame:GetWide(), 25) -- Draw top-bar
--             surface.SetDrawColor(109, 111, 114, 255)
--             surface.DrawRect(0, 25, loadout_menu_corps_frame:GetWide(), loadout_menu_corps_frame:GetTall() - 25) -- Draw rest of menu
--             surface.SetDrawColor(0, 0, 0, 255)
--             surface.DrawOutlinedRect(0, 0, loadout_menu_corps_frame:GetWide(), 25) -- Draw border around the top-bar menu
--             surface.DrawOutlinedRect(0, 0, loadout_menu_corps_frame:GetWide(), loadout_menu_corps_frame:GetTall()) -- Draw border around the whole menu
--         end

--         local loadout_menu_corps_a_panel = vgui.Create("DFrame", loadout_menu_corps_frame)
--         loadout_menu_corps_a_panel:SetPos(30, 35)
--         loadout_menu_corps_a_panel:SetSize(350, 350)
--         loadout_menu_corps_a_panel:SetTitle("Regular")
--         loadout_menu_corps_a_panel:SetVisible(true)
--         loadout_menu_corps_a_panel:SetDraggable(false)
--         loadout_menu_corps_a_panel:ShowCloseButton(false)

--         -- Paint function
--         loadout_menu_corps_a_panel.Paint = function()
--             --Set our rect color below; we do this so you can see items added to this panel
--             surface.SetDrawColor(20, 20, 20, 230)
--             surface.DrawRect(0, 0, loadout_menu_corps_a_panel:GetWide(), 25) -- Draw top-bar
--             surface.SetDrawColor(109, 111, 114, 255)
--             surface.DrawRect(0, 25, loadout_menu_corps_a_panel:GetWide(), loadout_menu_corps_a_panel:GetTall() - 25) -- Draw rest of menu
--             surface.SetDrawColor(0, 0, 0, 255)
--             surface.DrawOutlinedRect(0, 0, loadout_menu_corps_a_panel:GetWide(), 25) -- Draw border around the top-bar menu
--             surface.DrawOutlinedRect(0, 0, loadout_menu_corps_a_panel:GetWide(), loadout_menu_corps_a_panel:GetTall()) -- Draw border around the whole menu

--             local TexturedQuadStructure = {
--                 texture = surface.GetTextureID('menu/3dgear_bg'),
--                 color = Color(255, 255, 255, 255),
--                 x = 1,
--                 y = 25,
--                 w = 348,
--                 h = 324
--             }

--             draw.TexturedQuad(TexturedQuadStructure)
--         end

--         local loadout_menu_corps_a_button = vgui.Create("DModelPanel", loadout_menu_corps_frame, team_titan_panel)
--         loadout_menu_corps_a_button:SetPos(20, 50)
--         loadout_menu_corps_a_button:SetSize(350, 350)
--         loadout_menu_corps_a_button:SetModel("models/olddeath/w_snk_sword.mdl")
--         loadout_menu_corps_a_button:SetCamPos(iconVector)

--         loadout_menu_corps_a_button.DoClick = function(ply)
--             local loadoutNumber = 1
--             net.Start("LoadoutNumber")
--             net.WriteDouble(loadoutNumber)
--             net.SendToServer()
--             loadout_menu_corps_frame:Close(true)
--         end

--         local loadout_menu_corps_b_panel = vgui.Create("DFrame", loadout_menu_corps_frame)
--         loadout_menu_corps_b_panel:SetPos(420, 35)
--         loadout_menu_corps_b_panel:SetSize(350, 350)
--         loadout_menu_corps_b_panel:SetTitle("Advanced")
--         loadout_menu_corps_b_panel:SetVisible(true)
--         loadout_menu_corps_b_panel:SetDraggable(false)
--         loadout_menu_corps_b_panel:ShowCloseButton(false)

--         -- Paint function
--         loadout_menu_corps_b_panel.Paint = function()
--             --Set our rect color below; we do this so you can see items added to this panel
--             surface.SetDrawColor(20, 20, 20, 230)
--             surface.DrawRect(0, 0, loadout_menu_corps_b_panel:GetWide(), 25) -- Draw top-bar
--             surface.SetDrawColor(109, 111, 114, 255)
--             surface.DrawRect(0, 25, loadout_menu_corps_b_panel:GetWide(), loadout_menu_corps_b_panel:GetTall() - 25) -- Draw rest of menu
--             surface.SetDrawColor(0, 0, 0, 255)
--             surface.DrawOutlinedRect(0, 0, loadout_menu_corps_b_panel:GetWide(), 25) -- Draw border around the top-bar menu
--             surface.DrawOutlinedRect(0, 0, loadout_menu_corps_b_panel:GetWide(), loadout_menu_corps_b_panel:GetTall()) -- Draw border around the whole menu

--             local TexturedQuadStructure = {
--                 texture = surface.GetTextureID('menu/3dgear_bg'),
--                 color = Color(255, 255, 255, 255),
--                 x = 1,
--                 y = 25,
--                 w = 348,
--                 h = 324
--             }

--             draw.TexturedQuad(TexturedQuadStructure)
--         end

--         local loadout_menu_corps_b_button = vgui.Create("DModelPanel", loadout_menu_corps_frame, team_corps_panel)
--         loadout_menu_corps_b_button:SetPos(420, 40)
--         loadout_menu_corps_b_button:SetSize(350, 350)
--         loadout_menu_corps_b_button:SetModel("models/olddeath/w_snk_sword.mdl")
--         loadout_menu_corps_b_button:SetCamPos(iconVector)

--         loadout_menu_corps_b_button.DoClick = function(ply)
--             local loadoutNumber = 2
--             net.Start("LoadoutNumber")
--             net.WriteDouble(loadoutNumber)
--             net.SendToServer()
--             loadout_menu_corps_frame:Close(true)
--         end
--     end
-- end

-- concommand.Add("loadout_menu", loadout_menu_corps)
-- --End of Loadout Menu Corps