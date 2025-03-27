local enemy = {}

local enemylist = {}
local DrawEnemy1 = require("Strategies.enemyOne")
local DrawEnemy2 = require("Strategies.enemyTwo")
local DrawEnemy3 = require("Strategies.enemyThree")
local EnemyEvents = require("eventManager")

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

local normalize = require("normalization")

function enemy.DrawEnemy()
    if enemy.currentStrategy then
        enemy.currentStrategy.execute(enemy)
    else
        print("No strategy selected!")
    end
end


function enemy.EnemyMove(playerX, playerY, dt)
    local dx = playerX - enemy.x
    local dy = playerY - enemy.y

    local normDx, normDy = normalize.NormalizedVector(dx, dy)

    enemy.x = enemy.x + normDx * enemy.enemySpeed * dt
    enemy.y = enemy.y + normDy * enemy.enemySpeed * dt
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
    local side = math.random(1,4)

    if side == 1 then
        enemy.x = math.random(0, screenWidth)
        enemy.y = -20
    elseif side == 2 then
        -- Spawn below the screen
        enemy.x = math.random(0, screenWidth)
        enemy.y = screenHeight + 20
    elseif side == 3 then
        -- Spawn to the left of the screen
        enemy.x = -20
        enemy.y = math.random(0, screenHeight)
    elseif side == 4 then
        -- Spawn to the right of the screen
        enemy.x = screenWidth + 20
        enemy.y = math.random(0, screenHeight)
    end
    print(side)
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
