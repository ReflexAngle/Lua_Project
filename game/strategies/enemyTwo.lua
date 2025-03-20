local DrawEnemy2 = {}

function DrawEnemy2.execute(enemy)
    enemy.enemySpeed = 50
    enemy.enemyHealth = 200
    love.graphics.setColor(1, 0, 0) -- Red
    love.graphics.rectangle("fill", enemy.x, enemy.y, 10, 10)
    love.graphics.setColor(1, 1, 1) -- Reset color to white

end

return DrawEnemy2