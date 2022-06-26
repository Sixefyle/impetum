util.AddNetworkString("FireSkill")
util.AddNetworkString("GST:Titan_Grab")
util.AddNetworkString("GST:Titan_Grab_Manger")
util.AddNetworkString("GST:Titan_Balayage")
util.AddNetworkString("GST:Titan_Punch1")
util.AddNetworkString("GST:Titan_Punch2")
util.AddNetworkString("GST:Titan_Kick")
util.AddNetworkString("GST:Titan_Die")


net.Receive("FireSkill", function(len, ply)
    local skill = net.ReadEntity()

    if (IsValid(skill)) then
        skill:PrimaryAttack()
    end
end)