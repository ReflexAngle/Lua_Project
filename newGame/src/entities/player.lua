local ObjectPool = require("src/designPatterns/objectPool")
local normalize = require("src/math/normalization")



player = world:newBSGRectangleCollider(275, 180, 12, 12, 3)
player.x = 0
player.y = 0
player.dir = "down"
player.dirX = 1
player.dirY = 1
player.width = 12
player.height = 12
player.prevDirX = 1
player.prevDirY = 1
player.scaleX = 1
player.speed = 90
player.animSpeed = 0.1 --.14
player.aiming = false
player.animTimer = 0
player.max_hearts = 5
player.hearts = 4
-- player.stunTimer = 0
-- player.damagedTimer = 0
player.damagedBool = 1
player.damagedFlashTime = 0.05
player.invincible = 0 -- timer
player.sword = nil
player.swing = {
    active       = false,
    timer        = 0,
    duration     = 0.3,
    startAngle   = -math.pi/4, -- 45° up
    swingAngle   =  math.pi/2, -- 90° downward
    x            = 0,
    y            = 0,
    currentAngle = 0
}
player.bowRecoveryTime = 0.25
player.holdSprite = sprites.items.heart
player.attackDir = vector(1, 0)
player.comboCount = 0
player.arrowOffX = 0
player.arrowOffX = 0
player.bowVec = vector(1, 0)
player.baseDamping = 1 --12
player.dustTimer = 0
player.rotateMargin = 0.25
-- 0 = Normal gameplay
-- 1 = Sword swing
-- 2 = Bow (3: bow drawn, 3.1: recover)
-- 10 = Damage stun
-- 11 = Hold item
-- 12 = Transition
player.state = 0


player:setCollisionClass("Player")
player:setFixedRotation(true)
player:setLinearDamping(player.baseDamping)

-- Heart Pool
    player.heartPool = ObjectPool:new(function()
        return {
            sprite = sprites.items.heart,
            x = 0,
            y = 0,
            active = false
        }
    end, player.max_hearts)

--animations     
player.grid = anim8.newGrid(16, 32, sprites.player.playerWalkSheet:getWidth(), sprites.player.playerWalkSheet:getHeight())

player.animations = {}
--idle
player.animations.idle = anim8.newAnimation(player.grid('1-1', 1), player.animSpeed)
player.animations.idleDown = anim8.newAnimation(player.grid('1-1', 1), player.animSpeed)
player.animations.idleRight = anim8.newAnimation(player.grid('1-1',2), player.animSpeed)
player.animations.idleUp = anim8.newAnimation(player.grid('1-1', 3), player.animSpeed)
player.animations.idleLeft = anim8.newAnimation(player.grid('1-1', 4), player.animSpeed)
--walking
player.animations.walkUp = anim8.newAnimation(player.grid('1-4', 3), player.animSpeed)
player.animations.walkDown = anim8.newAnimation(player.grid('1-4', 1), player.animSpeed)
player.animations.walkLeft = anim8.newAnimation(player.grid('1-4', 4), player.animSpeed)
player.animations.walkRight = anim8.newAnimation(player.grid('1-4', 2), player.animSpeed)

--attack anims
player.animations.attackDown = anim8.newAnimation(player.grid('1-2', 5), .2)
player.animations.attackUp = anim8.newAnimation(player.grid('1-2', 6), .2)
player.animations.attackRight = anim8.newAnimation(player.grid('1-2', 7), .2)
player.animations.attackLeft = anim8.newAnimation(player.grid('1-2', 8), .2)


player.anim = player.animations.idleDown

player.buffer = {} -- input buffer

function player:update(dt)
  --  if pause.active then player.anim:update(dt) end
    if  self.state == 0 then 
        self:handleMovement(dt)
    elseif  self.state == 1 then
         self:setLinearVelocity((self.attackDir * 90):unpack())
    elseif self.state == 1.1 then
         self:setLinearVelocity(0,0)
    end

    -- countdown & transit
    if self.state == 1 or self.state == 1.1 then
        self.animTimer = self.animTimer - dt
        if self.animTimer <= 0 then

    if self.state == 1 then
        -- switch to recovery
        self.state     = 1.1
        self.anim:gotoFrame(2)
        self.animTimer = 0.25

        -- spawn your slice effect at the hand pivot
        local ox, oy = self:getHandOffset()
        effects:spawn("slice",self:getX() + ox, self:getY() + oy,self.attackDir)

        self:swordDamage()

    elseif self.state == 1.1 then
        -- back to idle
        self.state = 0
        self:resetAnimation()
    end

        end
    end
    if self.anim then
        self.anim:update(dt)
    end
end

   

