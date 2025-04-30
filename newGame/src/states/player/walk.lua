-- src/states/player/walk.lua
local Walk = {}

function Walk:enter(player)
    print("Entering Walk State")
    -- Animation is set within update based on direction
end

function Walk:update(player, dt)
    -- Handle movement and animation setting (similar to your old handleMovementAndAnimation)
    local moveX, moveY = 0, 0
    local isMoving = false 
    local targetAnim = nil

    if love.keyboard.isDown("d", "right") then moveX = 1; targetAnim = player.animations.walkRight; isMoving = true; player.dir="right"; player.dirX=1 end
    if love.keyboard.isDown("a", "left") then moveX = -1; targetAnim = player.animations.walkLeft; isMoving = true; player.dir="left"; player.dirX=-1 end
    if love.keyboard.isDown("s", "down") then moveY = 1; targetAnim = player.animations.walkDown; isMoving = true; player.dir="down"; player.dirY=1 end
    if love.keyboard.isDown("w", "up") then moveY = -1; targetAnim = player.animations.walkUp; isMoving = true; player.dir="up"; player.dirY=-1 end
    
    if not isMoving then
        -- No movement keys held, switch back to idle
        player.stateManager:switch(player.states.idle, player)
        return -- Exit early as we are changing state
    end

    -- Set animation if changed
    if player.anim ~= targetAnim then
        player.anim = targetAnim
        if player.anim then player.anim:gotoFrame(1) end
    end
    
    -- Normalize and set velocity
    if normalize then moveX, moveY = normalize.NormalizedVector(moveX, moveY) end
    local vec = { x = moveX * player.speed, y = moveY * player.speed } 
    if player.collider then player.collider:setLinearVelocity(vec.x, vec.y) end

     -- Check for attack input to transition
     if love.keyboard.isDown("space") then 
        -- player.stateManager:switch(player.states.attack, player) -- Uncomment when attack state is ready
     end
end

function Walk:draw(player)
    -- Usually empty, main player:draw handles player.anim
end

function Walk:leave(player)
     print("Leaving Walk State")
     -- Ensure player stops moving when leaving walk state if not transitioning to another moving state (like roll)
     if player.collider then player.collider:setLinearVelocity(0, 0) end
end

return Walk