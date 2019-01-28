local Bullet = require 'src.bullets.enemy.baseclass'

local SlowDownBullet = class ('SlowDownBullet', Bullet)
function SlowDownBullet:initialize(x, y, r, r2, vx, vy, speed, sprite, w, h)


  Bullet.initialize(self, x, y, r, r2, vx, vy, speed, sprite, w, h)
end

function SlowDownBullet:update()
  self.pos = self.pos + self.vel
  self.vel = self.vel + self.acc
  self.acc = self.acc * 0
  self:updateHitbox()
end


return SlowDownBullet
