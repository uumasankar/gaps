local storyboard = require ("storyboard")
local scene = storyboard.newScene()
local physics = require "physics"
physics.start()
physics.setGravity(0,0)
--physics.setDrawMode("hybrid")
score = require ("score")
local explodeSheetInfo = require("explode")
local boxSheetInfo = require("box-hd")
local lightningSheetInfo = require("lightning")
local circlesSheetInfo = require("circles")
local flashSheetInfo = require("flash")
local gapSpace = 70
local groundaRef = 0
local minimumX = 0
local maximumX = display.contentWidth
local minimumY = 0
local maximumY = display.contentHeight
local level_increment = 30
local speed_ceiling = 3.5
local boxWidth = 50
local startHeight = display.contentHeight/4
local startDifficultyLevel = 1.75
local backgroundSpeed = 1
local backgroundPic = "gsky.png"
local xScrollSpeed = 0.4
local startXScroll = startDifficultyLevel + 0.75
local blocksName = 'blocks'
local circlesName = 'circles'
local circleChance = 5
local circleIncrement = 20
local gamePause = false

scoreText = score.init({
fontSize = 22,
font = native.systemFontBold,
x = display.contentCenterX,
y = display.contentHeight - 20,
maxDigits = 7,
leadingZeros = true,
filename = "scorefile.txt",})

function sleep(n)
  os.execute("sleep " .. tonumber(n))
end

local function UpdateXCoord()
    for i = 1, #groundaObjects do
        gapas[i].x = groundaObjects[i].x + groundaObjects[i].width
        groundbObjects[i].x = gapas[i].x + gapas[i].width
        gapbs[i].x = groundbObjects[i].x + groundbObjects[i].width
        groundcObjects[i].x = gapbs[i].x + gapbs[i].width
    end
end

local function scrollGround(self,event)
    if self.y > display.contentHeight then
        if self.isBlock == true then
            self.isVisible = false
            physics.removeBody(self)
        end
        if self.isBackground == true then
            self.y = -display.contentHeight
        elseif self.isCircles == true then
            self.isVisible = false
        else
            self.y = 0
            if self.position == "first" then
                groundaRef = math.random(-80, 0)
                self.x = groundaRef
                UpdateXCoord()
                score.add(1)
            elseif self.isBlock == true then
                choiceBlock = math.random(100)
                choiceCircles = math.random(100)
                if choiceBlock%2 == 0 then
                    physics.addBody(self, "static")
                    self.isVisible = true
                    if choiceCircles%2 == 0 and score.get()>=circleChance and circles.isVisible==false then
                        circles.x = math.random(circles.width/2, display.contentWidth - circles.width/2)
                        circles.y = self.y - (display.contentHeight/4)/2
                        circles.isVisible = true
                        circleChance = circleChance + circleIncrement
                    end
                end
                if self.neighbour.isVisible == true then
                    physics.removeBody(self)
                    self.isVisible = false
                 end
            end
        end
    else
        self.y = self.y + self.speed
        if score.get() == 0 and self.y >= mainbox.y then
            score.add(1)
        end    
    end
    if difficultyLevel > startXScroll and self.isBackground ~= true and self.position == "first" then
        if self.x <= 0 and self.increment == true then
            self.x = self.x + self.xSpeed
            UpdateXCoord()
            if self.x >= 0 then
                self.increment = false
            end
        elseif self.x >= -self.width and self.increment == false then
            self.x = self.x - self.xSpeed
            UpdateXCoord()
            if self.x <= -self.width then
                self.increment = true
            end
        end
    end
end

local function scrollXGround(self,event)
end

local function gameOver()
    saveScore = score.load()
    if saveScore then
        if score.get()>saveScore then
            score.save()
        end
    else
        score.save()
    end
    storyboard.gotoScene("reset", "fade", 400)
end

