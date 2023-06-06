local composer = require("composer")
local physics = require("physics")
physics.start()

local scene = composer.newScene()

local games = { "draw_box", "getcoin", "tug of war" }

local riverbank
local player

function scene:create(event)
    -- local scene_group = self.view
    -- background
    local river = display.newImage("images/river.png", display.contentCenterX, display.contentCenterY)
    riverbank = display.newImage("images/riverbank.png", display.contentCenterX, display.contentCenterY)
    local screen_ratio = display.contentHeight / display.contentWidth
    riverbank.width = display.contentWidth - 100 -- weird, but works
    riverbank.height = display.contentHeight
    local pic_ratio = river.height / river.width
    if pic_ratio > screen_ratio then
        river.width = display.contentWidth
        river.height = river.width * pic_ratio
    else
        river.height = display.contentHeight
        river.width = river.height / pic_ratio
    end

    -- scene_group:insert(river)
    -- scene_group:insert(riverbank)

    -- local game_over_pic = display.newImage("images/game_over.png", display.contentCenterX,
    --     display.contentCenterY)
    -- pic_ratio = game_over_pic.height / game_over_pic.width
    -- if pic_ratio > screen_ratio then
    --     game_over_pic.width = display.contentWidth
    --     game_over_pic.height = game_over_pic.width * pic_ratio
    -- else
    --     game_over_pic.height = display.contentHeight
    --     game_over_pic.width = game_over_pic.height / pic_ratio
    -- end
    -- game_over_pic.alpha = 0


    --player
    player = display.newImageRect("images/player.png", 50, 50)
    player.x = display.contentCenterX
    player.y = display.contentCenterY
    physics.addBody(player, "dynamic")
    player.gravityScale = 0

    -- scene_group:insert(player)




    -- scene_group:insert(move)
    -- scene_group:insert(on_touch)

    -- score
    local scoredisplay = display.newText("Score : " .. Score, display.contentCenterX, 25, system.nativeFont, 18)

    timer.performWithDelay(1000, function()
        Score = Score + 1
        scoredisplay.text = "Score : " .. Score
        if Score % 100 == 0 then
            new_obj("images/swirl.png", 200, 200, true)
        end
    end, 0)



    -- crocodile
    local scale = 0.05
    local pos1, pos2 = display.contentCenterX - 25 * 5 + 7.5, display.contentCenterX + 25 * 5 - 7.5
    timer.performWithDelay(250, function()
        local crocodile = display.newImage("images/crocodile_l.png", pos1, display.contentHeight - 50)
        crocodile:scale(scale, scale)
        timer.performWithDelay(500, function()
            if crocodile.rotation == 0 then
                crocodile.rotation = -20
            else
                crocodile.rotation = 0
            end
        end, 0)
        pos1 = pos1 + 25
    end, 5)

    timer.performWithDelay(250, function()
        local crocodile = display.newImage("images/crocodile_r.png", pos2, display.contentHeight - 50)
        crocodile:scale(scale, scale)
        timer.performWithDelay(500, function()
            if crocodile.rotation == 0 then
                crocodile.rotation = -20
            else
                crocodile.rotation = 0
            end
        end, 0)
        pos2 = pos2 - 25
    end, 5)

    local lose_area = display.newRect(display.contentCenterX, display.contentHeight, display.contentWidth, 50)
    lose_area.alpha = 0
    physics.addBody(lose_area, "static", { isSensor = true })

    -- events
    player:addEventListener("collision", function(event)
        if event.phase == "began" and not over then
            if event.other == lose_area then
                scene:addEventListener("show", scene)
                -- composer.gotoScene("game_over", { effect = "fade", time = 500, params = { score = Score } })
                -- game_over_pic.alpha = 0.5
                -- player:removeSelf()
                physics.removeBody(player)
                player.x = display.contentCenterX
                player.y = display.contentCenterY
                player.alpha = 0
                over = true
                display.newText("Game Over", display.contentCenterX, display.contentCenterY, system.nativeFont, 40)
                display.newText("your score : " .. Score, display.contentCenterX, display.contentCenterY + 50,
                    system.nativeFont, 20)
            end
        end
    end)

    timer.performWithDelay(10, function() if player.y > display.contentCenterY then player.y = player.y - 1 end end,
        0)
