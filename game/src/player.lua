local anim8 = require 'libs/anim8'
local ObjectPool = require 'patterns/objectPool'


local Player = {}

function Player:load(screenWidth, screenHeight, frameWidth, frameHeight, playerScaler)
    self.sprites = {
        playerWalkSheet = love.graphics.newImage('assets/imgs/playerWalkSheet.png'),
        fullHPBar = love.graphics.newImage('assets/imgs/fullHPBar.png'),
        emptyHPBar = love.graphics.newImage('assets/imgs/emptyHPBar.png')
    }
    self.max_hearts = 3
    self.hearts = self.max_hearts
    self.walkSpeed = 3
    self.playerScaler = 3
    self.dragging = false
    self.pressed = false
    self.transform = {
        x = (screenWidth - frameWidth * playerScaler) / 2,
        y = (screenHeight - frameHeight * playerScaler) / 2,
        width = frameWidth * playerScaler,
        height = frameHeight * playerScaler
    }

    -- load player sprites
    
    -- grid for anim8
    local grid = anim8.newGrid(
    frameWidth,
    frameHeight,
    self.sprites.playerWalkSheet:getWidth(),
    self.sprites.playerWalkSheet:getHeight())

    -- player animations
    self.animations = {
        idle = anim8.newAnimation(grid('1-1', 1), 0.1),
        walkDown = anim8.newAnimation(grid('1-4', 1), 0.1),
        walkRight = anim8.newAnimation(grid('2-4', 2), 0.1),
        walkUp = anim8.newAnimation(grid('3-4', 3), 0.1),
        walkLeft = anim8.newAnimation(grid('4-4', 4), 0.1),
        currWalk = anim8.newAnimation(grid('1-4', 1), 0.1),
    }
    --default animation
    self.animations.currWalk = self.animations.idle
end



function Player:update(dt)
    self.animations.currWalk:update(dt)    
end




function Player:draw(offsetX, offsetY, scaledWidth, scaledHeight)
    self.animations.currWalk:draw(self.sprites.playerWalkSheet,
    self.transform.x,
    self.transform.y,
    0,
    self.playerScaler,
    self.playerScaler)
    
end

return Player