local getDist = function(a, b)
  local dx = b.x - a.x
  local dy = b.y - a.y
  return math.sqrt(dx * dx + dy * dy)
end

local checkCollision = function(a, b)
  local dist = getDist(a, b)
  return dist < a.r + b.r
end

CheckQuadCollisions = {
  checkQuadCollisions = function(self, a, b, callback)
    for j = #b, 1, -1 do
      if checkCollision(a.hitbox, b[j].ref.hitbox) then
        callback(j)
        return
      end
    end
  end
}

SetMode = {
  setMode = function(self)
    if self.mode == "red" then
      return 0.8,0.4,0.4,1
    elseif self.mode == "blue" then
      return 0.4,0.4,0.8,1
    else 
      return 0.8,0.4,0.8,1
    end
  end
}

UpdateHitbox = {
  updateHitbox = function(self)
    self.hitbox.x = self.pos.x + (self.w * self.sprite_scale)/2
    self.hitbox.y = self.pos.y + (self.h * self.sprite_scale)/2
    quadtree:insert({left=self.hitbox.x, top=self.hitbox.y, width=self.hitbox.r, height=self.hitbox.r, ref=self})
  end
}

DebugDraw = {
  debugDraw = function(self)
    local r, g, b, a = love.graphics.getColor( )
    love.graphics.setColor(0, 0, 255, 1)
    love.graphics.circle('fill', self.hitbox.x, self.hitbox.y, self.hitbox.r)
    love.graphics.setColor(r,g,b,a)
  end
}


UpdateTable = { 
  updateTable = function(self, t, dt)
    for i, j in pairs(t) do
      if j then --make sure exists 
        local offset = 1000
        if j.pos.x > GAME_WIDTH + offset
        or j.pos.y > GAME_HEIGHT + offset
        or j.pos.x < -offset
        or j.pos.y < -offset then
          table.remove(t, i)
        else
            j:update(dt)
        end
      end
    end
  end
}

DrawTable = {
  drawTable = function(self, t)
    for i = 1, #t do
      if t[i] then
        t[i]:draw()
      end
    end
  end
}
