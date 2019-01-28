local CrissCrossWhip = require 'src.shots.whip'

local CrissCrossWhip = class('CrissCrossWhip', Whip)
function CrissCrossWhip:initialize(p)
  Whip.initialize(self, p)
end

function CrissCrossWhip:update(dt)
  if self.shotTimer >= self.fireRate and self.stepCounter ~= self.totalStepAmount then
    self.shotTimer = 0
    self.stepCounter = self.stepCounter + 1
    local temp = self.maxAngle
    self.maxAngle = self.startAngle
    self.startAngle = temp
    love.audio.play(self.sfx_shot)
    self:getBullet()
  else
    self.shotTimer = self.shotTimer + dt
  end
  self.complete = self.stepCounter == self.totalStepAmount
end

return CrissCrossWhip
