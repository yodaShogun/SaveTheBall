local love = require "love"

function Button(txt, func, func_param, width, height)

    return{
        width = width or 100,
        height = height or 100,
        func =  func or function () print("Not Allowed") end,
        func_param = func_param,
        txt = txt  or "Disabled",
        buttonX = 0,
        buttonY = 0,
        textX = 0,
        textY = 0,

        checkPressed = function (self, mouseX, mouseY, mouseRadius)
            if (mouseX + mouseRadius >= self.buttonX) and (mouseX - mouseRadius <= self.buttonX + self.width) then
                if (mouseY + mouseRadius >= self.buttonY) and (mouseY - mouseRadius <= self.buttonY + self.height) then
                    if self.func_param then
                        self.func(self.func_param)
                    else
                        self.func()
                    end
                end
            end
        end,

        draw = function(self,buttonX, buttonY, textX,textY)
            self.buttonX  = buttonX or self.buttonX
            self.buttonY  = buttonY or self.buttonY

            if textX then
                self.textX = textX + self.buttonX
            else
                self.textX = self.buttonX
            end

            if textY then
                self.textY = textY + self.buttonY
            else
                self.textY = self.buttonY
            end

            love.graphics.setColor(0.6, 0.6, 0.6)
            love.graphics.rectangle("fill", self.buttonX, self.buttonY, self.width, self.height)

            love.graphics.setColor(0,0,0)
            love.graphics.print(self.txt, self.textX, self.textY)

            love.graphics.setColor(1,1,1)
        end
    }
    
end

return Button