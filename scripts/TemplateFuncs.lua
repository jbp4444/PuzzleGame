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

function processTemplateFile( filename )
	-- create a file path for corona i/o
	local path = system.pathForFile( filename, system.ResourceDirectory )
	dprint( 15, "jsonTemplateFile ["..path.."]" )
	
	-- will hold contents of file
	local contents
	
	-- io.open opens a file at path. returns nil if no file found
	local file = io.open( path, "r" )
	if file then
	   -- read all contents of file into a string
	   contents = file:read( "*a" )
	   io.close( file )	-- close the file after using it
	else
		dprint( 15, "** Error: cannot open file" )
	end
	
	dprint( 15, 16, "contents<<<EOF")
	dprint( 15, 16, contents )
	dprint( 15, 16, ">>EOF")

	local function string_tokens( sss )
		local rtn = {}
		dprint( 15, "string_tokens("..sss..")" )
		local last_i = 1
		for i=1,sss:len() do
			local c = sss:sub(i,i)
			dprint( 15, "i="..i.."  c="..c.."  last_i="..last_i )
			if( (c=="+") or (c=="-") or (c=="*") or (c=="/") ) then
				-- this is an operator/token-separator
				-- save the last word-token
				local t = sss:sub( last_i, i-1 )
				table.insert( rtn, t )
				-- and save the last operator-token
				table.insert( rtn, c )
				last_i = i + 1
			else
				-- not a token delimiter, skip it
			end
		end
		-- and capture the last token
		local t = sss:sub( last_i, sss:len() )
		table.insert( rtn, t )
		dprint( 15, "insert3 ["..t.."]" )
		return rtn
	end

	local function string_eval( v, defns )
		-- now walk across the tokens in the string
		local tok = string_tokens( v )
		-- first, replace variables with their values
		for i,tk in ipairs(tok) do
			if( defns[tk] ~= nil ) then
				-- a variable, substitute it
				tok[i] = defns[tk] + 0
			elseif( (tk=="*") or (tk=="/") or (tk=="+") or (tk=="-") ) then
				-- an operator, skip it for now
			else
				-- assume a numeric string, convert to a number
				tok[i] = tk + 0
			end
		end
		-- next, look for mpy/div
		local i = 1
		while( i <= table.getn(tok) ) do
			local tk = tok[i]
			dprint( 20, "tk ["..tk.."]" )
			if( (tk=="*") or (tk=="/") ) then
				-- found mpy/div, grab the two operands
				-- NOTE: since table.remove shrinks the array,
				--    the indices we remove look odd
				--    the are i-1, i, i+1 (in original ordering)
				local x = table.remove( tok, i-1 )
				local op = table.remove( tok, i-1 )
				local y = table.remove( tok, i-1 )
				local z = 0
				if( tk == "*" ) then
					z = x * y
				else
					z = x / y
				end
				table.insert( tok, i-1, z )
			else
				i = i + 1
			end
		end
		-- next, look for add/sub
		local i = 1
		while( i <= table.getn(tok) ) do
			local tk = tok[i]
			dprint( 20, "tk ["..tk.."]" )
			if( (tk=="+") or (tk=="-") ) then
				-- found add/sub, grab the two operands
				-- NOTE: since table.remove shrinks the array,
				--    the indices we remove look odd
				--    the are i-1, i, i+1 (in original ordering)
				local x = table.remove( tok, i-1 )
				local op = table.remove( tok, i-1 )
				local y = table.remove( tok, i-1 )
				local z = 0
				if( tk == "+" ) then
					z = x + y
				else
					z = x - y
				end
				table.insert( tok, i-1, z )
			else
				i = i + 1
			end
		end
		-- TODO: use math.floor ??
		return (tok[1]+0)
	end
	
	local function walkTree( db, defns )
		-- TODO: add a "userdef" group to the json file
		-- to allow user to set "fixed" parameters
		
		for k, v in pairs(db) do
			if( type(v) == "table" ) then
				walkTree( db[k], defns )
			elseif( string.find(k,"file") ~= nil ) then
				-- this is a file reference, no processing to do
			elseif( string.find(k,"_comment") ~= nil ) then
				-- this is a comment line, no processing to do
				print( "found a comment line ["..v.."]" )
			else
				local new_v = string_eval( v, defns )
				db[k] = new_v
				dprint( 15, "db["..k.."]="..new_v )
			end
		end
	end

	local json_db = json.decode( contents )
	dprint( 5, "loaded json-template" )
	
	-- first, get the user-def "variables" and other globals
	local defns = {
		W = display.contentWidth,
		H = display.contentHeight,
		P = display.pixelWidth,
		Q = display.pixelHeight,
	}
	if( json_db.user_def ~= nil ) then
		for k,v in pairs(json_db.user_def) do
			local q = string_eval( v, defns )
			print( "user_def["..k.."] = {"..v.."} ["..q.."]" )
			defns[k] = q
		end
	end

	walkTree( json_db, defns )
	
	return json_db
end
