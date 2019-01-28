local Shot = require 'src.shots.ShotBaseClass'

local SpeedUpSpiral = class('SpeedUpSpiral', Shot)
function SpeedUpSpiral:initialize(p)
  self.maxAngle = p.maxA
  self.k = p.k
  Shot.initialize(self, p)
end

function SpeedUpSpiral:getBullet()
  self.fireRate = self.fireRate - 0.1
  self.bulletSpeed = self.bulletSpeed + 0.1
  local a = (self.maxAngle / self.totalBulletAmount) * self.bulletCounter
  local bullet = Bullet:new(self.pos.x, self.pos.y, self.r/3, math.cos(a * self.k),math.sin(a * self.k), self.bulletSpeed, self.sprite)
  table.insert(game.bullets, bullet)
end

return SpeedUpSpiral
