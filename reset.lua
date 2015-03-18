local storyboard = require ("storyboard")
local scene = storyboard.newScene()
local textScore = display.newText("High Score", display.contentCenterX, display.contentCenterY+70, native.systemFontBold, 32 )
textScore.isVisible = false

function scene:createScene(event)
    local screenGroup = self.view
    background = display.newImage("restart.png")
    background.x = 0 + background.width/2
    background.y = display.contentHeight - background.height/2
    screenGroup:insert(background)

end

function start(event)
    if event.phase == "began" then
        textScore.isVisible = false
        storyboard.gotoScene("game", "fade", 400)
    end
end

function scene:enterScene(event)
    textScore.text = "" .. score.load()
    --textScore.text = "test"
    textScore.isVisible = true
    storyboard.purgeScene("game")
    background:addEventListener("touch", start)
end

function scene:exitScene(event)
    background:removeEventListener("touch", start)
end

function scene:destroyScene(event)

end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene