--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:35069196909f39e70aaaec0983076627:b8cec787b0a3fe5557bad524843ef541:0579d6bb59d2d77c42959278470324b2$
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
            x=360,
            y=2,
            width=50,
            height=48,

            sourceX = 5,
            sourceY = 6,
            sourceWidth = 60,
            sourceHeight = 60
        },
        {
            -- 1
            x=614,
            y=2,
            width=48,
            height=46,

            sourceX = 6,
            sourceY = 7,
            sourceWidth = 60,
            sourceHeight = 60
        },
        {
            -- 10
            x=154,
            y=2,
            width=50,
            height=49,

            sourceX = 5,
            sourceY = 6,
            sourceWidth = 60,
            sourceHeight = 60
        },
        {
            -- 11
            x=310,
            y=2,
            width=48,
            height=49,

            sourceX = 6,
            sourceY = 6,
            sourceWidth = 60,
            sourceHeight = 60
        },
        {
            -- 12
            x=206,
            y=2,
            width=50,
            height=49,

            sourceX = 5,
            sourceY = 6,
            sourceWidth = 60,
            sourceHeight = 60
        },
        {
            -- 13
            x=2,
            y=2,
            width=50,
            height=50,

            sourceX = 5,
            sourceY = 5,
            sourceWidth = 60,
            sourceHeight = 60
        },
        {
            -- 2
            x=566,
            y=2,
            width=46,
            height=47,

            sourceX = 7,
            sourceY = 7,
            sourceWidth = 60,
            sourceHeight = 60
        },
        {
            -- 3
            x=412,
            y=2,
            width=50,
            height=48,

            sourceX = 5,
            sourceY = 6,
            sourceWidth = 60,
            sourceHeight = 60
        },
        {
            -- 4
            x=464,
            y=2,
            width=50,
            height=48,

            sourceX = 5,
            sourceY = 6,
            sourceWidth = 60,
            sourceHeight = 60
        },
        {
            -- 5
            x=258,
            y=2,
            width=50,
            height=49,

            sourceX = 5,
            sourceY = 6,
            sourceWidth = 60,
            sourceHeight = 60
        },
        {
            -- 6
            x=54,
            y=2,
            width=48,
            height=50,

            sourceX = 6,
            sourceY = 5,
            sourceWidth = 60,
            sourceHeight = 60
        },
        {
            -- 7
            x=104,
            y=2,
            width=48,
            height=50,

            sourceX = 6,
            sourceY = 5,
            sourceWidth = 60,
            sourceHeight = 60
        },
        {
            -- 8
            x=664,
            y=2,
            width=46,
            height=46,

            sourceX = 7,
            sourceY = 7,
            sourceWidth = 60,
            sourceHeight = 60
        },
        {
            -- 9
            x=516,
            y=2,
            width=48,
            height=48,

            sourceX = 6,
            sourceY = 6,
            sourceWidth = 60,
            sourceHeight = 60
        },
    },
    
    sheetContentWidth = 712,
    sheetContentHeight = 54
}

SheetInfo.frameIndex =
{

    ["0"] = 1,
    ["1"] = 2,
    ["10"] = 3,
    ["11"] = 4,
    ["12"] = 5,
    ["13"] = 6,
    ["2"] = 7,
    ["3"] = 8,
    ["4"] = 9,
    ["5"] = 10,
    ["6"] = 11,
    ["7"] = 12,
    ["8"] = 13,
    ["9"] = 14,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
