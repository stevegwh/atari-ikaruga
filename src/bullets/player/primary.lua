local Bullet = require 'src.bullets.player.baseclass'

local PrimaryBullet = class('Primary', Bullet)
function PrimaryBullet:initialize(x, y, vx, vy, mode)
  -- local sprite = love.graphics.newQuad(64, 224, 32, 32, game.bullet_sprites:getWidth(),
  --                                      game.bullet_sprites:getHeight())
  -- local sprite = love.graphics.newQuad(416, 320, 32, 32, game.bullet_sprites:getWidth(),
  --                                      game.bullet_sprites:getHeight())
  local sprite = love.graphics.newImage('assets/sprites/bullet.png')
  local speed = 5
  local w = 64
  local h = 64
  local r2 = 10
  local sprite_scale = 2
  Bullet.initialize(self, x, y, r2, vx, vy, speed, sprite, w, h, sprite_scale, mode)
end

return PrimaryBullet
