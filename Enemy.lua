local love  = require "love"

function Enemy(_level)

    local dice = math.random(1,4)
    local pX, pY
    local pRad = 20

    if dice == 1 then
        pX = math.random(pRad, love.graphics.getWidth())
        pY = - pRad * 4
    elseif dice == 2 then
        pX = - pRad * 4
        pY = math.random(pRad, love.graphics.getHeight())
    elseif dice == 3 then
        pX = math.random(pRad, love.graphics.getWidth())
        pY = love.graphics.getHeight() + (pRad * 4)
    else
        pX = love.graphics.getWidth() + (pRad * 4)
        pY = math.random(pRad, love.graphics.getWidth())
    end


    return{
        level = _level or 1,
        radius  = pRad,
        x = pX,
        y = pY,

        move  = function (self, playerX, playerY)
            if playerX -self.x > 0 then
                self.x  = self.x + self.level
            elseif playerX -self.x < 0 then
                self.x  = self.x - self.level
            end

            if playerY -self.y > 0 then
                self.y  = self.y + self.level
            elseif playerY -self.y < 0 then
                self.y  = self.y - self.level
            end
        end,

        checkTouched  = function (self, playerX, playerY, cursorRadius)
            return math.sqrt((self.x - playerX)^2 + (self.y - playerY)^2 ) <= cursorRadius *2
        end,

        draw = function(self)
            love.graphics.setColor(153/255, 153/255, 14/255)
            love.graphics.circle("fill", self.x, self.y, self.radius)
            love.graphics.setColor(1, 1, 1)
        end

    }
end

return Enemy