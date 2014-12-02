local flower = flower
-- LuaSocket should come with zerobrane
local socket = require("socket")

NetworkFrameworkEntity = flower.class()

function NetworkFrameworkEntity:init(t)
    --self.MyIP = nil
    self.TheirIP = "192.168.1.21"
    self.port = 48310
    self.server, self.servError = socket.bind("*", self.port)
    if self.server then
        print("Network connection info:")
        print(self.server:getsockname())
        
        self.server:settimeout(15)
        self.client, self.servError = self.server:accept()
    else
        self.client, self.servError = socket.connect("localhost", self.port)
    end
        
    if self.client then
        self.client:settimeout(0)
    end
end

function NetworkFrameworkEntity:isConnected()
    if self.client then
        return true
    end
    
    return false, (self.servError or "Unknown error")
end

function NetworkFrameworkEntity:talker(text)
    if self:isConnected() then
        assert(self.client:send(text .. "\n"))
    end
end

function NetworkFrameworkEntity:listener()
    if self:isConnected() then
        local l, e = self.client:receive()
        return l
    end
end