local ply = FindMetaTable("Player")

function ply:ShowBuildSelector()
    local weap = LocalPlayer():GetActiveWeapon()
    if (weap:GetClass() ~= "skill_build") then return end

    self.build_base_panel = vgui.Create("DPanel")
    self.build_base_panel:SetSize(500,600)
    self.build_base_panel:MakePopup()
    self.build_base_panel:Center()
    self.build_base_panel:SetBackgroundColor(Color(80,80,80,0))

    build_base_background = vgui.Create("DImage", self.build_base_panel)
    build_base_background:SetSize(self.build_base_panel:GetSize())
    build_base_background:SetImage(GST_SNK.Images.BUILD_SELECTOR_BACKGROUND)

    local header_pane = vgui.Create("DPanel", self.build_base_panel)
    header_pane:Dock(TOP)
    header_pane:SetHeight(100)
    header_pane:SetBackgroundColor(Color(0,0,0,0))

    local close_button = vgui.Create("DButton", header_pane)
    close_button:SetText("")
    close_button:Dock(RIGHT)
    close_button:DockMargin(0, 10, 10, 55)
    close_button:SetWide(40)
    close_button:SetMouseInputEnabled(true)

    function close_button:Paint()

    end

    close_button.DoClick = function()
        self.build_base_panel:Remove()
    end

    close_button_image = vgui.Create("DImage", close_button)
    close_button_image:Dock(FILL)
    close_button_image:SetImage(GST_SNK.Images.RED_CROSS)

    local available_build_pane = vgui.Create("DScrollPanel", self.build_base_panel)
    available_build_pane:Dock(FILL)
    available_build_pane:DockMargin(0,0,0,10)
    local vBar = available_build_pane:GetVBar()
    vBar.Paint = function() end
    vBar.btnUp.Paint = function() end
    vBar.btnDown.Paint = function() end
    vBar.btnGrip.Paint = function() end

    for model, info in SortedPairsByMemberValue(weap.AvailableBuild, "Name") do
        local build_type_pane = vgui.Create("DButton", available_build_pane)
        build_type_pane:Dock(TOP)
        build_type_pane:DockMargin(15,5,0,0)
        build_type_pane:SetHeight(100)
        build_type_pane:SetText("")
        build_type_pane:SetMouseInputEnabled(true)
        build_type_pane.Paint = function()

        end

        local build_type_pane_back = vgui.Create("DImage", build_type_pane)
        build_type_pane_back:SetSize(460, 100)
        build_type_pane_back:SetPos(5, 0)
        build_type_pane_back:SetImage(GST_SNK.Images.BUILD_SELECTOR_BUTTON)

        build_type_pane.DoClick = function()
            weap.lastSelection = model
            GST_SNK.Utils:CreateGhost(model, weap, 1500)
            self.build_base_panel:Remove()
        end

        local build_type_model = vgui.Create("DModelPanel", build_type_pane)
        build_type_model:Dock(LEFT)
        build_type_model:DockMargin(10,3,0,3)
        build_type_model:SetWidth(95)
        build_type_model:SetModel(model)
        build_type_model.Entity:SetModelScale(1 / build_type_model.Entity:GetModelRadius() * 100)
        build_type_model:SetCamPos(build_type_model.Entity:EyePos() + Vector(100,100,100))

        local build_type_name = vgui.Create("DLabel", build_type_pane)
        build_type_name:Dock(TOP)
        build_type_name:DockMargin(10, 5, 0, 0)
        build_type_name:SetFont("default_snk_small")
        build_type_name:SetText(info.Name)
        build_type_name:SetColor(Color(255,255,255))
        build_type_name:SetWrap(true)

        local build_type_desc = vgui.Create("DLabel", build_type_pane)
        build_type_desc:Dock(TOP)
        build_type_desc:DockMargin(10, 5, 0, 0)
        build_type_desc:SetHeight(50)
        build_type_desc:SetFont("default_snk_small")
        build_type_desc:SetText(info.Description)
        build_type_desc:SetColor(Color(255,255,255))
        build_type_desc:SetWrap(true)
    end
end