package com.xiaozhang.util;

import org.luaj.vm2.Globals;
import org.luaj.vm2.LuaValue;
import org.luaj.vm2.lib.jse.JsePlatform;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2022/12/13 14:53
 */
@Slf4j
public class LuaCallUtil {

    private static final String LUA_PATH = "/Users/xiaozhang/workspace/java/utils/lua/src/main/lua/oop/";

    public static void main(String[] args) throws Exception {
        String luaFileName = LUA_PATH + "hello.lua";
        Globals globals = JsePlatform.standardGlobals();
        globals.loadfile(luaFileName).call();
        LuaValue func = globals.get(LuaValue.valueOf("helloWithoutTranscoder"));
        String execValue = func.call().toString();
        log.info("execValue : {}", execValue);
    }

}
