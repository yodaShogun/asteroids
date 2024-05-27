---@diagnostic disable: lowercase-global

local love = require "love"
local Player  = require "objects.Player"
local Game  = require "states.Game"

math.randomseed(os.time())

function love.load()
    love.mouse.setVisible(false)

    mouseX, mouseY = 0, 0
    local debugger = true

    player = Player(debugger)
    game  = Game()

    game:startNewGame(player)

end


function love.keypressed(key)

    if game.state.running then
        if key == "w" or key == "up" or key == "kp8" then
            player.thrusting = true
        end

        if key == "escape" then
            game:changeGameState("paused")
        end
    elseif game.state.paused then
        if key == "escape" then
            game:changeGameState("running")
        end
    end
end 

function love.keyreleased(key)
    if key == "w" or key == "up" or key == "kp8" then
        player.thrusting = false
    end
end

function love.update(dt)
    mouseX, mouseY = love.mouse.getPosition()
    if game.state.running then
        
        player:movePlayer()

        for ast_index, asteroid in ipairs(asteroids) do
            asteroid:move(dt)
        end
    end
end

function love.draw()
    
    if game.state.running or game.state.paused then
        player:draw(game.state.paused)

        for _, asteroid in ipairs(asteroids) do
            asteroid:draw(game.state.paused)
        end

        game:draw(game.state.paused)    
    end

    --player:draw()
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.print(love.timer.getFPS(), 10, 10)
end