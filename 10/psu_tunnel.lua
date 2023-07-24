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

 local function saveTurtleInfo(location, heading, script)
    local file = fs.open(saveFile, "w")
    local data = location .. "," .. heading .. "," .. script
    file.writeLine(data)
    file.close()
end

local function loadTurtleInfo()
    local file = fs.open(saveFile, "r")
    local data = split(file.readLine(),",")
    local location, heading, script = data[1], data[2], data[3]
    -- local location = data[1]
    -- local heading = data[2]
    -- local script = data[3]
    file.close()
    return location, heading, script
end

-- Unique Logic
f_alc = fs.open(saveFile, "w") --Filesystem alignment location control (VarName)
lastLocation, heading, lastScript = loadTurtleInfo()

local function writeALC()
    local data = location .. "," .. heading .. "," .. script
    file.writeLine(data)
end

local function resTurn(rot)
    if(rot == "clockwise")
        if(heading == "north")
            heading = "east"
        elseif(heading == "east")
            heading = "south"
        elseif(heading == "south")
            heading = "west"
        elseif(heading == "west")
            heading = "north"
        else
            error("Given heading not found!")
        end
    elseif(rot == "counterclockwise")
        if(heading == "north")
            heading = "west"
        elseif(heading == "west")
            heading = "south"
        elseif(heading == "south")
            heading = "east"
        elseif(heading == "east")
            heading = "north"
        else
            error("Given heading not found!")
        end
    else
        error("Rotation expected but not matched!")
    end
end

local function turnLeft()
    turtle.turnLeft()
    resTurn("counterclockwise")
    writeALC()
end

local function turnRight()
    turtle.turnRight()
    resTurn("clockwise")
    writeALC()
end

--=======================
--Turtle Movement Logic
--=======================

local function breakUp()
    while turtle.detectUp() do
        if turtle.digUp() then
            collect()
            sleep(0.5)
        else
            return false
        end
    end
    return true
end

local function breakF()
    while turtle.detect() do
        if turtle.dig() then
            collect()
            sleep(0.5)
        else
            return false
        end
    end
    return true
end

local function moveUp()
    refuel()
    while not turtle.up() do
        if turtle.detectUp() then
            if not tryDigUp() then
                return false
            end
        elseif turtle.attackUp() then
            collect()
        else
            sleep(0.5)
        end
    end
    return true
end

local function moveDown()
    refuel()
    while not turtle.down() do
        if turtle.detectDown() then
            if not tryDigDown() then
                return false
            end
        elseif turtle.attackDown() then
            collect()
        else
            sleep(0.5)
        end
    end
    return true
end

local function moveForward()
    refuel()
    while not turtle.forward() do
        if turtle.detect() then
            if not tryDig() then
                return false
            end
        elseif turtle.attack() then
            collect()
        else
            sleep(0.5)
        end
    end
    return true
end

--=====================--
--=====================--
--=====================--
--=====================--
--=====================--
-- Enter main program  --
--=====================--
--=====================--
--=====================--
--=====================--
--=====================--

for n = 1, length do
    turtle.placeDown()
    breakUp()
    turnLeft()
    breakF()
    moveUp()
    writeALC()
    breakF()
    turnRight()
    turnRight()
    breakF()
    moveDown()
    writeALC()
    breakF()
    turnLeft()

    if n < length then
        breakF()
        if not moveForward() then
            print("Aborting Tunnel.")
            break
        end
    else
        print("Tunnel complete.")
    end

end