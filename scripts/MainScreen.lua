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

local scene = storyboard.newScene()


local function processButton( event )
	if( event.target == scene.gameBtn ) then
		settings.game = "Puzzle"
		storyboard.gotoScene( "scripts.SelectionScreen" )
		return true
	elseif( event.target == scene.rotBtn ) then
		settings.game = "Rotate"
		storyboard.gotoScene( "scripts.SelectionScreen" )
		return true
	elseif( event.target == scene.togBtn ) then
		settings.game = "Toggle"
		storyboard.gotoScene( "scripts.SelectionScreen" )
		return true
	elseif( event.target == scene.setBtn ) then
		storyboard.gotoScene( "scripts.SettingsScreen" )
		return true
	elseif( event.target == scene.aboutBtn ) then
		storyboard.gotoScene( "scripts.AboutScreen" )
		return true
	end
	return false
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	dprint( 10, "createScene-MainScreen" )

	local group = self.view
	
	local bkgd = display.newImage( "assets/conppr_brown.jpg", 
		system.ResourceDirectory,
		display.contentWidth/2,
		display.contentHeight/2,
		true
	)
	group:insert( bkgd )
	self.bkgd = bkgd

	local function getButton( txt, wd, ht )
		local btn = widget.newButton( {
			width  = wd,
			height = ht,
			label  = txt,
			onPress = processButton
		})
		btn.anchorX = 0.5
		btn.anchorY = 0.5
		return btn
	end

	local wd = display.contentWidth * 0.30
	local ht = 70
	
	local gameBtn = getButton( "New Puzzle", wd,ht )
	group:insert( gameBtn )
	self.gameBtn = gameBtn
	local rotBtn = getButton( "New Rotate-r", wd,ht )
	group:insert( rotBtn )
	self.rotBtn = rotBtn
	local togBtn = getButton( "New Toggle-r", wd,ht )
	group:insert( togBtn )
	self.togBtn = togBtn
	
	wd = display.contentWidth * 0.25
	local setBtn = getButton( "Settings", wd,ht )
	group:insert( setBtn )
	self.setBtn = setBtn
	local aboutBtn = getButton( "About Us", wd,ht )
	group:insert( aboutBtn )
	self.aboutBtn = aboutBtn
	
	gameBtn.x  = display.contentWidth*0.50
	gameBtn.y  = 50
	rotBtn.x  = display.contentWidth*0.50
	rotBtn.y  = 150
	togBtn.x  = display.contentWidth*0.50
	togBtn.y  = 250
	setBtn.x   = display.contentWidth*0.33
	setBtn.y   = 350
	aboutBtn.x = display.contentWidth*0.66
	aboutBtn.y = 350
	
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	dprint( 10, "enterScene-MainScreen" )
	
	local group = self.view

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	dprint( 10, "exitScene-MainScreen" )
	
	local group = self.view

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
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
