function love.load()
    -- This runs once at the start of the game
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1) -- Sets a dark background
    love.window.setMode(800,800)
end

function love.update(dt)
    -- This runs every frame (dt is the time since last frame)
end

function love.draw()
    -- This is where you draw graphics
    love.graphics.print("Hello, Love2D!", 400, 300)
    love.graphics.rectangle('fill', 20, 20, 20, 20)
    love.graphics.setColor(1, 1, 1)
    
end
