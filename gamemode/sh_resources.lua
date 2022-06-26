local base_image_path = "gst/impetum/images/"

GST_SNK = {}

GST_SNK.Images = {
	["BUTTON_1"] = base_image_path .. "button/button.png",
	["BUTTON_2"] = base_image_path .. "button/button2.png",
	["BUTTON_BACKGROUND_1"] = base_image_path .. "button/button_background.png",
	["BUTTON_BACKGROUND_2"] = base_image_path .. "button/button_background2.png",

	["TAB_MENU_HEADER"] = base_image_path .. "scoreboard/header.png",
	["TAB_MENU_BACKGROUND_END"] = base_image_path .. "scoreboard/background_end.png",
	["TAB_MENU_BACKGROUND_MID"] = base_image_path .. "scoreboard/background_middle.png",
	["TAB_MENU_BACKGROUND_START"] = base_image_path .. "scoreboard/background_first.png",
	["TAB_MENU_USER_ELDIEN"] = base_image_path .. "scoreboard/user_eldien.png",
	["TAB_MENU_USER_MAHR"] = base_image_path .. "scoreboard/user_mahr.png",
	["TAB_MENU_USER_PRIMORDIAL"] = base_image_path .. "scoreboard/user_primo.png",
	["TAB_MENU_USER_TITAN"] = base_image_path .. "scoreboard/user_titan.png",

	["BUILD_SELECTOR_BACKGROUND"] = base_image_path .. "hud/build_selector_background.png",
	["BUILD_SELECTOR_BUTTON"] = base_image_path .. "hud/build_selector_button.png",

    ["TEAM_SELECTION_BACK"] = base_image_path .. "team_selection_back.png",
    ["TEAM_SELECTION_BORDER"] = base_image_path .. "team_selection_border.png",


	["CLASS_SELECTION_ELDIEN"] = base_image_path .. "class_selection_eldien.png",
    ["CLASS_SELECTION_PRIMORDIAL"] = base_image_path .. "class_selection_primordial.png",
    ["CLASS_SELECTION_TITAN"] = base_image_path .. "class_selection_titan.png",
	["CLASS_SELECTION_MAHR"] = base_image_path .. "class_selection_mahr.png",
	["CLASS_SELECTION_CONFIRMATION_POPUP"] = base_image_path .. "class_selection_buy_confirmation.png",

	["CLASS_SELECTION_BAR"] = base_image_path .. "class_bar.png",
	["CLASS_SELECTION_BAR_TITLE"] = base_image_path .. "class_bar_title.png",

	["CLASS_ICON_ATTACK"] = base_image_path .. "icon/titan_attack.png",
    ["CLASS_ICON_JAW"] = base_image_path .. "icon/titan_jaw.png",
    ["CLASS_ICON_FEMALE"] = base_image_path .. "icon/titan_female.png",
	["CLASS_ICON_COLOSSAL"] = base_image_path .. "icon/titan_colossal.png",
	["CLASS_ICON_CART"] = base_image_path .. "icon/titan_cart.png",
    ["CLASS_ICON_BEAST"] = base_image_path .. "icon/titan_beast.png",
    ["CLASS_ICON_WARHAMMER"] = base_image_path .. "icon/primordial_warhammer.png",
	["CLASS_ICON_ARMORED"] = base_image_path .. "icon/primordial_armored.png",

	["CLASS_ICON_ELDIEN_ACKERMAN"] = base_image_path .. "icon/eldien_ackerman.png",
    ["CLASS_ICON_ELDIEN_ARTILLERY"] = base_image_path .. "icon/eldien_artillery.png",
    ["CLASS_ICON_ELDIEN_BAP"] = base_image_path .. "icon/eldien_bap.png",
	["CLASS_ICON_ELDIEN_BUILDER"] = base_image_path .. "icon/eldien_builder.png",
	["CLASS_ICON_ELDIEN_DEMOLISHER"] = base_image_path .. "icon/eldien_demolisher.png",
    ["CLASS_ICON_ELDIEN_ENGINEER"] = base_image_path .. "icon/eldien_engineer.png",
    ["CLASS_ICON_ELDIEN_GUNNER"] = base_image_path .. "icon/eldien_gunner.png",
	["CLASS_ICON_ELDIEN_HEALER"] = base_image_path .. "icon/eldien_healer.png",
	["CLASS_ICON_ELDIEN_MEDIC"] = base_image_path .. "icon/eldien_medic.png",
    ["CLASS_ICON_ELDIEN_SCOUT"] = base_image_path .. "icon/eldien_scout.png",
    ["CLASS_ICON_ELDIEN_SOLDIER"] = base_image_path .. "icon/eldien_soldier.png",
	["CLASS_ICON_ELDIEN_SUPPLIER"] = base_image_path .. "icon/eldien_supplier.png",
	["CLASS_ICON_ELDIEN_TANK"] = base_image_path .. "icon/eldien_tank.png",
    ["CLASS_ICON_ELDIEN_TRAPPER"] = base_image_path .. "icon/eldien_trapper.png",
    ["CLASS_ICON_ELDIEN_VETERAN"] = base_image_path .. "icon/eldien_veteran.png",

	["CLASS_ICON_MAHR_MAGATH"] = base_image_path .. "icon/mahr_magath.png",
    ["CLASS_ICON_MAHR_ARTILLERY"] = base_image_path .. "icon/mahr_artillery.png",
    ["CLASS_ICON_MAHR_BAP"] = base_image_path .. "icon/mahr_bap.png",
	["CLASS_ICON_MAHR_BUILDER"] = base_image_path .. "icon/mahr_builder.png",
	["CLASS_ICON_MAHR_DEMOLISHER"] = base_image_path .. "icon/mahr_demolisher.png",
    ["CLASS_ICON_MAHR_ENGINEER"] = base_image_path .. "icon/mahr_engineer.png",
    ["CLASS_ICON_MAHR_GUNNER"] = base_image_path .. "icon/mahr_gunner.png",
	["CLASS_ICON_MAHR_HEALER"] = base_image_path .. "icon/mahr_healer.png",
	["CLASS_ICON_MAHR_MEDIC"] = base_image_path .. "icon/mahr_medic.png",
    ["CLASS_ICON_MAHR_SCOUT"] = base_image_path .. "icon/mahr_scout.png",
    ["CLASS_ICON_MAHR_SOLDIER"] = base_image_path .. "icon/mahr_soldier.png",
	["CLASS_ICON_MAHR_SUPPLIER"] = base_image_path .. "icon/mahr_supplier.png",
	["CLASS_ICON_MAHR_TANK"] = base_image_path .. "icon/mahr_tank.png",
    ["CLASS_ICON_MAHR_TRAPPER"] = base_image_path .. "icon/mahr_trapper.png",
    ["CLASS_ICON_MAHR_VETERAN"] = base_image_path .. "icon/mahr_veteran.png",

	["SKILL_HUMAN_ELDIEN_HEALER"] = base_image_path .. "skills/human/eldien/eldien_cap_healer.png",
	["SKILL_HUMAN_ELDIEN_HEALER_BACK"] = base_image_path .. "skills/human/eldien/eldien_cap_healer_wb.png",

	["SKILL_HUMAN_ELDIEN_ARTILLERY"] = base_image_path .. "skills/human/eldien/eldien_cap_artillery.png",
	["SKILL_HUMAN_ELDIEN_ARTILLERY_BACK"] = base_image_path .. "skills/human/eldien/eldien_cap_artillery_wb.png",

	["PLAYER_HUD"] = base_image_path .. "hud/hud.png",
	["PLAYER_HUD_GAZ"] = base_image_path .. "hud/gaz.png",
}

