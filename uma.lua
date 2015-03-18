local storyboard = require ("storyboard")
local scene = storyboard.newScene()
local physics = require "physics"
physics.start()
physics.setGravity(0,0)
--physics.setDrawMode("hybrid")
score = require ("score")
local explodeSheetInfo = require("explode")
local boxSheetInfo = require("box-hd")
local gapSpace = 70
local groundaRef = 0
local minimumX = 0
local maximumX = display.contentWidth
local minimumY = 0
local maximumY = display.contentHeight
local level_increment = 100
local boxWidth = 50

scoreText = score.init({
    fontSize = 20,
    font = "Helvetica",
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
        if groundaObjects[i].y < 5 then
            gapas[i].x = groundaObjects[i].x + groundaObjects[i].width
            groundbObjects[i].x = gapas[i].x + gapas[i].width
            gapbs[i].x = groundbObjects[i].x + groundbObjects[i].width
            groundcObjects[i].x = gapbs[i].x + gapbs[i].width
            
        end
    end
end

local function scrollGround(self,event)
    if self.y > display.contentHeight then
        if self.width == display.contentWidth then
            self.y = -display.contentHeight
        else
            self.y = 0
            if self.position == "first" then
                groundaRef = math.random(-80, 0)
                self.x = groundaRef
                UpdateXCoord()
            end
        end
    else
        self.y = self.y + self.speed
    end
end

local function gameOver()
    storyboard.gotoScene("reset", "fade", 400)
end

local function explode()
    explosionSprite.x = mainbox.x
    explosionSprite.y = mainbox.y
    Runtime:removeEventListener("enterFrame", background1)
    Runtime:removeEventListener("enterFrame", background2)
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

local function isTouch(event)
    if event.phase == "began" then
        if mainbox.collided == false then
            explosionSprite.isVisible = False
            mainbox.collided = true
            mainbox.bodyType = "static"
            timer.cancel(incScore)
            timer.cancel(incSpeed)
            difficultyLevel = 2
            explode()
            timer.performWithDelay(2800,gameOver,1)
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
        elseif event.x > maximumX then
            t.x = maximumX - t.actualWidth/2
        else
            t.x = event.x - t.x0
        end
    elseif "ended" == phase or "cancelled" == phase then
        display.getCurrentStage():setFocus(nil)
        t.isFocus= False
    end
    return True
end

local function moveBox(event)
    boxStartX = mainbox.x - mainbox.actualWidth/2
    boxEndX = mainbox.x + mainbox.actualWidth/2
    if event.y > (mainbox.y + mainbox.actualHeight/2) and event.x >= boxStartX and event.x <= boxEndX then    
        mainbox.x = event.x
        if mainbox.x < (minimumX + mainbox.actualWidth/2) then
            mainbox.x = minimumX + mainbox.actualWidth/2
        elseif mainbox.x > (maximumX - mainbox.actualWidth/2) then
            mainbox.x = maximumX - mainbox.actualWidth/2
        end
    end
end

function scene:createScene(event)
    
    screenGroup = self.view
    
    difficultyLevel = 2
    backgroundSpeed = 1
    
    background1 = display.newImage("brick.png")
    background1.anchorX = 0
    background1.anchorY = 0
    background1.x = 0
    background1.y = 0
    background1.speed = backgroundSpeed
    screenGroup:insert(background1)
    
    background2 = display.newImage("brick.png")
    background2.anchorX = 0
    background2.anchorY = 0
    background2.x = 0
    background2.y = -background1.height
    background2.speed = backgroundSpeed 
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
    
    gap1a = display.newImage("gaps.png")
    gap1b = display.newImage("gaps.png")
    gap2a = display.newImage("gaps.png")
    gap2b = display.newImage("gaps.png")
    gap3a = display.newImage("gaps.png")
    gap3b = display.newImage("gaps.png")
    gap4a = display.newImage("gaps.png")
    gap4b = display.newImage("gaps.png")

    gapas = {gap1a, gap2a, gap3a, gap4a}
    gapbs = {gap1b, gap2b, gap3b, gap4b}
    
    baseaY = display.contentHeight/4
    baseaAddY = ground1a.height
    basebY = display.contentHeight/4
    basebAddY = ground1b.height
    basecY = display.contentHeight/4
    basecAddY = ground1b.height
    for i = 1, #groundaObjects do
        groundaObjects[i].anchorX = 0
        groundaObjects[i].x = math.random(-80, 0) 
        groundaObjects[i].y = baseaY - baseaAddY
        groundaObjects[i].speed = difficultyLevel
        groundaObjects[i].position = "first"
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
        gapas[i].position = "second"
        screenGroup:insert(gapas[i])
        gapas[i].isVisible = false
    end    
    for i = 1, #groundbObjects do
        groundbObjects[i].anchorX = 0
        groundbObjects[i].x = gapas[i].x + gapas[i].width
        groundbObjects[i].y = basebY - basebAddY
        groundbObjects[i].speed = difficultyLevel
        groundbObjects[i].position = "third"
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
        gapbs[i].position = "fourth"
        screenGroup:insert(gapbs[i])
        gapbs[i].isVisible = false
    end
    for i = 1, #groundcObjects do
        groundcObjects[i].anchorX = 0
        groundcObjects[i].x = gapbs[i].x + gapbs[i].width
        groundcObjects[i].y = basecY - basecAddY
        groundcObjects[i].speed = difficultyLevel
        groundcObjects[i].position = "fourth"
        screenGroup:insert(groundcObjects[i])
        physics.addBody(groundcObjects[i], "static")
        basecY = groundcObjects[i].y
        basecAddY = display.contentHeight/4
    end
    
    boxSheet = graphics.newImageSheet( "bbox.png", boxSheetInfo:getSheet() )
    local boxSequenceData = {
        {name = 'bbox', start=1, count=4, time = 500, loopCount = 0},
    } 
    mainbox = display.newSprite( boxSheet , boxSequenceData, {frames={boxSheetInfo:getFrameIndex("sprite")}} )
    mainbox.x = display.contentWidth/2  
    mainbox.y = display.contentHeight - display.contentHeight/4
    mainbox:play()
    screenGroup:insert(mainbox)
    physics.addBody(mainbox, "dynamic", {shape = {-boxWidth/2,-boxWidth/2, -boxWidth/2,boxWidth/2, boxWidth/2,boxWidth/2, boxWidth/2,-boxWidth/2}})
    mainbox.collided = false
    mainbox.actualWidth = boxWidth
    mainbox.actualHeight = boxWidth
    
    explosionSheet = graphics.newImageSheet( "explode.png", explodeSheetInfo:getSheet() )
    local explodeSequenceData = {
        {name = 'explode', start=1, count=46, time = 2500, loopCount = 1},
    } 
    explosionSprite = display.newSprite( explosionSheet , explodeSequenceData, {frames={explodeSheetInfo:getFrameIndex("sprite")}} )
    explosionSprite.isVisible = false
    screenGroup:insert(explosionSprite)
    
    score.set(0)
    startScoring = false
    updateStop = false
    gap_set = false
    lastLevel = 0    
end

function scene:enterScene(event)
    local groundNum = 1
    local groundLength = 0
    for _ in pairs(groundaObjects) do groundLength = groundLength + 1 end
    mainbox:addEventListener("touch", onTouch)
    Runtime:addEventListener("collision", isTouch)
    background1.enterFrame = scrollGround
    background2.enterFrame = scrollGround
    Runtime:addEventListener("enterFrame", background1)
    Runtime:addEventListener("enterFrame", background2)
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
    function incrementScore()
        if mainbox.collided == false then
            if groundaObjects[groundNum].y >= mainbox.y then
                score.add(1)
                if groundNum == groundLength then
                    groundNum = 1
                else
                    groundNum = groundNum + 1
                end
            end
        end
    end
    function incrementSpeed()
        level = math.floor(score.get()/level_increment)
        if level > lastLevel then
            difficultyLevel = difficultyLevel + level 
            lastLevel = level
            for i = 1, #groundaObjects do
                groundaObjects[i].speed = difficultyLevel
                groundbObjects[i].speed = difficultyLevel
                groundcObjects[i].speed = difficultyLevel
                gapas[i].speed = difficultyLevel
                gapbs[i].speed = difficultyLevel
            end
        end
    end
    incScore = timer.performWithDelay(1000, incrementScore, 0)
    incSpeed = timer.performWithDelay(1000, incrementSpeed, 0)
end

function scene:exitScene(event)
    mainbox:removeEventListener("touch", onTouch)
    Runtime:removeEventListener("collision", isTouch)
    Runtime:removeEventListener("touch", moveBox)
end

function scene:destroyScene(event)

end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene