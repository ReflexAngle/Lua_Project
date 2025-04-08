local enemy = {}

local enemylist = {}
local DrawEnemy1 = require("src.enemies.Strategies.enemyOne")
local DrawEnemy2 = require("src.enemies.Strategies.enemyTwo")
local DrawEnemy3 = require("src.enemies.Strategies.enemyThree")
local EnemyEvents = require("src.events.saveDataEvent")
--local waveProperties = require("scripts.events.waveProperties")

local strategies = { DrawEnemy1, DrawEnemy2, DrawEnemy3 }
enemy.currentStrategy = nil

enemy.enemySpeed = 0
local enemyHealth = nil
enemy.x = 0
enemy.y = 0

local nextSpawnTime = love.timer.getTime() + 1

function enemy.pickEnemyStrategy()
    local strategyIndex = math.random(1, #strategies)
    enemy.currentStrategy = strategies[strategyIndex]
end

local normalize = require("src.math.normalization")

function enemy.DrawEnemy()
    for _, e in ipairs(enemylist) do
        if e.strategy and e.strategy.execute then
            e.strategy.execute(e) -- Use the enemy's strategy to draw it
        else
            print("No strategy selected for enemy!") -- Debugging message
        end
    end
end


function enemy.EnemyMove(playerX, playerY, dt)
    for _, e in ipairs(enemylist) do
        local dx = playerX - e.x
        local dy = playerY - e.y

        local normDx, normDy = normalize.NormalizedVector(dx, dy)

        e.x = e.x + normDx * e.enemySpeed * dt
        e.y = e.y + normDy * e.enemySpeed * dt
    end
    -- local distance = math.sqrt(dx * dx + dy * dy)

    -- if distance > 0 then
    --     enemy.x = enemy.x + (dx / distance) * enemySpeed * dt
    --     enemy.y = enemy.y + (dy / distance) * enemySpeed * dt
    -- end
end
function enemy.RayCast(x1,y1,x2,y2, obstacles)
    -- should return true if there is a collision
    -- else, return false

    local steps
    
    local dx = x2 - x1
    local dy = y2 - y1
    local distance = math.max(math.abs(dx), math.abs(dy))
    local xIncrement = dx / steps
    local yIncrement = dy / steps

    local x = x1
    local y = y1

    for i = 1, steps do
        x = x + xIncrement
        y = y + yIncrement

        for _, obstacle in ipairs(obstacles) do
            if x > obstacle.x and x < obstacle.x + obstacle.width and y > obstacle.y and y < obstacle.y + obstacle.height then
                return true
            end
        end
    end
end

function enemy.EnemySpawnerAmount()
    -- handles the amout of enemies that spawn
    -- based on the amount form the eventManager
    -- after each wave the amount of enemies increases in the eventManager

    local enemyAmount = EnemyEvents.getEnemyAmount()
end

function enemy.spawnEnemy(screenWidth, screenHeight)
    local side = math.random(1, 4)
    local x, y

    if side == 1 then
        x = math.random(0, screenWidth)
        y = -20
    elseif side == 2 then
        x = math.random(0, screenWidth)
        y = screenHeight + 20
    elseif side == 3 then
        x = -20
        y = math.random(0, screenHeight)
    elseif side == 4 then
        x = screenWidth + 20
        y = math.random(0, screenHeight)
    end

    -- Create a new enemy with a random strategy
    local newEnemy = {
        x = x,
        y = y,
        enemySpeed = 0,
        enemyHealth = 100,
        strategy = strategies[math.random(1, #strategies)] -- Assign a random strategy
    }

    table.insert(enemylist, newEnemy)
end

function enemy.updateEnemies(playerX, playerY, dt)
    for _, e in ipairs(enemylist) do
        -- Move the enemy towards the player
        local dx = playerX - e.x
        local dy = playerY - e.y
        local distance = math.sqrt(dx * dx + dy * dy)

        if distance > 0 then
            e.x = e.x + (dx / distance) * e.enemySpeed * dt
            e.y = e.y + (dy / distance) * e.enemySpeed * dt
        end
    end
end

function enemy.drawEnemies()
    for _, e in ipairs(enemylist) do
        if e.strategy and e.strategy.execute then
            e.strategy.execute(e) -- Use the enemy's strategy to draw it
        end
    end
end

-- handels the spawnig of enemies
-- when they spawn, how many spawn, etc
function enemy.EnemyWaveHandling(dt, screenWidth, screenHeight)
    if not enemy.spawnTimer then
        enemy.spawnTimer = 0
    end

    -- Number of enemies to spawn per wave
    local enemiesPerWave = 10

    -- Spawn interval in seconds
    local spawnInterval = 1

    -- Increment the timer
    enemy.spawnTimer = enemy.spawnTimer + dt

    -- Check if it's time to spawn a new wave
    if enemy.spawnTimer >= spawnInterval then
        for i = 1, enemiesPerWave do
            -- Spawn an enemy
            enemy.spawnEnemy(screenWidth, screenHeight)
            enemy.pickEnemyStrategy()
        end

        -- Reset the timer
        enemy.spawnTimer = 0
    end
    
end

function enemy.HandleEnemyAttack()
    -- if enemy is within range of player, attack
    -- else, move towards player
end



return enemy