if CLIENT then
	GST_SNK.Fonts = {
		["DEFAULT"] = "Rise Of Kingdom",
		["GOTHAM"] = "Gotham"
	}

	surface.CreateFont( "default_snk", {
		font = GST_SNK.Fonts.DEFAULT,
		extended = false,
		size = 48,
		weight = 500,
		antialias = true,

	} )

	surface.CreateFont( "default_snk_normal", {
		font = GST_SNK.Fonts.DEFAULT,
		extended = false,
		size = 24,
		weight = 500,
		antialias = true,
	} )

	surface.CreateFont( "default_snk_small", {
		font = GST_SNK.Fonts.DEFAULT,
		extended = false,
		size = 19,
		weight = 500,
		antialias = true,
	} )


	surface.CreateFont( "default_snk_very_small", {
		font = GST_SNK.Fonts.DEFAULT,
		extended = false,
		size = 17,
		weight = 500,
		antialias = true,
	} )

	surface.CreateFont( "default_snk_15", {
		font = GST_SNK.Fonts.DEFAULT,
		extended = false,
		size = 15,
		weight = 500,
		antialias = true,
	} )

	surface.CreateFont( "gotham", {
		font = GST_SNK.Fonts.GOTHAM,
		extended = false,
		size = 17,
		weight = 500,
		antialias = true,
	} )


	surface.CreateFont( "gotham_19", {
		font = GST_SNK.Fonts.GOTHAM,
		extended = false,
		size = 19,
		weight = 500,
		antialias = true,
	} )

	surface.CreateFont( "gotham_24", {
		font = GST_SNK.Fonts.GOTHAM,
		extended = false,
		size = 24,
		weight = 500,
		antialias = true,
	} )
end
