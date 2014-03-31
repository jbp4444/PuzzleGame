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
require( "scripts.UtilityFuncs" )
local widget = require( "widget" )

-- helper function
debug_level = 11

display.setStatusBar(display.HiddenStatusBar)
widget.setTheme( "widget_theme_ios" )
math.randomseed(os.time())

-- load the filelist
local filelist = readJsonFile( "assets/imageFiles.json" )

-- global settings
settings = {
	colormap = 0,
	numBoxes = 3,
	game = "Puzzle",
	maxToggle = 1,
	imageFile = "assets/elephant.png",
	fileList = filelist
}

dprint( 5, "display is "..display.contentWidth.." x "..display.contentHeight )

-- load splash screen
storyboard.gotoScene( "scripts.SplashScreen" )
