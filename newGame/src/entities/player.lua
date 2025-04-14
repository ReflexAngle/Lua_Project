local ObjectPool = require("src/designPatterns/objectPool")
local normalize = require("src/math/normalization")
--player = world:newBSGRectangleCollider(234, 184, 12, 12, 3)
player = world:newBSGRectangleCollider(204,184 ,15, 15, 4 )
player.x = 0
player.y = 0
player.dir = "down"
player.dirX = 1
player.dirY = 1
player.prevDirX = 1
player.prevDirY = 1
player.scaleX = 1
player.speed = 90
player.animSpeed = 0.1 --.14
player.walking = false
player.animTimer = 0
player.max_hearts = 5
player.hearts = 3
-- player.stunTimer = 0
-- player.damagedTimer = 0
player.damagedBool = 1
player.damagedFlashTime = 0.05
player.invincible = 0 -- timer
player.bowRecoveryTime = 0.25
player.holdSprite = sprites.items.heart
player.attackDir = vector(1, 0)
player.comboCount = 0
player.aiming = false
player.arrowOffX = 0
player.arrowOffX = 0
player.bowVec = vector(1, 0)
player.baseDamping = 1 --12
player.dustTimer = 0
player.rollDelayTimer = 0
player.rotateMargin = 0.25
-- 0 = Normal gameplay
-- 0.5 = Rolling
-- 1 = Sword swing
-- 2 = Use (bomb)
-- 3 = Bow (3: bow drawn, 3.1: recover)
-- 4 = grapple (4: armed, 4.1: launching, 4.2: moving)
-- 10 = Damage stun
-- 11 = Hold item
-- 12 = Transition
player.state = 0

player:setCollisionClass("Player")
player:setFixedRotation(true)
player:setLinearDamping(player.baseDamping)

-- Heart Pool
    player.heartPool = ObjectPool:new(function()
        return {
            sprite = sprites.items.heart,
            x = 0,
            y = 0,
            active = false
        }
    end, player.max_hearts)

player.grid = anim8.newGrid(16, 32, sprites.player.playerWalkSheet:getWidth(), sprites.player.playerWalkSheet:getHeight())

player.animations = {}
player.animations.idle = anim8.newAnimation(player.grid('1-1', 1), player.animSpeed)
player.animations.walkUp = anim8.newAnimation(player.grid('3-4', 3), player.animSpeed)
player.animations.walkDown = anim8.newAnimation(player.grid('1-4', 1), player.animSpeed)
player.animations.walkLeft = anim8.newAnimation(player.grid('1-4', 4), player.animSpeed)
player.animations.walkRight = anim8.newAnimation(player.grid('2-4', 2), player.animSpeed)

player.animations.attackUp = anim8.newAnimation(player.grid('1-2', 5), player.animSpeed)
player.animations.attackDown = anim8.newAnimation(player.grid('1-2', 6), player.animSpeed)
player.animations.attackLeft = anim8.newAnimation(player.grid('1-2', 7), player.animSpeed)
player.animations.attackRight = anim8.newAnimation(player.grid('1-2', 8), player.animSpeed)
--player.animations.downRight = anim8.newAnimation(player.grid('1-2', 1), player.animSpeed)
--player.animations.downLeft = anim8.newAnimation(player.grid('1-2', 1), player.animSpeed)
--player.animations.upRight = anim8.newAnimation(player.grid('1-2', 2), player.animSpeed)
--player.animations.upLeft = anim8.newAnimation(player.grid('1-2', 2), player.animSpeed)
-- player.animations.idle = anim8.newAnimation(grid('1-1', 1), 0.1),

-- player.animations.walkUp == anim8.newAnimation(grid('3-4', 3), 0.1),
-- -- attack anims
-- player.animations.attackDown = anim8.newAnimation(grid('1-2', 5), 0.1),
-- player.animations.attackUp = anim8.newAnimation(grid('1-2', 6), 0.1),
-- player.animations.attackRight = anim8.newAnimation(grid('1-2', 7), 0.1),
-- player.animations.attackLeft = anim8.newAnimation(grid('1-2', 8), 0.1)

