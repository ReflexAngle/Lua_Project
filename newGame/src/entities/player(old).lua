-- src/entities/player.lua

local ObjectPool = require 'src/designPatterns/objectPool'
local normalize = require 'src/math/normalization'


local Player = {}
Player.__index = Player

function Player:new(world, x, y, width, height, colliderRadius)
    local self = setmetatable({}, Player)

    -- Create physics collider
    self.collider = world:newBSGRectangleCollider(x, y, width, height, colliderRadius)
    --self.collider = world:newCircleCollider(dirX, dirY, 1, 1, 50)
    self.collider:setCollisionClass("Player")

    if self.fixtures and self.fixtures['main'] then
        -- Set Filter: Category 1, Mask 0 (collides with nothing), Group 0
        self.fixtures['main']:setFilterData(1, 0, 0)
        print("Player collision disabled for testing.")
    else
         -- Fallback if using raw body/fixture without Windfield structure assumed above
         local fixtures = self.collider.body:getFixtures()
         if fixtures and fixtures[1] then
              fixtures[1]:setFilterData(1, 0, 0)
              print("Player collision disabled via fallback for testing.")
         else
             print("WARN: Could not find player fixture to disable collision.")
        end
    end
    self.collider:setFixedRotation(true)
    self.collider:setLinearDamping(1)

    -- Movement & state
    self.dir = "down"
    self.dirX = 1
    self.dirY = 1
    self.prevDirX = 1
    self.prevDirY = 1
    self.walking = false
    self.aiming = false
    self.speed = 200  -- default should be 75
    self.scaleX = 2
    self.baseDamping = 12
    
    -- -99 = dead
    -- -1 = inactive/idle
    -- 0 = Normal gameplay
    -- 0.5 = Rolling
    -- 1 = Sword swingin
    -- 2 = Use (bomb)
    -- 3 = Bow (3: bow drawn, 3.1: recover)
    -- 4 = grapple (4: armed, 4.1: launching, 4.2: moving)
    -- 10 = Damage stun
    -- 11 = Hold item
    -- 12 = Transition
    self.state = 0

    -- Health
    self.max_hearts = 5
    self.hearts = 3

    -- Sprites
    self.sprites = {
        playerWalkSheet = love.graphics.newImage('sprites/player/playerWalkSheet2.png'),
        fullHPBar = love.graphics.newImage('sprites/items/FullHeart.png'),
        emptyHPBar = love.graphics.newImage('sprites/items/EmptyHeart.png'),
        sword = love.graphics.newImage('sprites/items/sword2.png')
    }

    -- Heart Pool
    self.heartPool = ObjectPool:new(function()
        return {
            sprite = self.sprites.fullHPBar,
            x = 0,
            y = 0,
            active = false
        }
    end, self.max_hearts)

    -- Animations
    local grid = anim8.newGrid(16, 32, self.sprites.playerWalkSheet:getWidth(), self.sprites.playerWalkSheet:getHeight())
    self.animations = {
        idle = anim8.newAnimation(grid('1-1', 1), 0.1),
        walkUp = anim8.newAnimation(grid('3-4', 3), 0.1),
        walkDown = anim8.newAnimation(grid('1-4', 1), 0.1),
        walkLeft = anim8.newAnimation(grid('1-4', 4), 0.1),
        walkRight = anim8.newAnimation(grid('2-4', 2), 0.1),
       -- attack anims
        attackDown = anim8.newAnimation(grid('1-2', 5), 0.1),
        attackUp = anim8.newAnimation(grid('1-2', 6), 0.1),
        attackRight = anim8.newAnimation(grid('1-2', 7), 0.1),
        attackLeft = anim8.newAnimation(grid('1-2', 8), 0.1)
    }

      

    self.animations.currentAnimation = self.animations.idle
    print("Initial Player Body Type:", self.collider:getType())
    return self
end



function Player:update(dt)

      if self.collider and self.collider.body then
        local vx, vy = self.collider:getLinearVelocity()
        print(string.format("Player Update: Type=%s Mass=%.2f Vel=(%.1f, %.1f) Pos=(%.1f, %.1f) State=%d",
              self.collider.body:getType(), self.collider:getMass(), vx, vy, self.collider:getX(), self.collider:getY(), self.state))
    end

    -- Handle movement ONLY when in the normal gameplay state (state 0)
    if self.state == 0 then
        self:handleMovementAndAnimation() -- <<< MUST BE UNCOMMENTED AND CALLED

    -- Handle the attacking state (state 1) and resetting state
    elseif self.state == 1 then
        -- Check if the attack animation has finished
        if self.animations.currentAnimation and
           self.animations.currentAnimation.position == #self.animations.currentAnimation.frames then
            -- Animation finished, return to normal state (0) and idle animation
            self.state = 0
            self.animations.currentAnimation = self.animations.idle
            -- Reset the idle animation to its first frame
            if self.animations.currentAnimation then self.animations.currentAnimation:gotoFrame(1) end
        end
    end

    -- Update the current animation (needs to be called!)
    if self.animations.currentAnimation then
      self.animations.currentAnimation:update(dt)
    end

