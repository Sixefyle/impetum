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

function GM:HandlePlayerJumping(ply, velocity)
	if (string.match(ply:GetModel(), "titan")) then
		return
	end
end

function GM:CalcMainActivity(ply, velocity)
	ply.CalcIdeal = ACT_MP_STAND_IDLE
	ply.CalcSeqOverride = -1

	self:HandlePlayerLanding( ply, velocity, ply.m_bWasOnGround )

	if !( self:HandlePlayerNoClipping( ply, velocity ) ||
		self:HandlePlayerDriving( ply ) ||
		self:HandlePlayerVaulting( ply, velocity ) ||
		self:HandlePlayerJumping( ply, velocity ) ||
		self:HandlePlayerSwimming( ply, velocity ) ||
		self:HandlePlayerDucking( ply, velocity ) ) then

		local len2d = velocity:Length2DSqr()
		if ( len2d > 22500) then
			ply.CalcIdeal = ACT_MP_RUN
		elseif ( len2d > 0.25 ) then
			 ply.CalcIdeal = ACT_MP_WALK
		end
	end

	ply.m_bWasOnGround = ply:IsOnGround()
	ply.m_bWasNoclipping = ( ply:GetMoveType() == MOVETYPE_NOCLIP && !ply:InVehicle() )

	if (string.len(ply:GetNWString("doAnimation")) > 0) then
		ply.CalcSeqOverride = ply:LookupSequence(ply:GetNWString("doAnimation"))
	end

	return ply.CalcIdeal, ply.CalcSeqOverride
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