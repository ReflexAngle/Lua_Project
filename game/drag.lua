local drag = {}

function drag.mousepressed(x, y)
    if x > player.transform.x
        and x < player.transform.x + player.transform.width
        and y > player.transform.y
        and y < player.transform.y + player.transform.height
    then
        player.dragging = true
    end
end

function drag.update()
    if  player.dragging then
        player.transform.x = love.mouse.getX() - player.transform.width / 2
        player.transform.y = love.mouse.getY() - player.transform.height / 2
    end
end

function drag.mousereleased()
    player.dragging = false
end

return drag
