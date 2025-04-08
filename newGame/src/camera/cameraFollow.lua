local cameraFollow = {}

local camera = {
    x = 0,
    y = 0,
    scale = 1
}

function cameraFollow.FollowPlayer(player)
    camera.x = player.collider:getX() - (love.graphics.getWidth() / 2) / camera.scale
    camera.y = player.collider:getY() - (love.graphics.getHeight() / 2) / camera.scale

end

function cameraFollow.Apply()
    love.graphics.push()
    love.graphics.scale(camera.scale)
    love.graphics.translate(-camera.x, -camera.y)
end

function cameraFollow.Reset()
    love.graphics.pop()
    
end
function cameraFollow.camSmooth()
    local smoothSpeed = 5
    camera.x = camera.x + (player.transform.x - camera.x) * smoothSpeed
    camera.y = camera.y + (player.transform.y - camera.y) * smoothSpeed
    -- body
end

return cameraFollow