util.AddNetworkString("FireSkill")
util.AddNetworkString("FireTitanSkill")
util.AddNetworkString("ReceiveTeamsInfo")
util.AddNetworkString("PlaySound")

util.AddNetworkString("GST:DoAnimation")

net.Receive("FireSkill", function(len, ply)
    local skill = net.ReadEntity()

    if (IsValid(skill)) then
        skill:PrimaryAttack()
    end
end)

net.Receive("FireTitanSkill", function(len, ply)
    local skillId = net.ReadUInt(3)

    if (skillId) then
        local weap = ply:GetActiveWeapon()
        weap:DoSkill(skillId)
    end
end)