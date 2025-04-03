-- src/entities/player.lua

local anim8 = require 'libs/anim8'
local ObjectPool = require 'src/designPatterns/objectPool'
local normalize = require 'src/math/normalization'


local Player = {}
Player.__index = Player

function Player:new(world, x, y, width, height, colliderRadius)
    local self = setmetatable({}, Player)

    -- Create physics collider
    self.collider = world:newBSGRectangleCollider(x, y, width, height, colliderRadius)
    self.collider:setCollisionClass("Player")
    self.collider:setFixedRotation(true)
    self.collider:setLinearDamping(12)

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
        walkDown = anim8.newAnimation(grid('1-4', 1), 0.1),
        walkRight = anim8.newAnimation(grid('2-4', 2), 0.1),
        walkUp = anim8.newAnimation(grid('3-4', 3), 0.1),
        walkLeft = anim8.newAnimation(grid('4-4', 4), 0.1),
        attackDown = anim8.newAnimation(grid('1-2', 5), 0.1),
        attackUp = anim8.newAnimation(grid('1-2', 6), 0.1),
        attackRight = anim8.newAnimation(grid('1-2', 7), 0.1),
        attackLeft = anim8.newAnimation(grid('1-2', 8), 0.1)
    }

    self.animations.currentAnimation = self.animations.idle
    return self
end



function Player:update(dt)

    if self.state == -1 then return end -- if player idle do nothing

    if self.state == 0 then  -- if player is playing do movement 
       self:handleMovementAndAnimation()
    elseif self.state == 1 then -- if play attacks 
        self:handleAttackAnimation(dt)
        -- try to prevent movement and keep the sword in diagonal pos to player
    end

    
    self.animations.currentAnimation:update(dt)
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
    local moveX, moveY = 0, 0
         if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
            moveX = 1 
            self.animations.currentAnimation = self.animations.walkRight    
            end

         if love.keyboard.isDown("a") or love.keyboard.isDown("left") then 
            moveX = -1
            self.animations.currentAnimation = self.animations.walkLeft    
            end

         if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
            moveY = 1
            self.animations.currentAnimation = self.animations.walkDown
            end

         if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
            moveY = -1
            self.animations.currentAnimation = self.animations.walkUp    
            end

        --  Use the function from your normalize module ***
            moveX, moveY = normalize.NormalizedVector(moveX, moveY) -- Call the function

            -- Apply velocity (using the potentially normalized moveX, moveY)
            local vec = { x = moveX * self.speed, y = moveY * self.speed }
            self.collider:setLinearVelocity(vec.x, vec.y)

            -- Update facing direction (stores the last non-zero direction)
            if moveX ~= 0 then self.dirX = moveX end
            if moveY ~= 0 then self.dirY = moveY end
        end

return Player
