local love = require "love"

math.randomseed(os.time())

function Asteroids(x, y, ast_size, level, debugging)
    debugging = debugging or false

    local AsteroidVert = 10
    local AsteroidsJag = 0.4
    local AsteroidsSpeed = math.random(50) + (level * 2)

    local vert  = math.floor(math.random(AsteroidVert + 1) + AsteroidVert/2)

    local offset ={}
    for i =1, vert+1 do
        table.insert(offset, math.random() * AsteroidsJag * 2 + 1 - AsteroidsJag)
    end


    local vel = -1

    if math.random < 0.5 then
        vel  = 1
    end

    return{
        x = x,
        y = y,
        xVel = math.random() * AsteroidsSpeed * vel,
        yVel = math.random() * AsteroidsSpeed * vel,
        radius = math.ceil(ast_size/2),

        draw = function (self,faded)
            local opcaity = 1

            if faded then
                opcaity = 0.2
            end

            love.graphics.setColor(186/255, 189/255, 182/255, opcaity)

            local points = {
                self.x + self.radius * self.offset

            }
        end


    }
end

return Asteroids