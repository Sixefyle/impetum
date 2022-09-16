include('shared.lua')

function SWEP:PrimaryAttack()
    --self:GetOwner():GetViewModel(1):SetWeaponModel("models/weapons/gst/v_lame_fury.mdl", self)
    self:SetNextPrimaryFire(CurTime() + 1)
    self:SetWeaponHoldType("melee")
    self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    self:PrimarySlash()

    timer.Simple(.45, function()
        if IsValid(self) then
            self:SetHoldType("gizer_idle")
        end
    end)
end

function SWEP:PrimarySlash()
    self:SendWeaponAnim(ACT_VM_HITCENTER)
end

hook.Add( "PostDrawTranslucentRenderables", "test", function()

	-- -- Set the draw material to solid white
	-- render.SetColorMaterial()

	-- -- Draw the wireframe sphere!
    -- local weap = LocalPlayer():GetActiveWeapon()
	-- render.DrawLine(LocalPlayer():LocalToWorld(weap.DetectBox.mins), LocalPlayer():LocalToWorld(weap.DetectBox.maxs), Color(0,204,255), true)
    -- render.DrawWireframeBox(LocalPlayer():GetPos(), LocalPlayer():EyeAngles(), weap.DetectBox.mins, weap.DetectBox.maxs, Color(255,0,0), true)
end )