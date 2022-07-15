include("shared.lua")
include("sh_resources.lua")
include("cl_preference.lua")
include("sh_teams.lua")
include("sh_class.lua")
include("cl_net.lua")
include("utils.lua")

include("vgui/cl_hud.lua")
include("cl_menu.lua")
include("vgui/cl_scoreboard.lua")
include("vgui/cl_class_selection.lua")
include("vgui/cl_team_selection.lua")
include("vgui/cl_build_select.lua")
include("vgui/cl_winner_board.lua")
include("vgui/cl_preference.lua")

local GUIToggled = false
local mouseX, mouseY = ScrW() / 2, ScrH() / 2

function GM:PostDrawViewModel( vm, ply, weapon )
	if ( weapon.UseHands || !weapon:IsScripted() ) then

		local hands = LocalPlayer():GetHands()
		if ( IsValid( hands ) ) then hands:DrawModel() end

	end
end

function GM:ShowSpare1()
  
    GUIToggled = not GUIToggled

    if GUIToggled then
        gui.SetMousePos(mouseX, mouseY)
    else
        mouseX, mouseY = gui.MousePos()
    end
    gui.EnableScreenClicker(GUIToggled)
end

function PlayerSuicide(data)
	RunConsoleCommand("kill")
end

function GM:PlayerBindPress( pl, bind, down )

	return false

end

usermessage.Hook("PlayerSuicideAOT",PlayerSuicide)

hook.Add("PlayerButtonDown", "showCursor", function(ply, button)
    if (button == KEY_ESCAPE and gui.MouseX() ~= 0) then
        gui.EnableScreenClicker(false)
    end

    if (IsFirstTimePredicted() and button == KEY_F3) then
        gui.EnableScreenClicker(gui.MouseX() == 0)
    end
end)
