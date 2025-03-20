local anim8 = require 'libs/anim8'
local player= require 'src.player'

local Slash = {}

function Slash:load()
    self.image = love.graphics.newImage('assets/imgs/Slashhh.png')
    self.swordImg = love.graphics.newImage('assets/imgs/Sword.png')

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
    self.swordActive = false -- tracks sword
    self.swordX, self.swordY = 0, 0 -- sword position
    self.x, self.y = 0, 0
    self.angle = 0
end

function Slash:activate(player)
    self.x, self.y = player.transform.x + player.transform.width / 2, player.transform.y + player.transform.height / 2
    self.active = true
    self.swordActive = true
    --self.swordX, self.swordY = player.transform.x + player.transform.width / 2, player.transform.y + player.transform.height / 2
    self.scale = player.playerScaler * 1  -- Adjust scale proportionally
    --self.animation:gotoFrame(1)  -- Reset animation

    -- Adjust rotation angle based on player direction
    local offset = 30 -- offset slash from player body
    if player.direction == "right" then
        self.angle = 0
        self.x = self.x + 15 + offset
        self.swordX = self.x
        self.swordY = self.y
    elseif player.direction == "left" then
        self.angle = math.pi  -- 180 degrees (flip)
        self.x = self.x - 15 - offset
        self.swordX = self.x
        self.swordY = self.y
    elseif player.direction == "up" then
        self.angle = -math.pi / 2  -- 90 degrees counterclockwise
        self.y = self.y - 15 - offset
        self.swordX = self.x
        self.swordY = self.y - 10 - offset
    elseif player.direction == "down" then
        self.angle = math.pi / 2  -- 90 degrees clockwise
        self.y = self.y + 15 + offset
        self.swordX = self.x
        self.swordY = self.y + 10 + offset
    end
end


function Slash:update(dt)
    if self.active then
       self.animation:update(dt)
       
        if self.animation.position == #self.animation.frames then
            self.active = false  -- Disable the slash after one cycle
            self.swordActive = false
        end
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

    -- draws swordimg
    if self.swordActive then
        love.graphics.draw(self.swordImg, self.swordX, self.swordY, self.angle - 90, 1, 1, self.swordImg:getWidth() / 3, self.swordImg:getHeight() / 3)
    end
end

return Slash