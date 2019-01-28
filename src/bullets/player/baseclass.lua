local Bullet = class('Bullet')
Bullet:include(DebugDraw)
Bullet:include(CheckQuadCollisions)
Bullet:include(SetMode)

function Bullet:initialize(x, y, r2, vx, vy, speed, sprite, w, h, sprite_scale, mode)
  self.mode = mode
  self.speed = speed
  self.pos = Vector(x, y)
  self.vel = Vector()
  self.acc = Vector(vx * speed, vy * speed) --sets the angle and speed
  --sprite dimensions
  self.sprite_scale = sprite_scale
  self.sprite = sprite
  self.w = w
  self.h = h
  self.r = (self.w/2)*self.sprite_scale
  --change hitbox r to make bullet bigger or smaller
  --r2 = hitbox radius
  self.hitbox = {x=0, y=0, r=r2}
end

function Bullet:draw()
  local r,g,b,a = love.graphics.getColor()
  love.graphics.setColor(self:setMode())
  love.graphics.draw(self.sprite, self.pos.x, self.pos.y, 0, self.sprite_scale, self.sprite_scale)
  -- love.graphics.draw(game.bullet_sprites, self.sprite, self.pos.x, self.pos.y, 0, self.sprite_scale, self.sprite_scale)
  love.graphics.setColor(r,g,b,a)
  if ddebug then
    self:debugDraw()
  end
end

function Bullet:updateHitbox()
  self.hitbox.x = self.pos.x + (self.w * self.sprite_scale)/2
  self.hitbox.y = self.pos.y + (self.h * self.sprite_scale)/2
  self:checkCollisions()
end

function Bullet:setPower() --TODO; make this a property in init
    return 1
end

function Bullet:isOutOfBounds()
  return self.pos.x > GAME_WIDTH + self.w or self.pos.y > GAME_HEIGHT + self.h or self.pos.x < 0 - self.w or self.pos.y < 0 - self.h
end

function Bullet:die()
  self.pos.x = -1500
end

function Bullet:checkCollisions()
  local collisions = quadtree:collidables({left=self.hitbox.x,top=self.hitbox.y,width=self.hitbox.r,height=self.hitbox.r})
  self:checkQuadCollisions(self, collisions, function(o)
      local e = collisions[o].ref
      if e.class.name == "Bullet" then --this should be easier
        return
      end
      e:hit(1)
      self:die()
      if e.hp <= 0 then e:onCollision("bullet") end
  end)
end

function Bullet:update(dt)
  self.pos = self.pos + self.vel
  self.vel = self.vel + self.acc
  self.acc = self.acc * 0
  self:updateHitbox()
  if self:isOutOfBounds() then
    self:die()
  end
end

return Bullet
