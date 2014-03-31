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
	if( event.target == scene.backBtn ) then
		storyboard.gotoScene( "scripts.MainScreen" )
		return true
	end
	return false
end

local function stepperListener( event )
	local tgt = event.target
	
	if( tgt == scene.boxszWgt ) then
		if( event.phase == "increment" ) then
			settings.numBoxes = settings.numBoxes + 1
	    elseif( event.phase == "decrement" ) then
			settings.numBoxes = settings.numBoxes - 1
	    end
		scene.boxszTxt.text = settings.numBoxes
	elseif( tgt == scene.togszWgt ) then
		if( event.phase == "increment" ) then
			settings.maxToggle = settings.maxToggle + 1
	    elseif( event.phase == "decrement" ) then
			settings.maxToggle = settings.maxToggle - 1
	    end
		scene.togszTxt.text = settings.maxToggle
	end
	
	return true
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	dprint( 10, "createScene-SettingsScreen" )

	local group = self.view

	-- bg image
	local bgImg = display.newImage( "assets/conppr_brown.jpg" )
	bgImg.x = display.contentWidth * 0.50
	bgImg.y = display.contentHeight * 0.50
	bgImg.width = display.contentWidth
	bgImg.height = display.contentHeight
	group:insert( bgImg )
	self.bgImg = bgImg

	-- start a "counter" for y-position
	local y = 20

	-- stepper for box-size for grid
	local boxszExpl = display.newText( "Number of Boxes:", 20,20,
		native.systemFont, 20 )
	boxszExpl.anchorX = 0.5
	boxszExpl.anchorY = 0
	boxszExpl.x = display.contentWidth * 0.50
	boxszExpl.y = y
	group:insert( boxszExpl )
	self.boxszExpl = boxszExpl
	y = y + 25
	
	local boxszTxt = display.newText( settings.numBoxes, 20,20,
		native.systemFont, 20 )
	boxszTxt.anchorX = 0
	boxszTxt.anchorY = 0
	boxszTxt.x = display.contentWidth * 0.50
	boxszTxt.y = y
	group:insert( boxszTxt )
	self.boxszTxt = boxszTxt
	
	local boxszWgt = widget.newStepper({
		left = display.contentWidth*0.50 + 20,
		top  = y,
		initialValue = settings.numBoxes,
		minimumValue = 2,
		maximumValue = 6,
		onPress = stepperListener
	})
	group:insert( boxszWgt )
	self.boxszWgt = boxszWgt	
	
	y = y + 75

	-- stepper for max-toggle
	local togszExpl = display.newText( "Max Toggle:", 20,20,
		native.systemFont, 20 )
	togszExpl.anchorX = 0.5
	togszExpl.anchorY = 0
	togszExpl.x = display.contentWidth * 0.50
	togszExpl.y = y
	group:insert( togszExpl )
	self.togszExpl = togszExpl
	y = y + 25
	
	local togszTxt = display.newText( settings.maxToggle, 20,20,
		native.systemFont, 20 )
	togszTxt.anchorX = 0
	togszTxt.anchorY = 0
	togszTxt.x = display.contentWidth * 0.50
	togszTxt.y = y
	group:insert( togszTxt )
	self.togszTxt = togszTxt
	
	local togszWgt = widget.newStepper({
		left = display.contentWidth*0.50 + 20,
		top  = y,
		initialValue = settings.maxToggle,
		minimumValue = 1,
		maximumValue = 5,
		onPress = stepperListener
	})
	group:insert( togszWgt )
	self.togszWgt = togszWgt

	local backBtn = widget.newButton( {
			width  = display.contentWidth * 0.75,
			height = 100,
			left = display.contentWidth*0.125,
			top = display.contentHeight - 105,
			label  = "Back",
			onPress = processButton
	})
	backBtn.anchorX = 0.5
	backBtn.anchorY = 0.5
	group:insert( backBtn )
	self.backBtn = backBtn
	
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	dprint( 10, "enterScene-SettingsScreen" )
	
	local group = self.view

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	dprint( 10, "exitScene-SettingsScreen" )

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
