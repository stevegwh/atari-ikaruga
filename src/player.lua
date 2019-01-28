require 'src.constants'
local PrimaryBullet = require 'src.bullets.player.primary'
local Player = class('Player')
local Explosion = require 'src.explosion'

--mixins
Player:include(DrawTable)
Player:include(SetMode)
Player:include(DebugDraw)

function Player:initialize()
  --score stuff
  self.red = 0
  self.blue = 0
  self.score = 0
  self.lives = 3
  self.alive = true
  self.focus = false
  self.angle = 0
  self.mode = 'red'
  --items
  self.bullets = {}
  --vectors
  self.pos = Vector(GAME_WIDTH/2, GAME_HEIGHT - GAME_HEIGHT/4)
  self.vel = Vector(0, 0)
  self.w = 256
  self.h = 256
  self.speed = 8
  --hitbox
  self.r = 4 --a bit redundant
  self.hitbox = {x=0, y=0, r=4}
  --assets
  self.sprite = love.graphics.newImage('assets/sprites/player_spritesheet.png')
  self.focus_sprite = love.graphics.newImage('assets/sprites/focus.png')
  --timers
  self.primaryBulletTimer = 0
  self.deathTimer = 0
  --animation
  self.current_animation = "broll"
  local g = anim8.newGrid(self.w, self.h, self.sprite:getWidth(), self.sprite:getHeight())
  self.animations = {
    broll = anim8.newAnimation(g('1-6',1, '5-2', 1), 0.025, "pauseAtStart")
    -- left = anim8.newAnimation(g('3-6',2), 0.1),
    -- right = anim8.newAnimation(g('3-6', 3), 0.1),
  }
  self.sprite_scale = 0.3
  self.offset = 0
  --sfx
  self.sfx_die = love.audio.newSource('assets/sfx/death.ogg', 'static')
  self.sfx_longshot = love.audio.newSource('assets/sfx/shot1_loop.ogg', 'static')
  self.sfx_shot = love.audio.newSource('assets/sfx/shot1.ogg', 'static')
  self.sfx_shot:setVolume(0.05)
end

function Player:powerupCollect(mode)
  self[mode] = self[mode] + 1
  self.score = self.score + 1000
end

function Player:fireSound()
    if self.sfx_shot:isPlaying() then
      self.sfx_shot:stop()
    end
    self.sfx_shot:play()
end

function Player:fire(dt)
  local playerCenter = self.pos.x + (self.w*self.sprite_scale)/2
  if self.primaryBulletTimer > 0.05 then
    self:fireSound()
    table.insert(self.bullets, PrimaryBullet:new(playerCenter - 80, self.pos.y - self.h/2, 0, -5, self.mode))
    table.insert(self.bullets, PrimaryBullet:new(playerCenter - 48, self.pos.y - self.h/2, 0, -5, self.mode))
    self.primaryBulletTimer = 0
  end
end

function Player:listenForMove(dt)
  local x, y = input:get 'move'
  local speed = nil
  if input:down 'shift' then
    speed = self.speed / 2
    self.focus = true
  else
    speed = self.speed
    self.focus = false
  end
  if not input:down 'move' then
  end
  if input:released 'changeMode' then
    if self.mode == "purple" then
      return
    elseif self.mode == 'red' then
      self.mode = 'blue'
    else
      self.mode = 'red'
    end
    self.current_animation = "broll"
    self.animations[self.current_animation]:resume()
  end
  if input:down 'left' then
    -- self.current_animation = "left"
  end
  if input:down 'right' then
    -- self.current_animation = "right"
  end
  if input:down 'action' then
    self:fire(dt)
  end
  self:move(Vector(x * speed, y * speed))
end

