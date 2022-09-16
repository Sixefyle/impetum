local ply = FindMetaTable("Player")

ply.flagsColor = {
	[1] = Color(150,150,150,200),
	[2] = Color(150,150,150,200),
	[3] = Color(150,150,150,200)
}

local function DoDrop(receiver, tableOfDroppedPanels, isDropped, menuIndex, mouseX, mouseY)
	LocalPlayer().player_hud:SetPos(mouseX, mouseY)
	if isDropped then
        LocalPlayer().player_hud:SetPos(mouseX, mouseY)
		SavePlayerHudPos(mouseX, mouseY)
		timer.Simple(.01, function()
			gui.EnableScreenClicker(true)
			gui.SetMousePos( mouseX, mouseY )
		end)
    end
end

local function SkillDrop(receiver, tableOfDroppedPanels, isDropped, menuIndex, mouseX, mouseY)
	LocalPlayer().cooldown_panel:SetPos(mouseX, mouseY)
	if isDropped then
        LocalPlayer().cooldown_panel:SetPos(mouseX, mouseY)
		SavePlayerSkillHudPos(mouseX, mouseY)
		timer.Simple(.01, function()
			gui.EnableScreenClicker(true)
			gui.SetMousePos( mouseX, mouseY )
		end)
    end
end

local function SetLowEffect(elem, name)
	if not elem or not name then return end

	local min = 120
	local red = min
	local bright = true

	if (not timer.Exists("Low" .. name .. "Effect")) then
		timer.Create("Low" .. name .. "Effect", 0, 0, function()
			if not elem or not elem:GetBackgroundColor() then
				timer.Remove("Low" .. name .. "Effect")
			end

			if (elem) then
				if (bright) then
					red = red + 3
					if (red >= 255) then
						bright = false
					end
				else
					red = red - 3
					if (red <= min) then
						bright = true
					end
				end

				elem:SetBackgroundColor(Color(red, 0, 0, elem:GetBackgroundColor().a))
			end
		end)
	end
end

