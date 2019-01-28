local Shot = require 'src.shots.ShotBaseClass'

local SimpleSideShot = class('SimpleSideShot', Shot)
function SimpleSideShot:initialize(p)
  Shot.initialize(self, p)
end
function SimpleSideShot:getBullet()
  local velX = 200
  if self.pos.x < 300 then
    velX = -5
  else
    velX = -5
  end
  local bullet = Bullet:new(self.pos.x, self.pos.y, self.r/3, -5, 5, self.movementSpeed, self.sprite)
  table.insert(game.bullets, bullet)
end

return SimpleSideShot
