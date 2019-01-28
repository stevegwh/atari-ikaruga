require 'src.level'
local Power = require 'src.powerup'
local Game = class('Game')
--mixins
Game:include(UpdateTable)
Game:include(DrawTable)

function Game:initialize()
  self.collisions = {}
  self.level = LevelOne:new()
  --collections
  self.enemies = {}
  self.bullets = {}
  self.explosions = {}
  --bg
  self.bg = love.graphics.newImage('assets/bg/bg.png')
  --sprites
  self.bullet_sprites = love.graphics.newImage('assets/sprites/bullets.png')
  self.enemy_sprites = love.graphics.newImage('assets/sprites/enemy.png')
  --sounds
  self.bgm = love.audio.newSource('assets/bgm/bgm.mp3', 'stream')
  --enemy
  self.powerup = love.graphics.newImage('assets/sprites/spread.png')
end

function Game:playMusic()
  -- love.audio.play(self.bgm)
end


function Game:draw()
  love.graphics.draw(self.bg)
  effect(function()
    self:drawTable(player.bullets)
    player:draw()
    self:drawTable(self.bullets)
    self:drawTable(self.explosions)
    self:drawTable(self.enemies)
  end)
end

function Game:update(dt)   --player is updated separately
  self:playMusic()
  self:updateTable(self.explosions, dt)
  self:updateTable(self.enemies, dt) 
  self:updateTable(self.bullets, dt)
  self:updateTable(player.bullets, dt)
  self.level:update(dt)
end

return Game
