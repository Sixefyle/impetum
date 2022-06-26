playerTeamColor = team.GetColor(1)

function GM:ScoreboardHide()
    GAMEMODE.ShowScoreboard = false
    gui.EnableScreenClicker(false)
	self.scoreboard_base:Remove()
end

function GM:GetPlayerScoreInfo()
	local players = {}

	for _, ply in pairs(player.GetAll()) do
		players[ply] = {}

		players[ply]["frags"] = ply:Frags()
		players[ply]["deaths"] = ply:Deaths()
		players[ply]["ping"] = ply:Ping()
		players[ply]["name"] = ply:Nick()
	end

	return players
end

function GM:GetScoreBoardPanel()
	self.scoreboard_base = vgui.Create("DPanel")
	self.scoreboard_base:SetPos(300, 32)
	self.scoreboard_base:SetSize(ScrW() - 600, ScrH() - 64)
	self.scoreboard_base:SetBackgroundColor(Color(255,0,0,0))

	local scoreboard_header_image = vgui.Create("DImage", self.scoreboard_base)
	scoreboard_header_image:SetPos(0,0)
	scoreboard_header_image:SetSize(self.scoreboard_base:GetSize(), 200)
	scoreboard_header_image:SetImage(GST_SNK.Images.TAB_MENU_HEADER)
	scoreboard_header_image:SetZPos(999)

	if (not LocalPlayer().scoreboardSortType and not LocalPlayer().scoreboardAsc) then
		LocalPlayer().scoreboardSortType = "name"
		LocalPlayer().scoreboardAsc = true
	end


	ping_sort_button = vgui.Create("DButton", self.scoreboard_base)
	ping_sort_button:SetPos(20,150)
	ping_sort_button:SetSize(100,50)
	ping_sort_button:SetText("")
	ping_sort_button:SetZPos(1000)

	ping_sort_button.Paint = function()
		if (LocalPlayer().scoreboardSortType == "ping") then
			draw.SimpleText(LocalPlayer().scoreboardAsc and "▼" or "▲", "gotham", 90, 20, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	ping_sort_button.DoClick = function()
		LocalPlayer().scoreboardSortType = "ping"
		LocalPlayer().scoreboardAsc = not LocalPlayer().scoreboardAsc
		RefreshList()
	end

	name_sort_button = vgui.Create("DButton", self.scoreboard_base)
	name_sort_button:SetPos(135,150)
	name_sort_button:SetSize(730,50)
	name_sort_button:SetText("")
	name_sort_button:SetZPos(1000)

	name_sort_button.Paint = function()
		if (LocalPlayer().scoreboardSortType == "name") then
			draw.SimpleText(LocalPlayer().scoreboardAsc and "▼" or "▲", "gotham", 140, 20, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end	end

	name_sort_button.DoClick = function()
		LocalPlayer().scoreboardSortType = "name"
		LocalPlayer().scoreboardAsc = not LocalPlayer().scoreboardAsc
		RefreshList()
	end

	frags_sort_button = vgui.Create("DButton", self.scoreboard_base)
	frags_sort_button:SetPos(900,150)
	frags_sort_button:SetSize(140,50)
	frags_sort_button:SetText("")
	frags_sort_button:SetZPos(1000)

	frags_sort_button.Paint = function()
		if (LocalPlayer().scoreboardSortType == "frags") then
			draw.SimpleText(LocalPlayer().scoreboardAsc and "▼" or "▲", "gotham", 120, 20, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	frags_sort_button.DoClick = function()
		LocalPlayer().scoreboardSortType = "frags"
		LocalPlayer().scoreboardAsc = not LocalPlayer().scoreboardAsc
		RefreshList()
	end

	deaths_sort_button = vgui.Create("DButton", self.scoreboard_base)
	deaths_sort_button:SetPos(1030, 150)
	deaths_sort_button:SetSize(125, 50)
	deaths_sort_button:SetText("")
	deaths_sort_button:SetZPos(1000)

	deaths_sort_button.Paint = function()
		if (LocalPlayer().scoreboardSortType == "deaths") then
			draw.SimpleText(LocalPlayer().scoreboardAsc and "▼" or "▲", "gotham", 120, 20, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	deaths_sort_button.DoClick = function()
		LocalPlayer().scoreboardSortType = "deaths"
		LocalPlayer().scoreboardAsc = not LocalPlayer().scoreboardAsc
		RefreshList()
	end

	points_sort_button = vgui.Create("DButton", self.scoreboard_base)
	points_sort_button:SetPos(1160, 150)
	points_sort_button:SetSize(125, 50)
	points_sort_button:SetText("")
	points_sort_button:SetZPos(1000)

	points_sort_button.Paint = function()
		if (LocalPlayer().scoreboardSortType == "points") then
			draw.SimpleText(LocalPlayer().scoreboardAsc and "▼" or "▲", "gotham", 115, 20, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	points_sort_button.DoClick = function()
		LocalPlayer().scoreboardSortType = "points"
		LocalPlayer().scoreboardAsc = not LocalPlayer().scoreboardAsc
		RefreshList()
	end

	function RefreshList()
		if (self.player_list_panel) then
			self.player_list_panel:Remove()
		end

		self.player_list_panel = vgui.Create("DScrollPanel", self.scoreboard_base)
		self.player_list_panel:Dock(FILL)
		self.player_list_panel:DockMargin(19, 170, 4, 0)
		self.player_list_panel:SetBackgroundColor(Color(0,0,0,0))

		local scroll_bar = self.player_list_panel:GetVBar()
		scroll_bar.Paint = function() end
		scroll_bar.btnUp.Paint = function() end
		scroll_bar.btnDown.Paint = function() end
		scroll_bar.btnGrip.Paint = function() end

		local index = 1
		local back_player_panel
		for ply, info in SortedPairsByMemberValue(self:GetPlayerScoreInfo(), LocalPlayer().scoreboardSortType, LocalPlayer().scoreboardAsc) do

			local teamColor
			if (ply:Team() > 0) then
				teamColor = GST_SNK:GetTeam(ply:Team()).color
				teamColor.a = 100
			else
				teamColor = Color(200,200,200,100)
			end

			local player_panel = vgui.Create("DPanel", self.player_list_panel)
			player_panel:Dock(TOP)
			player_panel:DockMargin(0, index == #player.GetAll() and 40 or 0, 0, 0)
			player_panel:SetHeight(60)
			player_panel:SetBackgroundColor(Color(0,0,0,0))
			player_panel:SetZPos(2)

			if (index == #player.GetAll()) then
				back_player_panel = vgui.Create("DImage", self.player_list_panel)
				back_player_panel:SetImage(GST_SNK.Images.TAB_MENU_BACKGROUND_START)
				back_player_panel:SetSize(self.scoreboard_base:GetSize() - 38, 100)
				back_player_panel:SetZPos(1)
			elseif (index == 1) then
				back_player_panel = vgui.Create("DImage", player_panel)
				back_player_panel:SetImage(GST_SNK.Images.TAB_MENU_BACKGROUND_END)
				back_player_panel:SetSize(self.scoreboard_base:GetSize() - 38, 60)
			else
				back_player_panel = vgui.Create("DImage", player_panel)
				back_player_panel:SetImage(GST_SNK.Images.TAB_MENU_BACKGROUND_MID)
				back_player_panel:SetSize(self.scoreboard_base:GetSize() - 38, 60)
			end

			local player_class_panel = vgui.Create("DPanel", player_panel)
			player_class_panel:SetPos(16,0)
			player_class_panel:SetSize(self.scoreboard_base:GetSize() - 70, 50 )
			player_class_panel:SetBackgroundColor(Color(0,0,0,0))

			player_class_panel_back = vgui.Create("DImage", player_class_panel)
			player_class_panel_back:SetSize(player_class_panel:GetSize(), 47)

			if (ply:Team() > 0) then
				player_class_panel_back:SetImage(GST_SNK.Images["TAB_MENU_USER_" .. string.upper(GST_SNK:GetTeam(ply:Team()).name)])
			else
				player_class_panel_back:SetImage(GST_SNK.Images.TAB_MENU_USER_ELDIEN)
			end

			local player_ping = vgui.Create("DPanel", player_class_panel)
			player_ping:Dock(LEFT)
			player_ping:DockMargin(30, 0, 0, 0)
			player_ping.Paint = function(panel, w, h)
				draw.SimpleText(ply:Ping(), "gotham_24", w / 2, h / 2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
	
			local player_name = vgui.Create("DPanel", player_class_panel)
			player_name:Dock(LEFT)
			player_name:SetWidth(730)
			player_name:DockMargin(50, 0, 0, 0)
			player_name.Paint = function(panel, w, h)
				draw.SimpleText(ply:Nick(), "gotham_24", 0, h / 2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
	
			local player_kills = vgui.Create("DPanel", player_class_panel)
			player_kills:Dock(LEFT)
			player_kills:DockMargin(40, 0, 0, 0)
			player_kills.Paint = function(panel, w, h)
				draw.SimpleText(ply:Frags(), "gotham_24", w / 2, h / 2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
	
			local player_deaths = vgui.Create("DPanel", player_class_panel)
			player_deaths:Dock(LEFT)
			player_deaths:DockMargin(75, 0, 0, 0)
			player_deaths.Paint = function(panel, w, h)
				draw.SimpleText(ply:Deaths(), "gotham_24", w / 2, h / 2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
	
			local player_points = vgui.Create("DPanel", player_class_panel)
			player_points:Dock(LEFT)
			player_points:DockMargin(65, 0, 0, 0)
			player_points.Paint = function(panel, w, h)
				draw.SimpleText(1748, "gotham_24", w / 2, h / 2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			index = index + 1
		end
	end

	RefreshList()

	hide_button = vgui.Create("DButton", self.scoreboard_base)
	hide_button:SetPos(0,0)
	hide_button:SetSize(100,100)
	hide_button:SetText("_")

	hide_button.DoClick = function()
		self.scoreboard_base:ToggleVisible()
	end
end

function GM:ScoreboardShow()
	GAMEMODE.ShowScoreboard = true
    gui.EnableScreenClicker(true)
	self:GetScoreBoardPanel()
end

net.Receive("MutePlayer", function(length)
    local ply = net.ReadEntity()
    ply:SetMuted(true)
    LocalPlayer():ChatPrint(ply:GetName() .. " has been muted.")
end)

net.Receive("UnMutePlayer", function(length)
    local ply = net.ReadEntity()
    ply:SetMuted(false)
    LocalPlayer():ChatPrint(ply:GetName() .. " has been unmuted.")
end)