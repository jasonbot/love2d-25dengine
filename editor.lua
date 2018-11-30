local class = require("middleclass/middleclass")
local drawing = require("drawing")
local loopable = require("loopable")

local Editor = class("Editor", loopable.Loopable)

function Editor:initialize()
    self.x = 0
    self.y = 0
    self.z = 0

    self.camera = drawing.Camera:new()
    self.camera:moveto(self.x + 0.5, self.y + 0.5, self.z + 0.5, true)
end

function Editor:keyreleased(key)
    if key == "left" then
        self.x = self.x - 1
    elseif key == "right" then
        self.x = self.x + 1
    elseif key == "up" then
        self.y = self.y + 1
    elseif key == "down" then
        self.y = self.y - 1
    elseif key == "a" then
        self.z = self.z - 1
    elseif key == "z" then
        self.z = self.z + 1
    end

    self.camera:moveto(self.x + 0.5, self.y + 0.5, self.z + 0.5)

    print("KEYUP" .. tostring(key))
end

function Editor:update()
    self.camera:update()
end

function Editor:draw()
    local text =
        string.format(
        "X: %s Y: %s Z: %s\nCamera X: %s Camera Y: %s Camera Z: %s",
        self.x,
        self.y,
        self.z,
        self.camera.x,
        self.camera.y,
        self.camera.z
    )
    love.graphics.print(text, 0, 0)
    love.graphics.setLineWidth(2.0)
    love.graphics.setColor(255, 255, 255, 25)

    self.camera:drawcube(self.camera.x - 0.5, self.camera.y - 0.5, self.camera.z - 0.5)

    love.graphics.setLineWidth(1.0, "smooth")
    love.graphics.setColor(255, 100, 100, 45)
    for x = 1, 100 do
        for z = 1, 10 do
            self.camera:drawcube(0 + x, 0, 0 + z)
        end
    end
end

return {
    Editor = Editor
}