function ply:RefreshHud()
    self.base = vgui.Create("DPanel")
    self.base:SetSize(ScrW(), ScrH())
    self.base:Center()
    self.base:SetBackgroundColor(Color(0, 0, 0, 0))
    self.base:Receiver("playerHudDrag", DoDrop)
    self.base:Receiver("skillsHudDrag", SkillDrop)

	if (not self:GetTeam() or not self.class) then return end

    self.player_hud = vgui.Create("DPanel", self.base)
    self.player_hud:SetSize(300, 200)

	if (not self.preference.player_hud_pos) then
		self.player_hud:SetPos(0, 200)
	else
		self.player_hud:SetPos(self.preference.player_hud_pos.x, self.preference.player_hud_pos.y)
	end

	self.player_hud:SetBackgroundColor(Color(0, 0, 0, 0))
    --self.player_hud:Droppable("playerHudDrag")

	player_hud_move_panel = vgui.Create("DPanel", self.player_hud)
	player_hud_move_panel:Dock(FILL)
	player_hud_move_panel:SetBackgroundColor(Color(255,0,0,0))
	player_hud_move_panel:SetZPos(10)
	player_hud_move_panel:Droppable("playerHudDrag")

    player_hud_name = vgui.Create("DLabel", self.player_hud)
    player_hud_name:SetPos(95, 0)
    player_hud_name:SetSize(200, 20)
    player_hud_name:SetText("")

    player_hud_name.Paint = function(panel, w, h)
        draw.SimpleText(self:GetName(), "default_snk_small", 5, h / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    player_hud_team = vgui.Create("DLabel", self.player_hud)
    player_hud_team:SetPos(120, 30)
    player_hud_team:SetSize(200, 20)
    player_hud_team:SetText("")

    player_hud_team.Paint = function(panel, w, h)
        draw.SimpleText(self:GetTeam().name .. " - " .. self.class.display_name, "default_snk_small", 5, h / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    LocalPlayer().player_health_bar = vgui.Create("DPanel", self.player_hud)
    LocalPlayer().player_health_bar:SetPos(111, 75)
    LocalPlayer().player_health_bar:SetSize(186 * (self:Health() / self:GetMaxHealth()), 18)
    LocalPlayer().player_health_bar:SetBackgroundColor(self.preference.health_bar_color)

	if(self:Health() < self:GetMaxHealth() / 2) then
		SetLowEffect(LocalPlayer().player_health_bar, "Health")
	end

    LocalPlayer().player_armor_bar = vgui.Create("DPanel", self.player_hud)
    LocalPlayer().player_armor_bar:SetPos(78, 110)
    LocalPlayer().player_armor_bar:SetSize(185 * (self:Armor() / self:GetMaxArmor()), 18)
    LocalPlayer().player_armor_bar:SetBackgroundColor(self.preference.armor_bar_color)

    player_class_icon = vgui.Create("DPanel", self.player_hud)
    player_class_icon:SetPos(-4, -8)
    player_class_icon:SetSize(147, 147)
    player_class_icon:SetBackgroundColor(Color(0, 0, 0, 0))

    player_class_icon_image = vgui.Create("DImage", player_class_icon)
    player_class_icon_image:Dock(FILL)
    player_class_icon_image:SetImage(self.class.icon)

    player_hud_background = vgui.Create("DImage", self.player_hud)
    player_hud_background:Dock(FILL)
	player_hud_background:DockMargin(0, 0, 0, 50)
    player_hud_background:SetImage(GST_SNK.Images.PLAYER_HUD)

	if (IsValid(self:GetActiveWeapon()) and self:GetActiveWeapon():GetClass() == "gst_3dmg") then
		local weap = self:GetActiveWeapon()
		self.player_gaz_bar = vgui.Create("DPanel", self.player_hud)
		self.player_gaz_bar:SetPos(50, 151)
		self.player_gaz_bar:SetSize(174 * (weap:GetGas() / weap:GetNWInt("MaxGas")), 20)
		self.player_gaz_bar:SetBackgroundColor(Color(196, 196, 196, 160))

		player_hud_gaz = vgui.Create("DImage", self.player_hud)
		player_hud_gaz:SetPos(50, 140)
		player_hud_gaz:SetSize(200, 40)
		player_hud_gaz:SetImage(GST_SNK.Images.PLAYER_HUD_GAZ)
	end

	-- SKILL COOLDOWN --
	self.cooldown_panel = vgui.Create("DPanel", self.base)
	self.cooldown_panel:SetSize(450,147)
	self.cooldown_panel:SetBackgroundColor(Color(0,0,0, 0))
	--self.cooldown_panel:Droppable("skillsHudDrag")

	if (not self.preference.player_skill_hud_pos) then
		self.cooldown_panel:SetPos(0,0)
	else
		self.cooldown_panel:SetPos(self.preference.player_skill_hud_pos.x, self.preference.player_skill_hud_pos.y)
	end

	player_hud_move_panel = vgui.Create("DPanel", self.cooldown_panel)
	player_hud_move_panel:SetSize(self.cooldown_panel:GetSize())
	player_hud_move_panel:SetBackgroundColor(Color(255,0,0,0))
	player_hud_move_panel:SetZPos(10)
	player_hud_move_panel:Droppable("skillsHudDrag")

	for i, skill in ipairs(LocalPlayer():GetSkills()) do
		if (type(skill) == "Weapon" and skill.Icon) then
			local _, cooldown_panel_upper, cooldown_icon_upper = ShowSkillIcon(skill.Icon, skill.IconBack, input.GetKeyName(LocalPlayer().preference.skill_key[i]))

			timer.Create("refreshCooldownHud" .. skill:GetClass(), .3, 0, function()
				if (skill and skill.Icon) then
					self:HudUpdateCooldown(cooldown_panel_upper, cooldown_icon_upper)
				end
			end)
		else
			local _, cooldown_panel_upper, cooldown_icon_upper =
				ShowSkillIcon(skill.Icon, skill.IconBack, skill.Cooldown > 0 and input.GetKeyName(LocalPlayer().preference.skill_key[i]) or nil)
			timer.Create("refreshTitanCooldownHud" .. i, .3, 0, function()
				self:HudUpdateMultipleCooldown(cooldown_panel_upper, cooldown_icon_upper, i)
			end)
		end
	end

	-- ATTACK COOLDOWN -- 
	--if (ply:GetNWBool("ShouldShowWeaponCooldownBar")) then
		if (self.weap_cooldown_bar) then self.weap_cooldown_bar:Remove() end
		self:GetWeaponCooldownBar(self.base)
	--end

	-- REPAIR BAR --
	self.repair_bar = vgui.Create("DPanel", self.base)
	self.repair_bar:SetSize(340, 60)
	self.repair_bar:SetPos(0, 80)
	self.repair_bar:CenterHorizontal()
	self.repair_bar:SetBackgroundColor(Color(126,126,126, 0))
	self.repair_bar:Hide()

	local repair_bar_border = vgui.Create("DImage", self.repair_bar)
	repair_bar_border:SetImage(GST_SNK.Images.BUTTON_1)
	repair_bar_border:SetSize(self.repair_bar:GetSize())
	repair_bar_border:SetZPos(3)

	local repair_bar_fill = vgui.Create("DPanel", self.repair_bar)
	repair_bar_fill:SetBackgroundColor(Color(255,0,0, 0))
	repair_bar_fill:SetPos(3,22)
	repair_bar_fill:SetSize(0, 27)
	repair_bar_fill:SetZPos(2)

	local repair_bar_fill_back = vgui.Create("DImage", repair_bar_fill)
	repair_bar_fill_back:SetImage(GST_SNK.Images.BUTTON_BACKGROUND_2)
	repair_bar_fill_back:SetImageColor(Color(255,255,255))
	repair_bar_fill_back:SetSize(334, 27)

	local repair_bar_text_lower = vgui.Create("DLabel", self.repair_bar)
	repair_bar_text_lower:SetSize(self.repair_bar:GetSize())
	repair_bar_text_lower:SetText("")
	repair_bar_text_lower.Paint = function(parent, w, h)
		local perc = ((LocalPlayer():GetNWFloat("RepairProgression") % 333) / 10) * 3

		repair_bar_fill:SetSize(perc * 3.4, 27)
		draw.SimpleText("Reparation: " .. perc .. "%", "default_snk_small", w / 2, h / 2 + 7, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local repair_bar_text_upper = vgui.Create("DLabel", repair_bar_fill_back)
	repair_bar_text_upper:SetSize(self.repair_bar:GetSize())
	repair_bar_text_upper:SetText("")
	repair_bar_text_upper.Paint = function(parent, w, h)
		local perc = ((LocalPlayer():GetNWFloat("RepairProgression") % 333) / 10) * 3
		draw.SimpleText("Reparation: " .. perc .. "%", "default_snk_small", w / 2 - 3, 15, Color(22, 22, 22), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	-- CAPTURE POINTS --
	self:ShowCapturePoints()
end

function ply:ShowCapturePoints()
	local panel = vgui.Create("DPanel", self.base)
	panel:SetPos(0, 80)
	panel:SetSize(220, 66)
	panel:CenterHorizontal()
	panel:SetBackgroundColor(Color(255,0,0,0))

	local flags = ents.FindByClass("capture_point")

	panel.Paint = function(panel, w, h)
		draw.SimpleText(GAMEMODE.EldienPoints, "gotham_19", 40, 15, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(GAMEMODE.PointsToWin, "gotham_24", w / 2, 15, Color(235,235,235), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(GAMEMODE.MahrPoints, "gotham_19", w - 40, 15, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		draw.RoundedBox(100, 10, 36, 26, 28, LocalPlayer().flagsColor[1])
		draw.RoundedBox(100, 96, 36, 26, 28, LocalPlayer().flagsColor[2])
		draw.RoundedBox(100, 185, 36, 26, 28, LocalPlayer().flagsColor[3])
	end

	local panel_image = vgui.Create("DImage", panel)
	panel_image:Dock(FILL)
	panel_image:SetImage(GST_SNK.Images.CAPTURE_POINTS)
end

function ply:ShowRepairBar(shouldShow)
	if (shouldShow) then
		self.repair_bar:Show()
	else
		self.repair_bar:Hide()
	end
end

function ply:ShowWeaponCooldownBar(shouldShow)
	if (not IsValid(self) or not self.weap_cooldown_bar) then return end

	if (shouldShow) then
		self.weap_cooldown_bar:Show()
	else
		self.weap_cooldown_bar:Hide()
	end
end

function ply:GetWeaponCooldownBar(base)
	self.weap_cooldown_bar = vgui.Create("DPanel", base)
	self.weap_cooldown_bar:SetPos(ScrW() / 2 - 50, ScrH() / 2 + 22)
	self.weap_cooldown_bar:SetSize(100,5)
	self.weap_cooldown_bar.Paint = function(bar, w, h)
		draw.RoundedBox(20, 0, 0, w, h, Color(206,206,206, 10))
	end

	self.weap_cooldown_bar_filled = vgui.Create("DPanel", self.weap_cooldown_bar)
	self.weap_cooldown_bar_filled:SetPos(0, 0)
	self.weap_cooldown_bar_filled:SetSize(100,5)
	self.weap_cooldown_bar_filled.Paint = function(bar, w, h)
		local widthPerc = w / 100
		local barColor = Color(30 + widthPerc * 50,  100 + widthPerc * 131, 30 + widthPerc * 75, 100)
		--Color(80,231,105)

		draw.RoundedBox(20, 0, 0, w, h, barColor)
	end

end

function ply:WeaponCooldownBar(timeLeft)
	local cooldown = timeLeft - CurTime()

	if (self.weap_cooldown_bar_filled) then
		self.weap_cooldown_bar_filled:SetSize(0, 5)
		timer.Create("WeaponCooldownBar", 0, 0, function()
			local fillAmount = (CurTime() - timeLeft + cooldown) / cooldown * 100
			self.weap_cooldown_bar_filled:SetSize(fillAmount, 5)

			if (fillAmount >= 100) then
				timer.Remove("WeaponCooldownBar")
			end
		end)
	end
end

function ShowSkillIcon(icon, iconBack, key)
	cooldown_icon_lower = vgui.Create("DImage", LocalPlayer().cooldown_panel)
	cooldown_icon_lower:Dock(LEFT)
	cooldown_icon_lower:SetSize(147,147)
	cooldown_icon_lower:SetImageColor(Color(100,100,100))
	cooldown_icon_lower:SetImage(iconBack)

	cooldown_panel_upper = vgui.Create("DPanel", cooldown_icon_lower)
	cooldown_panel_upper:SetPos(0, 0)
	cooldown_panel_upper:SetSize(147, 147)
	cooldown_panel_upper:SetBackgroundColor(Color(0,0,0,0))

	cooldown_icon_upper = vgui.Create("DImage", cooldown_panel_upper)
	cooldown_icon_upper:SetPos(0, 0)
	cooldown_icon_upper:SetSize(147, 147)
	cooldown_icon_upper:SetImage(icon)
	cooldown_icon_upper:SetMouseInputEnabled(true)

	if (key) then
		button_panel = vgui.Create("DPanel", cooldown_icon_lower)
		button_panel:SetPos(0, 115)
		button_panel:CenterHorizontal(.635)
		button_panel:SetSize(30,30)

		button_panel.Paint = function(panel, w, h)
			draw.RoundedBox(5, 0, 0, 25, 25, Color(202,202,202))
			draw.SimpleText(key, "gotham_24", 12, 12, Color(51,51,51), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	return cooldown_icon_lower, cooldown_panel_upper, cooldown_icon_upper
end

function ply:HudUpdateCooldown(panel_upper, icon_upper)
	local current = 147

	local panelX = panel_upper:GetPos()
	local iconX = icon_upper:GetPos()

	local skill = nil
	for key, weap in pairs(LocalPlayer():GetWeapons()) do
		if (weap.Base == "base_skill") then
			skill = weap
			break
		end
	end

	if (skill and not timer.Exists("HudSkillUpdate" .. skill:GetClass())) then
		local savedSkill = skill
		timer.Create("HudSkillUpdate" .. savedSkill:GetClass(), 0, 0, function()
			if (savedSkill and savedSkill.GetCooldown and savedSkill:GetCooldown() > CurTime()) then
				local cooldownLeft = savedSkill:GetTimeCooldown()
				local cooldown = savedSkill:GetNWFloat("LastCooldown")

				current = (cooldownLeft / cooldown) * 147
				panel_upper:SetPos(panelX, current)
				icon_upper:SetPos(iconX, -current)
			else
				timer.Remove("HudSkillUpdate" .. savedSkill:GetClass())
			end
		end)
	end
end

function ply:HudUpdateMultipleCooldown(panel_upper, icon_upper, skillId)
	local current = 147

	local panelX = panel_upper:GetPos()
	local iconX = icon_upper:GetPos()

	local weap = LocalPlayer():GetActiveWeapon()
	local skill = weap.Skills[skillId]

	if (IsValid(weap) and not timer.Exists("HudSkillUpdate" .. skill.Name)) then
		local savedSkill = weap
		timer.Create("HudSkillUpdate" .. skill.Name, 0, 0, function()
			if (savedSkill and savedSkill:GetCooldown(skillId) > CurTime()) then
				local cooldownLeft = savedSkill:GetTimeCooldown(skillId)
				local cooldown = savedSkill:GetNWFloat(skillId .. "LastCooldown")

				current = (cooldownLeft / cooldown) * 147
				panel_upper:SetPos(panelX, current)
				icon_upper:SetPos(iconX, -current)
			else
				timer.Remove("HudSkillUpdate" .. skill.Name)
			end
		end)
	end
end

function ply:HudRefreshGas()
	local weap = self:GetWeapon("gst_3dmg")

	if (not IsValid(weap) or not weap:GetNWInt("MaxGas")) then return end

	self.player_gaz_bar:SetSize(174 * (weap:GetGas() / weap:GetNWInt("MaxGas")), 20)

	if (weap:GetGas() / weap:GetNWInt("MaxGas") >= weap.RegenMaxPerc / 100) then
		if (timer.Exists("LowGasEffect")) then
			timer.Remove("LowGasEffect")
		end
		self.player_gaz_bar:SetBackgroundColor(Color(196, 196, 196, 160))
	else
		SetLowEffect(self.player_gaz_bar, "Gas")
	end
end

function ply:HudForceRefresh()
	if self.base then
		self.base:Remove()
	end
	self:RefreshHud()

	timer.Create("RefreshHealthArmorBar", .3, 0, function()
		LocalPlayer().player_health_bar:SetSize(186 * (LocalPlayer():Health() / LocalPlayer():GetMaxHealth()), 18)
		LocalPlayer().player_armor_bar:SetSize(185 * (LocalPlayer():Armor() / LocalPlayer():GetMaxArmor()), 18)
	end)
end

function hud()
	LocalPlayer():HudForceRefresh()
end

net.Receive("AOTA:TC:WeaponCooldownStart", function()
	LocalPlayer():WeaponCooldownBar(net.ReadDouble())
end)

net.Receive("AOTA:TC:ShowRepairBar", function()
	LocalPlayer():ShowRepairBar(net.ReadBool())
end)

net.Receive("AOTA:TC:ForceHudRefresh", function()
	if (IsValid(LocalPlayer())) then
		LocalPlayer():HudForceRefresh()
	end
end)

net.Receive("AOTA:TC:UpdatePlayerHudGas", function()
	LocalPlayer():HudRefreshGas()
end)

concommand.Add("player_hud", function(ply, cmd, args)
	if (args[1] == "reset") then
		SavePlayerHudPos(0, 200)
		SavePlayerSkillHudPos(0, 0)
		hud()
	else
		hud()
	end
end)