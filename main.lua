require 'src.constants'
require "lib.autobatch"

function love.load()
  -- ddebug = true
  --libs
  class = require 'lib.middleclass'
  Vector = require 'lib.brinevector'
  tween = require 'lib.tween'
  lume = require 'lib.lume'
  baton = require 'lib.baton'
  anim8 = require 'lib.anim8'
  Quadtree = require'lib.quadtree'
  moonshine = require 'lib.moonshine'
  effect = moonshine(moonshine.effects.godsray)
  local font = love.graphics.newFont(14)
  love.graphics.setFont(font)
  require 'src.mixins'
  local Game = require 'src.game'
  local Player = require 'src.player'
  game = Game:new()
  player = Player:new()
  input = baton.new {
    controls = {
      left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
      right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
      up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
      down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
      action = {'key:space', 'button:a'},
      bomb = {'key:e', 'button:y'},
      changeMode = {'key:q', 'button:b'},
      shift = {'key:lshift', 'button:x'},
    },
    pairs = {
      move = {'left', 'right', 'up', 'down'}
    },
    joystick = love.joystick.getJoysticks()[1],
}
end


function love.draw()
  love.graphics.scale(1, 1)
  game:draw()
  local r,g,b,a = love.graphics.getColor()
  love.graphics.setColor(1,0,0,1)
  love.graphics.rectangle('fill', WINDOW_WIDTH - 50, WINDOW_HEIGHT-50, 10 + player.red, 28)
  love.graphics.setColor(r,g,b,a)
  love.graphics.setColor(0,0,1,1)
  love.graphics.rectangle('fill', WINDOW_WIDTH - 100, WINDOW_HEIGHT-50, 10 + player.blue, 28)
  love.graphics.setColor(r,g,b,a)
  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 300, WINDOW_HEIGHT-50)
  love.graphics.print("Points: " .. player.score, 200, WINDOW_HEIGHT - 50)
end

function love.update(dt)
  if not ddbug then --this is very confusing
    quadtree = Quadtree.create(0, 0, GAME_WIDTH, GAME_HEIGHT, 5, 8)
    game:update(dt)
    input:update()
    player:update(dt)
    quadtree:clear()
  end
end

function love.keypressed(key, u)
  --Debug
  if key == "rctrl" then --set to whatever key you want to use
    if ddbug then
      ddbug = false
    else
      ddbug = true
      debug.debug()
    end
  end
  --Quit
  if key == "escape" then --set to whatever key you want to use
    love.event.quit()
  end
end