-- player.animations.swordDownRight = anim8.newAnimation(player.grid('1-2', 1), player.animSpeed)
-- player.animations.swordDownLeft = anim8.newAnimation(player.grid('1-2', 1), player.animSpeed)
-- player.animations.swordUpRight = anim8.newAnimation(player.grid('1-2', 2), player.animSpeed)
-- player.animations.swordUpLeft = anim8.newAnimation(player.grid('1-2', 2), player.animSpeed)
-- player.animations.useDownRight = anim8.newAnimation(player.grid(2, 1), player.animSpeed)
-- player.animations.useDownLeft = anim8.newAnimation(player.grid(2, 1), player.animSpeed)
-- player.animations.useUpRight = anim8.newAnimation(player.grid(2, 2), player.animSpeed)
-- player.animations.useUpLeft = anim8.newAnimation(player.grid(2, 2), player.animSpeed)
-- player.animations.hold = anim8.newAnimation(player.grid(1, 1), player.animSpeed)
-- player.animations.rollDown = anim8.newAnimation(player.grid('1-3', 4), 0.11)
-- player.animations.rollUp = anim8.newAnimation(player.grid('1-3', 5), 0.11)
-- player.animations.stopDown = anim8.newAnimation(player.grid('1-3', 6), 0.22, function() player.anim = player.animations.idleDown end)
-- player.animations.stopUp = anim8.newAnimation(player.grid('1-3', 7), 0.22, function() player.anim = player.animations.idleUp end)
-- player.animations.idleDown = anim8.newAnimation(player.grid('1-4', 8), {1.2, 0.1, 2.4, 0.1})
-- player.animations.idleUp = anim8.newAnimation(player.grid('1-2', 9), 0.22)

player.anim = player.animations.idle


player.buffer = {} -- input buffer

function player:update(dt)

    --if pause.active then player.anim:update(dt) end
    if  player.state == 0 then 
        player:setLinearDamping(player.baseDamping)
        player:handleMovementAndAnimation()

    elseif  player.state == 1 then
        if player.anim and player.anim.position == #player.anim.frames then
            player.state = 0
            player.anim = player.animations.idle
            
            if player.anim then player.anim:gotoFrame(1) end
        end
    end

    --update current anim
    if player.anim then
        player.anim:update(dt)
    end
end

