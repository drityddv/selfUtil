require("oop.LuaUtil")
Map = { settingId = 0, xLength = 0, yLength = 0 };

function Map:new (settingId, xLength, yLength)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.settingId = settingId;
    self.xLength = xLength;
    self.yLength = yLength;
    LuaUtil.printHashTable(self)
    return self;
end

map = Map:new(0, 1, 2)

