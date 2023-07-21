-- Function to make the turtle move forward
local function forward()
    while not turtle.forward() do
        turtle.dig()
        --sleep(0.5)
    end
end

-- Function to make the turtle turn right
local function turnRight()
    turtle.turnRight()
end

-- Function to make the turtle turn left
local function turnLeft()
    turtle.turnLeft()
end

-- Function to make the turtle go up
local function up()
    while not turtle.up() do
        turtle.digUp()
        --sleep(0.5)
    end
end

-- Function to make the turtle go down
local function down()
    while not turtle.down() do
        turtle.digDown()
        --sleep(0.5)
    end
end

-- Function to make the turtle move to the next corner
-- local function moveToNextCorner()
--     forward()
--     turnRight()
--     forward()
--     turnLeft()
--     forward()
--     turnRight()
--     forward()
-- end

-- Get the argument from the user
local args = { ... }
local cubeWidth = tonumber(args[1])

if cubeWidth == nil or cubeWidth <= 0 then
    print("Invalid argument. Please provide a positive number.")
    return
end

-- Starting from the bottom corner, walk the outline of the cube
for i = 1, 4 do
    for j = 1, cubeWidth do
        forward()
    end
    turnRight()
end