local function explode()
    explosionSprite.x = mainbox.x
    explosionSprite.y = mainbox.y
    Runtime:removeEventListener("enterFrame", background1)
    Runtime:removeEventListener("enterFrame", background2)
    Runtime:removeEventListener("enterFrame", circles)
    for i = 1, #groundaObjects do
        Runtime:removeEventListener("enterFrame", groundaObjects[i])
        Runtime:removeEventListener("enterFrame", groundbObjects[i])
        Runtime:removeEventListener("enterFrame", groundcObjects[i])
        Runtime:removeEventListener("enterFrame", gapas[i])
        Runtime:removeEventListener("enterFrame", gapbs[i])
    end
    mainbox.isVisible = false
    explosionSprite.isVisible = true
    explosionSprite:play()
end

local function hasCollided(obj1, obj2)
    if (obj1 == nil) then
        return false
    end
    if (obj2 == nil) then
        return false
    end
    --assuming mainbox is obj2 and it is big in actual area
    local left = obj1.contentBounds.xMin <= (obj2.contentBounds.xMin+obj2.contentWidth/4) and obj1.contentBounds.xMax >= (obj2.contentBounds.xMin+obj2.contentWidth/4)
    local right = obj1.contentBounds.xMin >= (obj2.contentBounds.xMin+obj2.contentWidth/4) and obj1.contentBounds.xMin <= (obj2.contentBounds.xMax-obj2.contentWidth/4)
    local up = obj1.contentBounds.yMin <= (obj2.contentBounds.yMin+obj2.contentWidth/4) and obj1.contentBounds.yMax >= (obj2.contentBounds.yMin+obj2.contentWidth/4)
    local down = obj1.contentBounds.yMin >= (obj2.contentBounds.yMin+obj2.contentWidth/4) and obj1.contentBounds.yMin <= (obj2.contentBounds.yMax-obj2.contentWidth/4)
    return (left or right) and (up or down)
end

local function blinkBackground()
    if blinkBG.blinked then
        blinkBG.blinked = false
        transition.to( blinkBG, {time=5, alpha=0.35})
    else
        blinkBG.blinked = true
        transition.to( blinkBG, {time=5, alpha=0.10})
    end
end

local function circleCollision()
    if circles.collided == false and (hasCollided(circles, mainbox)) then
        circles.collided = true
        blinkBG.isVisible = true
        blinkBackground()
        score.add(1)
        circles.collided = false
    else
        blinkBG.isVisible = false
    end
end

local function isTouch(event)
    if event.phase == "began" then
        if event.object1.gameName == "blocks" or event.object2.gameName == "blocks" then
            if mainbox.collided == false then
                explosionSprite.isVisible = false
                mainbox.collided = true
                mainbox.bodyType = "static"
                timer.cancel(incSpeed)
                timer.cancel(circleColliderMain)
                explode()
                difficultyLevel = startDifficultyLevel
                timer.performWithDelay(2800,gameOver,1)
            end
        end
    end
end

local function onTouch(event)
    local t = event.target
    t.x0 = 0
    local phase = event.phase
    if "began" == phase then
        local parent = t.parent
        parent:insert(t)
        display.getCurrentStage():setFocus(t)
        t.x0 = event.x - t.x
    elseif "moved" == phase then
        if event.x < (minimumX + t.actualWidth/2) then
            t.x = minimumX + t.actualWidth/2
        elseif event.x > (maximumX - t.actualWidth/2) then
            t.x = maximumX - t.actualWidth/2
        else
            t.x = event.x - t.x0
        end
    elseif "ended" == phase or "cancelled" == phase then
        display.getCurrentStage():setFocus(nil)
        t.isFocus= false
    end
    return true
end

