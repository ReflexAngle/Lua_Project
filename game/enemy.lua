local enemy = {}

local DrawEnemy1 = require("strategies.enemyOne")
local DrawEnemy2 = require("strategies.enemyTwo")
local DrawEnemy3 = require("strategies.enemyThree")

local EnemyEvents = require("eventManager")

local strategies = { DrawEnemy1, DrawEnemy2, DrawEnemy3 }
enemy.currentStrategy = nil

enemy.enemySpeed = 0
local enemyHealth = nil
enemy.x = 0
enemy.y = 0

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

-- spawns the enemies a distance off the camera
-- should use the Object Pool pattern to decide the enemies
function enemy.EnemyObjectPool()
    local currentEnemy
end

function enemy.EnemySpawnerAmount()
    
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


return enemy

