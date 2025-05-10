local commands = {}

-- HealCommand

local HealCommand = {}
HealCommand.__index = HealCommand


function HealCommand:new(receiver, amount)
    local cmd = setmetatable({}, HealCommand)
    cmd.receiver = receiver  -- This will be the global player object
    cmd.amount = amount or 1 -- Amount to heal (default is 1)
    print("HealCommand instance created for receiver:", receiver)
    return cmd
end

-- Executes the heal action on the receiver
function HealCommand:execute()
    if self.receiver and self.receiver.heal then
        print(string.format("Executing HealCommand: Healing by %d", self.amount))
        self.receiver.heal(self.amount) -- Call the player's heal method
    end
end
commands.HealCommand = HealCommand
return commands