end

function Player:draw(offsetX, offsetY, scaledWidth, scaledHeight)
    local x, y = self.collider:getX(), self.collider:getY()
    --self.animations.currentAnimation:draw(self.sprites.playerWalkSheet, x, y, 0, self.scaleX, self.scaleX)
    self.animations.currentAnimation:draw(self.sprites.playerWalkSheet, x, y, 0, self.scaleX, self.scaleX, 8, 16)
end

function Player:drawHearts()
    local heartX, heartY = 5, 5
    local heartSpacing = 16 * self.scaleX
    local heartScale = self.scaleX
    
    for i = 1, self.max_hearts do
        local heart = self.heartPool:get()
        heart.x = heartX + (i - 1) * heartSpacing
        heart.y = heartY
        heart.sprite = (i <= self.hearts) and self.sprites.fullHPBar or self.sprites.emptyHPBar
        
        love.graphics.draw(heart.sprite, heart.x, heart.y, 0, heartScale, heartScale)
        self.heartPool:release(heart)
    end
end

function Player:attack()
    -- Use 'not self.aiming' instead of '!player.aiming'
    if self.state == 0 and not self.aiming then
        print("Player: Attack triggered!") -- Keep for debugging

        self.state = 1 -- Set state to attacking
        self.collider:setLinearVelocity(0, 0) -- Stop movement

        -- Select correct attack animation based on facing direction
        if self.dirY > 0 then -- Facing Down
            self.currentAnimation = self.animations.attackDown
        elseif self.dirY < 0 then -- Facing Up
            self.currentAnimation = self.animations.attackUp
        elseif self.dirX < 0 then -- Facing Left
            self.currentAnimation = self.animations.attackLeft
        elseif self.dirX > 0 then -- Facing Right
            self.currentAnimation = self.animations.attackRight
        else -- Default case
            self.currentAnimation = self.animations.attackDown
        end

        -- Reset the animation to the beginning
        if self.currentAnimation then -- Check if animation exists
            self.currentAnimation:gotoFrame(1)
        end
    end
end

function Player:takeDamage()
    self.hearts = math.max(0, self.hearts - 1)
end

function Player:heal()
    self.hearts = math.min(self.max_hearts, self.hearts + 1)
end


function Player:handleMovementAndAnimation()
    -- This function assumes it's only called when self.state == 0

    local moveX, moveY = 0, 0

    -- Check keyboard input and set temporary move direction & animation
    -- Using elseif for opposite directions is slightly cleaner
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        moveX = 1
        self.animations.currentAnimation = self.animations.walkRight
    elseif love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        moveX = -1
        self.animations.currentAnimation = self.animations.walkLeft
    end

    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        moveY = 1
        self.animations.currentAnimation = self.animations.walkDown
    elseif love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        moveY = -1
        self.animations.currentAnimation = self.animations.walkUp
    end

    -- If no movement keys are pressed, set animation to idle
    if moveX == 0 and moveY == 0 then
        self.animations.currentAnimation = self.animations.idle
    end

    -- Normalize diagonal movement
    moveX, moveY = normalize.NormalizedVector(moveX, moveY)

    -- Calculate final velocity vector
    local vec = { x = moveX * self.speed, y = moveY * self.speed }

    -- Print velocity being applied (keep for debugging for now)
    print("Applying Velocity:", vec.x, vec.y, " (Speed:", self.speed, "MoveX:", moveX, "MoveY:", moveY, ")")

    -- Apply velocity to the physics collider
    self.collider:setLinearVelocity(vec.x, vec.y)

    -- Update facing direction based on actual movement input
    -- Only update if there *was* horizontal or vertical input this frame
    if moveX ~= 0 then
        self.dirX = moveX
    end
    if moveY ~= 0 then
        self.dirY = moveY
    end

    -- Note: We also need to store the overall direction ('up', 'down', 'left', 'right')
    -- This determines attack animation. Let's add logic for self.dir
    if moveY == -1 then
        self.dir = "up"
    elseif moveY == 1 then
        self.dir = "down"
    elseif moveX == -1 then
        self.dir = "left"
    elseif moveX == 1 then
        self.dir = "right"
    end
    -- If no movement, self.dir retains its previous value, which is usually desired for idle facing
end

return Player
