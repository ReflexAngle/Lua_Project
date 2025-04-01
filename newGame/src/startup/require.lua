function requireAll()
    require("src/startup/collisionClasses")
    createCollisionClasses()

    -- Resources / Data
    --require("src/startup/resources")
    --require("src/startup/data")

    -- Utilities
   -- require("src/utilities/cam")
    -- require("src/utilities/destroyAll")
    -- require("src/utilities/misc")
    -- require("src/utilities/shaders")
    -- require("src/utilities/shake")
    -- require("src/utilities/triggers")
    -- require("src/utilities/utils")

    -- Core gameplay
    require("src/entities/player")
    require("src/update")
    require("src/draw")

    -- Effects
    --require("src/effects/blast")
    --require("src/effects/effect")
    --require("src/effects/shadows")
    --require("src/effects/particles/particle")
    --require("src/effects/particles/particleEvent")

    -- Enemies
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
    -- require("src/levels/loadMap")
    -- require("src/levels/npc")
    -- require("src/levels/transition")
    -- require("src/levels/wall")

    -- UI
    --require("src/ui/hud")
    --require("src/ui/menu")
    --require("src/ui/pause")
end
