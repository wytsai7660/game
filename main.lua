display.setStatusBar(display.HiddenStatusBar)

local composer     = require("composer")
local widget       = require("widget")

Score              = 0

local welcome      = display.newImage("images/welcome.png", display.contentCenterX, display.contentCenterY)
local screen_ratio = display.contentHeight / display.contentWidth
local pic_ratio    = welcome.height / welcome.width
if pic_ratio > screen_ratio then
    welcome.width = display.contentWidth
    welcome.height = welcome.width * pic_ratio
else
    welcome.height = display.contentHeight
    welcome.width = welcome.height / pic_ratio
end

local button = widget.newButton {
    defaultFile = "images/stone5.png",
    onEvent = function(event)
        if event.phase == "began" then
            event.target.alpha = 0.75
        elseif event.phase == "ended" or event.phase == "cancelled" then
            event.target.alpha = 1
            composer.gotoScene("main_game", { effect = "fade", time = 500 })
        end
    end
}

button.x, button.y = display.contentCenterX, display.contentCenterY + 150
button.width, button.height = 400, 400
