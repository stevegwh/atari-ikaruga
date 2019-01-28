Bullet = require 'src.bullets.enemy.baseclass'
require 'src.bullets.enemy.bullets'
local Shot = class('Shot')

function Shot:initialize(p, sfx_shot)
  self.pos = {x=p.x,y=p.y}
  self.mode = p.mode
  self.shotTimer = 0
  self.totalBulletAmount = p.tba
  self.bulletCounter = 0
  self.fireRate = p.fr
  self.bulletSpeed = p.bs
  self.sprite = p.sprite
  self.r = p.r
  if sfx_shot then
    self.sfx_shot = sfx_shot
  else
    self.sfx_shot = love.audio.newSource('assets/sfx/shot1.ogg', 'static')
  end
  self.complete = false
end

function Shot:playSound()
  love.audio.play(self.sfx_shot)
end

function Shot:update(dt)
  if self.shotTimer >= self.fireRate and self.bulletCounter ~= self.totalBulletAmount then
    self:playSound()
    self.shotTimer = 0
    self.bulletCounter = self.bulletCounter + 1
    self:getBullet()
  else
    self.shotTimer = self.shotTimer + dt
  end
  self.complete = self.bulletCounter == self.totalBulletAmount
end

return Shot
