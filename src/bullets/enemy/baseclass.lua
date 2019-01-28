local Explosion = require 'src.explosion'
local sounds = require 'src.sounds'
local Bullet = class('Bullet')
Bullet:include(UpdateHitbox)
Bullet:include(DebugDraw)
Bullet:include(SetMode)

function Bullet:initialize(x, y, r2, vx, vy, speed, sprite, mode)
  self.speed = speed
  self.mode = mode
  self.pos = Vector(x, y)
  self.vel = Vector()
  self.acc = Vector(vx * speed, vy * speed) --sets the angle and speed
  --sprite dimensions
  self.sprite_scale = 1.25
  self.sprite = sprite.quad
  self.w = sprite.w
  self.h = sprite.h
  self.r = (self.w/2)*self.sprite_scale
  self.a = self:getHeading(vx, vy)
  --change hitbox r to make bullet bigger or smaller
  --r2 = hitbox radius
  self.hitbox = {x=0, y=0, r=r2}
  self.sfx_die = sounds.sfx_explode
end

function Bullet:getHeading(vx, vy)
  if vx > 0 and vy < vx or vx < 0 and vx < vy then
    return math.rad(90)
  else
    return math.rad(180)
  end
end

function Bullet:onCollision()
  self.pos.x = -1500
end

function Bullet:draw()
  --love2d can rotate the shape, might be useful to pass a param 1 bbmain
  local r,g,b,a = love.graphics.getColor()
  love.graphics.setColor(self:setMode())
  if self.a then
    love.graphics.draw(self.sprite, self.hitbox.x, self.hitbox.y, self.a,self.sprite_scale, self.sprite_scale, self.w/2, self.h/2)
  else
    love.graphics.draw(self.sprite, self.pos.x, self.pos.y, 0,self.sprite_scale, self.sprite_scale)
  end
  if ddebug then
    self:debugDraw()
    -- love.graphics.circle("fill", self.hitbox.x, self.hitbox.y, self.hitbox.r)
  end
  love.graphics.setColor(r,g,b,a)
end

function Bullet:update(dt)
  self.pos = self.pos + self.vel
  self.vel = self.vel + self.acc
  self.acc = self.acc * 0
  self:updateHitbox()
end

return Bullet
