--Run shell and daemon parallel
--Receive daemon never ends, so when shell ends the whole thing should stop?

local function runShell()
    shell.run("shell")
end

local function receiveFile()
    print("File receiver daemon started, waiting for files...")
    
    while true do
        local senderID, packet = rednet.receive() --blocks until msg received
    
        --deserialize packet
        local fileData = textutils.unserialise(packet)
        if type(fileData) ~= "table" then
            print("Received invalid file from " .. senderID)
        else
            --Write to local fs
            local handle = fs.open(fileData.name, "w")
            handle.write(fileData.contents)
            handle.close()
            print(fileData.name .. " received from computer ID " .. senderID)
            end
    end
end

parallel.waitForAny(receiveFile, runShell)

os.shutdown()
