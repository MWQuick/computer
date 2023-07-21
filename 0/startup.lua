local saveFile = "turtle_info.txt"  -- The name of the text file to save the turtle information
local autoRestart = false

fs = fs
shell = shell
gps = gps

local function split (inputstr, sep)
    if sep == nil then
       sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
       table.insert(t, str)
    end
    return t
 end
-- Function to save the turtle's location and script name to a text file
local function saveTurtleInfo(location, heading, script)
    local file = fs.open(saveFile, "w")
    local data = location .. "," .. heading .. "," .. script
    file.writeLine(data)
    file.close()
end

-- Function to load the turtle's last location and script name from the text file
local function loadTurtleInfo()
    local file = fs.open(saveFile, "r")
    local data = split(file.readLine(),",")
    local location = data[1]
    local heading = data[2]
    local script = data[3]
    file.close()
    return location, heading, script
end



-- Function to run a Lua script by its filename
local function runScript(scriptName)
    local path = shell.resolve(scriptName)
    print("Running script found at " .. path)
    if fs.exists(path) and not fs.isDir(path) then
        shell.run(path)
    end
end

-- Get the current script name
local scriptName = "Halt"--shell.getRunningProgram() --Dude, of course its going to be "startup.lua"

-- Get the turtle's last location and script name from the text file
local lastLocation, heading, lastScript = loadTurtleInfo()

-- If the last script name is different from the current script,
-- save the turtle's current location and the current script name to the text file
local currX, currY, currZ = gps.locate()
local currentLocation = nil
if(currX ~= nil and currY ~= nil and currZ ~= nil) then
    currentLocation = currX .. " " .. currY .. " " .. currZ
end
print("Current Location: " .. (currentLocation or "Unknown"))
if currentLocation then
    saveTurtleInfo(currentLocation, "north", scriptName)
end

-- Print the turtle's last location and script name
print("Last Location: " .. (lastLocation or "Unknown"))
print("Last Heading: " .. (heading or "Unknown"))
print("Last Script: " .. (lastScript or "Unknown"))

-- If the last script was different from the current script and it ended abnormally,
-- run the last script again
if lastScript ~= "Halt" and autoRestart then
    print("Running auto restart w/ " .. lastScript)
    runScript(lastScript)
end

