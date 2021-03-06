Queue = flower.class()

local table = table

function Queue:init(t)
    if type(t) == "table" then
        self.queue = flower.deepCopy(t)
    else
        self.queue = {}
    end
end

function Queue:pop()
    table.remove(self.queue, 1)
end

function Queue:push(...)
    local vars = {...}
    for i=1, #vars do
        table.insert(self.queue, vars[i])
    end
end

function Queue:front()
    return self.queue[1]
end

function Queue:empty()
    return self:size() <= 0
end

function Queue:size()
    return #self.queue
end

function Queue:toString()
    local text = ""
    for i, d in ipairs(self.queue) do
        text = text .. d .. '\n'
    end
    
    return text
end