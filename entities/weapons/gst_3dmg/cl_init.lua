include('shared.lua')

function SWEP:Deploy()
    
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire( CurTime() + 1 )
    self:SetWeaponHoldType( "melee" )
    self:EmitSound( "weapons/iceaxe/iceaxe_swing1.wav" )
    self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
    self:PrimarySlash()
    timer.Simple(.45, function() self:SetWeaponHoldType( "normal" ) end)

    self:GetOwner():WeaponCooldownBar(CurTime() + .8)
end

function SWEP:PrimarySlash()
    self:SendWeaponAnim(ACT_VM_HITCENTER)
end

hook.Add( "PostDrawTranslucentRenderables", "test", function()

	-- -- Set the draw material to solid white
	-- render.SetColorMaterial()
    -- local weap = LocalPlayer():GetActiveWeapon()
    -- if(weap and weap:GetClass() == "gst_3dmg") then
    --     render.DrawWireframeBox(LocalPlayer():EyePos(), LocalPlayer():EyeAngles(), weap.DetectBox.mins, weap.DetectBox.maxs, Color(255,0,0), true)
    -- end
end )