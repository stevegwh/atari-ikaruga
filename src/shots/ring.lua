local Shot = require 'src.shots.ShotBaseClass'

local Ring = class('Ring', Shot)
function Ring:initialize(p)
  self.maxAngle = p.maxA
  self.startAngle = p.startA
  self.stepCounter = 0
  self.totalStepAmount = p.tsa
  -- if p.bulletType then
  --   self.bulletType = p.bulletType
  -- else
    self.bulletType = Bullet
  -- end
  Shot.initialize(self, p)
end

function Ring:getBullet()
  local inc = math.rad((self.maxAngle - self.startAngle)/self.totalBulletAmount)
  local init = math.rad(self.startAngle)
  local limit = math.rad(self.maxAngle)
  for a = init + inc, limit, inc do 
    local velx = math.cos(a)
    local vely = math.sin(a)
    local bullet = Bullet:new(self.pos.x, self.pos.y, self.r/3, velx, vely, self.bulletSpeed, self.sprite, self.mode)
    table.insert(game.bullets, bullet)
  end
  self.complete = true
end

function Ring:update(dt)
  if self.shotTimer >= self.fireRate and self.stepCounter ~= self.totalStepAmount then
    self.shotTimer = 0
    self.stepCounter = self.stepCounter + 1
    love.audio.play(self.sfx_shot)
    self:getBullet()
  else
    self.shotTimer = self.shotTimer + dt
  end
  self.complete = self.stepCounter == self.totalStepAmount
end

return Ring