function player:draw()
    -- Sword sprite
    local swSpr = sprites.items.sword
    local swX = 0
    local swY = 0
    local swLayer = -1
    -- local arrowSpr = sprites.items.arrow
    -- local bowSpr = sprites.items.bow1
    --local hookSpr = sprites.items.grappleArmed
    --if player.aiming and (player.animTimer > 0 or data.arrowCount < 1) then bowSpr = sprites.items.bow2 end
    --if player.state == 4.1 or player.state == 4.2 then hookSpr = sprites.items.grappleHandle end

    local swordRot = 0
    if player.state == 1.1 then
        local tempVec = 0
        if player.comboCount % 2 == 0 then
            tempVec = player.attackDir:rotated(math.pi/2)
        else
            tempVec = player.attackDir:rotated(math.pi/-2)
        end
        swordRot = math.atan2(tempVec.y, tempVec.x)
        swX = tempVec.x * 12
        swY = tempVec.y * 12
        
        if swY > 0 then
            swLayer = 1
        end
    end

    local px = player:getX()
    local py = player:getY()

    if px and py then -- Make sure position is valid
        love.graphics.setColor(1, 0, 0, 1) -- Bright red, fully opaque
        -- Draw a 16x16 rectangle centered roughly where the player sprite would be
        love.graphics.rectangle("fill", px - 8, py - 16, 16, 32) 
        love.graphics.setColor(1, 1, 1, 1) -- Reset color to white
        print("Attempting to draw test rectangle at:", px, py) -- Add console print
    else
         print("Player position invalid in draw:", px, py)
    end

    -- local bowLayer = -1
    -- player.bowVec = toMouseVector(px, py)
    -- local bowScaleY = 1
    -- if player.bowVec.x < 0 then bowScaleY = -1 end
    -- local bowRot = math.atan2(player.bowVec.y, player.bowVec.x)
    -- local bowOffX = player.bowVec.x*6
    -- local bowOffY = player.bowVec.y*6
    -- local hookOffX = player.bowVec.x*6
    -- local hookOffY = player.bowVec.y*6
    -- player.arrowOffX = player.bowVec.x*6
    -- player.arrowOffY = player.bowVec.y*6

    -- if bowRot > -1 * player.rotateMargin or bowRot < (math.pi - player.rotateMargin) * -1 then
    --     bowLayer = 1
    -- end

   -- love.graphics.draw(sprites.playerShadow, px, py+5, nil, nil, nil, sprites.playerShadow:getWidth()/2, sprites.playerShadow:getHeight()/2)
    
    if player.state == 1.1 and swLayer == -1 then
        love.graphics.draw(swSpr, px+swX, py+swY, swordRot, nil, nil, swSpr:getWidth()/2, swSpr:getHeight()/2)
    end
    
    if player.aiming and bowLayer == -1 then

        
        --if player.stunTimer > 0 then love.graphics.setShader(shaders.whiteout) end

    --player.anim:draw(sprites.player.playerWalkSheet, player:getX(), player:getY(), nil, player.dirX, 1, 15, 15)
    player.anim:draw(sprites.player.playerWalkSheet, player:getX() - 8 , player:getY() - 16, nil, player.dirX * player.scaleX, player.scaleX, 16, 32)


   -- love.graphics.setShader()

    if player.state == 1.1 and swLayer == 1 then
        love.graphics.draw(swSpr, px+swX, py+swY, swordRot, nil, nil, swSpr:getWidth()/2, swSpr:getHeight()/2)
    end

    -- if player.aiming and bowLayer == 1 then
    --     love.graphics.draw(bowSpr, px + bowOffX, py + bowOffY, bowRot, 1.15, bowScaleY, bowSpr:getWidth()/2, bowSpr:getHeight()/2)
    --     if data.arrowCount > 0 and player.animTimer <= 0 then love.graphics.draw(arrowSpr, px + bowOffX, py + bowOffY, bowRot, 0.85, nil, arrowSpr:getWidth()/2, arrowSpr:getHeight()/2) end
    --     --love.graphics.draw(hookSpr, px + hookOffX, py + hookOffY, bowRot, 1.15, nil, hookSpr:getWidth()/2, hookSpr:getHeight()/2)
    -- end

    -- if player.state == 11 then
    --     love.graphics.draw(player.holdSprite, player:getX(), player:getY()-18, nil, nil, nil, player.holdSprite:getWidth()/2, player.holdSprite:getHeight()/2)
    -- end
end
end

-- function player:checkDamage()
--     if player.damagedTimer > 0 then return end

--     local hitEnemies = world:queryCircleArea(player:getX(), player:getY(), 5, {'Enemy'})
--     if #hitEnemies > 0 then
--         local e = hitEnemies[1]
--         if e.parent.dizzyTimer <= 0 and e.parent.stunTimer <= 0 then
--             player:hurt(0.5, e:getX(), e:getY())
--         end
--     end

    -- to fix the overlap issue, check distance as well
    -- for _,e in ipairs(enemies) do
    --     if e.physics and distanceBetween(e.physics:getX(), e.physics:getY(), player:getX(), player:getY()) < 4 then
    --         player:hurt(0.5, e.physics:getX(), e.physics:getY())
    --     end
    -- end

