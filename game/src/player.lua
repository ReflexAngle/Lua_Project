local anim8 = require 'libs/anim8'
local ObjectPool = require 'patterns/objectPool'
print("Obj Pool: ", ObjectPool)

local Player = {}

function Player:load(screenWidth, screenHeight, frameWidth, frameHeight, playerScaler)
    --init max hearts before assigning curr hearts
    self.max_hearts = 3
    self.hearts = self.max_hearts
    self.walkSpeed = 3
    self.playerScaler = playerScaler
    self.dragging = false
    self.pressed = false
    
    self.sprites = {
        playerWalkSheet = love.graphics.newImage('assets/imgs/playerWalkSheet.png'),
        fullHPBar = love.graphics.newImage('assets/imgs/FullHeart.png'),
        emptyHPBar = love.graphics.newImage('assets/imgs/EmptyHeart.png')
    }

    --ObjectPooling for hearts
    self.heartPool = ObjectPool:new(
    function()
        print("Creating new heart")
        return {
            sprite = self.sprites.fullHPBar,
            x = 0,
            y = 0,
            active = false
            }
        end, self.max_hearts) -- init pool size
    
    -- player transform
    self.transform = {
        x = (screenWidth - frameWidth * playerScaler) / 2,
        y = (screenHeight - frameHeight * playerScaler) / 2,
        width = frameWidth * playerScaler,
        height = frameHeight * playerScaler
    }
    
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

function Player:takeDamage()
    self.hearts = math.max(0, self.hearts - 1)
end

function Player:heal()
    self.hearts = math.min(self.max_hearts, self.hearts + 1)
end

function Player:update(dt)
    self.animations.currWalk:update(dt)    
end



function Player:drawHearts()
    local heartX, heartY = 5, 5
    local heartSpacing = 16 * self.playerScaler
    local heartScale = self.playerScaler
    

    for i = 1, self.max_hearts do
        local heart = self.heartPool:get()
        heart.x = heartX + (i-1) * heartSpacing
        heart.y = heartY
        heart.sprite = (i <= self.hearts) and self.sprites.fullHPBar or self.sprites.emptyHPBar
        
        --Draw heart
        love.graphics.draw(heart.sprite, heart.x, heart.y, 0, heartScale, heartScale)

        --Release heart back into pool
        self.heartPool:release(heart)
    end
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