local class = require("middleclass/middleclass")

local Camera = class("Camera")

local ttostring = nil

local function val_to_str(v)
    if "string" == type(v) then
        v = string.gsub(v, "\n", "\\n")
        if string.match(string.gsub(v, '[^\'"]', ""), '^"+$') then
            return "'" .. v .. "'"
        end
        return '"' .. string.gsub(v, '"', '\\"') .. '"'
    else
        return "table" == type(v) and ttostring(v) or ("number" == type(v) and string.format("%.3f", v) or tostring(v))
    end
end

local function key_to_str(k)
    if "string" == type(k) and string.match(k, "^[_%a][_%a%d]*$") then
        return k
    else
        return "[" .. val_to_str(k) .. "]"
    end
end

ttostring = function(tbl)
    local result, done = {}, {}
    for k, v in ipairs(tbl) do
        table.insert(result, val_to_str(v))
        done[k] = true
    end
    for k, v in pairs(tbl) do
        if not done[k] then
            table.insert(result, key_to_str(k) .. "=" .. val_to_str(v))
        end
    end
    return "{" .. table.concat(result, ",") .. "}"
end

function Camera:initialize()
    self.x, self.y, self.z = 0.0, 0.0, 0.0
    self.targetX, self.targetY, self.targetZ = 0.0, 0.0, 0.0
    self.unitwidth = 80
    self:resetdisplaymetrics()
end

function Camera:resetdisplaymetrics()
    self.screenwidth, self.screenheight, self.screenflags = love.window.getMode()
    self.centerx, self.centery = self.screenwidth / 2.0, self.screenheight / 3.0
    self.unitdimensions = self.screenwidth / self.unitwidth
end

function _multiplier(z, width)
    -- f(x) = mx + b
    -- f(0) = 1
    -- f(-width) = 0.5
    -- Solve eqn
    -- b = 1
    -- m*-width = -0.5
    -- m = 1/(2*width)
    -- return ((1.0 / (2.0 * width)) * z) + 1.0
    if z <= (-width * 2) then
        return nil
    elseif z >= (width * 2) then
        return nil
    end
    -- return math.pow(2, ((width - z) / (width * 2)))
    -- return math.pow(4, (width - z) / (width * 2))
    return math.pow(4, (width - z) / width)
end

function Camera:pointonscreen(x, y, z)
    local xpt, ypt, isOnScreen = nil, nil, false

    local multiplier = _multiplier(z - self.z, self.unitwidth)
    -- print(string.format("MUTLIPLERI(%s, %s) = %s", z - self.z, self.unitwidth, multiplier))

    if multiplier == nil or multiplier <= 0 then
        return {self.centerx, self.centery, false}
    end

    xpt = self.centerx + ((x - self.x) * self.unitdimensions * multiplier)
    ypt = self.centery + ((self.y - y) * self.unitdimensions * multiplier)

    if xpt >= 0 and xpt <= self.screenwidth and ypt >= 0 and ypt <= self.screenheight then
        isOnScreen = true
    end

    return {xpt, ypt, isOnScreen}
end

function Camera:drawcube(x, y, z)
    local c1, c2, c3, c4, c5, c6, c7, c8 =
        self:pointonscreen(x, y, z),
        self:pointonscreen(x + 1, y, z),
        self:pointonscreen(x, y + 1, z),
        self:pointonscreen(x + 1, y + 1, z),
        self:pointonscreen(x, y, z + 1),
        self:pointonscreen(x + 1, y, z + 1),
        self:pointonscreen(x, y + 1, z + 1),
        self:pointonscreen(x + 1, y + 1, z + 1)

    if not (c1[2] and c2[2] and c3[2] and c4[2] and c5[2] and c6[2] and c7[2] and c8[2]) then
        return
    end

    --love.graphics.print(val_to_str(c1), 0, 40)
    --love.graphics.print(val_to_str(c1[1]), 0, 80)
    -- back face
    love.graphics.line(c1[1], c1[2], c2[1], c2[2])
    love.graphics.line(c2[1], c2[2], c4[1], c4[2])
    love.graphics.line(c4[1], c4[2], c3[1], c3[2])
    love.graphics.line(c3[1], c3[2], c1[1], c1[2])

    -- connecting legs
    love.graphics.line(c1[1], c1[2], c5[1], c5[2])
    love.graphics.line(c2[1], c2[2], c6[1], c6[2])
    love.graphics.line(c4[1], c4[2], c8[1], c8[2])
    love.graphics.line(c3[1], c3[2], c7[1], c7[2])

    -- front face
    love.graphics.line(c5[1], c5[2], c6[1], c6[2])
    love.graphics.line(c6[1], c6[2], c8[1], c8[2])
    love.graphics.line(c8[1], c8[2], c7[1], c7[2])
    love.graphics.line(c7[1], c7[2], c5[1], c5[2])
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
    if self.x ~= self.targetX then
        local diff = (self.targetX - self.x) / 12.0
        if math.abs(diff) < 0.05 then
            diff = 0.05 * (math.abs(diff) / diff)
        end
        self.x = self.x + diff
    end

    if math.abs(self.x - self.targetX) < 0.05 then
        self.x = self.targetX
    end

    if self.y ~= self.targetY then
        local diff = (self.targetY - self.y) / 12.0
        if math.abs(diff) < 0.05 then
            diff = 0.05 * (math.abs(diff) / diff)
        end
        self.y = self.y + diff
    end

    if math.abs(self.y - self.targetY) < 0.05 then
        self.y = self.targetY
    end

    if self.z > self.targetZ then
        self.z = self.z - 0.1
    elseif self.z < self.targetZ then
        self.z = self.z + 0.1
    end

    if math.abs(self.z - self.targetZ) < 0.1 then
        self.z = self.targetZ
    end
end

return {Camera = Camera}
