package com.xiaozhang.test.proxy.jdk;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2022/7/3 20:34
 */

@Slf4j
public class JdkProxyDefine implements ProxyDefine {
    @Override
    public Object methodRunning(String stringParams) {
        log.info("this is define1 running");
        return this;
    }
}
