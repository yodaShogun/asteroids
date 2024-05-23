local love  = require "love"

function Text(text, x, y, fontSize, fadeIn, fadeOut, wrapWidth, align, opacity)

    fontSize = fontSize or "p"
    fadeIn  = fadeIn or false
    fadeOut = fadeOut or false
    wrapWidth = wrapWidth or love.graphics.getWidth()
    align = align or "left"
    opacity  = opacity or 1

    local FadeDuration  = 5

    local fonts  = {
        h1 = love.graphics.newFont(60),
        h2 = love.graphics.newFont(50),
        h3 = love.graphics.newFont(40),
        h4 = love.graphics.newFont(30),
        h5 = love.graphics.newFont(20),
        h6 = love.graphics.newFont(10),
        p =  love.graphics.newFont(16)
    }

    if fadeIn then
        opacity = 0.1

    end

    return{
        text = text,
        x = x,
        y = y,
        opacity = opacity,

        colors = {
            r = 1,
            g = 1,
            b = 1,
        },

        setColor = function (self, red, green, blue)
            self.colors.r = red
            self.colors.g = green
            self.colors.blue = blue
        end, 

        draw  = function (self, tbl_txt, index)
            if self.opacity > 0 then

                if fadeIn then

                    if self.opcaity< 1 then
                        self.opcaity = self.opacity + (1 / FadeDuration / love.timer.getFPS())
                    else
                        fadeIn = false
                    end
                    
                elseif fadeOut then
                    self.opacity = self.opacity - (1 / FadeDuration / love.timer.getFPS())
                end

                love.graphics.setColor(self.colors.r, self.colors.g, self.colors.b)

                love.graphics.setFont(fonts[fontSize])
                love.graphics.printf(self.text, self.x, self.y, wrapWidth, align)
                love.graphics.setFont(fonts['p'])
            else
                table.remove(tbl_txt , index)

                return false
            end

            return true
        end
    }

end

return Text