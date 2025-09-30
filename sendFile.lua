--Usage: sendFile("example.txt", targetID)
local fileName, targetID = ...
local targetID = tonumber(targetID)

if not fileName or not targetID then
    print("Usage: sendFile <fileName> <targetComputerID>")
    return
end

--Read file
if not fs.exists(fileName) then
    print("File does not exist: " .. fileName)
    return
end

local handle = fs.open(fileName, "r")
local data = handle.readAll()
handle.close()

--Wrap in a table and serialize
local packet = textutils.serialise({name=fileName, contents=data})

--Send via rednet.
rednet.send(targetID, packet)
print(fileName .. " sent to " .. targetID)
