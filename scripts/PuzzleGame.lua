--
--   Copyright 2013 John Pormann
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
		dprint( 17, "processButton phase=" .. event.phase )
		local tgt = event.target
		if( event.phase == "began" ) then
			tgt:toFront()
			tgt.originalX = tgt.x
			tgt.originalY = tgt.y
		elseif( event.phase == "moved" ) then
			tgt.x = event.x
			tgt.y = event.y
		elseif( event.phase == "ended" ) then
			-- are we in a drop-zone?  (i.e. a grid-box)
			local solution = game.solution
			local bn = -1
			for i=1,totalNumBoxes do
				local gg = game.grid[i]
				local bb = gg.contentBounds
				if( (event.x>=bb.xMin) and (event.x<=bb.xMax) and
					(event.y>=bb.yMin) and (event.y<=bb.yMax) ) then
					bn = i
					break
				end
			end
			if( bn > 0 ) then
				local gg = game.grid[bn]
				local bb = gg.contentBounds
				tgt.x = ( bb.xMin + bb.xMax )/2
				tgt.y = ( bb.yMin + bb.yMax )/2
				solution[bn] = tgt.myId
			else
				-- not in a box, return to pile
				-- TODO: should animate this!
				transition.to( tgt, {
					x = tgt.origX,
					y = tgt.origY,
					time = 400,
				})
			end
			
			-- for any touch event, check if this is a "win"
			local c = 0
			for i=1,totalNumBoxes do
				if( solution[i] == i ) then
					c = c + 1
				end
			end
			if( c == totalNumBoxes ) then
				game.timer2 = os.time()
				timer.performWithDelay( 300, gameOver )
			end
	
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
	-- initialize and start the game
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
	
	--
	-- the puzzle pieces
	--
	local function getButton( c )
		local piece = display.newImage( imgSheet, c )
		piece.width = gfx.tile_size
		piece.height = gfx.tile_size
		piece.myId = c
		piece.myType = "piece"
		piece:addEventListener( "touch", touchHandler )
		game:insert( piece )
		return piece
	end
	local pieces = {}
	local solution = {}
	for c=1,totalNumBoxes do
		pieces[c] = getButton( c )
		-- assign out-of-bounds coords so piece doesn't 
		-- accidentally show up on screen
		pieces[c].x = display.contentWidth*2
		pieces[c].y = display.contentHeight*2
		solution[c] = 0
	end
	game.pieces = pieces
	game.solution = solution
	
	-- shuffle the pieces
	-- for the really paranoid, do more outer iterations
	for outer = 1,5 do
		for inner = 1,totalNumBoxes do
			local i = math.random(1,totalNumBoxes)
			local j = math.random(1,totalNumBoxes)
			if( i ~= j ) then
				local di = pieces[i]
				local dj = pieces[j]
				pieces[i] = dj
				pieces[j] = di
			end
		end
	end

	-- arrange tiles in starting locations
	for c=1,totalNumBoxes do
		pieces[c].x = gfx.start_loc[c].center_x
		pieces[c].y = gfx.start_loc[c].center_y
		pieces[c].origX = pieces[c].x
		pieces[c].origY = pieces[c].y
	end	
	
	-- draw the grid
	local grid = {}
	for c=1,totalNumBoxes do
		print( "c="..c.." ("..gfx.play_grid[c].center_x
			..","..gfx.play_grid[c].center_y..")" )
		local bx = display.newRect(
			gfx.play_grid[c].center_x,
			gfx.play_grid[c].center_y,
			gfx.tile_size, gfx.tile_size
		)
		bx.strokeWidth = 3
		bx:setFillColor( 0,0,0,0 )
		bx:setStrokeColor( 1,1,1 )
		grid[c] = bx
		game:insert( grid[c] )
	end
	game.grid = grid

	-- start a timer
	game.timer1 = os.time()
	game.timer2 = 0
	
	return game
end

return Game