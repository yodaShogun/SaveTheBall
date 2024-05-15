_G.love = require("love")

local hunter = require "Enemy"
local Button = require "Button"
math.random(os.time())

local player = {
    radius = 20,
    x = 30,
    y = 30,
}

local buttons  = {
    menu_state ={},
    ended_state = {}
}

local game = {
    difficulty = 1,
    state ={
        menu  = true,
        paused = false,
        running = false,
        ended = false
    },
    points = 0,
    levels = {15, 30, 60, 120}
}

local hunters = {}

local fonts = {
    medium = {
        font = love.graphics.newFont(16),
        size = 16
    },
    large = {
        font = love.graphics.newFont(24),
        size = 24
    },
    massive = {
        font = love.graphics.newFont(60),
        size = 60
    }
}

local function gameState(state)
    game.state['menu'] = state == "menu"
    game.state['paused'] = state == "paused"
    game.state['running'] = state == "running"
    game.state['ended'] = state == "ended"
end

local function newGame()

    gameState("running")

    hunters = {hunter(1)}
    game.points = 0

end


function love.mousepressed(x, y, button, istouch, pressed)
    if not game.state['running'] then
        if button == 1 then
            if game.state['menu'] then
                for index in pairs(buttons.menu_state) do
                    buttons.menu_state[index]:checkPressed(x, y, player.radius)
                end
            elseif game.state['ended'] then
                for index in pairs(buttons.ended_state) do
                    buttons.ended_state[index]:checkPressed(x, y, player.radius)
                end
            end
        end
    end
end


function love.load()

    love.window.setTitle("Nisi Pila")
    love.mouse.setVisible(false)

    buttons.menu_state.playGame  = Button("Play Game", newGame, nil, 120, 40)
    buttons.menu_state.settings  = Button("Settings", nil, nil, 120, 40)
    buttons.menu_state.exit  = Button("Quit", love.event.quit, nil, 120, 40)

    buttons.ended_state.replay  = Button("Replay", newGame, nil, 100, 50)
    buttons.ended_state.menu  = Button("menu", gameState, "menu", 100, 50)
    buttons.ended_state.exit  = Button("Quit", love.event.quit, nil, 100, 50)

end

function love.update(dt)
    player.x, player.y = love.mouse.getPosition()

    if game.state['running'] then
        for i=1, #hunters do
            if not hunters[i]:checkTouched(player.x, player.y, player.radius) then
                hunters[i]:move(player.x, player.y)
                
                for i = 1, #game.levels do
                    if math.floor(game.points) == game.levels[i] then
                        table.insert(hunters, i, hunter(game.difficulty * (i+1)))
                        game.points = game.points + 1
                    end
                end
            else
                gameState("ended")
            end
        end
        game.points = game.points + dt
    end
end

function love.draw()

    love.graphics.setFont(fonts.medium.font)

    love.graphics.printf("FPS: "..love.timer.getFPS(), fonts.medium.font, 10, love.graphics.getHeight() - 30, love.graphics.getWidth())


    if game.state['running'] then

        love.graphics.printf(math.floor(game.points), fonts.medium.font, 0, 10,  love.graphics.getWidth(), "center")

        for i=1, #hunters do
            hunters[i]:draw()
        end

        love.graphics.circle("fill", player.x, player.y, player.radius)

    elseif game.state['menu'] then
        buttons.menu_state.playGame:draw(10, 20, 17, 10)
        buttons.menu_state.settings:draw(10, 70, 17, 10)
        buttons.menu_state.exit:draw(10, 120, 17, 10)

    elseif game.state['ended'] then

        love.graphics.setFont(fonts.medium.font)

        buttons.ended_state.replay:draw(love.graphics.getWidth()/2.25, love.graphics.getHeight() / 1.8 , 10, 10)
        buttons.ended_state.menu:draw(love.graphics.getWidth()/2.25, love.graphics.getHeight() / 1.54, 17, 10)
        buttons.ended_state.exit:draw(love.graphics.getWidth()/2.25, love.graphics.getHeight() / 1.33, 22, 10)

        love.graphics.printf("Score: "..math.floor(game.points), fonts.massive.font, 0, love.graphics.getHeight() /2 -fonts.massive.size, love.graphics.getWidth(), "center" )
    end

    if not game.state['running'] then
        love.graphics.circle("fill", player.x, player.y, player.radius/3)
    end
end