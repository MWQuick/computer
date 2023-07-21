-- File: dance_controller.lua

-- Load the wireless modem
rednet.open("right")

-- Function to send a stop signal to the dance program
local function sendStopSignal()
    rednet.broadcast("stop_dance")
end

-- Main program loop
while true do
    -- Listen for incoming messages
    local senderId, message = rednet.receive()

    -- Check if the message is a stop signal
    if message == "stop_dance" then
        print("Received stop signal. Stopping dance program...")
        os.queueEvent("custom_stop_event") -- Trigger custom event to stop dance program
        break -- Exit the loop and end the program
    end
end

-- Close the wireless modem
rednet.close()

