-- File: dance.lua

-- Function to perform dance steps
local function performDance()
    -- Add your dance steps here
    -- Replace this with the actual dance steps or shell.run command
    shell.run("dance.lua")
end

local function listenC2Signal()
    peripheral.find("modem", rednet.open) -- Open the wireless modem on the remote computer
    while true do
        local event, sender, message, protocol = os.pullEvent("rednet_message")
        if message == "stop_dance" then
            return
        end
    end
end

-- Function to handle stop event
local function dance_eventHandler()
    listenC2Signal()
    print("Stop event received. Stopping dance program...")
    -- Add any necessary cleanup or stop actions here
    error("Dance program stopped") -- Raise an error to exit the program
end

-- Register event handler for custom stop event
-- event.listen("custom_stop_event", handleStopEvent)
-- parallel.waitForAny(dance_eventHandler,performDance)
parallel.waitForAny(rednet.receive,performDance)
