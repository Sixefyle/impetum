util.AddNetworkString("AOTA:TS:FireSkill")
util.AddNetworkString("AOTA:TS:FireTitanSkill")
util.AddNetworkString("AOTA:TC:ReceiveTeamsInfo")
util.AddNetworkString("AOTA:TC:PlaySound")
util.AddNetworkString("AOTA:TC:PlayLoopSound")
util.AddNetworkString("AOTA:TC:StopLoopSound")
util.AddNetworkString("AOTA:TC:ReceiveNewCapturedPoint") -- capture_point

util.AddNetworkString("AOTA:TC:DoAnimation")

net.Receive("AOTA:TS:FireSkill", function(len, ply)
    local skill = net.ReadEntity()

    if (IsValid(skill)) then
        skill:PrimaryAttack()
    end
end)

net.Receive("AOTA:TS:FireTitanSkill", function(len, ply)
    local skillId = net.ReadUInt(3)

    if (skillId) then
        local weap = ply:GetActiveWeapon()
        weap:DoSkill(skillId)
    end
end)