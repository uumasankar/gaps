local storyboard = require ("storyboard")
local scene = storyboard.newScene()

function scene:createScene(event)
    screenGroup = self.view
    
    background = display.newImage("start.png")
    background.x = 0 + background.width/2
    background.y = display.contentHeight - background.height/2
    screenGroup:insert(background)

end

function start(event)
    if event.phase == "began" then
        storyboard.gotoScene("game", "fade", 400)
    end
end

function scene:enterScene(event)
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