local composer = require("composer")

local scene = composer.newScene()

local star = {}
local box = {}

function scene:create(event)
    local scene_group = self.view
    local function shuffle(array)
        local counter = #array

        while counter > 1 do
            local index = math.random(counter)
            array[counter], array[index] = array[index], array[counter]
            counter = counter - 1
        end

        return array
    end


    local transparentBox = {}
    for i = 1, 16 do
        box[i] = display.newImageRect("images/box.png", 50, 50)
        box[i].x = -20 + (i % 4) * 75
        box[i].y = 150 + (i / 4) * 100
        box[i].boxIndex = i
    end
    scene_group:insert(box)
    local numbers = { 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8 }
    numbers = shuffle(numbers)
    local starnum = {}
    for i = 1, 16 do
        star[i] = display.newImage("images/coin.png", 0.01, 0.01)
        star[i].x = box[i].x
        star[i].y = box[i].y
        starnum[i] = display.newText(numbers[i], 0, 0, native.systemFont, 20)
        starnum[i]:setTextColor(1, 0, 0)
        starnum[i].x = box[i].x
        starnum[i].y = box[i].y
        box[i]:toFront()
    end
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase
    print(box[i])
    if (phase == "will") then
        local tapnum = 0
        local a
        local b
        local score = 0
        local scoreText = display.newText("Score: 0", display.contentCenterX, 50, native.systemFont, 20)
        local function updateScore()
            scoreText.text = "Score: " .. score
        end
        local function same(x, y)
            if x and y then
                if numbers[x] == numbers[y] then
                    display.remove(box[x])
                    display.remove(box[y])
                    score = score + numbers[x]
                    print("Score:", score)
                    updateScore()
                else
                    transition.to(box[x], { y = box[x].y + 40 })
                    transition.to(box[y], {
                        y = box[y].y + 40,
                        onComplete = function()
                            transition.to(box[x], { y = box[x].y })
                            transition.to(box[y], { y = box[y].y })
                        end
                    })
                end
                a = nil
                b = nil
            end
        end

        local function handleBoxTap(event)
            local boxIndex = event.target.boxIndex
            local tappedBox = box[boxIndex]

            if a ~= nil and b == nil then
                b = boxIndex

                transition.to(tappedBox, {
                    y = tappedBox.y - 40,
                    onComplete = function()
                        print("b =", numbers[b])
                        same(a, b)
                    end
                })
            else
                a = boxIndex


                transition.to(tappedBox, {
                    y = tappedBox.y - 40,
                    onComplete = function()
                        print("a =", numbers[a])
                    end
                })
            end
            tapnum = tapnum + 1
        end

        for i = 1, 16 do
            -- box[i].boxIndex = i
            transition.to(box[i], {
                y = box[i].y - 50,
                onComplete = function()
                    timer.performWithDelay(3000, function()
                        transition.to(box[i], { y = box[i].y + 50 })
                    end)
                end
            })

            box[i]:addEventListener("tap", handleBoxTap)
        end
        if tapnum >= 10 then
            scene:hide()
        end
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        for i = 1, 16 do
            box[i]:removeSelf()
            star[i]:removeSelf()
        end
    end
end

-- scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)




return scene