local function moveBox(event)
    boxStartX = mainbox.x - mainbox.actualWidth/2
    boxEndX = mainbox.x + mainbox.actualWidth/2
    if event.y > (mainbox.y + mainbox.actualHeight/2) and event.y < (display.contentHeight - pauseButton.height - 5)  and event.x >= boxStartX and event.x <= boxEndX then
        mainbox.x = event.x
        if mainbox.x < (minimumX + mainbox.actualWidth/2) then
            mainbox.x = minimumX + mainbox.actualWidth/2
        elseif mainbox.x > (maximumX - mainbox.actualWidth/2) then
            mainbox.x = maximumX - mainbox.actualWidth/2
        end
    end
end

local function toggleGamePause()
    if gamePause then
        gamePause = false
    else
        gamePause = true
    end    
end

local function resumeGame()
    if gamePause and mainbox.collided == false then
        mainbox:play()
        circleColliderMain = timer.performWithDelay(50, circleCollision, 0)
        resumeButton.isVisible = false
        pauseButton.isVisible = true
        pauseBg.isVisible = false
        physics.start()
        mainbox:addEventListener("touch", onTouch)
        Runtime:addEventListener("collision", isTouch)
        Runtime:addEventListener("touch", moveBox)
        Runtime:addEventListener("enterFrame", background1)
        Runtime:addEventListener("enterFrame", background2)
        Runtime:addEventListener("enterFrame", circles)
        for i = 1, #groundaObjects do
            Runtime:addEventListener("enterFrame", groundaObjects[i])
            Runtime:addEventListener("enterFrame", groundbObjects[i])
            Runtime:addEventListener("enterFrame", groundcObjects[i])
            Runtime:addEventListener("enterFrame", gapas[i])
            Runtime:addEventListener("enterFrame", gapbs[i])
        end
        timer.performWithDelay(200, toggleGamePause, 1)
    end
end

local function pauseGame(event)
    if gamePause == false and mainbox.collided == false then
        mainbox:pause()
        timer.cancel(circleColliderMain)
        pauseButton.isVisible = false
        resumeButton.isVisible = true
        pauseBg:toFront()
        pauseBg.isVisible = true
        physics.pause()
        mainbox:removeEventListener("touch", onTouch)
        Runtime:removeEventListener("collision", isTouch)
        Runtime:removeEventListener("touch", moveBox)
        Runtime:removeEventListener("enterFrame", background1)
        Runtime:removeEventListener("enterFrame", background2)
        Runtime:removeEventListener("enterFrame", circles)
        for i = 1, #groundaObjects do
            Runtime:removeEventListener("enterFrame", groundaObjects[i])
            Runtime:removeEventListener("enterFrame", groundbObjects[i])
            Runtime:removeEventListener("enterFrame", groundcObjects[i])
            Runtime:removeEventListener("enterFrame", gapas[i])
            Runtime:removeEventListener("enterFrame", gapbs[i])
        end
        timer.performWithDelay(200, toggleGamePause, 1)
    end
end

