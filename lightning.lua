--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:4a363d6f76482298baa9d7871ed626f0:cb81758d9a9e19b693592d442427e135:74a6ee1732652fa474489b658ff699e6$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- 0
            x=2,
            y=2,
            width=75,
            height=16,

            sourceX = 0,
            sourceY = 2,
            sourceWidth = 75,
            sourceHeight = 20
        },
        {
            -- 1
            x=156,
            y=36,
            width=75,
            height=13,

            sourceX = 0,
            sourceY = 4,
            sourceWidth = 75,
            sourceHeight = 20
        },
        {
            -- 2
            x=156,
            y=2,
            width=75,
            height=15,

            sourceX = 0,
            sourceY = 3,
            sourceWidth = 75,
            sourceHeight = 20
        },
        {
            -- 3
            x=2,
            y=20,
            width=75,
            height=16,

            sourceX = 0,
            sourceY = 3,
            sourceWidth = 75,
            sourceHeight = 20
        },
        {
            -- 4
            x=79,
            y=2,
            width=75,
            height=16,

            sourceX = 0,
            sourceY = 2,
            sourceWidth = 75,
            sourceHeight = 20
        },
        {
            -- 5
            x=79,
            y=37,
            width=75,
            height=13,

            sourceX = 0,
            sourceY = 4,
            sourceWidth = 75,
            sourceHeight = 20
        },
        {
            -- 6
            x=156,
            y=19,
            width=75,
            height=15,

            sourceX = 0,
            sourceY = 3,
            sourceWidth = 75,
            sourceHeight = 20
        },
        {
            -- 7
            x=79,
            y=20,
            width=75,
            height=15,

            sourceX = 0,
            sourceY = 3,
            sourceWidth = 75,
            sourceHeight = 19
        },
    },
    
    sheetContentWidth = 233,
    sheetContentHeight = 52
}

SheetInfo.frameIndex =
{

    ["0"] = 1,
    ["1"] = 2,
    ["2"] = 3,
    ["3"] = 4,
    ["4"] = 5,
    ["5"] = 6,
    ["6"] = 7,
    ["7"] = 8,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
