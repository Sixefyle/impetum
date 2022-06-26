-- 3DMG/OMG Rope
-- Author: mmys
-- See the main 3DMG file for header.
AddCSLuaFile()
ENT.Type = "anim" -- Default, but let's be safe.
ENT.ClassName = "rope"
--//////////////////////////////////////////////////////////////////////////////
-- Constants
local CABLE_MATERIAL = Material("cable/cable")
local CABLE_COLOUR = Color(180, 180, 180)
local CABLE_SPEED = 5000

function ENT:Initialize()
    self:DrawShadow(false)
    self:SetSolid(SOLID_NONE)
    self:SetNWFloat("stretchDist", 0.0)
    self.curTime = CurTime()

    self:SetNWBool("IsHooked", false)
end

function ENT:Draw()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    local origin = self:GetPos()
    origin.z = origin.z - 28.0 -- very hacky
    local destination = self:GetDestination()
    self:DrawCable(origin, destination)
end

function ENT:DrawCable(startPos, endPos)
    render.SetMaterial(Material("cable/cable2"))

    if self:GetNWBool("IsHooked") then
        render.DrawBeam(startPos, endPos, 1.0, 0.0, endPos:Distance(startPos), CABLE_COLOUR)
    else
        local distance = endPos:Distance(startPos)
        local stretched = self:GetNWFloat("stretchDist")
        local nowTime = CurTime()
        stretched = stretched + (CABLE_SPEED * (nowTime - self.curTime))

        if stretched > distance then
            stretched = distance
            self:SetNWBool("IsHooked", true)
        end

        render.DrawBeam(startPos, startPos + (endPos - startPos) * (stretched / distance), 2.0, 0.0, stretched, CABLE_COLOUR)
        self.curTime = nowTime
        self:SetNWFloat("stretchDist", stretched)
    end

end

function ENT:SetDestination(pos)
    self:SetNWVector("destination", pos)
end

function ENT:GetDestination()
    return self:GetNWVector("destination")
end

function ENT:IsHooked()
    return self:GetNWBool("IsHooked")
end

-- The empty stub of shame. Don't look at it. It's too sad. :(
function ENT:Think()
end
-- ...