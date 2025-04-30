local Idle = {}


function Idle:enter(player)
  print("entering idle lol")
  player.anim = player.animations.idle
  if player.anim then player.anim:gotoFrame(1) end

  if player.collider then player.collider:setLinearVelocity(0,0) end
end  

function Idle:update(player,dt)
    if love.keyboard.isDown("w", "up", "s", "down", "a", "left", "d", "right") then
        player.stateManager:switch(player.states.walk, player)  
    elseif love.keyboard.isDown("space") then -- for attack input
        --player.stateManager:switch(player.states.attack)
    end
end

function Idle:draw(player)

end

function Idle:leave(player)
    print("leaving Idle state")
end

return Idle