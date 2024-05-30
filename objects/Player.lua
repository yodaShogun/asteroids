local love = require "love"

local Laser = require "objects.Laser"

function Player()

    local SHIP_SIZE = 30
    local VIEW_ANGLE =  math.rad(90)

    local MaxLaserDistance  = 0.6
    local MaxLaser = 10

    return{

        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        radius = SHIP_SIZE / 2,
        angle  = VIEW_ANGLE,
        rotation = 0,
        lasers = {},
        thrusting  = false,
        thrust = {
            x = 0,
            y = 0,
            speed = 5,
            big_flame = false,
            flame = 2.0
        },

        drawFlameThrust = function(self, fillType, color)

            love.graphics.setColor(color)

            love.graphics.polygon(
                fillType,
                self.x - self.radius * ( 2/3 * math.cos(self.angle) + 0.5 * math.sin(self.angle)),
                self.y + self.radius * ( 2/3 * math.sin(self.angle) - 0.5 * math.cos(self.angle)),
                self.x - self.radius * self.thrust.flame *  math.cos(self.angle),
                self.y + self.radius * self.thrust.flame *  math.sin(self.angle),
                self.x - self.radius * ( 2/3 * math.cos(self.angle) - 0.5 * math.sin(self.angle)),
                self.y + self.radius * ( 2/3 * math.sin(self.angle) + 0.5 * math.cos(self.angle))
            )
        end,

        shootLazer = function (self)

            if #self < MaxLaser then
                table.insert(self.lasers, 1, Laser(
                    self.x,
                    self.y,
                    self.angle
                )) 
            end
        end,

        destroyLazer = function (self, index)
            table.remove(self.lasers, index)
        end,

        draw = function(self, faded)

            local opacity = 1

            if faded then
                opacity = 0.2
            end

            if self.thrusting then
                if not self.thrust.big_flame then
                    self.thrust.flame = self.thrust.flame - 1 / love.timer.getFPS()
                    if self.thrust.flame < 1.5 then
                        self.thrust.big_flame = true
                    end
                else
                    self.thrust.flame = self.thrust.flame + 1 /  love.timer.getFPS()
                    if self.thrust.flame > 2.5 then
                        self.thrust.big_flame = false
                    end
                end

                self:drawFlameThrust("fill", {255/255, 108/255, 25/255})
                self:drawFlameThrust("line", {1, 0.16, 0})
            end

            if showDebugging  then
                love.graphics.setColor(1, 0, 0)

                love.graphics.rectangle("fill", self.x-1, self.y-1, 2, 2)
                love.graphics.circle("line", self.x, self.y, self.radius)
            end

            love.graphics.setColor(1, 1, 1, opacity)

            love.graphics.polygon(
                "line",
                self.x + ( ( 4 / 3) *self.radius) * math.cos(self.angle),
                self.y - ( ( 4 / 3) *self.radius) * math.sin(self.angle),
                self.x - self.radius * ( 2/3 * math.cos(self.angle) + math.sin(self.angle)),
                self.y + self.radius * ( 2/3 * math.sin(self.angle) - math.cos(self.angle)),
                self.x - self.radius * ( 2/3 * math.cos(self.angle) - math.sin(self.angle)),
                self.y + self.radius * ( 2/3 * math.sin(self.angle) + math.cos(self.angle))
            )

            for _, laser in pairs(self.lasers) do
                laser:draw(faded)
            end

        end,

        movePlayer = function (self)
            local FPS  = love.timer.getFPS()
            local friction =  0.7

            self.rotation = 360/180 * math.pi/FPS

            if love.keyboard.isDown("left") then
                self.angle = self.angle - self.rotation
            end

            if self.thrusting then

                self.thrust.x = self.thrust.x + self.thrust.speed * math.cos(self.angle) / FPS
                self.thrust.y = self.thrust.y - self.thrust.speed * math.sin(self.angle) / FPS
            else
                if self.thrust.x ~=0 or self.thrust.y ~= 0 then
                    self.thrust.x = self.thrust.x - friction * self.thrust.x / FPS
                    self.thrust.y = self.thrust.y - friction * self.thrust.y / FPS
                end
            end

            self.x = self.x + self.thrust.x
            self.y = self.y + self.thrust.y

            if self.x + self.radius < 0 then  
                self.x  = love.graphics.getWidth() + self.radius
            elseif self.x - self.radius > love.graphics.getWidth() then
                self.x  = -self.radius
            end

            if self.y + self.radius < 0 then  
                self.y  = love.graphics.getHeight() + self.radius
            elseif self.y - self.radius > love.graphics.getHeight() then
                self.y  = -self.radius
            end
            for index, laser in pairs(self.lasers) do
                if(laser.distance > MaxLaserDistance * love.graphics.getWidth() and (laser.exploding == 0)) then
                    laser:expload()
                end 

                if laser.exploding == 0 then
                    laser:move()
                elseif laser.exploding == 2 then
                    self.destroyLazer(self, index)
                end
            end
        end
    }

end

return Player