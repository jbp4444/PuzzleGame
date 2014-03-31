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

local Game = {}

function Game.new( gfx )
	local game = display.newGroup()

	--
	-- state variables
	--
	local rotDirection = 1
	
	--
	-- game "geometry" calculations:
	--
	-- TODO: alter sizes, etc. based on numBoxes
	local numBoxes = settings.numBoxes
	local totalNumBoxes = numBoxes * numBoxes
	
	-- the image (spritesheet)
	-- TODO: read image info to get size
	local imageSize = 600
	local spriteSize = imageSize / settings.numBoxes
	-- TODO: what about non-evenly-divisible sizes?
	local imgSheet = graphics.newImageSheet( settings.imageFile, {
		sheetContentWidth = imageSize,
		sheetContentHeight = imageSize,
		width = spriteSize,
		height = spriteSize,
		numFrames = totalNumBoxes,
	})

	
	--
	-- functions
	--
	local function touchHandler( event )
		dprint( 7, "processButton phase=" .. event.phase )
		if event.phase == "began" then
			dprint( 7, "touch at "..event.x..","..event.y)
			target = event.target
			if( target == nil ) then
				-- this is a click on the background
				dprint( 7, "  target=nil" )
			else
				-- some object was touched
				local type = target.myType
				if( type == nil ) then
					-- not sure what this is
					dprint( 7, "  type=nil" )
				elseif( type == "rotCW" ) then
					rotDirection = 1
					game.rotCW:setFillColor( 1,1,1 )
					game.rotCCW:setFillColor( .5,.5,.5 )
				elseif( type == "rotCCW" ) then
					rotDirection = 2
					game.rotCCW:setFillColor( 1,1,1 )
					game.rotCW:setFillColor( .5,.5,.5 )
				elseif( type == "button" ) then
					dprint( 7, "  target="..target.myType..","..target.myId )
					-- TODO: what if it's not just rotation but 1-of-N images
					--  e.g. in a spritesheet?
					local rot = target.rot
					if( rotDirection == 1 ) then
						rot = (rot+1)%4
						target.rot = rot
						target:rotate( 90 )
					else
						rot = (rot+3)%4
						target.rot = rot
						target:rotate( -90 )
					end											
				else
					-- not sure what this is
					dprint( 7, "  target=(unknown)" )
				end
			end
		end
		
		-- for any touch event, check if this is a "win"
		local c = 0
		local btn = game.btn
		local soln = game.soln
		for i=1,totalNumBoxes do
			if( btn[i].rot == 0 ) then
				c = c + 1
			end
		end
		if( c == totalNumBoxes ) then
			game.timer2 = os.time()
			timer.performWithDelay( 300, gameOver )
		end

		return true
	end
	
	function gameOver( e )
		local tdiff = os.difftime(game.timer2,game.timer1)
		dprint( 7, "Game Over" )
		local alertBox = native.showAlert( "You Won!", 
			"You matched all the pieces in "..tdiff.." sec", 
			{ "Ok" }, function()
				storyboard.gotoScene( "scripts.MainScreen" )
			end )
	end
	

	--
	-- initialize and start the screen
	--

	-- bg image
	local bgImg = display.newImage( gfx.bg_image.bg_file )
	bgImg.x = gfx.bg_image.center_x
	bgImg.y = gfx.bg_image.center_y
	bgImg.width = gfx.bg_image.width
	bgImg.height = gfx.bg_image.height
	print( "bgImg ("..bgImg.x..","..bgImg.y..")  ["..bgImg.width.."x"
		..bgImg.height.."]" )
	game:insert( bgImg )
	game.bgImg = bgImg

	-- create a grey background for play-area
	local bkgd1 = display.newImage( gfx.play_area.bg_file )
	bkgd1.x = gfx.play_area.center_x
	bkgd1.y = gfx.play_area.center_y
	bkgd1.width = gfx.play_area.width
	bkgd1.height = gfx.play_area.height
	bkgd1:setFillColor( .5,.5,.5 )
	game:insert( bkgd1 )
	game.bkgd1 = bkgd1
			
	local text1 = display.newText({
		text = "Drag blocks to grid",
		x = gfx.play_area.center_x,
		y = gfx.play_area.center_y,
		font = native.systemFontBold,
		fontSize = 36
	})
	text1:setFillColor( 0.5,0.5,0.5 )
	game:insert( text1 )
	game.text1 = text1

	-- create a grey background for target
	local text2 = display.newText({
		text = "Goal:",
		x = gfx.goal_area.text_center_x,
		y = gfx.goal_area.text_center_y,
		font = native.systemFontBold,
		fontSize = 24
	})
	game:insert( text2 )
	game.text2 = text2		
	local bkgd2 = display.newRect(
		gfx.goal_area.center_x,
		gfx.goal_area.center_y,
		gfx.goal_area.width,
		gfx.goal_area.height
	)
	bkgd2.strokeWidth = 5
	bkgd2:setFillColor( .5,.5,.5 )
	game:insert( bkgd2 )
	game.bkgd2 = bkgd2
	local soln = display.newImage( settings.imageFile )
	soln.x = gfx.goal_area.center_x
	soln.y = gfx.goal_area.center_y
	soln.width = gfx.goal_area.width
	soln.height = gfx.goal_area.height
	game:insert( soln )
	game.soln = soln

	local rotCW = display.newImage( gfx.cw_btn.img_file )
	rotCW.width = gfx.cw_btn.width
	rotCW.height = gfx.cw_btn.height
	rotCW.x = gfx.cw_btn.center_x
	rotCW.y = gfx.cw_btn.center_y
	rotCW:addEventListener( "touch", touchHandler )
	rotCW.myType = "rotCW"
	game:insert( rotCW )
	game.rotCW = rotCW
	local rotCCW = display.newImage( gfx.ccw_btn.img_file )
	rotCCW.width = gfx.ccw_btn.width
	rotCCW.height = gfx.ccw_btn.height
	rotCCW.x = gfx.ccw_btn.center_x
	rotCCW.y = gfx.ccw_btn.center_y
	rotCCW:addEventListener( "touch", touchHandler )
	rotCCW.myType = "rotCCW"
	rotCCW:setFillColor( .5,.5,.5 )
	game:insert( rotCCW )
	game.rotCCW = rotCCW

	local text0 = display.newText({
		text = "Direction",
		x = display.contentWidth * 0.60 + 30,
		y = display.contentHeight * 0.75 + 50,
		font = native.systemFontBold,
		fontSize = 16
	})
	text0.anchorX = 0.5
	text0.anchorY = 0
	game:insert( text0 )
	game.text0 = text0


	local function getButton( c )
		local btn = display.newImage( imgSheet, c )
		btn.width = gfx.tile_size
		btn.height = gfx.tile_size
		btn:addEventListener( "touch", touchHandler )
		btn.myId = c
		btn.myType = "button"
		game:insert( btn )
		return btn
	end

	-- draw the grid/buttons
	local btn = {}
	for c=1,totalNumBoxes do
		print( "c="..c.." ("..gfx.play_grid[c].center_x
			..","..gfx.play_grid[c].center_y..")" )
		btn[c] = getButton( c )
		btn[c].x = gfx.play_grid[c].center_x
		btn[c].y = gfx.play_grid[c].center_y
		-- calculate initial state
		local rot = math.random(0,3)
		btn[c].rot = rot
		btn[c]:rotate( rot*90 )
		game:insert( btn[c] )
	end
	game.btn = btn

	-- start a timer
	game.timer1 = os.time()
	game.timer2 = 0
	
	return game
end

return Game