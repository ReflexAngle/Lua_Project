--local saveData = require("scripts/events/saveDataEvent")
local cameraFollow = require("src/camera/cameraFollow")

--local normalize = require("scripts/math/normalization")
local enemy = require("src/enemies/enemyBehavior")
--local mapLoader = require("src/levels/loadMap")
-- setting bg sprites   
--local sprites = {
    --    background = love.graphics.newImage("assets/imgs/background.png"),
    --}
    
    
    
    
function love.load()
    print("game loading")
    require("src/startup/gameStart")
    gameStart()
    --mapLoader.loadMap("TestMap3")
    loadMap("darkmap")
    colliderToggle = false
        
    local Player = require("src/entities/player")
    player = Player:new(world, 500, 400, 16, 32, 8)
--    --createNewSave()

    enemySpawnTimer = 0
    enemySpawnInterval = 2 -- Spawn an enemy every 2 seconds
end

function love.update(dt)
    --updateAll(dt)
    world:update(dt)
    if gameMap then gameMap:update(dt) end
    if player and player.update then
       player:update(dt) end

    enemySpawnTimer = enemySpawnTimer + dt
    if enemySpawnTimer >= enemySpawnInterval then
       enemy.spawnEnemy(love.graphics.getWidth(), love.graphics.getHeight())
       enemySpawnTimer = 0
    end
    
    if player then
        print("following the player")
        cameraFollow.FollowPlayer(player)
    end
    if player then
        enemy.EnemyMove(player.collider:getX(), player.collider:getY(), dt)
        enemy.HandleEnemyAttack(player)
    end
end
    
function love.draw()
    -- draw background
    --love.graphics.draw(sprites.background, 0, 0, 0, love.graphics.getWidth()/sprites.background:getWidth(), love.graphics.getHeight()/sprites.background:getHeight())
    cameraFollow.Apply()
    -- draws gamemap
    if gameMap then gameMap:draw() end

    -- draw  before camera method
    -- cam:attach()
    -- drawCamera()
    if colliderToggle and world.draw then
        world:draw()
        --particleWorld:draw()
    end
    if player and player.draw then
       player:draw()

    end
    enemy.DrawEnemy()
    
    --cam:detach()
    -- draw after cam method
    cameraFollow.Reset()

    if player and player.drawHearts then
        player:drawHearts()
     end

end

--player:draw(offsetX, offsetY, scaledWidth, scaledHeight)
--player:drawHearts()

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()


    elseif key == "f12" then
        local isFullscreen = love.window.getFullscreen()
        love.window.setFullscreen(not isFullscreen)


    elseif key == "f9" then -- Or any key you prefer
        colliderToggle = not colliderToggle

    elseif key == "space" then -- Or "k", "z", etc.
        if player and player.attack then -- Check if player and the method exist
           player:attack()
        end
    end
end