function player:draw()
    local x, y = player:getX(), player:getY()
    local px, py = self:getX(), self:getY()

    if self.anim then
    self.anim:draw(sprites.player.playerWalkSheet, px, py, 0, self.dirX, 1, 8, 16 )
  end

  -- 2) If we’re attacking, draw the sword only then
  if self.state == 1 then
    -- compute a perpendicular swing offset
    local perpAngle = (self.dirX == 1) and math.pi/2 or -math.pi/2
    local tempVec   = self.attackDir:rotated(perpAngle)

    -- pivot at the hand, not the body center
    local handOX, handOY = self:getHandOffset()
    local baseX, baseY   = px + handOX, py + handOY

    local swordRot = math.atan2(tempVec.y, tempVec.x)
    local swX, swY = tempVec.x * 12, tempVec.y * 12
    
    local swSpr = sprites.items.sword
    local ox, oy = swSpr:getWidth()/2, swSpr:getHeight()/2


    -- layer behind or in front
    if swY <= 0 then
      love.graphics.draw(swSpr, px + swX , py + swY, swordRot, self.dirX, 1, ox, oy)
    end

    if swY > 0 then
      love.graphics.draw(swSpr, px + swX, py + swY, swordRot, self.dirX, 1, ox, oy)
    end
  end
end



-- function player:hurt(damage, srcX, srcY)
--     if player.damagedTimer > 0 then return end
--     player.damagedTimer = 2
--     shake:start(0.1, 2, 0.03)
--     particleEvent("playerHit", player:getX(), player:getY())
--     dj.play(sounds.player.hurt, "static", "effect")
--     player.health = player.health - damage
--     player.state = 10 -- damaged
--     player:setLinearVelocity((getFromToVector(srcX, srcY, player:getX(), player:getY()) * 300):unpack())
--     player.stunTimer = 0.075
--     player.aiming = false
-- end

function player:getHandOffset()
    local ox, oy = 0, -self.height/4
    if     self.dir == "right" then
        ox =  self.width/2 + 1
        oy = -self.height/4
    elseif self.dir == "left"  then
        ox = -self.width/2 - 1
        oy = -self.height/4
    elseif self.dir == "up"    then
        ox =  0
        oy = -self.height/2 - 1
    elseif self.dir == "down"  then
        ox =  2
        oy =  self.height/2 + 1
    end
    return ox, oy
end


function player:handleMovement(dt)
    local moveX, moveY = 0, 0
    local animTo

   if love.keyboard.isDown("d","right") then
    moveX  = 1
    self.dir = "right"
    animTo = self.animations.walkRight

  elseif love.keyboard.isDown("a","left") then
    moveX  = -1
    self.dir = "left"
    animTo = self.animations.walkLeft

  elseif love.keyboard.isDown("s","down") then
    moveY  = 1
    self.dir = "down"
    animTo = self.animations.walkDown

  elseif love.keyboard.isDown("w","up") then
    moveY  = -1
    self.dir = "up"
    animTo = self.animations.walkUp

  else
    -- no input ⇒ pick the idle that matches your last dir
    if     self.dir == "right" then animTo = self.animations.idleRight
    elseif self.dir == "left"  then animTo = self.animations.idleLeft
    elseif self.dir == "up"    then animTo = self.animations.idleUp
    else   animTo = self.animations.idleDown
    end
  end

  -- Switch animation only when it changes
  if self.anim ~= animTo then
    self.anim = animTo
    self.anim:gotoFrame(1)
  end

    -- Normalize diagonal movement (so speed is consistent)
    local nx, ny = normalize.NormalizedVector(moveX, moveY)
    --local vx, vy = nx * self.speed, ny * self.speed
    --self:setLinearVelocity(vx, vy)
    self:setLinearVelocity(nx * self.speed, ny * self.speed)

end

-- function player:attack()
--     if self.state ~= 0 then return end
--     self.state = 1

--     -- pick the correct attack anim
--     if     self.dir == "down"  then self.anim = self.animations.attackDown
--     elseif self.dir == "up"    then self.anim = self.animations.attackUp
--     elseif self.dir == "right" then self.anim = self.animations.attackRight
--     elseif self.dir == "left"  then self.anim = self.animations.attackLeft
--     end

--     -- restart the anim
--     if self.anim then
--         self.anim:gotoFrame(1)
--         self.anim:update(0)
--     end

--     -- *** spawn the swing pivot at the hand offset ***
--     local px, py     = self:getX() , self:getY()
--     local offX, offY = self:getHandOffset()
--     self.swing.x     = px + offX 
--     self.swing.y     = py + offY
--     self.swing.timer = self.swing.duration
--     self.swing.active = true
-- end

