local saveData = require("scripts/events/saveDataEvent")
local cameraFollow = require("scripts/camera/cameraFollow")
local normalize = require("scripts/math/normalization")
local player = require("scripts/entities/player")
local enemy = require("scripts/enemies/enemyBehavior")


-- setting bg sprites
--local sprites = {
--    background = love.graphics.newImage("assets/imgs/background.png"),
--}

-- scaling and sizing
--local bgWidth = sprites.background:getWidth()
--local bgHeight = sprites.background:getHeight()
--local scale = math.min(screenWidth / 10, screenHeight / 10)
--local scaledWidth = 10 * scale
--local scaledHeight = bgHeight * scale
--local offsetX = (screenWidth - scaledWidth) / 2
--local offsetY = (screenHeight - scaledHeight) / 2
local frameWidth = 16
local frameHeight = 32
local playerScaler = 3 -- scales player sprites


function love.load()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
     player:load(screenWidth, screenHeight, frameWidth, frameHeight, playerScaler)
     --slash:load()
end

function love.update(dt)
    
    --keyboard movement
        if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
            --player.transform.x = player.transform.x + player.walkSpeed
            dx = dx + 1
            player.animations.currWalk = player.animations.walkRight
            player.direction = "right"
        end
    
        if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
            --player.transform.x = player.transform.x - player.walkSpeed
            dx = dx - 1
            player.animations.currWalk = player.animations.walkLeft
            player.direction = "left"
        end
    
        if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
            --player.transform.y = player.transform.y - player.walkSpeed
            dy = dy - 1
            player.animations.currWalk = player.animations.walkUp
            player.direction = "up"
        end
    
        if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
            --player.transform.y = player.transform.y + player.walkSpeed
            dy = dy + 1
            player.animations.currWalk = player.animations.walkDown
            player.direction = "down"
        end
end

function love.draw()
    player:draw(offsetX, offsetY, scaledWidth, scaledHeight)
    player:drawHearts()
end
