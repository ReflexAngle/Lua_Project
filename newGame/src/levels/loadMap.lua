local mapLoader = {}

function mapLoader.loadMap(mapName, destX, destY)
    destroyAll()
-- function loadMap(mapName, destX, destY)
--     destroyAll()

        player:setPosition(destX, destY)
    end
--     if destX and destY then
--         player:setPosition(destX, destY)
--     end

--     loadedMap = mapName
--     -- gameMap = sti("maps/" .. mapName .. ".lua")
--     gameMap = sti("maps/TestMap3.lua")

--     if gameMap.layers["Walls"] then
--         for i, obj in pairs(gameMap.layers["Walls"].objects) do
--             spawnWall(obj.x, obj.y, obj.width, obj.height, obj.name, obj.type)
--         end
--     end

    -- if gameMap.layers["Enemies"] then
    --     for i, obj in pairs(gameMap.layers["Enemies"].objects) do
    --         local args = {}
    --         if obj.properties.form then args.form = obj.properties.form end
    --         spawnEnemy(obj.x, obj.y, obj.name, args)
    --     end
    -- end

    -- if gameMap.layers["Loot"] then
    --     for i, obj in pairs(gameMap.layers["Loot"].objects) do
    --         spawnLoot(obj.x, obj.y, obj.type, false, obj.properties.price)
    --     end
    -- end

    -- if gameMap.layers["Chests"] then
    --     for i, obj in pairs(gameMap.layers["Chests"].objects) do
    --         spawnChest(obj.x, obj.y, obj.name, obj.type)
    --     end
    -- end

    -- if gameMap.layers["NPC"] then
    --     for i, obj in pairs(gameMap.layers["NPC"].objects) do
    --         spawnNPC(obj.name, obj.x, obj.y)
    --     end
    -- end

    -- if gameMap.layers["Transitions"] then
    --     for i, obj in pairs(gameMap.layers["Transitions"].objects) do
    --         spawnTransition(obj.x, obj.y, obj.width, obj.height, obj.name, obj.properties.destX, obj.properties.destY, obj.type)
    --     end
    -- end

    -- if gameMap.layers["Triggers"] then
    --     for i, obj in pairs(gameMap.layers["Triggers"].objects) do
    --         spawnTrigger(obj.x, obj.y, obj.name)
    --     end
    -- end

    -- if gameMap.layers["Trees"] then
    --     for i, obj in pairs(gameMap.layers["Trees"].objects) do
    --         spawnTree(obj.x, obj.y, obj.type, obj.name)
    --     end
    -- end

    -- if gameMap.layers["Water"] then
    --     for i, obj in pairs(gameMap.layers["Water"].objects) do
    --         spawnWater(obj.x, obj.y, obj.width, obj.height)
    --     end
    -- end

    -- if gameMap.properties.dark then
    --     gameMap.dark = gameMap.properties.dark
    -- else
    --     gameMap.dark = false
    -- end

-- end
gameMap = nil
loadMap = nil


function loadMap(mapName)
    print("should load map: ",mapName)

    local mapPath = "maps/" ..mapName .. ".lua"
    local info = love.filesystem.getInfo(mapPath)
    if info and info.type == "file" then
        gameMap = sti(mapPath)
        print("Successs")

        loadedMap = mapName
    else
        gameMap.dark = false
    end

end

return mapLoader
=======
        if  info then
            print("Error path issue")
        else 
            print("Error map file issue")
        end
        gameMap = nil
    end   
    
end
>>>>>>> Stashed changes
