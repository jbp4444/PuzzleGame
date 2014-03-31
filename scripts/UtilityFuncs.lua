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

local json = require( "json" )

function dprint( num, txt )
	-- how much printing do we want?
	if( num < debug_level ) then
		print( txt )
	end
end

function printarray( aa )
	local txt = "array (n="..table.getn(aa).."): {"
	for i,v in ipairs(aa) do
		if( i == 1 ) then
			txt = txt .. tostring(v)
		else
			txt = txt .. "," .. tostring(v)
		end
	end
	txt = txt .. "}"
	print( txt )
end

function printtable(table, indent )
  indent = indent or 0;

	if( indent > 10 ) then
		return
	end
	
  print(string.rep('  ', indent)..'{');
  indent = indent + 1;
  for k, v in pairs(table) do

    local key = k;
    if (type(key) == 'string') then
      if not (string.match(key, '^[A-Za-z_][0-9A-Za-z_]*$')) then
        key = "['"..key.."']";
      end
    elseif (type(key) == 'number') then
      key = "["..key.."]";
    end

    if( key == '_class' ) then
        print( string.rep('  ', indent) .. "key="..tostring(key).." skipping" );
    elseif (type(v) == 'table') then
      if (next(v)) then
        print( string.rep('  ', indent) .. "key="..tostring(key));
        printtable(v, indent);
      else
        print( string.rep('  ', indent) .. "key="..tostring(key));
      end 
    elseif (type(v) == 'string') then
      print( string.rep('  ', indent) .. "key="..tostring(key) .. " val=['"..v.."']");
    else
      print( string.rep('  ', indent) .. "key="..tostring(key) .. " val=["..tostring(v).."]");
    end
  end
  indent = indent - 1;
  print(string.rep('  ', indent)..'}');
end

function readJsonFile( filename, base )
	-- set default base dir if none specified
	if not base then base = system.ResourceDirectory; end
	
	-- create a file path for corona i/o
	local path = system.pathForFile( filename, base )
	dprint( 5, "jsonFile ["..path.."]" )
	
	-- will hold contents of file
	local contents
	
	-- io.open opens a file at path. returns nil if no file found
	local file = io.open( path, "r" )
	if file then
	   -- read all contents of file into a string
	   contents = file:read( "*a" )
	   io.close( file )	-- close the file after using it
	else
		print( "** Error: cannot open file" )
	end
	
	dprint( 15, "contents<<<EOF")
	dprint( 15, contents )
	dprint( 15, ">>EOF")
	
	return json.decode( contents )
end

