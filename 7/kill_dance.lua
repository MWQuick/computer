peripheral.find("modem", rednet.open) -- Open the wireless modem on the remote computer
rednet.broadcast("stop_dance") -- Send the stop signal to all connected devices
rednet.close() -- Close the wireless modem
