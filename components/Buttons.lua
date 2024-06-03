local love = require "love"
local Text  = require "components.Text"

function Button (func, txtColor, btnColor, width, height, text, align, font, btnX, btnY, xTxt, yTxt)

    local btnText = {
        
    }

    func = func or function () print("Action Not Allowed") end

    if yTxt then
        btnText.y = yTxt + btnY
    else
        btnText.y = btnY
    end

    if xTxt then
        btnText.x = xTxt + btnX
    else
        btnText.x = btnX
    end

    return{
        txtColor  = txtColor or {r =1, g=1, b=1},
        btnColor = btnColor or {r =0, g=0, b=0},
        width = width or 100,
        height = height or 100,
        text = text or "VOID",
        xTxt = xTxt or btnX or 0,
        yTxt = yTxt or btnY or 0,
        btnX = btnX or 0,
        btnY = btnY or 0,
        text_component = {
            text,
            btnText.x,
            btnText.y,
            font,
            false,
            false,
            width,
            align,
            1
        },

        draw = function (self)
            love.graphics.setColor(self.btnColor["r"], self.btnColor["g"], self.btnColor["b"])
            love.graphics.rectangle("fill",self.btnX, self.btnY, self.width, self.height)
            love.graphics.setColor(self.btnColor["r"], self.btnColor["g"], self.btnColor["b"])

            self.text_component:draw()

            love.graphics.setColor(1, 1, 1)

        end,
    }
end

return Button