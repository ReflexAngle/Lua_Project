menu = {}

function menu:draw()
    if gamestate == 0 then
        love.graphics.setFont(fonts.pause1)
        love.graphics.setColor(1, 1, 1, 1)

        --love.graphics.printf("1.  File #1", love.graphics.getWidth()/2 - 4000, 20 * scale, 8000, "center")
        --love.graphics.printf("2.  File #2", love.graphics.getWidth()/2 - 4000, 30 * scale, 8000, "center")
        --love.graphics.printf("3.  File #3", love.graphics.getWidth()/2 - 4000, 40 * scale, 8000, "center")

        love.graphics.printf("Press F12 to toggle fullscreen", love.graphics.getWidth()/2 - 4000, 10 * scale, 8000, "center")
        love.graphics.printf("Press Esc to close the game.", love.graphics.getWidth()/2 - 4000, 22 * scale, 8000, "center")
        love.graphics.printf("Use WASD or Arrow Keys to move.", love.graphics.getWidth()/2 - 4000, 47 * scale, 8000, "center")
        love.graphics.printf("Press the Spacebar to attack.", love.graphics.getWidth()/2 - 4000, 59 * scale, 8000, "center")
        love.graphics.printf("Press Tab to equip items.", love.graphics.getWidth()/2 - 4000, 71 * scale, 8000, "center")
        love.graphics.printf("Press the Spacebar to start!", love.graphics.getWidth()/2 - 4000, 111 * scale, 8000, "center")
    end
end

function menu:select(key)
    if gamestate == 0 then
        if key ~= "space" then return end
        
        function Menu:keypressed(key)
    if key == "space" then
        GState:change(1)
    end
end
        startFresh(1)

        if data.map and string.len(data.map) > 0 then
            curtain:call(data.map, data.playerX, data.playerY, "fade")
        end

        return

    end
end
