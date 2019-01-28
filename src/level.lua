local sprites = require 'src.sprites'
require 'src.enemy'
local EFactory = require 'src.enemyfactory'
local Level = class('Level')
function Level:initialize()
  self.timer = 0
end

function Level:update(dt)
  self.timer = self.timer + dt
  local timer = math.floor(self.timer)
  for i, e in ipairs(self.data) do
    if timer == e.time and not e.spawned then
      for j, k in ipairs(e.enemies) do
        e.spawned = true
        table.insert(game.enemies, k)
      end
      return
    end
  end
end

LevelOne = class('LevelOne', Level)
function LevelOne:initialize()
  self.data = self.getData()
  Level:initialize(self)
end
function LevelOne:getData()
  local regularBullet = sprites.bullets.bigBlueOrb
  local regularPurpleBullet  = sprites.bullets.bigPurpleOrb
  local smallBullet = sprites.bullets.smallGreenBullet
  local smallOrangeBullet = sprites.bullets.smallOrangeBullet
  local shootingStar = sprites.enemies.shootingStar
  local bullet = {
    quad = love.graphics.newImage('assets/sprites/enemy_bullet.png'),
    w = 64,
    h = 64
  }
  local level = {
    {
      time = 0,
      enemies = EFactory:makeBatch(ShootingStar, 10, {x=100, y=-100, speed=6, sprite=shootingStar, mode='red', bulletSprite=bullet})
    },
    {
      time = 5,
      enemies = EFactory:makeBatch(ShootingStar, 15, {x=100, y=-100, speed=6, sprite=shootingStar, mode='blue', bulletSprite=bullet})
    },
    {
      time = 8,
      enemies = EFactory:makeBatch(ShootingStar, 15, {x=100, y=-100, speed=6, sprite=shootingStar, mode='red', bulletSprite=bullet})
    },
    -- {
    --   time = 8, enemies = {
    --     TweenMob:new(300, 300, sprites.enemies.bigGreen,"red",
    --       {{
    --           pos={x=100, y=300}, t=1, e='inSine',
    --           patterns={
    --             Spiral:new({tba=50, maxR=20, fr=0.01, bs=2, r=16, sprite=bullet, mode="blue"}),
    --             Spiral:new({tba=100, maxR=10, fr=0.01, bs=1, r=16, sprite=bullet, mode="red"}),
    --             ShotAimedAtPlayer:new({tba=50, fr=0.1, bs=1, r=16, sprite=bullet, mode="red"})
    --           }
    --        }
    --        ,{
    --           pos={x=2000, y=100}, t=10, e='inSine'}
    --     }),
    --   }
    -- },
    -- {
    --   time = 0, enemies = {
    --     EFactory:tweenMob(300, 300, sprites.enemies.bigGreen,
    --       {{
    --           pos={x=100, y=300}, t=1, e='inSine',
    --           patterns={
    --             {Spiral, {tba=5, maxR=3, fr=0.01, bs=2, r=16, sprite=regularPurpleBullet}},
    --             {Spiral, {tba=10, maxR=1, fr=0.01, bs=1, r=16, sprite=regularBullet}},
    --             {ShotAimedAtPlayer, {tba=5, fr=0.1, bs=1, r=16, sprite=regularPurpleBullet}}
    --           }
    --        }
    --        ,{
    --           pos={x=2000, y=100}, t=10, e='inSine'}
    --     }),
    --   }
    -- },
    -- {
    --   time = 0, enemies = {
    --     EFactory:tweenMob(300, 300, sprites.enemies.bigGreen,
    --       {{
    --           pos={x=100, y=300}, t=1, e='inSine',
    --           pattern={ShotAimedAtPlayer, {tba=50, fr=0.01, bs=1, r=16, sprite=regularBullet}}
    --        },{
    --           pos={x=200, y=400}, t=1, e='inSine',
    --           pattern={ShotAimedAtPlayer, {tba=50, fr=0.01, bs=1, r=16, sprite=regularBullet}}
    --        },{
    --           pos={x=2000, y=100}, t=10, e='inSine'}
    --     }),
    --   }
    -- },
    -- {
    --   time = 15,
    --   enemies = EFactory:makeLine({
    --       {type=LoopingEnemy,amount=10, startX=600,startY=-1000,gap = 100, speed=5, sprite=sprites.enemies.regularBlue},
    --       {type=RegularMob,amount=10, startX=100,startY=-1000,gap = 100, speed=5, sprite=sprites.enemies.regularBlue}
    --   })
    -- },

  }
  return level
end



