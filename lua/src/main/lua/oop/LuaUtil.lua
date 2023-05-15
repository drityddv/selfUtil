LuaUtil = {};

--打印table键值对
function LuaUtil.printHashTable(targetTable)
    for k, v in pairs(targetTable) do
        print(k, v)
    end
end
return LuaUtil
