local bullet_sprites = love.graphics.newImage('assets/sprites/bullets.png')
local enemy_sprites = love.graphics.newImage('assets/sprites/enemy_sheet.png')

local g = anim8.newGrid(68, 82, enemy_sprites:getWidth(), enemy_sprites:getHeight())
function getGrid(w, h, s_sheet, frames, row, duration, left, top)
    local g = anim8.newGrid(w, h, s_sheet:getWidth(), s_sheet:getHeight(), left, top)
    return anim8.newAnimation(g(frames,row), duration)
end
return {
  explosion = {
    quad = love.graphics.newImage('assets/sprites/explosion2.png'),
    w = 512,
    h = 512
  },
  blast = {
    quad = love.graphics.newImage('assets/sprites/blast.png'),
    w = 512,
    h = 512
  },
  bullets = {
    smallGreenBullet = {
      quad = love.graphics.newQuad(288, 128, 32, 32, bullet_sprites:getWidth(), bullet_sprites:getHeight()),
      w = 32,
      h = 32
    },
    smallOrangeBullet = {
      quad = love.graphics.newQuad(64, 128, 32, 32, bullet_sprites:getWidth(), bullet_sprites:getHeight()),
      w = 32,
      h = 32
    },
    smallPurpleBullet = {
      quad = love.graphics.newQuad(128, 128, 32, 32, bullet_sprites:getWidth(), bullet_sprites:getHeight()),
      w = 32,
      h = 32
    },
    bigBlueOrb = {
      quad = love.graphics.newQuad(192, 96, 32, 32, bullet_sprites:getWidth(), bullet_sprites:getHeight()),
      w = 32,
      h = 32
    },
    bigPurpleOrb = {
      quad = love.graphics.newQuad(96, 96, 32, 32, bullet_sprites:getWidth(), bullet_sprites:getHeight()),
      w = 32,
      h = 32
    }
  },
  enemies = {
    shootingStar = {
      quad = love.graphics.newImage('assets/sprites/enemy2.png'),
      w = 128,
      h = 128,
      scale = 0.5
    },
    regularBlue = {
      w = 68,
      h = 82,
      scale = 0.7,
      animations = {
          still = getGrid(68, 82, enemy_sprites, '1-2', 1, 1),
          right = getGrid(68, 82, enemy_sprites, '1-2', 2, 1),
          left = getGrid(68, 82, enemy_sprites, '1-2', 3, 1),
      }
    },
    bigGreen = {
      w = 108,
      h = 90,
      scale = 1,
      animations = {
          still = getGrid(108, 90, enemy_sprites, '1-2', 1, 1, 0, 246),
          right = getGrid(108, 90, enemy_sprites, '1-2', 2, 1, 0, 246),
          left = getGrid(108, 90, enemy_sprites, '1-2', 3, 1, 0, 246),
      }
    }
  }
}
