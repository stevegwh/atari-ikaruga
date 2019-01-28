require 'src.enemy'
require 'src.shots.shots'

local EnemyFactory = class('EnemyFactory')
function EnemyFactory:initialize()
end

function EnemyFactory:makePyramid(enemy, amount, startX, startY, gap, speed, sprite)
  local arr = {}
  for i = 1, amount - 1 do
    if i < amount/2 then
      table.insert(arr, enemy:new(startX + gap * i, -startY * i, speed, sprite))
    else
      table.insert(arr, enemy:new(startX + gap * i, -startY * (amount - i), speed, sprite))
    end
  end
  return arr
end

function EnemyFactory:makeLine(t)
  local arr = {}
  for i, k in pairs(t) do
    for j=1, k.amount do
      table.insert(arr, k.type:new(k.startX, k.startY + k.gap * j, k.speed, k.sprite, k.a))
    end
  end
  return arr
end

function EnemyFactory:makeBatch(type,amount,params)
  local arr = {}
  for i=1, amount do
      table.insert(arr, type:new(params))
  end
  return arr
end


-- function EnemyFactory:tweenMob(x,y,sprite,directions)
--   for i=1, #directions do
--     local e = directions[i]
--     if e.pattern then
--       e.pattern = e.pattern[1]:new(e.pattern[2])
--     end
--   end
--   return TweenMob:new(x,y,sprite,directions)
-- end

function EnemyFactory:tweenMob(x,y,sprite,directions)
  for i=1, #directions do
    if directions[i].patterns then
      local arr = {}
      for j=1, #directions[i].patterns do
        local pattern = directions[i].patterns[j]
        arr[j] = pattern[1]:new(pattern[2])
      end
      directions[i].patterns = arr
    end
  end
  return TweenMob:new(x,y,sprite,directions)
end

return EnemyFactory
