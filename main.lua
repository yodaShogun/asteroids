---@diagnostic disable: lowercase-global

local love = require "love"
local Player  = require "Player"


function love.load()
    love.mouse.setVisible(false)

    mouseX, mouseY = 0, 0
    local debugger = true

    player = Player(debugger)

end

function love.update(dt)
    mouseX, mouseY = love.mouse.getPosition()
    player:movePlayer()
end

function love.draw()
    player:draw()
end