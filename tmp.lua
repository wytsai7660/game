Runtime:addEventListener("touch", on_touch)
timer.performWithDelay(10, function() if player.y > display.contentCenterY then player.y = player.y - 1 end end, 0)


-- waves
timer.performWithDelay(math.random(1000, 1500) / (Score / 100 + 0.5),
    function() new_obj("images/wave1.png", math.random(50, 100), math.random(50, 100)) end, 0)
timer.performWithDelay(math.random(500, 1000) / (Score / 100 + 0.5),
    function() new_obj("images/wave2.png", math.random(50, 100), math.random(50, 100)) end, 0)

-- background only
timer.performWithDelay(math.random(1000, 3000) / (Score / 100 + 0.5),
    function()
        new_obj("images/" .. background_elements[math.random(#background_elements)] .. ".png", math.random(50, 75),
            math.random(50, 75), false)
    end, 0)


-- stone
timer.performWithDelay(math.random(1000, 1500) / (Score / 100 + 0.5),
    function()
        new_obj("images/" .. obstacle_elements[math.random(#obstacle_elements)] .. ".png", math.random(50, 100),
            math.random(50, 100), true)
    end, 0)
