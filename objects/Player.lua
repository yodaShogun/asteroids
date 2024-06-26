local love = require "love"

local Laser = require "objects.Laser"

function Player(num_lives)

    local SHIP_SIZE = 30
    local VIEW_ANGLE =  math.rad(90)
    local exploadDur = 3
    local MaxLaserDistance  = 0.6
    local MaxLaser = 10

    return{

        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        radius = SHIP_SIZE / 2,
        angle  = VIEW_ANGLE,
        rotation = 0,
        exploadingTime = 0,
        exploading = false,
        lasers = {},
        thrusting  = false,
        thrust = {
            x = 0,
            y = 0,
            speed = 5,
            big_flame = false,
            flame = 2.0
        },
        lives = num_lives or 3,

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

            if not self.exploding then
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
            else
                love.graphics.setColor(1, 0, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, self.radius * 1.5)

                love.graphics.setColor(1, 158 / 255, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, self.radius * 1)

                love.graphics.setColor(1, 234 / 255, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, self.radius * 0.5)
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

        drawLives = function (self, faded)
            local opacity = 1
            if faded then
                opacity = 0.2
            end

            if self.lives == 2 then
                love.graphics.setColor(1, 1, 0.5, opacity)
            elseif self.lives == 1 then
                love.graphics.setColor(1, 0.2, 0.2, opacity)
            else
                love.graphics.setColor(255, 255, 255, opacity)
            end

            local xPos, yPos = 45, 30

            for i=1, self.lives do

                if self.exploadingTime then
                    if i == self.lives then
                        love.graphics.setColor(1, 0, 0, opacity)
                    end
                end

                love.graphics.polygon(
                    "line",
                    (i * xPos) + ( ( 4 / 3) *self.radius) * math.cos(VIEW_ANGLE),
                    yPos - ( ( 4 / 3) *self.radius) * math.sin(VIEW_ANGLE),
                    (i * xPos) - self.radius * ( 2/3 * math.cos(VIEW_ANGLE) + math.sin(VIEW_ANGLE)),
                    yPos + self.radius * ( 2/3 * math.sin(VIEW_ANGLE) - math.cos(VIEW_ANGLE)),
                    (i * xPos) - self.radius * ( 2/3 * math.cos(VIEW_ANGLE) - math.sin(VIEW_ANGLE)),
                    yPos + self.radius * ( 2/3 * math.sin(VIEW_ANGLE) + math.cos(VIEW_ANGLE))
                ) 

            end
        end,

        movePlayer = function (self)

            self.exploding = self.exploadingTime > 0

            if not self.exploding then
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
        end, 

        expload = function (self)
            self.exploadingTime = math.ceil(exploadDur * love.timer.getFPS())
        end
    }

end

return Player