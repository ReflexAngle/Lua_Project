local major, minor, revision = love.getVersion()
local screenWidth = love.graphics.getWidth() -- Gets the screen width
local screenHeight = love.graphics.getHeight() -- Gets the screen height

--local anim8 = require('libs.anim8') -- anim8 library for animations
local player = require("src.player") -- player class

-- setting sprites
local sprites = {
    background = love.graphics.newImage("assets/imgs/background.png"),
    --player = love.graphics.newImage("Player.png"),
    --playerWalkSheet = love.graphics.newImage("playerWalkSheet.png")
}

-- scaling and sizing
local bgWidth = sprites.background:getWidth()
local bgHeight = sprites.background:getHeight()
local scale = math.min(screenWidth / bgWidth, screenHeight / bgHeight)
local scaledWidth = bgWidth * scale
local scaledHeight = bgHeight * scale
local offsetX = (screenWidth - scaledWidth) / 2
local offsetY = (screenHeight - scaledHeight) / 2

local frameWidth = 16
local frameHeight = 32
local playerScaler = 3 -- scales player sprite

-- grid for anim8 to use to pick for animations
--local grid = anim8.newGrid(frameWidth, frameHeight, sprites.playerWalkSheet:getWidth(), sprites.playerWalkSheet:getHeight()) -- Creates a grid for the player sprite



-- main player config
-- local player =
-- {
--     dragging = false,
--     pressed = false,
--     walkSpeed = 3,
--     transform = {
--         x = (screenWidth - frameWidth * playerScaler) / 2,
--         y = (screenHeight - frameHeight * playerScaler) / 2,
--         width = frameWidth * playerScaler,
--         height = frameHeight * playerScaler
--     },

--     animations = {
--         idle = anim8.newAnimation(grid('1-1', 1), 0.1),
--         walkDown = anim8.newAnimation(grid('1-4', 1), 0.1),
--         walkRight = anim8.newAnimation(grid('2-4', 2), 0.1),
--         walkUp = anim8.newAnimation(grid('3-4', 3), 0.1),
--         walkLeft = anim8.newAnimation(grid('4-4', 4), 0.1),
--         currWalk = anim8.newAnimation(grid('1-4', 1), 0.1),
--     }
-- }



function love.load() -- This runs once at the start of the game
    -- fonts
    local font = love.graphics.newFont(16)
    love.graphics.setFont(font)
    player:load(screenWidth, screenHeight, frameWidth, frameHeight, playerScaler)
end

function love.update(dt)
    local pressed = false

    --mouse movement for dragging
    if  player.dragging then
        player.transform.x = love.mouse.getX() - player.transform.width / 2
        player.transform.y = love.mouse.getY() - player.transform.height / 2
    end

    --keyboard movement
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        player.transform.x = player.transform.x + player.walkSpeed
        player.animations.currWalk = player.animations.walkRight
        pressed = true
    end

    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        player.transform.x = player.transform.x - player.walkSpeed
        player.animations.currWalk = player.animations.walkLeft
        pressed = true
    end

    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        player.transform.y = player.transform.y - player.walkSpeed
        player.animations.currWalk = player.animations.walkUp
        pressed = true
    end

    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        player.transform.y = player.transform.y + player.walkSpeed
        player.animations.currWalk = player.animations.walkDown
        pressed = true
    end
    
    if not pressed then
        player.animations.currWalk = player.animations.idle
    end
    player:update(dt) -- updates the current animation
end

function love.draw() -- draws graphics

    -- game title and version of love
    love.graphics.print("Love2D version: " .. major .. "." .. minor .. "." .. revision .. " (The Legend of Kofe Version: Alpha 0.00.01)")
 
    -- drawing background 
    love.graphics.draw(sprites.background, offsetX, offsetY, 0, scale, scale) 
    -- draw player
    player:draw(offsetX, offsetY, scaledWidth, scaledHeight)
    -- testing walk animations
    -- player.animations.currWalk:draw(
    -- sprites.playerWalkSheet,
    -- offsetX + player.transform.x,
    -- offsetY + player.transform.y,
    -- 0,
    -- playerScaler,
    -- playerScaler)
end




-- was testing a drag func, you should be able to drag the player
function love.mousepressed(x, y)
    if x > player.transform.x
        and x < player.transform.x + player.transform.width
        and y > player.transform.y
        and y < player.transform.y + player.transform.height then
        player.dragging = true
    end
end

function love.mousereleased()
    player.dragging = false
end