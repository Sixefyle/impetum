net.Receive("GST:DoAnimation", function()
    local titan = net.ReadEntity()
    local animationName = net.ReadString()
    local time = net.ReadUInt(8)
    local oldSeq = titan:GetSequence()

    titan:AddVCDSequenceToGestureSlot(0, titan:LookupSequence(animationName), 0, time == 0)

    if (time > 0) then
        timer.Simple(time, function()
            if (titan:GetNWString("doAnimation") == animationName) then
                titan:AddVCDSequenceToGestureSlot(0, oldSeq, 0, false)
            end
        end)
    end
end)

net.Receive("ReceiveTeamPoints", function()
    GAMEMODE.EldienPoints = net.ReadUInt(8)
    GAMEMODE.MahrPoints = net.ReadUInt(8)
end)

net.Receive("ReceiveTeamsInfo", function()
    GAMEMODE.EldienPoints = net.ReadUInt(8)
    GAMEMODE.MahrPoints = net.ReadUInt(8)
    local index = 1

    while index <= 3 do
        color = net.ReadColor()
        LocalPlayer().flagsColor[index] = color
        index = index + 1
    end
end)

net.Receive("ReceiveServerClassInfo", function()
    GST_SNK.Classes = net.ReadTable()
end)

net.Receive("PlaySound", function()
    LocalPlayer():EmitSound(net.ReadString(), 75, 100, .3)
end)