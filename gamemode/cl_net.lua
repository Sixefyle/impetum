

net.Receive("GST:Titan_Grab", function()
    local titan = net.ReadEntity()
    titan:AddVCDSequenceToGestureSlot( 0, titan:LookupSequence("grab_player"), 0, true )
end)

net.Receive("GST:Titan_Grab_Manger", function()
    if CLIENT then
        local titan = net.ReadEntity()
        
        titan:AddVCDSequenceToGestureSlot( 0, titan:LookupSequence("grab_player_manger"), 0, true )
	end
end)

net.Receive("GST:Titan_Balayage", function()
    if CLIENT then
        local titan = net.ReadEntity()
        
        titan:AddVCDSequenceToGestureSlot( 0, titan:LookupSequence("balayage"), 0, true )
	end
end)

net.Receive("GST:Titan_Punch1", function()
    if CLIENT then
        local titan = net.ReadEntity()
        titan:AddVCDSequenceToGestureSlot( 0, titan:LookupSequence("punch1"), 0, true )
	end
end)

net.Receive("GST:Titan_Punch2", function()
    if CLIENT then
        local titan = net.ReadEntity()
        
        titan:AddVCDSequenceToGestureSlot( 0, titan:LookupSequence("punch2"), 0, true )
	end
end)

net.Receive("GST:Titan_Kick", function()
    if CLIENT then
        local titan = net.ReadEntity()
        
        titan:AddVCDSequenceToGestureSlot( 0, titan:LookupSequence("kick"), 0, true )
	end
end)

net.Receive("GST:Titan_Die", function()
    if CLIENT then
        local titan = net.ReadEntity()
        
        titan:AddVCDSequenceToGestureSlot( 0, titan:LookupSequence("titan_dying"), 0, true )
	end
end)