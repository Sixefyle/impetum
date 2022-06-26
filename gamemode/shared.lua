---------------------------Info-----------------------------------
GM.Name = "Impetum"
GM.Author = "Sixefyle"
GM.Email = "N/A"
GM.Website = "https://discord.gg/peaCt8KYDG"
DeriveGamemode( "sandbox" )
------------------------------------------------------------------
function GM:Initialize()
	print("Lancement d'Impetum")
    self.BaseClass.Initialize( self )
end

//F1
function GM:ShowHelp( ply )
    ply:ConCommand( "team_menu" )
end

function GM:CalcMainActivity(ply, vel)
	-- if (ply:GetNWBool("testKick")) then
	-- 	return -1, ply:LookupSequence("kick")
	-- end
	-- return -1, ply:LookupSequence("grab_player")
end

if CLIENT then
	local function DoSkill(ply, skill)
		if (skill:CanPrimaryAttack()) then
			local oldWeap = ply:GetActiveWeapon()
			input.SelectWeapon(skill)
			timer.Simple(2, function()

				net.Start("FireSkill")
					net.WriteEntity(skill)
				net.SendToServer()
				skill:PrimaryAttack()

				timer.Simple(2, function()
					input.SelectWeapon(oldWeap)
				end)
			end)
		end
	end

	hook.Add("PlayerButtonDown", "DoPlayerSkill", function(ply, key)
		for i, skill in ipairs(ply:GetSkills()) do
			if (ply.preference.skill_key[i] == key) then
				DoSkill(ply, skill)
			end
		end
	end)
end