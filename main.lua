---@diagnostic disable: lowercase-global

local love = require "love"
local Player  = require "objects.Player"
local Game  = require "states.Game"
local Menu = require "states.Menu"

require "globals"

math.randomseed(os.time())

function love.load()
    love.mouse.setVisible(false)

    mouseX, mouseY = 0, 0
    player = Player()
    game  = Game()
    menu = Menu(game, player)
end

function love.keypressed(key)

    if game.state.running then
        if key == "w" or key == "up" or key == "kp8" then
            player.thrusting = true
        end

        if key == "space" or key == "down" or key == "kp5" then
            player:shootLazer()
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

function love.mousepressed(x, y, button, istouch, pressed)
    if game.state.running then
        if button == 1 then
            player:shootLazer()
        else
            clickedMouse = true
        end
    end
end

function love.update(dt)
    mouseX, mouseY = love.mouse.getPosition()
    if game.state.running then

        player:movePlayer()

        for ast_index, asteroid in ipairs(asteroids) do
            if not player.exploading then
                if calculateDIstance(player.x, player.y, asteroid.x, asteroid.y) < asteroid.radius then
                    player:expload()
                    destAst = true
                end
            else
                player.exploadingTime = player.exploadingTime - 1

                if player.exploadingTime == 0 then
                    if player.lives - 1 <= 0 then
                        game:changeGameState("ended")
                        return
                    end
                    player = Player(player.lives - 1)
                end
            end

            for _, laser in pairs(player.lasers)do
                if calculateDIstance(laser.x, laser.y, asteroid.x, asteroid.y) < asteroid.radius then
                    laser:expload()
                    asteroid:destroy(asteroids, ast_index, game)
                end
            end
            if destAst then
                if player.lives - 1 <= 0 then
                    if player.exploadingTime == 0 then
                        destAst = false
                        asteroid:destroy(asteroids, ast_index, game)
                    end
                end
            else
                destAst = false
                asteroid:destroy(asteroids, ast_index, game)
            end

            asteroid:move(dt)
        end
    elseif game.state.menu then
        clickedMouse = false
    end

end

function love.draw()
    
    if game.state.running or game.state.paused then

        player:drawLives(game.state.paused)
        player:draw(game.state.paused)

        for _, asteroid in ipairs(asteroids) do
            asteroid:draw(game.state.paused)
        end

        game:draw(game.state.paused)
    elseif game.state.menu then    
        menu:draw()
    end

    --player:draw()
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.print(love.timer.getFPS(), 10, 10)
end