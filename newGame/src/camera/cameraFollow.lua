-- src/camera/cameraFollow.lua (Corrected)

local cameraFollow = {}

-- This local table still holds the position, but not the scale
local camera = {
    x = 0,
    y = 0
    -- scale = 1 -- We no longer use this internal scale value
}

-- Calculates where the camera should be based on player position and GLOBAL scale
function cameraFollow.FollowPlayer(player)
    -- Ensure player and collider exist before trying to access them
    if player and player.collider and scale and scale ~= 0 then -- Also check global scale exists and isn't zero
        -- Use the global 'scale' variable for calculations
        camera.x = player.collider:getX() - (love.graphics.getWidth() / 2) / scale
        camera.y = player.collider:getY() - (love.graphics.getHeight() / 2) / scale
    else
        -- Handle cases where player/collider/scale might not be ready yet
        -- Maybe keep camera position as is, or set to 0,0?
        -- camera.x = 0
        -- camera.y = 0
        if not scale or scale == 0 then print("Warning: Global scale is invalid in FollowPlayer") end
    end
end

-- Applies the global scale and the calculated translation
function cameraFollow.Apply()
    love.graphics.push()
    -- Use the global 'scale' variable for graphics scaling
    if scale then -- Check if scale exists
       love.graphics.scale(scale)
    else
        print("Warning: Global scale not found in Apply")
        -- love.graphics.scale(1) -- Default to 1 if global scale is missing
    end
    love.graphics.translate(-camera.x, -camera.y)
end

-- Resets transformations
function cameraFollow.Reset()
    love.graphics.pop()
end

-- camSmooth function remains the same, but note it uses player.transform.x/y
-- which might not exist on your global player table. It should likely use
-- player.collider:getX()/getY() if you intend to use smoothing later.
function cameraFollow.camSmooth()
    --[[ Potential issue: player.transform may not exist.
         Should probably use player.collider:getX/Y if implementing smoothing.
    local smoothSpeed = 5
    if player and player.collider then -- Check player and collider exist
        local targetX, targetY = player.collider:getX(), player.collider:getY()
        -- Need to calculate the target camera position based on targetX/Y first
        -- This simple lerp won't work directly with player pos vs camera pos correctly with scaling
        -- camera.x = camera.x + (targetX - ?? ) * smoothSpeed * dt -- Needs proper calculation
        -- camera.y = camera.y + (targetY - ?? ) * smoothSpeed * dt -- Needs proper calculation
    end
    ]]
end

return cameraFollow