--     if player:enter('Projectile') then
--         local e = player:getEnterCollisionData('Projectile')
--         e.collider.dead = true
--         player:hurt(0.5, e.collider:getX(), e.collider:getY())
--     end
-- end

-- function player:checkTransition()
--     if player:enter('Transition') then
--         local t = player:getEnterCollisionData('Transition')
--         if t.collider.type == "instant" then
--             triggerTransition(t.collider.id, t.collider.destX, t.collider.destY)
--         else
--             curtain:call(t.collider.id, t.collider.destX, t.collider.destY, t.collider.type)
--         end
--         --triggerTransition(t.collider.id, t.collider.destX, t.collider.destY)
--     end
-- end

-- function player:hurt(damage, srcX, srcY)
--     if player.damagedTimer > 0 then return end
--     player.damagedTimer = 2
--     shake:start(0.1, 2, 0.03)
--     particleEvent("playerHit", player:getX(), player:getY())
--     dj.play(sounds.player.hurt, "static", "effect")
--     player.health = player.health - damage
--     player.state = 10 -- damaged
--     player:setLinearVelocity((getFromToVector(srcX, srcY, player:getX(), player:getY()) * 300):unpack())
--     player.stunTimer = 0.075
--     player.aiming = false
-- end

-- Corrected function in src/entities/player_setup.lua (or wherever player methods are defined)

function player.handleMovementAndAnimation() -- Use dot (.) not colon (:)
    -- This function assumes it's only called when player.state == 0

    local moveX, moveY = 0, 0
    local isMoving = false -- Flag to track if movement keys are pressed

    -- Check keyboard input and set temporary move direction & animation
    -- Using elseif for opposite directions is slightly cleaner
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        moveX = 1
        player.anim = player.animations.walkRight
        isMoving = true
    elseif love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        moveX = -1
        player.anim = player.animations.walkLeft
        isMoving = true
    end

    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        moveY = 1
        player.anim = player.animations.walkDown 
        isMoving = true
    elseif love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        moveY = -1
        player.anim = player.animations.walkUp
        isMoving = true
    end

    if not isMoving then -- Check the flag instead of moveX/Y which might be normalized
        player.animations.currentAnimation = player.animations.idle -- Use player.
    end

    -- Normalize diagonal movement - this call should work fine now
    -- Make sure the 'normalize' table is accessible globally or required in this file
    if normalize and normalize.NormalizedVector then
    moveX, moveY = normalize.NormalizedVector(moveX, moveY)    else
        print("Warning: normalize module not found/loaded.")
    end

    -- Calculate final velocity vector using player's speed
    local vec = { x = moveX * player.speed, y = moveY * player.speed } -- Use player.

    if player.collider then -- Check collider exists
       player.collider:setLinearVelocity(vec.x, vec.y) -- Use player.
    end

    -- Update facing direction based on actual movement input
    -- Only update if there *was* horizontal or vertical input this frame
    if moveX ~= 0 then
        player.dirX = moveX -- Use player.
    end
    if moveY ~= 0 then
        player.dirY = moveY -- Use player.
    end

    -- Update the string direction variable based on the prioritized input
    if moveY == -1 then
        player.dir = "up" -- Use player.
    elseif moveY == 1 then
        player.dir = "down" -- Use player.
    elseif moveX == -1 then
        player.dir = "left" -- Use player.
    elseif moveX == 1 then
        player.dir = "right" -- Use player.
    end
    -- If no movement (isMoving is false), player.dir retains its previous value

end 

function player:swingSword()

    -- The player can only swing their sword if the player.state is 0 (regular gameplay)
    if player.state ~= 0 then
        player:addToBuffer("sword")
        return
    end
    
