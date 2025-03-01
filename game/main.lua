local major, minor, revision, codename = love.getVersion()
local screenWidth = love.graphics.getWidth() -- Gets the screen width
local screenHeight = love.graphics.getHeight() -- Gets the screen height

local anim8 = require("anim8") -- anim8 library for animations


-- scaling and sizing
local playerScaler = 3 -- Scales the player sprite by 3
local scale = math.min(screenWidth / bgWidth, screenHeight / bgHeight)
local scaledWidth = bgWidth * scale
local scaledHeight = bgHeight * scale

local offsetX = (screenWidth - scaledWidth) / 2
local offsetY = (screenHeight - scaledHeight) / 2

-- setting up player specs and sprites
local sprites = {
    background = love.graphics.newImage("background.png"),
    player = love.graphics.newImage("Player.png"),
}

local bgWidth = sprites.background:getWidth()
local bgHeight = sprites.background:getHeight()

local player =
{
    dragging = false,
    transform = {
    x = (screenWidth - 126) / 2,
    y = (screenHeight - 176) / 2,
    width = 126,
    height = 176,
},
}



function love.load() -- This runs once at the start of the game
    
local font = love.graphics.newFont(16)
love.graphics.setFont(font)
    
    
   
end

function love.update(dt) -- This runs every frame (dt is the time since last frame)
    if  player.dragging then
        player.transform.x = love.mouse.getX() - player.transform.width / 2
        player.transform.y = love.mouse.getY() - player.transform.height / 2
    end


-- arrow key movement
    if love.keyboard.isDown("right") then
        player.transform.x = player.transform.x + 5
    end

    if love.keyboard.isDown("left") then
        player.transform.x = player.transform.x - 5
    end

    if love.keyboard.isDown("up") then
        player.transform.y = player.transform.y - 5
    end

    if love.keyboard.isDown("down") then
        player.transform.y = player.transform.y + 5
    end
end

function love.draw() -- draws graphics
    love.graphics.draw(sprites.background, offsetX, offsetY, 0, scale, scale) 
    love.graphics.draw(sprites.player, player.transform.x, player.transform.y, 0, playerScaler, playerScaler) -- Draws the player sprite
    love.graphics.print("Love2D version: " .. major .. "." .. minor .. "." .. revision .. " (The Legend of Kofe Version: Alpha 0.00.01)")

end




-- was testing a drag func, you should be able to drag the player
function love.mousepressed(x, y)
    if x > player.transform.x
        and x < player.transform.x + player.transform.width
        and y > player.transform.y
        and y < player.transform.y + player.transform.height
    then
        player.dragging = true
    end
end

function love.mousereleased()
    player.dragging = false
end