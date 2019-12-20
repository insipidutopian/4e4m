local FileUtil = {Instances={}}
local FileUtil_mt = { __index = FileUtil }  -- metatable

function FileUtil:new(...)	-- constructor
	local instance = setmetatable({}, self)
	print ("FileUtil.new called")
	return instance
end
 

function FileUtil:initialize()
	print ("FileUtil:initialize() - Initializing FileUtil...")
	table.insert(self.Instances, self)
end

function FileUtil.__call(_, value)
	return Underscore:new(value)
end

function FileUtil:new(value, chained)
	return setmetatable({ _val = value or false }, self)
end


function FileUtil.writeUserFile(self, fName, fData)
	--local fName = "myFile.txt"
	print ("FileUtil.writeFile: " .. fName .. " called")
	print ("FileUtil.writeFile: data=" .. fData)
	local path = system.pathForFile( fName, system.DocumentsDirectory )

	local file = io.open( path, "w" )
	file:write( fData )

	io.close( file )

	file = nil
end


function FileUtil.loadUserFile(self, fName)
	--local fName = "myFile.txt"
	local path = system.pathForFile( fName, system.DocumentsDirectory )

	local readCount = 0
	local fContents = ""
	local file = io.open( path, "r" )

	if file then 
		print ("FileUtil.loadFile: " .. fName .. " opened successfully")
		-- local savedData = file:read( "*a" )
		for line in file:lines() do
		    print( "FileUtil.loadFile read: " .. line )
		    readCount = readCount + 1
		    fContents = fContents .. line .. "\n"
		    local key, value = line:match '(%S+)=(%S+)'
		    --print ("KEY=" .. key .. ", VALUE=" .. value)
		end
		-- print ("read '" .. savedData .. "' from " .. fName)
		io.close( file )
	else
		print ("FileUtils.loadFile: could not open file, " .. fName)
	end
	file = nil

	return fContents
end

function FileUtil.loadSettingsFile(self, fName, settings)
	--local fName = "myFile.txt"
	local path = system.pathForFile( fName, system.DocumentsDirectory )

	print ("Attempting to open settings file.")
	local readCount = 0
	local fContents = ""
	local file = io.open( path, "r" )

	if file then 
		print ("FileUtil.loadFile: " .. fName .. " opened successfully")
		-- local savedData = file:read( "*a" )
		for line in file:lines() do
		    --print( "FileUtil.loadFile read: " .. line )
		    readCount = readCount + 1
		    fContents = fContents .. line .. "\n"
		    local key, value = line:match '(%S+)=(%S+)'
		    -- print ("KEY=" .. key .. ", VALUE=" .. value)
		    settings[key] = value
		end
		-- print ("read '" .. savedData .. "' from " .. fName)
		io.close( file )
	else
		print ("FileUtils.loadFile: could not open file, " .. fName)
	end
	file = nil

	return fContents
end

function FileUtil.writeSettingsFile(self, fName, settings)
	--local fName = "myFile.txt"
	print ("FileUtil.writeFile: " .. fName .. " called")
	local path = system.pathForFile( fName, system.DocumentsDirectory )

	local file = io.open( path, "w" )

	for key,v in pairs(settings) do
		file:write( key .. "=" .. settings[key] .. "\n")
	end

	io.close( file )

	file = nil
end

function FileUtil.initializeSettingsFileIfNotExists(self, fName, settings)
	print("initializeSettingsFileIfNotExists called: ", fName)
    local filePath = system.pathForFile( fName, system.DocumentsDirectory )
	local fileHandle = io.open( filePath, "r" )
	if (fileHandle) then
		print("initializeSettingsFileIfNotExists: File Exists")
		io.close(fileHandle)
	else
		print("initializeSettingsFileIfNotExists: Initializing Settings")
		FileUtil:writeSettingsFile(fName, settings)
	end

end

function FileUtil.loadAppFile(self, fName)
	--local fName = "myFile.txt"
	local path = system.pathForFile( fName, system.ResourceDirectory )

	local readCount = 0
	local fContents = ""
	local file = io.open( path, "r" )

	if file then 
		print ("FileUtil.loadFile: " .. fName .. " opened successfully")
		-- local savedData = file:read( "*a" )
		for line in file:lines() do
		    print( "FileUtil.loadFile read: " .. line )
		    readCount = readCount + 1
		    fContents = fContents .. line .. "\n"
		end
		-- print ("read '" .. savedData .. "' from " .. fName)
		io.close( file )
	else
		print ("FileUtils.loadFile: could not open file, " .. fName)
	end
	file = nil

	return fContents
end
 -- Initialize the FileUtil
FileUtil:new()
FileUtil:initialize()


return FileUtil