function player:swingSword()
  if self.state ~= 0 then return end
  self.state = 1

  -- pick a cardinal attack anim
  self.anim = ({
    down  = self.animations.attackDown,
    up    = self.animations.attackUp,
    right = self.animations.attackRight,
    left  = self.animations.attackLeft,
  })[ self.dir ]

  -- reset anim & timer
  self.anim:gotoFrame(1)
  self.anim:update(0)
  self.animTimer = 0.1

  -- record a simple cardinal vector for movement / effect
  local dirVecs = {
    down  = vector( 0,  1),
    up    = vector( 0, -1),
    right = vector( 1,  0),
    left  = vector(-1,  0),
  }
  self.attackDir = dirVecs[self.dir]
end


function player:resetAnimation(direction)
    --player.anim = player.animations[direction]
    if player.dirX == 1 then
        if player.dirY == 1 then
            player.anim = player.animations.idleDown
        else
            player.anim = player.animations.idleUp
        end
    else
        if player.dirY == 1 then
            player.anim = player.animations.idleDown
        else
            player.anim = player.animations.idleUp
        end
    end
    player.anim:gotoFrame(1)
end

function player:swordDamage()
    -- Query for enemies to hit with the sword
    --local hitEnemies = world:queryCircleArea(player:getX(), player:getY(), 24, {'Enemy'})

    local px, py = player:getPosition()
    local dir = player.attackDir:normalized()
    local rightDir = dir:rotated(math.pi/2)
    local leftDir = dir:rotated(math.pi/-2)
    local polygon = {
        px + dir.x*20,
        py + dir.y*20,
        px + dir:rotated(math.pi/8).x*20,
        py + dir:rotated(math.pi/8).y*20,
        px + dir:rotated(math.pi/4).x*20,
        py + dir:rotated(math.pi/4).y*20,
        px + dir:rotated(3*math.pi/8).x*20,
        py + dir:rotated(3*math.pi/8).y*20,
        px + rightDir.x*22,
        py + rightDir.y*22,
        px + rightDir.x*22 + rightDir:rotated(math.pi/2).x*6,
        py + rightDir.y*22 + rightDir:rotated(math.pi/2).y*6,
        px + leftDir.x*22 + leftDir:rotated(math.pi/-2).x*6,
        py + leftDir.y*22 + leftDir:rotated(math.pi/-2).y*6,
        px + leftDir.x*22,
        py + leftDir.y*22,
        px + dir:rotated(3*math.pi/-8).x*20,
        py + dir:rotated(3*math.pi/-8).y*20,
        px + dir:rotated(math.pi/-4).x*20,
        py + dir:rotated(math.pi/-4).y*20,
        px + dir:rotated(math.pi/-8).x*20,
        py + dir:rotated(math.pi/-8).y*20,
    }

    local range = math.random()/4
    --dj.play(sounds.items.sword, "static", "effect", 1, 1+range)

    -- local hitEnemies = world:queryPolygonArea(polygon, {'Enemy'})
    -- for _,e in ipairs(hitEnemies) do
    --     local knockbackDir = getPlayerToSelfVector(e:getX(), e:getY())
    --     e.parent:hit(1, knockbackDir, 0.1)
    -- end
end

function player:setDirFromVector(vec)
    local rad = math.atan2(vec.y, vec.x)
    if rad >= player.rotateMargin*-1 and rad < math.pi/2 then
        player.dirX = 1
        player.dirY = 1
    elseif (rad >= math.pi/2 and rad < math.pi) or (rad < (math.pi - player.rotateMargin)*-1) then
        player.dirX = -1
        player.dirY = 1
    elseif rad < 0 and rad > math.pi/-2 then
        player.dirX = 1
        player.dirY = -1
    else
        player.dirX = -1
        player.dirY = -1
    end
end

function player:processBuffer(dt)
    for i=#player.buffer,1,-1 do
        player.buffer[i][2] = player.buffer[i][2] - dt
    end
    for i=#player.buffer,1,-1 do
        if player.buffer[i][2] <= 0 then
            table.remove(player.buffer, i)
        end
    end

    if player.state == 0 then
        player:useBuffer()
    end
end

function player:addToBuffer(action)
    if action == "roll" and player.state == 0.5 then
        table.insert(player.buffer, {action, 0.1})
    else
        table.insert(player.buffer, {action, 0.25})
    end
end

function player:useBuffer()
    local action = nil
    if #player.buffer > 0 then
        action = player.buffer[1][1]
    end

    -- clear buffer
    for k,v in pairs(player.buffer) do player.buffer[k]=nil end

    if action == nil then return end

    if action == "sword" then
        player:swingSword()
    end
end