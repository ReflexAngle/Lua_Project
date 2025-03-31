local waveProperties = {}

local waveNumber = 1
local EnemyCount = 10

local enemySpawnTimer = 1

function waveProperties.nextWave()
    waveProperties.waveNumber = waveNumber
    waveProperties.enemyCount = EnemyCount
end

function waveProperties.getWaveCount()
    return waveProperties.waveNumber
end

return waveProperties
