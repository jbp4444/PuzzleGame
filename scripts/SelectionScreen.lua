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
	-- cancel all the tweens
	local group = scene.btnList
	local n = #group
	for i=1,n do
		local btn = group[i]
		local tween = btn.tween
		if( tween ~= nil ) then
			transition.cancel( tween )
		end
	end
	-- TODO: should we remove all small-images?
	-- set the parameter for which image-file to use
	settings.imageFile = event.target.filename
	-- transition to the next scene (the countdown scene)
	storyboard.gotoScene( "scripts.CountdownScreen" )
	return true
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	dprint( 10, "createScene-SelectionScreen" )

	local group = self.view

	local btnSz = 75

	local function getButton( filename )
		local btn = display.newImage( "assets/"..filename )
		btn.width = btnSz
		btn.height = btnSz
		btn:addEventListener( "touch", processButton )
		btn.filename = "assets/"..filename
		return btn
	end

	local btnList = {}
	
	local filelist = settings.fileList.list
	local n = table.getn( filelist )
	local da = 2*3.14159265/n
	local aa = display.contentWidth/3
	local bb = display.contentHeight/3
	for i,v in ipairs(filelist) do
		local fn = v.filename
		local x = display.contentWidth/2 + aa*math.cos( i*da )
		local y = display.contentHeight/2 + bb*math.sin( i*da )
		dprint( 15, "file "..i.." = "..fn )
		local btn = getButton( fn )
		btn.x = x
		btn.y = y
		group:insert( btn )
		local tween = transition.to( btn, {
			time = 2000,
			iterations = 100,
			rotation = 360,
		})
		btn.tween = tween
		table.insert( btnList, btn )
	end
	self.btnList = btnList
		
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	dprint( 10, "enterScene-SelectionScreen" )
	
	local group = self.view

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	dprint( 10, "exitScene-SelectionScreen" )
	
	local group = self.view

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	dprint( 10, "destroyScene-SelectionScreen" )

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
