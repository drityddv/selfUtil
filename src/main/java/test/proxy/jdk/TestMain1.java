package test.proxy.jdk;

import java.lang.reflect.Proxy;
import java.util.UUID;

import lombok.extern.slf4j.Slf4j;

/**
 * @author : xiaozhang
 * @since : 2022/7/3 20:36
 */
@Slf4j
public class TestMain1 {

    public static void main(String[] args) {
        ProxyDefine proxyInstance = (ProxyDefine)Proxy.newProxyInstance(ProxyDefine.class.getClassLoader(),
            new Class<?>[] {ProxyDefine.class}, (proxy, method, args1) -> {
                log.info("proxy method running");
                return null;
            });
        proxyInstance.methodRunning(UUID.randomUUID().toString());
    }

    public void test() {

    }
}