--player.comboCount = player.comboCount + 1
    
    player.attackDir = toMouseVector(player:getX(), player:getY())
    player:setDirFromVector(player.attackDir)
    
    player.state = 1
    
    if player.dirX == 1 then
        if player.dirY == 1 then
            player.anim = player.animations.swordDownRight
        else
            player.anim = player.animations.swordUpRight
        end
    else
        if player.dirY == 1 then
            player.anim = player.animations.swordDownLeft
        else
            player.anim = player.animations.swordUpLeft
        end
    end
    
    --player.anim:gotoFrame(1)
    -- animTimer for sword wind-up
    player.animTimer = 0.075

end

function player:swordDamage()
    -- Query for enemies to hit with the sword
    --local hitEnemies = world:queryCircleArea(player:getX(), player:getY(), 24, {'Enemy'})

    local px, py = player:getPosition()
    local dir = player.attackDir:normalized()
    local rightDir = dir:rotated(math.pi/2)
    local leftDir = dir:rotated(math.pi/-2)
    local polygon = {
        px + dir.x*20,
        py + dir.y*20,
        px + dir:rotated(math.pi/8).x*20,
        py + dir:rotated(math.pi/8).y*20,
        px + dir:rotated(math.pi/4).x*20,
        py + dir:rotated(math.pi/4).y*20,
        px + dir:rotated(3*math.pi/8).x*20,
        py + dir:rotated(3*math.pi/8).y*20,
        px + rightDir.x*22,
        py + rightDir.y*22,
        px + rightDir.x*22 + rightDir:rotated(math.pi/2).x*6,
        py + rightDir.y*22 + rightDir:rotated(math.pi/2).y*6,
        px + leftDir.x*22 + leftDir:rotated(math.pi/-2).x*6,
        py + leftDir.y*22 + leftDir:rotated(math.pi/-2).y*6,
        px + leftDir.x*22,
        py + leftDir.y*22,
        px + dir:rotated(3*math.pi/-8).x*20,
        py + dir:rotated(3*math.pi/-8).y*20,
        px + dir:rotated(math.pi/-4).x*20,
        py + dir:rotated(math.pi/-4).y*20,
        px + dir:rotated(math.pi/-8).x*20,
        py + dir:rotated(math.pi/-8).y*20,
    }

    local range = math.random()/4
    --dj.play(sounds.items.sword, "static", "effect", 1, 1+range)

    -- local hitEnemies = world:queryPolygonArea(polygon, {'Enemy'})
    -- for _,e in ipairs(hitEnemies) do
    --     local knockbackDir = getPlayerToSelfVector(e:getX(), e:getY())
    --     e.parent:hit(1, knockbackDir, 0.1)
    -- end
end

function player:setDirFromVector(vec)
    local rad = math.atan2(vec.y, vec.x)
    if rad >= player.rotateMargin*-1 and rad < math.pi/2 then
        player.dirX = 1
        player.dirY = 1
    elseif (rad >= math.pi/2 and rad < math.pi) or (rad < (math.pi - player.rotateMargin)*-1) then
        player.dirX = -1
        player.dirY = 1
    elseif rad < 0 and rad > math.pi/-2 then
        player.dirX = 1
        player.dirY = -1
    else
        player.dirX = -1
        player.dirY = -1
    end
end

function player:processBuffer(dt)
    for i=#player.buffer,1,-1 do
        player.buffer[i][2] = player.buffer[i][2] - dt
    end
    for i=#player.buffer,1,-1 do
        if player.buffer[i][2] <= 0 then
            table.remove(player.buffer, i)
        end
    end

    if player.state == 0 then
        player:useBuffer()
    end
end

function player:addToBuffer(action)
    if action == "roll" and player.state == 0.5 then
        table.insert(player.buffer, {action, 0.1})
    else
        table.insert(player.buffer, {action, 0.25})
    end
end

function player:useBuffer()
    local action = nil
    if #player.buffer > 0 then
        action = player.buffer[1][1]
    end

    -- clear buffer
    for k,v in pairs(player.buffer) do player.buffer[k]=nil end

    if action == nil then return end

    if action == "sword" then
        player:swingSword()
    end
end