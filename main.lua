---@diagnostic disable: lowercase-global

local love = require "love"
local Player  = require "Player"


function love.load()
    love.mouse.setVisible(false)

    mouseX, mouseY = 0, 0
    local debugger = true

    player = Player(debugger)

end


function love.keypressed(key)
    if key == "w" or key == "up" or key == "kp8" then
        player.thrusting = true
    end
end 

function love.keyreleased(key)
    if key == "w" or key == "up" or key == "kp8" then
        player.thrusting = false
    end
end

function love.update(dt)
    mouseX, mouseY = love.mouse.getPosition()
    player:movePlayer()
end

function love.draw()
    
    player:draw()

    love.graphics.print(love.timer.getFPS(), 10, 10)
end