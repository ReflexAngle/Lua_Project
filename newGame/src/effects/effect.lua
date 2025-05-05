local anim8 = require("libs/anim8")
effects = {}

function effects:spawn(type, x, y, args)
  local effect = { x = x, y = y, scaleX = 1, scaleY = 1, dead = false }
  if type == "slice" then
    effect.spriteSheet = sprites.effects.sliceAnim    -- your sliceAnim.png
    effect.width  = 23
    effect.height = 39
    effect.grid   = anim8.newGrid(23,39,
                      effect.spriteSheet:getWidth(),
                      effect.spriteSheet:getHeight())
    -- play both frames at 0.06s each, then kill
    effect.anim = anim8.newAnimation(
      effect.grid('1-2',1),
      0.06,
      function() effect.dead = true end
    )
    effect.layer = 0
    -- orient the slice to your attackDir
    if args then
      effect.rot = math.atan2(args.y, args.x)
      -- optional Y-flip every other combo if you want
      -- if player.comboCount % 2 == 0 then effect.scaleY = -1 end
    end

    function effect:update(dt)
      self.anim:update(dt)
    end

    function effect:draw()
      love.graphics.draw(
        self.spriteSheet,
        self.anim.frame,
        self.x, self.y,
        self.rot,
        self.scaleX, self.scaleY,
        self.width/2, self.height/2
      )
    end
  end

  table.insert(self, effect)
end

return effects
