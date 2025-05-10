--local saveData = require("scripts/events/saveDataEvent")
local cameraFollow = require("src/camera/cameraFollow")
--local normalize = require("scripts/math/normalization")
local StateMachine = require("src/states/stateMachine")
local enemy = require("src/enemies/enemyBehavior")
local Commands = require("src/command/commands")

-- loading
function love.load()
    print("game loading")
    require("src/startup/gameStart")
     GState = StateMachine.new()
    gameStart()
    --createNewSave()
    currMap = "menu"

    --loadMap("lightmap")
    loadMap(currMap)
    colliderToggle = false
   --create save point

    enemySpawnTimer = 0
    enemySpawnInterval = 2 -- Spawn an enemy every 2 seconds
end




-- update
function love.update(dt)
    -- this will show our game state it console
    print("This is the current GameState:")
    print(gamestate)
    if gamestate == 1 then
        updateAll(dt) 

        enemySpawnTimer = enemySpawnTimer + dt
        if enemySpawnTimer >= enemySpawnInterval then
            enemy.spawnEnemy(love.graphics.getWidth(), love.graphics.getHeight())
            enemySpawnTimer = 0
        end
    end
end




-- drawing
function love.draw()
    --cameraFollow.Apply()
    drawBeforeCamera()
    cam:attach()
    drawCamera()
    if colliderToggle then
        world:draw()
        --particleWorld:draw()
    end
    cam:detach()
    drawAfterCamera()

    
    enemy.DrawEnemy()
end






-- util functs
function love.keypressed(key)
    if currMap == "menu" and (key == "return" or key == "space") then
        print("the map should change gamestate: " )
        print(gamestate)
        gamestate = 1
        currMap = "lightmap"
        loadMap(currMap)
    end
            if key == "escape" then
                love.event.quit()

            elseif key == "f12" then
                local isFullscreen = love.window.getFullscreen()
                love.window.setFullscreen(not isFullscreen)
                
            elseif key == "f9" then -- Collider toggle
                colliderToggle = not colliderToggle
            elseif key == 'space' then
                player:swingSword()
            elseif key == "q" then -- Heal key
                if player and Commands and Commands.HealCommand then
                    -- Here, you explicitly create the command to heal by 1 heart
                    local healPlayerCommand = Commands.HealCommand:new(player, 1)
                    healPlayerCommand:execute()
                else
                print("Error: Player or HealCommand not available.")
                end
            end
            -- if key == 'return' or key == 'tab' or key == 'e' then
            --     if gamestate == 1 then
            --         pause:toggle()
            --     end
            -- end
end

    