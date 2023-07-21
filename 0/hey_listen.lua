-- local modem = peripheral.find("modem") or error("No modem attached", 0)
-- modem.open(0)

-- while true do
--     local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
--     print(("Message received on side %s on channel %d (reply to %d) from %f blocks away with message %s"):format(
--         side, channel, replyChannel, distance, tostring(message)
--     ))
-- end

peripheral.find("modem", rednet.open) -- Open the wireless modem on the remote computer
while true do
    local event, sender, message, protocol = os.pullEvent("rednet_message")
    if protocol ~= nil then
      print("Received message from " .. sender .. " with protocol " .. protocol .. " and message " .. tostring(message))
    else
      print("Received message from " .. sender .. " with message " .. tostring(message))
    end
end

-- local id, message = rednet.receive()
-- print(("Computer %d sent message %s"):format(id, message))