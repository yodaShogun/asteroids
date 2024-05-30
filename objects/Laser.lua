local love = require "love"

function Laser(x, y, angle)

    local LazerSpeed = 500
    local ExplodDur = 0.2

    return{
        x = x, 
        y = y, 
        xVel = LazerSpeed * math.cos(angle) / love.timer.getFPS(),
        yVel = - LazerSpeed * math.sin(angle) / love.timer.getFPS(),
        distance = 0,
        exploding  = 0,
        exploadTime  = 0,
        

        draw = function(self, faded)
            local opcaity  = 1 

            if faded then
                opcaity = 0.2
            end
            if self.exploding < 1 then   
                love.graphics.setColor(1, 1, 1, opcaity)
                love.graphics.setPointSize(3)
                love.graphics.points(self.x, self.y)
            else
                love.graphics.setColor(1, 104 / 255, 0, opcaity)
                love.graphics.circle("fill", self.x, self.y, 7 * 2)

                love.graphics.setColor(1, 234 / 255, 0, opcaity)
                love.graphics.circle("fill", self.x, self.y, 7 * 1)
            end
        end, 

        move = function (self)
            self.x = self.x + self.xVel
            self.y = self.y + self.yVel

            if self.exploadTime > 0 then
                self.exploadTime = 1
            end

            if self.x  < 0 then  
                self.x  = love.graphics.getWidth() 
            elseif self.x  > love.graphics.getWidth() then
                self.x  = 0
            end

            if self.y  < 0 then  
                self.y  = love.graphics.getHeight() 
            elseif self.y  > love.graphics.getHeight() then
                self.y  = 0
            end

            self.distance = self.distance + math.sqrt((self.xVel ^ 2) + (self.yVel ^ 2))
        end, 

        expload =  function(self)
            self.exploadTime =  math.ceil(ExplodDur * (love.timer.getFPS()/100))

            if self.exploadTime > ExplodDur then
                self.exploding = 2
            end
        end
    }

end

return Laser