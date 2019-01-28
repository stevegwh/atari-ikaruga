require 'src.constants'
local Shot = require 'src.shots.ShotBaseClass'
-- totalBulletAmount refers to the amount of bullets per rotation
local Spiral = class('Spiral', Shot)
function Spiral:initialize(p)
  self.maxRotations = p.maxR
  self.rotations = 1
  Shot.initialize(self, p)
end

function Spiral:getBullet()
  local a = math.rad((360/self.totalBulletAmount/self.maxRotations)*self.bulletCounter)
  if a * self.maxRotations > math.pi*self.rotations*2 then
    self.rotations = self.rotations + 1
  end
  self.bulletSpeed = self.bulletSpeed + 0.001
  local bullet = Bullet:new(self.pos.x, self.pos.y, self.r/3, math.cos(a * self.maxRotations), math.sin(a * self.maxRotations), self.bulletSpeed, self.sprite, self.mode)
  table.insert(game.bullets, bullet)
end

function Spiral:update(dt)
  if self.shotTimer >= self.fireRate and self.rotations ~= self.maxRotations then
    self:playSound()
    self.shotTimer = 0
    self.bulletCounter = self.bulletCounter + 1
    self:getBullet()
  else
    self.shotTimer = self.shotTimer + dt
  end
  self.complete = self.rotations == self.maxRotations
end

--[[ function Spiral:getBullet()
  local a = math.rad(((self.maxAngle - self.startAngle) / self.totalBulletAmount) * self.bulletCounter)
  local bullet = Bullet:new(self.pos.x, self.pos.y, self.r/3, math.cos(a * self.k),math.sin(a * self.k), self.bulletSpeed, self.sprite)
  table.insert(game.bullets, bullet)
end ]]

return Spiral
