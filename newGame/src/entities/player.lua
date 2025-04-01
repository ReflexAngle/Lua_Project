-- src/entities/player.lua

local anim8 = require 'libs/anim8'
local ObjectPool = require 'src/designPatterns/objectPool'

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
    self.state = -1
    self.walking = false
    self.aiming = false
    self.speed = 75
    self.scaleX = 1

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
    local grid = anim8.newGrid(16, 16, self.sprites.playerWalkSheet:getWidth(), self.sprites.playerWalkSheet:getHeight())
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

    self.animations.currWalk = self.animations.idle
    return self
end

function Player:update(dt)
    if self.state == 99 then return end

    if self.state == 0 then
        self.prevDirX = self.dirX
        self.prevDirY = self.dirY

        local dirX, dirY = 0, 0

        if love.keyboard.isDown("d") or love.keyboard.isDown("right") then dirX = 1; self.dirX = 1 end
        if love.keyboard.isDown("a") or love.keyboard.isDown("left") then dirX = -1; self.dirX = -1 end
        if love.keyboard.isDown("s") or love.keyboard.isDown("down") then dirY = 1; self.dirY = 1 end
        if love.keyboard.isDown("w") or love.keyboard.isDown("up") then dirY = -1; self.dirY = -1 end

        if dirY == 0 and dirX ~= 0 then self.dirY = 1 end

        local vec = { x = dirX * self.speed, y = dirY * self.speed }
        self.collider:setLinearVelocity(vec.x, vec.y)
    end

    self.animations.currWalk:update(dt)
end

function Player:draw(offsetX, offsetY, scaledWidth, scaledHeight)
    local x, y = self.collider:getX(), self.collider:getY()
    self.animations.currWalk:draw(self.sprites.playerWalkSheet, x, y, 0, self.scaleX, self.scaleX)
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

function Player:takeDamage()
    self.hearts = math.max(0, self.hearts - 1)
end

function Player:heal()
    self.hearts = math.min(self.max_hearts, self.hearts + 1)
end

return Player
