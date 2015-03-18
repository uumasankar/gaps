--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:d0ddd582a258ad1f4fc01973f18be5cf:f7e2cf201d49ab3f65d61fb686625db3:afd2819f325484b6be03a34db8894973$
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
            -- PointB
            x=2,
            y=2,
            width=128,
            height=128,

        },
        {
            -- PointG
            x=132,
            y=2,
            width=128,
            height=128,

        },
        {
            -- PointR
            x=262,
            y=2,
            width=128,
            height=128,

        },
        {
            -- PointY
            x=392,
            y=2,
            width=128,
            height=128,

        },
    },
    
    sheetContentWidth = 522,
    sheetContentHeight = 132
}

SheetInfo.frameIndex =
{

    ["PointB"] = 1,
    ["PointG"] = 2,
    ["PointR"] = 3,
    ["PointY"] = 4,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
