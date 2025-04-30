local ObjectPool = require("src/designPatterns/objectPool")
local normalize = require("src/math/normalization")



player = world:newBSGRectangleCollider(275, 180, 12, 12, 3)
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
player.aiming = false
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

--animations     
player.grid = anim8.newGrid(16, 32, sprites.player.playerWalkSheet:getWidth(), sprites.player.playerWalkSheet:getHeight())

player.animations = {}
player.animations.idle = anim8.newAnimation(player.grid('1-1', 1), player.animSpeed)
player.animations.walkUp = anim8.newAnimation(player.grid('1-4', 3), player.animSpeed)
player.animations.walkDown = anim8.newAnimation(player.grid('1-4', 1), player.animSpeed)
player.animations.walkLeft = anim8.newAnimation(player.grid('1-4', 4), player.animSpeed)
player.animations.walkRight = anim8.newAnimation(player.grid('1-4', 2), player.animSpeed)

player.anim = player.animations.idle

player.buffer = {} -- input buffer

function player:update(dt)


  --  if pause.active then player.anim:update(dt) end
    if  player.state == 0 then 
        self:setLinearDamping(self.baseDamping)
        self:handleMovement()
    elseif  player.state == 1 then
    --sword attack logic
    -- if player.anim and player.anim.position == #player.anim.frames then
    --     player.state = 0
    --     player.anim = player.animations.idle
    --     if player.anim then player.anim:gotoFrame(1) end
    -- end
    end
    if self.anim then
        self.anim:update(dt)
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

    local x, y = player:getX(), player:getY()
    local px, py = player:getX(), player:getY()


    -- if px and py then -- Make sure position is valid
    --     love.graphics.setColor(1, 0, 0, 1) -- Bright red, fully opaque
    --     -- Draw a 16x16 rectangle centered roughly where the player sprite would be
    --     love.graphics.rectangle("fill", px - 8, py - 16, 16, 32) 
    --     love.graphics.setColor(1, 1, 1, 1) -- Reset color to white
    --     print("Attempting to draw test rectangle at:", px, py) -- Add console print
    -- else
    --      print("Player position invalid in draw:", px, py)
    -- end

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
    
   --love.graphics.draw(sprites.player.playerWalkSheet)
   --player.anim:draw(sprites.player.playerWalkSheet, player:getX(), player:getY(), nil, player.dirX, 1, 15, 15)
   

   if player.anim then
        -- Draw AT the physics center, using sprite's visual center as origin
        -- Removed the '-2' from player:getY()
        -- Origin (8, 16) assumes the sprite is centered within its 16x32 frame

     player.anim:draw(sprites.player.playerWalkSheet, x, y, 0, 1, 1, 8, 16) 
    end
   
   -- if player.state == 1.1 and swLayer == -1 then
    --     love.graphics.draw(swSpr, px+swX, py+swY, swordRot, nil, nil, swSpr:getWidth()/2, swSpr:getHeight()/2)
    -- end
    
    -- if player.aiming and bowLayer == -1 then

        
    --     --if player.stunTimer > 0 then love.graphics.setShader(shaders.whiteout) end

    -- --player.anim:draw(sprites.player.playerWalkSheet, player:getX(), player:getY(), nil, player.dirX, 1, 15, 15)
    -- player.anim:draw(sprites.player.playerWalkSheet, player:getX() - 8 , player:getY() - 16, nil, player.dirX * player.scaleX, player.scaleX, 16, 32)


   -- love.graphics.setShader()

    -- if player.state == 1.1 and swLayer == 1 then
    --     love.graphics.draw(swSpr, px+swX, py+swY, swordRot, nil, nil, swSpr:getWidth()/2, swSpr:getHeight()/2)
    -- end

    -- if player.aiming and bowLayer == 1 then
    --     love.graphics.draw(bowSpr, px + bowOffX, py + bowOffY, bowRot, 1.15, bowScaleY, bowSpr:getWidth()/2, bowSpr:getHeight()/2)
    --     if data.arrowCount > 0 and player.animTimer <= 0 then love.graphics.draw(arrowSpr, px + bowOffX, py + bowOffY, bowRot, 0.85, nil, arrowSpr:getWidth()/2, arrowSpr:getHeight()/2) end
    --     --love.graphics.draw(hookSpr, px + hookOffX, py + hookOffY, bowRot, 1.15, nil, hookSpr:getWidth()/2, hookSpr:getHeight()/2)
    -- end

    -- if player.state == 11 then
    --     love.graphics.draw(player.holdSprite, player:getX(), player:getY()-18, nil, nil, nil, player.holdSprite:getWidth()/2, player.holdSprite:getHeight()/2)
    -- end
