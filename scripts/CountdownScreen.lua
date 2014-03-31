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

local scene = storyboard.newScene()


-- Called when the scene's view does not exist:
function scene:createScene( event )
	dprint( 10, "createScene-CountdownScreen" )

	local group = self.view
	local spriteGroup = display.newGroup()
	spriteGroup.anchorChildren = true
	spriteGroup.anchorX = 0
	spriteGroup.anchorY = 0

	local function getSprite( n, y0 )
		local bg
		if( n == 1 ) then
			bg = display.newImage( "assets/conppr_red.jpg" ) 
		elseif( n == 2 ) then
			bg = display.newImage( "assets/conppr_orange.jpg" ) 
		elseif( n == 3 ) then
			bg = display.newImage( "assets/conppr_yellow.jpg" ) 
		end
		bg.x = display.contentWidth * 0.50
		bg.y = y0
		bg.width = display.contentWidth
		bg.height = display.contentHeight
		spriteGroup:insert( bg )
		local txt = display.newText({
			text = n,
			font = native.systemFontBold,
			fontSize = 96,
		})
		txt.x = display.contentWidth * 0.50
		txt.y = y0
		txt:setFillColor( 0,0,0 )
		spriteGroup:insert( txt )
	end

	local y = display.contentHeight * 0.50
	local s3 = getSprite( 3, y )
	local s2 = getSprite( 2, 3*y )
	local s1 = getSprite( 1, 5*y )

	group:insert( spriteGroup )
	group.spriteGroup = spriteGroup
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	dprint( 10, "enterScene-CountdownScreen" )

	local group = self.view

	group.spriteGroup.y = 0

	transition.to( group.spriteGroup, {
		time = 3000,
		y = -2*display.contentHeight,
		onComplete = function(e)
			if( settings.game == "Puzzle" ) then
				storyboard.gotoScene( "scripts.PuzzleScreen" )
			elseif( settings.game == "Rotate" ) then
				storyboard.gotoScene( "scripts.RotateScreen" )
			elseif( settings.game == "Toggle" ) then
				storyboard.gotoScene( "scripts.ToggleScreen" )
			end
		end
	} )

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	dprint( 10, "exitScene-CountdownScreen" )

	local group = self.view

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	dprint( 10, "destroyScene-CountdownScreen" )

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
