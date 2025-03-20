local anim8 = require 'libs/anim8'
local player= require 'src.player'

local Slash = {}

function Slash:load()
    self.image = love.graphics.newImage('assets/imgs/Slashhh.png')
  
    local imgWidth = self.image:getWidth()
    local imgHeight = self.image:getHeight()
    local frameWidth = imgWidth / 3
    local frameHeight = imgHeight
   
    --local grid = anim8.newGrid(23, 39, self.image:getWidth(), self.image:getHeight())
    local grid = anim8.newGrid(
    frameWidth,
    frameHeight,
    imgWidth,
    imgHeight
)
    
    self.animation = anim8.newAnimation(grid('1-3', 1), 0.1) -- Adjust based on your frames
    self.active = false
    self.x, self.y = 0, 0
    self.angle = 0
end

function Slash:activate(player)
    self.x, self.y = player.transform.x + player.transform.width / 2, player.transform.y + player.transform.height / 2
    self.active = true
    self.scale = player.playerScaler * 1  -- Adjust scale proportionally
    --self.animation:gotoFrame(1)  -- Reset animation

    -- Adjust rotation angle based on player direction
    local offset = 30 -- offset slash from player body
    if player.direction == "right" then
        self.angle = 0
        self.x = self.x + 15 + offset
    elseif player.direction == "left" then
        self.angle = math.pi  -- 180 degrees (flip)
        self.x = self.x - 15 - offset
    elseif player.direction == "up" then
        self.angle = -math.pi / 2  -- 90 degrees counterclockwise
        self.y = self.y - 15 - offset
    elseif player.direction == "down" then
        self.angle = math.pi / 2  -- 90 degrees clockwise
        self.y = self.y + 15 + offset
    end
end


function Slash:update(dt)
    if self.active then
       self.animation:update(dt)
    end

    if self.animation.position == #self.animation.frames then
        self.active = false  -- Disable the slash after one cycle
    end
end

function Slash:draw()
    if self.active then
        self.animation:draw(
            self.image, 
            self.x, self.y,
            self.angle,  -- Rotation angle
            self.scale,
            self.scale, -- Scale
            self.image:getWidth() / 4,
            self.image:getHeight() / 2 -- Origin point
        )
    end
end

return Slash