-- end
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


-- function player:handleMovementAndAnimation() -- Use dot (.) not colon (:)
--     -- This function assumes it's only called when player.state == 0

--     local moveX, moveY = 0, 0
--     local isMoving = false 
--     local targetAnim = nil

--     -- movement
--     if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
--         isMoving = true
--         moveX = 1
--         player.dirX  = 1
--         targetAnim = player.animations.walkRight
--     end
--     if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
--         isMoving = true
--         moveX = -1
--         player.dirX = -1
--         targetAnim = player.animations.walkLeft
--     end

--     if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
--         isMoving = true
--         moveY = 1
--         player.dirY = 1
--         targetAnim = player.animations.walkDown 
--     end 
    
--     if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
--         isMoving = true
--         moveY = -1
--         player.dirY = -1
--         targetAnim = player.animations.walkUp
--     end

--     -- Set animation ONLY if it's different or if movement stopped/started
--     if isMoving then
--         if player.anim ~= targetAnim then
--             player.anim = targetAnim
--             if player.anim then player.anim:gotoFrame(1) end -- Reset new animation
--         end
--     else
--         -- Player stopped moving, switch to idle if not already idle
--         if player.anim ~= player.animations.idle then
--              player.anim = player.animations.idle -- Corrected variable name
--              if player.anim then player.anim:gotoFrame(1) end -- Reset idle animation
--         end
--     end

--     -- Normalize diagonal movement - this call should work fine now
--     -- Make sure the 'normalize' table is accessible globally or required in this file
--     if normalize and normalize.NormalizedVector then
--     moveX, moveY = normalize.NormalizedVector(moveX, moveY)    else
--         print("Warning: normalize module not found/loaded.")
--     end

--     -- Calculate final velocity vector using player's speed
--     local vec = { x = moveX * player.speed, y = moveY * player.speed } -- Use player.
--         print("Calculated Velocity Vec: x=", vec.x, "y=", vec.y, "| Speed:", player.speed) 

--     if player.collider then -- Check collider exists
--        self:setLinearVelocity(vec.x, vec.y) -- Use player.
--     end

--     -- Update facing direction based on movement input
--     if moveX ~= 0 then
--         player.dirX = moveX 
--     end
--     if moveY ~= 0 then
--         player.dirY = moveY 
--     end
    
--     -- Update string direction variable based on prioritized input
--     if moveY == -1 then
--         player.dir = "up" 
--     elseif moveY == 1 then
--         player.dir = "down" 
--     elseif moveX == -1 then
--         player.dir = "left" 
--     elseif moveX == 1 then
--         player.dir = "right" 
--     end

   
-- end 

function player:handleMovement(dt)
    local moveX, moveY = 0, 0
  local animTo = self.animations.idle

  if love.keyboard.isDown("d","right") then moveX=1; animTo=self.animations.walkRight; self.dir="right" end
  if love.keyboard.isDown("a","left")  then moveX=-1; animTo=self.animations.walkLeft;  self.dir="left"  end
  if love.keyboard.isDown("s","down")  then moveY=1; animTo=self.animations.walkDown;  self.dir="down"  end
  if love.keyboard.isDown("w","up")    then moveY=-1; animTo=self.animations.walkUp;    self.dir="up"    end

  -- Switch animation only when it changes
  if self.anim ~= animTo then
    self.anim = animTo
    self.anim:gotoFrame(1)
  end

    -- Normalize diagonal movement (so speed is consistent)
    local nx, ny = normalize.NormalizedVector(moveX, moveY)
    --local vx, vy = nx * self.speed, ny * self.speed
    --self:setLinearVelocity(vx, vy)
    self:setLinearVelocity(nx * self.speed, ny * self.speed)

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