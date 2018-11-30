local class = require("middleclass/middleclass")

local Camera = class("Camera")

function Camera:initialize()
    self.x = 0.0
    self.y = 0.0
    self.z = 0.0
    self.targetX = 0.0
    self.targetY = 0.0
    self.targetZ = 0.0
    self.width = 20
end

function Camera:moveto(x, y, z, force)
    self.targetX = x
    self.targetY = y
    self.targetZ = z

    if force == true then
        self.x = self.targetX
        self.y = self.targetY
        self.z = self.targetZ
    end
end

function Camera:update()
    if self.x > self.targetX then
        self.x = self.x - 0.1
    elseif self.x < self.targetX then
        self.x = self.x + 0.1
    end

    if math.abs(self.x - self.targetX) < 0.01 then
        self.x = self.targetX
    end

    if self.y > self.targetY then
        self.y = self.y - 0.1
    elseif self.y < self.targetY then
        self.y = self.y + 0.1
    end

    if math.abs(self.y - self.targetY) < 0.01 then
        self.y = self.targetY
    end

    if self.z > self.targetZ then
        self.z = self.z - 0.1
    elseif self.z < self.targetZ then
        self.z = self.z + 0.1
    end

    if math.abs(self.z - self.targetZ) < 0.01 then
        self.z = self.targetZ
    end
end

return {Camera = Camera}