function scene:createScene(event)
    
    difficultyLevel = startDifficultyLevel
    screenGroup = self.view
    startScoring = false
    updateStop = false
    gap_set = false
    gamePause = false
    lastLevel = 0
    backgroundSpeed = 1
    xScrollSpeed = 0.4
    circleChance = 10
    score.set(0)    
   
    background1 = display.newImage(backgroundPic)
    background1.anchorX = 0
    background1.anchorY = 0
    background1.x = 0
    background1.y = 0
    background1.speed = backgroundSpeed
    background1.isBackground= true
    screenGroup:insert(background1)
    
    background2 = display.newImage(backgroundPic)
    background2.anchorX = 0
    background2.anchorY = 0
    background2.x = 0
    background2.y = -background1.height
    background2.speed = backgroundSpeed
    background2.isBackground= true
    screenGroup:insert(background2)
    
    blinkBG = display.newImage("background.png")
    blinkBG.anchorX = 0
    blinkBG.anchorY = 0
    blinkBG.x = 0
    blinkBG.y = 0
    blinkBG.isVisible = false
    blinkBG.alpha = 0.15
    blinkBG.blinked = true
    screenGroup:insert(background2)
     
    ground1a = display.newImage("maingac.png") 
    ground1b = display.newImage("maingb.png")
    ground1c = display.newImage("maingac.png")
    
    ground2a = display.newImage("maingac.png") 
    ground2b = display.newImage("maingb.png")
    ground2c = display.newImage("maingac.png")
    
    ground3a = display.newImage("maingac.png") 
    ground3b = display.newImage("maingb.png")
    ground3c = display.newImage("maingac.png")
    
    ground4a = display.newImage("maingac.png") 
    ground4b = display.newImage("maingb.png")
    ground4c = display.newImage("maingac.png")
    
    groundaObjects = {ground1a, ground2a, ground3a, ground4a}
    groundbObjects = {ground1b, ground2b, ground3b, ground4b}
    groundcObjects = {ground1c, ground2c, ground3c, ground4c}
    
    lightningSheet = graphics.newImageSheet( "lightning.png", lightningSheetInfo:getSheet() )
    local lightningSequenceData = {
        {name = 'lightning', start=1, count=8, time = 1000, loopCount = 0},
    }
    gap1a = display.newSprite( lightningSheet , lightningSequenceData, {frames={lightningSheetInfo:getFrameIndex("sprite")}} )
    gap1b = display.newSprite( lightningSheet , lightningSequenceData, {frames={lightningSheetInfo:getFrameIndex("sprite")}} )
    gap2a = display.newSprite( lightningSheet , lightningSequenceData, {frames={lightningSheetInfo:getFrameIndex("sprite")}} )
    gap2b = display.newSprite( lightningSheet , lightningSequenceData, {frames={lightningSheetInfo:getFrameIndex("sprite")}} )
    gap3a = display.newSprite( lightningSheet , lightningSequenceData, {frames={lightningSheetInfo:getFrameIndex("sprite")}} )
    gap3b = display.newSprite( lightningSheet , lightningSequenceData, {frames={lightningSheetInfo:getFrameIndex("sprite")}} )
    gap4a = display.newSprite( lightningSheet , lightningSequenceData, {frames={lightningSheetInfo:getFrameIndex("sprite")}} )
    gap4b = display.newSprite( lightningSheet , lightningSequenceData, {frames={lightningSheetInfo:getFrameIndex("sprite")}} )
    
    gapas = {gap1a, gap2a, gap3a, gap4a}
    gapbs = {gap1b, gap2b, gap3b, gap4b}
    
    baseaY = startHeight
    baseaAddY = ground1a.height
    basebY = startHeight
    basebAddY = ground1b.height
    basecY = startHeight
    basecAddY = ground1b.height
    for i = 1, #groundaObjects do
        groundaObjects[i].anchorX = 0
        groundaObjects[i].x = math.random(-80, 0) 
        groundaObjects[i].y = baseaY - baseaAddY
        groundaObjects[i].speed = difficultyLevel
        groundaObjects[i].xSpeed = xScrollSpeed
        groundaObjects[i].position = "first"
        groundaObjects[i].increment = true
        groundaObjects[i].gameName = blocksName
        screenGroup:insert(groundaObjects[i])
        physics.addBody(groundaObjects[i], "static")
        baseaY = groundaObjects[i].y
        baseaAddY = display.contentHeight/4
    end
    for i = 1, #gapas do
        gapas[i].anchorX = 0
        gapas[i].x = groundaObjects[i].x + groundaObjects[i].width
        gapas[i].y = groundaObjects[i].y
        gapas[i].speed = difficultyLevel
        gapas[i].xSpeed = xScrollSpeed
        gapas[i].position = "second"
        gapas[i].increment = true
        gapas[i].gameName = blocksName
        screenGroup:insert(gapas[i])
        gapas[i].isVisible = false
        gapas[i].isBlock = true
        gapas[i].neighbour = gapbs[i]
        gapas[i]:play()
    end    
    for i = 1, #groundbObjects do
        groundbObjects[i].anchorX = 0
        groundbObjects[i].x = gapas[i].x + gapas[i].width
        groundbObjects[i].y = basebY - basebAddY
        groundbObjects[i].speed = difficultyLevel
        groundbObjects[i].xSpeed = xScrollSpeed
        groundbObjects[i].position = "third"
        groundbObjects[i].increment = true
        groundbObjects[i].gameName = blocksName
        screenGroup:insert(groundbObjects[i])
        physics.addBody(groundbObjects[i], "static")
        basebY = groundbObjects[i].y
        basebAddY = display.contentHeight/4
    end
    for i = 1, #gapbs do
        gapbs[i].anchorX = 0
        gapbs[i].x = groundbObjects[i].x + groundbObjects[i].width
        gapbs[i].y = groundbObjects[i].y
        gapbs[i].speed = difficultyLevel
        gapbs[i].xSpeed = xScrollSpeed
        gapbs[i].position = "fourth"
        gapbs[i].increment = true
        gapbs[i].gameName = blocksName
        screenGroup:insert(gapbs[i])
        gapbs[i].isVisible = false
        gapbs[i].isBlock = true
        gapbs[i].neighbour = gapas[i]
        gapbs[i]:play()
    end
    for i = 1, #groundcObjects do
        groundcObjects[i].anchorX = 0
        groundcObjects[i].x = gapbs[i].x + gapbs[i].width
        groundcObjects[i].y = basecY - basecAddY
        groundcObjects[i].speed = difficultyLevel
        groundcObjects[i].xSpeed = xScrollSpeed
        groundcObjects[i].position = "fourth"
        groundcObjects[i].increment = true
        groundcObjects[i].gameName = blocksName
        screenGroup:insert(groundcObjects[i])
        physics.addBody(groundcObjects[i], "static")
        basecY = groundcObjects[i].y
        basecAddY = display.contentHeight/4
    end
    
    boxSheet = graphics.newImageSheet( "bbox.png", boxSheetInfo:getSheet() )
    local boxSequenceData = {
        {name = 'bbox', start=1, count=4, time = 500, loopCount = 0},
    } 
    mainbox = display.newSprite( boxSheet , boxSequenceData, {frames={boxSheetInfo:getFrameIndex("bbox")}} )
    mainbox.x = display.contentWidth/2  
    mainbox.y = display.contentHeight - display.contentHeight/4
    mainbox:play()
    screenGroup:insert(mainbox)
    physics.addBody(mainbox, "dynamic", {shape = {-boxWidth/2,-boxWidth/2, -boxWidth/2,boxWidth/2, boxWidth/2,boxWidth/2, boxWidth/2,-boxWidth/2}, bounce = 0, friction = 1})
    mainbox.isFixedRotation = true
    mainbox.collided = false
    mainbox.actualWidth = boxWidth
    mainbox.actualHeight = boxWidth
    mainbox.gameName = "box"
    
    explosionSheet = graphics.newImageSheet( "explode.png", explodeSheetInfo:getSheet() )
    local explodeSequenceData = {
        {name = 'explode', start=1, count=46, time = 2500, loopCount = 1},
    } 
    explosionSprite = display.newSprite( explosionSheet , explodeSequenceData, {frames={explodeSheetInfo:getFrameIndex("explode")}} )
    explosionSprite.isVisible = false
    screenGroup:insert(explosionSprite)
    
    circlesSheet = graphics.newImageSheet( "circles.png", circlesSheetInfo:getSheet() )
    local circlesSequenceData = {
        {name = 'circles', start=1, count=14, time = 1000, loopCount = 0},
    } 
    circles = display.newSprite( circlesSheet , circlesSequenceData, {frames={circlesSheetInfo:getFrameIndex("circles")}} )
    circles.isVisible = false
    screenGroup:insert(circles)
    circles:play()
    circles.collided = false
    circles.gameName = circlesName
    circles.speed = difficultyLevel
    circles.x = -boxWidth
    circles.isCircles = true
    
    flashSheet = graphics.newImageSheet( "flash.png", flashSheetInfo:getSheet() )
    local flashSequenceData = {
        {name = 'flash', start=1, count=6, time = 100, loopCount = 1},
    } 
    flash = display.newSprite( flashSheet , flashSequenceData, {frames={flashSheetInfo:getFrameIndex("flash")}} )
    flash.isVisible = false
    screenGroup:insert(flash)
    flash.x = circles.x
    flash.y = circles.y   
    
    pauseBg = display.newImage("pausebg.png")
    pauseBg.x = display.contentCenterX + 10
    pauseBg.y = display.contentCenterY - 35
    pauseBg.isVisible = false
    screenGroup:insert(pauseBg)
    
    pauseButton = display.newImage("pause.png")
    pauseButton.x = pauseButton.width/2 + 10
    pauseButton.y = display.contentHeight - pauseButton.height/2 - 5
    screenGroup:insert(pauseButton)
    
    resumeButton = display.newImage("resume.png")
    resumeButton.isVisible = false
    resumeButton.x = pauseButton.x
    resumeButton.y = pauseButton.y
    screenGroup:insert(resumeButton)

