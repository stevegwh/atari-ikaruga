require 'src.constants'
require 'src.shots.shots'
local Explosion = require 'src.explosion'
local sounds = require 'src.sounds'

local Enemy = class('Enemy')
Enemy:include(UpdateHitbox)
Enemy:include(DebugDraw)

function Enemy:initialize(x, y, hp, sprite, mode, directions)
  --position
  self.mode = mode --blue or red
  self.pos = {x=x, y=y}
  self.dirIndex = 1
  if directions then
    self.directions = directions
    local e = self.directions[1]
    self.t = tween.new(e.t, self.pos, e.pos, e.e)
  end
  --sprite and animations
  self.sprite_sheet = love.graphics.newImage('assets/sprites/enemy_sheet.png')
  self.sprite = sprite
  self.sprite_scale = self.sprite.scale
  self.w = self.sprite.w
  self.h = self.sprite.h
  self.animations = self.sprite.animations
  self.r = (self.w*self.sprite_scale)/2
  self.current_animation = "still"
  --hitbox, change r to make actual hitbox bigger or smaller
  self.hitbox = {x=0, y=0, r=self.r}
  --assets
  self.sfx_explode = sounds.sfx_explode
  self.sfx_hit = sounds.sfx_hit
  self.sfx_shoot = sounds.sfx_shoot 
  self.sfx_die = sounds.sfx_explode
  self.sfx_die:setVolume(0.5)
  self.sfx_hit:setVolume(0.2)
  --misc
  self.hp = hp
  self.a = 2
end

function Enemy:onCollision(mode)
  if mode == "bullet" then
  end
  if self.sfx_die:isPlaying() then
    self.sfx_die:stop()
  end
  self.sfx_die:play()
  local explosion = Explosion:new(self.hitbox.x, self.hitbox.y)
  table.insert(game.explosions, explosion)
  self.pos.x = -1500
end

function Enemy:hit(strength, mode)
  if self.mode == mode then
    self.hp = self.hp - strength
  else
    self.hp = self.hp - strength*2
  end
  self.sfx_hit:play()
end

function Enemy:draw()
  if ddebug then
    self:debugDraw()
  end
  if self.animations then
    self.animations[self.current_animation]:draw(self.sprite_sheet, self.pos.x, self.pos.y, 0, self.sprite_scale, self.sprite_scale)
  else 
    -- love.graphics.draw(self.sprite_sheet, self.sprite.quad, self.pos.x, self.pos.y, 0, self.sprite_scale, self.sprite_scale)
    love.graphics.draw(self.sprite.quad, self.pos.x, self.pos.y, self.a, self.sprite_scale, self.sprite_scale)
  end
end

function Enemy:animate(dt)
  if self.animations then
    self.animations[self.current_animation]:update(dt)
  end
end

function Enemy:update(dt)
  local current = self.directions[self.dirIndex]
  local tweenComplete = self.t:update(dt)
  if tweenComplete and self.dirIndex < #self.directions then
    if not current.patterns then
      self.dirIndex = self.dirIndex + 1
      local e = self.directions[self.dirIndex]
      self.t = tween.new(e.t, self.pos, e.pos, e.e)
      return 
    end
    local allComplete = false
    for index, pattern in pairs(current.patterns) do
      if not pattern.complete then
        pattern.pos.x = (self.pos.x + (self.sprite.w/2)*self.sprite_scale) - pattern.sprite.w/2
        pattern.pos.y = (self.pos.y + (self.sprite.h/2)*self.sprite_scale) - pattern.sprite.h /2
        pattern:update(dt)
      else
        allComplete = index == #current.patterns + 1
      end
    end
    if allComplete then
      current.patterns = nil --null table to satisify condition above and continue
    end
  end
  self:updateHitbox()
  self:animate(dt)
end

-- Enemy update with a single pattern, doesn't iterate through a patterns table
-- function Enemy:update(dt)
--   local current = self.directions[self.dirIndex]
--   local tweenComplete = self.t:update(dt)
--   if tweenComplete and self.dirIndex < #self.directions then
--     if current.pattern and not current.pattern.complete then
--       current.pattern.pos.x = (self.pos.x + (self.sprite.w/2)*self.sprite_scale) - current.pattern.sprite.w/2
--       current.pattern.pos.y = (self.pos.y + (self.sprite.h/2)*self.sprite_scale) - current.pattern.sprite.h /2
--       current.pattern:update(dt)
--     else
--       self.dirIndex = self.dirIndex + 1
--       local e = self.directions[self.dirIndex]
--       self.t = tween.new(e.t, self.pos, e.pos, e.e)
--     end
--   end
--
--   self:updateHitbox()
--   self:animate(dt)
-- end

