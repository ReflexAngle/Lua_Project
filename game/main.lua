local major, minor, revision = love.getVersion()
local screenWidth = love.graphics.getWidth() -- Gets the screen width
local screenHeight = love.graphics.getHeight() -- Gets the screen height

--local anim8 = require('libs.anim8') -- anim8 library for animations
local player = require("src.player") -- player class
local slash = require("src.slash") -- slash class
local drag = require("src.drag") -- drag class
local enemy = require("enemy") -- load the enemy thing
local jason = require("src.loadGameData")
local normalize = require("normalization") -- load the normalization thing
local cameraFollow = require("cameraFollow") -- load the camera follow thing

-- setting bg sprites
local sprites = {
    background = love.graphics.newImage("assets/imgs/background.png"),
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
local playerScaler = 3 -- scales player sprites



function love.load() -- This runs once at the start of the game
    -- create a player data file
    jason.LoadPlayerData()
    -- Seed the random number generator because aparently it's not seeded by default 
    -- like in other languages
    math.randomseed(os.time()) 

    enemy.pickEnemyStrategy() -- Pick a random strategy

    -- fonts
    local font = love.graphics.newFont(16)
    love.graphics.setFont(font)
    player:load(screenWidth, screenHeight, frameWidth, frameHeight, playerScaler)
    slash:load()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    enemy.spawnEnemy(screenWidth, screenHeight)
    

end

function love.update(dt)
    --local pressed = false
    print
    local dx, dy = 0, 0

    slash:update(dt)
    enemy.EnemyWaveHandling(dt, screenWidth, screenHeight)

    --mouse movement for dragging
    if  player.dragging then
        player.transform.x = love.mouse.getX() - player.transform.width / 2
        player.transform.y = love.mouse.getY() - player.transform.height / 2
    end

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

    -- basic attack functions
    if love.keyboard.isDown("space") then
        player:attack()
        slash:activate(player)

    end

    if dx ~= 0 or dy ~= 0 then
        local normDx, normDy = normalize.NormalizedVector(dx, dy)
        player.transform.x = player.transform.x + normDx * player.walkSpeed
        player.transform.y = player.transform.y + normDy * player.walkSpeed
    else
        player.animations.currWalk = player.animations.idle

    end
    
    -- if not pressed then
    --     player.animations.currWalk = player.animations.idle
    -- end
    player:update(dt) -- updates the current animation

    enemy.EnemyMove(player.transform.x, player.transform.y, dt)
    
    cameraFollow.FollowPlayer(player)

end

function love.draw() -- draws graphics
    cameraFollow.Apply() -- apply cameraFollow
    
 
    -- drawing background 
    love.graphics.draw(sprites.background, offsetX, offsetY, 0, scale, scale) 
    
    -- draw player
    player:draw(offsetX, offsetY, scaledWidth, scaledHeight)
    slash:draw()
    enemy.DrawEnemy()
    drag.init(player) -- drag function input anything
    cameraFollow.Reset() -- apply cameraFollow
    
    --draw HUD elements
    player:drawHearts()
end
-- drag functions
function love.mousepressed(x, y, button)
    drag.mousepressed(x, y, button)
end


function love.mousereleased(x, y, button)
    drag.mousereleased(x, y, button)
end
