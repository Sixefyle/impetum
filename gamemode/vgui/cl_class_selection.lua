function OpenClassMenu(newTeam)
    local teamColor = GST_SNK.Teams[newTeam].color
    teamColor.a = 255

    local base_panel = vgui.Create("DPanel")
    base_panel:SetSize(ScrW() - ScrW() * .05, ScrH() - ScrH() * .1)
    base_panel:MakePopup()
    base_panel:Center()
    base_panel:SetBackgroundColor(Color(0,0,0,0))

    panel_background = vgui.Create("DImage", base_panel)
    panel_background:SetPos(0,0)
    panel_background:SetSize(base_panel:GetSize())

    if (GST_SNK.Images["CLASS_SELECTION_" .. string.upper(newTeam)]) then
        panel_background:SetImage(GST_SNK.Images["CLASS_SELECTION_" .. string.upper(newTeam)])
    else
        panel_background:SetImage(GST_SNK.Images.CLASS_SELECTION_ELDIEN)
    end

    panel_title = vgui.Create("DPanel", base_panel)
    panel_title:Dock(TOP)
    panel_title:SetHeight(ScrH() * .2)
    panel_title:SetBackgroundColor(Color(0,0,0,0))

    -- BACK BUTTON

    back_button = vgui.Create("DButton", panel_title)
    back_button:SetPos(ScrW() * .29, ScrH() * .073)
    back_button:SetSize(base_panel:GetWide() * .1, ScrH() * .07)
    back_button:SetText("")

    back_button.Paint = function(self, w, h)
        GST_SNK.Utils:HUDPlaySound(self, "button/hover.wav")

    end

    back_button.DoClick = function()
        base_panel:Remove()
        LocalPlayer():ConCommand("team_menu")
    end

    back_button_background = vgui.Create("DImage", back_button)
    back_button_background:Dock(FILL)
    back_button_background:DockMargin(0, ScrH() * .025, 0, ScrH() * .013)
    back_button_background:SetImage(GST_SNK.Images.BUTTON_BACKGROUND_2)
    back_button_background:SetImageColor(Color(100,100,100))

    back_button_border = vgui.Create("DImage", back_button)
    back_button_border:SetPos(0,0)
    back_button_border:Dock(FILL)
    back_button_border:SetImage(GST_SNK.Images.BUTTON_1)

    back_button_text = vgui.Create("DLabel", back_button_background)
    back_button_text:Dock(FILL)
    back_button_text:SetText("")

    back_button_text.Paint = function(self, w, h)
        draw.SimpleText("Retour", "default_snk_normal", w / 2, h / 2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    gst_coins_amount = vgui.Create("DLabel", panel_title)
    gst_coins_amount:SetPos(base_panel:GetWide() * .8, ScrH() * .073)
    gst_coins_amount:SetSize(base_panel:GetWide() * .15, ScrH() * .07)
    gst_coins_amount:SetText("")

    gst_coins_amount.Paint = function(self, w, h)    end
    
    gst_coins_background = vgui.Create("DImage", gst_coins_amount)
    gst_coins_background:Dock(FILL)
    gst_coins_background:SetImage(GST_SNK.Images.BUTTON_2)
    gst_coins_background:SetImageColor(Color(255,214,0))

    gst_coins_text = vgui.Create("DLabel", gst_coins_background)
    gst_coins_text:Dock(FILL)
    gst_coins_text:SetText("")

    gst_coins_text.Paint = function(self, w, h)
        draw.SimpleText(string.Comma(LocalPlayer():SH_GetPremiumPoints()) .. " GST Coins", "default_snk_normal", w / 2, h / 2 + 3, Color(255,174,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    -- STANDARD COIN AMOUNT

    standard_coins_amount = vgui.Create("DLabel", panel_title)
    standard_coins_amount:SetPos(base_panel:GetWide() * .63, ScrH() * .073)
    standard_coins_amount:SetSize(base_panel:GetWide() * .15, ScrH() * .07)
    standard_coins_amount:SetText("")

    standard_coins_amount.Paint = function(self, w, h)    end

    standard_coins_background = vgui.Create("DImage", standard_coins_amount)
    standard_coins_background:Dock(FILL)
    standard_coins_background:SetImage(GST_SNK.Images.BUTTON_2)

    standard_coins_text = vgui.Create("DLabel", standard_coins_background)
    standard_coins_text:Dock(FILL)
    standard_coins_text:SetText("")

    standard_coins_text.Paint = function(self, w, h)
        draw.SimpleText(string.Comma(LocalPlayer():SH_GetStandardPoints()) .. " Coins", "default_snk_normal", w / 2, h / 2 + 3, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    ---------------

    local class_button
    local index = 0

    base_class_panel_right = vgui.Create("DPanel", base_panel)
    base_class_panel_right:Dock(RIGHT)
    base_class_panel_right:SetBackgroundColor(Color(0,0,0,0))
    base_class_panel_right:SetWidth(base_panel:GetWide() / 2 - base_panel:GetWide() * .017)
    base_class_panel_right:DockMargin(0,0,base_panel:GetWide() * .035,0)

    for id, class in SortedPairsByMemberValue(GST_SNK.Classes[newTeam], "id") do

        local isLocked = not LocalPlayer().unlocked_classes[newTeam] or not table.HasValue(LocalPlayer().unlocked_classes[newTeam], id)
        local isDisabled = class.isDisabled

        if (index % 2 == 0) then
            base_class_panel = vgui.Create("DPanel", base_panel)
        else
            base_class_panel = vgui.Create("DPanel", base_class_panel_right)
        end

        base_class_panel:SetHeight(ScrH() * .1)
        base_class_panel:Dock(TOP)
        base_class_panel:SetBackgroundColor(Color(0,0,0,0))
        base_class_panel:DockMargin(base_panel:GetWide() * .027, 0, 0, 5)

        class_icon = vgui.Create("DPanel", base_class_panel)
        class_icon:Dock(LEFT)
        class_icon:SetWidth(base_panel:GetWide() * .055)
        class_icon:SetBackgroundColor(Color(0,0,0,0))

        if (class.icon) then
            class_icon_background = vgui.Create("DImage", class_icon)
            class_icon_background:Dock(FILL)
            class_icon_background:SetImage(class.icon)
        end

        class_title = vgui.Create("DPanel", base_class_panel)
        --class_title:Dock(TOP)
        class_title:SetPos(base_panel:GetWide() * .09,0)
        class_title:SetSize(base_panel:GetWide() * .11, ScrH() * .05)
        class_title:SetBackgroundColor(Color(0,0,0,0))
        class_title:SetZPos(3)

        class_title_border = vgui.Create("DImage", class_title)
        class_title_border:Dock(FILL)
        class_title_border:SetImage(GST_SNK.Images.CLASS_SELECTION_BAR_TITLE)
        if(isLocked or isDisabled) then
            class_title_border:SetImageColor(Color(153,153,153))
        end

        class_title_text =  vgui.Create("DLabel", class_title)
        class_title_text:Dock(FILL)
        class_title_text:SetText("")

        local title_color = Color(255,255,255)
        if(isLocked or isDisabled) then
            title_color = Color(200,200,200)
        end
        class_title_text.Paint = function(self, w, h)
            draw.DrawText(class.display_name, "default_snk_small", w / 2, h / 2 - 10, title_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        class_desc_panel = vgui.Create("DPanel", base_class_panel)
        class_desc_panel:Dock(TOP)
        class_desc_panel:SetHeight(ScrH() * .05)
        class_desc_panel:DockMargin(base_panel:GetWide() * .005, ScrH() * .04, base_panel:GetWide() * .007, 0)
        class_desc_panel:SetBackgroundColor(Color(0, 0, 0, 0))
        class_desc_panel:SetZPos(2)

        class_bar = vgui.Create("DImage", class_desc_panel)
        class_bar:Dock(FILL)
        class_bar:SetImage(GST_SNK.Images.CLASS_SELECTION_BAR)
        class_bar:SetZPos(2)

        if(isLocked or isDisabled) then
            class_bar:SetImageColor(Color(153,153,153))
        end


        class_button = vgui.Create("DButton", class_desc_panel)
        class_button:SetPos(base_panel:GetWide() * .315, -ScrH() * .005)
        class_button:SetSize(base_panel:GetWide() * .1, ScrH() * .1)
        class_button:SetColor(Color(0,0,0))
        class_button:SetText("")
        class_button:SetZPos(1)

        class_button.Paint = function(self, w, h)
            GST_SNK.Utils:HUDPlaySound(self, "button/hover.wav")

            if (isDisabled) then
                surface.SetDrawColor(Color(145,40,40))
            elseif (isLocked) then
                if (self:IsHovered()) then
                    surface.SetDrawColor(Color(233,200,37))
                else
                    surface.SetDrawColor(Color(199,172,38))
                end
            elseif (self:IsHovered()) then
                surface.SetDrawColor(LigtherColor(teamColor, -30))
            else
                surface.SetDrawColor(LigtherColor(teamColor, -80))
            end
            surface.DrawRect(0, 0, w, h)

            if (isDisabled) then
                draw.SimpleText("Indisponible", "default_snk_small", w / 2 - w * .08, h * .3, Color(255,255,255,200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            elseif (isLocked) then
                draw.SimpleText("Acheter", "default_snk_small", w / 2 - w * .08, h * .3, Color(255,255,255,200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else
                draw.SimpleText("Rejoindre", "default_snk_small", w / 2 - w * .08, h * .3, Color(255,255,255,200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end

        class_button.DoClick = function()
            if(isDisabled) then return end

            if (not isLocked) then
                net.Start("TeamSelect")
                    net.WriteString(newTeam)
                    net.WriteString(id)
                net.SendToServer()
                base_panel:Remove()
            else
                OpenBuyModal(base_panel, class, id, newTeam)
            end
        end

        class_desc_text = vgui.Create("DLabel", class_desc_panel)
        class_desc_text:SetPos(base_panel:GetWide() * .025, -ScrH() * 0.01)
        class_desc_text:SetSize(base_panel:GetWide() * .3, ScrH() * .07)
        class_desc_text:SetFont("gotham")
        class_desc_text:SetText(class.description and class.description or "Aucune description fournie.")
        class_desc_text:SetWrap(true)
        class_desc_text:SetZPos(3)

        test_blur = vgui.Create("DPanel", class_desc_panel)
        test_blur:SetPos(base_panel:GetWide() * .015,0)
        test_blur:SetSize(class_desc_text:GetSize())
        test_blur:SetZPos(4)
        test_blur.Paint = function(self, w, h)
            if ((isLocked or isDisabled) and not self:IsHovered()) then
                blur(self)
                draw.SimpleText("VERROUILLE", "default_snk_small",  w / 2, h / 2 - 15, Color(255,255,255,189), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText("(Passez votre souris pour découvrir)", "gotham",  w / 2, h / 2 + 5  , Color(255,255,255,189), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end

        index = index + 1
    end
end

function LigtherColor(color, brightness, alpha)
    local r, g, b, a = color:Unpack()
    r = (r + brightness > 0 and r + brightness or 0)
    g = (g + brightness > 0 and g + brightness or 0)
    b = (b + brightness > 0 and b + brightness or 0)
    a = (alpha and alpha or 255)
    return Color(r, g, b, a)
end

local matBlurScreen = Material( "pp/blurscreen" )
function blur(panel)
	local Fraction = 1

	if ( starttime ) then
		Fraction = math.Clamp((SysTime()) / 1, 0, 1 )
	end

	local x, y = panel:LocalToScreen( 0, 0 )

    surface.SetMaterial( matBlurScreen )
    surface.SetDrawColor( 255, 255, 255, 255 )

    for i = 0.11, 0.44, 0.11 do
        matBlurScreen:SetFloat( "$blur", Fraction * 5 * i )
        matBlurScreen:Recompute()
        if ( render ) then render.UpdateScreenEffectTexture() end -- Todo: Make this available to menu Lua
        surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
    end

	surface.SetDrawColor( 10, 10, 10, 200 * Fraction )
	--surface.DrawRect( x * -1, y * -1 , ScrW(), ScrH())
end

function OpenBuyModal(parent_panel, class, id, newTeam)
    local blur_modal_panel = vgui.Create("DPanel")
    blur_modal_panel:SetSize(ScrW(), ScrH())
    blur_modal_panel:MakePopup()
    blur_modal_panel:Center()
    blur_modal_panel:SetBackgroundColor(0,0,0,0)

    blur_modal_panel.Paint = function(self, w, h)
        Derma_DrawBackgroundBlur( self, SysTime() - 100 )
    end

    local base_modal_panel = vgui.Create("DPanel", blur_modal_panel)
    base_modal_panel:SetSize(800, 400)
    base_modal_panel:Center()
    base_modal_panel:SetBackgroundColor(Color(0,0,0,0))

    local base_modal_background = vgui.Create("DImage", base_modal_panel)
    base_modal_background:SetSize(base_modal_panel:GetSize())
    base_modal_background:SetPos(0,0)
    base_modal_background:SetImage(GST_SNK.Images.CLASS_SELECTION_CONFIRMATION_POPUP)

    local title = vgui.Create("DLabel", base_modal_panel)
    title:Dock(TOP)
    title:SetHeight(100)
    title:SetText("")

    title.Paint = function(self, w, h)
        draw.SimpleText("Acheter " .. class.display_name .. " ?", "default_snk_normal", w / 2, h / 2 + 15, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local description = vgui.Create("DLabel", base_modal_panel)
    description:Dock(TOP)
    description:DockMargin(50,0,50,0)
    description:SetHeight(180)
    description:SetFont("gotham_24")
    description:SetText(class.description and class.description or "Aucune déscription fournie.")
    description:SetWrap(true)

    -- BUY STD

    local std_buy_button = vgui.Create("DButton", base_modal_panel)
    std_buy_button:Dock(LEFT)
    std_buy_button:SetWidth(180)
    std_buy_button:DockMargin(100,10,5,30)
    std_buy_button:SetText("")

    std_buy_button.Paint = function(self, w, h)
        GST_SNK.Utils:HUDPlaySound(self, "button/hover.wav")

        if (std_buy_button:IsHovered()) then
            std_buy_button_background:SetImageColor(Color(70,70,70))
        else
            std_buy_button_background:SetImageColor(Color(90,90,90))
        end
    end
    

    std_buy_button.DoClick = function()
        net.Start("ClassBuyRequest")
            net.WriteBit(0)
            net.WriteString(id)
            net.WriteString(newTeam)
        net.SendToServer()

        timer.Simple(.1, function()
            parent_panel:Remove()
            blur_modal_panel:Remove()
            OpenClassMenu(newTeam)
        end)
    end

    std_buy_button_background = vgui.Create("DImage", std_buy_button)
    std_buy_button_background:Dock(FILL)
    std_buy_button_background:DockMargin(0,27,0,15)
    std_buy_button_background:SetImage(GST_SNK.Images.BUTTON_BACKGROUND_2)

    std_buy_button_border = vgui.Create("DImage", std_buy_button)
    std_buy_button_border:SetPos(0,0)
    std_buy_button_border:Dock(FILL)
    std_buy_button_border:SetImage(GST_SNK.Images.BUTTON_1)

    std_buy_button_text = vgui.Create("DLabel", std_buy_button_border)
    std_buy_button_text:Dock(FILL)
    std_buy_button_text:SetText("")

    std_buy_button_text.Paint = function(self, w, h)
        --draw.SimpleText("Acheter", "default_snk_very_small", w / 2, h / 2 + 14, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(string.Comma(class.price_std) .. " Coins", "default_snk_very_small", w / 2, h / 2 + 7, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)   
     end

    -- BUY GST

    local gst_buy_button = vgui.Create("DButton", base_modal_panel)
    gst_buy_button:Dock(FILL)
    gst_buy_button:DockMargin(2,10,5,30)
    gst_buy_button:SetText("")

    gst_buy_button.Paint = function(self, w, h)
        GST_SNK.Utils:HUDPlaySound(self, "button/hover.wav")

        if (gst_buy_button:IsHovered()) then
            gst_buy_button_background:SetImageColor(Color(226,170,14))
        else
            gst_buy_button_background:SetImageColor(Color(255,187,0))
        end
    end

    gst_buy_button.DoClick = function()
        net.Start("ClassBuyRequest")
            net.WriteBit(1)
            net.WriteString(id)
            net.WriteString(newTeam)
        net.SendToServer()

        timer.Simple(.1, function()
            parent_panel:Remove()
            blur_modal_panel:Remove()
            OpenClassMenu(newTeam)
        end)
    end

    gst_buy_button_background = vgui.Create("DImage", gst_buy_button)
    gst_buy_button_background:Dock(FILL)
    gst_buy_button_background:DockMargin(0,27,0,15)
    gst_buy_button_background:SetImage(GST_SNK.Images.BUTTON_BACKGROUND_2)

    gst_buy_button_border = vgui.Create("DImage", gst_buy_button)
    gst_buy_button_border:SetPos(0,0)
    gst_buy_button_border:Dock(FILL)
    gst_buy_button_border:SetImage(GST_SNK.Images.BUTTON_1)

    gst_buy_button_text = vgui.Create("DLabel", gst_buy_button_border)
    gst_buy_button_text:Dock(FILL)
    gst_buy_button_text:SetText("")

    gst_buy_button_text.Paint = function(self, w, h)
        --draw.SimpleText("Acheter", "default_snk_very_small", w / 2, h / 2 + 14, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(string.Comma(class.price_gst) .. " GST Coins", "default_snk_very_small", w / 2, h / 2 + 7, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)       
    end

    -- CANCEL BUTTON

    local cancel_button = vgui.Create("DButton", base_modal_panel)
    cancel_button:Dock(RIGHT)
    cancel_button:DockMargin(2,10,100,30)
    cancel_button:SetWidth(180)
    cancel_button:SetText("")

    cancel_button.Paint = function(self, w, h)
        GST_SNK.Utils:HUDPlaySound(self, "button/hover.wav")

        if (cancel_button:IsHovered()) then
            cancel_button_background:SetImageColor(Color(105,10,10))
        else
            cancel_button_background:SetImageColor(Color(134,9,9))
        end
    end

    cancel_button.DoClick = function()
        blur_modal_panel:Remove()
    end

    cancel_button_background = vgui.Create("DImage", cancel_button)
    cancel_button_background:Dock(FILL)
    cancel_button_background:DockMargin(0,26,0,16)
    cancel_button_background:SetImage(GST_SNK.Images.BUTTON_BACKGROUND_2)

    cancel_button_border = vgui.Create("DImage", cancel_button)
    cancel_button_border:SetPos(0,0)
    cancel_button_border:Dock(FILL)
    cancel_button_border:SetImage(GST_SNK.Images.BUTTON_1)

    cancel_button_text = vgui.Create("DLabel", cancel_button_border)
    cancel_button_text:Dock(FILL)
    cancel_button_text:SetText("")

    cancel_button_text.Paint = function(self, w, h)
        draw.SimpleText("Annuler", "default_snk_small", w / 2, h / 2 + 5, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end