end

function scene:enterScene(event)
    pauseButton:addEventListener("touch", pauseGame)
    resumeButton:addEventListener("touch", resumeGame)
    mainbox:addEventListener("touch", onTouch)
    Runtime:addEventListener("collision", isTouch)
    background1.enterFrame = scrollGround
    background2.enterFrame = scrollGround
    Runtime:addEventListener("enterFrame", background1)
    Runtime:addEventListener("enterFrame", background2)
    circles.enterFrame = scrollGround
    Runtime:addEventListener("enterFrame", circles)
    Runtime:addEventListener("touch", moveBox)
    function GroundMove()
        for i = 1, #groundaObjects do
            groundaObjects[i].enterFrame = scrollGround
            Runtime:addEventListener("enterFrame", groundaObjects[i])
            gapas[i].enterFrame = scrollGround
            Runtime:addEventListener("enterFrame", gapas[i])
            groundbObjects[i].enterFrame = scrollGround
            Runtime:addEventListener("enterFrame", groundbObjects[i])
            gapbs[i].enterFrame = scrollGround
            Runtime:addEventListener("enterFrame", gapbs[i])
            groundcObjects[i].enterFrame = scrollGround
            Runtime:addEventListener("enterFrame", groundcObjects[i])
        end
        
    end
    GroundMove()
    function incrementSpeed()
        level = math.floor(score.get()/level_increment)
        if level > lastLevel and difficultyLevel <= speed_ceiling then
            difficultyLevel = difficultyLevel + level/4
            backgroundSpeed = backgroundSpeed + 0.25
            lastLevel = level
            for i = 1, #groundaObjects do
                groundaObjects[i].speed = difficultyLevel
                groundbObjects[i].speed = difficultyLevel
                groundcObjects[i].speed = difficultyLevel
                gapas[i].speed = difficultyLevel
                gapbs[i].speed = difficultyLevel
            end
            circles.speed = difficultyLevel
        end
    end
    incSpeed = timer.performWithDelay(1000, incrementSpeed, 0)
    circleColliderMain = timer.performWithDelay(50, circleCollision, 0)
end

function scene:exitScene(event)
    mainbox:removeEventListener("touch", onTouch)
    Runtime:removeEventListener("collision", isTouch)
    Runtime:removeEventListener("touch", moveBox)
    pauseButton:removeEventListener("touch", pauseGame)
    resumeButton:removeEventListener("touch", resumeGame)
end

function scene:destroyScene(event)

end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene