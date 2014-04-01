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

local W = display.contentWidth
local H = display.contentHeight
local S = 120

local layout = {
	bg_image = {
		center_x = W*0.50,
		center_y = H*0.50,
		width = W,
		height = H,
		bg_file = "assets/conppr_green.jpg"
	},
	tile_size = S,
	goal_area = {
		text_center_x = W*0.40,
		text_center_y = H*0.10,
		center_x = W*0.50,
		center_y = H*0.10,
		width = W*0.09375,
		height = H*0.15
	},
	back_btn = {
		center_x = W*0.50,
		center_y = H*0.95,
		width = W*0.1,
		height = H*0.1
	},
	play_area = {
		center_x = W*0.50,
		center_y = H*0.525,
		width = 480,
		height = 480,
		bg_file = "assets/conppr_grey.jpg"
	},
	play_grid = {
			{
				-- row=1
				center_x = W*0.50-S*1.50,
				center_y = H*0.525-S*1.50
			},
			{
				center_x = W*0.50-S*0.50,
				center_y = H*0.525-S*1.50
			},
			{
				center_x = W*0.50+S*0.50,
				center_y = H*0.525-S*1.50
			},
			{
				center_x = W*0.50+S*1.50,
				center_y = H*0.525-S*1.50
			},
			{
				-- row=2
				center_x = W*0.50-S*1.50,
				center_y = H*0.525-S*0.50
			},
			{
				center_x = W*0.50-S*0.50,
				center_y = H*0.525-S*0.50
			},
			{
				center_x = W*0.50+S*0.50,
				center_y = H*0.525-S*0.50
			},
			{
				center_x = W*0.50+S*1.50,
				center_y = H*0.525-S*0.50
			},
			{
				-- row=3
				center_x = W*0.50-S*1.50,
				center_y = H*0.525+S*0.50
			},
			{
				center_x = W*0.50-S*0.50,
				center_y = H*0.525+S*0.50
			},
			{
				center_x = W*0.50+S*0.50,
				center_y = H*0.525+S*0.50
			},
			{
				center_x = W*0.50+S*1.50,
				center_y = H*0.525+S*0.50
			},
			{
				-- row=4
				center_x = W*0.50-S*1.50,
				center_y = H*0.525+S*1.50
			},
			{
				center_x = W*0.50-S*0.50,
				center_y = H*0.525+S*1.50
			},
			{
				center_x = W*0.50+S*0.50,
				center_y = H*0.525+S*1.50
			},
			{
				center_x = W*0.50+S*1.50,
				center_y = H*0.525+S*1.50
			},
	},
	start_loc = {
		{
			-- col=1
			center_x = W*0.2188,
			center_y = H*0.125 
		},
		{
			center_x = W*0.2188,
			center_y = H*0.375 
		},
		{
			center_x = W*0.2188,
			center_y = H*0.625 
		},
		{
			center_x = W*0.2188,
			center_y = H*0.875 
		},
		{
			-- col=2
			center_x = W*0.7813,
			center_y = H*0.125 
		},
		{
			center_x = W*0.7813,
			center_y = H*0.375 
		},
		{
			center_x = W*0.7813,
			center_y = H*0.625 
		},
		{
			center_x = W*0.7813,
			center_y = H*0.875 
		},
		{
			-- col=3
			center_x = W*0.0781,
			center_y = H*0.125 
		},
		{
			center_x = W*0.0781,
			center_y = H*0.375 
		},
		{
			center_x = W*0.0781,
			center_y = H*0.625 
		},
		{
			center_x = W*0.0781,
			center_y = H*0.875 
		},
		{
			-- col=4
			center_x = W*0.9219,
			center_y = H*0.125 
		},
		{
			center_x = W*0.9219,
			center_y = H*0.375 
		},
		{
			center_x = W*0.9219,
			center_y = H*0.625 
		},
		{
			center_x = W*0.9219,
			center_y = H*0.875 
		},
    }
}

return layout