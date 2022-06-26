-- Team Menu
function team_menu()
	local button_width = ScrW() / 2
	local button_height = ScrH() / 2

	local isVIP = LocalPlayer():GetUserGroup() == "vip"
	local nonVipOffset = 30

    local team_menu_frame = vgui.Create("DPanel")
    team_menu_frame:SetSize(ScrW(), ScrH())
    team_menu_frame:SetVisible(true)
    team_menu_frame:Center()
    team_menu_frame:MakePopup()

	local team_selection_background = vgui.Create("DImage", team_menu_frame)
	team_selection_background:SetPos(0, 0)
	team_selection_background:SetSize(team_menu_frame:GetSize())
	team_selection_background:SetImage(GST_SNK.Images.TEAM_SELECTION_BACK)
	team_selection_background:SetZPos(0)

	local team_selection_border = vgui.Create("DImage", team_menu_frame)
	team_selection_border:SetPos(0, 0)
	team_selection_border:SetSize(team_menu_frame:GetSize())
	team_selection_border:SetImage(GST_SNK.Images.TEAM_SELECTION_BORDER)
	team_selection_border:SetZPos(2)

	-- TITAN
	local team_button_titan = vgui.Create("DButton", team_menu_frame)
	team_button_titan:SetPos(button_width + 1, button_height + 1)
	team_button_titan:SetSize(button_width, button_height) -- 960 540
	team_button_titan:SetMouseInputEnabled( true )
	team_button_titan:SetText("")
	team_button_titan.Team = "Titan"

	function team_button_titan:DoClick()
		OpenClassMenu(team_button_titan.Team)
        surface.PlaySound("/UI/buttonclick.wav")
        team_menu_frame:Remove()
	end

	local titan_color = GST_SNK.Teams[team_button_titan.Team].color
	titan_color.a = 30
	function team_button_titan:Paint(w, h)
		local vip_required = GST_SNK.Teams[team_button_titan.Team].require_vip

		surface.SetDrawColor(0,0,0,100)
		
		if (self:IsHovered()) then
			surface.SetDrawColor(titan_color)
		end
		surface.DrawRect(0, 0, w, h)

		draw.SimpleText("Titan", "default_snk", w / 2, (h / 2) - (vip_required and nonVipOffset or 0), Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if (vip_required and not isVIP) then
			draw.SimpleText("VIP Requis", "default_snk", w / 2, (h / 2) + nonVipOffset, Color(235, 0, 0, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	-- ELDIEN
	local team_button_edlien = vgui.Create("DButton", team_menu_frame)
	team_button_edlien:SetPos(0, 0)
	team_button_edlien:SetSize(button_width, button_height) -- 960 540
	team_button_edlien:SetMouseInputEnabled( true )
	team_button_edlien:SetText("")
	team_button_edlien.Team = "Eldien"

	function team_button_edlien:DoClick()
		OpenClassMenu(team_button_edlien.Team)
        surface.PlaySound("/UI/buttonclick.wav")
        team_menu_frame:Remove()
	end

	eldien_color = GST_SNK.Teams[team_button_edlien.Team].color
	eldien_color.a = 30
	function team_button_edlien:Paint(w, h)
		local vip_required = GST_SNK.Teams[team_button_edlien.Team].require_vip

		surface.SetDrawColor(0,0,0,100)
		
		if (self:IsHovered()) then
			surface.SetDrawColor(eldien_color)
		end
		surface.DrawRect(0, 0, w, h)

		draw.SimpleText("Eldien", "default_snk", w / 2, (h / 2) - (vip_required and nonVipOffset or 0), Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if (vip_required and not isVIP) then
			draw.SimpleText("VIP Requis", "default_snk", w / 2, (h / 2) + nonVipOffset, Color(235, 0, 0, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end	
	end

    -- MAHR
	local team_button_marh = vgui.Create("DButton", team_menu_frame)
	team_button_marh:SetPos(button_width + 1, 0)
	team_button_marh:SetSize(button_width, button_height) -- 960 540
	team_button_marh:SetMouseInputEnabled( true )
	team_button_marh:SetText("")
	team_button_marh.Team = "Mahr"

	function team_button_marh:DoClick()
		OpenClassMenu(team_button_marh.Team)
        surface.PlaySound("/UI/buttonclick.wav")
        team_menu_frame:Remove()
	end

	mahr_color = GST_SNK.Teams[team_button_marh.Team].color
	mahr_color.a = 30
	function team_button_marh:Paint(w, h)
		local vip_required = GST_SNK.Teams[team_button_marh.Team].require_vip

		surface.SetDrawColor(0,0,0,100)
		
		if (self:IsHovered()) then
			surface.SetDrawColor(mahr_color)
		end
		surface.DrawRect(0, 0, w, h)

		draw.SimpleText("Marh", "default_snk", w / 2, (h / 2) - (vip_required and nonVipOffset or 0), Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if (vip_required and not isVIP) then
			draw.SimpleText("VIP Requis", "default_snk", w / 2, (h / 2) + nonVipOffset, Color(235, 0, 0, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end	
	end

	-- PRIMODIALS
	local team_button_primo = vgui.Create("DButton", team_menu_frame)
	team_button_primo:SetPos(0, button_height + 1)
	team_button_primo:SetSize(button_width, button_height) -- 960 540
	team_button_primo:SetMouseInputEnabled( true )
	team_button_primo:SetText("")
	team_button_primo.Team = "Primordial"

	function team_button_primo:DoClick()
		OpenClassMenu(team_button_primo.Team)
		surface.PlaySound("/UI/buttonclick.wav")
		team_menu_frame:Remove()
	end

	primordial_color = GST_SNK.Teams[team_button_primo.Team].color
	primordial_color.a = 30
	function team_button_primo:Paint(w, h)
		local vip_required = GST_SNK.Teams[team_button_primo.Team].require_vip
		surface.SetDrawColor(0,0,0,100)
		
		if (self:IsHovered()) then
			surface.SetDrawColor(primordial_color)
		end
		surface.DrawRect(0, 0, w, h)

		draw.SimpleText("Primordial", "default_snk", w / 2, (h / 2) - (vip_required and nonVipOffset or 0), Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if (vip_required and not isVIP) then
			draw.SimpleText("VIP Requis", "default_snk", w / 2, (h / 2) + nonVipOffset, Color(235, 0, 0, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end

concommand.Add("team_menu", team_menu)