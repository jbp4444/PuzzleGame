--
--   Copyright 2013-2014 John Pormann
--
--   Licensed under the Apache License, Version 2.0 (the "License");
--   you may not use this file except in compliance with the License.
--   You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
--   Unless required by applicable law or agreed to in writing, software
--   distributed under the License is distributed on an "AS IS" BASIS,
--   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--   See the License for the specific language governing permissions and
--   limitations under the License.
--

local storyboard = require( "storyboard" )
local widget = require( "widget" )
require( "scripts.UtilityFuncs" )

local scene = storyboard.newScene()


-- Called when the scene's view does not exist:
function scene:createScene( event )
	dprint( 10, "createScene-SplashScreen" )

	local group = self.view

	local function getSprite( name )
		local sprite = display.newImageRect( "assets/"..name, 100,100 )
		sprite.x = -200
		sprite.y = -200
		return sprite
	end
	
	local filelist = settings.fileList.list
	local spritelist = {}
	for i,v in ipairs(filelist) do
		local fn = v.filename
		dprint( 15, "file "..i.." = "..fn )
		local sprite = getSprite( fn )
		group:insert( sprite )
		spritelist[i] = sprite
	end
	self.spritelist = spritelist
	
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	dprint( 10, "enterScene-SplashScreen" )

	local group = self.view

	local spritelist = self.spritelist
	local n = table.getn( spritelist )
	local da = 2*3.14159265/n
	local aa = display.contentWidth/3
	local bb = display.contentHeight/3
	
	for i=1,n do
		local x = display.contentWidth/2 + aa*math.cos( i*da )
		local y = display.contentHeight/2 + bb*math.sin( i*da )
		local sprite = spritelist[i]
		sprite.x = x
		sprite.y = y
		transition.to( sprite, {
			time = 2000,
			rotation = 360,
		})

	end
	
	timer.performWithDelay( 2200, function()
		storyboard.gotoScene( "scripts.MainScreen" )
		end
	)

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	dprint( 10, "exitScene-SplashScreen" )

	local group = self.view

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	dprint( 10, "destroyScene-SplashScreen" )

	local group = self.view

	-----------------------------------------------------------------------------

	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)

	-----------------------------------------------------------------------------

end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene
