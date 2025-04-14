--local saveData = require("scripts/events/saveDataEvent")
local cameraFollow = require("src/camera/cameraFollow")
--local normalize = require("scripts/math/normalization")
local enemy = require("src/enemies/enemyBehavior")

function love.load()
    print("game loading")
    
    require("src/startup/gameStart")
    gameStart()
    createNewSave()

    loadMap("lightmap")
    colliderToggle = false
   --create save point

    enemySpawnTimer = 0
    enemySpawnInterval = 2 -- Spawn an enemy every 2 seconds
end

function love.update(dt)
    updateAll(dt)


    enemySpawnTimer = enemySpawnTimer + dt
    if enemySpawnTimer >= enemySpawnInterval then
       enemy.spawnEnemy(love.graphics.getWidth(), love.graphics.getHeight())
       enemySpawnTimer = 0
    end
    
    if player then
        print("following the player")
        print("player state: ", player.state)
        print("player pos X : ", player.x)
        --cameraFollow.FollowPlayer(player)
    end
    -- if player then
    --     enemy.EnemyMove(player.collider:getX(), player.collider:getY(), dt)
    -- end
end
    
function love.draw()
    --cameraFollow.Apply()
    --drawBeforeCamera()
    cam:attach()
          drawCamera()
          if colliderToggle then
              world:draw()
             --particleWorld:draw()
          end
    cam:detach()
    --drawAfterCamera()

    enemy.DrawEnemy()
    --cameraFollow.Reset()

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