display.setStatusBar(display.HiddenStatusBar)

local composer     = require("composer")
local widget       = require("widget")

Score              = 0

local welcome      = display.newImage("images/welcome.jpg", display.contentCenterX, display.contentCenterY)
local screen_ratio = display.contentHeight / display.contentWidth
local pic_ratio    = welcome.height / welcome.width
if pic_ratio > screen_ratio then
    welcome.width = display.contentWidth
    welcome.height = welcome.width * pic_ratio
else
    welcome.height = display.contentHeight
    welcome.width = welcome.height / pic_ratio
end

local character = display.newImage("images/character.png", display.contentCenterX, display.contentCenterY)
character:scale(0.1, 0.1)

local button = widget.newButton {
    defaultFile = "images/start_btn.png",
    onPress = function(event)
        event.target.alpha = 0.75
    end,
    onRelease = function(event)
        event.target.alpha = 1
        composer.gotoScene("main_game", { effect = "fade", time = 500 })
    end,
    x = display.contentCenterX,
    y = display.contentCenterY + 125
}
button:scale(0.1, 0.1)


local button = widget.newButton {
    defaultFile = "images/start_btn.png",
    onPress = function(event)
        event.target.alpha = 0.75
    end,
    onRelease = function(event)
        event.target.alpha = 1
        composer.gotoScene("draw box", { effect = "fade", time = 500 })
    end,
    x = display.contentCenterX + 50,
    y = 100
}
button:scale(0.01, 0.01)

local button = widget.newButton {
    defaultFile = "images/start_btn.png",
    onPress = function(event)
        event.target.alpha = 0.75
    end,
    onRelease = function(event)
        event.target.alpha = 1
        composer.gotoScene("getcoin", { effect = "fade", time = 500 })
    end,
    x = display.contentCenterX + 50,
    y = 150
}
button:scale(0.01, 0.01)

local button = widget.newButton {
    defaultFile = "images/start_btn.png",
    onPress = function(event)
        event.target.alpha = 0.75
    end,
    onRelease = function(event)
        event.target.alpha = 1
        composer.gotoScene("tug of war", { effect = "fade", time = 500 })
    end,
    x = display.contentCenterX + 50,
    y = 200
}
button:scale(0.01, 0.01)