end

function scene:show(event)
    -- local scene_group = self.view

    local move_time = 1 -- optional
    local touch_x
    local on_touch
    local move = function()
        if touch_x == player.x then return end
        local x
        if touch_x > player.x then
            x = math.min(touch_x, player.x + 10)
        else
            x = math.max(touch_x, player.x - 10)
        end
        transition.to(player, { x = x, time = math.abs(x - player.x) * move_time, onComplete = on_touch })
    end

    on_touch = function(event)
        if event.phase == "began" or event.phase == "moved" or event.phase == "stationary" then -- weird issue: using only 'else' will make the player movement not continuous
            if event.x < 100 then
                touch_x = 100
            elseif event.x > display.contentWidth - 100 then
                touch_x = display.contentWidth - 100
            else
                touch_x = event.x
            end
        elseif event.phase == "ended" then
            transition.cancel(player)
            return
        end
        move()
    end

    Runtime:addEventListener("touch", on_touch)

    -- new object
    local new_obj = function(pic, width, height, body)
        local obj = display.newImageRect(pic, width, height)
        if not over then
            -- game_over_pic:toFront()
            -- else
            riverbank:toFront()
            player:toFront()
        end
        if pic == "images/swirl.png" then
            obj.x = display.contentCenterX
        else
            obj.x = math.random(75, display.contentWidth - 75)
        end
        obj.y = -10

        if pic == "images/swirl.png" then
            physics.addBody(obj, "dynamic", { isSensor = true })
            obj.gravityScale = 0
            obj:addEventListener("collision", function(event)
                if event.other == player then
                    composer.gotoScene(games[math.random(#games)],
                        { effect = "fade", time = 500, params = { score = Score } })
                end
            end)

            transition.to(obj,
                {
                    y = display.contentHeight,
                    rotation = obj.rotation + 360,
                    time = 5000,
                    iterations = 0,
                    deltaAngle = 45,
                    onComplete = function() obj:removeSelf() end
                })
        else
            if body then
                physics.addBody(obj, "dynamic")
                obj.gravityScale = 0
            end
            transition.to(obj,
                {
                    y = display.contentHeight,
                    time = math.random(1000, 3000) / (Score / 100 + 0.5),
                    onComplete = function() obj:removeSelf() end
                })
        end
    end

    -- waves
    timer_generate_waves = timer.performWithDelay(math.random(1000, 1500) / (Score / 100 + 0.5),
        function() new_obj("images/wave1.png", math.random(50, 100), math.random(50, 100)) end, 0)
    timer.performWithDelay(math.random(500, 1000) / (Score / 100 + 0.5),
        function() new_obj("images/wave2.png", math.random(50, 100), math.random(50, 100)) end, 0)


    -- elements
    local background_elements = { "leaf1", "leaf2", "leaf3", "starfish", "conch", "grass" }
    local obstacle_elements = { "stone1", "stone2", "stone3", "stone4", "stone5", "driftwood1", "driftwood2" }


    -- background only
    timer.performWithDelay(math.random(1000, 3000) / (Score / 100 + 0.5),
        function()
            new_obj("images/" .. background_elements[math.random(#background_elements)] .. ".png",
                math.random(50, 75),
                math.random(50, 75), false)
        end, 0)


    -- stone
    timer.performWithDelay(math.random(1000, 1500) / (Score / 100 + 0.5),
        function()
            new_obj("images/" .. obstacle_elements[math.random(#obstacle_elements)] .. ".png", math.random(50, 100),
                math.random(50, 100), true)
        end, 0)
end

function scene:hide()
    timer.cancel(timer_generate_waves)
end

-- listeners
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)


return scene
