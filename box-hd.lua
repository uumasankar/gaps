--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:5ab24ea6ec8507eddbdfc003c859f373:f7e2cf201d49ab3f65d61fb686625db3:51bd76c31aba6c2b8d0b4dd04a7e105d$
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
            width=96,
            height=96,

        },
        {
            -- PointG
            x=100,
            y=2,
            width=96,
            height=96,

        },
        {
            -- PointR
            x=198,
            y=2,
            width=96,
            height=96,

        },
        {
            -- PointY
            x=296,
            y=2,
            width=96,
            height=96,

        },
    },
    
    sheetContentWidth = 394,
    sheetContentHeight = 100
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
