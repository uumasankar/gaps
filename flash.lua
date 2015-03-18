--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:fd9ff92d02ab8dc2e0c41a5d0024195b:d3e5ed22b2c42c9b388b1b0004539c38:67cb4ea4ec5c8c3b1c898d8a5d51e89b$
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
            width=45,
            height=46,

            sourceX = 8,
            sourceY = 8,
            sourceWidth = 64,
            sourceHeight = 64
        },
        {
            -- 1
            x=49,
            y=2,
            width=45,
            height=46,

            sourceX = 8,
            sourceY = 8,
            sourceWidth = 64,
            sourceHeight = 64
        },
        {
            -- 2
            x=96,
            y=2,
            width=47,
            height=46,

            sourceX = 7,
            sourceY = 8,
            sourceWidth = 64,
            sourceHeight = 64
        },
        {
            -- 3
            x=96,
            y=2,
            width=47,
            height=46,

            sourceX = 7,
            sourceY = 8,
            sourceWidth = 64,
            sourceHeight = 64
        },
        {
            -- 4
            x=145,
            y=2,
            width=59,
            height=59,

            sourceX = 1,
            sourceY = 1,
            sourceWidth = 64,
            sourceHeight = 64
        },
        {
            -- 5
            x=49,
            y=2,
            width=45,
            height=46,

            sourceX = 8,
            sourceY = 8,
            sourceWidth = 64,
            sourceHeight = 64
        },
    },
    
    sheetContentWidth = 206,
    sheetContentHeight = 63
}

SheetInfo.frameIndex =
{

    ["0"] = 1,
    ["1"] = 2,
    ["2"] = 3,
    ["3"] = 4,
    ["4"] = 5,
    ["5"] = 6,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
