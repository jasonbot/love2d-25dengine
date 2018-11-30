local editor = require "editor"
local gameState = nil
--local profiler = require "profiler"

function love.load()
    --profiler:activate()
    gameState = editor.Editor:new()
end

function love.update(dt)
    if gameState ~= nil then
        gameState:update()
    end
end

function love.draw()
    if gameState ~= nil then
        gameState:draw()
    end
end

function love.keypressed(key)
    if gameState ~= nil then
        gameState:keypressed(key)
    end
end

function love.keyreleased(key)
    if key == "escape" then
        love.event.quit()
        --profiler:deactivate()
        --profiler:print_results()
        return
    end

    if gameState ~= nil then
        gameState:keyreleased(key)
    end
end

function love.resize(w, h)
    if gameState ~= nil then
        gameState:resize(w, h)
    end
end
