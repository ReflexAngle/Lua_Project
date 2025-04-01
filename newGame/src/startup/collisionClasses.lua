function createCollisionClasses()
    -- 💡 Safety check to avoid redefining
    if world.collisionClasses and world.collisionClasses["Player"] then return end

    -- STEP 1: Add all collision classes (no ignores yet)
    world:addCollisionClass("Ignore")
    world:addCollisionClass("Ground")
    world:addCollisionClass("Player")
    world:addCollisionClass("Wall")
    world:addCollisionClass("Enemy")
    world:addCollisionClass("Projectile")

    -- STEP 2: Now set their ignore behavior
    world:collisionClassesSet("Ignore",     {ignores = {"Ignore"}})
    world:collisionClassesSet("Ground",     {ignores = {"Ignore"}})
    world:collisionClassesSet("Player",     {ignores = {"Ignore"}})
    world:collisionClassesSet("Wall",       {ignores = {"Ignore"}})
    world:collisionClassesSet("Enemy",      {ignores = {"Ignore", "Player"}})
    world:collisionClassesSet("Projectile", {ignores = {"Ignore", "Enemy", "Player", "Ground", "Wall"}})
end
