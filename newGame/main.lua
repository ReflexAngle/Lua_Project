--local saveData = require("scripts/events/saveDataEvent")
--local cameraFollow = require("scripts/camera/cameraFollow")
--local normalize = require("scripts/math/normalization")
--local enemy = require("scripts/enemies/enemyBehavior")
-- setting bg sprites   
--local sprites = {
    --    background = love.graphics.newImage("assets/imgs/background.png"),
    --}
    
    
    
    
    function love.load()
        require("src/startup/gameStart")
        gameStart()
        
        colliderToggle = false
        local Player = require("src/entities/player")
        player = Player:new(world, 500, 400, 16, 16, 8)
--    --createNewSave()
end

function love.update(dt)
    --updateAll(dt)
    world:update(dt)
    if player and player.update then
       player:update(dt) end
end
    
function love.draw()
    -- draw  before camera method
    -- cam:attach()
    -- drawCamera()
    if colliderToggle and world.draw then
        world:draw()
        --particleWorld:draw()
    end
    if player and player.draw then
       player:draw(0,0,0,0)

    end
    if player and player.drawHearts then
       player:drawHearts()
    end
    --cam:detach()
    -- draw after cam method
end

--player:draw(offsetX, offsetY, scaledWidth, scaledHeight)
--player:drawHearts()

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "f12" then
        local isFullscreen = love.window.getFullscreen()
        love.window.setFullscreen(not isFullscreen)
    end
end