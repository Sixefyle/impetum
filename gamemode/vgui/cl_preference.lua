
local ply = FindMetaTable("Player")

function ply:ShowPreferenceGUI()

    if(self.preference_base) then
        self.preference_base:Remove()
    end

    self.preference_base = vgui.Create("DPanel")
    self.preference_base:SetSize(ScrW() - 800, ScrH() - 200)
    self.preference_base:Center()
    self.preference_base:MakePopup()

    self.preference_base.OnRemove = function(panel)
        SavePlayerPreference()
        self:HudForceRefresh()
    end

    local header_panel = vgui.Create("DPanel", self.preference_base)
    header_panel:Dock(TOP)
    header_panel:SetHeight(200)

    local exit_button = vgui.Create("DButton", header_panel)
    exit_button:SetSize(100,100)
    exit_button:SetText("Fermer")

    exit_button.DoClick = function()
        self.preference_base:Remove()
    end

    local body_panel = vgui.Create("DScrollPanel", self.preference_base)
    body_panel:Dock(FILL)

    local shortcut_title = vgui.Create("DLabel", body_panel)
    shortcut_title:Dock(TOP)
    shortcut_title:CenterHorizontal()
    shortcut_title:SetText("Raccourcie")
    shortcut_title:SetColor(Color(0,0,0))

    local shortcut_3dmg_panel = vgui.Create("DPanel", body_panel)
    shortcut_3dmg_panel:Dock(TOP)
    shortcut_3dmg_panel:SetHeight(100)

    local shortcut_3dmg_name = vgui.Create("DLabel", shortcut_3dmg_panel)
    shortcut_3dmg_name:Dock(LEFT)
    shortcut_3dmg_name:SetWide(1000)
    shortcut_3dmg_name:SetText("Utilisation 3DMG")
    shortcut_3dmg_name:SetColor(Color(0,0,0))

    local shortcut_3dmg_button = vgui.Create("DBinder", shortcut_3dmg_panel)
    shortcut_3dmg_button:Dock(RIGHT)
    shortcut_3dmg_button:SetValue(self.preference["server_only_sc"]["use_3dmg"])
    shortcut_3dmg_button.OnChange = function(panel, num)
        self.preference["server_only_sc"]["use_3dmg"] = num
    end

    local shortcut_gas_panel = vgui.Create("DPanel", body_panel)
    shortcut_gas_panel:Dock(TOP)
    shortcut_gas_panel:SetHeight(100)

    local shortcut_gas_name = vgui.Create("DLabel", shortcut_gas_panel)
    shortcut_gas_name:Dock(LEFT)
    shortcut_gas_name:SetWide(1000)
    shortcut_gas_name:SetText("Utilisation Gaz")
    shortcut_gas_name:SetColor(Color(0,0,0))

    local shortcut_gas_button = vgui.Create("DBinder", shortcut_gas_panel)
    shortcut_gas_button:Dock(RIGHT)
    shortcut_gas_button:SetValue(self.preference["server_only_sc"]["use_gas"])
    shortcut_gas_button.OnChange = function(panel, num)
        self.preference["server_only_sc"]["use_gas"] = num
    end

    for index, key in ipairs(self.preference["skill_key"]) do
        local shortcut_panel = vgui.Create("DPanel", body_panel)
        shortcut_panel:Dock(TOP)
        shortcut_panel:SetHeight(100)

        local shortcut_name = vgui.Create("DLabel", shortcut_panel)
        shortcut_name:Dock(LEFT)
        shortcut_name:SetText("Sort " .. index)
        shortcut_name:SetColor(Color(0,0,0))

        local shortcut_button = vgui.Create("DBinder", shortcut_panel)
        shortcut_button:Dock(RIGHT)
        shortcut_button:SetValue(key)
        shortcut_button.OnChange = function(panel, num)
            self.preference["skill_key"][index] = num
        end
    end

    local colors_title = vgui.Create("DLabel", body_panel)
    colors_title:Dock(TOP)
    colors_title:CenterHorizontal()
    colors_title:SetText("Couleurs HUD")
    colors_title:SetColor(Color(0,0,0))

    local health_bar_color_panel = vgui.Create("DPanel", body_panel)
    health_bar_color_panel:Dock(TOP)
    health_bar_color_panel:SetHeight(100)

    local health_bar_color_name = vgui.Create("DLabel", health_bar_color_panel)
    health_bar_color_name:Dock(LEFT)
    health_bar_color_name:SetText("Barre de vie")
    health_bar_color_name:SetColor(Color(0,0,0))
    
    local health_bar_color_picker = vgui.Create("DColorMixer", health_bar_color_panel)
    health_bar_color_picker:Dock(RIGHT)
    health_bar_color_picker:SetPalette(false)  			-- Show/hide the palette 				DEF:true
    health_bar_color_picker:SetAlphaBar(true) 			-- Show/hide the alpha bar 				DEF:true
    health_bar_color_picker:SetWangs(false) 				-- Show/hide the R G B A indicators 	DEF:true
    health_bar_color_picker:SetColor(self.preference.health_bar_color) 	-- Set the default color

    health_bar_color_picker.ValueChanged = function(panel, color)
        self.preference.health_bar_color = color
    end

    local armor_bar_color_panel = vgui.Create("DPanel", body_panel)
    armor_bar_color_panel:Dock(TOP)
    armor_bar_color_panel:SetHeight(100)

    local armor_bar_color_name = vgui.Create("DLabel", armor_bar_color_panel)
    armor_bar_color_name:Dock(LEFT)
    armor_bar_color_name:SetText("Barre d'armure'")
    armor_bar_color_name:SetColor(Color(0,0,0))
    
    local armor_bar_color_picker = vgui.Create("DColorMixer", armor_bar_color_panel)
    armor_bar_color_picker:Dock(RIGHT)
    armor_bar_color_picker:SetPalette(false)  			-- Show/hide the palette 				DEF:true
    armor_bar_color_picker:SetAlphaBar(true) 			-- Show/hide the alpha bar 				DEF:true
    armor_bar_color_picker:SetWangs(false) 				-- Show/hide the R G B A indicators 	DEF:true
    armor_bar_color_picker:SetColor(self.preference.armor_bar_color) 	-- Set the default color

    armor_bar_color_picker.ValueChanged = function(panel, color)
        self.preference.armor_bar_color = color
    end
end

concommand.Add("show_preference", function()
    LocalPlayer():ShowPreferenceGUI()
end)