TweenMob = class('TweenMob', Enemy)
function TweenMob:initialize(x, y, sprite, mode, directions)
  local hp = 20
  Enemy.initialize(self, x, y, hp, sprite, mode, directions)
end


RegularMob = class('RegularMob', Enemy)
function RegularMob:initialize(x,y,speed,sprite,mode)
  local hp = 1
  self.shot = nil
  self.speed = speed
  Enemy.initialize(self, x, y, hp, sprite,mode)
end

function RegularMob:update(dt)
  self.pos.y = self.pos.y + self.speed
  self:updateHitbox()
  self:animate(dt)
end

SineWave = class('SineWave', Enemy)
function SineWave:initialize(x,y,speed,a,sprite,mode)
  local hp = 1
  self.angleChange = a
  self.shot = nil
  self.speed = speed
  Enemy.initialize(self, x, y, hp, sprite,mode)
end

function SineWave:update(dt)
  self.a = self.a + self.angleChange
  self.pos.y = self.pos.y + self.speed
  self.pos.x = self.pos.x + math.cos(self.a);
  self:updateHitbox()
  self:animate(dt)
end

LoopingEnemy = class('LoopingEnemy', Enemy)
function LoopingEnemy:initialize(x,y,speed,sprite,mode)
  self.startLoop = false
  self.a = 0.1
  local hp = 1
  self.speed = speed
  Enemy.initialize(self, x, y, hp, sprite,mode)
end

function LoopingEnemy:update(dt)
  if self.pos.y > GAME_HEIGHT/2 then
    self.startLoop = true
  end
  if self.startLoop  and self.a < 8 then
    self.a = self.a + 0.1
    local a = self.a
    if self.pos.x < WINDOW_WIDTH/2 then a = -self.a else a = self.a end
    self.pos.x = self.pos.x + math.sin(a) * self.speed
    self.pos.y = self.pos.y + math.cos(a) * self.speed
  elseif self.a > 8 then
    if self.pos.x < WINDOW_WIDTH/2 then
      self.pos.x = self.pos.x - self.speed
    else
      self.pos.x = self.pos.x + self.speed
    end
  else
    self.pos.y = self.pos.y + self.speed
  end

  self:updateHitbox()
  self:animate(dt)
end

ShootingStar = class('ShootingStar', Enemy)
function ShootingStar:initialize(p)
  local x = love.math.random(0, WINDOW_WIDTH)
  local y = love.math.random(0, -500)
  local hp = 1
  self.bulletSprite = p.bulletSprite
  self.shot = nil
  self.exploded = false
  self.speed = p.speed
  if p.target then
    self.target = p.target
  else
    self.target = Vector(love.math.random(500), love.math.random(800))
  end
  self.vel = Vector()
  Enemy.initialize(self, x, y, hp, p.sprite,p.mode)
end

function ShootingStar:update(dt)
  if not self.exploded then
    self:updateHitbox()
    self:animate(dt)
    self.a = self.a + dt * math.pi/2
    self.a = self.a % (2*math.pi)
    if self.target.y <= self.pos.y then --assumes will always be above
      local explosion = Explosion:new(self.pos.x, self.pos.y)
      table.insert(game.explosions, explosion)
      local p = {x=self.pos.x,y=self.pos.y,tba=4,fr=0.1,bs=3,r=16,
                startA=0,maxA=360,tsa=1,mode=self.mode, sprite=self.bulletSprite}
      self.shot = Ring:new(p)
      self.pos.y = -200
      self.exploded = true
    else
      local vel = self.target - self.pos
      vel = vel.normalized * self.speed
      self.pos = self.pos + vel
    end
  else
    if self.shot.complete then
      self.pos.x = -2000
    else
      self.shot:update(dt)
    end
  end
end


local Boss = class('Boss', Enemy)

function Boss:initialize()
  local sprite = x
  self.w = self.sprite.w
  self.h = self.sprite.h

  Enemy:initialize(x, y, hp, sprite, directions)
end



