net.Receive("AOTA:TC:DoAnimation", function()
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

net.Receive("AOTA:TC:ReceiveTeamPoints", function()
    GAMEMODE.EldienPoints = net.ReadUInt(12)
    GAMEMODE.MahrPoints = net.ReadUInt(12)
end)

net.Receive("AOTA:TC:ReceiveNewCapturedPoint", function()
    local index = net.ReadUInt(2)
    local color = net.ReadColor()

    LocalPlayer().flagsColor[index] = color
end)

net.Receive("AOTA:TC:ReceiveTeamsInfo", function()
    GAMEMODE.EldienPoints = net.ReadUInt(8)
    GAMEMODE.MahrPoints = net.ReadUInt(8)
    local index = 1

    while index <= 3 do
        color = net.ReadColor()
        LocalPlayer().flagsColor[index] = color
        index = index + 1
    end
end)

net.Receive("AOTA:TC:ReceiveServerClassInfo", function()
    GST_SNK.Classes = net.ReadTable()
end)

net.Receive("AOTA:TC:PlaySound", function()
    local soundName = net.ReadString()
    LocalPlayer():EmitSound(soundName, 75, 100, .3)
end)

net.Receive("AOTA:TC:PlayLoopSound", function()
    LocalPlayer().loopingSound = LocalPlayer():StartLoopingSound(net.ReadString())
end)

net.Receive("AOTA:TC:StopLoopSound", function()
    if LocalPlayer().loopingSound then
        LocalPlayer():StopLoopingSound(LocalPlayer().loopingSound)
    end
end)


net.Receive("AOTA:TC:MutePlayer", function(length)
    local ply = net.ReadEntity()
    ply:SetMuted(true)
    LocalPlayer():ChatPrint(ply:GetName() .. " has been muted.")
end)

net.Receive("AOTA:TC:UnMutePlayer", function(length)
    local ply = net.ReadEntity()
    ply:SetMuted(false)
    LocalPlayer():ChatPrint(ply:GetName() .. " has been unmuted.")
end)