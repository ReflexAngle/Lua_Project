-- src/entities/states/attack_state.lua

local Attack = {}
Attack.__index = Attack -- For potential metatable usage if you expand this

function Attack:new()
    local state = setmetatable({}, Attack)
    print("Attack state object created")
    return state
end

-- Called when entering the Attack state
function Attack:enter(player)
    print("Player entering Attack state, direction:", player.dir)

    -- Stop player movement when attacking
    if player.collider then
        player.collider:setLinearVelocity(0, 0)
    end

    -- Select the correct attack animation based on the player's current direction
    -- (player.dir should be 'up', 'down', 'left', or 'right')
    if player.dir == "up" then
        player.animations.currentAnimation = player.animations.attackUp
    elseif player.dir == "down" then
        player.animations.currentAnimation = player.animations.attackDown
    elseif player.dir == "left" then
        player.animations.currentAnimation = player.animations.attackLeft
    elseif player.dir == "right" then
        player.animations.currentAnimation = player.animations.attackRight
    else
        -- Default to attackDown if direction is somehow invalid
        print("Warning: Invalid player direction in Attack:enter - defaulting to attackDown")
        player.animations.currentAnimation = player.animations.attackDown
    end

    -- Reset the selected animation to its first frame
    if player.animations.currentAnimation then
        player.animations.currentAnimation:gotoFrame(1)
    else
        print("Warning: Attack animation not found for direction:", player.dir)
    end
end

-- Called every frame while in the Attack state
function Attack:update(player, dt)
    -- The main purpose of the Attack state's update is to check if the animation has finished.
    -- The animation itself is updated globally in player:update().

    if player.animations.currentAnimation then
        if player.animations.currentAnimation.position == #player.animations.currentAnimation.frames then
            -- Attack animation has finished, switch back to the Idle state.
            -- The Idle state will then handle transitions to Walk if movement keys are pressed.
            if player.stateManager and player.states and player.states.idle then
                print("Attack animation finished, switching to Idle state.")
                player.stateManager:switch(player.states.idle, player)
            else
                -- Fallback if state manager isn't set up yet, revert to direct state change
                print("Attack animation finished, state manager not found. Reverting to player.state = 0")
                player.state = 0 -- Revert to normal state
                player.animations.currentAnimation = player.animations.idle
                if player.animations.currentAnimation then player.animations.currentAnimation:gotoFrame(1) end
            end
        end
    else
        -- If for some reason there's no current animation, immediately try to switch to idle
        -- to prevent getting stuck.
        if player.stateManager and player.states and player.states.idle then
            print("Warning: No current animation in Attack state, switching to Idle.")
            player.stateManager:switch(player.states.idle, player)
        end
    end
end

-- Drawing for the Attack state (usually handled by the main player:draw)
function Attack:draw(player)
    -- Typically, the main player:draw() function handles rendering the
    -- player.animations.currentAnimation, so this might be empty.
    -- You could add state-specific visual effects here if needed (e.g., a weapon trail).
end

-- Called when leaving the Attack state
function Attack:leave(player)
    print("Player leaving Attack state")
    -- Any cleanup specific to the attack state can go here.
    -- For example, ensuring the player's velocity is still zero if needed,
    -- or resetting combo counters if you add them later.
end

return Attack
