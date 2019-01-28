local Shot = require 'src.shots.ShotBaseClass'

local BikeWheel = class('BikeWheel', Shot)
function BikeWheel:initialize(p)
  self.k = p.k
  Shot.initialize(self, p)
end

function BikeWheel:getBullet()
  local bullets = {}
  for i=1, 8 do
    local a = 45 * i
    local bullet = Bullet:new(self.pos.x, self.pos.y, self.r/3, math.cos(a * self.k),math.sin(a * self.k), self.movementSpeed, self.sprite)
    table.insert(game.bullets, bullet)
  end
end

return BikeWheel
