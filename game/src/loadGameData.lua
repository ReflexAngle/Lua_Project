local jsonload = {}

local json = require("libs.dkjson") -- json library

-- player data file 
-- also save current game data such as waves 
function jsonload.LoadPlayerData()
    if not love.filesystem.getInfo("playerdata", "directory") then
        love.filesystem.createDirectory("playerdata")
    end

    local filePath = "playerdata/player_data.json"

    if love.filesystem.getInfo(filePath) then
        local jsonData = love.filesystem.read(filePath)
        return json.decode(jsonData)
    else
        local defaultData = {
            health = 100,
            maxHealth = 100,
            position = { x = 0, y = 0 }
        }

        local encodedData = json.encode(defaultData)
        love.filesystem.write(filePath, encodedData)
        return defaultData
    end
end
    
return jsonload