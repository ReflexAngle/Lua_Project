-- newGame/src/utils/statemachine.lua
local StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine.new()
    return setmetatable({
        states   = {},
        current  = nil
    }, StateMachine)
end

function StateMachine:register(name, state)
    self.states[name] = state
end

function StateMachine:change(name, ...)
    assert(self.states[name], "State “"..name.."” doesn’t exist")
    if self.current and self.current.exit then
        self.current:exit()
    end
    self.current = self.states[name]
    if self.current.enter then
        self.current:enter(...)
    end
end

function StateMachine:update(dt)
    if self.current and self.current.update then
        self.current:update(dt)
    end
end

function StateMachine:draw()
    if self.current and self.current.draw then
        self.current:draw()
    end
end

function StateMachine:keypressed(key)
    if self.current and self.current.keypressed then
        self.current:keypressed(key)
    end
end

return StateMachine
