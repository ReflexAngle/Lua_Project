function requireAll()
    require("src/startup/collisionClasses")
    createCollisionClasses()

    -- Resources / Data
     require("src/startup/resources")
     require("src/startup/data")

    -- Utilities
       require("src/utils/cam")
       require("src/utils/destroyAll")
       require("src/math/normalization")
       
       
       -- Design Patterns
       require("src/designPatterns/objectPool")
    -- require("src/utils/misc")
    -- require("src/utils/shaders")
    -- require("src/utils/shake")
    -- require("src/utils/triggers")
    -- require("src/utils/utils")

    -- Core gameplay
    require("src/entities/player")
    require("src/update")
    require("src/draw")

    -- Effects
    require("src/effects/slash")
    --require("src/effects/blast")
    --require("src/effects/effect")
    --require("src/effects/shadows")
    --require("src/effects/particles/particle")
    --require("src/effects/particles/particleEvent")

    -- Enemies
    --use this require all as a checklist of what were adding and add you require methods in here
    --require("src/enemies/projectile")
    --require("src/enemies/enemy")

    -- Environment
    --require("src/environment/tree")
    --require("src/environment/water")

    -- Items
    -- require("src/items/item")
    -- require("src/items/loot")
    -- require("src/items/arrow")
    -- require("src/items/bomb")
    -- require("src/items/boomerang")
    -- require("src/items/grapple")
    -- require("src/items/chest")

    -- Spells
    -- require("src/spells/fireball")
    -- require("src/spells/flame")

    -- Levels
    -- require("src/levels/curtain")
    require("src/levels/loadMap")
    -- require("src/levels/npc")
    -------- require("src/levels/transition")
     require("src.levels.walls")

    -- UI
    -- require("src/ui/hud")
    -- require("src/ui/menu")
    -- require("src/ui/pause")
end
