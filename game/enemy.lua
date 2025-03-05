local enemy = {}
local enemySpeed = 100
enemy.x = 0
enemy.y = 0


function enemy.DrawEnemy()
    love.graphics.rectangle("fill",enemy.x, enemy.y,10,10)
    
end
function enemy.EnemyMove(playerX, playerY, dt)
    local dx = playerX - enemy.x
    local dy = playerY - enemy.y
    local distance = math.sqrt(dx * dx + dy * dy)

    if distance > 0 then
        enemy.x = enemy.x + (dx / distance) * enemySpeed * dt
        enemy.y = enemy.y + (dy / distance) * enemySpeed * dt
    end
end
function EnemyFollowPlayer()

end
return enemy

