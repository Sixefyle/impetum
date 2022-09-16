include("shared.lua")

local matBall = Material("textures/Ship/cannonball")


function ENT:Draw()
  self:DrawModel()
end