function Player:move(nextPos)
  local next = self.pos + nextPos
  local playerW = (self.w * self.sprite_scale)
  local playerH = (self.h * self.sprite_scale) 
  --divided these so the player wouldn't stick to boundaries with analog controls
  if next.x + playerW/1.5 < GAME_WIDTH and next.x + playerW/2.5 > 0 then
    self.pos.x = self.pos.x + nextPos.x
  end
  if next.y + playerH < GAME_HEIGHT and next.y > 0 then
    self.pos.y = self.pos.y + nextPos.y
  end
end

function Player:die()
  love.audio.play(self.sfx_die)
  local explosion = Explosion:new(self.hitbox.x, self.hitbox.y)
  table.insert(game.explosions, explosion)
  self.alive = false
end


function Player:checkState(dt)
  if not self.alive and self.deathTimer < 2 then
    self.deathTimer = dt + self.deathTimer
  elseif self.deathTimer >= 2 then
    self.alive = true
    self.deathTimer = 0
  end
end


local getDist = function(a, b)
  local dx = b.x - a.x
  local dy = b.y - a.y
  return math.sqrt(dx * dx + dy * dy)
end

local checkCollision = function(a, b)
  local dist = getDist(a, b)
  return dist < a.r + b.r
end

function Player:checkQuadCollisions(a, b, callback)
  for j = #b, 1, -1 do
    if checkCollision(a, b[j].ref.hitbox) then
      callback(j)
      return
    end
  end
end

function Player:checkCollisions() --two loops when maybe one would be better
  local collisions = quadtree:collidables({left=self.hitbox.x,top=self.hitbox.y,width=self.hitbox.r,height=self.hitbox.r})
  self:checkQuadCollisions(self.hitbox, collisions, function(o)
      local e = collisions[o].ref
      self:die()
      e:onCollision()
      return
  end)
  local collisions2 = quadtree:collidables({left=self.hitbox.x,top=self.hitbox.y,width=self.focus_sprite:getWidth()/2,height=self.focus_sprite:getHeight()/2})
  local hitbox = {x=self.hitbox.x,y=self.hitbox.y,r=self.focus_sprite:getWidth()}
  self:checkQuadCollisions(hitbox, collisions2, function(o)
      local e = collisions[o].ref
      print(e.mode)
      if e.mode == self.mode or self.mode == "purple" then
        self:powerupCollect(e.mode)
        e:onCollision()
      end
  end)
end

function Player:updateHitbox()
  self.hitbox.x = self.pos.x + (self.w * self.sprite_scale)/2
  self.hitbox.y = self.pos.y + (self.h * self.sprite_scale)/2
  self.hitbox.y = self.hitbox.y - 5
end

function Player:draw()
  local r,g,b,a = love.graphics.getColor()
  love.graphics.setColor(self:setMode())
  -- love.graphics.draw(self.sprite, self.pos.x, self.pos.y, 0, self.sprite_scale, self.sprite_scale)
  love.graphics.draw(self.focus_sprite, self.hitbox.x, self.hitbox.y + 5, -self.angle, 1.2, 1.2, self.focus_sprite:getWidth() / 2, self.focus_sprite:getHeight() / 2)
  self.animations[self.current_animation]:draw(self.sprite, self.pos.x, self.pos.y, 0, self.sprite_scale, self.sprite_scale)
  love.graphics.setColor(r,g,b,a)

  if ddbug then
    love.graphics.circle('fill', self.hitbox.x, self.hitbox.y, self.hitbox.r)
  end

  if self.bomb then
    self.bomb:draw()
  end

end

function Player:update(dt)
  self:checkCollisions()
  self:checkState(dt)
  self:listenForMove(dt)
  self.animations[self.current_animation]:update(dt)
  self.primaryBulletTimer = self.primaryBulletTimer + dt
  self.secondaryBulletTimer = self.secondaryBulletTimer + dt
  self:updateHitbox()
  self.angle = self.angle + dt * math.pi/2
  self.angle = self.angle % (2*math.pi)
  if self.red + self.blue > 10 then
    self.mode = "purple"
  end
end

return Player




