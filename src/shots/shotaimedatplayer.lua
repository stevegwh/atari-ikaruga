local Shot = require 'src.shots.ShotBaseClass'
local ShotAimedAtPlayer = class('ShotAimedAtPlayer', Shot)
function ShotAimedAtPlayer:initialize(p)
  local sfx_shot = love.audio.newSource('assets/sfx/shot1.ogg', 'static')
  Shot.initialize(self, p, sfx_shot)
end

function ShotAimedAtPlayer:getBullet()
  self:playSound()
  local velx = self.pos.x - (player.hitbox.x - self.sprite.w/2) -- 16 is half the width of the bullet sprite
  local vely = self.pos.y - (player.hitbox.y - self.sprite.h/2)
  local vel = Vector(velx, vely)
  vel = vel.normalized
  local speed = 10
  local bullet = Bullet:new(self.pos.x, self.pos.y, self.r/3, -vel.x, -vel.y, speed, self.sprite,self.mode)
  table.insert(game.bullets, bullet)
end

return ShotAimedAtPlayer
