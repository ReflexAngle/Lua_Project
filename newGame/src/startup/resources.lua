sprites = {}

sprites.player = {}
sprites.player.playerWalkSheet = love.graphics.newImage('sprites/player/playerWalkSheet2.png')

sprites.effects = {}
sprites.effects.slice = love.graphics.newImage('sprites/effects/Slashhh.png')
sprites.effects.sliceAnim = love.graphics.newImage('sprites/effects/sliceAnim.png')

sprites.items = {}
sprites.items.sword = love.graphics.newImage('sprites/items/sword2.png')

sprites.enemies = {}

sprites.hud = {}
sprites.hud.emptyHeart = love.graphics.newImage('sprites/items/EmptyHeart.png')
sprites.items.heart = love.graphics.newImage('sprites/items/FullHeart.png')

sprites.enviornment = {}


-- since fonts are influenced by scale, they need to be re-initialized when the scale changes
function initFonts()
    fonts = {}
    -- fonts.debug = love.graphics.newFont("fonts/vt323/VT323-Regular.ttf", 15*scale)
    -- fonts.debug2 = love.graphics.newFont(10*scale)
    -- fonts.debugSmall = love.graphics.newFont("fonts/vt323/VT323-Regular.ttf", 10*scale)
    -- fonts.ammo = love.graphics.newFont("fonts/kenney-pixel-square/Kenney-Pixel-Square.ttf", 4.5*scale)
    -- fonts.coins = love.graphics.newFont("fonts/kenney-pixel-square/Kenney-Pixel-Square.ttf", 6.5*scale)
    -- fonts.shop = love.graphics.newFont("fonts/kenney-pixel-square/Kenney-Pixel-Square.ttf", 8)

    fonts.pause1 = love.graphics.newFont("fonts/vt323/VT323-Regular.ttf", 12*scale)
    fonts.pause2 = love.graphics.newFont("fonts/vt323/VT323-Regular.ttf", 9*scale)
    fonts.pauseTop = love.graphics.newFont("fonts/vt323/VT323-Regular.ttf", 10*scale)
end
initFonts()
