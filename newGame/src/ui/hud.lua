
local HUD = {}

-- Local variables to store the data received from signals
local currentHearts = 0
local maxHearts = 0
local currentScaleX = 1 -- Store scale if needed, or get from player/global

-- Listener function: Called when 'health_changed' is emitted
local function onHealthChanged(newHealth, newMaxHealth)
    print(string.format("HUD Received 'health_changed': %d / %d", newHealth, newMaxHealth))
    currentHearts = newHealth or 0
    maxHearts = newMaxHealth or 0
    -- We could also potentially grab the current player scale here if needed
    -- currentScaleX = player and player.scaleX or 1 
end

if signal then
    signal.register('health_changed', onHealthChanged)
    print("HUD registered listener for 'health_changed'")
else
    print("ERROR: Global 'signal' not found! Require 'libs.hump.signal' in main.lua.")
end

if player then
    currentHearts = player.hearts or 0
    maxHearts = player.max_hearts or 0
    currentScaleX = player.scaleX or 1
end



function HUD.drawHearts()
    -- Check if player and necessary resources exist globally
    if not player or not player.heartPool or not sprites or not sprites.items or not sprites.hud then
        print("Warning: Player or sprites not ready for drawHearts")
        return
    end

    local heartX, heartY = 5, 5 
    -- Access player properties directly via the global 'player' table
    local heartSpacing = 16 * (3) -- Default scaleX to 1 if nil
    local heartScale = 5

    for i = 1, (player.max_hearts or 0) do -- Use player.max_hearts
        local heart = player.heartPool:get() 
        if heart then -- Check if heartPool returned an object
            heart.x = heartX + (i - 1) * heartSpacing
            heart.y = heartY
            -- Use player.hearts
            heart.sprite = (i <= (player.hearts or 0)) and sprites.items.heart or sprites.hud.emptyHeart 
            
            love.graphics.draw(heart.sprite, heart.x, heart.y, 0, heartScale, heartScale)
            player.heartPool:release(heart) -- Use player.heartPool
        else
             print("Warning: heartPool returned nil in drawHearts")
        end
    end
end

function HUD.draw()
    -- Set color, font etc. for HUD elements if needed
    love.graphics.setColor(1, 1, 1, 1) -- Reset color

    HUD.drawHearts()
    --HUD.drawMoney()

    -- Add other HUD elements here (stamina, score, etc.)
end

return HUD 