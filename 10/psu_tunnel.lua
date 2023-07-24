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
    local location, heading, script, exeIndex = data[1], data[2], data[3], data[4]
    file.close()
    return location, heading, script, exeIndex
end

--==============================================
--==============================================
--==============================================
--==============================================
--==============================================
--Personally Unique Logic
--==============================================
--==============================================
--==============================================
--==============================================
--==============================================

f_alc = fs.open(saveFile, "w") --Filesystem alignment location control (VarName)
lastLocation, heading, lastScript, exeIndex = loadTurtleInfo()

local function writeALC()
    local data = location .. "," .. heading .. "," .. script .. "," .. exeIndex
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
--=======================
--=======================
--=======================
--=======================
--Script Restart Handler
--=======================
--=======================
--=======================
--=======================
--=======================

--Any script written with the concept of a restartable script must have ways to be restarted.

--=======================
--=======================
--=======================
--=======================
--=======================
--Turtle Movement Logic
--=======================
--=======================
--=======================
--=======================
--=======================

local function refuel()
    local fuelLevel = turtle.getFuelLevel()
    if fuelLevel == "unlimited" or fuelLevel > 0 then
        return
    end

    local function tryRefuel()
        for n = 1, 16 do
            if turtle.getItemCount(n) > 0 then
                turtle.select(n)
                if turtle.refuel(1) then
                    turtle.select(1)
                    return true
                end
            end
        end
        turtle.select(1)
        return false
    end

    if not tryRefuel() then
        print("Add more fuel to continue.")
        while not tryRefuel() do
            os.pullEvent("turtle_inventory")
        end
        print("Resuming Tunnel.")
    end
end

local function breakUp()
    while turtle.detectUp() do
        if turtle.digUp() then
            sleep(0.5)
        else
            return false
        end
    end
    return true
end

local function breakDown()
    while turtle.detectDown() do
        if turtle.digDown() then
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
            if not breakUp() then
                return false
            end
        elseif turtle.attackUp() then
            sleep(0.5)
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
            if not breakDown() then
                return false
            end
        elseif turtle.attackDown() then
            sleep(0.5)
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
            if not breakF() then
                return false
            end
        elseif turtle.attack() then
            sleep(0.5)
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

--Functions that would normally be the driver
local mainFuncTab = {      
    turtle.placeDown,
    breakUp,
    turnLeft,
    breakF,
    moveUp,
    breakF,
    turnRight,
    turnRight,
    breakF,
    moveDown,
    breakF,
    turnLeft
}

--Handle nils, files don't always have the required data
if (not exeIndex)
    exeIndex = 0
end

for n = 1, length do
    for i = exeIndex + 1, #mainFuncTab do
        mainFuncTab[i]()
        exeIndex = i
        writeALC()
    end

    if n < length then
        breakF()
        if not moveForward() then
            print("Aborting Tunnel.")
            break
        end
        writeALC()
    else
        print("Tunnel complete.")
    end

end