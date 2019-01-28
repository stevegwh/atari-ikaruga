local sprites = require 'src.sprites'
local Explosion = class('Explosion')
Explosion:include(Animate)

function Explosion:initialize(x, y)
  self.pos = Vector(x, y)
  -- self.sprite = love.graphics.newImage('assets/sprites/blast.png')
  self.sprite = sprites.explosion.quad
  self.sprite2 = sprites.blast.quad
  self.sprite_scale = 0.1
  self.sprite_scale_wave = 0.3
  self.a = math.rad(0.1)
end

function Explosion:draw()
  local r,g,b,a = love.graphics:getColor()
  local random = math.random(2)
  if random == 1 then
    love.graphics.setColor(0.3, 0, 0.6, 0.4)
  else
    love.graphics.setColor(0, 0, 0.2, 0.3)
  end
  love.graphics.draw(self.sprite, self.pos.x, self.pos.y, self.a, self.sprite_scale, self.sprite_scale, self.sprite:getWidth()/2, self.sprite:getHeight()/2)
  love.graphics.setColor(r, g, b, a)

  love.graphics.draw(self.sprite2, self.pos.x, self.pos.y, self.a, self.sprite_scale_wave, self.sprite_scale_wave, self.sprite2:getWidth()/2, self.sprite2:getHeight()/2, 1, 0)
  love.graphics.draw(self.sprite2, self.pos.x, self.pos.y, self.a, self.sprite_scale_wave, self.sprite_scale_wave, self.sprite2:getWidth()/2, self.sprite2:getHeight()/2, 0.5, 1)
end

function Explosion:update(dt)
  if self.sprite_scale < 0.4 and self.sprite_scale_wave < 0.7 then
    self.sprite_scale = self.sprite_scale + 0.03
    self.sprite_scale_wave = self.sprite_scale_wave + 0.05
    self.a = self.a + math.rad(20)
  else
    self.pos.x = -1500
  end
end

return Explosion
