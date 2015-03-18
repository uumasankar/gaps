local aspectRatio = display.pixelHeight / display.pixelWidth

application =
{

	content =
	{
		width = aspectRatio > 1.5 and 320 or math.ceil( 480 / aspectRatio ),
		height = aspectRatio < 1.5 and 480 or math.ceil( 320 * aspectRatio ), 
		scale = "zoomEven",
		fps = 30,
		xAlign = "left",
		yAlign = "center"
		
		--[[
		imageSuffix =
		{
			    ["@2x"] = 2,
		},
		--]]
	},

	--[[
	-- Push notifications
	notification =
	{
		iphone =
		{
			types =
			{
				"badge", "sound", "alert", "newsstand"
			}
		}
	},
	--]]    
}
