local drag = {}

local player = nil

function drag.init(p)
    player = p
end


-- was testing a drag func, you should be able to drag the player
function drag.mousepressed(x, y, button)
    if button == 1 and player then   
        if x > player.transform.x
            and x < player.transform.x + player.transform.width
            and y > player.transform.y
            and y < player.transform.y + player.transform.height then
            player.dragging = true
        end
    end
end

function drag.mousereleased(x, y, button)
    if button == 1 and player then 
        player.dragging = false
    end
end

function drag.update()
    if player and player.dragging then
        player.transform.x = love.mouse.getX() - player.transform.width / 2
        player.transform.y = love.mouse.getY() - player.transform.height / 2
    end
end

return drag