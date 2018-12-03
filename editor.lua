local class = require("middleclass/middleclass")
local projection = require("projection")
local loopable = require("loopable")

local Editor = class("Editor", loopable.Loopable)

function Editor:initialize()
    self.x = 0
    self.y = 0
    self.z = 0

    self.mesh =
        love.graphics.newMesh(
        {
            {0, 0, 0, 0},
            {128, 0, 1, 0},
            {128, 128, 1, 1},
            {0, 128, 0, 1}
        },
        "fan",
        "stream"
    )
    print(self.mesh)
    self.tile = love.graphics.newImage("tile.png")
    self.mesh:setTexture(self.tile)

    self.camera = projection.Camera:new()
    self.y = math.ceil(self.camera.y) - 0.5
    self.camera:moveto(self.x + 0.5, self.y + 0.5, self.z + 0.5, true)
end

function Editor:keyreleased(key)
    if key == "left" then
        self.x = self.x - 1
    elseif key == "right" then
        self.x = self.x + 1
    elseif key == "up" then
        self.z = self.z - 1
    elseif key == "down" then
        self.z = self.z + 1
    elseif key == "a" then
        self.y = self.y + 1
    elseif key == "z" then
        self.y = self.y - 1
    elseif key == "f" then
        love.window.setFullscreen(not love.window.getFullscreen(), "desktop")
    end

    self.camera:moveto(self.x + 0.5, self.y + 0.5, self.z + 0.5)
end

function Editor:update()
    self.camera:update()
end

function Editor:resize(w, h)
    self.camera:resetdisplaymetrics()
    self.y = math.ceil(self.camera.targetY) - 0.5
end

function Editor:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.mesh)

    local text =
        string.format(
        "X: %s Y: %s Z: %s\nCamera X: %s Camera Y: %s Camera Z: %s\n%s FPS",
        self.x,
        self.y,
        self.z,
        self.camera.x,
        self.camera.y,
        self.camera.z,
        love.timer.getFPS()
    )
    love.graphics.print(text, 0, 0)
    love.graphics.setLineWidth(2.0)
    love.graphics.setColor(16, 16, 16, 12)

    self.camera:drawcube(self.camera.x - 0.5, self.camera.y - 0.5, self.camera.z - 0.5)

    love.graphics.setLineWidth(1.0)
    for x = 0, self.camera.unitwidth - 1 do
        for z = 0, self.camera.unitwidth - 1 do
            love.graphics.setColor(1, x / 16, z / 16)
            self.camera:drawcube(0 + x, 0, 0 + z)
            self.camera:drawcube(0 + x, self.camera.unitwidth - 1, 0 + z)
        end
    end

    love.graphics.setColor(0, 1, 0)
    for y = 1, self.camera.unitwidth - 2 do
        self.camera:drawcube(0, y, 0)
        self.camera:drawcube(self.camera.unitwidth - 1, y, 0)
        self.camera:drawcube(0, y, self.camera.unitwidth - 1)
        self.camera:drawcube(self.camera.unitwidth - 1, y, self.camera.unitwidth - 1)
    end
end

return {
    Editor = Editor
}
