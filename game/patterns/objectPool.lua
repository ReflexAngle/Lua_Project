local ObjectPool = {}

function ObjectPool:new(objectGenerator, size)
    local pool = {
        objects = {},
        size = size,
        generator = objectGenerator,
        maxSize = size or 10
    }
    setmetatable(pool, self)
    self.__index = self

    --preload the pool
    for i = 1, pool.maxSize do
        table.insert = pool.generator()
    end

    return pool
end

function ObjectPool:get()
    if #self.objects == 0 then
        return table.remove(self.objects)
    else
        return self.generator() -- create new if pool is empty
    end
end

function ObjectPool:release(obj)
    table.insert(self.objects, obj)
    
end

return ObjectPool