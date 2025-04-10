local DrawEnemy3 = {}

function DrawEnemy3.execute(enemy)
    enemy.enemySpeed = 200
    enemy.enemyHealth = 50
    love.graphics.setColor(0, 1, 0) -- Green
    love.graphics.rectangle("fill", enemy.x, enemy.y, 10, 10)
    love.graphics.setColor(1, 1, 1) -- Reset color to white
    enemy.enemyDamage = 5

end

return DrawEnemy3