local class = require("middleclass/middleclass")
local stateful = require("stateful/stateful")

local Loopable = class("Loopable")
Loopable:include(stateful)

function Loopable:update()
end

function Loopable:draw()
end

function Loopable:keypressed(key)
    print("key pressed " .. tostring(key))
end

function Loopable:keyreleased(key)
    print("key released " .. tostring(key))
end

function Loopable:resize(w, h)
end

return {Loopable = Loopable}
