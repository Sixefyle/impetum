GST_SNK.Utils = {}


function GST_SNK.Utils:GetWorldHeightPos(pos)
    local trace = util.TraceLine( {
        start = pos,
        endpos = pos + Angle(90,0,0):Forward() * 10000
    })

    if (trace.HitNoDraw) then
        trace = util.TraceLine( {
            start = pos + Vector(0,0,1000),
            endpos = pos + Angle(90,0,0):Forward() * 10000
        })
    end

    return trace.HitPos
end