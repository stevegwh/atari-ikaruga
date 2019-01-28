--brings all shots into namespace
sprites = require 'src.sprites'
BikeWheel = require 'src.shots.bikewheel'
SimpleSideShot = require 'src.shots.simplesideshot'
ShotAimedAtPlayer = require 'src.shots.shotaimedatplayer'
SimpleSideShot = require 'src.shots.simplesideshot'
Spiral = require 'src.shots.spiral'
SpeedUpSpiral = require'src.shots.speedupspiral'
Ring = require 'src.shots.ring'
Whip = require'src.shots.whip'
CrissCrossWhip = require 'src.shots.crisscrosswhip'




-- HOMING FLOWERS;
-- TODO: REMOVE SELF.COMPLETE AND MAKE IT HAVE ITS OWN TIMER
-- -- local p2 = {amount=10, rotationRate=1, movementSpeed=1, maxAngle=360, k=8, r=16}
-- function BikeWheel:initialize(p)
--   local s_sheet = love.graphics.newImage('assets/sprites/bullets.png')
--   self.sprite = love.graphics.newQuad(192, 96, 32, 32, s_sheet:getWidth(),
--                                       s_sheet:getHeight())
--   self.k = p.k
-- end

-- function BikeWheel:update(dt)
--   if self.rotationTimer >= 0.1 then
--     self.rotationTimer = 0
--     for i = 1, #game.bullets do
--       local b = game.bullets[i]
--       local angle = math.atan2((b.pos.y - player.pos.y), (b.pos.x - player.pos.x))
--       local bulletDx = 1 * math.cos(angle)
--       local bulletDy = 1 * math.sin(angle)
--       b.acc = Vector(-bulletDx, -bulletDy)
--     end
--   else
--     self.rotationTimer = self.rotationTimer + dt
--   end
--   if self.timer >= self.rotationRate and not self.complete then
--     self.timer = 0
--     self.count = self.count + 1
--     self:getBullet()
--   else
--     self.timer = self.timer + dt
--   end
--   self.complete = self.count == self.amount
-- end

-- function BikeWheel:getBullet()
--   local bullets = {}
--   for i=0, 8 do
--     local bullet = Bullet:new(self.pos.x, self.pos.y, self.r, self.r/3, math.cos(45 * i),math.sin(45 * i), self.movementSpeed, self.sprite, 32, 32, 1)
--     table.insert(game.bullets, bullet)
--   end
-- end

-- local p2 = {amount=120, rotationRate=0.1, movementSpeed=1, maxAngle=360, k=8, r=16}
-- HomingHurricaine = class('HomingHurricaine')
-- function HomingHurricaine:initialize(p)
--   local s_sheet = love.graphics.newImage('assets/sprites/bullets.png')
--   self.sprite = love.graphics.newQuad(192, 96, 32, 32, s_sheet:getWidth(),
--                                       s_sheet:getHeight())
--   self.k = p.k
--   self.homingTimer = 0
--   self.maxHomingTime = 5
-- end

-- function HomingHurricaine:update(dt)
--     for i = 1, #game.bullets do
--       local b = game.bullets[i]
--       local angle = math.atan2((b.pos.y - player.pos.y), (b.pos.x - player.pos.x))
--       local bulletDx = self.movementSpeed * math.cos(angle)
--       local bulletDy = self.movementSpeed * math.sin(angle)
--       b.acc = Vector(-bulletDx, -bulletDy)
--       b.vel:limit(5)
--     end
--   if self.timer >= self.rotationRate and self.count ~= self.amount then
--     self.timer = 0
--     self.count = self.count + 1
--     self:getBullet()
--   else
--     self.timer = self.timer + dt
--   end
--   if self.homingTimer < self.maxHomingTime then
--     self.homingTimer = self.homingTimer + dt
--   else
--     self.complete = true
--   end
-- end

-- function HomingHurricaine:getBullet()
--     local bullet = Bullet:new(self.pos.x, self.pos.y, self.r, self.r/3, 1, 1, self.movementSpeed, self.sprite, 32, 32, 1)
--     table.insert(game.bullets, bullet)
-- end

