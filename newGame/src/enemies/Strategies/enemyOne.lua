local DrawEnemy1 = {}

function DrawEnemy1.execute(enemy)
    enemy.enemySpeed = 100
    enemy.enemyHealth = 100
    love.graphics.setColor(1, 1, 1) -- White
    love.graphics.rectangle("fill", enemy.x, enemy.y, 10, 10)
    love.graphics.setColor(1, 1, 1) -- Reset color to white
    enemy.enemyDamage = 20 -- Default damage

end

return DrawEnemy1