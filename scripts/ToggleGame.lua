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
	
	--
	-- game "geometry" calculations:
	--
	-- TODO: alter sizes, etc. based on numBoxes
	local numBoxes = settings.numBoxes
	local totalNumBoxes = numBoxes * numBoxes

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
				elseif( type == "button" ) then
					dprint( 7, "  target="..target.myType..","..target.myId )
					-- toggle for the pressed button happens automatically
					local btn  = game.btn
					local mask = btn[ target.myId ].mask
					for c=1,totalNumBoxes do
						if( mask[c] == 1 ) then
							if( btn[c].isOn ) then
								btn[c].isOn = false
								btn[c]:rotate( 180 )
							else
								btn[c].isOn = true
								btn[c]:rotate( 180 )
							end
						end
					end
					
				else
					-- not sure what this is
					dprint( 7, "  target=(unknown)" )
				end
			end
		end
		
		-- for any touch event that we see here, check if this is a "win"
		local c = 0
		local btn = game.btn
		for i=1,totalNumBoxes do
			if( btn[i].isOn == true ) then
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

	dprint( 7, "startGame - max-t="..settings.maxToggle )
	-- we need a dummy sprite-sheet
	local imageSize = 600
	local imgSheet = graphics.newImageSheet( settings.imageFile, {
		sheetContentWidth = imageSize,
		sheetContentHeight = imageSize,
		width = imageSize,
		height = imageSize,
		numFrames = 1
	})
	
	local function getButton( c )
		local btn = display.newImage( imgSheet, 1 )
		btn.width = gfx.tile_size
		btn.height = gfx.tile_size
		btn.myId = c
		btn.myType = "button"
		btn:addEventListener( "touch", touchHandler )
		game:insert( btn )
		return btn
	end

	local btn = {}
	for c=1,totalNumBoxes do
		btn[c] = getButton( c )
		btn[c].x = gfx.play_grid[c].center_x
		btn[c].y = gfx.play_grid[c].center_y
		-- initial state
		if( math.random( 0, 1 ) == 1 ) then
			btn[c].isOn = true
		else
			btn[c].isOn = false
			btn[c]:rotate( 180 )
		end
		btn[c].mask = {}
		print( "btn="..c.." init state="..btn[c].rotation )
	end
	game.btn = btn

	-- set masks for each button
	-- TODO: should probably check that every button has at least two mask entries
	local flag = 1
	while( flag == 1 ) do
		for c=1,totalNumBoxes do
			local mask = btn[c].mask
			for cc=1,totalNumBoxes do
				mask[cc] = 0
			end
			-- toggle the button itself when it's touched
			mask[c] = 1
			for cc=1,settings.maxToggle do
				local ii = math.random( 1,totalNumBoxes )
				if( ii == c ) then
					-- skip it
				else
					mask[ii] = 1
				end
			end 
		end
		-- TODO: check mask entries
		flag = 0
	end

	-- start a timer
	game.timer1 = os.time()
	game.timer2 = 0

	return game
end

return Game