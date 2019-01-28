local Ring = require 'src.shots.ring'

local Whip = class('Whip', Ring)
function Whip:initialize(p)
  self.startAngle = p.startA
  self.maxAngle = p.maxA
  self.stepCounter = 0
  self.totalStepAmount = p.tsa
  self.originalBulletSpeed = p.bs
  Ring.initialize(self, p)
end

function Whip:getBullet()
  self.bulletSpeed = self.originalBulletSpeed
  for a = math.rad(self.startAngle), math.rad(self.maxAngle), math.rad((self.maxAngle - self.startAngle)/self.totalBulletAmount) do
    self.bulletSpeed = self.bulletSpeed - (self.bulletSpeed/self.totalBulletAmount) * 2
    local velx = math.cos(a)
    local vely = math.sin(a)
    local bullet = Bullet:new(self.pos.x, self.pos.y, self.r/3, velx, vely, self.bulletSpeed, self.sprite)
    table.insert(game.bullets, bullet)
  end
  self.complete = true
end

return Whip

