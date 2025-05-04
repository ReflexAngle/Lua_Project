transitions = {}

function spawnTransition(x, y, width, height, id, destX, destY, transitionType)

    local transition = world:newRectangleCollider(x, y, width, height, {collision_class = "Transition"})
    transition:setType('static')

    transition.id = id
    transition.destX = destX
    transition.destY = destY
    transition.type = "standard"

    if transitionType then transition.type = transitionType end

    table.insert(transitions, transition)

end

function triggerTransition(id, destX, destY)
    local newMap = "lightmap"

    if id == "toTestShop" then
        newMap = "testShop"
    elseif id == "tolightmap" then
        newMap = "lightmap"
    else
        newMap = id
    end

    gamestate = 1
    player:setPosition(destX, destY)

    loadMap(newMap)
end
