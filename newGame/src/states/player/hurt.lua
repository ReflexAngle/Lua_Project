
local Hurt = {}
Hurt.__index = Hurt


local vec = require "libs.hump.vector" 

function Hurt:new()
    local state = setmetatable({}, Hurt)
    state.stunDuration = 0.3     -- How long the player can't act after getting hit
    state.invincibilityDuration = 1.0 -- How long the player flashes and can't be hit again
    state.knockbackSpeed = 200    -- How fast the player is pushed back
    return state
end

-- player starts taking dmg
function Hurt:enter(player, previousStateName, damageInfo) 
    print(string.format("Player entering Hurt state from %s (Damage: %s)", previousStateName, damageInfo and damageInfo.amount or "N/A"))
    
    -- Reduce Health (moved here from takeDamage method)
    player.hearts = math.max(0, player.hearts - (damageInfo and damageInfo.amount or 1))
    
    -- Signals
    if signal then
        signal.emit('health_changed', player.hearts, player.max_hearts)
        if player.hearts <= 0 then
            signal.emit('player_died')
            -- IMPORTANT: Immediately switch to Dead state if health is zero
            player.stateManager:switch(player.states.dead, player)
            return -- Stop processing this 'enter' if dead
        end
    end

    -- Apply Knockback Velocity
    if player.collider and damageInfo and damageInfo.srcX and damageInfo.srcY then
        local knockbackDir = vec.new(player:getX() - damageInfo.srcX, player:getY() - damageInfo.srcY):normalized()
        player.collider:setLinearVelocity(knockbackDir.x * self.knockbackSpeed, knockbackDir.y * self.knockbackSpeed)
    end
    
    --for setting Timers
    --player.stunTimer = self.stunDuration -- Use a temporary variable on the player table
    --player.invincible = self.invincibilityDuration -- Use the existing invincibility timer

    -- Set Hurt Animation (You need to define this in player.lua)
    if player.animations.hurt then
        player.anim = player.animations.hurt 
        if player.anim then player.anim:gotoFrame(1) end
    else
        print("Warning: player.animations.hurt not defined!")
    end
    
    -- Play Sound / Effects
    -- dj.play(sounds.player.hurt, "static", "effect")
    -- particleEvent("playerHit", player:getX(), player:getY())
    -- shake:start(0.1, 2, 0.03) 
end

-- Called every frame while in Hurt state
function Hurt:update(player, dt) 
    -- Decrease timers
    if player.stunTimer then player.stunTimer = math.max(0, player.stunTimer - dt) end
    if player.invincible then player.invincible = math.max(0, player.invincible - dt) end

    -- Apply damping during knockback
    player:setLinearDamping(player.baseDamping * 0.5) -- Maybe less damping during knockback

    -- Check if stun duration is over
    if player.stunTimer <= 0 then
        -- Stun finished, transition back to idle (or maybe walk if keys are held?)
        player.stateManager:switch(player.states.idle, player)
    end
end

-- Optional: Draw flashing effect
function Hurt:draw(player) 
    -- Check player.invincible timer to alternate alpha or use a shader
    local flashRate = 0.1
    if player.invincible > 0 and (math.floor(player.invincible / flashRate) % 2 == 0) then
        -- Could set a shader here, or just skip drawing the main sprite
        -- For simplicity, we'll let player:draw handle the main sprite,
        -- maybe just change color briefly if needed (though shaders are better).
        -- love.graphics.setColor(1,1,1,0.5) -- Example: brief transparency
    end
end

-- Called when switching FROM this state
function Hurt:leave(player, nextStateName) 
    print("Player leaving Hurt state", nextStateName)
    player.stunTimer = 0 -- Ensure stun is cleared
    player:setLinearDamping(player.baseDamping) -- Restore normal damping
    -- love.graphics.setColor(1,1,1,1) -- Reset color if changed in draw
end

return Hurt:new()